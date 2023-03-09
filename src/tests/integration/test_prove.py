from pathlib import Path
from typing import Final

import pytest

from knock import KNock

from ..utils import TEST_DATA_DIR

PROVE_DIR: Final = (TEST_DATA_DIR / 'proofs').resolve(strict=True)
PROVE_FILES: Final = list(PROVE_DIR.glob('*.k'))


@pytest.mark.parametrize('spec_file', PROVE_FILES, ids=[file.name for file in PROVE_FILES])
def test_prove(knock: KNock, spec_file: Path) -> None:
    # When
    knock.prove(spec_file)
