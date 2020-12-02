#!perl

my $debug = 0;

my %orbits;

while(<>) {
	chomp;
	my( $orbitee, $orbiter ) = split( '\)', $_ );
	$orbits{$orbiter} = $orbitee;
}

my $direct = 0;
my $indirect = 0;
my $orbit_count = 0;

foreach $k (keys %orbits) {
	print $k . ")" . $orbits{$k} . "\n" if $debug;

	my $ik = $k;

	while( defined( $orbits{$ik} ) ) {
		print $orbits{$ik} . ")" if $debug;

		$ik = $orbits{$ik};
		$orbit_count++;
	}
	print "\n" if $debug;
}
print "total orbits: $orbit_count\n";

if( defined( $orbits{"YOU"} ) && defined( $orbits{ "SAN" } ) ) {
	# construct path
	my @you_path = &get_path( "YOU" );
	print join( "\(", @you_path ) . "\n" if $debug;

	my @san_path = &get_path( "SAN" );
	print join( "\(", @san_path ) . "\n" if $debug;

	my @working_path = (@you_path, reverse @san_path );

	print join( "\(", @working_path ) . "\n" if $debug;

	my $dups = 0;
	do {
		$dups = 0;
		my @new_path;
		for( $i = 0; $i <= $#working_path; $i++ ) {
			if( defined $working_path[$i+1] &&
				$working_path[ $i ] eq $working_path[ $i+1] ) {
				$i++;
				$dups++;
			} else {
				push @new_path, $working_path[$i];
			}
		}
		print "new: " . join( "\(", @new_path ) . "\n" if $debug;
		@working_path = @new_path;
	} while( $dups );

	print "transfers: " . ($#working_path + 1) . "\n";
}

exit( 0 );

sub get_path {
	my( $ob ) = @_;
	my @path;

	my $ik = $ob;

	while( defined( $orbits{$ik} ) ) {
		push @path, $orbits{$ik};
		$ik = $orbits{$ik};
	}

	return @path;
}
