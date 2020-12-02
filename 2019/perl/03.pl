#!perl

my @wires;
my $wire_count = 0;
my %locs;

my @wire_one_steps;
my @wire_two_steps;

while(<>) {
	chomp;

	my @wire = split( ',' );

	$wires[$wire_count++] = \@wire;
}

for($i = 0; $i < $wire_count; $i++ ) {
#	print qq(wire $i: ) . join( ',', @{$wires[$i]} ) . qq(\n);

	my @point = (0,0);

	foreach $ins (@{$wires[$i]}) {
		my( $loc );
		my( $dir, $count );
		$dir = substr( $ins, 0, 1 );
		$count = substr( $ins, 1);

		if( $dir eq "R" ) {
			for( $r = 0; $r < $count; $r++ ) {
				$loc = ++$point[0] . "," . $point[1];
				$locs{ $loc } .= "$i";
				if( $i == 0 ){
					push @wire_one_steps, $loc;
				} else {
					push @wire_two_steps, $loc;
				}
			}
		} elsif( $dir eq "L" ) {
			for( $l = 1; $l <= $count; $l++ ) {
				$loc = --$point[0] . "," . $point[1];
				$locs{ $loc } .= "$i";
				if( $i == 0 ){
					push @wire_one_steps, $loc;
				} else {
					push @wire_two_steps, $loc;
				}
			}
		} elsif( $dir eq "U" ) {
			for( $u = 1; $u <= $count; $u++ ) {
				$loc = $point[0] . "," . ++$point[1];
				$locs{ $loc } .= "$i";
				if( $i == 0 ){
					push @wire_one_steps, $loc;
				} else {
					push @wire_two_steps, $loc;
				}
			}
		} elsif( $dir eq "D" ) {
			for( $d = 1; $d <= $count; $d++ ) {
				$loc = $point[0] . "," . --$point[1];
				$locs{ $loc } .= "$i";
				if( $i == 0 ){
					push @wire_one_steps, $loc;
				} else {
					push @wire_two_steps, $loc;
				}
			}
		}
	}
}

foreach my $loc (keys %locs) {
	my( $x, $y ) = split( ",", $loc );

	my( $total_steps ) = 0;

	if( $locs{$loc} eq "01" ) {
		for($i = 0; $i <= $#wire_one_steps; $i++ ) {
			if( $wire_one_steps[$i] eq $loc ) {
				$total_steps = $i + 1;
			}
		}
		for($i = 0; $i <= $#wire_two_steps; $i++ ) {
			if( $wire_two_steps[$i] eq $loc ) {
				$total_steps += $i + 1;
			}
		}

		print "$loc " . $locs{$loc} . " " . &manhattan_distance( 0, 0, $x, $y) . " $total_steps\n";
	}
}

exit( 0 );

sub manhattan_distance {
	my( $x1, $y1, $x2, $y2 ) = @_;

	my $md;

	$md = abs( $x1 - $x2 ) + abs( $y1 - $y2 );

	return $md;
}
