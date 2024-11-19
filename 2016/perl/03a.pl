#!perl -w

my $count = 0;

chomp( my @dat = <> );

foreach $sides ( @dat ) {
	my( $a, $b, $c ) = sort { $a <=> $b } split( " ", $sides );

	if( $a + $b > $c ) {
		$count++;
	}
}

print "count: $count\n";

exit( 0 );
