use strict;
use Test::More tests => 1;

BEGIN {
    use_ok 'Cache::Redis';
}

diag "Testing Cache::Redis/$Cache::Redis::VERSION";
