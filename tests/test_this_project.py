"""
Test module for verifying various functionalities of the `project` object
and database interactions within the `shared` module.

This module uses pytest to assert the proper initialization of directories,
properties, paths, and database connections. It also tests methods for
fetching casinos, settings, and resource strings from the project.
"""

import os

from shared import log, project
from this_db import ThisDB
from xl.xl_initial_data import XlInitialData

# pylint: disable=broad-exception-caught
# pylint: disable=pointless-string-statement
# pylint: disable=logging-fstring-interpolation


def test_directories():
    """
    Test if the project directories are properly set up.

    Verifies that the essential directories in the project (input, output, templates, etc.)
    exist and are accessible.
    """
    assert os.path.isdir(project.input_dir)
    assert os.path.isdir(project.output_dir)
    assert os.path.isdir(project.templates_dir)
    assert os.path.isdir(project.docs_dir)
    assert os.path.isdir(project.init_dir)
    assert os.path.isdir(project.database_dir)
    assert os.path.isdir(project.config_dir)
    assert os.path.isdir(project.log_dir)


def test_properties():
    """
    Test if the basic properties of the project are correctly initialized.

    Ensures that the project's name, description, date, and version are properly set and are
    of the expected types (e.g., strings).
    """
    assert isinstance(project.name, str)
    assert isinstance(project.description, str)
    # Adjust type as per your implementation
    assert isinstance(project.date, str)
    assert isinstance(project.version, str)


def test_paths():
    """
    Test if the project configuration files and database files are correctly initialized.

    Verifies the existence of the project's logging configuration, Access database,
    SQLite database, and initial data files.
    """
    assert os.path.isfile(project.logging_config_file)
    assert os.path.isfile(project.access_db_file)
    assert os.path.isfile(project.sqlite_db_file)
    assert os.path.isfile(project.initial_data_file)


def test_connections():
    """
    Test if the project's database connection strings are properly set up.

    Verifies that the connection strings for Access and SQLite databases are initialized and
    are of the correct type (string).
    """
    assert isinstance(project.access_conn_str, str)
    assert isinstance(project.access_uri, str)
    assert isinstance(project.sqlite_uri, str)
    assert isinstance(project.sqlite_memory_uri, str)


def init_db_access():
    """
    Initialize the database access and load initial data.

    This function initializes the database (in-memory SQLite), loads initial data from
    an Excel file, and performs basic CRUD operations to insert data into the database.
    """
    def load_initial_data(cls, xl_file, post_processing=None):
        """
        Load data from an Excel file using the provided class and perform optional post-processing.

        Args:
            cls: The class used to load the data.
            xl_file (str): The path to the Excel file.
            post_processing (function, optional): A function to call after loading data.
        """
        log.info(f"Loading {xl_file} ...")
        xl = cls(xl_file)
        xl.load_data()
        if post_processing:
            post_processing()

        log.info(f"{xl_file} Loaded. \n\n")

    def create_db():
        """
        Create and initialize the in-memory SQLite database.

        This function sets up the in-memory database, loads initial data,
        and ensures that the project can access the database.
        """
        connection_uri = 'sqlite:///:memory:'

        try:
            this_db = ThisDB(connection_uri)
            this_db.init_db(drop_all=True)
            project.set_this_db(this_db)

            this_db = project.get_this_db()

            if this_db is None:
                log.error("Database initialization failed.")

            log.info("Database initialized.")

            xl_file = project.initial_data_file
            load_initial_data(XlInitialData, xl_file)
        except Exception as e:
            log.error(f"An error occurred: {e}")

    create_db()


def assert_db():
    """
    Ensure the database is initialized before running the tests.

    Calls `init_db_access()` if the database is not already initialized.
    """
    if project.get_this_db() is None:
        init_db_access()


def test_get_casinos():
    """
    Test if the project retrieves the correct number of casinos.

    Ensures that the project fetches exactly 25 casinos from the database.
    """
    assert_db()
    assert len(project.get_casinos()) == 25


def test_get_casino_count():
    """
    Test if the project retrieves the correct count of casinos.

    Ensures that the project returns a count of 25 casinos.
    """
    assert_db()
    assert project.get_casino_count() == 25


def test_get_casino_name_from_dzs_id():
    """
    Test if the project retrieves the correct casino name based on the DZS ID.

    Verifies that the correct casino name is fetched for a given DZS ID.
    """
    assert_db()
    assert project.get_casino_name_from_dzs_id('83041663') == 'Baden'


def test_get_settings():
    """
    Test if the project retrieves specific settings.

    Ensures that the project fetches settings and finds a specific setting named 'Test_Setting'.
    """
    assert_db()
    params = project.get_settings()
    found = False
    for param in params:
        if param.Name == 'Test_Setting':
            found = True
            break

    assert found


def test_get_resource_strings():
    """
    Test if the project retrieves the resource strings.

    Ensures that resource strings are fetched correctly, specifically looking for a resource
    with reference 'TEST1'.
    """
    assert_db()
    resource_strings = project.get_resource_strings()
    found = False
    if resource_strings is not None:
        for resource in resource_strings:
            if resource.Ref == 'TEST1':
                found = True
                break

    assert found


def test_get_resource_string_translation():
    """
    Test if the project retrieves the correct resource string translations.

    Verifies that the correct translations are returned for a resource string with reference
    'TEST1' in various languages.
    """
    assert_db()
    assert project.get_resource_string('TEST1', 'EN') == 'Test_EN'
    assert project.get_resource_string('TEST1', 'FR') == 'Test_FR'
    assert project.get_resource_string('TEST1', 'DE') == 'Test_DE'
    assert project.get_resource_string('TEST1', 'IT') == 'Test_IT'
    assert project.get_resource_string('TEST1', 'ES') == 'Test_EN'
    assert project.get_resource_string('TEST3', 'EN') is None


def test_get_resource_string_default_value():
    """
    Test if the project retrieves the default value for a resource string.

    Verifies that the default value ('Test_EN') is returned for a resource string with reference
    'TEST2' in all languages.
    """
    assert_db()
    assert project.get_resource_string('TEST2', 'EN') == 'Test_EN'
    assert project.get_resource_string('TEST2', 'FR') == 'Test_EN'
    assert project.get_resource_string('TEST2', 'DE') == 'Test_EN'
    assert project.get_resource_string('TEST2', 'IT') == 'Test_EN'


def test_get_table_class():
    """
    Test if the project retrieves the correct table class for 'Casinos'.

    Ensures that the project fetches the 'Casinos' table class and verifies its name.
    """
    assert_db()
    my_table = project.get_table_class('Casinos')
    assert my_table.__name__ == 'Casinos'
