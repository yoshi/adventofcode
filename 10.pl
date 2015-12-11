#!/usr/bin/perl -w

my $input = "1113222113";

print "start: $input\n";

my $iter = $input;

for( $i = 0; $i < 50; $i +=1 ) {
	$iter = &las($iter);
}

print "iter length: " . length( $iter ) . "\n";

exit( 0 );

sub las {
	my( $start_str ) = @_;

	my $iter_str = "";
#	vec($iter_str, length($start_str) * 1.5, 8) = 0;
#	$iter_str = "";

	my( @scoreboard );

	my( $prev );

	foreach $c ( split( //, $start_str ) ) {
		if( ! defined $prev ) {
			$scoreboard[ $c ] = 1;
		} else {
			if( $prev eq $c ) {
				$scoreboard[ $c ] += 1;
			} else {
				my $las = $scoreboard[ $prev ] . $prev;
				$iter_str .= $las;
				$scoreboard[ $prev ] = 0;
				$scoreboard[ $c ] = 1;
			}
		}
		$prev = $c;
	}

	#final one
	my $las = $scoreboard[$prev] . $prev;
	$iter_str .= $las;

	return $iter_str;
}
