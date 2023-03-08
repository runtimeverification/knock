#!/bin/bash
set -euxo pipefail


function run {
    kompile k-src/nock.k
    input="$1"; shift
    python3 src/knock/parser.py $input > $input.pre-parsed
    krun $input.pre-parsed "$@"
}

function prove {
    kompile k-src/nock.k --backend haskell
    input="$1"; shift

    kprove $input "$@" --haskell-backend-command "kore-exec --disable-stuck-check"
}

run_command="$1" ; shift

case $run_command in
    run    ) run     "$@" ;;
    prove  ) prove   "$@" ;;
    *      ) echo "Unknown command $run_command" ;;
esac




