use strict;
use Test::More;
use Test::Number::Delta within => 1e-14;
BEGIN {
   use_ok('Math::Random::MT', qw(srand rand irand));
}


# Check that the results are the same with the function-call interface
# as with the OO interface

ok srand(5489);
delta_ok rand(), 0.814723691903055;
delta_ok rand(), 0.135477004107088;
delta_ok irand(), 3890346734;
delta_ok irand(), 3586334585;

done_testing();
