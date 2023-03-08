module LOOP-SPEC
    imports NOCK

    // This nock code returns 0 (%.y) if N is even, 1 (%.n) if it's odd.
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
    
    /* Not passing
    claim [even-loop-inv-2]: <k>
        * [ [ B:Int [ X:Int [ N:Int _:Noun ] ] ] [ 8 [ [ 1 [ 6 [ [ 5 [ [ 0 14 ] [ 0 30 ] ] ] [ [ 0 6 ] [ 9 [ 2 [ 10 [ [ 14 [ 4 [ 0 14 ] ] ] [ 10 [ [ 6 [ 6 [ [ 0 6 ] [ [ 1 1 ] [ 1 0 ] ] ] ] ] [ 0 1 ] ] ] ] ] ] ] ] ] ] ] [ 9 [ 2 [ 0 1 ] ] ] ] ] ]
        => 0
        ... </k>
        requires N modInt 2 ==Int 0
        andBool  N >=Int X
        andBool  X modInt 2 ==Int B
        */

endmodule