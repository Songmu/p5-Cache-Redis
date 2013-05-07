# NAME

Cache::Redis - Redis client specialized for cache

# SYNOPSIS

    use Cache::Redis;

    my $cache = Cache::Redis->new(
        server    => 'localhost:9999',
        namespace => 'cache:',
    );
    $cache->set('key', 'val');
    my $val = $cache->get('key');
    $cache->remove('key');



# DESCRIPTION

This module is for cache of Redis backend having [Cache::Cache](http://search.cpan.org/perldoc?Cache::Cache) like interface.

__THIS IS A DEVELOPMENT RELEASE. API MAY CHANGE WITHOUT NOTICE__.

# INTERFACE

## Methods

### `my $obj = Cache::Redis->new(%options)`

Create a new cache object. Various options may be set in `%options`, which affect
the behaviour of the cache (defaults in parentheses):

- `default_expires_in (60*60*24 * 30)`

    The default expiration seconds for objects place in the cache.

- `namespace ('')`

    The namespace associated with this cache.

- `nowait (0)`

    If enabled, when you call a method that only returns its success status (like "set"), in a void context,
    it sends the request to the server and returns immediately, not waiting the reply. This avoids the
    round-trip latency at a cost of uncertain command outcome.

- `serializer ('Storable')`

    Serializer. 'MessagePack' and 'Storable' are usable. if \`serialize\_methods\` option
    is specified, this option is ignored.

- `serialize_methods (undef)`

    The value is a reference to an array holding two code references for serialization and
    deserialization routines respectively.

- server (undef)

    Redis server information. You can use \`sock\` option instead of this and can specify
    all other [Redis](http://search.cpan.org/perldoc?Redis) constructor options to `Cache::Cache->new` method.

### `$obj->set($key, $value, $expire)`

Set a stuff to cache.

### `my $stuff = $obj->get($key)`

Get a stuff from cache.

### `$obj->remove($key)`

Remove stuff of key from cache.

### `$obj->get_or_set($key, $code, $expire)`

Get a cache value for _$key_ if it's already cached. If it's not cached then,
run _$code_ and cache _$expiration_ seconds and return the value.

### `$obj->nowait_push`

Wait all response from redis. This is intended for `$obj->nowait`.

# DEPENDENCIES

Perl 5.8.1 or later.

# BUGS

All complex software has bugs lurking in it, and this module is no
exception. If you find a bug please either email me, or add the bug
to cpan-RT.

# SEE ALSO

[perl](http://search.cpan.org/perldoc?perl)

# AUTHOR

Masayuki Matsuki <y.songmu@gmail.com>

# LICENSE AND COPYRIGHT

Copyright (c) 2013, Masayuki Matsuki. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
