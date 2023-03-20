module DECREMENT-SPEC
    imports NOCK

    claim [decrement-concrete]: <k>
        nock([2 ^Int 256 [8 [1 0] 8 [1 6 [5 [0 7] 4 0 6] [0 6] 9 2 [0 2] [4 0 6] 0 7] 9 2 0 1]])
        => 2 ^Int 256 -Int 1
        ... </k>

    claim [decrement]: <k>
        nock([N:Int [8 [1 0] 8 [1 6 [5 [0 7] 4 0 6] [0 6] 9 2 [0 2] [4 0 6] 0 7] 9 2 0 1]])
        => N -Int 1
        ... </k>
        requires N >Int 0

    claim [decrement-loop-inv]: <k>
        // depth 166
        //   * [ [ [ 6 [ [ 5 [ [ 0 7 ] [ 4 [ 0 6 ] ] ] ] [ [ 0 6 ] [ 9 [ 2 [ [ 0 2 ] [ [ 4 [ 0 6 ] ] [ 0 7 ] ] ] ] ] ] ] ] [ 1 N:Int ] ] [ 2 [ [ 0 1 ] [ 0 2 ] ] ] ] ~> _DotVar1 ~> .
        //   cleaned:
        // *[[[6 [5 [0 7] 4 0 6] [0 6] 9 2 [0 2] [4 0 6] 0 7] 1 N:Int] 2 [0 1] 0 2 ]
        //   what changes between invocations ----------------^
        *[[[6 [5 [0 7] 4 0 6] [0 6] 9 2 [0 2] [4 0 6] 0 7] X:Int N:Int] 2 [0 1] 0 2 ]
        //=> *[[[6 [5 [0 7] 4 0 6] [0 6] 9 2 [0 2] [4 0 6] 0 7] (N -Int 1) N] 2 [0 1] 0 2 ]
        => N -Int 1
        ... </k>
    requires X <Int N

endmodule
