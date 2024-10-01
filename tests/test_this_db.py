import pytest
from unittest.mock import MagicMock, patch
from emptyproject.this_db import ThisDB

@pytest.fixture
def mock_core_db():
    with patch('emptyproject.this_db.CoreDB', autospec=True) as mock_core_db:
        yield mock_core_db

@pytest.fixture
def this_db(mock_core_db):
    return ThisDB('sqlite:///:memory:')

def test_init(this_db):
    assert isinstance(this_db, ThisDB)

def test_update_criterion_fk(this_db):
    this_db.update_criterion_fk = MagicMock()
    this_db.update_criterion_fk()
    this_db.update_criterion_fk.assert_called_once()

def test_update_casino_fk(this_db):
    this_db.update_casino_fk = MagicMock()
    this_db.update_casino_fk()
    this_db.update_casino_fk.assert_called_once()

def test_update_all_fk(this_db):
    this_db.update_all_fk = MagicMock()
    this_db.update_all_fk()
    this_db.update_all_fk.assert_called_once()

def test_update_crossview_infos(this_db):
    this_db.update_crossview_infos = MagicMock()
    this_db.update_crossview_infos('en')
    this_db.update_crossview_infos.assert_called_once_with('en')

def test_add_annual_computed_exclusions(this_db):
    this_db.add_annual_computed_exclusions = MagicMock()
    this_db.add_annual_computed_exclusions()
    this_db.add_annual_computed_exclusions.assert_called_once()

def test_replace_ref(this_db):
    this_db.replace_ref = MagicMock()
    this_db.replace_ref('old_ref', 'new_ref')
    this_db.replace_ref.assert_called_once_with('old_ref', 'new_ref')