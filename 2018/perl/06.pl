#!/usr/bin/perl -w

my @coords;

my $dim = 10;

my ($minx, $miny) = (1000) x 2;
my ($maxx, $maxy) = (0) x 2;

my( @grid );

# initialize grid
for( my $i = 0; $i < $dim; $i++) {
	for( my $j = 0; $j < $dim; $j++) {
		$grid[$i][$j] = 'O';
	}
}

# consume coordinates
while( <> ) {
	chomp;

	my ($x, $y) = $_ =~ /(\d+), (\d+)/;

	$minx = $x if( $x < $minx );
	$miny = $y if( $y < $miny );
	$maxx = $x if( $x > $maxx );
	$maxy = $y if( $y > $maxy );

	push @coords, join( "x", ($x,$y));
}

# plot coordinates
foreach my $c ( @coords ) {
	my( $cx, $cy ) = split( "x", $c );

	$grid[$cx, $cy) = x;
}


# iterate through grid
for( my $i = 0; $i < $dim; $i++) {
	for( my $j = 0; $j < $dim; $j++) {
		my $paint = 'x';
		my %dists;
		my $mindis = $dim;

		foreach $c (@coords) {
			my( $cx, $cy ) = split( "x", $c );
			my( $dis ) = &mdis( $i, $j, $cx, $cy );

			printf( "%dx%d c %dx%d distance: %d\n", $i, $j, $cx, $cy, $dis );



			if( $dis < $mindis ) {
				$dists{$dis} = 
				$mindis = $dis;
			}

			if( ! defined ( $dists{$dis} ) ) {
				$paint = '*';
				$dists{$dis} = $c;
			} else {

			}
		}
		$grid[$i][$j] = $paint;
	}
}

# output grid
print qq(boundaries: $minx, $miny, $maxx, $maxy\n);
for( my $i = 0; $i < $dim; $i++) {
	print sprintf("%4d", $i);
	for( my $j = 0; $j < $dim; $j++) {
		print $grid[$i][$j];
	}
	print "\n";
}

exit( 0 );

sub mdis {
	my( $x, $y, $cx, $cy ) = @_;

	return abs( $x - $cx ) + abs( $y - $cy );
}
