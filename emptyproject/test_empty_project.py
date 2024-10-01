import pytest
import argparse
from unittest.mock import patch, MagicMock
from emptyproject.empty_project import set_project_database, main

@pytest.fixture
def mock_args():
    return argparse.Namespace(
        command='create',
        database='test.db',
        database_type='sqlite',
        language='EN',
        operation='LB',
        excel_file='test.xlsx',
        debug=True
    )

@patch('emptyproject.empty_project.project')
@patch('emptyproject.empty_project.get_uri_str')
@patch('emptyproject.empty_project.ThisDB')
def test_set_project_database(mock_thisdb, mock_get_uri_str, mock_project, mock_args):
    mock_get_uri_str.return_value = 'sqlite:///test.db'
    mock_project.get_connection_uri.return_value = 'sqlite:///test.db'
    
    set_project_database(mock_args)
    
    mock_get_uri_str.assert_called_once_with('sqlite')
    mock_project.get_connection_uri.assert_called_once_with('sqlite:///test.db')
    mock_thisdb.assert_called_once_with('sqlite:///test.db')
    mock_project.set_this_db.assert_called_once()

@patch('emptyproject.empty_project.argparse.ArgumentParser.parse_args')
@patch('emptyproject.empty_project.check_path')
@patch('emptyproject.empty_project.project')
@patch('emptyproject.empty_project.set_project_database')
@patch('emptyproject.empty_project.DB_Loader')
@patch('emptyproject.empty_project.sys.exit')
def test_main_create(mock_sys_exit, mock_db_loader, mock_set_project_database, mock_project, mock_check_path, mock_parse_args):
    mock_parse_args.return_value = argparse.Namespace(
        command='create',
        database='test.db',
        database_type='sqlite',
        language='EN',
        operation='LB',
        excel_file='test.xlsx',
        debug=True
    )
    mock_check_path.return_value = True
    mock_project.get_this_db.return_value = MagicMock()
    
    main()
    
    mock_check_path.assert_called_once_with('test.db')
    mock_project.set_db_file_path.assert_called_once_with('sqlite', 'test.db')
    mock_set_project_database.assert_called()
    mock_project.get_this_db.assert_called_once()
    mock_db_loader.assert_called_once()
    mock_sys_exit.assert_called_once()

@patch('emptyproject.empty_project.argparse.ArgumentParser.parse_args')
@patch('emptyproject.empty_project.sys.exit')
def test_main_load(mock_sys_exit, mock_parse_args):
    mock_parse_args.return_value = argparse.Namespace(
        command='load',
        database='test.db',
        database_type='sqlite',
        language='EN',
        operation='LB',
        excel_file='test.xlsx',
        debug=True
    )
    
    main()
    
    mock_sys_exit.assert_called_once()

@patch('emptyproject.empty_project.argparse.ArgumentParser.parse_args')
@patch('emptyproject.empty_project.project')
@patch('emptyproject.empty_project.sys.exit')
def test_main_export(mock_sys_exit, mock_project, mock_parse_args):
    mock_parse_args.return_value = argparse.Namespace(
        command='export',
        database='test.db',
        database_type='sqlite',
        language='EN',
        operation='LB',
        excel_file='test.xlsx',
        debug=True
    )
    mock_project.get_this_db.return_value = MagicMock()
    
    main()
    
    mock_project.get_this_db.assert_called_once()
    mock_sys_exit.assert_called_once()