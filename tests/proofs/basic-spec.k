module BASIC-SPEC
    import NOCK

    claim [constant]: <k> nock([_:Noun 1 N:Noun]) => N ... </k> // Passes

    claim [increment]: <k> nock([N:Int 4 0 1]) => N +Int 1 ... </k> // Passes

    claim [extend]: <k>
        nock([SUBJECT:Noun [8 [1 0] G:Noun]]) => *[[0 SUBJECT] G]
        ... </k> // Passes

endmodule
