#!perl -w

use strict;
use feature 'say';
#use re 'debugcolor';

chomp( my @dat = <> );

say "sum of products: " . &dejumble( $dat[0] );

exit( 0 );

sub dejumble {
	my( $jumbled_program ) = @_;
	my $product = 0;
	my $toggle = 1;
	my @parts =
		($jumbled_program =~ /(do\(\))|(don\'t\(\))|(mul\(\d+,\d+\))/g);

	foreach my $part (@parts) {
		if( defined $part ) {
#			say $part;
			if( $part eq "do()" ) {
				$toggle = 1;
			} elsif( $part eq "don't()" ) {
				$toggle = 0;
			} else {
				if( $toggle ) {
					$part =~ /mul\((\d+),(\d+)\)/;
					$product += $1 * $2;
				}
			}
		}
	}

	return $product;
}
