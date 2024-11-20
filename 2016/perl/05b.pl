#!perl -w

use Digest::MD5 qw(md5_hex);

print &gen_password( "abc" ) . qq(\n);
print &gen_password( "wtnhxymk" ) . qq(\n);

exit( 0 );

sub gen_password {
	my( $id ) = @_;

	my $password = "        ";
	my $done = 0;
	my $index = 0;
	my $count = 0;

	while( ! $done ) {
		my $hash = md5_hex( "$id$index" );

		if( substr( $hash, 0, 5) eq "00000" ) {
			my $loc = substr( $hash, 5, 1);
			my $c = substr( $hash, 6, 1);

			if( $loc =~ /[0-7]/ ) {
				if( substr($password, $loc, 1) eq " " ) {
					#print "loc: $loc c: $c\n";
					substr( $password, $loc, 1 ) = $c;
					$count++;
				}
			}
		}
		
		if( $count == 8 ) {
			$done = 1;
		} else {
			$index++;
		}
	}

	return $password;
}
