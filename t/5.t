use strict;
use Test::More;
BEGIN {
   use_ok('Math::Random::MT');
}


# OO interface
# Check that we can use an array to seed the generator.

my $gen;

ok $gen = Math::Random::MT->new(1, 2, 3, 4);
is sprintf('%.12f',$gen->rand(1)), 0.678865759168;
###cmp_ok abs($gen->rand(1) - 0.678865759168), '<', 1e-14;
cmp_ok $gen->irand, '==', 1022996879;

# high value seeds broke initial implementation of mt_setup_array()
ok $gen = Math::Random::MT->new(1, 2, 3, 2**31);
is sprintf('%.12f',$gen->rand(1)), 0.336814725539;
###cmp_ok abs($gen->rand(1) - 0.336814725539), '<', 1e-14;
cmp_ok $gen->irand, '==', 1615524784;

done_testing();
