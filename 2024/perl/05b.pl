#!perl -w

use strict;
use feature 'say';

my $section = 0;
my %rules;

my $middles = 0;
my $reordered_middles = 0;

chomp( my @data = <> );

foreach my $line ( @data ) {
	if( $line eq "" ) {
		$section = 1;
		next;
	}
	if( $section == 0 ) {
		$rules{$line} = 1;
	} else {
		my @pages = split( ",", $line );
		if( &orderly( @pages ) ) {
			my $mid_index = $#pages / 2;
			$middles += $pages[$mid_index];
		} else {
			my @reordered_pages = &reorder_pages(@pages);
			my $mid_index = $#reordered_pages / 2;
			$reordered_middles += $reordered_pages[$mid_index];
		}
	}
}

say "sum of middles: " . $middles;
say "sum of reordered middles: " . $reordered_middles;

exit( 0 );

sub orderly {
	my @pages = @_;
	my $is_orderly = 1;

	for( my $i = 1; $i <= $#pages; $i++ ) {
		if( ! defined $rules{$pages[$i-1] . "|" . $pages[$i]} ) {
			$is_orderly = 0;
		}
	}

	return $is_orderly;
}

sub reorder_pages {
	my @pages = @_;
	my $did_swap = 0;

	for( my $i = 1; $i <= $#pages; $i++ ) {
		if( ! defined $rules{$pages[$i-1] . "|" . $pages[$i]} ){
			my $tmp = $pages[$i-1];
			$pages[$i-1] = $pages[$i];
			$pages[$i] = $tmp;
			$did_swap = 1;
		}
	}

	if( $did_swap ) {
		return &reorder_pages( @pages );
	} else {
		return @pages;
	}
}
	
# 97,13,75,29,47

# 97,75,47,29,13

# 29|13

# 47|13
# 47|29
# 47|53

# 75|13
# 75|29
# 75|47

# 97|13
# 97|29
# 97|47
# 97|75
