#!perl -w

use strict;

chomp( my @dat = <> );

my @coords;
my $maxx = 0;
my $maxy = 0;

foreach my $linestr (@dat) {
	my ($p1, $p2) = split( " -> ", $linestr );
	my( $x1, $y1) = split( ',', $p1 );
	my( $x2, $y2) = split( ',', $p2 );

	$maxx = $x1 if( $x1 > $maxx );
	$maxx = $x2 if( $x2 > $maxx );
	$maxy = $y1 if( $y1 > $maxy );
	$maxy = $y2 if( $y2 > $maxy );
	#next if( ! (($x1 == $x2) || ($y1 == $y2) ));
	if( ($x1 == $x2) || ($y1 == $y2) ) {
		push( @coords, &line_coords( $x1, $y1, $x2, $y2 ) );
	} else {
		push( @coords, &diag_coords( $x1, $y1, $x2, $y2 ) );
	}
}

my @matrix;

for( my $i = 0; $i <= $maxy; $i++ ) {
	push( @matrix, [(0) x ($maxx + 1)] );
}

foreach my $line (@coords) {
	foreach my $coord (@$line) {
		$matrix[$coord->[1]][$coord->[0]]++;
	}
}

my $score = &score_matrix( \@matrix );

print qq(score: $score\n);

exit( 0 );

sub print_matrix {
	my( $matrix )= @_;

	foreach my $t (@$matrix) {
		print join( "", @$t ) . qq(\n);
	}
}

sub score_matrix {
	my( $matrix )= @_;
	my( $score ) = 0;
	foreach my $t (@$matrix) {
		foreach my $v (@$t) {
			$score++ if $v > 1;
		}
	}
	return $score;
}

sub diag_coords {
	my( $x1, $y1, $x2, $y2 ) = @_;
	my( $dis ) = abs($x2 - $x1);
	my( @coords );
	my $slope = 1;

	 if( $x1 > $x2 ) {
	 	my $tmpx = $x1;
	 	$x1 = $x2;
	 	$x2 = $tmpx;
	 	my $tmpy = $y1;
	 	$y1 = $y2;
	 	$y2 = $tmpy;
	}

	$slope = -1 if( $y2 < $y1 );

	
	if( $slope == 1 ) {
		for( my $i = 0; $i <= $dis; $i++ ) {
			my( $uhx, $uhy );
			$uhx = $x1 + $i;
			$uhy = $y1 + $i;
			push( @coords, [$uhx, $uhy] );
		}
	} else {
		for( my $i = 0; $i <= $dis; $i++ ) {
			my( $uhx, $uhy );
			$uhx = $x1 + $i;
			$uhy = $y1 - $i;
			push( @coords, [$uhx, $uhy] );
		}
	}
	return \@coords;
}

sub line_coords {
	my( $x1, $y1, $x2, $y2 ) = @_;
	my @coords;
	my $dis = 0;

	if( $x1 != $x2 ) {
		if( $x1 < $x2 ) {
			$dis = $x2 - $x1;
			for( my $i = $x1; $i <= $x1 + $dis; $i++ ) {
				push( @coords, [$i, $y1] );
			}
		} else {
			$dis = $x1 - $x2;
			for( my $i = $x2; $i <= $x2 + $dis; $i++ ) {
				push( @coords, [$i, $y1] );
			}
		}
	} else {
		if( $y1 < $y2 ) {
			$dis = $y2 - $y1;
			for( my $i = $y1; $i <= $y1 + $dis; $i++ ) {
				push( @coords, [$x1, $i] );
			}
		} else {
			$dis = $y1 - $y2;
			for( my $i = $y2; $i <= $y2 + $dis; $i++ ) {
				push( @coords, [$x1, $i] );
			}
		}
	}
	return \@coords;
}
