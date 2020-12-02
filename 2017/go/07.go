/*
--- Day 7: Recursive Circus ---

Wandering further through the circuits of the computer, you come upon
a tower of programs that have gotten themselves into a bit of
trouble. A recursive algorithm has gotten out of hand, and now they're
balanced precariously in a large tower.

One program at the bottom supports the entire tower. It's holding a
large disc, and on the disc are balanced several more sub-towers. At
the bottom of these sub-towers, standing on the bottom disc, are other
programs, each holding their own disc, and so on. At the very tops of
these sub-sub-sub-...-towers, many programs stand simply keeping the
disc below them balanced but with no disc of their own.

You offer to help, but first you need to understand the structure of
these towers. You ask each program to yell out their name, their
weight, and (if they're holding a disc) the names of the programs
immediately above them balancing on that disc. You write this
information down (your puzzle input). Unfortunately, in their panic,
they don't do this in an orderly fashion; by the time you're done,
you're not sure which program gave which information.

For example, if your list is the following:

pbga (66)
xhth (57)
ebii (61)
havc (66)
ktlj (57)
fwft (72) -> ktlj, cntj, xhth
qoyq (66)
padx (45) -> pbga, havc, qoyq
tknk (41) -> ugml, padx, fwft
jptl (61)
ugml (68) -> gyxo, ebii, jptl
gyxo (61)
cntj (57)

...then you would be able to recreate the structure of the towers that
looks like this:

                gyxo
              /     
         ugml - ebii
       /      \     
      |         jptl
      |        
      |         pbga
     /        /
tknk --- padx - havc
     \        \
      |         qoyq
      |             
      |         ktlj
       \      /     
         fwft - cntj
              \     
                xhth

In this example, tknk is at the bottom of the tower (the bottom
program), and is holding up ugml, padx, and fwft. Those programs are,
in turn, holding up other programs; in this example, none of those
programs are holding up any other programs, and are all the tops of
their own towers. (The actual tower balancing in front of you is much
larger.)

Before you're ready to help them, you need to make sure your
information is correct. What is the name of the bottom program?
*/
package main

import (
	"fmt"
	"bufio"
	"strings"
	"strconv"
	"os"
)

type Node struct {
	name		string
	weight		int
	children	map[string]Node
}

func (n *Node) HasChild() bool {
	if n.children == nil {
		return false
	} else {
		return true
	}
}

func main() {
	fmt.Printf("Starting day 7\n")

	//f, err := os.Open( "07.data")
	f, err := os.Open( "07.test")
	defer f.Close( )

	if err == nil  {
		scanner := bufio.NewScanner( f )

		// read all nodes and node relationships
		var nodes []Node
		nodemap := make(map[string]Node, 0)
		for scanner.Scan() {
			line := scanner.Text()
			// format: NAME (WEIGHT) [-> [child]+]
			a := strings.Split(line, " -> " )
			nw := strings.Split(a[0], " (")
			name := nw[0]
			weight,_ := strconv.Atoi( strings.Replace(nw[1], ")", "", -1) )

			node := new( Node )

			node.name = name
			node.weight = weight

			if( len(a) > 1 ) {
				node.children = make(map[string]Node, 0)
				kids := strings.Split( a[1], ", ")
				//fmt.Printf( "has kids -> %v\n", kids)
				for _,k := range( kids ) {
					child := new(Node)
					child.name = k
					node.children[child.name] = *child
					//node.children = append(node.children, *child)
				}
			}

			nodemap[node.name] = *node
			nodes = append( nodes, *node )
		}
		//fmt.Printf( "nodemap: %v\n", nodemap)
		//fmt.Printf( "nodes: %v\n", nodes)

		// with the hash version, we iterate through the map and find any entries that match.
		// with the match, we replace the real version with the top level version
		// then we remove the top level version

		for k,v := range nodemap {
			for subk,subv := range nodemap {
				if subk == k {
					continue
				} else {
					if subv.HasChild() {
						for chik,_ := range subv.children {
							if chik == k {
								delete( subv.children, chik )
								subv.children[chik] = v
								delete( nodemap, k)
							}
						}
					}
				}
			}
		}
		fmt.Printf( "nodemap: %v\n", nodemap)
	}

	fmt.Printf("Ending day 7\n")
}
