from pathlib import Path
from typing import Final

import pytest

from knock import KNock

from ..utils import TEST_DATA_DIR

PARSE_FILES: Final = tuple(TEST_DATA_DIR.rglob('*.nock'))


@pytest.mark.parametrize('program_file', PARSE_FILES, ids=[file.name for file in PARSE_FILES])
def test_run(knock: KNock, program_file: Path, tmp_path: Path) -> None:
    # Given
    temp_file = tmp_path / 'preprocessed'

    # When
    knock.parse(program_file, temp_file=temp_file)
