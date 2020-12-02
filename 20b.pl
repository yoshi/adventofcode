#!perl

use List::Util qw(sum);
use List::MoreUtils qw(uniq);
use Math::Complex;

my @visits;

my $i = 0;

my $maxpresents = 0;

do {
	$i++;
	my @rawfacts;
	my @facts;

	@rawfacts = sort( uniq( &factors( $i ) ) );

	foreach $fact ( @rawfacts ) {
		if( ! defined( $visits[$fact] ) ) {
			$visits[$fact] = 0;
		}
		if( $visits[ $fact ] < 50 ) {
			$visits[ $fact ]++;
			push @facts, $fact;
		}
	}

	$presents = sum( @facts ) * 11;
	$maxpresents = $presents if( $presents > $maxpresents );
#	print qq($i $presents @facts\n);
} while( $maxpresents < 33100000 );

print qq(i: $i max: $maxpresents\n);

exit( 0 );

sub factors {
	my ($n)  = @_;
	my @f;

	for( my $i = 1; $i <= int( sqrt( $n ) ); $i++ ) {
		if( $n % $i == 0 ) {
			push @f, $i;
			push @f, $n / $i;
		}
	}

	return ( @f );
}
