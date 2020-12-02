#!perl

use lib qw(.);

use Intcode;

my $ic_data;

my $input = 5;

my $debug = 0;

while( <> ) {
	chomp;

	$ic_data = $_;
}

my $ic = Intcode->new( $ic_data );

my @input_stream, @output_stream;

push @input_stream, $input;

$ic->istream( \@input_stream );
$ic->ostream( \@output_stream );

#$ic->print_tape();

while( ! $ic->{halted} ) {
	$ic->print_tape();
	$ic->tick();
}

#$ic->run();


print "output: " . join( ",", @output_stream ) . "\n";

exit( 0 );
