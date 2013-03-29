use strict;
use warnings;
use Module::Build;

my $build = Module::Build->new(
    license        => 'perl',
    dynamic_config => 0,
    dist_abstract  => 'Redis client specialized for cache',

    build_requires     => {
        'Test::More'     => '0.98',
        'Test::Requires' => '0.06',
    },
    configure_requires => { 'Module::Build' => '0.38' },
    test_requires      => {
        'Test::RedisServer' => '0',
    },
    requires           => {
        perl         => '5.008001',
        'Redis'             => '0',
        'Data::MessagePack' => '0.36',
        # 'parent'     => 0,
    },

    no_index    => { 'directory' => [ 'inc' ] },
    name        => 'Cache/Redis',
    module_name => 'Cache::Redis',

    # script_files => [''],

    test_files           => (-d '.git' || $ENV{RELEASE_TESTING}) ? 't/ xt/' : 't/',
    recursive_test_files => 1,

    create_readme      => 1,
    create_license     => 1,
);
$build->create_build_script;
