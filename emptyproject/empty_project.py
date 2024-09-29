"""
This script is the main entry point for the Play Safe Metrics project.

It provides a command-line interface to create, load, and export data for
the project's database. The script uses SQLAlchemy for database operations
and Pandas/Openpyxl for handling Excel files.

Commands:
    - create: Initializes a new database and loads initial data.
    - load: (Not implemented) Loads additional data into the database.
    - export: Exports data from the database into Excel files.

Options:
    -db, --database PATH         Path to the database file.
    -db_type, --database_type    Type of the database (sqlite or access).
    -l, --language               Language of the report 'DE' or 'FR' or 'IT' or 'EN'.
    -o, --operation              Type of casino operation 'LB' or 'OL' or 'BO' for Both.
    -xl, --excel_file PATH       Path to the Excel file to generate.
    -x, --debug                  Enable debug mode for logging.
"""
# pylint: disable=broad-exception-caught

import argparse
import glob
import logging
import os
import sys

from cross_views import create_excel_export
from db.crud import CRUDRepository
from shared import dlog, log, project
from this_db import ThisDB
from sqlalchemy.orm import Session

from xl.xl_initial_data import XlInitialData


def get_uri_str(db_type):
    """
    Returns the appropriate database URI key based on the database type.

    Args:
        db_type (str): The type of database ('sqlite' or 'access').

    Returns:
        str: The corresponding URI key.
    """
    match db_type:
        case 'sqlite':
            return 'sqlite_uri'
        case 'access':
            return 'access_uri'
        case _:
            return None


def load_initial_data(cls, xl_file, post_processing=None):
    """
    Loads initial data from an Excel file into the database.

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


def load_data_from_file(cls, xl_file_pattern, table, post_processing=None):
    """
    Loads data from multiple Excel files matching a pattern into the database.

    Args:
        cls: The class responsible for loading the data.
        xl_file_pattern (str): The pattern to match Excel files.
        table (str): The database table to insert data into.
        post_processing (function, optional): A function to call after data is loaded.
    """
    files = glob.glob(xl_file_pattern)
    for file in files:
        load_data(cls, file, table, post_processing)


def load_data(cls, xl_file, table, post_processing=None):
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
    db_generator = this_db.get_db()
    db: Session = next(db_generator)

    try:
        # db_type = db.bind.dialect.name
        xl = cls(xl_file)
        data_to_insert = xl.load_data()

        for data in data_to_insert:
            table_class = this_db.get_table_class(table)
            new_entry = table_class(**data)
            if new_entry.Casino == 'Total':
                continue
            CRUDRepository.create(db, new_entry)

        db.commit()
    except Exception as e:
        db.rollback()
        log.error("Error inserting data: %s", e)
    finally:
        next(db_generator, None)

    if post_processing:
        post_processing()

    log.info("%s Loaded.\n", xl_file)


def check_path(path):
    """
    Validates the provided file path.

    Args:
        path (str): The file path to check.

    Returns:
        bool: True if the path is valid, False otherwise.
    """
    if path is None or path == '':
        return False

    if path == ':memory:':
        return True

    directory = os.path.dirname(path)
    if not os.path.exists(directory):
        log.warning("The directory '%s' does not exist.", directory)
        return False

    filename = os.path.basename(path)
    filename_no_ext, file_ext = os.path.splitext(filename)
    if not filename_no_ext or not file_ext:
        log.warning(
            "The path '%s' does not contain a valid file name with an extension.",
            path)
        return False

    return True


def connect_database(args):
    """
    Connects to the database based on the provided arguments.

    Args:
        args: The command-line arguments.
    """
    if args.database_type is None:
        uri = get_uri_str('sqlite')
    else:
        uri = get_uri_str(args.database_type.lower())

    if uri:
        connection_uri = project.get_connection_uri(uri)
    else:
        dlog.info("The database %s is not supported yet", args.db_type)
        sys.exit()

    dlog.info("Connection_uri: %s", connection_uri)

    try:
        this_db = ThisDB(connection_uri)
        project.set_this_db(this_db)
    except Exception as e:
        log.error("An error occurred: %s", e)
    finally:
        pass


def main():
    """
    Main entry point for the script. Parses command-line arguments and
    executes the specified command.
    """
    usage_text = """
    Usage: basic_example.py [OPTIONS] COMMAND [ARGS]...

    Commands:
      create      Create a new database.
      load        Load data into the database.
      export      Export data from the database.

    Options:
      -db, --database PATH         Path to the database file.
      -db_type, --database_type    Type of the database (sqlite or access).
      -l, --language               Language of the report 'DE' or 'FR' or 'IT' or 'EN'
      -o, --operation              Type of casino operation 'LB' or 'OL' or 'BO' for Both
      -xl, --excel_file PATH       Path to the Excel file to generate.
      -x, --debug                  Enable debug mode.
    """
    parser = argparse.ArgumentParser(
        description='Play Safe Metrics',
        usage=usage_text)
    parser.add_argument(
        'command',
        choices=[
            'create',
            'load',
            'export'],
        help="The command to execute. Can be 'create' or 'load' or 'export'")
    parser.add_argument(
        '-db',
        '--database',
        type=str,
        help="The path to the database file")
    parser.add_argument(
        '-db_type',
        '--database_type',
        nargs='?',
        default='sqlite',
        type=str,
        help="Can be 'sqlite' or 'access'. By default, sqlite would be used")
    parser.add_argument(
        '-l',
        '--language',
        choices=[
            'DE',
            'FR',
            'IT',
            'EN'],
        nargs='?',
        default='DE',
        type=str,
        help="Determine the language of the excel_sheet. Can be 'DE' or 'FR' or 'IT' or 'EN'")
    parser.add_argument(
        '-o',
        '--operation',
        choices=[
            'LB',
            'OL',
            'BO'],
        nargs='?',
        default='LB',
        type=str,
        help=(
            "Determine the type of casino operation reported to the excel_sheet. "
            "Can be 'LB' or 'OL' or 'BO' for Both"))
    parser.add_argument(
        '-xl',
        '--excel_file',
        type=str,
        help="The path to the excel file to generate")
    parser.add_argument(
        '-x',
        '--debug',
        action='store_true',
        help="Enable debug mode")
    args = parser.parse_args()

    if check_path(args.database):
        project.set_db_file_path(args.database_type, args.database)

    if args.debug:
        log.setLevel(logging.DEBUG)
        log.debug('Debug mode enabled')
    else:
        log.setLevel(logging.INFO)

    operation = args.operation
    language = args.language

    match args.command:
        case 'create':
            connect_database(args)
            try:
                this_db = project.get_this_db()
                this_db.init_db(drop_all=True)

                if this_db is None:
                    log.error("Database initialization failed.")
                    sys.exit()

                log.info("Database initialized.")

                load_initial_data(XlInitialData, project.initial_data_file)

 """
                load_data(
                    XlDzsAnnualPlayerData,
                    project.get_path('fichier'),
                    'Table')
"""
 

            except Exception as e:
                log.error("An error occurred: %s", e)
            finally:
                sys.exit()
        case 'load':
            print("Load command is not defined yet.")
            sys.exit()
        case 'export':
            connect_database(args)
            this_db = project.get_this_db()
            sys.exit()


if __name__ == "__main__":
    main()
