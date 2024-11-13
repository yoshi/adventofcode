#!perl -w

use utf8;
use strict;

chomp( my @dat = <> );

my $du_sum;

# in the data, we have paths, and descriptions of the paths.
# not sure we'll need much more accumiliation than that.

my $cwd;

# dirs is an array of errays that branch from /
# every dir has a cost calcuated by it's contents

for( my $i = 0; $i < scalar( @dat ); $i++ ) {
	# is this a command or is it data

	if($ $dat[$i] =~ /^\$/ ) {

		# what commands do we understand?
		# cd .. # up
		# cd <name> #down
		# ls # data

		# we have a cmd

		# lets understand the root path
		
		if( $dat[$i] eq == '$ cd /' ) {
			# set $cwd to the top of the path
		}
	} else {
		# we've got data
	}

}

print qq(du sum: $du_sum\n);

exit(0);
