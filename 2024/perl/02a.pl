#!perl -w

use strict;

my $safe_count = 0;

chomp( my @dat = <> );

foreach my $line ( @dat ) {
	my (@vals) = split(/\s+/, $line );

	my $creasing = 0;
	my $safe = 1;

	if ($vals[0] > $vals[1] ) {
		$creasing = -1;
	} else {
		$creasing = 1;
	}

	foreach my $i (1..$#vals) {
		if( $vals[$i-1] == $vals[$i] || abs($vals[$i-1] - $vals[$i]) > 3 ) {
			$safe = 0;
		}
		if( $creasing == -1 && $vals[$i-1] < $vals[$i] ) {
			$safe = 0;
		}
		if( $creasing == 1 && $vals[$i-1] > $vals[$i] ) {
			$safe = 0;
		}
		last if ! $safe;
	}
	if( $safe ) {
#		print join( " ", @vals) . "\n";
		$safe_count++;
	}
}

print "safe_count: $safe_count\n";

exit( 0 );
