# knock

K Framework implementation of the [Nock virtual machine](https://developers.urbit.org/reference/nock/definition).


## Installation

### Installing K

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

### Installing the `knock` Python Package

Prerequsites: `python 3.8.*`, `pip >= 20.0.2`, `poetry >= 1.3.2`.

```bash
make build
pip install dist/*.whl
```


## For Developers

Use `make` to run common tasks (see the [Makefile](Makefile) for a complete list of available targets).

* `make build`: Build wheel
* `make check`: Check code style
* `make format`: Format code
* `make test-unit`: Run unit tests

For interactive use, spawn a shell with `poetry shell` (after `poetry install`), then run an interpreter.


## Running

KNock accepts a single noun which already contains the subject and evaluates it.
So for example, `src/tests/test-data/inc3.nock`:

```
[42 4 0 1]
```

Running:

```
$ knock run src/tests/test-data/inc3.nock
<k>
  43 ~> .
</k>
```

To only execute a few steps you can use the `--depth` flag, which will decide how many steps the executino will take.
Not that these are steps in K, which are not exactly the same as number of Nock reductions.

```
$ knock run src/tests/test-data/inc3.nock --depth 2
<k>
  + * [ 42 [ 0 1 ] ] ~> .
</k>
```


## Proving

```
$ knock prove src/tests/test-data/proofs/basic-spec.k
```

An example with a loop:

```
$ knock prove src/tests/test-data/proofs/decrement-spec.k
```

You can specify a claim with the `--claims` flag instead of running all claims in a file.

```
$ knock prove src/tests/test-data/proofs/basic-spec.k --claims BASIC-SPEC.increment,BASIC-SPEC.constant
```

Once again, you can stop exectuion after some number of steps with `--depth`.

```
$ knock prove src/tests/test-data/proofs/basic-spec.k --claims BASIC-SPEC.increment --depth 2
<k>
  + * [ N:Int [ 0 1 ] ] ~> _DotVar1 ~> .
</k>
[Error] Prover: backend terminated because the configuration cannot be
rewritten further. See output for more details.
```


## ISSUES:

- [x] pre-parser fails for programs which already have right-association: `[subject 3 [1 2]]`
- [x] pre-parser fails for programs containing symbolic values other than `subject`: `[a 6 b c d]`


## TODO:

- [x] set up prover
- [x] pre-parser: insert explicit brackets to right-associate. `[1 2 3 4]` becomes `[1 [2 [3 [4]]]]`.
- [x] syntax: remove list rules, keep macro rules for simpler rule writing.
- [ ] ~~semantics: complete semantics with `anywhere` rules.~~
- [x] semantics: implement semantics with ordered evaluation (could perhaps just use `strict` on rules for `/, #, *, +` etc. with `KResult ::= BaseNock` and `BaseNock ::= Int | "[" BaseNock BaseNock "]"`.
- [ ] set up a test harness for all our tests
- [ ] do a `.*`-like implementation, where the subject is supplied together with a program.
- [ ] don't compile semantics every time, make a sensible build setup.
- [ ] set up KCFG
- [ ] proving help: highlight (with color if possible) the subject, command and tail for *[ubj X tail]. May be enough to always color code the (top level) head, second head, and tail
- [ ] allow arbitrary length cells directly: use List or NeList and parse with macros
- [ ] allow real nock integers: take 12.345.678 and automatically turn it into 12345678
