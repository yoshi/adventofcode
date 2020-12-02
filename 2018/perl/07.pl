#!/usr/bin/perl -w

my $worker_count = 2;
my $cost_offset = 0;
my %step_cost;

my @schedule;
my @schedule_markers;

my %scheduled_nodes;

my %before;
my %after;

my( @starts, @ends );

# init step costs
my $v = 1;
foreach my $step ( 'A' .. 'Z' ) {
	$step_cost{$step} = $cost_offset + $v++;
}

# consume input
while( <> ) {
	chomp;

	my( $prev, $next ) = $_ =~ /Step (\w) .* step (\w) .*/;

	push( @{$before{ $next }}, $prev );
	push( @{$after{ $prev }}, $next );
}

# init schedule
for( my $i = 0; $i < $worker_count; $i++ ) {
	$schedule_markers[$i] = 0;
}

#ya, this init is terrible and doesn't work
# for( my $i = 0; $i < $worker_count; $i++ ) {
# 	my @w = ('.') x (26 + 26 * $cost_offset);

# 	push @{ $schedule[$i] }, @w;

# 	print "worker init: " . $i . ": " . join( "", @{$schedule[$i]} )  . "\n";
# 	$schedule_markers[$i] = 0;
# }

# starts are defined as nodes that exist in after but not in before.
foreach $node ( keys %after ) {
	if( ! defined $before{ $node } ) {
		push @starts, $node;
	}
}

# ends are defined as nodes that exist in before but not in after.
foreach $node (keys %before ) {
	if( ! defined $after{ $node } ) {
		push @ends, $node;
	}
}

# here are our beginning conditions
print "== starts " . join( ", ", @starts ) . " ends " . join( ", ", @ends ) . " ==\n";

# I guess iterate through starts until the starts look like the ends?

my @results;
my @node_queue = @starts;

while (scalar @node_queue > 0 ) {
	# sort starts and process the first one.
	@node_queue = sort @node_queue;

#	&schedule_simple( @node_queue );

	print join( "", @node_queue ) . "\n";
	my $curr_node = shift @node_queue;

	# record the result and also schedule out the job.
	push @results, $curr_node;

	# take the things that $curr points to and put them into starts
	# eliminate the $curr from list as well.

	if( defined $after{ $curr_node } ) {
		foreach $af ( @{$after{$curr_node}} ) {
			# only add a thing if the things before it have already been posted.
			my $add_it = 1;

			my %res = map{ $_ => 1 } @results;

			if( defined( $before{ $af } ) ) {
				my @befores = @{$before{ $af }};
				foreach $t ( @befores ) {
					if( ! defined( $res{$t} ) ) {
						$add_it = 0;
					}
				}
			}
			if( $add_it ) {
				push @node_queue, $af;
			}
		}
	}

	# dedup starts

	@node_queue = grep { $_ ne $curr_node } keys { map { $_ => 1 } @node_queue};
}

print "initial order: " . join( "", @results ) . "\n";

&wide();

&print_schedule();

exit(0);

# so what the hell.

sub print_schedule {
	for( my $worker_id = 0; $worker_id < $worker_count; $worker_id++ ) {
		print "worker: " . $worker_id . " marker: " . $schedule_markers[$worker_id] . " => ";
		for( my $i = 0; $i < $schedule_markers[$worker_id]; $i++ ) {
			if( defined $schedule[$worker_id][$i] ) {
				print $schedule[$worker_id][$i];
			} else {
				print ".";
			}
		}
		print "\n";
	}
}

# There is a request to schedule the processing of one or more nodes.
# There are one or more workers that can service these requests.
# Each worker can schedule work after a certain time marker.
# Schedule the work with the worker that has the lowest marker.

