#!perl -w

use strict;
use feature 'say';

my $middles = 0;

my @rule_strs;
my @update_strs;

chomp( my @data = <> );

# so, the first set of input is BEFORE|AFTER
# then, 

my $section = 0;

foreach my $line ( @data ) {
	if( $line eq "" ) {
		$section = 1;
		next;
	}
	if( $section == 0 ) {
		push @rule_strs, $line;
	} else {
		push @update_strs, $line;
	}
}

my %rules;
my %parent_rules;

say "rules";
foreach my $rule_str (@rule_strs) {
	my ($before, $after ) = split '\|', $rule_str;
	say "$before|$after";
	push @{$rules{$before}}, $after;
	push @{$parent_rules{$after}}, $before;
}

foreach my $k (sort keys %rules) {
	say $k . " before " . join ",", @{$rules{$k}};
}

foreach my $k (sort keys %parent_rules) {
	say $k . " after " . join ",", @{$parent_rules{$k}};
}

say "updates";
foreach my $update_str (@update_strs) {
	say $update_str;
	my @pages = split "," , $update_str;

	if( &orderly( @pages ) ) {
		my $index = $#pages / 2;
		$middles += $pages[$index];
	}
}


# if the order of pages is correct, take the middle page number and then add all of these together.

exit( 0 );

sub orderly {
	my @pages = @_;
	my $is_orderly = 0;



	# oh, if page num is needed, it must preceed it dep.

	# $pages[0], it must be before the other pages in the rules.

	# measure the first thing to make sure that there is not a dep.
	# $page[0] should not be in values %rules;
	# $page[1..$] should each resolve by their previous thing.
	if( grep( $pages[0], (values %rules) ) ) {
		say $pages[0] . " seems to be good as a beginning";
	} else {
		say $pages[0] . " seems to not be good as a beginning";
	}

	foreach my $page (@pages) {
		if( @{$rules{$page}} ) {
			say "$page: " . join( ", ", @{$rules{$page}});
		} else {
			say "$page";
		}
	}

	return $is_orderly;
}
