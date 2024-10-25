from unittest.mock import MagicMock, patch

import pytest
from db.core_db import CoreDB
from db.models import Casinos, ResourceStrings, Settings
from sqlalchemy.orm import Session


@pytest.fixture
def core_db():
    # Use an in-memory SQLite database for testing
    connection_uri = 'sqlite:///:memory:'
    return CoreDB(connection_uri)


def test_get_casinos(core_db):
    mock_session = MagicMock(spec=Session)
    mock_casinos = [Casinos(name="Baden"), Casinos(name="Baden")]
    mock_session.query().all.return_value = mock_casinos

    with patch.object(core_db, 'get_session', return_value=mock_session):
        casinos = core_db.get_casinos()
        assert casinos == mock_casinos
        mock_session.query().all.assert_called_once()


def test_get_casino_name_from_dzs_id(core_db):
    mock_session = MagicMock(spec=Session)
    mock_casino = Casinos(name="Baden")
    mock_session.query().filter().first.return_value = mock_casino

    with patch.object(core_db, 'get_session', return_value=mock_session):
        casino_name = core_db.get_casino_name_from_dzs_id(1)
        assert casino_name == "Baden"
        mock_session.query().filter().first.assert_called_once()


def test_get_casino_count(core_db):
    mock_session = MagicMock(spec=Session)
    mock_session.query().count.return_value = 5

    with patch.object(core_db, 'get_session', return_value=mock_session):
        count = core_db.get_casino_count()
        assert count == 5
        mock_session.query().count.assert_called_once()


def test_get_online_casino_count(core_db):
    mock_session = MagicMock(spec=Session)
    mock_session.query().filter().count.return_value = 3

    with patch.object(core_db, 'get_session', return_value=mock_session):
        count = core_db.get_online_casino_count()
        assert count == 3
        mock_session.query().filter().count.assert_called_once()


def test_get_settings(core_db):
    mock_session = MagicMock(spec=Session)
    mock_settings = [Settings(key="setting1"), Settings(key="setting2")]
    mock_session.query().all.return_value = mock_settings

    with patch.object(core_db, 'get_session', return_value=mock_session):
        settings = core_db.get_settings()
        assert settings == mock_settings
        mock_session.query().all.assert_called_once()


def test_get_resource_strings(core_db):
    mock_session = MagicMock(spec=Session)
    mock_resource_strings = [
        ResourceStrings(
            key="string1"), ResourceStrings(
            key="string2")]
    mock_session.query().all.return_value = mock_resource_strings

    with patch.object(core_db, 'get_session', return_value=mock_session):
        resource_strings = core_db.get_resource_strings()
        assert resource_strings == mock_resource_strings
        mock_session.query().all.assert_called_once()
