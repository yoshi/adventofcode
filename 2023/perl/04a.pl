#!perl -w

chomp( my @dat = <> );

my $sum = 0;

for( my $i = 0; $i < scalar( @dat ); $i++ ) {
#	print $dat[$i] . "\n";
	my( $card, $win_str, $num_str ) = $dat[$i] =~ /Card\s+([0-9]+):\s+(.+)\s+\|\s+(.+)/;

	# print "card " .  $card . "\n";
	# print "win_str $win_str\n";
	# print "num_str $num_str\n";
	# print "win_str " . join( " ", sort{ $a <=> $b } split( /\s+/, $win_str ) ) . "\n";
	# print "num_str " . join( " ", sort{ $a <=> $b } split( /\s+/, $num_str ) ) . "\n";

	my %wins = map { $_ => 1 } sort{ $a <=> $b } split( /\s+/, $win_str );
	my @nums = sort{ $a <=> $b } split( /\s+/, $num_str );

	my $win_count = 0;
	foreach $num ( @nums ) {
#		print "testing: " . $num . " match: " . defined( $wins{$num} ) . "\n";
		$win_count++ if( defined( $wins{$num} ) );
	}
	if( $win_count > 0 ) {
		$sum += 2 ** ($win_count - 1);
#		print "card: $card win_count: $win_count val: " . (2 ** ($win_count - 1) ) . "\n";
	}
}

print qq(sum: $sum\n);

exit(0);
