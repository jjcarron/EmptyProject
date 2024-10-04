"""
db_loader.py
This module provides the DatabaseLoader class, which contains methods for loading data from
Excel files into a database. The class supports different types of databases, such as SQLite
and Access, and includes functionality for loading data
from multiple sheets and files, as well as handling post-processing tasks.
Classes:
    DatabaseLoader: A class that provides methods for loading data from Excel files
    into a database.
Exceptions:
    SQLAlchemyError: Raised when there is an error with SQLAlchemy operations.
    IOError: Raised when there is an input/output error.
Functions:
    __init__(self, db_type): Initializes the DatabaseLoader object with the specified
    database type.
    get_uri_str(self): Returns the appropriate database URI key based on the database type.
    load_all_sheets(self, cls, xl_file, post_processing=None): Loads all data from all sheets
    of an Excel file into the database.
    load_data_from_file(self, cls, xl_file_pattern, table, post_processing=None): Loads data
    from multiple Excel files matching a pattern into the database.
    load_data(self, cls, xl_file, table, post_processing=None): Loads data from a single
    Excel file into the database.
"""

import re

from db.crud import CRUDRepository
from lib.utils import find_files_by_pattern
from shared import log, project
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy.orm import Session


# pylint
class DatabaseLoader():
    """
    The DatabaseLoader class provides methods for loading data from Excel files into a database.

    Attributes:
        db_type (str): The type of database ('sqlite' or 'access').
    """

    def __init__(self, db_type):
        """
        Initializes the DatabaseLoader object with the specified database type.

        Args:
            db_type (str): The type of database ('sqlite' or 'access').
        """
        self.db_type = db_type

    def get_uri_str(self):
        """
        Returns the appropriate database URI key based on the database type.

        Returns:
            str: The corresponding URI key.
        """
        match self.db_type:
            case 'sqlite':
                return 'sqlite_uri'
            case 'access':
                return 'access_uri'
            case _:
                return None

    def load_all_sheets(self, cls, xl_file, post_processing=None):
        """
        Loads all data from all sheets of an Excel file into the database.
        It assumes that the sheet name is the same as the table name and
        they exits in the database.

        Args:
            cls: The class responsible for loading the data.
            xl_file (str): The path to the Excel file.
            post_processing (function, optional): A function to call after data is loaded.
        """
        log.info("Loading %s ...", xl_file)
        xl = cls(xl_file)
        xl.load_data()
        if post_processing:
            post_processing()

        log.info("%s Loaded.\n", xl_file)

    # pylint: disable=too-many-positional-arguments
    def load_data_from_files(
            self,
            cls,
            tables,
            path,
            pattern,
            recursive=False,
            post_processing=None,
    ):
        """
        Loads data from multiple Excel files matching a pattern into the database.

        Args:
            cls: The class responsible for loading the data.
            xl_file_pattern (str): The pattern to match Excel files.
            table (str): The database table to insert data into.
            post_processing (function, optional): A function to call after data is loaded.
        """
        files = find_files_by_pattern(path, pattern, recursive=recursive)

        for file in files:
            match = re.match(pattern, file)
            self.load_data(cls, tables, file, match, post_processing)

    # pylint: disable=too-many-locals
    def load_data(
            self,
            cls,
            tables,
            xl_file,
            match=None,
            post_processing=None):
        """
        Loads data from a single Excel file into the database.

        Args:
            cls: The class responsible for loading the data.
            xl_file (str): The path to the Excel file.
            table (str): The database table to insert data into.
            post_processing (function, optional): A function to call after data is loaded.
        """
        log.info("Loading %s ...", xl_file)

        this_db = project.get_this_db()
        db: Session = this_db.get_session()

        try:
            # db_type = db.bind.dialect.name
            xl = cls(xl_file, match)
            # Iterate over each table in the list of tables
            for table in tables:
                # Load data from the Excel file for the current table
                data_to_insert = xl.load_data(table)

                # Process each entry in the data to insert
                for data in data_to_insert:
                    # Get the class corresponding to the current table
                    table_class = this_db.get_table_class(table)

                    # Filter out keys that are not attributes of the table
                    # class
                    valid_data = {
                        k: v for k, v in data.items() if hasattr(
                            table_class, k)}

                    # Create a new database entry
                    new_entry = table_class(**valid_data)

                    # check for constraints
                    crud_repo = CRUDRepository(table_class)
                    if not crud_repo.check_constraints(db, new_entry):
                        continue

                    # Insert the new entry into the database
                    CRUDRepository.create(db, new_entry)

            # Commit the transaction after processing all tables
            db.commit()
        except (SQLAlchemyError, IOError) as e:
            db.rollback()
            log.error("Error inserting data: %s", e)
        finally:
            db.close()

        if post_processing:
            post_processing()

        log.info("%s Loaded.\n", xl_file)
