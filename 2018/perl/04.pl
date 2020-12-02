#!/usr/bin/perl -w

use List::Util qw(min max);

my @logs;

while( <> ) {
	chomp;
	push @logs, $_;
}

my( $guard_id, $sleep_min );

my( %guard_min_count );
my( %min_guard_count );

my( %glog );

foreach my $log (sort @logs) {
	if( $log =~ /Guard/ ) {
		($guard_id) = ($log =~ /Guard #(\d+)/);
	} else {
		# this is a "wakes up" or "falls asleep" event.
		my ($event_month, $event_day, $event_min, $event) = ($log =~ /\[\d+-(\d+)-(\d+) \d+:(\d+)\] (\w+)/);
#		print qq($month, $day, $min, $event\n);

		if( $event eq "falls" ) {
			$sleep_min = $event_min;
		} else {
			my $wake_min = $event_min;
			my @mins;

			if( ! defined($guard_min_count{$guard_id})) {
				$guard_min_count{$guard_id} = 0;
			}
			for( my $i = 0; $i < 60; $i++ ) {
				if( ($i >= $sleep_min) && ($i < $wake_min) ){
					$guard_min_count{$guard_id} ++;
					push( @{$min_guard_count{$i}}, $guard_id);
					$mins[$i] = "#";
				} else {
					$mins[$i] = ".";
				}
			}
#			print qq($month-$day #$guard_id $sleep_min - $min\n);
			print qq($event_month-$event_day #) . sprintf( "%05d", $guard_id ) . " " . join( "",@mins) . qq(\n);

			push( @{ $glog{$guard_id} }, join( "", @mins ));
		}
	}
}

foreach my $k (sort keys %guard_min_count) {
	print $k . " " . $guard_min_count{$k} . "\n";
	my @mins = (0) x 60;
	my $m = 0;
	my %uh;

	foreach (@{$glog{$k}}) {
		my @gmins = split(//, $_);
		for( $i = 0; $i < 60; $i++) {
			if( $gmins[$i] eq "#" ) {
				$mins[$i]++;
			}
		}
		print join("", @gmins) . "\n";
#		print join("", @mins) . "\n";
	}

	for ($i = 0; $i < 60; $i++ ) {
		$uh{ $mins[$i] } = $i;
	}

	$m = $uh{ max @mins };

	print qq(guard $k is asleep at minute $m most often\n);
}


my $max_min = 0, $max_guard, $max_sleep = 0;

foreach my $k (sort keys %min_guard_count) {
	my %gs;

	foreach my $g (sort( @{$min_guard_count{$k}})){
		if( ! defined $gs{$g} ) {
			$gs{$g} = 1;
		} else {
			$gs{$g}++;
		}
	}

	foreach my $g (keys %gs) {
		if( $gs{$g} > $max_sleep ) {
			$max_sleep = $gs{$g};
			$max_min = $k;
			$max_guard = $g;
			print qq($max_min $max_sleep $max_guard\n);
		}
	}
}

print qq($max_min $max_sleep $max_guard\n);
