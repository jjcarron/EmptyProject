import pytest
from db.crud import CRUDRepository
from sqlalchemy import Column, Integer, String, create_engine
from sqlalchemy.orm import declarative_base, sessionmaker

Base = declarative_base()

# Define a sample model for testing


class SampleModel(Base):
    __tablename__ = 'sample_model'
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, index=True)


# Create an in-memory SQLite database for testing
DATABASE_URL = "sqlite:///:memory:"
engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Create the tables in the database
Base.metadata.create_all(bind=engine)


@pytest.fixture
def db_session():
    session = SessionLocal()
    yield session
    session.close()


def test_create(db_session):
    repo = CRUDRepository(SampleModel)
    new_obj = SampleModel(name="Test name")
    created_obj = repo.create(db_session, new_obj)
    assert created_obj.id is not None
    assert created_obj.name == "Test name"


def test_get(db_session):
    repo = CRUDRepository(SampleModel)
    new_obj = SampleModel(name="Test name")
    created_obj = repo.create(db_session, new_obj)
    fetched_obj = repo.get(db_session, SampleModel, created_obj.id)
    assert fetched_obj is not None
    assert fetched_obj.id == created_obj.id
    assert fetched_obj.name == "Test name"


def test_get_all(db_session):
    repo = CRUDRepository(SampleModel)
    new_obj1 = SampleModel(name="Test name 1")
    new_obj2 = SampleModel(name="Test name 2")
    repo.create(db_session, new_obj1)
    repo.create(db_session, new_obj2)
    all_objs = repo.get_all(db_session, SampleModel)
    assert len(all_objs) == 2


def test_update(db_session):
    repo = CRUDRepository(SampleModel)
    new_obj = SampleModel(name="Old name")
    created_obj = repo.create(db_session, new_obj)
    updated_obj = repo.update(
        db_session, SampleModel, created_obj.id, {
            "name": "New name"})
    assert updated_obj is not None
    assert updated_obj.name == "New name"


def test_delete(db_session):
    repo = CRUDRepository(SampleModel)
    new_obj = SampleModel(name="Test name")
    created_obj = repo.create(db_session, new_obj)
    deleted_obj = repo.delete(db_session, SampleModel, created_obj.id)
    assert deleted_obj is not None
    assert repo.get(db_session, SampleModel, created_obj.id) is None

    def test_check_constraints_unique(db_session):
        repo = CRUDRepository(SampleModel)
        new_obj1 = SampleModel(name="Unique name")
        repo.create(db_session, new_obj1)

        new_obj2 = SampleModel(name="Unique name")
        assert not repo.check_constraints(db_session, new_obj2)

    def test_check_constraints_no_violation(db_session):
        repo = CRUDRepository(SampleModel)
        new_obj1 = SampleModel(name="Unique name 1")
        repo.create(db_session, new_obj1)

        new_obj2 = SampleModel(name="Unique name 2")
        assert repo.check_constraints(db_session, new_obj2)
