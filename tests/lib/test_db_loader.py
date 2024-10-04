from unittest.mock import MagicMock, patch

import pytest
from sqlalchemy.exc import SQLAlchemyError

from lib.db_loader import DatabaseLoader


@pytest.fixture
def db_loader():
    return DatabaseLoader(db_type='sqlite')


def test_get_uri_str_sqlite(db_loader):
    assert db_loader.get_uri_str() == 'sqlite_uri'


def test_get_uri_str_access():
    db_loader = DatabaseLoader(db_type='access')
    assert db_loader.get_uri_str() == 'access_uri'


def test_get_uri_str_invalid():
    db_loader = DatabaseLoader(db_type='invalid')
    assert db_loader.get_uri_str() is None


@patch('lib.db_loader.log')
def test_load_all_sheets(mock_log, db_loader):
    mock_cls = MagicMock()
    mock_xl = mock_cls.return_value
    mock_xl.load_data = MagicMock()
    post_processing = MagicMock()

    db_loader.load_all_sheets(mock_cls, 'test.xlsx', post_processing)

    mock_cls.assert_called_once_with('test.xlsx')
    mock_xl.load_data.assert_called_once()
    post_processing.assert_called_once()
    mock_log.info.assert_any_call("Loading %s ...", 'test.xlsx')
    mock_log.info.assert_any_call("%s Loaded.\n", 'test.xlsx')


@patch('lib.db_loader.find_files_by_pattern')
@patch('lib.db_loader.DatabaseLoader.load_data')
def test_load_data_from_files(mock_load_data, mock_find_files, db_loader):
    mock_find_files.return_value = ['file1.xlsx', 'file2.xlsx']
    mock_cls = MagicMock()
    tables = ['table1', 'table2']
    pattern = '.*\\.xlsx'
    path = 'some/path'

    db_loader.load_data_from_files(mock_cls, tables, path, pattern)

    mock_find_files.assert_called_once_with(path, pattern, recursive=False)
    assert mock_load_data.call_count == 2


@patch('lib.db_loader.project.get_this_db')
@patch('lib.db_loader.log')
def test_load_data(mock_log, mock_get_this_db, db_loader):
    mock_db = MagicMock()
    mock_session = MagicMock()
    mock_get_this_db.return_value.get_session.return_value = mock_session
    mock_cls = MagicMock()
    mock_xl = mock_cls.return_value
    mock_xl.load_data.return_value = [{'col1': 'val1', 'col2': 'val2'}]
    mock_table_class = MagicMock()
    mock_get_this_db.return_value.get_table_class.return_value = mock_table_class
    mock_crud_repo = MagicMock()
    mock_crud_repo.check_constraints.return_value = True

    with patch('lib.db_loader.CRUDRepository', return_value=mock_crud_repo):
        db_loader.load_data(mock_cls, ['table1'], 'test.xlsx')

    mock_cls.assert_called_once_with('test.xlsx', None)
    mock_xl.load_data.assert_called_once_with('table1')
    mock_get_this_db.return_value.get_table_class.assert_called_once_with(
        'table1')
    mock_crud_repo.check_constraints.assert_called_once()
    mock_session.commit.assert_called_once()
    mock_session.close.assert_called_once()
    mock_log.info.assert_any_call("Loading %s ...", 'test.xlsx')
    mock_log.info.assert_any_call("%s Loaded.\n", 'test.xlsx')


@patch('lib.db_loader.project.get_this_db')
@patch('lib.db_loader.log')
def test_load_data_with_exception(mock_log, mock_get_this_db, db_loader):
    mock_db = MagicMock()
    mock_session = MagicMock()
    mock_get_this_db.return_value.get_session.return_value = mock_session
    mock_cls = MagicMock()
    mock_cls.side_effect = SQLAlchemyError

    with patch('lib.db_loader.CRUDRepository'):
        db_loader.load_data(mock_cls, ['table1'], 'test.xlsx')

    mock_session.rollback.assert_called_once()
    mock_session.close.assert_called_once()
    mock_log.error.assert_called_once()
