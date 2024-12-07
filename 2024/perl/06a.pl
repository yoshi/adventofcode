#!perl -w

use strict;
use feature 'say';

my @matrix;
my $width = 0;
my $height = 0;
my $count = 0;
my ( $x, $y );
my $direction = 'N'; # N, E, S, W

chomp( my @dat = <> );

$width = length( $dat[0] );

foreach my $line ( @dat ) {
	my @row = split(//, $line );
	my $loc;
#	say join('', @row);

	if( ($loc = index( $line, '^' ) ) != -1 ) {
		$x = $loc;
		$y = $height;
	}

	push( @matrix, [@row]);
	$height++;
}

#say "guard is at $x $y";
$matrix[$y][$x] = "X";

my $escaped = 0;

while( ! $escaped ) {
#	say "direction: $direction";
	if( $direction eq "N" ) {
		if( ($y-1) < 0 ) {
			$escaped = 1;
		} else {
			if( $matrix[$y-1][$x] eq "#" ) {
				$direction = "E";
			} else {
				$y -= 1;
				$matrix[$y][$x] = "X";
			}
		}
	} elsif( $direction eq "E" ) {
		if( ($x+1) >= $width ) {
			$escaped = 1;
		} else {
			if( $matrix[$y][$x+1] eq "#" ) {
				$direction = "S";
			} else {
				$x += 1;
				$matrix[$y][$x] = "X";
			}
		}
	} elsif( $direction eq "S" ) {
		if( ($y+1) >= $height ) {
			$escaped = 1;
		} else {
			if( $matrix[$y+1][$x] eq "#" ) {
				$direction = "W";
			} else {
				$y += 1;
				$matrix[$y][$x] = "X";
			}
		}
	} elsif( $direction eq "W" ) {
		if( ($x-1) < 0 ) {
			$escaped = 1;
		} else {
			if( $matrix[$y][$x-1] eq "#" ) {
				$direction = "N";
			} else {
				$x -= 1;
				$matrix[$y][$x] = "X";
			}
		}
	}
#	&print_map;
}

$count = &calc_path;

print "count: $count\n";

exit( 0 );

sub print_map {
	say "x $x y $y";
	for ( my $i = 0; $i < $height; $i++ ) {
		for( my $j = 0; $j < $width; $j++ ) {
			print $matrix[$i][$j];
		}
		print "\n";
	}
	print "\n";
}

sub calc_path {
	my $steps;
	for ( my $i = 0; $i < $height; $i++ ) {
		for( my $j = 0; $j < $width; $j++ ) {
			$steps++ if $matrix[$i][$j] eq "X";
		}
	}
	return $steps;
}
