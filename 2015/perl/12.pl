#!perl -w

use Data::Dumper;
use JSON qw( from_json decode_json );
use Scalar::Util qw( looks_like_number );

my $input;
my $skip_red = 0;

while( <> ) {
	chomp;
	$input .= $_;
}

print qq(cheaty_sum: ) . cheaty_sum( $input ) . qq(\n);
print qq(aw_sum: ) . aw_sum( $input ) . qq(\n);
print qq(red_sum: ) . red_sum( $input ) . qq(\n);

exit( 0 );

sub cheaty_sum {
	my( $json ) = @_;

	$json =~ s/[\[\]",:\}\{a-z]/ /g;
	$json =~ s/ +/ /g;

	return eval join( "+", split( / /, $json ));
}

# Ok, now do it the non-cheaty way...

sub aw_sum {
	my( $json ) = @_;
	my $sum = 0;
	my $data = from_json $json;

	return get_sum( $data );
}

sub red_sum {
	my( $json ) = @_;
	my $sum = 0;
	my $data = from_json $json;

	$skip_red = 1;

	return get_sum( $data );
}

sub get_sum {
	my( $thing ) = @_;
	my( $sum ) = 0;

	if( ref($thing) eq "HASH" ) {
		if( ! ( $skip_red && grep { $_ eq "red" } values %{$thing} ) ) {
			foreach $key ( keys %{$thing} ) {
				$sum += get_sum( $thing->{$key} );
			}
		}
	}
	if( ref($thing) eq "ARRAY" ) {
		foreach $item ( @{$thing} ) {
			$sum += get_sum( $item );
		}
	}
	if( ( !ref( $thing ) || ref($thing) eq "SCALAR" ) && looks_like_number( $thing ) ) {
		$sum = $thing;
	}

	return $sum
}
