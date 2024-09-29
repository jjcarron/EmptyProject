"""
This module provides a utility functions

"""

import re


def create_short_name(input_string: str) -> str:
    """
    Generates a short name by extracting all capital letters and digits
    from the input string.

    Args:
        input_string (str): The string from which to generate the short name.

    Returns:
        str: A string composed of all capital letters and digits found in
             the input string.
    """
    # Define the regex pattern for capital letters and digits
    pattern = re.compile('[A-Z0-9]')

    # Find all matches in the input string
    matches = pattern.findall(input_string)

    # Build and return the resulting string
    return ''.join(matches)


def format_class_name(table_name):
    """
    Removes the 'tbl_' prefix from the table name (if it exists) and converts the name to CamelCase.

    Args:
        table_name (str): The table name to format.

    Returns:
        str: The formatted class name in CamelCase.
    """
    # Remove 'tbl_' prefix if it exists
    if table_name.startswith('tbl_'):
        table_name = table_name[4:]

    # Split the name by underscores and capitalize each part
    parts = table_name.split('_')
    class_name = ''.join(word.capitalize() for word in parts)

    return class_name
