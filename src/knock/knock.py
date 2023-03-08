from dataclasses import dataclass
from pathlib import Path
from tempfile import NamedTemporaryFile
from typing import Optional, Union, final

from pyk.cli_utils import check_dir_path, check_file_path
from pyk.ktool.krun import _krun

from .parser import preprocess


@final
@dataclass(frozen=True)
class KNock:
    llvm_dir: Path

    def __init__(self, llvm_dir: Union[str, Path]):
        llvm_dir = Path(llvm_dir)
        check_dir_path(llvm_dir)
        object.__setattr__(self, 'llvm_dir', llvm_dir)

    def run(
        self,
        program_file: Union[str, Path],
        *,
        depth: Optional[int] = None,
        temp_file: Optional[Union[str, Path]] = None
    ) -> str:
        program_file = Path(program_file)
        check_file_path(program_file)

        if temp_file is not None:
            temp_file = Path(temp_file)
            return self._run(program_file, depth, temp_file)

        with NamedTemporaryFile(mode='w') as f:
            temp_file = Path(f.name)
            return self._run(program_file, depth, temp_file)

    def _run(self, program_file: Path, depth: Optional[int], temp_file: Path) -> str:
        temp_file.write_text(preprocess(program_file.read_text()))
        proc_res = _krun(input_file=temp_file, definition_dir=self.llvm_dir, depth=depth)
        return proc_res.stdout
