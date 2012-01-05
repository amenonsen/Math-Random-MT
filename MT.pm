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
    # Create a Math::Random::MT::Perl object
    my ($class, @seeds) = @_;
    my $self = Math::Random::MT::init();
    # Seed the random number generator
    $self->set_seed(@seeds);
    return $self;
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

sub set_seed
{
    # Set the seed. Generate one automatically if none was provided.
    my ($self, @seeds) = @_;
    @seeds > 1 ? $self->setup_array(@seeds) :
                 $self->init_seed($seeds[0]||_rand_seed());
    return 1;
}

sub srand
{
    # Seed the random number generator and return the seed.
    my (@seeds) = @_;
    $gen = Math::Random::MT->new(@seeds);
    return $gen->get_seed;
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

  ## Object-oriented interface:
  use Math::Random::MT;
  $gen = Math::Random::MT->new()        # or...
  $gen = Math::Random::MT->new($seed);  # or...
  $gen = Math::Random::MT->new(@seeds);
  $seed = $gen->get_seed();             # seed used to generate the random numbers
  $rand = $gen->rand(42);               # random number in the interval [0, 42)
  $dice = int($gen->rand(6)+1);         # random integer between 1 and 6
  $coin = $gen->rand() < 0.5 ?          # flip a coin
    "heads" : "tails"

  ## Function-oriented interface:
  use Math::Random::MT qw(srand rand);
  # now use srand() and rand() as you usually do in Perl

=head1 DESCRIPTION

The Mersenne Twister is a pseudorandom number generator developed by
Makoto Matsumoto and Takuji Nishimura. It is described in their paper at
<URL:http://www.math.keio.ac.jp/~nisimura/random/doc/mt.ps>. This algorithm
has a very uniform distribution and is good for modelling purposes but do not
use it for cryptography. 

This module implements two interfaces:

=head2 Object-oriented interface

=over

=item new()

Creates a new generator that is automatically seeded. The seed varies quickly
in time so you can run many automatically-seeded processes at once without
getting the same random numbers.

=item new($seed)

Creates a new generator seeded with an unsigned 32-bit integer.

=item new(@seeds)

Creates a new generator seeded with an array of (up to 624) unsigned
32-bit integers.

=item set_seed()

Seeds the generator. It takes the same arguments as I<new()>.

=item get_seed()

Retrieves the value of the seed used.

=item rand($num)

Behaves exactly like Perl's builtin rand(), returning a number uniformly
distributed in [0, $num) ($num defaults to 1).

=back

=head2 Function-oriented interface

=over

=item rand($num)

Behaves exactly like Perl's builtin rand(), returning a number uniformly
distributed in [0, $num) ($num defaults to 1).

=item srand($seed)

Behaves just like Perl's builtin srand(). As in Perl >= 5.14, the seed is
returned. If you use this interface, it is strongly recommended that you
call I<srand()> explicitly, rather than relying on I<rand()> to call it the
first time it is used.

=back

=head1 SEE ALSO

<URL:http://www.math.sci.hiroshima-u.ac.jp/~m-mat/MT/emt.html>

Math::TrulyRandom

Math::Random::MT::Perl

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
