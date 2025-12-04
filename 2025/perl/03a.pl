#!perl

use strict;
use warnings;
use List::Util qw(uniq);

chomp( my @dat = <> );

my $result = 0;

foreach my $line ( @dat ) {
	my( @digits ) = split( //, $line);

	my $joltage = 0;

	my( @ordered ) = uniq( sort {$b <=> $a} @digits );

#	print qq(\ntesting: $line\n);
#	print join(" ", @digits) . qq(\n);
#	print join(" ", @ordered) . qq(\n);

	for( my $i = 0; $i < scalar( @ordered ) - 1; $i++ ) {
		my $first = $ordered[$i];
		my $first_index = index( $line, $first );
#		print qq(\ni: $i first: $first @ $first_index\n);

		my $lower_bound = $first_index . "0";

		if( $joltage > $lower_bound ) {
#			print qq(joltage $joltage > lower_bound $lower_bound\n);
			last;
		}

		for( my $j = 0; $j < scalar( @ordered ) - 1; $j++ ) {
			my $next = $ordered[$j];
			my $next_index = index( $line, $next, $first_index + 1 );
#			print qq(j: $j next: $next @ $next_index\n);
			if( $next_index != -1 ) {
				my $test_joltage = $digits[$first_index] . $digits[$next_index];

#				print qq(test: $test_joltage\n);
				if( $joltage < $test_joltage ) {
					$joltage = $test_joltage;
				}
			}
		}
	}
	$result += $joltage;
#	print qq(joltage: $joltage\n);
}

print qq(result: $result\n);

exit( 0 );
