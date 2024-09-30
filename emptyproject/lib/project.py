"""
This module provides the Project class, which handles project configuration
and path management in a singleton pattern.

The Project class is designed to load configuration from a YAML file, manage
project-related paths, directories, and properties, and provide access to
various project elements such as connections and other configurable settings.

Classes:
    - Project: A singleton class that manages project configuration and paths.
"""

import os
import re

import yaml
from lib.singleton_meta import SingletonMeta

# pylint: disable=broad-exception-caught


class Project(metaclass=SingletonMeta):
    """
    Singleton class that handles project configuration and paths management.

    Attributes:
        base_dir (str): The base directory where the project resides.
        config_file (str): The path to the project's configuration YAML file.
        config (dict): The configuration loaded from the YAML file.
    """

    def __init__(self, base_dir, project_config_filename):
        """
        Initializes the Project instance with the base directory and configuration file.

        Args:
            base_dir (str): The base directory where the project resides.
            project_config_filename (str): The filename of the project's
                                           configuration file.
        """
        self.base_dir = base_dir
        self.config_file = os.path.join(self.base_dir, project_config_filename)
        self.config = self._load_config()

    def _load_config(self):
        """
        Loads the YAML configuration file.

        Returns:
            dict: The configuration data loaded from the YAML file.
        """
        with open(self.config_file, 'r', encoding='utf-8') as f:
            return yaml.safe_load(f)

    def get_path(self, key):
        """
        Retrieves and resolves the path corresponding to a given key from the configuration.

        Args:
            key (str): The key for which the path is to be retrieved.

        Returns:
            str: The resolved absolute path.
        """
        path = self.config['project']['paths'].get(key)
        return self._resolve_path(self._replace_variables(path))

    def get_mask(self, key):
        """
        Retrieves and resolves the path corresponding to a given key from the configuration.

        Args:
            key (str): The key for which the path is to be retrieved.

        Returns:
            str: The resolved absolute path.
        """
        mask = self.config['project']['masks'].get(key)
        return mask

    def get_dir(self, key):
        """
        Retrieves and resolves the directory path corresponding to a given key
        from the configuration.

        Args:
            key (str): The key for which the directory path is to be retrieved.

        Returns:
            str: The resolved absolute directory path.
        """
        path = self.config['project']['dirs'].get(key)
        return self._resolve_path(self._replace_variables(path))

    def get_element(self, element, key):
        """
        Retrieves a specific element from the configuration.

        Args:
            element (str): The element name (e.g., 'other_elements').
            key (str): The key within the element to retrieve.

        Returns:
            Any: The value corresponding to the element and key.
        """
        return self.config['project']['other_elements'][element].get(key)

    def get_property(self, key):
        """
        Retrieves a property value from the configuration.

        Args:
            key (str): The key of the property to retrieve.

        Returns:
            Any: The value of the property.
        """
        return self.config['project']['properties'].get(key)

    def _resolve_path(self, path):
        """
        Resolves a relative path to an absolute path based on the base directory.

        Args:
            path (str): The path to resolve.

        Returns:
            str: The resolved absolute path, or an empty string if an error occurs.
        """
        try:
            if not path:  # Check if the path is empty or None
                raise ValueError("The path is empty or None.")

            if os.path.isabs(path):
                return path

            return os.path.abspath(os.path.join(self.base_dir, path))

        except Exception as e:
            # Log the error and return an empty string
            print(f"Error resolving path: {e}")
            return ""

    def _replace_variables(self, text):
        """
        Replaces variables within a text with corresponding values from the
        configuration.

        Args:
            text (str): The text in which to replace variables.

        Returns:
            str: The text with variables replaced.
        """
        if not isinstance(text, str):
            return text

        def replacer(match):
            """
            Internal function to replace matched variables with their values.

            Args:
                match (re.Match): The regex match object containing the variable
                                  name.

            Returns:
                str: The value of the variable from the configuration.
            """
            variable_name = match.group(1)
            variable_value = (
                self.config['project']['dirs'].get(variable_name, '') or
                self.config['project']['paths'].get(variable_name, '') or
                self.config['project']['connections'].get(variable_name, '') or
                self.config['project']['properties'].get(variable_name, '')
            )
            return self._replace_variables(variable_value)

        return re.sub(r'\[([^\]]+)\]', replacer, text)

    def get_connection(self, key):
        """
        Retrieves a connection string from the configuration and resolves
        any variables.

        Args:
            key (str): The key of the connection to retrieve.

        Returns:
            str: The resolved connection string.
        """
        return self._replace_variables(
            self.config['project']['connections'].get(key)
        )
