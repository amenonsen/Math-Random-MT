use strict;

use Test;
use vars qw($loaded);

BEGIN { plan tests => 6 }
END   { print "not ok 1\n" unless $loaded }

# Test that the OO interface works

use Math::Random::MT;
ok($loaded = 1);
ok(my $gen = Math::Random::MT->new(5489));
ok(abs($gen->rand() - 0.814723691903055) < 1e-14);
ok(abs($gen->rand() - 0.135477004107088) < 1e-14);
ok($gen->irand() == 3890346734);
ok($gen->irand() == 3586334585);
