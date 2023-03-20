module BASIC-SPEC
    import NOCK

    claim [constant]: <k> nock([_:Noun 1 N:Noun]) => N ... </k> // Passes

    claim [increment]: <k> nock([N:Int 4 0 1]) => N +Int 1 ... </k> // Passes

    claim [extend-1]: <k> // Passes
        nock([SUBJECT:Noun 8 [1 0] G:Noun]) => *[[0 SUBJECT] G]
        ... </k>

    claim [if-then]: <k> // Passes
        nock([[0 SUBJ:Noun] 6 [0 2] [7 [0 3] A:Noun] _:Noun]) => *[SUBJ A]
        ... </k>

    claim [if-else]: <k> // Passes
        nock([[1 SUBJ:Noun] 6 [0 2] _:Noun [7 [0 3] B:Noun]]) => *[SUBJ B]
        ... </k>

    claim [extend-2]: <k> // Passes
        nock([SUBJECT:Noun [8 [1 0] [8 [1 BODY:Noun] 9 2 [0 1]]]])
        // If you execute to Bottom, depth 50, you will see the correct result.
     // => Bottom
        => *[[BODY 0 SUBJECT] BODY]
        ... </k>

    claim [extend-3]: <k> // Passes
        *[[BODY:Noun 0 SUBJECT:Noun] 9 2 0 1]
        => *[*[[BODY 0 SUBJECT] 0 1] *[[BODY 0 SUBJECT] 0 2]]
        ... </k>

endmodule
