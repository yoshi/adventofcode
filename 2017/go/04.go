/*
--- Day 4: High-Entropy Passphrases ---

A new system policy has been put in place that requires all accounts
to use a passphrase instead of simply a password. A passphrase
consists of a series of words (lowercase letters) separated by spaces.

To ensure security, a valid passphrase must contain no duplicate
words.

For example:

    aa bb cc dd ee is valid.

    aa bb cc dd aa is not valid - the word aa appears more than once.

    aa bb cc dd aaa is valid - aa and aaa count as different words.

The system's full passphrase list is available as your puzzle
input. How many passphrases are valid?

--- Part Two ---

For added security, yet another system policy has been put in
place. Now, a valid passphrase must contain no two words that are
anagrams of each other - that is, a passphrase is invalid if any
word's letters can be rearranged to form any other word in the
passphrase.

For example:

    abcde fghij is a valid passphrase.

    abcde xyz ecdab is not valid - the letters from the third word can
    be rearranged to form the first word.

    a ab abc abd abf abj is a valid passphrase, because all letters
    need to be used when forming another word.

    iiii oiii ooii oooi oooo is valid.

    oiii ioii iioi iiio is not valid - any of these words can be
    rearranged to form any other word.

Under this new system policy, how many passphrases are valid?
*/
package main

import (
	"os"
	"strings"
	"bufio"
	"fmt"
	"sort"
)

func main() {
	f, err := os.Open( "04.data")
	defer f.Close( )

	if err == nil  {
		// read a line from the file
		scanner := bufio.NewScanner( f )
		valid_count := 0

		for scanner.Scan() {
			valid := 1
			line := scanner.Text()

			a := strings.Split(line, " " )

			for i := range a {
				for j := range a {
					ai := strings.Split( a[i], "" )
					sort.Strings(ai)
					sortedai := strings.Join(ai, "")

					aj := strings.Split( a[j], "" )
					sort.Strings(aj)
					sortedaj := strings.Join(aj, "")

					if i != j && (strings.Compare( a[i], a[j] ) == 0 ||
						strings.Compare( sortedai, sortedaj ) == 0 ) {
						valid = 0
					}
				}
			}
			valid_count = valid_count + valid
		}
		fmt.Printf( "valid_count: %d\n", valid_count )
	}
}
