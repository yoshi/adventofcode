#!perl -w

chomp( my @dat = <> );
my $inc = 0;
my $prev;

my $priority_sum = 0;

for( my $i = 0; $i < scalar( @dat ); $i += 3 ) {
	# split string down the middle
	my %one = map { $_ => 1 } split( '', $dat[$i] );
	my %two = map { $_ => 1 } split( '', $dat[$i + 1] );
	my %three = map { $_ => 1 } split( '', $dat[$i + 2] );

	# find item that is in both strings
	foreach $c ( keys %one ) {
		if( defined( $two{ $c } ) && defined( $three{ $c } ) ) {
			#print qq(found the dup: $c\n);
			my $cval = ord($c);
			my $badge = $cval > 96 ? $cval - 96 : $cval - 38;
			#print qq($c ($priority): ) . ord($c) . qq(\n);
			$badge_sum += $badge;
		}
	}

	# add priority to sum
}
print qq(badge_sum: $badge_sum\n);
