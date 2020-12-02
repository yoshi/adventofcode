#!perl -w

use Data::Dumper;
use List::Util qw(min max);

my( %edges );
my( %people );
my( %seating );

while( <> ) {
	chomp;

	my @tokens = split( ' ' );

	$people{ $tokens[0] } = 1;
	$tokens[10] =~ s/.$//g;
	$people{ $tokens[10] } = 1;

	#my $edge = join( '-', $tokens[0], $tokens[10] );
	my $edge = join( '-', $tokens[10], $tokens[0] );

	if( $tokens[2] eq "gain" ) {
		$edges{ $edge } = $tokens[3];
	} else {
		$edges{ $edge } = -$tokens[3];
	}
}

#print "people\n" . Dumper( \%people );
#print "edges\n" . Dumper( \%edges );

# seat all people
foreach $start_person ( keys %people ) {
	my @people_list = grep{ $_ ne $start_person } keys %people;

	seat( [$start_person], \@people_list );
}

#print "seating\n" . Dumper( \%seating );

print qq(max happiness seating: ) . max( values %seating ) . qq(\n);

# add myself and recompute

foreach $person ( keys %people ) {
	$edges{ join( '-', $person, "yoshi" ) } = 0;
	$edges{ join( '-', "yoshi", $person ) } = 0;
}

$people{ "yoshi" } = 1;

# re-seat all people
undef %seating;

foreach $start_person ( keys %people ) {
	my @people_list = grep{ $_ ne $start_person } keys %people;

	seat( [$start_person], \@people_list );
}

print qq(max happiness seating with me: ) . max( values %seating ) . qq(\n);

exit( 0 );

sub seat {
	my( $breadcrumb, $next_people ) = @_;

	if( scalar( @{ $next_people } ) == 0 ) {
		if( scalar @{ $breadcrumb } == scalar keys %people ) {
			push( @{ $breadcrumb }, $breadcrumb->[0] );
			record_seating( $breadcrumb );
		}
	} else {
		foreach $next_person ( @{ $next_people } ) {
			my @next_next_people = grep{ $_ ne $next_person } @{ $next_people };
			my @next_breadcrumb = @{ $breadcrumb };

			push @next_breadcrumb, $next_person;
			seat( \@next_breadcrumb, \@next_next_people );
		}
	}
}

sub record_seating {
	my( $breadcrumb ) = @_;
	my $happiness = 0;
	my $seating_key = join( "-", @{ $breadcrumb } );

	for( $i = 1; $i < scalar( @{$breadcrumb}); $i += 1 ) {
		$happiness += happiness( @{$breadcrumb}[$i-1], @{$breadcrumb}[$i] );
		$happiness += happiness( @{$breadcrumb}[$i], @{$breadcrumb}[$i-1] );
	}

	$seating{ $seating_key } = $happiness;
}

sub happiness {
	return $edges{ join( '-', @_ )}
}
