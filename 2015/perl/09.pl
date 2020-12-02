#!/usr/bin/perl -w

use Data::Dumper;
use List::Util qw(min max);

# Record all edges.
# Record all cities.
# Generate all paths.

my( %edges );
my( %cities );
my( %paths );

while( <> ) {
	chomp;
	my @tokens = split( ' ' );

	$cities{ $tokens[0] } = 1;
	$cities{ $tokens[2] } = 1;

	my $edge = join( '-', sort( $tokens[0], $tokens[2] ) );

	$edges{ $edge } = $tokens[4];
}

#print "cities\n" . Dumper( \%cities );
#print "edges\n" . Dumper( \%edges );

foreach $start_city ( keys %cities ) {
	my @city_list = grep{ $_ ne $start_city } keys %cities;

	#print "START starting from $start_city -> cities: " . Dumper( \@city_list );
	walk( [$start_city], \@city_list );
}

#print Dumper( \%paths );

print qq(minimum path: ) . min( values %paths ) . qq(\n);
print qq(maximum path: ) . max( values %paths ) . qq(\n);

exit( 0 );

sub walk {
	my( $breadcrumb, $next_cities ) = @_;

	if( scalar( @{ $next_cities } ) == 0 ) {
		if( scalar @{ $breadcrumb } == scalar keys %cities ) {
			record_path( $breadcrumb );
		}
	} else {
		foreach $next_city ( @{ $next_cities } ) {
			my @next_next_cities = grep{ $_ ne $next_city } @{ $next_cities };

			my $prev_city = @{ $breadcrumb }[$#$breadcrumb];
			my $edge_key = join( "-", sort( $next_city, $prev_city ) );

			if( defined $edges{ $edge_key } ) {
				my @next_breadcrumb = @{ $breadcrumb };
				push @next_breadcrumb, $next_city;
				walk( \@next_breadcrumb, \@next_next_cities );
			} else {
				print qq(you cant get to $next_city from $prev_city\n);
			}
		}
	}
}

sub record_path {
	my( $breadcrumb ) = @_;
	my $distance = 0;
	my $path_key = join( "-", @{ $breadcrumb } );

	for( $i = 1; $i < scalar( @{$breadcrumb}); $i += 1 ) {
		$distance += distance( @{$breadcrumb}[$i-1], @{$breadcrumb}[$i] );
	}

	$paths{ $path_key } = $distance;
}

sub distance {
	return $edges{ join( '-', sort @_ )}
}
