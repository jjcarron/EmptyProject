"""
"""

import re

import pandas as pd
from db.crud import CRUDRepository
from lib.utils import find_files_by_pattern, get_df_from_slqalchemy_objectlist
from shared import log, project
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy.orm import Session
from xl.xl_writer import XlWriter


class DatabaseExporter():
    """
    The DatabaseExporter class provides methods for extracting data from database and write it into Excel files.

    Attributes:
        none
    """

    def __init__(self, database, xl_file, writer=XlWriter):
        """
        Initializes the DatabaseExporter object with the specified database type.

        Args:
            database: The database object.
            writer: The class responsible for writing the data.
            xl_file (str): The path to the Excel file.
        """
        self.database = database
        self.writer = writer(xl_file)

    def export_all_tables(self):
        """
        export all data from all databasebtables in one an Excel file.
        The sheet name is the same as the table name an each attribute will be the columnname.

        Args:
            none
        """
        log.info("Not implemented yet")
        return
        log.info("Writing %s ...", xl_file)
        xl = cls(xl_file)
        xl.load_data()

    def export_tables(self, tables):
        """
        export all data from all databasebtables in one an Excel file.
        The sheet name is the same as the table name an each attribute will be the columnname.

        Args:
            tables: The list of tables to export.
        """

        for table in tables:
            self.export_table(table, write=False)

        self.writer.save()

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
        log.info("Writing %s ...", xl_file)
        xl = cls(xl_file)
        xl.load_data()

        log.info("%s Loaded.\n", xl_file)
