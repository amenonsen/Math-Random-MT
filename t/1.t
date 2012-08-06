use strict;
use Test::More;
use Test::Number::Delta within => 1e-14;
BEGIN {
   use_ok('Math::Random::MT');
}


# Test that the OO interface works

my $gen;

ok $gen = Math::Random::MT->new(5489);
isa_ok $gen, 'Math::Random::MT';
delta_ok $gen->rand(), 0.814723691903055;
delta_ok $gen->rand(), 0.135477004107088;
delta_ok $gen->irand(), 3890346734;
delta_ok $gen->irand(), 3586334585;

done_testing();
