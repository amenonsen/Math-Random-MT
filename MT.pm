package Math::Random::MT;

use strict;
use Carp;
use DynaLoader;
use Time::HiRes qw(gettimeofday); # standard in Perl >= 5.8
use vars qw( @ISA $VERSION );

my $gen = undef;
@ISA = qw( DynaLoader );
$VERSION = '1.12';

bootstrap Math::Random::MT $VERSION;

sub new
{
    my ($class, @seeds) = @_;

    if ( scalar @seeds == 1 ) {
        return Math::Random::MT::setup( $seeds[0] );
    }
    else {
        return Math::Random::MT::setup_array( @seeds );
    }
}

sub rand
{
    my ($self, $N) = @_;
    if (ref $self) {
        return ($N || 1) * $self->genrand();
    }
    else {
        $N = $self;
        Math::Random::MT::srand() unless defined $gen;
        return ($N || 1) * $gen->genrand();
    }
}

# Don't rely on the default seed.
sub srand {
    $gen = new Math::Random::MT (shift || time);
    #return $$gen;
}

sub _rand_seed {
    # Create a random seed using Perl's builtin random number generator system
    my ($self) = @_;
    # 1/ Seed Perl's srand() with a temporary random seed that varies quickly
    # in time so that no two identical seeds are obtained if several seeds are
    # automatically generated in a short time interval
    my $tmp_seed = (gettimeofday)[1]; # time in microseconds
    CORE::srand($tmp_seed);
    # 2/ Generate the random seed to use using Perl's builtin rand() (unsigned
    # 32-bit integer)
    my $max = int(2**32-1); # Largest unsigned 32-bit integer
    my $rand_seed = int(CORE::rand($max+1)); # An integer between 0 and $max
    return $rand_seed;
}

sub import
{
    no strict 'refs';
    my $pkg = caller;

    foreach my $sym (@_) {
        if ($sym eq "srand" || $sym eq "rand") {
            *{"${pkg}::$sym"} = \&$sym;
        }
    }
}

1;

__END__

=head1 NAME

Math::Random::MT - The Mersenne Twister PRNG

=head1 SYNOPSIS

 use Math::Random::MT;

 $gen = Math::Random::MT->new($seed); # OR...
 $gen = Math::Random::MT->new(@seed);

 print $gen->rand(3);

 OR

 use Math::Random::MT qw(srand rand);

 # now srand and rand behave as usual.

=head1 DESCRIPTION

The Mersenne Twister is a pseudorandom number generator developed by
Makoto Matsumoto and Takuji Nishimura. It is described in their paper at
<URL:http://www.math.keio.ac.jp/~nisimura/random/doc/mt.ps>.

This module implements two interfaces, as described in the synopsis
above. It defines the following functions.

=head2 Functions

=over

=item new($seed)

Creates a new generator seeded with an unsigned 32-bit integer.

=item new(@seed)

Creates a new generator seeded with an array of (up to 624) unsigned
32-bit integers.

=item rand($num)

Behaves exactly like Perl's builtin rand(), returning a number uniformly
distributed in [0, $num) ($num defaults to 1).

=item srand($seed)

This is an alternative interface to the module's functionality. It
behaves just like Perl's builtin srand(). If you use this interface, it
is strongly recommended that you call I<srand()> explicitly, rather than
relying on I<rand()> to call it the first time it is used.

=back

=head1 SEE ALSO

<URL:http://www.math.sci.hiroshima-u.ac.jp/~m-mat/MT/emt.html>

Math::TrulyRandom

=head1 ACKNOWLEDGEMENTS

=over 4

=item Sean M. Burke

For giving me the idea to write this module.

=item Philip Newton

For several useful patches.

=back

=head1 AUTHOR

Abhijit Menon-Sen <ams@toroid.org>

Copyright 2001 Abhijit Menon-Sen. All rights reserved.

Based on the C implementation of MT19937
Copyright (C) 1997 - 2002, Makoto Matsumoto and Takuji Nishimura

This software is distributed under a (three-clause) BSD-style license.
See the LICENSE file in the distribution for details.
