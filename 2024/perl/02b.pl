#!perl -w

use strict;
use feature 'say';

my $safe_count = 0;

chomp( my @dat = <> );

foreach my $line ( @dat ) {
	my (@vals) = split(/\s+/, $line );

	if( &is_safe( @vals ) || &is_safe_tolerant( @vals ) ) {
		$safe_count++;
	}
}

print "safe_count: $safe_count\n";

exit( 0 );

sub is_safe {
	my (@samples) = @_;
	my $safe = 1;

	my $creasing = 0;

#	say "testing: " . join( " ", @samples);

	if ($samples[0] > $samples[1]) {
		$creasing = -1;
	} elsif ($samples[0] < $samples[1]) {
		$creasing = 1;
	}

	foreach my $i (1..$#samples) {
		if( $samples[$i-1] == $samples[$i] || abs($samples[$i-1] - $samples[$i]) > 3 ) {
			$safe = 0;
		} elsif( $creasing == -1 && $samples[$i-1] < $samples[$i] ) {
			$safe = 0;
		} elsif( $creasing == 1 && $samples[$i-1] > $samples[$i] ) {
			$safe = 0;
		}
		last if ! $safe;
	}

	return $safe;
}

sub is_safe_tolerant {
	my( @samples ) = @_;
	my $safe = 0;

	foreach my $i (0..$#samples) {
		my @sub_samples = @samples;
		splice( @sub_samples, $i, 1 );
		
#		say "retesting";

		if( &is_safe( @sub_samples ) ) {
			$safe = 1;
			last;
		}
	}

	return( $safe );
}
