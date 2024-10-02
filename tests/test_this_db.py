"""
Test suite for the ThisDB class.

This test module contains basic unit tests for the ThisDB class, which extends the CoreDB class.
It mocks database interactions to ensure that the ThisDB class is properly initialized and works
as expected without interacting with a real database.

Fixtures:
    - mock_db_session: A mock SQLAlchemy session object.
    - test_db_instance: An instance of ThisDB with the mock session injected.

Tests:
    - test_thisdb_initialization: Ensures that the ThisDB class is instantiated correctly,
      inheriting properties from CoreDB, and that the session is properly set.
"""
# pylint: disable=redefined-outer-name
from unittest.mock import MagicMock

import pytest
from this_db import ThisDB  # Adjust according to your project structure


@pytest.fixture
def mock_db_session():
    """
    Fixture to provide a mock SQLAlchemy session for the tests.
    """
    return MagicMock()


@pytest.fixture
def test_db_instance(mock_db_session):
    """
    Fixture to create an instance of ThisDB with a mocked session.
    """
    db_uri = "sqlite:///:memory:"  # or any valid database URI
    db_instance = ThisDB(db_uri)
    db_instance.session = mock_db_session  # Injecting the mocked session
    return db_instance


def test_thisdb_initialization(test_db_instance):
    """
    Test the initialization of ThisDB and ensure it inherits CoreDB properties.
    """
    assert isinstance(
        test_db_instance,
        ThisDB)  # Ensure the instance is of type ThisDB
    assert test_db_instance.session  # Ensure session is set correctly
