requires 'Redis';
requires 'perl', '5.008001';

recommends 'Data::MessagePack', '0.36';
recommends 'JSON::XS';

on build => sub {
    requires 'Test::More', '0.98';
    requires 'Test::RedisServer';
};
