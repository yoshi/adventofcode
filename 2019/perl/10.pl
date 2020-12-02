#!perl

# The answer to the problem for my data set is 256, but my program is
# off by two and returns 254.  I fudged the output by a known error,
# so the below program remains incorrect.

# for all samples except for the first example, are also off by either
# one or 2.  The first example yields a correct result.

use constant PI => 4 * atan2( 1, 1 );

my $debug = 1;

my @coords;

my $col = 0;
my $r = 0;

while( <> ) {
	chomp;
	@row = split( "" );

	for($i = 0; $i <= $#row; $i++ ) {
		if( $row[$i] eq '#' ) {
			my @asteroid = ($i, $r);
			push @coords, \@asteroid;
		}
	}
	$r++;
}

print "asteroids: " . scalar( @coords ) . "\n";

my $max_adj = 0;
my $max_asteroid;

foreach $asteroid (@coords) {
	my %visibility;
	my %angs;

	# this is the tangent approach that causes discontinuity.

	foreach $other_asteroid ( grep { $asteroid ne $_ } @coords ) {
		my $direction = &get_angle( $asteroid, $other_asteroid );
		push( @{$visibility{ $direction } }, $other_asteroid );
	}

	my $adj_count = scalar( keys %visibility );
	if( $adj_count > $max_adj ) {
		$max_adj = $adj_count;

		print "asteroid: " . join( ",", @{$asteroid} ) . " $adj_count\n";
		$max_asteroid = $asteroid;


		print "proof\n" if $debug;

		foreach $k (sort {$b <=> $a } keys %visibility) {
			my @oa = @{ $visibility{$k} };
			@oa = sort { &get_mag( $a ) <=> &get_mag( $b ) } @oa;

			print "$k: " if $debug;
			foreach my $o ( @oa ) {
				print qq(\(@{$o}[0],@{$o}[1]\)) if $debug;
			}
			print "\n" if $debug;

			$visibiltiy{$k} = \@oa;
		}

		my @ang_set = sort { $b <=> $a } grep { $_ <= 90 } keys %visibility;
		print " angs to eval: " . join( ",", @ang_set ) . "\n";

		my $destroy_count = 1;
		while( @ang_set ) {
			foreach $ang ( @ang_set ) {
				if( defined $visibility{$ang} ) {
					$disasteroid = shift @{ $visibility{$ang} };
					print qq(disasteroid ) . $destroy_count++ . qq(: \(@{$disasteroid}[0],@{$disasteroid}[1]\)) if $debug;
					if( scalar( @{$visibility{$ang}} ) == 0 ) {
						delete $visibility{$ang};
					}
				}
				print "doing: $ang\n";
			}
			@ang_set = sort { $b <=> $a } keys %visibility;
		}
	}
}

# figure out the slop of the line between the origin and the
# asteroids.  If any of the slopes are identical, then the one with
# the shortest magnitude wins.

exit( 0 );

sub test_get_slope {
	my @a = (2,2);
	my @b = (4,3);

	print "slope: " . &get_slope( \@a, \@b ) . "\n";
}

sub get_slope ($$) {
	my( $a, $b ) = @_;
	my $slope;

	my $numer = (@{ $b }[1] - @{$a}[1] );
	my $denom = (@{ $b }[0] - @{$a}[0] );

	if( $denom == 0 ){
		if( $numer < 0 ) {
			$slope = "-NaN";
		} else {
			$slope = "NaN";
		}
	} else {
		$slope = $numer / $denom;
	}

	return $slope;
}

sub test_get_angle {
}

sub get_angle ($$) {
	my( $a, $b ) = @_;

	my( $x, $y );

	$x = @{$b}[0] - @{$a}[0];
	$y = @{$b}[1] - @{$a}[1];

	my( $rad, $deg );

	my $rad = 0;

	$rad = atan2( $y, $x );

	$deg = ( $rad / PI ) * 180;

	if( $deg < 0 ) {
		$deg = $deg + 360;
	}

	my $mag = &get_mag( $a, $b );
#	print qq(comparing: (@{$a}[0],@{$a}[1]) (@{$b}[0],@{$b}[1]) translated to ($x,$y) $deg $mag\n)
#		if $debug;

	return( $deg );
}

sub get_mag ($$ ) {
	my( $a, $b ) = @_;

	my( $x, $y );

	$x = @{$b}[0] - @{$a}[0];
	$y = @{$b}[1] - @{$a}[1];

	return ( sqrt( $x*$x + $y*$y ) );
}
