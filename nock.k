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

    rule /[1 A]:Noun       => A [priority(50)]
    rule /[2  A _B]:Noun   => A [priority(50)]
    rule /[3 _A  B]:Noun   => B [priority(50)]
    rule /[A' :Int B]:Noun => /[2 /[A'  /Int 2 B]] requires A' modInt 2  ==Int 0 [priority(51)]
    rule /[A'':Int B]:Noun => /[3 /[A'' /Int 2 B]] requires A'' modInt 2 =/=Int 0 [priority(51)]
    rule /_A:Noun          => Bottom [owise]

    rule *[A [B C] D]:Noun => [*[A B C] *[A D]]

    rule *[ A 0 B]:Noun   => /[B A]
    rule *[_A 1 B]:Noun   => B
    rule *[ A 2 B C]:Noun => *[*[A B] *[A C]]
    rule *[ A 3 B]:Noun   => wut *[A B]
    rule *[_A 4 B]:Noun   => +B
    rule *[ A 5 B C]:Noun => =[*[A B] *[A C]]

    // Derived rules
    // The rules for / lead to an infinite loop.
    // /[2 a] = /[(1 + 1)     a] => /[2 /[1 a]] => /[2 a] => ...
    // /[3 a] = /[(1 + 1 + 1) a] => /[3 /[1 a]] => /[3 a] => ...
    // Note that the rules for /[2 A B] and /[3 A B] do *not* apply, not even in the writte nock spec.
    rule /[2 _A:Int] => Bottom
    rule /[3 _A:Int] => Bottom

endmodule
