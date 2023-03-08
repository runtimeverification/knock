module LOOP-SPEC
    imports NOCK

    /* Two simple Nock programs with recursion/looping.
    In both cases, the issue is figuring out where the loop head is.
    So far, the most simple way to do this is:
    - run the proof with some `--depth`
    - look at the output: do we have accumulated conditions that indicate that we have performed more than one iteration of the loop, e.g. "N =/= 1".
    - binary search with `--depth`: try to find an expression where there are few freezers, and the top is a call with `*`.
        - the loop head will tend to be an evaluate (nock 2) with a large subject -- this is the result of running invoke (nock 9) and computing the new subject: 
            *[[[6 [5 [0 7] 4 0 6] [0 6] 9 2 [0 2] [4 0 6] 0 7] X:Int N:Int] _2_ [0 1] 0 2 ]
        - if you want to find the first branching point quick, you can use --brancing-allowed 0 (or some higher number until you find the right branching point)
    - try the loop invariant on its own: ./knock.sh prove tests/proofs/loop-spec.k --claims LOOP-SPEC.decrement-loop-inv
    - see if that makes the proof go through: ./knock.sh prove  tests/proofs/loop-spec.k
      (for some reason, I can't make --trusted work, so I need to run the full file)
    */

    // This is a handwritten decrementation function handwritten in Nock.
    // It will instantiate an iterator at i=0, and then check whether i+1 = N, and if so, return i.
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

    // This nock code returns 0 (%.y) if N is even, 1 (%.n) if it's odd.
    // !=  =/  a   <N>  =/  b  0  =/  is  %.y  |-  ?:  =(b a)  is  $(b +(b), is ?!(is))

    claim [even-loop-concrete]: <k>
        nock([_:Noun [8 [[1 N:Int] [8 [[1 0] [8 [[1 0] [8 [[1 [6 [[5 [[0 14] [0 30]]] [[0 6] [9 [2 [10 [[14 [4 [0 14]]] [10 [[6 [6 [[0 6] [[1 1] [1 0]]]]] [0 1]]]]]]]]]]] [9 [2 [0 1]]]]]]]]]]]])
        => 0
        ... </k>
        requires N ==Int 10

    claim [even-loop]: <k> // Passes
        nock([_:Noun [8 [[1 N:Int] [8 [[1 0] [8 [[1 0] [8 [[1 [6 [[5 [[0 14] [0 30]]] [[0 6] [9 [2 [10 [[14 [4 [0 14]]] [10 [[6 [6 [[0 6] [[1 1] [1 0]]]]] [0 1]]]]]]]]]]] [9 [2 [0 1]]]]]]]]]]]])
        => N modInt 2
        ... </k>
        requires N >=Int 0

    claim [even-loop-inv]: <k> // Passes
        // Depth 42
        * [[[6 [[5 [[0 14] [0 30]]] [[0 6] [9 [2 [10 [[14 [4 [0 14]]] [10 [[6 [6 [[0 6] [[1 1] [1 0]]]]] [0 1]]]]]]]]]] [B:Int [X:Int [N:Int _:Noun]]]] [2 [[0 1] [0 2]]]]
        => N modInt 2
        ... </k>
        requires N >=Int X
        andBool  X modInt 2 ==Int B

endmodule