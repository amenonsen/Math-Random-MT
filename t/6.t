use strict;

use Test;
use vars qw($loaded);

BEGIN { plan tests => 3 }
END   { print "not ok 1\n" unless $loaded }

# Check that we can use an array to seed the generator.

use Math::Random::MT;

my $gen;
ok($loaded = 1);
ok($gen = Math::Random::MT->new(1, 2, 3, 4));
ok(abs($gen->rand(1) - 0.67886575916782) < 1e-14);
