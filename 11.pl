#!/usr/bin/perl -w

my $input = 'cqjxjnds';

print qq(cur: $input\n);
my $next = get_next_pw( $input );
print qq(next: $next\n);
print qq(and the next: ) . &get_next_pw( $next ) . qq(\n);

exit( 0 );

# fin.

sub get_next_pw {
	my( $cur_pw ) = @_;
	my( $next_pw ) = $cur_pw;

	do {
		$next_pw = increment_string( $next_pw );
	} until( contains_straight( $next_pw ) &&
			 ! contains_mistaken( $next_pw ) &&
			 contains_pairs( $next_pw ) );

	return $next_pw;
}

sub contains_straight {
	my( $pw ) = @_;
	my( $contains_straight ) = 0;

	my @chars = split( //, $pw );

	for( $i = 0; $i < (length $pw ) - 2; $i +=1 ) {
		if( increment_string( $chars[$i] ) eq $chars[$i+1] &&
			increment_string( $chars[$i+1] ) eq $chars[$i+2] ) {
			$contains_straight = 1;
		}
	}

	return $contains_straight;
}

sub contains_mistaken {
	my( $pw ) = @_;
	my( $contains_mistaken ) = 0;

	if( $pw =~ /[iol]/ ) {
		$contains_mistaken = 1;
	}

	return $contains_mistaken;
}

sub contains_pairs {
	my( $pw ) = @_;
	my( $contains_pairs ) = 0;

	my @chars = split( //, $pw );
	my $pair_count = 0;

	for( $i = 0; $i < (length $pw) - 1; $i += 1 ) {
		if( $chars[$i] eq $chars[$i+1] ) {
			$pair_count += 1;
			$i += 1; # seek past current pair
		}
	}

	if( $pair_count >= 2 ) {
		$contains_pairs = 1;
	}

	return $contains_pairs;
}

sub increment_string {
	my( $str ) = @_;
	return ++$str;
}
