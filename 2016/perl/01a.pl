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

foreach $ins ( @walk ) {
	my( $loc );
	my( $dir, $count );
	$dir = substr( $ins, 0, 1 );
	$count = substr( $ins, 1);

	if( $dir eq "R" ) {
		$heading = $rose_cw{$heading};
	} elsif( $dir eq "L" ) {
		$heading = $rose_ccw{$heading}
	}

	if( $heading eq 'N' ) {
		$point[1] += $count;
	} elsif( $heading eq 'S' ) {
		$point[1] -= $count;
	} elsif( $heading eq 'E' ) {
		$point[0] += $count;
	} elsif( $heading eq 'W' ) {
		$point[0] -= $count;
	}

	$loc = $point[0] . ',' . $point[1];
	if( defined( $locations{$loc} ) ){
		print "location revisited: " . $loc . " distance: " . &manhattan_distance( @origin, split( ',', $loc ) ) . "\n";
	}
	$locations{$loc}++;
}

print "distance: " . &manhattan_distance( @origin, @point );

exit( 0 );

sub manhattan_distance {
	my( $x1, $y1, $x2, $y2 ) = @_;

	my $md;

	$md = abs( $x1 - $x2 ) + abs( $y1 - $y2 );

	return $md;
}
