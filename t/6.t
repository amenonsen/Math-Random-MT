use strict;
use Test::More;
BEGIN {
   use_ok('Math::Random::MT');
}


# Check that we can use an array to seed the generator.

my $gen;

ok $gen = Math::Random::MT->new(1, 2, 3, 4);
cmp_ok abs($gen->rand(1) - 0.67886575916782), '<', 1e-14;
is $gen->irand, 1022996879;

done_testing();
