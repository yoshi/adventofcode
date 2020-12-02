#!/usr/bin/perl -w

my( %claims );

my( %fabric );

my( $uh ) = 0;

while( <> ) {
	chomp;

	my $claim = $_;

	my( $id, $x, $y, $w, $h ) = ($claim =~ /#(\d+) @ (\d+),(\d+): (\d+)x(\d+)/);

	for( my $i = $x; $i < ($x + $w); $i++ ) {
		for( my $j = $y; $j < ($y + $h); $j++ ) {
			my $key = $i . "x" . $j;
			if( defined $fabric{$key} ) {
				$fabric{$key}++;
			} else {
				$fabric{$key} = 1;
			}
			#push @{$fabric{ $i . $j }}, $id;
			#push @{ $fabric[$i][$j] }, $id;
		}
	}
}


my( $overlaps ) = 0;

foreach my $k (keys %fabric) {
	if( $fabric{$k} > 1 ) {
		$overlaps++;
	}
}

print qq(overlaps: $overlaps\n);

