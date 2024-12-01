#!perl -w

use strict;

chomp( my @dat = <> );

my $diffsum = 0;
my @a;
my @b;

foreach my $line ( @dat ) {
	my ($a, $b) = split(/\s+/, $line );

	push( @a, $a );
	push( @b, $b );
}

@a = sort @a;
@b = sort @b;

foreach my $i (0..$#a) {
	print $a[$i] . " " .  $b[$i] . "\n";
	$diffsum += abs($a[$i] - $b[$i]);
}

print "diffsum: $diffsum\n";

exit( 0 );
