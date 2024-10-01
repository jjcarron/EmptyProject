import pytest
from sqlalchemy import create_engine, Column, Integer, String, literal
from sqlalchemy.orm import sessionmaker, declarative_base
from sqlalchemy.sql import func
from sqlalchemy.dialects import sqlite, postgresql, mysql, mssql
import re
from sqlalchemy_extensions import Substr

# Define the base for SQLAlchemy models
Base = declarative_base()

# Define a sample table model for testing
class tbl_Criteria(Base):
    __tablename__ = 'tbl_Criteria'
    id = Column(Integer, primary_key=True)
    Reference = Column(String)

# Create a fixture for the database session
@pytest.fixture(scope='function')
def session():
    engine = create_engine('sqlite:///:memory:')
    Base.metadata.create_all(engine)
    Session = sessionmaker(bind=engine)
    session = Session()
    session.add(tbl_Criteria(Reference='test_string'))
    session.commit()
    yield session
    session.close()
    Base.metadata.drop_all(engine)
    
def compare_strings(expected, actual):
    """ Compare two strings and print differences character by character """
    if expected != actual:
        print("\n=== String Comparison ===")
        print(f"Expected (repr): {repr(expected)}")
        print(f"Actual (repr): {repr(actual)}")
        for i, (e_char, a_char) in enumerate(zip(expected, actual)):
            if e_char != a_char:
                print(f"Difference at index {i}: expected '{e_char}', got '{a_char}'")
        if len(expected) != len(actual):
            print(f"Expected length: {len(expected)}, Actual length: {len(actual)}")
        print("==========================")
    assert expected == actual

def test_substr_in_filter_mssql(session):
    """ Test Substr function in the MSSQL dialect """
    query = session.query(tbl_Criteria).filter(
        func.substr(tbl_Criteria.Reference, literal(1), literal(4)) == 'test'
    )
    compiled_query = query.statement.compile(dialect=mssql.dialect(), compile_kwargs={"literal_binds": True})
    normalized_sql = normalize_sql(str(compiled_query))
    
    # Expected SQL for MSSQL with 'substr' in lowercase
    expected_sql = normalize_sql(
        'SELECT tbl_Criteria.id, tbl_Criteria.Reference FROM tbl_Criteria WHERE substr(tbl_Criteria.Reference, 1, 4) = \'test\''
    )
    
    # Print for diagnosis
    print("Compiled SQL (MSSQL):", normalized_sql)
    print("Expected SQL (MSSQL):", expected_sql)
    
    # Assert
    assert normalized_sql == expected_sql


def normalize_sql(sql):
    """ Function to normalize SQL by removing extra spaces, newlines, quotes, and square brackets. """
    # Replace newlines and multiple spaces with a single space
    sql = re.sub(r'\s+', ' ', sql).strip()
    # Remove double quotes from identifiers, backticks, and square brackets
    sql = sql.replace('"', '').replace('`', '').replace('[', '').replace(']', '')
    return sql

# Test for SQLite with the correct 'substr'
def test_substr_in_filter_sqlite(session):
    query = session.query(tbl_Criteria).filter(
        func.substr(tbl_Criteria.Reference, literal(1), literal(4)) == 'test'
    )
    compiled_query = query.statement.compile(dialect=sqlite.dialect(), compile_kwargs={"literal_binds": True})
    normalized_sql = normalize_sql(str(compiled_query))
    
    # Expected SQL for SQLite with 'substr' in lowercase
    expected_sql = normalize_sql(
        'SELECT tbl_Criteria.id, tbl_Criteria.Reference FROM tbl_Criteria WHERE substr(tbl_Criteria.Reference, 1, 4) = \'test\''
    )
    
    # Print for diagnosis
    print("Compiled SQL (SQLite):", normalized_sql)
    print("Expected SQL (SQLite):", expected_sql)
    
    # Assert
    assert normalized_sql == expected_sql

# Test for PostgreSQL with 'substr' in lowercase
def test_substr_in_filter_postgresql(session):
    query = session.query(tbl_Criteria).filter(
        func.substr(tbl_Criteria.Reference, literal(1), literal(4)) == 'test'
    )
    compiled_query = query.statement.compile(dialect=postgresql.dialect(), compile_kwargs={"literal_binds": True})
    normalized_sql = normalize_sql(str(compiled_query))
    
    # Expected SQL for PostgreSQL with 'substr' in lowercase
    expected_sql = normalize_sql(
        'SELECT tbl_Criteria.id, tbl_Criteria.Reference FROM tbl_Criteria WHERE substr(tbl_Criteria.Reference, 1, 4) = \'test\''
    )
    
    # Print for diagnosis
    print("Compiled SQL (PostgreSQL):", normalized_sql)
    print("Expected SQL (PostgreSQL):", expected_sql)
    
    # Assert
    assert normalized_sql == expected_sql

# Test for MySQL with 'substr' in lowercase
def test_substr_in_filter_mysql(session):
    query = session.query(tbl_Criteria).filter(
        func.substr(tbl_Criteria.Reference, literal(1), literal(4)) == 'test'
    )
    compiled_query = query.statement.compile(dialect=mysql.dialect(), compile_kwargs={"literal_binds": True})
    normalized_sql = normalize_sql(str(compiled_query))
    
    # Expected SQL for MySQL with 'substr' in lowercase
    expected_sql = normalize_sql(
        'SELECT tbl_Criteria.id, tbl_Criteria.Reference FROM tbl_Criteria WHERE substr(tbl_Criteria.Reference, 1, 4) = \'test\''
    )
    
    # Print for diagnosis
    print("Compiled SQL (MySQL):", normalized_sql)
    print("Expected SQL (MySQL):", expected_sql)
    
    # Assert
    assert normalized_sql == expected_sql

# Test for MSSQL with 'substr' in lowercase
def test_substr_in_filter_mssql(session):
    query = session.query(tbl_Criteria).filter(
        func.substr(tbl_Criteria.Reference, literal(1), literal(4)) == 'test'
    )
    compiled_query = query.statement.compile(dialect=mssql.dialect(), compile_kwargs={"literal_binds": True})
    normalized_sql = normalize_sql(str(compiled_query))
    
    # Expected SQL for MSSQL with 'substr' in lowercase
    expected_sql = normalize_sql(
        'SELECT tbl_Criteria.id, tbl_Criteria.Reference FROM tbl_Criteria WHERE substr(tbl_Criteria.Reference, 1, 4) = \'test\''
    )
    
    # Print for diagnosis
    print("Compiled SQL (MSSQL):", normalized_sql)
    print("Expected SQL (MSSQL):", expected_sql)
    
    # Assert
    assert normalized_sql == expected_sql
