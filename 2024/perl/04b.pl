#!perl -w

use strict;
use feature 'say';

my @matrix;
my $height = 0;
my $width = 0;
my $count = 0;

chomp( my @dat = <> );

$width = length( $dat[0] );

foreach my $line ( @dat ) {
	my @row = split(//, $line );
#	say join('', @row);

	push( @matrix, [@row]);
	$height++;
}

say "we are dealing with $width x $height";

for( my $y = 1; $y < $width-1; $y++ ) {
	for( my $x = 1; $x < $height-1; $x++) {
		#print $matrix[$y][$x];
		if( $matrix[$y][$x] eq 'A' ) {
			#say "A $x $y";
			$count++ if( ( $matrix[$y-1][$x-1] eq 'M' &&
						   $matrix[$y+1][$x+1] eq 'S' &&
						   $matrix[$y-1][$x+1] eq 'M' &&
						   $matrix[$y+1][$x-1] eq 'S' ) ||

						 ( $matrix[$y-1][$x-1] eq 'M' &&
						   $matrix[$y+1][$x+1] eq 'S' &&
						   $matrix[$y-1][$x+1] eq 'S' &&
						   $matrix[$y+1][$x-1] eq 'M' ) ||

						 ( $matrix[$y-1][$x-1] eq 'S' &&
						   $matrix[$y+1][$x+1] eq 'M' &&
						   $matrix[$y-1][$x+1] eq 'S' &&
						   $matrix[$y+1][$x-1] eq 'M' ) ||

						 ( $matrix[$y-1][$x-1] eq 'S' &&
						   $matrix[$y+1][$x+1] eq 'M' &&
						   $matrix[$y-1][$x+1] eq 'M' &&
						   $matrix[$y+1][$x-1] eq 'S' ) );
		}
	}
	#print "\n";
}

say "XMAS x $count";

exit( 0 );
