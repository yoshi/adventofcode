#!/usr/bin/perl -w

my( @claims );

my( %fabric );

while( <> ) {
	chomp;

	my $claim = $_;

	my( $id, $x, $y, $w, $h ) = ($claim =~ /#(\d+) @ (\d+),(\d+): (\d+)x(\d+)/);

	push @claims, $claim;

	print qq($claim\n);

	for( my $i = $x; $i < ($x + $w); $i++ ) {
		for( my $j = $y; $j < ($y + $h); $j++ ) {
			my $k = $i . "x" . $j;
			if( defined $fabric{$k} ) {
				$fabric{$k}++;
			} else {
				$fabric{$k} = 1;
			}
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

foreach my $claim ( @claims ) {
	my( $id, $x, $y, $w, $h ) = ($claim =~ /#(\d+) @ (\d+),(\d+): (\d+)x(\d+)/);

	my( $candidate ) = 1;

	for( my $i = $x; $i < ($x + $w); $i++ ) {
		for( my $j = $y; $j < ($y + $h); $j++ ) {
			my $k = $i . "x" . $j;
			if( $fabric{$k} > 1 ) {
				$candidate = 0;
			}
		}
	}
	if( $candidate == 1 ) {
		print qq($id is a candidate\n);
	}
}
