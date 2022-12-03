#!perl -w

chomp( my @dat = <> );
my $inc = 0;
my $prev;

my $priority_sum = 0;

for( my $i = 0; $i < scalar( @dat ); $i++ ) {
	# split string down the middle
	my $len = length( $dat[$i] );
	my %one = map { $_ => 1 } split( '', substr( $dat[$i], 0, $len / 2 ) );
	my %two = map { $_ => 1 } split( '', substr( $dat[$i], -1 * $len / 2 ) );

	# find item that is in both strings
	foreach $c ( keys %one ) {
		if( defined( $two{ $c } ) ) {
			#print qq(found the dup: $c\n);
			my $priority = ord( $c ) > 96 ? ord($c) - 96 : ord($c) - 38;
			#print qq($c ($priority): ) . ord($c) . qq(\n);
			$priority_sum += $priority;
		}
	}

	# add priority to sum
}
print qq(priority_sum: $priority_sum\n);
