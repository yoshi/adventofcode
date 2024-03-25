#!perl -w

chomp( my @dat = <> );

my $card_count = scalar( @dat );
my @card_tally;

for( my $k = 0; $k < $card_count; $k++ ) {
	$card_tally[$k] = 1;
}

for( my $i = 0; $i < scalar( @dat ); $i++ ) {
	my( $card, $win_str, $num_str ) = $dat[$i] =~ /Card\s+([0-9]+):\s+(.+)\s+\|\s+(.+)/;
	my %wins = map { $_ => 1 } sort{ $a <=> $b } split( /\s+/, $win_str );
	my @nums = sort{ $a <=> $b } split( /\s+/, $num_str );

	my $win_count = 0;
	foreach $num ( @nums ) {
		$win_count++ if( defined( $wins{$num} ) );
	}

	for( my $j = 1; $j <= $win_count; $j++ ) {
		$card_tally[$card + $j - 1] += 1 * $card_tally[ $card - 1];
	}
}

my $sum = 0;
for( my $l = 0; $l < $card_count; $l++ ) {
#	print "$l : $card_tally[$l]\n";
	$sum += $card_tally[$l];
}
print "sum: $sum\n";

exit(0);
