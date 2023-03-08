import sys
from argparse import ArgumentParser, Namespace
from pathlib import Path
from typing import Any, Optional

from pyk.cli_utils import dir_path, file_path
from pyk.kbuild import KBuild, Package

from . import KNock


def main() -> None:
    args = vars(_parse_args())

    if args['command'] == 'run':
        exec_run(**args)

    else:
        raise AssertionError()


def exec_run(
    program_file: Path,
    depth: Optional[int],
    llvm_dir: Optional[Path],
    kbuild_dir: Optional[Path],
    **kwargs: Any,
) -> None:
    llvm_dir = _ensure_llvm_dir(llvm_dir, kbuild_dir)
    knock = KNock(llvm_dir=llvm_dir)
    res = knock.run(program_file, depth=depth)
    sys.stdout.write(res)
    sys.stdout.flush()


def _ensure_llvm_dir(llvm_dir: Optional[Path], kbuild_dir: Optional[Path]) -> Path:
    if llvm_dir:
        return llvm_dir

    kbuild = KBuild(kbuild_dir)
    package = Package.create('kbuild.toml')
    return kbuild.kompile(package, 'llvm')


def _parse_args() -> Namespace:
    parser = ArgumentParser(description='KNock - Nock semantics in K')
    parser.add_argument('--llvm-dir', metavar='DIR', type=dir_path, help='path to LLVM definition directory')
    parser.add_argument('--haskell-dir', metavar='DIR', type=dir_path, help='path to HASKELL definition directory')
    parser.add_argument('--kbuild-dir', metavar='DIR', type=Path, help='path to HASKELL definition directory')

    command_parser = parser.add_subparsers(dest='command', metavar='COMMAND', required=True)

    run_parser = command_parser.add_parser('run', help='run Nock program')
    run_parser.add_argument('program_file', metavar='FILE', type=file_path, help='path to Nock program to run')
    run_parser.add_argument('--depth', metavar='DEPTH', type=int, help='execution depth')

    return parser.parse_args()


if __name__ == '__main__':
    main()
