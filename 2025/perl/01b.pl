#!perl

use strict;
use warnings;

chomp( my @dat = <> );

my $from = 50;
my $zeros = 0;

foreach my $line ( @dat ) {
	my( $dir, $clicks ) = $line =~ /(\w)(\d+)/;
	my( $to ) = $from;

	# normalize clicks and count cycles
	$zeros += int( $clicks / 100 );
	$clicks = $clicks % 100;

	if( $dir eq "L" ) {
		$to -= $clicks;
	} else {
		$to += $clicks;
	}

	# normalize the to
	if( $to >= 100 ) {
		$zeros += int( $to / 100 );
		$to = $to % 100;
	} elsif( $to < 0 ) {
		$zeros ++ if( $from > 0 );
		$to += 100;
		$to = $to % 100;
	} elsif( $to == 0 ) {
		$zeros ++;
	}

#	print qq($line: from $from to $to zeros $zeros\n);
	$from = $to;
}

print qq(zeros: $zeros\n);

exit( 0 );
