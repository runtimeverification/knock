#!/bin/bash
set -euxo pipefail

function prove {
    input="$1"; shift
    defn_dir=$(kbuild kompile haskell)
    kprove $input --definition $defn_dir "$@" --haskell-backend-command "kore-exec --disable-stuck-check"
}

run_command="$1" ; shift

case $run_command in
    prove  ) prove   "$@" ;;
    *      ) echo "Unknown command $run_command" ;;
esac
