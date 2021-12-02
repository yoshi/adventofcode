#!perl -w

chomp( my @dat = <> );
my $inc = 0;
my $prev;

for( $i = 0; $i < scalar( @dat ) - 2; $i++ ) {
	my $cur = $dat[$i] + $dat[$i+1] + $dat[$i+2];
	if( defined $prev ) {
		if( $cur > $prev ) {
			$inc++;
		}
	}
	$prev = $cur;
}

print qq(inc: $inc\n);
