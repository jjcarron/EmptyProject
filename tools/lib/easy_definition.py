"""
This module provides the Definitions class, which is used to parse and store definitions
from a given file. Each definition is expected to be in the format 'name = value;'. The
module offers methods to retrieve all definitions or a specific definition by name.

Classes:
    Definitions: Parses a file to extract and store name-value pairs as definitions.
"""

import re

# easy_definitions.py


class Definitions:
    """
    A class to parse and store definitions from a given file.

    Attributes:
        definitions (list): A list of tuples containing definition names and
        their corresponding values.
    """

    def __init__(self, filename):
        """
        Initializes the Definitions class and parses the definitions from
        the given file.

        Args:
            filename (str): The path to the file containing the definitions.
        """
        self.definitions = []
        self.parse_definitions(filename)

    def parse_definitions(self, file_path):
        """
        Parses the definitions from the specified file.

        Args:
            file_path (str): The path to the file to parse.
        """
        current_definition_name = None
        current_definition = []

        with open(file_path, 'r', encoding='utf-8') as file:
            for line in file:
                line = line.strip()
                if line.startswith("'") or not line:
                    continue
                match = re.match(r'^(\w+)\s*=\s*(.*?);?$', line)
                if match:
                    if current_definition_name is not None:
                        self.definitions.append(
                            (current_definition_name,
                             ' '.join(current_definition).rstrip(';').strip())
                        )
                    current_definition_name = match.group(1)
                    current_definition = [match.group(2)]
                else:
                    current_definition.append(line.strip())

        if current_definition_name and current_definition:
            self.definitions.append(
                (current_definition_name,
                 ' '.join(current_definition).rstrip(';').strip())
            )

    def get_definitions(self):
        """
        Returns all parsed definitions.

        Returns:
            list: A list of tuples containing definition names and their corresponding values.
        """
        return self.definitions

    def get_definition(self, name):
        """
        Retrieves a specific definition by its name.

        Args:
            name (str): The name of the definition to retrieve.

        Returns:
            tuple: A tuple containing the definition name and its value, or
            (name, None) if not found.
        """
        for def_name, def_value in self.definitions:
            if def_name == name:
                return def_name, def_value
        return name, None
