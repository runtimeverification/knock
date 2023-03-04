K framework implementation of the [Nock virtual machine](https://developers.urbit.org/reference/nock/definition).

# Installing

It's easiest to install K and keep it up to date using the `kup` tool.

Intall `kup`:
```
$ bash <(curl https://kframework.org/install)
```

Install K:

```
$ kup install k
$ kprove --version
```

# Running

KNock accepts a single noun which already contains the subject and evaluates it.
So for example, `tests/inc3.nock`:

```
[42 4 0 1]
```

Running:

```
$ ./knock.sh run tests/inc3.nock
<k>
  43 ~> .
</k>
```

To only execute a few steps you can use the `--depth` flag, which will decide how many steps the executino will take.
Not that these are steps in K, which are not exactly the same as number of Nock reductions.

```
$ ./knock.sh run tests/inc3.nock --depth 2
<k>
  + * [ 42 [ 0 1 ] ] ~> .
</k>
```

# Proving

```
$ ./knock.sh prove tests/proofs/basic-spec.k
```

An example with a loop:

```
$ ./knock.sh prove tests/proofs/decrement-spec.k
```

You can specify a claim with the `--claims` flag instead of running all claims in a file.

```
$ ./knock.sh prove tests/proofs/basic-spec.k --claims BASIC-SPEC.increment,BASIC-SPEC.constant
```

Once again, you can stop exectuion after some number of steps with `--depth`.

```
$ ./knock.sh prove tests/proofs/basic-spec.k --claims BASIC-SPEC.increment --depth 2
<k>
  + * [ N:Int [ 0 1 ] ] ~> _DotVar1 ~> .
</k>
[Error] Prover: backend terminated because the configuration cannot be
rewritten further. See output for more details.
```

# ISSUES:

- [x] pre-parser fails for programs which already have right-association: `[subject 3 [1 2]]`
- [x] pre-parser fails for programs containing symbolic values other than `subject`: `[a 6 b c d]`

# TODO:

- [x] set up prover
- [x] pre-parser: insert explicit brackets to right-associate. `[1 2 3 4]` becomes `[1 [2 [3 [4]]]]`.
- [x] syntax: remove list rules, keep macro rules for simpler rule writing.
- [ ] ~~semantics: complete semantics with `anywhere` rules.~~
- [x] semantics: implement semantics with ordered evaluation (could perhaps just use `strict` on rules for `/, #, *, +` etc. with `KResult ::= BaseNock` and `BaseNock ::= Int | "[" BaseNock BaseNock "]"`.
- [ ] set up a test harness for all our tests
- [ ] Do a `.*`-like implementation, where the subject is supplied together with a program.
- [ ] Don't compile semantics every time, make a sensible build setup.
- [ ] Set up KCFG
