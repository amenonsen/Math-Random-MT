use strict;
use Test::More;
BEGIN {
   use_ok('Math::Random::MT');
}


# OO interface
# Check that we can use an array to seed the generator.

use Math::Random::MT;

my $gen;
ok $gen = Math::Random::MT->new(1, 2, 3, 4);
is sprintf('%.12f',$gen->rand(1)), 0.678865759168;
is $gen->irand, 1022996879;

# high value seeds broke initial implementation of mt_setup_array()
ok $gen = Math::Random::MT->new(1, 2, 3, 2**31);
is sprintf('%.12f',$gen->rand(1)), 0.336814725539;
is $gen->irand, 1615524784;

done_testing();
