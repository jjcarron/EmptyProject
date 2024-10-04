"""
This module defines the ThisProject class, which extends the Project class to manage
project-specific configurations, directories, and database connections.

The ThisProject class includes methods for handling project directories, database paths,
and resource strings, as well as interactions with the ThisDB database. This class is
designed to centralize project configuration and provide utility functions for database
management.

Classes:
    - ThisProject: A class that extends Project to manage project-specific configurations,
      directories, and database connections.

Methods:
    - __init__: Initializes the ThisProject class with specific directories, paths, and
      connection strings.
    - print_attributes: Prints all attributes of the ThisProject instance.
    - set_db_file_path: Sets the file path for the database based on the type.
    - get_connection_uri: Retrieves and formats the connection URI based on the database type.
    - check_and_modify_extension: Ensures that the file has an .mdb extension, modifying it if
      necessary.
    - ensure_access_database_exists: Ensures that the Access database exists, creating it if
      necessary.
    - convert_mdb_to_accdb: Converts an MDB file to an ACCDB file using a PowerShell script.
    - set_this_db: Sets the database object.
    - get_this_db: Retrieves the database object.
    - get_casinos: Retrieves the list of casinos from the database.
    - get_criteria: Retrieves the list of criteria from the database, optionally filtered by
      operation.
    - get_casino_count: Retrieves the total number of casinos from the database.
    - get_casino_name_from_dzs_id: Retrieves the name of a casino based on its DZS ID.
    - get_online_casino_count: Retrieves the total number of online casinos from the database.
    - get_settings: Retrieves the list of settings from the database.
    - get_crossview_infos: Retrieves the crossview information from the database.
    - get_table_class: Retrieves the table class corresponding to the provided table name.
    - get_resource_strings: Retrieves the list of resource strings from the database.
    - get_resource_string: Retrieves a specific resource string based on its reference and language.
    - get_pivot_file_name: Generates the pivot file name based on the operation, language, and
      current date/time.
    - update_crossview_infos: Updates the crossview information in the database for the
      specified language.
"""
# pylint: disable=too-many-instance-attributes

import os
import sys

import pypyodbc
from lib.logger import user_logger as log
from lib.project import Project


