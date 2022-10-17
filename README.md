K framework implementation of the [Nock virtual machine](https://developers.urbit.org/reference/nock/definition).

ISSUES:

- [x] pre-parser fails for programs which already have right-association: `[subject 3 [1 2]]`
- [x] pre-parser fails for programs containing symbolic values other than `subject`: `[a 6 b c d]`

TODO:

- [x] pre-parser: insert explicit brackets to right-associate. `[1 2 3 4]` becomes `[1 [2 [3 [4]]]]`.
- [x] syntax: remove list rules, keep macro rules for simpler rule writing.
- [ ] ~~semantics: complete semantics with `anywhere` rules.~~
- [ ] semantics: implement semantics with ordered evaluation (could perhaps just use `strict` on rules for `/, #, *, +` etc. with `KResult ::= BaseNock` and `BaseNock ::= Int | "[" BaseNock BaseNock "]"`.
- [ ] set up a test harness for all our tests
