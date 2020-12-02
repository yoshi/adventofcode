#!/usr/bin/perl -w

use Digest::MD5 qw(md5 md5_hex);

my $secret_base = "bgvyzdsv";
my $found = 0;
my $i = 0;
while( !$found ){
	my $secret = $secret_base . "$i";
	my $hash = md5_hex( $secret );
	#print qq($secret : $hash\n);

	if( $hash =~ /^000000/ ) {
		$found = 1;
	}

	$i += 1;
}
