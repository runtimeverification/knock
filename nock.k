module NOCK-SYNTAX
    import BOOL
    import INT-SYNTAX

    syntax Noun ::= Int | "[" Noun Noun "]" [prefer]

    // For quick "symbolic" execution, placeholders
    syntax Noun ::= "subject" | "a" | "b" | "c" | "d"

/*
endmodule

module NOCK-ABSTRACT-SYNTAX
    import NOCK-SYNTAX
*/

    syntax Nock ::= Noun | "[" Nock Nock "]" [seqstrict]
    syntax KResult ::= Noun

    syntax Nock ::= nock(Nock)
    syntax Nock ::= "wut" Nock [strict] // ? has significance in K, so we must replace it.
                  | "+" Nock   [strict]
                  | "=" Nock   [strict]
                  | "/" Nock   [strict]
                  | "*" Nock   [strict]
                  | "Bottom"

    // Sugar for writing rules.
    syntax Noun ::= "[" Noun Noun Noun "]"                      [macro]
                  | "[" Noun Noun Noun Noun "]"                 [macro]
                  | "[" Noun Noun Noun Noun Noun "]"            [macro]
                  | "[" Noun Noun Noun Noun Noun Noun "]"       [macro]
                  | "[" Noun Noun Noun Noun Noun Noun Noun "]"  [macro]
 // -------------------------------------------------------------------
    rule [ N1 N2 N3             ] => [ N1 [ N2 N3             ] ]
    rule [ N1 N2 N3 N4          ] => [ N1 [ N2 N3 N4          ] ]
    rule [ N1 N2 N3 N4 N5       ] => [ N1 [ N2 N3 N4 N5       ] ]
    rule [ N1 N2 N3 N4 N5 N6    ] => [ N1 [ N2 N3 N4 N5 N6    ] ]
    rule [ N1 N2 N3 N4 N5 N6 N7 ] => [ N1 [ N2 N3 N4 N5 N6 N7 ] ]

endmodule

module NOCK
    import NOCK-SYNTAX
    import INT

    configuration <k> nock($PGM:Nock) </k>

    // When a nock tree has been fully evaluated, it is a noun.
    rule [ NN:Noun NN':Noun]::Nock => [ NN NN']::Noun

    rule nock(A) => *A
    rule wut [_A _B]:Noun => 0
    rule wut _A:Int       => 1
    rule +[_A _B]:Noun    => Bottom
    rule +A:Int           => A +Int 1
    rule =[ A  A]:Noun    => 0 [priority(50)]
    rule =[_A _B]:Noun    => 1 [priority(51)]

    rule *[A [B C] D]:Noun => [*[A B C] *[A D]]

    rule *[_A 1 B]:Noun   => B
    rule *[ A 2 B C]:Noun => *[*[A B] *[A C]]
    rule *[ A 3 B]:Noun   => wut *[A B]
    rule *[_A 4 B]:Noun   => +B
    rule *[ A 5 B C]:Noun => =[*[A B] *[A C]]

endmodule
