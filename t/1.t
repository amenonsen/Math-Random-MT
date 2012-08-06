use strict;
use Test::More;
BEGIN {
   use_ok('Math::Random::MT');
}


# Test that the OO interface works

my $gen;

ok $gen = Math::Random::MT->new(5489);
isa_ok $gen, 'Math::Random::MT';
cmp_ok abs($gen->rand() - 0.814723691903055), '<', 1e-14;
cmp_ok abs($gen->rand() - 0.135477004107088), '<', 1e-14;
cmp_ok $gen->irand(), '==', 3890346734;
cmp_ok $gen->irand(), '==', 3586334585;

done_testing();
