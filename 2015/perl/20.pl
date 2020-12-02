#!perl

use List::Util qw(sum);
use List::MoreUtils qw(uniq);
use Math::Complex;

my $i = 1;

my $maxpresents = 0;

do {
	$i++;
	$presents = sum( uniq( @{ &factors( $i ) } ) ) * 10;
#	print qq($i: $presents\n);
	$maxpresents = $presents if( $presents > $maxpresents );
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

	return ( \@f );
}
