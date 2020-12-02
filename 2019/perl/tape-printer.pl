#!perl

use lib qw(.);

use Intcode;

my $ic_data;

while( <> ) {
	chomp;

	$ic_data = $_;
}

my $ic1 = Intcode->new( $ic_data );

$ic1->print_tape();

exit( 0 );
