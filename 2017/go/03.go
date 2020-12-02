/*
--- Day 3: Spiral Memory ---

You come across an experimental new kind of memory stored on an
infinite two-dimensional grid.

Each square on the grid is allocated in a spiral pattern starting at a
location marked 1 and then counting up while spiraling outward. For
example, the first few squares are allocated like this:

17  16  15  14  13
18   5   4   3  12
19   6   1   2  11
20   7   8   9  10
21  22  23---> ...

While this is very space-efficient (no squares are skipped), requested
data must be carried back to square 1 (the location of the only access
port for this memory system) by programs that can only move up, down,
left, or right. They always take the shortest path: the Manhattan
Distance between the location of the data and square 1.

For example:

    Data from square 1 is carried 0 steps, since it's at the access
    port.

    Data from square 12 is carried 3 steps, such as: down, left, left.

    Data from square 23 is carried only 2 steps: up twice.

    Data from square 1024 must be carried 31 steps.

How many steps are required to carry the data from the square
identified in your puzzle input all the way to the access port?

Your puzzle input is 368078.

--- Part Two ---

As a stress test on the system, the programs here clear the grid and
then store the value 1 in square 1. Then, in the same allocation order
as shown above, they store the sum of the values in all adjacent
squares, including diagonals.

So, the first few squares' values are chosen as follows:

    Square 1 starts with the value 1.

    Square 2 has only one adjacent filled square (with value 1), so it
    also stores 1.

    Square 3 has both of the above squares as neighbors and stores the
    sum of their values, 2.

    Square 4 has all three of the aforementioned squares as neighbors
    and stores the sum of their values, 4.

    Square 5 only has the first and fourth squares as neighbors, so it
    gets the value 5.

Once a square is written, its value does not change. Therefore, the
first few squares would receive the following values:

147  142  133  122   59
304    5    4    2   57
330   10    1    1   54
351   11   23   25   26
362  747  806--->   ...

What is the first value written that is larger than your puzzle input?

Your puzzle input is still 368078.
*/
package main

import (
	"fmt"
//	"bufio"
//	"io"
//	"io/ioutil"
//	"os"
//	"strconv"
//	"strings"
//	"math"
)

type Direction int

const (
	UP Direction = iota
	DOWN
	LEFT
	RIGHT
)

func main() {
	var input, next, i uint

	m := make([][]uint, 2048)
	for i := range m {
		m[i] = make([]uint, 2048)
	}

	midx := 1024
	midy := 1024

	input = 368078

	maxy := 0
	maxx := 0
	miny := 0
	minx := 0
	x := 0
	y := 0
	distance := 0

	// init: dir = right
	dir := RIGHT
//	fmt.Printf( "%d: %d\n", 0, 0)

	m[midx][midy] = 1

	for i = 2; i <= input; i++ {
		// if dir == right then x = x + 1
		// if dir == up then y = y + 1
		// if dir == left then x = x - 1
		// if dir == down then y = y - 1

		// Move the target
		if dir == RIGHT {
			x = x + 1
		}
		if dir == UP {
			y = y + 1
		}
		if dir == LEFT {
			x = x - 1
		}
		if dir == DOWN {
			y = y - 1
		}

		m[midx+x][midy+y] =
			m[midx+x-1][midy+y+1] + m[midx+x][midy+y+1] + m[midx+x+1][midy+y+1] +
			m[midx+x-1][midy+y] + m[midx+x][midy+y] + m[midx+x+1][midy+y] +
			m[midx+x-1][midy+y-1] + m[midx+x][midy+y-1] + m[midx+x+1][midy+y-1]

		if( m[midx+x][midy+y] > input && next == 0 ) {
			next = m[midx+x][midy+y]
		}

//		fmt.Printf( "indexes: %d %d %d %d %d %d\n", i, midx, midy, x, y, m[midx+x][midy+y])

		// if x > maxx then maxx = x, dir = up
		// if x < minx then minx = x, dir = down
		// if y > maxy then maxy = y, dir = left
		// if y > miny then miny = y, dir = right
		if x > maxx {
			maxx = x
			dir = UP
		}
		if x < minx {
			minx = x
			dir = DOWN
		}
		if y > maxy {
			maxy = y
			dir = LEFT
		}
		if y < miny {
			miny = y
			dir = RIGHT
		}

		absx := x

		if x < 0 {
			absx = -x
		}

		absy := y

		if y <  0 {
			absy = -y
		}

		distance = absx + absy
//		fmt.Printf( "%d: %d\n", i, absx + absy)
	}
	fmt.Printf( "%d distance %d (%d %d) (%d %d %d %d)\n", input, distance, x,y,minx, miny, maxx, maxy )
	fmt.Printf( "next: %d\n", next )
}


/* NOTES

1 0,0		RIGHT
1 1,0		UP		(SELF + LEFT)
2 1,1		LEFT	(SELF + DOWN + DL)
4 0,1		LEFT	(SELF + RIGHT + DR + DOWN)
5 -1,1		DOWN	(SELF + RIGHT + DR)
10 -1,0		DOWN	(SELF + UP + UR + RIGHT)
11 -1,-1	RIGHT	(SELF + UP + UR)
23 0,-1		RIGHT	(SELF + LEFT + UL + UP)
25 1,-1		RIGHT	(SELF + LEFT + UL + UP)
26 2,-1		UP		(SELF + LEFT + UL)
54 2,0		UP		(SELF + DOWN + DL + LEFT)
57 2,1		UP		(SELF + DOWN + DL + LEFT)
59 2,2		LEFT	(SELF + DOWN + DL)
122 1,2		LEFT	(SELF + RIGHT + DR + DOWN)
133 0,2		LEFT	(SELF + RIGHT + DR + DOWN)
142 -1,2	LEFT	(SELF + RIGHT + DR + DOWN)
147 -2,2	DOWN	(SELF + RIGHT + DR)
304 -2,1	DOWN	(SELF + UP + UR + RIGHT)
330 -2,0	DOWN	(SELF + UP + UR + RIGHT)
351 -2,-1	DOWN	(SELF + UP + UR + RIGHT)
362 -2,-2	RIGHT	(SELF + UP + UR)
747 -1,-2	RIGHT	(SELF + LEFT + UL + UP)
806 0,-2	RIGHT	(SELF + LEFT + UL + UP)
*/
