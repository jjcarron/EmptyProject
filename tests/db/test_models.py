import pytest
from db.models import Base, Casinos, ResourceStrings, Settings
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

# Create an in-memory SQLite database for testing
DATABASE_URL = "sqlite:///:memory:"


@pytest.fixture(scope='module')
def engine():
    return create_engine(DATABASE_URL)


@pytest.fixture(scope='module')
def tables(engine):
    Base.metadata.create_all(engine)
    yield
    Base.metadata.drop_all(engine)


@pytest.fixture(scope='function')
def db_session(engine, tables):
    connection = engine.connect()
    transaction = connection.begin()
    Session = sessionmaker(bind=connection)
    session = Session()

    yield session

    session.close()
    transaction.rollback()
    connection.close()


def test_settings_table(db_session):
    new_setting = Settings(
        key="Test Setting",
        p_value="Test Value",
        p_bool=True)
    db_session.add(new_setting)
    db_session.commit()

    result = db_session.query(Settings).filter_by(key="Test Setting").first()
    assert result is not None
    assert result.p_value == "Test Value"
    assert result.p_bool is True


def test_casinos_table(db_session):
    new_casino = Casinos(name="Test Casino", online=True, dzs_id=123)
    db_session.add(new_casino)
    db_session.commit()

    result = db_session.query(Casinos).filter_by(name="Test Casino").first()
    assert result is not None
    assert result.online is True
    assert result.dzs_id == 123


def test_resource_strings_table(db_session):
    new_resource_string = ResourceStrings(
        key="Test key",
        en="English",
        de="German",
        fr="French",
        it="Italian")
    db_session.add(new_resource_string)
    db_session.commit()

    result = db_session.query(ResourceStrings).filter_by(
        key="Test key").first()
    assert result is not None
    assert result.en == "English"
    assert result.de == "German"
    assert result.fr == "French"
    assert result.it == "Italian"
