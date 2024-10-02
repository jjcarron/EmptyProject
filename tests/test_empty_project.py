"""
Unit tests for the empty_project module.

This module contains unit tests for various functions and classes in the empty_project module.
"""
import argparse
from unittest.mock import patch

import pytest
from empty_project import set_project_database


@pytest.fixture
def mock_arguments():
    """
    Fixture to provide mock arguments for the tests.

    Returns:
        argparse.Namespace: A namespace object with mock arguments.
    """
    return argparse.Namespace(
        command='create',
        database='test.db',
        database_type='sqlite',
        language='en',
        operation='LB',
        excel_file='test.xlsx',
        debug=True
    )


@pytest.fixture
@patch('empty_project.project')
@patch('empty_project.get_uri_str')
@patch('empty_project.ThisDB')
def test_set_project_database(
        mock_thisdb,
        mock_get_uri_str,
        mock_project,
        mock_args):
    """
    Test the set_project_database function.

    Args:
        mock_thisdb (MagicMock): Mock for ThisDB class.
        mock_get_uri_str (MagicMock): Mock for get_uri_str function.
        mock_project (MagicMock): Mock for project module.
        mock_args (argparse.Namespace): Mock arguments.

    Asserts:
        The function calls the expected methods with the correct arguments.
    """
    mock_get_uri_str.return_value = 'sqlite:///test.db'
    mock_project.get_connection_uri.return_value = 'sqlite:///test.db'

    set_project_database(mock_args)

    mock_get_uri_str.assert_called_once_with('sqlite')
    mock_project.get_connection_uri.assert_called_once_with(
        'sqlite:///test.db')
    mock_project.get_connection_uri.assert_called_once_with(
        'sqlite:///test.db')
    mock_thisdb.assert_called_once_with('sqlite:///test.db')
    mock_project.set_this_db.assert_called_once()


@patch('empty_project.argparse.ArgumentParser.parse_args')
def test_main_create(
        mock_parse_args):
    """
    Test the main function with the 'create' command.

    Args:
        mock_parse_args (MagicMock): Mock for ArgumentParser.parse_args method.

    Asserts:
        The function calls the expected methods with the correct arguments.
    """
    mock_parse_args.return_value = argparse.Namespace(
        command='create',
        database='test.db',
        database_type='sqlite',
        language='en',
        operation='LB',
        excel_file='test.xlsx',
        debug=True
    )
