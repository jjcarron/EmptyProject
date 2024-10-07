"""
This module defines the `XlCleanReader` class, which is used to load initial data from an
Excel file into a database using SQLAlchemy ORM.

The module extends the base `Xl` class and provides functionality to:
- Initialize with a path to an Excel file.
- Load data from each sheet in the Excel file into the corresponding database tables.
- Handle errors and log necessary information during the data loading process.

Classes:
    XlCleanReader: Handles loading of initial data from an Excel file into the database.

Usage:
    - Create an instance of `XlCleanReader` by providing the path to the Excel file.
    - Call the `load_data` method to read the Excel data and insert it into the database.
"""

# pylint: disable=broad-exception-caught

import sys

import pandas as pd
from shared import log, project
from xl.xl_reader import XlReader


class XlCleanReader(XlReader):
    """
    A class used to load initial data from an Excel file into the database.

    This class extends the `Xl` class and provides methods to read data from
    an Excel file and insert it into the appropriate database tables using SQLAlchemy ORM.

    Attributes:
        file_path (str): The path to the Excel file containing the initial data.
    """

    def __init__(self, file_path):
        """
        Initializes the XlCleanReader object with the path to the Excel file.

        Args:
            file_path (str): The path to the Excel file to be loaded.
        """
        super().__init__(file_path)

    def load_data(self):
        """
        Loads data from the Excel file and inserts it into the database.

        The method iterates over each sheet in the Excel file, and for each sheet,
        it fetches the corresponding table class from the database instance. It then
        iterates over the rows of the sheet, creating and adding a new entry to the
        database for each row.

        In case of an error during the insertion process, it logs the error and rolls
        back the session. The session is always closed in the `finally` block.

        Raises:
            Exception: If any error occurs during the data insertion process.
        """
        db_instance = project.get_this_db()
        if db_instance:
            session = db_instance.get_session()
            try:
                for sheet, df in self.df_dict.items():
                    table_class = db_instance.get_table_class(sheet)
                    columns = [
                        col for col in df.columns if col and not col.startswith("Unnamed")]
                    for row in df.itertuples(index=False, name=None):
                        record = {
                            col: value for col, value in zip(columns, row)
                            if pd.notna(value) and value != ''
                        }
                        entry = table_class(**record)
                        session.add(entry)
                    session.commit()
                log.info("Data inserted successfully.")
            except Exception as e:
                session.rollback()
                log.error("Error inserting data: %s", e)
            finally:
                session.close()
        else:
            log.error(
                "The database instance is not initialized: %s",
                db_instance)
            sys.exit()
