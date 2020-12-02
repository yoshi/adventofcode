/*
--- Day 5: A Maze of Twisty Trampolines, All Alike ---

An urgent interrupt arrives from the CPU: it's trapped in a maze of
jump instructions, and it would like assistance from any programs with
spare cycles to help find the exit.

The message includes a list of the offsets for each jump. Jumps are
relative: -1 moves to the previous instruction, and 2 skips the next
one. Start at the first instruction in the list. The goal is to follow
the jumps until one leads outside the list.

In addition, these instructions are a little strange; after each jump,
the offset of that instruction increases by 1. So, if you come across
an offset of 3, you would move three instructions forward, but change
it to a 4 for the next time it is encountered.

For example, consider the following list of jump offsets:

0
3
0
1
-3

Positive jumps ("forward") move downward; negative jumps move
upward. For legibility in this example, these offset values will be
written all on one line, with the current instruction marked in
parentheses. The following steps would be taken before an exit is
found:

    (0) 3 0 1 -3 - before we have taken any steps.

    (1) 3 0 1 -3 - jump with offset 0 (that is, don't jump at
    all). Fortunately, the instruction is then incremented to 1.

     2 (3) 0 1 -3 - step forward because of the instruction we just
     modified. The first instruction is incremented again, now to 2.

     2 4 0 1 (-3) - jump all the way to the end; leave a 4 behind.

     2 (4) 0 1 -2 - go back to where we just were; increment -3 to -2.

     2 5 0 1 -2 - jump 4 steps forward, escaping the maze.

In this example, the exit is reached in 5 steps.

How many steps does it take to reach the exit?

--- Part Two ---

Now, the jumps are even stranger: after each jump, if the offset was
three or more, instead decrease it by 1. Otherwise, increase it by 1
as before.

Using this rule with the above example, the process now takes 10
steps, and the offset values after finding the exit are left as 2 3 2
3 -1.

How many steps does it now take to reach the exit?

Although it hasn't changed, you can still get your puzzle input.

*/
package main

import (
	"os"
//	"strings"
	"bufio"
	"fmt"
	"strconv"
)

func main() {
	fmt.Printf( "Starting up" )

	// create a dynamic int array.  add elements until file io is complete.
	var states = make([]int, 0)

	f, err := os.Open( "05.data")
	//f, err := os.Open( "05.test")
	defer f.Close( )

	if err == nil  {
		scanner := bufio.NewScanner( f )

		for scanner.Scan() {
			line := scanner.Text()
			val,_ := strconv.Atoi( line )
			states = append( states, val )
		}
	}

	s2 := make([]int, len(states), cap(states))
	copy( s2, states )

	//fmt.Printf( "states:%v\n", states )

	// start machining up and down the array until an exit can be found.
	if len(states) != 0 {
		exited := false
		rounds := 0
		ix := 0

		for ! exited {
			rounds = rounds + 1

			//fmt.Printf( "round %d states:%v ix:%d sval:%d\n", rounds, states, ix, states[ix] )

			sval := states[ ix ]
			states[ ix ] = states [ ix ] + 1
			ix = ix + sval

			if( ix < 0 || ix > len( states ) - 1 ) {
				// record the answer and present it.

				//fmt.Printf( "round %d states:%v ix:%d sval:%d\n", rounds, states, ix, states[ix] )
				exited = true
			}
		}

		fmt.Printf( "Exited in %d rounds\n", rounds )

		exited = false
		rounds = 0
		ix = 0

		for ! exited {
			rounds = rounds + 1

			//fmt.Printf( "round %d states:%v ix:%d sval:%d\n", rounds, s2, ix, s2[ix] )

			sval := s2[ix]
			if s2[ix] >= 3 {
				s2[ix] = s2[ix] - 1
			} else {
				s2[ix] = s2[ix] + 1
			}
			ix = ix + sval

			if( ix < 0 || ix > len( s2 ) - 1 ) {
				// record the answer and present it.

				//fmt.Printf( "round %d states:%v ix:%d sval:%d\n", rounds, states, ix, states[ix] )
				exited = true
			}
		}
		fmt.Printf( "Exited in %d rounds\n", rounds )

	} else {
		fmt.Println( "the data set is empty!!!" )
	}

}
