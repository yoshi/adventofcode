#!perl -w

use strict;
use feature 'say';

my @blocks;
#my $checksum = 0;
my @free_blocks;
my @alloc_blocks;
my @file_lengths;

chomp( my @dat = <> );

#&map_to_block_chart( $dat[0] );

&decode_map( $dat[0] );

#&defrag_blocks;
&defrag_files;

say &calc_checksum;

exit( 0 );

# Well, block to file, file to block
# file_id
# block_id
# $blocks is an array of file_id indexed by block_id
# do we need a free list?

sub map_to_block_chart {
	my( $map ) = @_; 
	my( $chart );
	my( $writing ) = 1;

	foreach my $f (split( //, $map) ) {
		if( $writing ) {
			# writing blocks
			$chart .= "*" x $f;
			$writing = 0;
		} else {
			# skipping blocks
			$chart .= "." x $f;
			$writing = 1;
		}
	}
	say $chart;
}

sub decode_map {
	my( $map ) = @_;

	my $file_id = 0;
	my $pos = 0;
	my $writing = 1;
	
	foreach my $b ( split( //, $map ) ) {
		if( $writing ) {
			$file_lengths[$file_id] = $b
			for( my $i = 0; $i < $b; $i++ ) {
#				say $pos . " contains " . $file_id;
				push @alloc_blocks, $pos;
				$blocks[$pos++] = $file_id;
			}
			$file_id++;
			$writing = 0;
		} else {
			for( my $i = 0; $i < $b; $i++ ) {
#				say $pos . " is free";
				push @free_blocks, $pos;
				$blocks[$pos++] = -1;
			}
			$writing = 1;
		}
	}
}

sub defrag_blocks {
#	&block_chart;
	# for( my $i = $#blocks; $i > 0; $i-- ) {
	# 	last if $#free_blocks == 0;
	# 	if( $blocks[$i] != -1 ) {
	# 		my $free_block_id = shift @free_blocks;
	# 		say "moving $i to $free_block_id";
	# 		$blocks[$free_block_id] = $blocks[$i];
	# 		$blocks[$i] = -1;
	# 		&block_chart;
	# 	}
	# }
	foreach my $free_block_id (@free_blocks) {
		if( $free_block_id < $alloc_blocks[$#alloc_blocks] ) {
			my $alloc_block_id = pop @alloc_blocks;
			my $file_id = $blocks[$alloc_block_id];
			$blocks[$free_block_id] = $file_id;
			$blocks[$alloc_block_id] = -1;
		} else {
			last;
		}
#		&block_chart;
	}
}

sub defrag_files {
	&block_chart;
	&block_chart;
}

sub block_chart {
	foreach my $b (@blocks) {
		if( $b != -1 ) {
			print "*";
		} else {
			print ".";
		}
	}
	print "\n";
}


sub calc_checksum {
	my $checksum = 0;
	
	for( my $i = 0; $i < $#blocks; $i++ ) {
		next if $blocks[$i] == -1;
		$checksum += $i * $blocks[$i];
	}

	return $checksum;
}
