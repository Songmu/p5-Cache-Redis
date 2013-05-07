requires 'Data::MessagePack', '0.36';
requires 'Redis';
requires 'perl', '5.008001';

on build => sub {
    requires 'Test::More', '0.98';
    requires 'Test::Requires', '0.06';
};
