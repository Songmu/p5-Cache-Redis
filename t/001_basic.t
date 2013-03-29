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

subtest get_and_set => sub {
    ok !$cache->get('hoge');
    ok $cache->set('hoge',  'fuga');
    is $cache->get('hoge'), 'fuga';

    ok $cache->remove('hoge');
    ok !$cache->get('hoge');
};

subtest multi_byte => sub {
    ok !$cache->get('hoge');
    ok $cache->set('hoge',  'あ');
    is $cache->get('hoge'), 'あ';

    ok $cache->remove('hoge');
    ok !$cache->get('hoge');
};

done_testing;
