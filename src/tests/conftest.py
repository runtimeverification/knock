from pathlib import Path

import pytest
from pyk.kbuild import KBuild, Package
from pytest import TempPathFactory

from knock import KNock


@pytest.fixture(scope='session')
def kbuild_dir(tmp_path_factory: TempPathFactory) -> Path:
    return tmp_path_factory.mktemp('kbuild')


@pytest.fixture(scope='session')
def kbuild(kbuild_dir: Path) -> KBuild:
    return KBuild(kbuild_dir)


@pytest.fixture(scope='session')
def package() -> Package:
    return Package.create('kbuild.toml')


@pytest.fixture(scope='session')
def llvm_dir(kbuild: KBuild, package: Package) -> Path:
    return kbuild.kompile(package, 'llvm')


@pytest.fixture(scope='session')
def haskell_dir(kbuild: KBuild, package: Package) -> Path:
    return kbuild.kompile(package, 'haskell')


@pytest.fixture(scope='session')
def knock(llvm_dir: Path, haskell_dir: Path) -> KNock:
    return KNock(llvm_dir=llvm_dir, haskell_dir=haskell_dir)
