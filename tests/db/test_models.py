import pytest
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from emptyproject.db.models import Base, Settings, Casinos, ResourceStrings

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
    new_setting = Settings(Name="Test Setting", PValue="Test Value", PBoolean=True)
    db_session.add(new_setting)
    db_session.commit()

    result = db_session.query(Settings).filter_by(Name="Test Setting").first()
    assert result is not None
    assert result.PValue == "Test Value"
    assert result.PBoolean is True

def test_casinos_table(db_session):
    new_casino = Casinos(Name="Test Casino", Online=True, DZS_ID=123)
    db_session.add(new_casino)
    db_session.commit()

    result = db_session.query(Casinos).filter_by(Name="Test Casino").first()
    assert result is not None
    assert result.Online is True
    assert result.DZS_ID == 123

def test_resource_strings_table(db_session):
    new_resource_string = ResourceStrings(Ref="Test Ref", EN="English", DE="German", FR="French", IT="Italian")
    db_session.add(new_resource_string)
    db_session.commit()

    result = db_session.query(ResourceStrings).filter_by(Ref="Test Ref").first()
    assert result is not None
    assert result.EN == "English"
    assert result.DE == "German"
    assert result.FR == "French"
    assert result.IT == "Italian"