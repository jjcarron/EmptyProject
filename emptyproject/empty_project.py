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
    -l, --language               Language of the report 'de' or 'fr' or 'it' or 'en'.
    -o, --operation              Type of casino operation 'LB' or 'OL' or 'BO' for Both.
    -xl, --excel_file PATH       Path to the Excel file to generate.
    -x, --debug                  Enable debug mode for logging.
"""

# pylint: disable=broad-exception-caught
# pylint: disable=pointless-string-statement
# pylint: disable=logging-fstring-interpolation

import argparse
import logging
# import os
import sys

# from generate_altered_data import generate_data_from_template
# from lib.db_exporter import DatabaseExporter
from lib.db_loader import DatabaseLoader
from lib.utils import get_uri_str
from shared import check_path, dlog, log, project
from this_db import ThisDB
# from this_exporter import ThisExporter
from this_project import Context
from xl.xl_clean_reader import XlCleanReader

# from xl.xl_criteria_reader import XlCriteriaReader
# from xl.xl_pivot_writer import XlPivotWriter
# from xl.xl_simple_reader import XlSimpleReader


def set_project_context(args):
    """
    Store the project context based on the provided arguments.

    Args:
        args: The command-line arguments.
    """
    project.context = Context(
        language=args.language,
        operation=args.operation,
        database_type=args.database_type,
        debug=args.debug,
    )


def set_project_database(args):
    """
    Connects to the database based on the provided arguments.

    Args:
        args: The command-line arguments.
    """
    connection_uri = ""
    if args.database_type is None:
        uri = get_uri_str("sqlite")
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


def handle_create(args, this_db):
    """
    Handle the 'create' command, which initializes a new database and loads initial data.

    Parameters:
    - args: The command-line arguments.
    - this_db: The database object to interact with.
    """
    # generate_data_from_template()
    set_project_database(args)
    try:
        this_db.init_db(drop_all=True)
        log.info("Database initialized.")

        dbl = DatabaseLoader(this_db)
        dbl.load_all_sheets(XlCleanReader, project.initial_data_file)

        log.info("Database initialized successfully.")
    except Exception as e:
        log.error("An error occurred during database creation: %s", e)
    finally:
        sys.exit()


def handle_load(this_db):
    """
    Handle the 'load' command, which loads data into the existing database.

    Parameters:
    - args: The command-line arguments.
    - this_db: The database object to interact with.
    """
    dbl = DatabaseLoader(this_db)
    _ = dbl  # just to avoid pylint complaints before the implementation
    # pattern = project.input_files_pattern.replace("{year}", r"\d{4}")

    # log.info(f"Loading data from project.input_dir: {project.input_dir}")
    # dbl.load_data_from_files(
    # XlSimpleReader,
    # tables=["Categories", "Sentences"],
    # path=project.input_dir,
    # pattern=pattern,
    # post_processing=this_db.update_sentences_category_fk,
    # recursive=True,
    # )

    # pattern = project.input_files_pattern.replace("{year}", r"2023")
    # dbl.load_data_from_files(
    # XlCriteriaReader,
    # tables=["CriterionValues"],
    # path=project.input_dir,
    # pattern=pattern,
    # recursive=True,
    # )

    # log.info("Data loaded successfully.")
    log.info("Not implemented yet.")


def handle_export(this_db):
    """
    Handle the 'export' command, which exports data from the database into Excel files.

    Parameters:
    - args: The command-line arguments.
    - this_db: The database object to interact with.
    """
    _ = this_db  # just to avoid pylint complaints before the implementation
    log.info("Exporting data...")

    # # Using DatabaseExporter to export data
    # db_exporter_test_file = os.path.join(
    # project.output_dir, "db_exporter_test.xlsx")
    # with DatabaseExporter(this_db, db_exporter_test_file) as dbe:
    # dbe.export_tables(["Categories", "Sentences"])

    # # Reformat one sheet
    # sh = dbe.writer.get_sheet("Sentences")
    # sh.format_worksheet()
    # sh.adjust_column_width()
    # sh.page_print_setting(portrait=False)
    # sh.define_header_and_footer(title="My Sentences")

    # # Using ThisExporter for a customized export
    # customized_db_exporter_test_file = os.path.join(
    # project.output_dir, "customized_exporter_test.xlsx"
    # )
    # with ThisExporter(this_db, customized_db_exporter_test_file) as cdbe:
    # cdbe.export_all()

    # # Using ThisExporter for specific pivot exports
    # pivot_exporter_test_file = os.path.join(
    # project.output_dir, "pivot_exporter_test.xlsx"
    # )
    # with ThisExporter(this_db, pivot_exporter_test_file, XlPivotWriter) as cdbe:
    # cdbe.export_generated_pivots()

    # log.info("Export completed successfully.")
    log.info("Not implemented yet.")


def main():
    """
    Main entry point for the script. Parses command-line arguments and
    executes the specified command (create, load, or export).
    """
    usage_text = """
    Usage: basic_example.py [OPTIONS] COMMAND [ARGS]...

    Commands:
      create      Create a new database.
      load        Load data into the database.
      export      Export data from the database.
    """
    parser = argparse.ArgumentParser(
        description="Play Safe Metrics",
        usage=usage_text)
    parser.add_argument(
        "command",
        choices=["create", "load", "export"],
        help="The command to execute: 'create', 'load', or 'export'",
    )
    parser.add_argument(
        "-db", "--database", type=str, help="The path to the database file"
    )
    parser.add_argument(
        "-db_type",
        "--database_type",
        nargs="?",
        default="sqlite",
        type=str,
        help="Database type ('sqlite' or 'access'). Default is 'sqlite'.",
    )
    parser.add_argument(
        "-l",
        "--language",
        choices=[
            "de",
            "fr",
            "it",
            "en"],
        nargs="?",
        default="de",
        type=str,
        help="Language of the report ('de', 'fr', 'it', 'en'). Default is 'de'.",
    )
    parser.add_argument(
        "-o",
        "--operation",
        choices=["LB", "OL", "BO"],
        nargs="?",
        default="LB",
        type=str,
        help="Type of casino operation ('LB', 'OL', 'BO'). Default is 'LB'.",
    )
    parser.add_argument(
        "-xl",
        "--excel_file",
        type=str,
        help="The path to the Excel file to generate.")
    parser.add_argument(
        "-x",
        "--debug",
        action="store_true",
        help="Enable debug mode.")
    args = parser.parse_args()

    if check_path(args.database):
        project.set_db_file_path(args.database_type, args.database)

    if args.debug:
        log.setLevel(logging.DEBUG)
        log.debug("Debug mode enabled")
    else:
        log.setLevel(logging.INFO)

    set_project_database(args)
    set_project_context(args)

    this_db = project.get_this_db()
    if this_db is None:
        log.error("Database initialization failed.")
        sys.exit()

    # Execute the appropriate function based on the command
    match args.command:
        case "create":
            handle_create(args, this_db)
        case "load":
            handle_load(this_db)
        case "export":
            handle_export(this_db)


if __name__ == "__main__":
    main()
