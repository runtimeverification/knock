from itertools import count
from typing import Final

import pytest

from knock.parser import preprocess

PREPROCESS_TEST_DATA: Final = (('[1 2]', '[1 2]'),)


@pytest.mark.parametrize(('text', 'expected'), PREPROCESS_TEST_DATA, ids=count())
def test_preprocess(text: str, expected: str) -> None:
    # When
    actual = preprocess(text)

    # Then
    assert actual == expected
