from unittest.mock import Mock, patch

import pytest
from lib.db_loader import \
    DatabaseLoader  # Replace with the correct import path
from sqlalchemy.exc import SQLAlchemyError


# Mock database session and table class
class MockDatabase:
    def get_session(self):
        return MockSession()

    def get_table_class(self, table):
        return MockTableClass


class MockSession:
    def commit(self):
        pass

    def rollback(self):
        pass

    def close(self):
        pass


class MockTableClass:
    def __init__(self, **kwargs):
        pass

# Mock Excel file loader


class MockExcelLoader:
    def __init__(self, xl_file, match=None):
        self.xl_file = xl_file
        self.match = match

    def load_data(self, table=None):
        return [{"column1": "value1", "column2": "value2"}]

# Fixtures


@pytest.fixture
def mock_database():
    return MockDatabase()


@pytest.fixture
def mock_excel_loader():
    return MockExcelLoader

# Tests


def test_database_loader_initialization(mock_database):
    """Test the initialization of DatabaseLoader."""
    loader = DatabaseLoader(mock_database)
    assert loader.database == mock_database


@patch('db_loader.log.info')  # Patching 'log.info' directly
def test_load_all_sheets(mock_log_info, mock_database, mock_excel_loader):
    """Test the load_all_sheets method."""
    loader = DatabaseLoader(mock_database)
    post_processing_mock = Mock()

    loader.load_all_sheets(
        mock_excel_loader,
        "test.xlsx",
        post_processing=post_processing_mock)

    mock_log_info.assert_called()  # Ensure logging happens
    post_processing_mock.assert_called_once()  # Check if post-processing was called


class MockTableClass:
    def __init__(self, **kwargs):
        pass
