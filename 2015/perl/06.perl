#!/usr/bin/perl -w

#
# Examples:
#
# turn on 0,0 through 999,999 would turn on (or leave on) every light.
#
# toggle 0,0 through 999,0 would toggle the first line of 1000 lights,
# turning off the ones that were on, and turning on the ones that were
# off.
#
# turn off 499,499 through 500,500 would turn off (or leave off) the
# middle four lights.
#

my @lights;
my @bright_lights;

my $width = 1000;
my $height = 1000;

# initialize lights to off
&off( 0, 0, $width - 1, $height - 1);


while( <> ) {
	print;
	chomp;

	my( $cmd, $x1, $y1, $x2, $y2 ) = &parse( $_ );

	if( $cmd eq "turn on" ) {
		&on( $x1, $y1, $x2, $y2 );
	}

	if( $cmd eq "turn off" ) {
		&off( $x1, $y1, $x2, $y2 );
	}

	if( $cmd eq "toggle" ) {
		&toggle( $x1, $y1, $x2, $y2 );
	}
}

print "light on count: " . &count . "\n";
print "bright lights count: " . &bright_count . "\n";

exit( 0 );

sub parse {
	my @tokens = split( " " );

	my ($cmd, $x1, $y1, $x2, $y2);
	my ($loc1, $loc2);

	if( $tokens[0] eq "toggle" ) {
		$cmd = "toggle";
		$loc1 = $tokens[1];
		$loc2 = $tokens[3];
	}
	if( $tokens[1] eq "on" ) {
		$cmd = "turn on";
		$loc1 = $tokens[2];
		$loc2 = $tokens[4];
	}
	if( $tokens[1] eq "off" ) {
		$cmd = "turn off";
		$loc1 = $tokens[2];
		$loc2 = $tokens[4];
	}

	($x1, $y1) = &parse_loc( $loc1 );
	($x2, $y2) = &parse_loc( $loc2 );

	return( $cmd, $x1, $y1, $x2, $y2 );
}

sub parse_loc {
	return split( ',', $_[0] );
}

sub off {
	my( $x1, $y1, $x2, $y2 ) = @_;

	# for every row flip every column
	for( my $cur_y = $y1; $cur_y <= $y2; $cur_y += 1 ) {
		for( my $offset = $x1 + $cur_y * $width; $offset <= $x2 + $cur_y * $width; $offset += 1 ) {
			my $cur_x = $offset - $cur_y * $width;
			#print "pos: $cur_x $cur_y offset: $offset\n";
			$lights[ $offset ] = 0;
			if( defined $bright_lights[ $offset ] && $bright_lights[ $offset ] > 0 ) {
				$bright_lights[ $offset ] -= 1;
			} else {
				$bright_lights[ $offset ] = 0;
			}
		}
	}
}

sub on {
	my( $x1, $y1, $x2, $y2 ) = @_;

	# for every row flip every column
	for( my $cur_y = $y1; $cur_y <= $y2; $cur_y += 1 ) {
		for( my $offset = $x1 + $cur_y * $width; $offset <= $x2 + $cur_y * $width; $offset += 1 ) {
			my $cur_x = $offset - $cur_y * $width;
			#print "pos: $cur_x $cur_y offset: $offset\n";
			$lights[ $offset ] = 1;
			$bright_lights[ $offset ] += 1;
		}
	}
}

sub toggle {
	my( $x1, $y1, $x2, $y2 ) = @_;

	# for every row flip every column
	for( my $cur_y = $y1; $cur_y <= $y2; $cur_y += 1 ) {
		for( my $offset = $x1 + $cur_y * $width; $offset <= $x2 + $cur_y * $width; $offset += 1 ) {
			my $cur_x = $offset - $cur_y * $width;
			#print "pos: $cur_x $cur_y offset: $offset\n";
			if( $lights[ $offset ] == 1 ) {
				$lights[ $offset ] = 0;
			} else {
				$lights[ $offset ] = 1;
			}
			$bright_lights[ $offset ] += 2;
		}
	}
}

sub count {
	my $on_count = 0;
	foreach $light (@lights) {
		if( $light == 1 ) {
			$on_count += 1;
		}
	}

	return $on_count;
}

sub bright_count {
	my $count = 0;
	foreach $bright_light (@bright_lights) {
		$count += $bright_light;
	}

	return $count;
}
