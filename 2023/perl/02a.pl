#!perl -w

# what the heck?  now i'm identifying games that are not possible due to over utilization.

chomp( my @dat = <> );

my $max_red = 12;
my $max_green = 13;
my $max_blue = 14;

my $id_sum = 0;

for( my $i = 0; $i < scalar( @dat ); $i++ ) {
    my( $game_id, $game_dat ) = $dat[$i] =~ /^Game (\d+): (.*)/;
    my @game_sets = split( '; ', $game_dat );

	my $valid_game = 1;

	# iterate over each set
    foreach $game_set( @game_sets ) {
		my @die_counts = split(", ", $game_set );
		my %die_sum;

		# iterate over each color clump of the set
		foreach $die_count( @die_counts ) {
			my( $count, $color ) = split( " ", $die_count );
			$die_sum{ $color } += $count;
		}
		$valid_game = 0 if( (defined( $die_sum{ "red" } ) && $die_sum{ "red" } > $max_red ) ||
							(defined( $die_sum{ "blue" } ) && $die_sum{ "blue" } > $max_blue ) ||
							(defined( $die_sum{ "green" } ) && $die_sum{ "green" } > $max_green ) );
    }

	$id_sum += $game_id if( $valid_game );
}

print qq(id_sum: $id_sum\n);
