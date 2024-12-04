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

for( my $y = 0; $y < $width; $y++ ) {
	for( my $x = 0; $x < $height; $x++) {
		#print $matrix[$y][$x];
		if( $matrix[$y][$x] eq 'X' ) {
			# N
			$count++ if( $y - 3 >= 0
						 && $matrix[$y-1][$x] eq 'M'
						 && $matrix[$y-2][$x] eq 'A'
						 && $matrix[$y-3][$x] eq 'S');
			# NE
			$count++ if( $y - 3 >= 0 && $x + 3 < $width 
						 && $matrix[$y-1][$x+1] eq 'M'
						 && $matrix[$y-2][$x+2] eq 'A'
						 && $matrix[$y-3][$x+3] eq 'S');
			# E
			$count++ if( $x + 3 < $width 
						 && $matrix[$y][$x+1] eq 'M'
						 && $matrix[$y][$x+2] eq 'A'
						 && $matrix[$y][$x+3] eq 'S');
			# SE
			$count++ if( $y + 3 < $height && $x + 3 < $width
						 && $matrix[$y+1][$x+1] eq 'M'
						 && $matrix[$y+2][$x+2] eq 'A'
						 && $matrix[$y+3][$x+3] eq 'S');
			# S
			$count++ if( $y + 3 < $height
						 && $matrix[$y+1][$x] eq 'M'
						 && $matrix[$y+2][$x] eq 'A'
						 && $matrix[$y+3][$x] eq 'S');
			# SW
			$count++ if( $y + 3 < $height && $x - 3 >= 0
						 && $matrix[$y+1][$x-1] eq 'M'
						 && $matrix[$y+2][$x-2] eq 'A'
						 && $matrix[$y+3][$x-3] eq 'S');
			# W
			$count++ if( $x - 3 >= 0
						 && $matrix[$y][$x-1] eq 'M'
						 && $matrix[$y][$x-2] eq 'A'
						 && $matrix[$y][$x-3] eq 'S');
			# NW
			$count++ if( $y - 3 >= 0 && $x - 3 >= 0
						 && $matrix[$y-1][$x-1] eq 'M'
						 && $matrix[$y-2][$x-2] eq 'A'
						 && $matrix[$y-3][$x-3] eq 'S');
		}
	}
	#print "\n";
}

say "XMAS x $count";

exit( 0 );
