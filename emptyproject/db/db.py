"""
This module defines the Database class, which provides a basic interface
for connecting to and interacting with a SQLAlchemy-managed database.

Classes:
    - Database: A class that handles database connections, session management,
      and schema initialization for a SQLAlchemy database.
"""

import inspect

import db.models as tables
from db.models import Base
from shared import log
from sqlalchemy import create_engine
from sqlalchemy.orm import Session, scoped_session, sessionmaker


class Database:
    """
    A class that handles database connections, session management, and schema
    initialization for a SQLAlchemy database.

    Attributes:
        engine (sqlalchemy.engine.Engine): The SQLAlchemy engine connected to the database.
        Session (sqlalchemy.orm.scoped_session): A scoped session factory for database sessions.
        db_type (str): The type of database being used (e.g., 'sqlite', 'postgresql').
    """

    def __init__(self, connection_uri):
        """
        Initializes the Database class with a connection URI.

        Args:
            connection_uri (str): The URI for the database connection.
        """
        self.engine = create_engine(connection_uri, echo=False)
        self.session = scoped_session(
            sessionmaker(autocommit=False, autoflush=False, bind=self.engine)
        )
        self.db_type = self.engine.dialect.name
        log.info("Database initialized with URI: %s\n", connection_uri)

    def get_single_session(self):
        """
        Returns the scoped session factory for database sessions.

        Returns:
            sqlalchemy.orm.scoped_session: The scoped session factory.
        """
        return self.session

    def get_engine(self):
        """
        Returns the SQLAlchemy engine connected to the database.

        Returns:
            sqlalchemy.engine.Engine: The SQLAlchemy engine.
        """
        return self.engine

    def get_db_type(self):
        """
        Returns the type of the database (e.g., 'sqlite', 'postgresql').

        Returns:
            str: The type of the database.
        """
        return self.db_type

    def init_db(self, drop_all=False):
        """
        Initializes the database schema, optionally dropping all existing tables.

        Args:
            drop_all (bool): If True, drops all existing tables before initializing.
                             Defaults to False.
        """
        if drop_all:
            # Be careful with this in production
            Base.metadata.drop_all(self.engine)
        Base.metadata.create_all(self.engine)
        log.info("Database schema created.")

    def get_table_class(self, table_name):
        """
        Retrieves the SQLAlchemy class associated with a given table name.

        Args:
            table_name (str): The name of the table for which to retrieve the class.

        Returns:
            class: The SQLAlchemy class corresponding to the table name.

        Raises:
            ValueError: If no class is found for the given table name.
        """
        for name, obj in inspect.getmembers(tables):
            _ = name

            if inspect.isclass(obj) and hasattr(
                    obj, '__tablename__') and obj.__tablename__ == table_name:
                return obj
        raise ValueError(f"No table class found for table: {table_name}")

    def get_session(self):
        """
        Returns a new SQLAlchemy session.

        Returns:
            sqlalchemy.orm.Session: A new session object.
        """
        db_generator = self.get_db()
        db: Session = next(db_generator)
        return db

    def get_db(self):
        """
        A generator that yields a database session. Ensures that the session
        is properly closed after use.

        Yields:
            sqlalchemy.orm.Session: A database session object.
        """
        session_local = self.session
        db = session_local()
        try:
            yield db
        finally:
            db.close()
