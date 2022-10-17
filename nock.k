module NOCK-SYNTAX
    import BOOL
    import INT-SYNTAX

    syntax Noun ::= Int | "[" Noun Noun "]" [prefer]

    // For quick "symbolic" execution, placeholders
    syntax Noun ::= "subject" | "a" | "b" | "c" | "d"

endmodule

module NOCK-ABSTRACT-SYNTAX
    import NOCK-SYNTAX

    syntax Nock ::= Noun | "[" Nock Nock "]" [seqstrict]
    syntax KResult ::= Noun

    syntax Nock ::= nock(Nock)
    syntax Nock ::= "wut" Nock [strict] // ? has significance in K, so we must replace it.
                  | "+" Nock   [strict]
                  | "=" Nock   [strict]
                  | "/" Nock   [strict]
                  | "#" Nock   [strict]
                  | "*" Nock   [strict]
                  | "Bottom"

    // Sugar for writing rules.
    // This only helps with rule-writing.
    // Program input still needs to be properly associated, i.e. [1 [2 3]] not [1 2 3].
    syntax Noun ::= "[" Noun Noun Noun "]"                      [macro-rec, prefer]
                  | "[" Noun Noun Noun Noun "]"                 [macro-rec, prefer]
                  | "[" Noun Noun Noun Noun Noun "]"            [macro-rec, prefer]
                  | "[" Noun Noun Noun Noun Noun Noun "]"       [macro-rec, prefer]
                  | "[" Noun Noun Noun Noun Noun Noun Noun "]"  [macro-rec, prefer]
    syntax Nock ::= "[" Nock Nock Nock "]"                      [macro-rec]
                  | "[" Nock Nock Nock Nock "]"                 [macro-rec]
                  | "[" Nock Nock Nock Nock Nock "]"            [macro-rec]
                  | "[" Nock Nock Nock Nock Nock Nock "]"       [macro-rec]
                  | "[" Nock Nock Nock Nock Nock Nock Nock "]"  [macro-rec]
 // -----------------------------------------------------------------------
    rule [ N1 N2 N3             ]:Noun => [ N1 [ N2 N3             ] ]
    rule [ N1 N2 N3 N4          ]:Noun => [ N1 [ N2 N3 N4          ] ]
    rule [ N1 N2 N3 N4 N5       ]:Noun => [ N1 [ N2 N3 N4 N5       ] ]
    rule [ N1 N2 N3 N4 N5 N6    ]:Noun => [ N1 [ N2 N3 N4 N5 N6    ] ]
    rule [ N1 N2 N3 N4 N5 N6 N7 ]:Noun => [ N1 [ N2 N3 N4 N5 N6 N7 ] ]

    rule [ N1 N2 N3             ]:Nock => [ N1 [ N2 N3             ] ]
    rule [ N1 N2 N3 N4          ]:Nock => [ N1 [ N2 N3 N4          ] ]
    rule [ N1 N2 N3 N4 N5       ]:Nock => [ N1 [ N2 N3 N4 N5       ] ]
    rule [ N1 N2 N3 N4 N5 N6    ]:Nock => [ N1 [ N2 N3 N4 N5 N6    ] ]
    rule [ N1 N2 N3 N4 N5 N6 N7 ]:Nock => [ N1 [ N2 N3 N4 N5 N6 N7 ] ]

endmodule

module NOCK
    import NOCK-ABSTRACT-SYNTAX
    import INT

    configuration <k> nock($PGM:Noun) </k>

    // When a nock tree has been fully evaluated, it is a noun.
    rule [NN:Noun NN':Noun]::Nock => [NN NN']::Noun

    rule nock(A) => *A
    rule wut [_A _B]:Noun => 0 [priority(50)]
    rule wut _A:Noun      => 1 [priority(51)]
    rule +[_A _B]:Noun    => Bottom
    rule +A:Int           => A +Int 1
    rule =[ A  A]:Noun    => 0 [priority(50)]
    rule =[_A _B]:Noun    => 1 [priority(51)]

    rule /[1 A]:Noun       => A [priority(50)]
    rule /[2  A _B]:Noun   => A [priority(50)]
    rule /[3 _A  B]:Noun   => B [priority(50)]
    rule /[A' :Int B]:Noun => /[2 /[A'  /Int 2 B]] requires A'  modInt 2  ==Int 0 [priority(51)]
    rule /[A'':Int B]:Noun => /[3 /[A'' /Int 2 B]] requires A'' modInt 2 =/=Int 0 [priority(51)]
    rule /_A:Noun          => Bottom [owise]

    rule #[1 A _B]:Noun    => A [priority(50)]
    rule #[A' B C]:Noun    => #[A'  /Int 2 [B /[A' +Int 1 C]]  C] requires A'  modInt 2  ==Int 0 [priority(51)]
    rule #[A'' B C]:Noun   => #[A'' /Int 2 [/[A'' -Int 1 C] B] C] requires A'' modInt 2 =/=Int 0 [priority(51)]
    rule #(_A:Noun)        => Bottom [owise] // TODO: Could this rule be removed? I can't think of a single way to reach this instruction. The hax Nock is always introduced by rule 10, which always gives two "arguments" in the tail. And we match on the first number being 1, or even, or odd. There are no more cases to be concerned with. The slot operator will reach Bottom in cases when the indicated location is not in the tree.

    rule *[A [B C] D]:Noun => [*[A B C] *[A D]]

    rule *[ A 0  B]:Noun   => /[B A]
    rule *[_A 1  B]:Noun   => B
    rule *[ A 2  B C]:Noun => *[*[A B] *[A C]]
    rule *[ A 3  B]:Noun   => wut *[A B]
    rule *[ A 4  B]:Noun   => +*[A B]
    rule *[ A 5  B C]:Noun => =[*[A B] *[A C]]

    rule *[ A 6 B C D]:Noun    => *[A *[[C D] 0 *[[2 3] 0 *[A 4 4 B]]]]
    rule *[A 7 B C]:Noun       => *[*[A B] C]
    rule *[A 8 B C]:Noun       => *[[*[A B] A] C]
    rule *[A 9 B C]:Noun       => *[*[A C] 2 [0 1] 0 B]
    rule *[A 10 [B C] D]:Noun  => #[B *[A C] *[A D]]

    rule *[A 11 [_B C] D]:Noun => *[[*[A C] *[A D]] 0 3]
    rule *[A 11 _B C]:Noun     => *[A C]

    rule *_A => Bottom [owise]

    // Derived rules.
    // ==============

    // These rules for / lead to an infinite loop.

    // /[0 a] => /[2 /[0 a]] => /[2 /[2 /[0 a]]] => ...
    rule /[0 _A:Noun] => Bottom [priority(50)]

    // /[2 a] = /[(1 + 1)     a] => /[2 /[1 a]] => /[2 a] => ...
    // /[3 a] = /[(1 + 1 + 1) a] => /[3 /[1 a]] => /[3 a] => ...
    // Note that the rules for /[2 A B] and /[3 A B] do *not* apply, not even in the writte nock spec.
    rule /[2 _A:Int]  => Bottom [priority(50)]
    rule /[3 _A:Int]  => Bottom [priority(50)]

endmodule
