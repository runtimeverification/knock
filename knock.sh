#!/bin/bash
set -euxo pipefail

kompile nock.k

input="$1"
shift
python3 parser.py $input > $input.pre-parsed
krun $input.pre-parsed "$@"

