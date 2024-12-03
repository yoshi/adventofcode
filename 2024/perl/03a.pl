#!perl -w

use strict;
use feature 'say';

chomp( my @dat = <> );

say "sum of products: " . &dejumble( $dat[0] );

exit( 0 );

sub dejumble {
	my( $jumbled_program ) = @_;
	my $product = 0;

	while( $jumbled_program =~ /mul\((\d+),(\d+)\)/g ) {
#		say "mul($1,$2)";
		$product += $1 * $2;
	}

	return $product;
}
