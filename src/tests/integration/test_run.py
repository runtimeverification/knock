from pathlib import Path
from typing import Final

import pytest

from knock import KNock

from ..utils import TEST_DATA_DIR

RUN_FILES: Final = tuple(TEST_DATA_DIR.glob('*.nock'))
RUN_EXCLUDE: Final = {'prog.nock'}


@pytest.mark.parametrize('program_file', RUN_FILES, ids=[file.name for file in RUN_FILES])
def test_run(knock: KNock, program_file: Path, tmp_path: Path) -> None:
    # Given
    temp_file = tmp_path / 'preprocessed'

    # When
    if program_file.name in RUN_EXCLUDE:
        pytest.skip()

    knock.run(program_file, temp_file=temp_file)
