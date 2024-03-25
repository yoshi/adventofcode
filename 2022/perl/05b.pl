#!perl -w

use strict;
use utf8;

chomp( my @dat = <> );

# read data in sections
my $section = 0;

# get the number of stacks
my $stack_count = (length( $dat[0] ) + 1) / 4;

my @stacks;

for( my $i = 0; $i < scalar( @dat ); $i++ ) {
	if( $dat[$i] eq "" ) {
		$section++;
		next;
	}

	if( $section == 0 ) {
		# create stacks
		#print qq($dat[$i]\n);
		my @row = split( //, $dat[$i] );
		for( my $j = 0; $j < $stack_count; $j++ ) {
			my $c = $j * 4 + 1;
			if( $row[$c] =~ /[A-Z]/ ) {
				#print qq($row[$c] into stack $j\n);
				unshift @{$stacks[$j]}, $row[$c];
			}
		}
	} else {
		# move crates

		# parse instruction
		my $row = $dat[$i];
		print qq(raw instruction: $row\n);
		$row =~ s/[a-z]//g;
		$row =~ s/^ *//g;
		$row =~ s/ +/ /g;
		my( $count, $from_stack, $to_stack ) = split( ' ', $row );
		print qq(parsed instruction: $count $from_stack $to_stack\n);

		# execute instruction
		my @tmp;
		for( my $j = 0; $j < $count; $j++ ) {
			push @tmp, pop @{$stacks[$from_stack - 1]};
		}
		for( my $j = 0; $j < $count; $j++ ) {
			push @{$stacks[$to_stack - 1]}, pop @tmp;
		}
	}
}

# present results
my $result;

for( my $i = 0; $i < scalar( @stacks ); $i++ ) {
	my $tmp;
	$tmp = pop( @{$stacks[$i]} );

	$result .= $tmp;
}

print qq(working with $stack_count stacks\n);

print qq(result: $result\n);

exit( 0 );
