#!/bin/bash
set -euxo pipefail


function run {
    input="$1"; shift
    defn_dir=$(kbuild kompile llvm)
    python3 src/knock/parser.py $input > $input.pre-parsed
    krun $input.pre-parsed --definition $defn_dir "$@"
}

function prove {
    input="$1"; shift
    defn_dir=$(kbuild kompile haskell)
    kprove $input --definition $defn_dir "$@" --haskell-backend-command "kore-exec --disable-stuck-check"
}

run_command="$1" ; shift

case $run_command in
    run    ) run     "$@" ;;
    prove  ) prove   "$@" ;;
    *      ) echo "Unknown command $run_command" ;;
esac
