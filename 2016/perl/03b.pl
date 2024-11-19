#!perl -w

my $count = 0;

chomp( my @dat = <> );

for( my $i = 0; $i < scalar(@dat); $i = $i + 3) {
	my @l0 = split( " ", $dat[$i]);
	my @l1 = split( " ", $dat[$i+1]);
	my @l2 = split( " ", $dat[$i+2]);
	
	my @t0 = sort {$a <=> $b} ($l0[0], $l1[0], $l2[0]);
	my @t1 = sort {$a <=> $b} ($l0[1], $l1[1], $l2[1]);
	my @t2 = sort {$a <=> $b} ($l0[2], $l1[2], $l2[2]);

	$count++ if( $t0[0] + $t0[1] > $t0[2] );
	$count++ if( $t1[0] + $t1[1] > $t1[2] );
	$count++ if( $t2[0] + $t2[1] > $t2[2] );
}

print "count: $count\n";

exit( 0 );
