#!perl -w

chomp( my @dat = <> );
my $inc = 0;
my $prev;

my %op;

$op{ 'A' } = "Rock";
$op{ 'B' } = "Paper";
$op{ 'C' } = "Scissors";

my %me;

$me{ 'X' } = "Rock";
$me{ 'Y' } = "Paper";
$me{ 'Z' } = "Scissors";

my $total_score = 0;

for( my $i = 0; $i < scalar( @dat ); $i++ ) {
	my( $op_play, $me_play ) = split( ' ', $dat[$i] );

	my( $revised_play ) = -1;

	my $round_score = 0;

	if( $me_play eq 'X' ) {
		#lose
		if( $op{ $op_play } eq "Rock" ) {
			$mod_play = "Scissors";
		} elsif( $op{ $op_play } eq "Paper" ) {
			$mod_play = "Rock";
		} elsif( $op{ $op_play } eq "Scissors" ) {
			$mod_play = "Paper";
		}
		$round_score += 0;
	} elsif( $me_play eq 'Y' ) {
		#tie
		$mod_play = $op{ $op_play };
		$round_score += 3;
	} else {
		#win
		if( $op{ $op_play } eq "Rock" ) {
			$mod_play = "Paper";
		} elsif( $op{ $op_play } eq "Paper" ) {
			$mod_play = "Scissors";
		} elsif( $op{ $op_play } eq "Scissors" ) {
			$mod_play = "Rock";
		}
		$round_score += 6;
	}

	$round_score += 1 if( $mod_play eq "Rock" );
	$round_score += 2 if( $mod_play eq "Paper" );
	$round_score += 3 if( $mod_play eq "Scissors" );

	#print qq( $op_play $me_play $round_score\n);

	$total_score += $round_score;
}
print qq(total_score: $total_score\n);

#print qq(samwise elf: ) . $samwise . qq( ) . $elf_calories[$samwise] . qq(\n);
