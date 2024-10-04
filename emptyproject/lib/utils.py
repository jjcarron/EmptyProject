"""
This module provides utility functions for string manipulation and database URI retrieval.
Functions:
    create_short_name(input_string):
        Generates a short name by extracting all capital letters and digits from the input string.
    format_class_name(table_name):
    get_uri_str(db_type):
"""
# pylint: disable=duplicate-code

import glob
import os
import re


def find_files_by_pattern(path, pattern, recursive=False):
    """
    Find files in a specified directory that match the given pattern.

    :param path: The directory path where to search for the files.
    :param pattern: The pattern to search for, such as '*.py' or '*_test.py'.
    :return: A list of matching file paths.
    """
    # Ensure path ends with a slash (if necessary)
    if not path.endswith(os.sep):
        path += os.sep

    # Use glob to get all .xlsx files in the directory
    files = glob.glob(os.path.join(path, '**'), recursive=recursive)

    # Now filter the files with your regex pattern
    matching_files = [
        f for f in files if re.search(
            pattern, os.path.basename(f))]

    return matching_files


def create_short_name(input_string):
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
