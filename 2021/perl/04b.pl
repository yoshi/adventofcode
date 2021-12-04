#!perl -w

chomp( my @dat = <> );

my( @boards );
my( @marks );
my $score = 0;
my $winner;

@draws = split( ',', $dat[0] );

# read boards
for( $i = 1; $i < scalar @dat; $i += 6 ) {
	my( $board_str );
	my( @board );
	my( @mark ) = (0) x 25;
	$board_str = join( ' ', @dat[$i+1..$i+5] );
	$board_str =~ s/^ //g;
	$board_str =~ s/  / /g;
	@board = split( " ", $board_str );
	push( @boards, \@board );
	push( @marks, \@mark );
}

my @scoreboard = (0) x scalar(@boards);

foreach $draw ( @draws ) {
	for( $i = 0; $i < scalar @boards; $i++ ) {
		$board = $boards[$i];
		for( $j = 0; $j < scalar @{$board}; $j++ ) {
			if( $draw == @{$board}[$j] ) {
				$marks[$i]->[$j] = 1;
			}
		}
		if( &iswin( $marks[$i] ) == 1 ) {
			$scoreboard[$i] = 1;

			my $win_board_count = 0;

			for( $m = 0; $m < scalar(@scoreboard); $m++ ) {
				if( $scoreboard[$m] == 1 ) {
					$win_board_count++;
				}
			}

			if( $win_board_count == scalar( @scoreboard ) ) {
				$winner = $i;
				$unmarked_sum = 0;
			
				for( $k = 0; $k < scalar @{$board}; $k++ ) {
					$unmarked_sum += @{$board}[$k] if $marks[$i]->[$k] == 0;
				}
				
				$score = $unmarked_sum * $draw;
				last;
			}
		}
	}
	last if( defined $winner );
}

if( defined $winner ) {
	print qq(winner: $winner\n);
} else {
	print qq(no winners :\(\n);
}

print qq(score: $score\n);

exit(0);

sub iswin {
	my( $mark ) = @_;

	my( $winz ) = 0;

	if( (join( '', @$mark[0..4]) eq "11111") ||
		(join( '', @$mark[5..9]) eq "11111") ||
		(join( '', @$mark[10..14]) eq "11111" ) ||
		(join( '', @$mark[15..19]) eq "11111" ) ||
		(join( '', @$mark[20...24]) eq "11111" ) ||
		(join( '', @$mark[0,5,10,15,20]) eq "11111" ) ||
		(join( '', @$mark[1,6,11,16,21]) eq "11111" ) ||
		(join( '', @$mark[2,7,12,17,22]) eq "11111" ) ||
		(join( '', @$mark[3,8,13,18,23]) eq "11111" ) ||
		(join( '', @$mark[4,9,14,19,24]) eq "11111" )) {
		$winz = 1;
	}
	
	return $winz;
}

