#!/bin/bash
set -euxo pipefail


function run {
    kompile nock.k
    input="$1"; shift
    python3 parser.py $input > $input.pre-parsed
    krun $input.pre-parsed "$@"
}

function prove {
    kompile nock.k --backend haskell
    input="$1"; shift

    kprove $input "$@"
}

run_command="$1" ; shift

case $run_command in
    run    ) run     "$@" ;;
    prove  ) prove   "$@" ;;
    *      ) echo "Unknown command $run_command" ;;
esac




