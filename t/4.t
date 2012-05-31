use strict;

use Test;
use vars qw($loaded $num1 $num2);

BEGIN { plan tests => 12 }
END   { print "not ok 1\n" unless $loaded }

# Check that it's possible to call rand() without srand()

use Math::Random::MT qw(srand rand irand);
ok($loaded = 1);

eval { $num1 = rand; };
ok($@, '', '$@ should be empty after rand() but it\'s: '.$@);
ok(defined($num1));
ok(0 <= $num1);
ok($num1 < 1); # rand without argument is like rand(1)
eval { $num2 = rand; };
ok($@, '', '$@ should also be empty the second time rand() is called');
ok($num1 != $num2);

eval { $num1 = irand; };
ok($@, '', '$@ should be empty after rand()');
ok(defined($num1));
ok(0 <= $num1);
eval { $num2 = irand; };
ok($@, '', '$@ should also be empty the second time rand() is called');
ok($num1 != $num2);
