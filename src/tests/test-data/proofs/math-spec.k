module MATH-SPEC
    imports NOCK
    imports MATH-SPEC-TESTS

    // Hoon standard library: math portion
    // Dependencies:
    // DEC <- LTH

    // The `dec` function of the Hoon standard library.
endmodule

module MATH-SPEC-TESTS
    imports NOCK

    claim [decrement]: <k>
        nock([[_:Noun N:Int _:Noun] [11 [[1851876717 [[1 [[1 1717658988] [7 [[0 1] [8 [[1 [1 [100 [101 [99 [114 [101 [109 [101 [110 [116 [45 [117 [110 [100 [101 [114 [102 [108 [111 [119 0]]]]]]]]]]]]]]]]]]]]] [9 [2 [0 1]]]]]]]]] [0 1]]] [6 [[5 [[1 0] [0 6]]] [[0 0] [8 [[1 0] [8 [[1 [6 [[5 [[0 30] [4 [0 6]]]] [[0 6] [9 [2 [10 [[6 [4 [0 6]]] [0 1]]]]]]]]] [9 [2 [0 1]]]]]]]]]]]]])
        => N -Int 1
        ... </k>
        requires N >Int 0

    claim [dec-inv-2]: <k>
    // --depth 106, the top expression on top of th freezers for nock11
        * [[[6 [[5 [[0 30] [4 [0 6]]]] [[0 6] [9 [2 [10 [[6 [4 [0 6]]] [0 1]]]]]]]] [X:Int [_:Noun [N:Int _:Noun]]]] [2 [[0 1] [0 2]]]]
        =>  N -Int 1
        ... </k>
        requires N >Int X
    
endmodule