#!perl -w

chomp( my @dat = <> );
my $inc = 0;
my $prev;

for( $i = 0; $i < scalar( @dat ); $i++ ) {
	my $cur = $dat[$i];
	if( defined $prev ) {
		if( $cur > $prev ) {
			$inc++;
		}
	}
	$prev = $cur;
}

print qq(inc: $inc\n);
