#!perl -w
use strict;
use utf8;
use Test::More;

use Test::RedisServer;
use Cache::Redis;

my $redis = Test::RedisServer->new;
my $socket = $redis->conf->{unixsocket};

my $cache = new_ok 'Cache::Redis', [
    sock => $socket,
];

subtest serialize => sub {
    my $org = 'hoge';
    my $packed   = Cache::Redis::_serialize($org);
    my $unpacked = Cache::Redis::_deserialize($packed);
    is $unpacked, $org;
};

subtest basic => sub {
    ok !$cache->get('hoge');
    $cache->set('hoge',  'fuga');
    is $cache->get('hoge'), 'fuga';

    ok $cache->remove('hoge');
    ok !$cache->get('hoge');
};

subtest multi_byte => sub {
    ok !$cache->get('hoge');
    $cache->set('hoge',  'あ');
    is $cache->get('hoge'), 'あ';

    ok $cache->remove('hoge');
    ok !$cache->get('hoge');
};

subtest get_or_set => sub {
    my $key = 'kkk';

    ok !$cache->get($key);
    is $cache->get_or_set($key => sub {10}), 10;
    is $cache->get($key), 10;
};

done_testing;
