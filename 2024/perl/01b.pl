#!perl -w

use strict;

chomp( my @dat = <> );

my $simscore = 0;
my @a;
my %b;

foreach my $line ( @dat ) {
	my ($a, $b) = split(/\s+/, $line );

	push( @a, $a );
	$b{$b}++;
}

@a = sort @a;

foreach my $i (0..$#a) {
	if( defined $b{$a[$i]} ) {
#		say $a[$i] . " " .  $b{$a[$i]};
		$simscore += $a[$i] * $b{$a[$i]};
	}
}

print "simscore: $simscore\n";

exit( 0 );
