from argparse import ArgumentParser, Namespace
from pathlib import Path
from typing import Any, List, Optional

from pyk.cli_utils import dir_path, file_path
from pyk.kbuild import KBuild, Package
from pyk.ktool.kprint import KAstOutput

from . import KNock


def main() -> None:
    args = vars(_parse_args())

    if args['command'] == 'parse':
        exec_parse(**args)

    elif args['command'] == 'run':
        exec_run(**args)

    elif args['command'] == 'prove':
        exec_prove(**args)

    else:
        raise AssertionError()


def exec_parse(
    program_file: Path,
    output: Optional[KAstOutput],
    **kwargs: Any,
) -> None:
    knock = _knock(**kwargs)
    res = knock.parse(program_file, output=output)
    print(res, end='')


def exec_run(
    program_file: Path,
    depth: Optional[int],
    **kwargs: Any,
) -> None:
    knock = _knock(**kwargs)
    res = knock.run(program_file, depth=depth)
    print(res, end='')


def exec_prove(
    spec_file: Path,
    depth: Optional[int],
    **kwargs: Any,
) -> None:
    knock = _knock(**kwargs)
    res = knock.prove(spec_file, depth=depth)
    print(res, end='')


def _knock(
    llvm_dir: Optional[Path],
    haskell_dir: Optional[Path],
    kbuild_dir: Optional[Path],
    **kwargs: Any,
) -> KNock:
    llvm_dir = _ensure_target(llvm_dir, kbuild_dir, 'llvm')
    haskell_dir = _ensure_target(haskell_dir, kbuild_dir, 'haskell')
    return KNock(llvm_dir=llvm_dir, haskell_dir=haskell_dir)


def _ensure_target(definition_dir: Optional[Path], kbuild_dir: Optional[Path], target: str) -> Path:
    if definition_dir:
        return definition_dir

    kbuild = KBuild(kbuild_dir)
    package = Package.create('kbuild.toml')
    return kbuild.kompile(package, target)


def _parse_args() -> Namespace:
    def list_of_str(text: str) -> List[str]:
        return text.split(',')

    parser = ArgumentParser(description='KNock - Nock semantics in K')
    parser.add_argument('--llvm-dir', metavar='DIR', type=dir_path, help='path to LLVM definition directory')
    parser.add_argument('--haskell-dir', metavar='DIR', type=dir_path, help='path to HASKELL definition directory')
    parser.add_argument('--kbuild-dir', metavar='DIR', type=Path, help='path to HASKELL definition directory')

    command_parser = parser.add_subparsers(dest='command', metavar='COMMAND', required=True)

    parse_parser = command_parser.add_parser('parse', help='parse Nock program')
    parse_parser.add_argument('program_file', metavar='FILE', type=file_path, help='path to Nock program to parse')
    parse_parser.add_argument('--output', metavar='OUTPUT', type=KAstOutput, help='output format')

    run_parser = command_parser.add_parser('run', help='run Nock program')
    run_parser.add_argument('program_file', metavar='FILE', type=file_path, help='path to Nock program to run')
    run_parser.add_argument('--depth', metavar='DEPTH', type=int, help='execution depth')

    prove_parser = command_parser.add_parser('prove', help='prove specification')
    prove_parser.add_argument('spec_file', metavar='FILE', type=file_path, help='path to specification file to prove')
    prove_parser.add_argument('--depth', metavar='DEPTH', type=int, help='proving depth')
    prove_parser.add_argument(
        '--claims', metavar='CLAIMS', type=list_of_str, help='comma-separated list of labels for claims to prove'
    )

    return parser.parse_args()


if __name__ == '__main__':
    main()
