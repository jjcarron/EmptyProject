import os

import pytest
from sqlalchemy.orm import Session

from shared import dlog, log, project
from this_db import ThisDB
from xl_initial_data import XlInitialData


def test_directories():
    assert os.path.isdir(project.input_dir)
    assert os.path.isdir(project.output_dir)
    assert os.path.isdir(project.templates_dir)
    assert os.path.isdir(project.docs_dir)
    assert os.path.isdir(project.init_dir)
    assert os.path.isdir(project.database_dir)
    assert os.path.isdir(project.config_dir)
    assert os.path.isdir(project.log_dir)


def test_properties():
    assert isinstance(project.name, str)
    assert isinstance(project.description, str)
    # Adjust type as per your implementation
    assert isinstance(project.date, str)
    assert isinstance(project.version, str)


def test_paths():
    assert os.path.isfile(project.logging_config_file)
    assert os.path.isfile(project.access_db_file)
    assert os.path.isfile(project.sqlite_db_file)
    assert os.path.isfile(project.initial_data_file)


def test_connections():
    assert isinstance(project.access_conn_str, str)
    assert isinstance(project.access_uri, str)
    assert isinstance(project.sqlite_uri, str)
    assert isinstance(project.sqlite_memory_uri, str)


def init_db_access():
    def load_initial_data(cls, xl_file, post_processing=None):
        log.info(f"Loading {xl_file} ...")
        xl = cls(xl_file)
        xl.load_data()
        if post_processing:
            post_processing()

        log.info(f"{xl_file} Loaded. \n\n")

    def load_data(cls, xl_file, table, post_processing=None):
        log.info(f"Loading {xl_file} ...")
        this_db = project.get_this_db()
        # Getting a session
        db_generator = this_db.get_db()
        db: Session = next(db_generator)

        try:
            # Example usage of update methods
            db_type = db.bind.dialect.name
            xl = cls(xl_file)
            # Load data from the Excel file
            data_to_insert = xl.load_data()

            # Insert the data into the database
            for data in data_to_insert:
                table_class = this_db.get_table_class(table)
                new_entry = table_class(**data)
                if new_entry.Casino == 'Total':
                    continue
                CRUDRepository.create(db, new_entry)

            db.commit()
        except Exception as e:
            db.rollback()
            log.error(f"Error inserting data: {e}")

        finally:
            # Ensure the generator is exhausted and the session is closed
            next(db_generator, None)

        if post_processing:
            post_processing()

        log.info(f"{xl_file} Loaded. \n")

    def create_db():
        connection_uri = 'sqlite:///:memory:'

        try:
            this_db = ThisDB(connection_uri)
            this_db.init_db(drop_all=True)
            # ensure the availability of the database through the project
            project.set_this_db(this_db)

            this_db = project.get_this_db()

            # Ensure the this_db is initialized before proceeding
            if this_db is None:
                log.error("Database initialization failed.")

            log.info("Database initialized.")

            xl_file = project.initial_data_file
            load_initial_data(XlInitialData, xl_file)
        except Exception as e:
            log.error(f"An error occurred: {e}")
        finally:
            pass

        #return this_db

    create_db()


def assert_db():
    if project.get_this_db() is None:
        init_db_access()


def test_get_casinos():
    assert_db()
    assert len(project.get_casinos()) == 25


def test_get_get_casino_count():
    assert_db()
    assert project.get_casino_count() == 25


def test_get_casino_name_from_dzs_id():
    assert_db()
    assert project.get_casino_name_from_dzs_id('83041663') == 'Baden'


def test_get_settings():
    assert_db()
    params = project.get_settings()
    found = False
    for param in params:
        if param.Name == 'Test_Setting':
            found = True
            break

    assert found


def test_get_resource_strings():
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
    assert_db()
    assert project.get_resource_string('TEST1', 'EN') == 'Test_EN'
    assert project.get_resource_string('TEST1', 'FR') == 'Test_FR'
    assert project.get_resource_string('TEST1', 'DE') == 'Test_DE'
    assert project.get_resource_string('TEST1', 'IT') == 'Test_IT'
    assert project.get_resource_string('TEST1', 'ES') == 'Test_EN'
    assert project.get_resource_string('TEST3', 'EN') is None


def test_get_resource_string_default_value():
    assert_db()
    assert project.get_resource_string('TEST2', 'EN') == 'Test_EN'
    assert project.get_resource_string('TEST2', 'FR') == 'Test_EN'
    assert project.get_resource_string('TEST2', 'DE') == 'Test_EN'
    assert project.get_resource_string('TEST2', 'IT') == 'Test_EN'


def test_get_table_class():
    assert_db

    my_table = project.get_table_class('Casinos')
    assert my_table.__name__ == 'Casinos'
