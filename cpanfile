requires 'perl', '5.008001';
requires 'Redis';
requires 'Module::Load';

recommends 'Redis::Fast';
recommends 'Data::MessagePack', '0.36';
recommends 'JSON::XS';

on configure => sub {
    requires 'CPAN::Meta';
    requires 'CPAN::Meta::Prereqs';
    requires 'Module::Build';
};

on test => sub {
    requires 'Test::More', '0.98';
    requires 'Test::Requires';
    requires 'Test::RedisServer';
}