class ThisProject(Project):
    """
    This class extends the Project class to manage project-specific
    configurations, directories, and database connections.
    """

    def __init__(self, base_dir, project_config_path):
        """
        Initializes the ThisProject class with specific directories, paths,
        and connection strings.

        Args:
            base_dir (str): The base directory of the project.
            project_config_path (str): The path to the project configuration file.
        """
        super().__init__(base_dir, project_config_path)

        self.input_dir = self.get_dir('input')
        self.output_dir = self.get_dir('output')
        self.templates_dir = self.get_dir('templates')
        self.docs_dir = self.get_dir('docs')
        self.init_dir = self.get_dir('init')
        self.database_dir = self.get_dir('database')
        self.config_dir = self.get_dir('config')
        self.log_dir = self.get_dir('log')
        self.name = self.get_property('name')
        self.description = self.get_property('description')
        self.date = self.get_property('date')
        self.version = self.get_property('version')

        # Paths
        self.logging_config_file = self.get_path('logging_config_file')
        self.access_db_file = self.get_path('access_db_file')
        self.sqlite_db_file = self.get_path('sqlite_db_file')
        self.initial_data_file = self.get_path('initial_xl_data')

        # patterns
        self.input_files_pattern = self.get_pattern('input_files_pattern')

        # Connection information
        self.access_conn_str = self.get_connection('access_conn_str')
        self.access_uri = self.get_connection('access_uri')
        self.sqlite_uri = self.get_connection('sqlite_uri')
        self.sqlite_memory_uri = self.get_connection('sqlite_memory_uri')

        self.this_db = None

    def print_attributes(self):
        """
        Prints all attributes of the ThisProject instance.
        """
        attributes = vars(self)
        for attribute, value in attributes.items():
            print(f"{attribute}: {value}")

    def set_db_file_path(self, db_type, file_path):
        """
        Sets the file path for the database based on the type.

        Args:
            db_type (str): The type of database ('sqlite' or 'access').
            file_path (str): The file path to set for the database.
        """
        if db_type == 'sqlite':
            self.sqlite_db_file = file_path
            log.info("The SQLite database path is set to %s", file_path)
        elif db_type == 'access':
            self.access_db_file = file_path
            log.info("The Access database path is set to %s", file_path)
        else:
            log.warning(
                "The db_type %s is not supported. Using the default name.",
                db_type)

    def get_connection_uri(self, connection_uri):
        """
        Retrieves and formats the connection URI based on the database type.

        Args:
            connection_uri (str): The base connection URI to format.

        Returns:
            str: The formatted connection URI.
        """
        uri = self.get_connection(connection_uri)
        log.info("database_dir = %s", self.database_dir)
        log.info("access_uri = %s", connection_uri)
        if 'Microsoft Access Driver' in uri:
            uri += f"DBQ={self.access_db_file};"
            log.info("access_uri = %s", uri)
            self.ensure_access_database_exists()
        else:
            uri = uri.format(db_path=self.sqlite_db_file)
        return uri

    def check_and_modify_extension(self, file_path):
        """
        Ensures that the file has an .mdb extension, modifying it if necessary.

        Args:
            file_path (str): The original file path.

        Returns:
            str: The file path with an .mdb extension.
        """
        base, ext = os.path.splitext(file_path)
        if ext.lower() != '.mdb':
            new_file_path = base + '.mdb'
            log.info(
                "File extension changed from %s to .mdb for file %s",
                ext,
                file_path)
            return new_file_path
        return file_path

    def ensure_access_database_exists(self):
        """
        Ensures that the Access database exists, creating it if necessary.
        """
        db_path = self.access_db_file
        log.info("Database to create: %s", db_path)
        if not os.path.exists(db_path):
            mdb_path = self.check_and_modify_extension(db_path)

            if not os.path.exists(mdb_path):
                pypyodbc.win_create_mdb(mdb_path)
                log.info("DB: %s created", mdb_path)

            log.error(
                "The database %s doesn't exist and cannot be created programmatically. "
                "Please create it manually.", db_path)
            sys.exit()
        else:
            log.info("DB %s exists", db_path)

    def set_this_db(self, this_db):
        """
        Sets the database object.

        Args:
            this_db (object): Thedatabase object to set.
        """
        self.this_db = this_db

    def get_this_db(self):
        """
        Retrieves the database object.

        Returns:
            object: The database object.
        """
        return self.this_db

    def get_casinos(self):
        """
        Retrieves the list of casinos from the database.

        Returns:
            list: The list of casinos.
        """
        return self.this_db.get_casinos()

    def get_casino_count(self):
        """
        Retrieves the total number of casinos from the database.

        Returns:
            int: The total number of casinos.
        """
        return self.this_db.get_casino_count()

    def get_casino_name_from_dzs_id(self, dzs_id):
        """
        Retrieves the name of a casino based on its DZS ID.

        Args:
            dzs_id (int): The DZS ID of the casino.

        Returns:
            str: The name of the casino.
        """
        return self.this_db.get_casino_name_from_dzs_id(dzs_id)

    def get_online_casino_count(self):
        """
        Retrieves the total number of online casinos from the database.

        Returns:
            int: The total number of online casinos.
        """
        return self.this_db.get_online_casino_count()

    def get_settings(self):
        """
        Retrieves the list of settings from the database.

        Returns:
            list: The list of settings.
        """
        return self.this_db.get_settings()

    def get_table_class(self, table_name):
        """
        Retrieves the table class corresponding to the provided table name.

        Args:
            table_name (str): The name of the table.

        Returns:
            type: The SQLAlchemy model class for the table.
        """
        return self.this_db.get_table_class(table_name)

    def get_resource_strings(self):
        """
        Retrieves the list of resource strings from the database.

        Returns:
            list: The list of resource strings.
        """
        return self.this_db.get_resource_strings()

    def get_resource_string(self, ref, language):
        """
        Retrieves a specific resource string based on its reference and language.

        Args:
            ref (str): The reference for the resource string.
            language (str): The language for the resource string.

        Returns:
            str: The resource string.
        """
        return self.this_db.get_resource_string(ref, language)
