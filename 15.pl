#!perl

use strict;
use warnings;

use Moops;

class Ingredient {
	has name => ( is => 'rwp', isa => Str );

	has capacity => ( is => 'rwp', isa => Int );
	has durability => ( is => 'rwp', isa => Int );
	has flavor => ( is => 'rwp', isa => Int );
	has texture => ( is => 'rwp', isa => Int );
	has calories => ( is => 'rwp', isa => Int );

	method details {
		printf( "%s: capacity %d, durability %d, flavor %d, texture %d, calories %d\n",
				$self->name,
				$self->capacity,
				$self->durability,
				$self->flavor,
				$self->texture,
				$self->calories );
	}
}

package main;

my @ingredients;

while( <> ) {
	chomp;

	my ( $name, $rest, undef ) = split( ':' );
	$rest =~ s/[a-z ]//g;
	my @data = split( /,/, $rest );

	my ( $ingredient ) = Ingredient->new( name => $name,
										  capacity => $data[0],
										  durability => $data[1],
										  flavor => $data[2],
										  texture => $data[3],
										  calories => $data[4] );

	push @ingredients, $ingredient;
}

# Generate all cookies and find best cookie.

my $high_score = 0;
my $high_cal_score = 0;

for( my $i = 0; $i <= 100; $i += 1 ) {
	for ( my $j = 0; $j <= 100; $j += 1 ) {
		for ( my $k = 0; $k <= 100; $k += 1 ) {
			for ( my $l = 0; $l <= 100; $l += 1 ) {
				if( ($i + $j + $k + $l ) == 100 ) {
					if( ($i + $j + $k + $l ) == 100 ) {
						my $capacity_score =
							$ingredients[0]->capacity * $i +
							$ingredients[1]->capacity * $j +
							$ingredients[2]->capacity * $k +
							$ingredients[3]->capacity * $l;
						my $durability_score =
							$ingredients[0]->durability * $i +
							$ingredients[1]->durability * $j +
							$ingredients[2]->durability * $k +
							$ingredients[3]->durability * $l;
						my $flavor_score =
							$ingredients[0]->flavor * $i +
							$ingredients[1]->flavor * $j +
							$ingredients[2]->flavor * $k +
							$ingredients[3]->flavor * $l;
						my $texture_score =
							$ingredients[0]->texture * $i +
							$ingredients[1]->texture * $j +
							$ingredients[2]->texture * $k +
							$ingredients[3]->texture * $l;
						my $calories_score =
							$ingredients[0]->calories * $i +
							$ingredients[1]->calories * $j +
							$ingredients[2]->calories * $k +
							$ingredients[3]->calories * $l;

						my $score =
							( $capacity_score > 0 ? $capacity_score : 0 ) *
							( $durability_score > 0 ? $durability_score : 0 ) *
							( $flavor_score > 0 ? $flavor_score : 0 ) *
							( $texture_score > 0 ? $texture_score : 0 );

						if ( $score > 0 ) {
							# printf( "Scores: %d %d %d %d %d\n",
							#		$capacity_score, $durability_score,
							#		$flavor_score, $texture_score, $calories_score );
							# printf( "Valid Cookie: %d %d %d %d Score: %d\n",
							#		$i, $j, $k, $l, $score );

							$high_score = $score if $score > $high_score;
							if( $calories_score == 500 ) {
								$high_cal_score = $score if $score > $high_cal_score;
							}
						}
					}
				}
			}
		}
	}
}

print qq(the high score is: $high_score\n);
print qq(the high cal score is: $high_cal_score\n );
