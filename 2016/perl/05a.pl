#!perl -w

use Digest::MD5 qw(md5_hex);

print &gen_password( "abc" ) . qq(\n);
print &gen_password( "wtnhxymk" ) . qq(\n);

exit( 0 );

sub gen_password {
	my( $id ) = @_;

	my $password = "";
	my $done = 0;
	my $index = 0;

	while( ! $done ) {
		my $hash = md5_hex( "$id$index" );

		if( substr( $hash, 0, 5) eq "00000" ) {
			$password .= substr( $hash, 5,1 );
		}
		if( length( $password ) == 8 ) {
			$done = 1;
		} else {
			$index++;
		}
	}

	return $password;
}
