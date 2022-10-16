module NOCK-SYNTAX
    import BOOL
    import INT-SYNTAX

    syntax Nock ::= Noun | "[" Nock Nock "]" [seqstrict]

    syntax Noun ::= Int | "[" Noun Noun "]" [prefer]
    syntax KResult ::= Noun

    // For quick "symbolic" execution, placeholders
    syntax Nock ::= "subject" | "a" | "b" | "c" | "d"

    // Test: use these as targets for "a" and "b"
    // This way we can check that the "nock-to-noun" rule below works.
    syntax Noun ::= "x" | "y"

endmodule


module NOCK-ABSTRACT-SYNTAX
    import NOCK-SYNTAX

    syntax Nock ::= nock(Nock)
    syntax Nock ::= "*" Nock
    syntax Nock ::= "/" Nock

    // Sugar for writing rules.
    syntax Nock ::= "[" Nock Nock Nock "]"                      [macro]
                  | "[" Nock Nock Nock Nock "]"                 [macro]
                  | "[" Nock Nock Nock Nock Nock "]"            [macro]
                  | "[" Nock Nock Nock Nock Nock Nock "]"       [macro]
                  | "[" Nock Nock Nock Nock Nock Nock Nock "]"  [macro]
 // ---------------------------------------------------------
    rule [ N1 N2 N3             ] => [ N1 [ N2 N3             ] ]
    rule [ N1 N2 N3 N4          ] => [ N1 [ N2 N3 N4          ] ]
    rule [ N1 N2 N3 N4 N5       ] => [ N1 [ N2 N3 N4 N5       ] ]
    rule [ N1 N2 N3 N4 N5 N6    ] => [ N1 [ N2 N3 N4 N5 N6    ] ]
    rule [ N1 N2 N3 N4 N5 N6 N7 ] => [ N1 [ N2 N3 N4 N5 N6 N7 ] ]

endmodule

module NOCK
    import NOCK-SYNTAX

    // When a nock tree has been fully evaluated, it is a noun.
    rule [ NN:Noun NN':Noun]::Nock => [ NN NN']::Noun

    // Test: Check that the "nock-to-noun" rule above works.
    rule a => x
    rule b => y

endmodule

module NOCK-INSTANT
/* This module uses [anywhere] rules to apply instant reductions everywhere, so
 * allows no "stepping". This makes the semantics simpler as no evaluation
 * order is necessary.
*/
    import NOCK-ABSTRACT-SYNTAX
    import INT
    import BOOL

    configuration <k> nock($PGM:Nock) </k>


    rule nock(A)             => *A               [anywhere, priority(1)]

    rule /[1 A]               => A                [anywhere, priority(20)]
    rule /[2 [ A _B]]         => A                [anywhere, priority(21)]
    rule /[3 [_A  B]]         => B                [anywhere, priority(22)]
    rule /[A_LUS_A B]         => /[2 /[A_LUS_A divInt 2 B]]
      requires A_LUS_A modInt 2 ==Int 0
        [anywhere, priority(23)]
    rule /[A_LUS_A_LUS_1 B]    => /[3 /[A_LUS_A_LUS_1 divInt 2 B]]
      requires A_LUS_A_LUS_1 modInt 2 ==Int 1
        [anywhere, priority(24)]

    rule *[A [0 B]]        => /[B A]                [anywhere, priority(40)]
    rule *[_A [1 B]]       => B                     [anywhere, priority(41)]
    rule *[A [2 [B C]]]    => *[*[A B] *[A C]]      [anywhere, priority(42)]
    rule *[A [8 [B C]]]    => *[[*[A B] A] C]       [anywhere, priority(50)]
    rule *[A [9 [B C]]]    => *[*[A C] 2 [0 1] 0 B] [anywhere, priority(49)]

endmodule

