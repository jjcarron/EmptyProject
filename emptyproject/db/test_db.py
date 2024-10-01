import pytest
from sqlalchemy import create_engine, MetaData
from sqlalchemy.orm import sessionmaker, Session, scoped_session
from db.db import Database
from db.models import Base
from unittest.mock import patch, MagicMock

@pytest.fixture(scope='module')
def db():
    # Use an in-memory SQLite database for testing
    connection_uri = 'sqlite:///:memory:'
    db = Database(connection_uri)
    db.init_db()
    yield db
    db.session.remove()

def test_database_initialization(db):
    assert db.get_engine() is not None
    assert db.get_db_type() == 'sqlite'

def test_get_single_session(db):
    session = db.get_single_session()
    assert session is not None

def test_get_engine(db):
    engine = db.get_engine()
    assert engine is not None

def test_get_db_type(db):
    db_type = db.get_db_type()
    assert db_type == 'sqlite'

def test_init_db(db):
    with patch('db.models.Base.metadata.create_all') as mock_create_all:
        db.init_db()
        mock_create_all.assert_called_once_with(db.get_engine())

def test_get_table_class(db):
    # Patch the tables module to include the Casinos class
    table_class = db.get_table_class('ResourceStrings')
    assert table_class.__tablename__ == 'ResourceStrings'

def test_get_table_class_not_found(db):
    with pytest.raises(ValueError):
        db.get_table_class('non_existent_table')

def test_get_session(db):
    session = db.get_session()
    print(f"Session: {session}")
    assert isinstance(session, Session)
    
def test_get_single_session(db):
    session = db.get_session()
    print(f"Session: {session}")
    assert isinstance(session, Session)

def test_get_db_generator(db):
    db_generator = db.get_db_generator()
    session = next(db_generator)
    print(f"Session: {session}")
    assert isinstance(session, Session)
    session.close()
