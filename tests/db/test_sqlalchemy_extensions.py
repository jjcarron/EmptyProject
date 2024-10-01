import pytest
from sqlalchemy import create_engine, Column, Integer, String, text
from sqlalchemy.orm import sessionmaker, declarative_base
from sqlalchemy.ext.compiler import compiles
from sqlalchemy.sql.functions import FunctionElement
from sqlalchemy.types import String as SQLString
from sqlalchemy.dialects import sqlite
from sqlalchemy.sql import func
from sqlalchemy.sql import compiler
import re

# Define the base for SQLAlchemy models
Base = declarative_base()

# Define the Substr function for SQLAlchemy
class Substr(FunctionElement):
    type = SQLString()

# Register the Substr function for the sqlite dialect
@compiles(Substr, 'sqlite')
def sqlite_compile(element, compiler, **kw):
    return "SUBSTR(%s, %s, %s)" % (
        compiler.process(element.clauses.clauses[0]),  # Process the first argument
        compiler.process(element.clauses.clauses[1]),  # Process the second argument
        compiler.process(element.clauses.clauses[2])   # Process the third argument
    )

# Correctly register Substr as a function in SQLAlchemy's func namespace
func.substr = Substr  # Register the class Substr with func

# Custom identifier preparer to remove quotes
class CustomIdentifierPreparer(compiler.IdentifierPreparer):
    def quote(self, ident, force=None):
        return ident  # Override to prevent quoting

# Create a custom SQLite dialect that doesn't quote identifiers
class CustomSQLiteDialect(sqlite.dialect):
    preparer = CustomIdentifierPreparer

# Define a sample table model for testing
class tbl_Criteria(Base):
    __tablename__ = 'tbl_Criteria'
    id = Column(Integer, primary_key=True)
    Reference = Column(String)

# Create a fixture for the database session
@pytest.fixture(scope='function')
def session():
    # Use SQLite in-memory database for testing
    engine = create_engine('sqlite:///:memory:', echo=True)
    Base.metadata.create_all(engine)  # Create tables

    Session = sessionmaker(bind=engine)
    session = Session()

    # Add sample data
    session.add(tbl_Criteria(Reference='test_string'))
    session.commit()

    yield session

    # Teardown
    session.close()
    Base.metadata.drop_all(engine)

def normalize_sql(sql):
    """ Function to normalize SQL by removing extra spaces and newlines """
    sql = sql.replace('\n', ' ')  # Replace newlines with spaces
    sql = re.sub(r'\s+', ' ', sql)  # Replace multiple spaces with a single space
    return sql.strip()

def test_substr_in_filter(session):
    """ Test Substr function in a filter clause """
    
    # Use a raw SQL string to force the use of literal values in the filter
    query = session.query(tbl_Criteria).filter(
        text("SUBSTR(tbl_Criteria.Reference, 1, 4) = 'test'")
    )
    
    # Print for debugging
    print(f"Generated query object: {query}")
    
    # Compile the query for the custom SQLite dialect without quotes
    compiled_query = query.statement.compile(dialect=CustomSQLiteDialect(), compile_kwargs={"literal_binds": True})
    
    # Normalize the compiled SQL by removing extra spaces and newlines
    normalized_sql = normalize_sql(str(compiled_query))
    
    # Print the compiled SQL for debugging
    print(f"Compiled SQL: {normalized_sql}")
    
    # Expected SQL without placeholders and newlines
    expected_sql = (
        'SELECT tbl_Criteria.id, tbl_Criteria.Reference '
        'FROM tbl_Criteria WHERE SUBSTR(tbl_Criteria.Reference, 1, 4) = \'test\''
    )
    
    print(f"Expected SQL: {expected_sql}")
    print(f"Actual SQL: {normalized_sql}")
    
    # Check that the SQL is what we expect for SQLite
    assert normalized_sql == expected_sql
