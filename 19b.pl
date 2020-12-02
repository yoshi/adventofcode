#!/usr/bin/perl -w

use locale;

# parse input

my $rule_mode = 1;
my @rules;
my %rules;
my %r;
my %rr;
my $molecule;

while( <> ) {
	chomp;

	if( /^$/ ) {
		$rule_mode = 0;
		next;
	} else {
		if( $rule_mode ) {
			my( $from, $to ) = split( / => /, $_ );
			$rr{$to} = $from;
#			push @rules, [$from, $to];
#			push @{ $rules{ $from }}, $to;
		} else {
			$molecule = $_;
		}
	}
}

#print "there are " . scalar( keys %rules ) . " rules\n";
#print "there are " . scalar( @rules ) . " rules\n";

print "there are " . scalar( keys( %rr ) ). " rules\n";

print join( "\n", sort { length $b <=> length $a } keys ( %rr ) );

print "0:" . $molecule . "\n";

my $i = 0;

while( $molecule ne "e" ) {
	foreach $k (sort {length $b <=> length $a } keys ( %rr ) ) {
		print qq(testing $k\n);
		if( $molecule =~ m/$k/ ) {
			$molecule =~ s/$k/$rr{$k}/;
			print qq(replaced $k with $rr{$k}\n);
			$i++;
			last;
		}
	}

	print $i . ":" . $molecule . "\n";
}

#my @branches;

#print join( ',', @{ $rules{'e'} } ) . "\n";

#push @branches, @{ $rules{'e'}};

#print join( ',', @branches ) . "\n";

exit( 0 );
