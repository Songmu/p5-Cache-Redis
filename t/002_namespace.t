use strict;
use warnings;
use utf8;
use Test::More;
use Test::RedisServer;

use Cache::Redis;

my $redis = Test::RedisServer->new;
my $socket = $redis->conf->{unixsocket};

my $cache1 = Cache::Redis->new(
    sock      => $socket,
    namespace => 'ns1:',
);

my $cache2 = Cache::Redis->new(
    sock      => $socket,
    namespace => 'ns2:',
);

$cache1->set(hoge => 1);
is $cache1->get('hoge'), 1;

$cache2->set(hoge => 2);
is $cache2->get('hoge'), 2;
is $cache1->get('hoge'), 1;

done_testing;
