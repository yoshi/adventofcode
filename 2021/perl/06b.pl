#!perl -w

use strict;

chomp( my @dat = <> );

my %fishies;

foreach my $fish_gen ( split ",", $dat[0] ) {
	$fishies{$fish_gen}++;
}

for( my $n = 0; $n <= 8; $n++ ) {
	$fishies{$n} = 0 if( !defined $fishies{$n});
}

for( my $i = 1; $i <= 256; $i++ ) {
	my %gen = %fishies;

	for( my $fish_gen = 1; $fish_gen <= 8; $fish_gen++) {
		$gen{$fish_gen - 1} = $fishies{$fish_gen};
	}

	my $regen = $fishies{0};
	$gen{6} += $regen;
	$gen{8} = $regen;

	%fishies = %gen;
}

my $fish_count = 0;
foreach my $fish_gen (keys %fishies ) {
	$fish_count += $fishies{$fish_gen};
}

print qq(fishies: $fish_count\n);
