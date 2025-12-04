#!perl

use strict;
use warnings;
use List::Util qw(uniq);

chomp( my @dat = <> );

my $result = 0;

foreach my $line ( @dat ) {
	my( @digits ) = split( //, $line);

	my $joltage = 0;

	my( @ordered ) = sort @digits;

	my( $slim_line ) = $line;

	print $slim_line . "\n";

	while( length( $slim_line ) > 12) {
		my $smol = shift @ordered;
		my $smol_index = index( $slim_line, $smol );

		print qq(removing $smol\n);

		substr( $slim_line, $smol_index, 1, "");
		print "slim: " . $slim_line . "\n";
	}
	$result += $joltage;
}

print qq(result: $result\n);

exit( 0 );
