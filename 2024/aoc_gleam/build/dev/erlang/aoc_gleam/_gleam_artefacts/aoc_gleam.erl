-module(aoc_gleam).
-compile([no_auto_import, nowarn_unused_vars, nowarn_unused_function, nowarn_nomatch]).

-export([main/0]).

-file("/Users/ytakahashi/src/github.com/yoshi/adventofcode/2024/aoc_gleam/src/aoc_gleam.gleam", 3).
-spec main() -> nil.
main() ->
    gleam@io:println(<<"Hello from aoc_gleam!"/utf8>>).
