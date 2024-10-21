"""
This module provides functionality to export database tables to Excel files.
Classes:
    DatabaseExporter: A class to handle the export of database tables to Excel files.
Functions:
    None
Exceptions:
    None
Misc variables:
    None
"""

from db.models import Base
from lib.utils import get_df_from_slqalchemy_objectlist
from shared import log, project
from sqlalchemy.exc import SQLAlchemyError
from xl.xl_writer import XlWriter


class DatabaseExporter:
    """
    The DatabaseExporter class provides methods for extracting data from database and
    write it into Excel files.

    Attributes:
        none
    """

    def __init__(self, database, file, writer=XlWriter):
        """
        Initializes the DatabaseExporter object with the specified database type.

        Args:
            database: The database object.
            writer: The class responsible for writing the data.
            xl_file (str): The path to the Excel file.
        """
        self.database = database
        self.writer = writer(file)

    def __enter__(self):
        # Code that runs when entering the context (e.g., resource setup)
        # print("Entering the context of DatabaseExporter")
        # Optionally return the object itself or something else
        return self

    def __exit__(self, exc_type, exc_value, traceback):
        # Code that runs when exiting the context (e.g., cleanup)
        # print("Exiting the context of DatabaseExporter")
        # Close any resources or handle exceptions if necessary
        if exc_type:
            print(f"Exception occurred: {exc_type}, {exc_value}")

        self.writer.save()

        # Return False to propagate exceptions, True to suppress them
        return False

    def export_all_tables(self):
        """
        export all data from all databasebtables in one an Excel file.
        The sheet name is the same as the table name an each attribute will be the columnname.

        Args:
            none
        """

        # Base.metadata.tables will give you a dictionary of table names and
        # their definitions
        table_names = Base.metadata.tables.keys()

        print("List of tables:", list(table_names))

        for table in table_names:
            self.export_table(table, write=False)

        log.info("Not implemented yet")

    def export_tables(self, tables):
        """
        export all data from all databasebtables in one an Excel file.
        The sheet name is the same as the table name an each attribute will be the columnname.

        Args:
            tables: The list of tables to export.
        """

        for table in tables:
            self.export_table(table, write=False)

    def export_table(self, table, write=False):
        """
        export all data from al database table into one an Excel file.
        The sheet name is the same as the table name an each attribute will be the columnname.

        Args:
            table: table to export.
        """
        try:
            db = project.get_this_db()
            db_data = db.get_all(table)

            df = get_df_from_slqalchemy_objectlist(db_data)
        except SQLAlchemyError as e:
            log.error("Error fetching data for table %s: %s", table, str(e))
            return
        self.writer.add_sheet(table, df)
        if write:
            self.writer.write_data()

        return
