#!perl -w

# Well hell.  every number that is not adjacent 

chomp( my @dat = <> );

# @dat is an array of strings that represents the entire file.

my $sum = 0;

# $i increments as we go down the map
my $map_depth = scalar( @dat );
my $map_width = length( $dat[0] );

my %gears;

# index all of the gears
# for( my $i = 0; $i < $map_depth; $i++ ) {
# 	for( my $j = 0; $j < $map_width; $j++ ) {
# 		my $c = substr( $dat[$i], $j, 1 );
# 		if( $c eq '*' ) {
# 			$gears{ "$i x $j" } = "";
# 		}
# 	}
# }

for( my $i = 0; $i < $map_depth; $i++ ) {
	# find a number.
	# scan around the number to find a symbol.
	# discard the number if it does not have a symbol nearby.

	# yay, i can find numbers now.
	# now look at the number halo to determine if it is a part number.
	# add the part number to the sum.
	
	my $in_number = 0;
	my $numstr = "";
	my $is_part_number = 0; # start with doubt
	my $is_gear_adj = 0; # start with doubt
	my $cur_gear;

	# $j increments as we go right
	for( my $j = 0; $j < $map_width; $j++ ) {
		my $c = substr( $dat[$i], $j, 1 );
		if( $c eq '*' ) {
			# print qq(gear at depth $i width $j\n);
		}

		if( $c =~ /[0-9]/ ) {
			$in_number = 1;
			$numstr .= $c;

			# look for symbol at 0,+1, +1,+1, +1,0, +1,-1, 0,-1, -1,-1, -1,0, -1,+1
			# $dat[$i][$j] is relative 0,0

			# 0,+1
			if( $j+1 < $map_width && &is_symbol( substr( $dat[$i], $j+1, 1 ) ) ) {
				$is_part_number = 1;
				if( &is_gear( substr( $dat[$i], $j+1, 1 ) ) ) {
					$is_gear_adj = 1;
					$cur_gear = $i . " x " . ($j + 1);
				}
			}
			# +1,+1
			if( $i+1 < $map_depth && $j+1 < $map_width && &is_symbol( substr( $dat[$i+1], $j+1, 1 ) ) ) {
				$is_part_number = 1;
				if( &is_gear( substr( $dat[$i+1], $j+1, 1 ) ) ) {
					$is_gear_adj = 1;
					$cur_gear = ($i + 1) . " x " . ($j + 1);
				}
			}
			# +1,0
			if( $i+1 < $map_depth && &is_symbol( substr( $dat[$i+1], $j, 1 ) ) ) {
				$is_part_number = 1; 
				if( &is_gear( substr( $dat[$i+1], $j, 1 ) ) ) {
					$is_gear_adj = 1;
					$cur_gear = ($i+1) . " x " . $j;
				}
			}

			# +1,-1
			if( $i+1 < $map_depth && $j-1 >= 0 && &is_symbol( substr( $dat[$i+1], $j-1, 1 ) ) ) {
				$is_part_number = 1;
				if( &is_gear( substr( $dat[$i+1], $j-1, 1 ) ) ) {
					$is_gear_adj = 1; 
					$cur_gear = ($i+1) . " x " . ($j-1);
				}
			}
			# 0,-1
			if( $j-1 >= 0 && &is_symbol( substr( $dat[$i], $j-1, 1 ) ) ) {
				$is_part_number = 1;
				if( &is_gear( substr( $dat[$i], $j-1, 1 ) ) ) {
					$is_gear_adj = 1;
					$cur_gear = $i . " x " . ($j-1);
				}
			}
			# -1,-1
			if( $i-1 >= 0 && $j-1 >= 0 && &is_symbol( substr( $dat[$i-1], $j-1, 1 ) ) ) {
				$is_part_number = 1;
				if( &is_gear( substr( $dat[$i-1], $j-1, 1 ) ) ) {
					$is_gear_adj = 1;
					$cur_gear = ($i-1) . " x " . ($j-1);
				}
			}
			# -1,0
			if( $i-1 >= 0 && &is_symbol( substr( $dat[$i-1], $j, 1 ) ) ) {
				$is_part_number = 1;
				if( &is_gear( substr( $dat[$i-1], $j, 1 ) ) ) {
					$is_gear_adj = 1;
					$cur_gear = ($i-1) . " x " . $j;
				}
			}
			# -1,+1
			if( $i-1 >= 0 && $j+1 < $map_width && &is_symbol( substr( $dat[$i-1], $j+1, 1 ) ) ) {
				$is_part_number = 1;
				if( &is_gear( substr( $dat[$i-1], $j+1, 1 ) ) ) {
					$is_gear_adj = 1;
					$cur_gear = ($i - 1) . " x " . ($j + 1);
				}
			}				
		} else {
			# this marks the end of a number in the middle of the string
			if( $in_number == 1 ) {
				# decide if we store this number

				push( @{$gears{ $cur_gear }}, $numstr ) if( $is_gear_adj );

				$sum += $numstr	if( $is_part_number );
				$numstr = "";
				$in_number = 0;
				$is_part_number = 0;
				$is_gear_adj = 0;
				$cur_gear = "";
			}
		}
	}

	# this marks the end of a number at the end of the string
	if( $in_number == 1 ) {
		# decide if we store this number
		push( @{$gears{ $cur_gear }}, $numstr ) if( $is_gear_adj );
		$sum += $numstr	if( $is_part_number );
		$numstr = "";
		$in_number = 0;
		$is_part_number = 0;
		$is_gear_adj = 0;
		$cur_gear = "";
	}
}

my $gear_ratio_sum = 0;

foreach my $gear_loc ( keys %gears ) {
	my $gear_ratio = 0;
	if( scalar( @{$gears{$gear_loc}} ) == 2 ) {
#		print qq($gear_loc: ) . @{$gears{$gear_loc}}[0] . qq( x ) . @{$gears{$gear_loc}}[1] . qq(\n);
		$gear_ratio = @{$gears{$gear_loc}}[0] * @{$gears{$gear_loc}}[1];
	}
	$gear_ratio_sum += $gear_ratio;
}

print qq(sum: $sum\n);
print qq(gear_ratio_sum: $gear_ratio_sum\n);

exit( 0 );

sub is_symbol {
	my( $char ) = @_;
	return( $char !~ /[0-9.]/ );
}

sub is_gear {
	my( $char ) = @_;
	return( $char eq '*' );
}
