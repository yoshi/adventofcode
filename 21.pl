#!perl

%weapons = ( "Dagger" => [8,4,0],
			 "Shortsword" => [10,5,0],
			 "Warhammer" => [25,6,0],
			 "Longsword" => [40,7,0],
			 "Greataxe" => [74,8,0] );

%armor = ( "Leather" => [13, 0, 1],
		   "Chainmail" => [31, 0, 2],
		   "Splitmail" => [53, 0, 3],
		   "Bandedmail" => [75, 0, 4],
		   "Platemail" => [102, 0, 5] );

%rings = ( "Damage +1" => [25, 1, 0],
		   "Damage +2" => [50, 2, 0],
		   "Damage +3" => [100, 3, 0],
		   "Defense +1" => [20, 0, 1],
		   "Defense +2" => [40, 0, 2],
		   "Defense +3" => [80, 0, 3] );

$boss_hp = 0;
$boss_dmg = 0;
$boss_ac = 0;

while( <> ) {
	chomp;
	($boss_hp) = ($_ =~ /(\d+)/)if( $_ =~ /^Hit Points/ );
	($boss_dmg) = ($_ =~ /(\d+)/) if( $_ =~ /^Damage/ );
	($boss_ac) = ($_ =~ /(\d+)/) if( $_ =~ /^Armor/ );
}

# the market
foreach $wp ( keys %weapons ) {
	foreach $ar (keys %armor ) {
		foreach $r1 (keys %rings ) {
			my $total_cost = $weapons{$wp}[0] + $armor{$ar}[0] + $rings{$r1}[0];
			my $total_dmg = $weapons{$wp}[1] + $armor{$ar}[1] + $rings{$r1}[1];
			my $total_ac = $weapons{$wp}[2] + $armor{$ar}[2] + $rings{$r1}[2];

			print qq($total_cost $wp $ar $r1 $total_dmg $total_ac winner: ) .
				&equip_check( $total_dmg, $total_ac ) . qq(\n);
		}
	}
}

#print qq(Boss Stats: $boss_hp $boss_dmg $boss_ac\n);
#print qq(Player Stats: $player_hp $player_dmg $player_ac\n);

exit( 0 );

sub equip_check {
	my( $test_dmg, $test_ac ) = @_;

	my $player_hp = 100;
	my $player_dmg = 0;
	my $player_ac = 0;

	my $test_boss_hp = $boss_hp;
	my $test_boss_dmg = $boss_dmg;
	my $test_boss_ac = $boss_ac;

	my $winner = "Boss";

	while( $player_hp > 0 && $test_boss_hp > 0 ) {
		($player_hp, $test_boss_hp) = &round( $player_hp, $player_dmg, $player_ac,
											  $test_boss_hp, $test_boss_dmg, $test_boss_ac );

		if( $player_hp <= 0 ) {
			$winner = "Boss";
			last;
		} elsif( $test_boss_hp <= 0 ) {
			$winner = "Player";
			last;
		}
	}
	return $winner;
}

sub round {
	my( $player_hp, $player_dmg, $player_ac, $test_boss_hp, $test_boss_dmg, $test_boss_ac ) = @_;

	my( $player_dealt ) = 0;
	my( $boss_dealt ) = 0;

	if( $player_dmg >= $test_boss_ac ) {
		$player_dealt = $player_dmg - $test_boss_ac;
	} else {
		$player_dealt = 1;
	}
	$test_boss_hp -= $player_dealt;
	print qq(The player deals $player_dmg-$test_boss_ac = $player_dealt );
	print qq(min ) if $player_dealt == 1;
	print qq(damage; the boss goes down to $test_boss_hp hit points.\n);

	if( $test_boss_dmg >= $player_ac ) {
		$boss_dealt = $test_boss_dmg - $player_ac;
	} else {
		$boss_dealt = 1;
	}
	$player_hp -= $boss_dealt;
	print qq(The boss deals $test_boss_dmg-$player_ac = $boss_dealt );
	print qq(min ) if $boss_dealt == 1;
	print qq(damage; the player goes down to $player_hp hit points.\n);

	return( $player_hp, $test_boss_hp );
}
