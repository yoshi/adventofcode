#!perl -w

# Well hell.  every number that is not adjacent 

chomp( my @dat = <> );

# @dat is an array of strings that represents the entire file.

my $sum = 0;

# $i increments as we go down the map
my $map_depth = scalar( @dat );
my $map_width = length( $dat[0] );

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

	# $j increments as we go right
	for( my $j = 0; $j < $map_width; $j++ ) {
		my $c = substr( $dat[$i], $j, 1 );
		if( $c =~ /[0-9]/ ) {
			$in_number = 1;
			$numstr .= $c;

			# look for symbol at 0,+1, +1,+1, +1,0, +1,-1, 0,-1, -1,-1, -1,0, -1,+1
			# $dat[$i][$j] is relative 0,0

			$is_part_number = 1 if( $j+1 < $map_width && &is_symbol( substr( $dat[$i], $j+1, 1 ) ) ); # 0,+1
			$is_part_number = 1 if( $i+1 < $map_depth && $j+1 < $map_width && &is_symbol( substr( $dat[$i+1], $j+1, 1 ) ) ); # +1,+1
			$is_part_number = 1 if( $i+1 < $map_depth && &is_symbol( substr( $dat[$i+1], $j, 1 ) ) ); # +1,0
			$is_part_number = 1 if( $i+1 < $map_depth && $j-1 >= 0 && &is_symbol( substr( $dat[$i+1], $j-1, 1 ) ) ); # +1,-1
			$is_part_number = 1 if( $j-1 >= 0 && &is_symbol( substr( $dat[$i], $j-1, 1 ) ) ); # 0,-1
			$is_part_number = 1 if( $i-1 >= 0 && $j-1 >= 0 && &is_symbol( substr( $dat[$i-1], $j-1, 1 ) ) ); # -1,-1
			$is_part_number = 1 if( $i-1 >= 0 && &is_symbol( substr( $dat[$i-1], $j, 1 ) ) ); # -1,0
			$is_part_number = 1 if( $i-1 >= 0 && $j+1 < $map_width && &is_symbol( substr( $dat[$i-1], $j+1, 1 ) ) ); # -1,+1
		} else {
			# this marks the end of a number in the middle of the string
			if( $in_number == 1 ) {
				# decide if we store this number

				$sum += $numstr	if( $is_part_number );
				$numstr = "";
				$in_number = 0;
				$is_part_number = 0;
			}
		}
	}

	# this marks the end of a number at the end of the string
	if( $in_number == 1 ) {
		# decide if we store this number
		$sum += $numstr	if( $is_part_number );
		$numstr = "";
		$in_number = 0;
		$is_part_number = 0;
	}
}

print qq(sum: $sum\n);

exit( 0 );

sub is_symbol {
	my( $char ) = @_;
	return( $char !~ /[0-9.]/ );
}
