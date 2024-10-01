from unittest.mock import MagicMock, patch

import pytest
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

    mock_log.info.assert_any_call("Loading %s ...", 'test.xlsx')
    mock_xl.load_data.assert_called_once()
    post_processing.assert_called_once()
    mock_log.info.assert_any_call("%s Loaded.\n", 'test.xlsx')


@patch('lib.db_loader.glob.glob')
@patch('lib.db_loader.DatabaseLoader.load_data')
def test_load_data_from_file(mock_load_data, mock_glob):
    mock_glob.return_value = ['file1.xlsx', 'file2.xlsx']

    db_loader = DatabaseLoader(db_type='sqlite')
    mock_session = MagicMock()
    mock_options = MagicMock()

    db_loader.load_data_from_file(
        mock_session, '*.xlsx', 'table', mock_options)

    mock_load_data.assert_any_call(
        mock_session,
        'file1.xlsx',
        'table',
        mock_options)
    mock_load_data.assert_any_call(
        mock_session,
        'file2.xlsx',
        'table',
        mock_options)


@patch('lib.db_loader.log')
@patch('lib.db_loader.project')
@patch('lib.db_loader.CRUDRepository')
def test_load_data(mock_CRUDRepository, mock_project, mock_log, db_loader):
    mock_cls = MagicMock()
    mock_xl = mock_cls.return_value
    mock_xl.load_data.return_value = [{'Casino': 'Test'}, {'Casino': 'Total'}]
    mock_db = mock_project.get_this_db.return_value
    mock_session = mock_db.get_session.return_value
    mock_table_class = mock_db.get_table_class.return_value
    post_processing = MagicMock()

    db_loader.load_data(mock_cls, 'test.xlsx', 'table', post_processing)

    mock_log.info.assert_any_call("Loading %s ...", 'test.xlsx')
    mock_xl.load_data.assert_called_once()
    mock_CRUDRepository.create.assert_any_call(
        mock_session, mock_table_class.return_value)
    assert mock_CRUDRepository.create.call_count == 2
