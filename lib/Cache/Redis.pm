package Cache::Redis;
use 5.008_001;
use strict;
use warnings;

our $VERSION = '0.01';
use Redis;

my $_mp;
sub _mp {
    $_mp ||= Data::MessagePack->new->utf8;
}
sub _mp_serialize {
    _mp->pack(@_);
}
sub _mp_deserialize {
    _mp->unpack(@_);
}

sub _mk_serialize {
    my $code = shift;

    return sub {
        my $data = shift;

        my $flags; # for future extention
        my $store_date = [$data, $flags];
        $code->($store_date);
    };
}

sub _mk_deserialize {
    my $code = shift;

    return sub {
        my $data = shift;

        my ($org, $flags) = @{$code->($data)};
        $org;
    };
}

sub new {
    my $class = shift;

    my $args = @_ == 1 ? $_[0] : {@_};
    my $default_expires_in = delete $args->{default_expires_in} || 60*60*24 * 30;
    my $namespace          = delete $args->{namespace}          || '';
    my $nowait             = delete $args->{nowait}             || 0;
    my $serializer         = delete $args->{serializer}         || 'MessagePack';

    my ($serialize, $deserialize, $redis);
    my $serialize_methods = delete $args->{serialize_methods};
    if ($serialize_methods) {
        $serialize   = _mk_serialize   $serialize_methods->[0];
        $deserialize = _mk_deserialize $serialize_methods->[1];
    }
    elsif ($serializer) {
        if ($serializer eq 'MessagePack') {
            require Data::MessagePack;
            $serialize   = \&_mp_serialize;
            $deserialize = \&_mp_deserialize;
        }
        elsif ($serializer eq 'Storable') {
            require Storable;
            $serialize   = _mk_serialize   \&Storable::nfreeze;
            $deserialize = _mk_deserialize \&Storable::thaw;
        }
    }
    $redis = Redis->new(
        encoding => undef,
        %$args
    );

    bless {
        default_expires_in => $default_expires_in,
        serialize          => $serialize,
        deserialize        => $deserialize,
        redis              => $redis,
        namespace          => $namespace,
        nowait             => $nowait,
    }, $class;
}

sub get {
    my ($self, $key) = @_;
    $key = $self->{namespace} . $key;

    my $data = $self->{redis}->get($key);

    defined $data ? $self->{deserialize}->($data) : $data;
}

sub set {
    my ($self, $key, $value, $expire) = @_;
    $key = $self->{namespace} . $key;
    $expire ||= $self->{default_expires_in};

    my $redis = $self->{redis};
    $redis->set($key, $self->{serialize}->($value), sub {});
    $redis->expire($key, $expire, sub {});

    $redis->wait_all_responses unless $self->{nowait};
}

sub get_or_set {
    my ($self, $key, $code, $expire) = @_;

    my $data = $self->get($key);
    unless (defined $data) {
        $data = $code->();
        $self->set($key, $data, $expire);
    }
    $data;
}

sub remove {
    my ($self, $key) = @_;

    $self->{redis}->del($key);
}

sub nowait_push {
    shift->{redis}->wait_all_responses;
}

1;
__END__

=head1 NAME

Cache::Redis - Perl extention to do something

=head1 VERSION

This document describes Cache::Redis version 0.01.

=head1 SYNOPSIS

    use Cache::Redis;

=head1 DESCRIPTION

# TODO

=head1 INTERFACE

=head2 Functions

=head3 C<< hello() >>

# TODO

=head1 DEPENDENCIES

Perl 5.8.1 or later.

=head1 BUGS

All complex software has bugs lurking in it, and this module is no
exception. If you find a bug please either email me, or add the bug
to cpan-RT.

=head1 SEE ALSO

L<perl>

=head1 AUTHOR

Masayuki Matsuki E<lt>y.songmu@gmail.comE<gt>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2013, Masayuki Matsuki. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
