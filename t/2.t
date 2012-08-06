use strict;
use Test::More;
BEGIN {
   use_ok('Math::Random::MT', qw(srand rand irand));
}


# Check that the results are the same with the function-call interface
# as with the OO interface

ok srand(5489);
cmp_ok abs(rand() - 0.814723691903055), '<', 1e-14;
cmp_ok abs(rand() - 0.135477004107088), '<', 1e-14;
cmp_ok irand(), '==', 3890346734;
cmp_ok irand(), '==', 3586334585;

done_testing();
