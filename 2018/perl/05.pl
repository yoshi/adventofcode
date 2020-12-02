#!/usr/bin/perl -w

my $orig_polymer;

while(<>) {
	chomp;
	$orig_polymer = $_;
}

$polymer = &react( $orig_polymer );

print "orig units = " . length( $orig_polymer ) . "\n";
print "units = " . length( $polymer ) . "\n";

foreach $c ( 'a' .. 'z' ) {
	my $test_polymer = $orig_polymer;

	$test_polymer =~ s/$c//gi;

	$test_polymer = &react( $test_polymer );
	print "$c test units = " . length( $test_polymer ) . "\n";
}

exit( 0 );

sub react {
	my($p) = @_;

	my $prev;

	do {
		$prev = $p;
		$p = &react_iter( $p );
	} while( $prev ne $p );

	return $p;
}


sub react_iter {
	my($p) = @_;

	foreach $c ('a' .. 'z') {
		my $le = $c . uc($c);
		my $be = uc($c) . $c;

		$p =~ s/$le//g;
		$p =~ s/$be//g;
	}

	return $p;
}
