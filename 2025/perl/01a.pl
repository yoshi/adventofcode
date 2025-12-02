#!perl

use strict;
use warnings;

chomp( my @dat = <> );

my $dial_point = 50;
my $zeros = 0;

foreach my $line ( @dat ) {
	my( $direction, $rotate ) = $line =~ /(\w)(\d+)/;
#	print qq($dial_point: direction: $direction rotate: $rotate\n);

	if( $direction eq "L" ) {
		$dial_point -= $rotate;
		$dial_point += 100 if $dial_point < 0;
	} else {
		$dial_point += $rotate;
	}

	$dial_point = $dial_point % 100;

	if( $dial_point == 0 ) {
		$zeros += 1;
	}
}

print qq(zeros: $zeros\n);

exit( 0 );
