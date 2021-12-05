#!perl -w

use strict;
use Data::Dumper;

chomp( my @dat = <> );

my @lines;
my $maxx = 0;
my $maxy = 0;

foreach my $linestr (@dat) {
	my ($p1, $p2) = split( " -> ", $linestr );
	my( $x1, $y1) = split( ',', $p1 );
	my( $x2, $y2) = split( ',', $p2 );

	$maxx = $x1 if( $x1 > $maxx );
	$maxx = $x2 if( $x2 > $maxx );
	$maxy = $y1 if( $y1 > $maxy );
	$maxy = $y2 if( $y2 > $maxy );
	next if( ! (($x1 == $x2) || ($y1 == $y2) ));

	# fixup
	if( $x1 > $x2 ) {
		my $tmp;
		$tmp = $x1;
		$x1 = $x2;
		$x2 = $tmp;
	}
	if( $y1 > $y2 ) {
		my $tmp;
		$tmp = $y1;
		$y1 = $y2;
		$y2 = $tmp;
	}


	print qq(hmm: $x1 $y1 $x2 $y2\n);

	push( @lines, [$x1, $y1, $x2, $y2] );

}

print qq(we have ) . scalar(@lines) . qq( lines\n);
print qq(maxx $maxx maxy $maxy\n);
my @matrix;

for( my $i = 0; $i <= $maxy; $i++ ) {
	push( @matrix, [(0) x ($maxx + 1)] );
}

#print Dumper(\@matrix);

print qq(beginning\n);
#&print_matrix( \@matrix );

foreach my $line (@lines) {
	print Dumper($line);
	# for( my $x = $line->[0]; $x <= $line->[2]; $x++ ) {
	# 	for( my $y = $line->[1]; $y <= $line->[3]; $y++ ) {
	# 		print "painting $x $y\n";
	# 		$matrix[$y][$x]++;
	# 		&print_matrix( \@matrix );
	# 	}
	# }
	foreach my $x ($line->[0] .. $line->[2] ) {
		foreach my $y ($line->[1] .. $line->[3] ) {
			print "painting $x $y\n";
			$matrix[$y][$x]++
#	 		&print_matrix( \@matrix );
		}
	}

}

print qq(ending\n);
#&print_matrix( \@matrix );

my $score = &score_matrix( \@matrix );

print qq(score: $score\n);


exit( 0 );

sub print_matrix {
	my( $matrix )= @_;

	foreach my $t (@$matrix) {
		print join( "", @$t ) . qq(\n);
	}
}

sub score_matrix {
	my( $matrix )= @_;
	my( $score ) = 0;
	foreach my $t (@$matrix) {
		foreach my $v (@$t) {
			$score++ if $v > 1;
		}
	}
	return $score;
}