# this is the single worker version.
sub schedule_simple {
	my( @nodes ) = @_;

	print "schedule nodes: " . join( "", @nodes ) . "\n";

	foreach my $k ( @nodes ) {
		print "scheduling $k\n";

		$node_cost = $step_cost{$k};

		for( my $ix = $schedule_markers[0]; $ix < ($schedule_markers[0] + $node_cost); $ix++ ) {
			$schedule[0][$ix] = $k;
		}

		$schedule_markers[0] += $node_cost;
	}

	print "worker 0 status: " . $schedule_markers[0] . "\n";
}

# wide
sub wide {
	my( @nodes ) = sort @starts;
	my %processed_nodes;

	while( scalar @nodes > 0 ) {
		my @next_nodes;

		&schedule2( @nodes );
		&print_schedule();

		foreach $node (@nodes) {
			$processed_nodes{ $node } = 1;
			if( defined $after{$node} ) {
#				print "adding: " . join( "", @{$after{$node}}) . "\n";
				foreach $after_node (@{$after{$node}}) {
					my $befores_processed = 1;
					# add node if the precursors of it have already been processed
					# gatekeep $after_node
					foreach $before_node ( @{$before{$after_node}} ){
						if ( ! defined( $processed_nodes{$before_node} ) ) {
							$befores_processed = 0;
						}
					}

					if( $befores_processed ) {
						push @next_nodes, $after_node;
					}
				}
			} else {
#				print $node . " appears to be terminal\n";
			}
		}

		@nodes = sort keys { map { $_ => 1 } @next_nodes};
	}
}

# this is the multi-worker version.
sub schedule2 {
	my( @nodes ) = @_;
	my $max_marker = 0;

	print "scheduling on: " . join( "", @nodes ) . "\n";

	# schedule a node as soon as possible with a free worker.

	foreach $node ( @nodes ) {
		my $scheduled = 0;

		while( ! $scheduled ) {
			# find nearest non-busy worker by evaluating schedule_markers
			# default to the zero worker
			my $worker_id = 0;
			for( my $i = 0; $i < $worker_count; $i++ ) {
				if( $schedule_markers[$i] < $schedule_markers[$worker_id] ) {
					$worker_id = $i;
				}
			}
			print "worker_selected: $worker_id\n";

			# schedule node
			for( my $j = 0; $j < $step_cost{$node}; $j++ ) {
				$schedule[$worker_id][$schedule_markers[$worker_id] + $j] = $node;
			}
			# update schedule_marker for worker
			$schedule_markers[$worker_id] += $step_cost{$node};

			if( $schedule_markers[$worker_id] > $max_marker ) {
				$max_marker = $schedule_markers[$worker_id];
			}
			$scheduled = 1;
		}
	}
	# synchronize all schedule/worker markers
	for( my $worker_id = 0; $worker_id < $worker_count; $worker_id ++ ) {
		$schedule_markers[$worker_id] = $max_marker;
	}
}

sub schedule {
	my( @nodes ) = @_;
	my $max_marker = $schedule_marker;

	print "schedule nodes: " . join( "", @nodes ) . "\n";

	foreach my $k ( @nodes ) {
		if(! defined( $scheduled_nodes{ $k } ) ) {
			print "scheduling $k\n";

			# find a slot and lay down the node.
			my $worker_id = -1;

			for( my $i = $schedule_marker; $i <= ( $schedule_marker + $step_cost{$k} ); $i++ ) {
				# choose a worker
				for( my $j = 0; $j <= $workers; $j++ ) {
					if( $schedule[$j][$i] eq '.' ) {
						$worker_id = $j;
						last;
					}
				}
				if( $worker_id == -1 ) {
					print "no workers available at schedule_marker: " . $i . "\n";
				} else {
					print "found a worker: " . $worker_id . " at " . $i . "\n";
					last;
				}
			}

			if( $worker_id != -1 ) {
				for( my $m = $schedule_marker; $m < ($schedule_marker + $step_cost{$k}); $m++ ) {
					$schedule[$worker_id][$m] = $k;
				}

				# dont mark a node as scheduled if it wasnt.
				if( $scheduled ) {
					$scheduled_nodes{ $k } = 1;
				}
			}
		}
	}
}
