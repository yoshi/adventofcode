#!perl -w

my @walk;
my @rose = ('N', 'E', 'S', 'W');
my %rose_cw = ( 'N' => 'E',
				'E' => 'S',
				'S' => 'W',
				'W' => 'N' );
my %rose_ccw = ( 'N' => 'W',
				 'W' => 'S',
				 'S' => 'E',
				 'E' => 'N' );


my $heading = 'N';

my %locations;

while(<>) {
	chomp;

	@walk = split( ', ' );
}

my @origin = (0,0);
my @point = @origin;

$locations{"0,0"} = 1; # visit the origin.

$first_revisited = undef;

foreach $ins ( @walk ) {
	my( $loc );
	my( $dir, $count );
	$dir = substr( $ins, 0, 1 );
	$count = substr( $ins, 1);

	# print qq(ins: $ins\n);

	if( $dir eq "R" ) {
		$heading = $rose_cw{$heading};
	} elsif( $dir eq "L" ) {
		$heading = $rose_ccw{$heading}
	}

	for( my $i = 1; $i <= $count; $i++ ) {
		if( $heading eq 'N' ) {
			$point[1] += 1;
		} elsif( $heading eq 'S' ) {
			$point[1] -= 1;
		} elsif( $heading eq 'E' ) {
			$point[0] += 1;
		} elsif( $heading eq 'W' ) {
			$point[0] -= 1;
		}
		&visit( $point[0], $point[1] );
	}
}

if( defined( $first_revisited ) ) {
	print qq(first revisited: $first_revisited dist: ) .
		$location{$first_revisited} . qq(\n);
}else {
	print qq(no revisits on this trip\n);
}

print "manhattan distance: " . &manhattan_distance( @origin, @point ) . "\n";

exit( 0 );

sub manhattan_distance {
	my( $x1, $y1, $x2, $y2 ) = @_;
	my $md;

	$md = abs( $x1 - $x2 ) + abs( $y1 - $y2 );

	return $md;
}

sub visit {
	my( $x, $y ) = @_;
	my $locstr = "$x,$y";

	my $dist = &manhattan_distance( @origin, $x, $y );

	if( defined( $location{$locstr} ) ) {
		$first_revisited = $locstr if( !defined $first_revisited );
	} else {
		$location{$locstr} = $dist;
	}
}
