from pathlib import Path
from typing import Final

import pytest

from knock.parser import preprocess

from ..utils import TEST_DATA_DIR

PARSER_DIR: Final = (TEST_DATA_DIR / 'parser').resolve(strict=True)
PROGRAM_FILES: Final = tuple(PARSER_DIR.glob('*.nock'))


@pytest.mark.parametrize(
    'program_file',
    PROGRAM_FILES,
    ids=[program_file.name for program_file in PROGRAM_FILES],
)
def test_preprocess(program_file: Path) -> None:
    # Given
    expected = program_file.with_suffix('.golden').read_text()

    # When
    actual = preprocess(program_file.read_text())

    # Then
    assert actual == expected
