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
# pylint: disable=pointless-string-statement

import argparse
import logging
import sys

from lib.db_loader import DB_Loader
from lib.utils import get_uri_str   

from shared import dlog, log, project, check_path

from this_db import ThisDB
from xl.xl_initial_data import XlInitialData

        
def set_project_database(args):
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

    # avoid  pylint warning if they are unused
    _ = operation
    _ = language

    set_project_database(args)
    match args.command:
        case 'create':
            set_project_database(args)
            try:
                this_db = project.get_this_db()
                this_db.init_db(drop_all=True)

                if this_db is None:
                    log.error("Database initialization failed.")

                log.info("Database initialized.")
                dbl = DB_Loader(this_db)
                dbl.load_all_sheets(XlInitialData, project.initial_data_file)

                # Load other data from Excel files here for example: 
                # dbl.load_data(OtherData, project.get_path('fichier'), 'Table')
            
            except Exception as e:
                log.error("An error occurred: %s", e)
            finally:
                sys.exit()
        case 'load':
            print("Load command is not defined yet.")
            sys.exit()
        case 'export':
            this_db = project.get_this_db()
            sys.exit()

if __name__ == "__main__":
    main()
