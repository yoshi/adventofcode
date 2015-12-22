#!perl

use strict;
use warnings;

package main;

my %sue_prime;

$sue_prime{ "children" } = 3;
$sue_prime{ "cats" } = 7;
$sue_prime{ "samoyeds" } = 2;
$sue_prime{ "pomeranians" } = 3;
$sue_prime{ "akitas" } = 0;
$sue_prime{ "vizslas" } = 0;
$sue_prime{ "goldfish" } = 5;
$sue_prime{ "trees" } = 3;
$sue_prime{ "cars" } = 2;
$sue_prime{ "perfumes" } = 2;

my @sues;
my $sue_count = 1;

while( <> ) {
	chomp;

	# process Sues
	my %sue;

	s/^Sue \d+: //g;

	my @pairs = split( ', ' );

	foreach my $pair ( @pairs ) {
		my ( $key, $value ) = split( ': ', $pair );
		$sue{ $key } = $value;
	}

	push @sues, \%sue;

	if( is_like_prime( \%sue ) ) {
		print qq($sue_count comes close to prime\n);
	}

	if( adv_is_like_prime( \%sue ) ) {
		print qq($sue_count comes close to prime advancely\n);
	}

	$sue_count += 1;
}

exit( 0 );


sub is_like_prime {
	my( $sue ) = @_;
	my $is_like_prime = 1;

	foreach my $k ( keys %sue_prime ) {
		if ( defined( $sue->{$k} ) ) {
			if( $sue->{$k} == $sue_prime{ $k } && $is_like_prime == 1) {
				$is_like_prime = 1;
			} else {
				$is_like_prime = 0;
			}
		}
	}

	return $is_like_prime;
}

sub adv_is_like_prime {
	my( $sue ) = @_;
	my $is_like_prime = 1;

	foreach my $k ( keys %sue_prime ) {
		if ( defined( $sue->{$k} ) ) {
			if ( ( ( $k eq "cats" && $sue->{$k} > $sue_prime{ $k } ) ||
				   ( $k eq "trees" && $sue->{$k} > $sue_prime{ $k } ) ||
				   ( $k eq "pomeranians" && $sue->{$k} < $sue_prime{ $k } ) ||
				   ( $k eq "goldfish" && $sue->{$k} < $sue_prime{ $k } ) ||

				   ( $k eq "children" && $sue->{$k} == $sue_prime{ $k } ) ||
				   ( $k eq "samoyeds" && $sue->{$k} == $sue_prime{ $k } ) ||
				   ( $k eq "goldfish" && $sue->{$k} == $sue_prime{ $k } ) ||
				   ( $k eq "cars" && $sue->{$k} == $sue_prime{ $k } ) ||
				   ( $k eq "akitas" && $sue->{$k} == $sue_prime{ $k } ) ||
				   ( $k eq "vizslas" && $sue->{$k} == $sue_prime{ $k } ) ||
				   ( $k eq "perfumes" && $sue->{$k} == $sue_prime{ $k } ) ) &&
				 $is_like_prime == 1 ) {
				$is_like_prime = 1;
			} else {
				$is_like_prime = 0;
			}
		}
	}

	return $is_like_prime;
}
