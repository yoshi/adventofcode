#!perl -w

# what the heck?  now i'm identifying games that are not possible due to over utilization.

chomp( my @dat = <> );

my $max_red = 12;
my $max_green = 13;
my $max_blue = 14;

my $power_sum = 0;

for( my $i = 0; $i < scalar( @dat ); $i++ ) {
    my( $game_id, $game_dat ) = $dat[$i] =~ /^Game (\d+): (.*)/;
    my @game_sets = split( '; ', $game_dat );

	my %die_min;

	# iterate over each set
    foreach $game_set( @game_sets ) {
		my @die_counts = split(", ", $game_set );

		# iterate over each color clump of the set
		foreach $die_count( @die_counts ) {
			my( $count, $color ) = split( " ", $die_count );

			$die_min{ $color } = $count if( !defined( $die_min{ $color } ) ||
													  $count > $die_min{ $color } );
		}
    }

	$power = $die_min{ "red" } * $die_min{ "blue" } * $die_min{ "green" };

	$power_sum += $power;
}

print qq(power_sum: $power_sum\n);
