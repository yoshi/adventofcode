#!perl

use lib qw(.);

use Intcode;

my $debug = 0;

my @seq = (1,0,4,3,2);

my $ic_data;

while( <> ) {
	chomp;

	$ic_data = $_;
}

my @input_stream, @output_stream;

push @input_stream, shift @seq;
push @input_stream, 0;

my $ica = Intcode->new( $ic_data );

$ica->istream( \@input_stream );
$ica->ostream( \@output_stream );

while( ! $ica->{halted} ) {
#	$ica->print_tape();
	$ica->tick();
}

print "ostream a: " . join( ",", @output_stream ) . "\n";

push @input_stream, shift @seq;
push @input_stream, shift @output_stream;

my $icb = Intcode->new( $ic_data );

$icb->istream( \@input_stream );
$icb->ostream( \@output_stream );

while( ! $icb->{halted} ) {
#	$icb->print_tape();
	$icb->tick();
}

print "ostream b: " . join( ",", @output_stream ) . "\n";

push @input_stream, shift @seq;
push @input_stream, shift @output_stream;

my $icc = Intcode->new( $ic_data );

$icc->istream( \@input_stream );
$icc->ostream( \@output_stream );

while( ! $icc->{halted} ) {
#	$icc->print_tape();
	$icc->tick();
}

print "ostream c: " . join( ",", @output_stream ) . "\n";

push @input_stream, shift @seq;
push @input_stream, shift @output_stream;

my $icd = Intcode->new( $ic_data );

$icd->istream( \@input_stream );
$icd->ostream( \@output_stream );

while( ! $icd->{halted} ) {
#	$icd->print_tape();
	$icd->tick();
}

print "ostream d: " . join( ",", @output_stream ) . "\n";

push @input_stream, shift @seq;
push @input_stream, shift @output_stream;

my $ice = Intcode->new( $ic_data );

$ice->istream( \@input_stream );
$ice->ostream( \@output_stream );

while( ! $ice->{halted} ) {
#	$ice->print_tape();
	$ice->tick();
}

#$ic->run();

print "ostream e: " . join( ",", @output_stream ) . "\n";

exit(0);
