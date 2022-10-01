#!/bin/bash
set -eu

input="$1"
python3 parser.py $input > $input.pre-parsed
krun $input.pre-parsed

