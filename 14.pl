#!perl -w

use Moops;

class Reindeer {
	has name => ( is => 'rw', isa => Str );

	has fly_speed => ( is => 'rwp', isa => Int );
	has fly_duration => ( is => 'rwp', isa => Int );
	has rest_duration => ( is => 'rwp', isa => Int );

	has distance => ( is => 'rwp', isa => Int, default => 0 );
	has is_resting => ( is => 'rwp', isa => Bool, default => false );
	has is_flying => ( is => 'rwp', isa => Bool, default => true );

	has fly_ticks => ( is => 'rwp', isa => Int, default => 0 );
	has rest_ticks => ( is => 'rwp', isa => Int, default => 0 );

	has points => ( is => 'rwp', isa => Int, default => 0 );

	method tick {
		if ( $self->is_flying ) {
			$self->_set_fly_ticks( $self->fly_ticks - 1 );
			$self->_set_distance( $self->distance + $self->fly_speed );
			if( $self->fly_ticks == 0 ) {
				$self->_set_rest_ticks( $self->rest_duration );
				$self->_set_is_resting( true );
				$self->_set_is_flying( false );
				printf( "%s is now resting\n", $self->name );
			}
		} else {
			$self->_set_rest_ticks( $self->rest_ticks - 1 );
			if( $self->rest_ticks == 0 ) {
				$self->_set_fly_ticks( $self->fly_duration );
				$self->_set_is_resting( false );
				$self->_set_is_flying( true );
				printf( "%s is now flying\n", $self->name );
			}
		}
	}

	method state {
		printf( "%s is %s and has traveled %d km and has %d points.\n",
				$self->name,
				$self->is_resting ? "resting" : "flying",
				$self->distance,
				$self->points );
	}

	method give_point {
		$self->_set_points( $self->get_points + 1 );
	}
}

package main;

my @reindeer_crew;

while( <> ) {
	chomp;

	my @data = split(/ /);

	my $a_reindeer = Reindeer->new( name => $data[0],
									fly_speed => $data[3],
									fly_ticks => $data[6],
									fly_duration => $data[6],
									rest_duration => $data[13] );

	push @reindeer_crew, $a_reindeer;
}

for( my $i = 0; $i < 2503; $i += 1 ) {
	foreach my $reindeer (@reindeer_crew ) {
		$reindeer->tick;
	}
}

print qq(After 2503 ticks here is the crew's status:\n);

foreach my $reindeer (@reindeer_crew ) {
	$reindeer->state;
}
