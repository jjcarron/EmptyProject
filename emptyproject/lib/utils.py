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

import pandas as pd


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
    files = glob.glob(os.path.join(path, "**"), recursive=recursive)

    # Now filter the files with your regex pattern
    matching_files = []
    for f in files:
        match = re.search(pattern, os.path.basename(f))
        if match:
            # Append the file path and the tuple of captured groups (or an
            # empty tuple if no groups)
            matching_files.append((f, match.groups()))

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
    pattern = re.compile("[A-Z0-9]")

    # Find all matches in the input string
    matches = pattern.findall(input_string)

    # Build and return the resulting string
    return "".join(matches)


def format_class_name(table_name):
    """
    Removes the 'tbl_' prefix from the table name (if it exists) and converts the name to CamelCase.

    Args:
        table_name (str): The table name to format.

    Returns:
        str: The formatted class name in CamelCase.
    """
    # Remove 'tbl_' prefix if it exists
    if table_name.startswith("tbl_"):
        table_name = table_name[4:]

    # Split the name by underscores and capitalize each part
    parts = table_name.split("_")
    class_name = "".join(word.capitalize() for word in parts)

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
        case "sqlite":
            return "sqlite_uri"
        case "access":
            return "access_uri"
        case _:
            return None


def get_df_from_slqalchemy_objectlist(objlist):
    """
    Converts a list of SQLAlchemy objects to a DataFrame.

    Args:
        objlist (list): A list of SQLAlchemy objects.

    Returns:
        pandas.DataFrame: A DataFrame containing the data from the SQLAlchemy objects.
    """
    if objlist:
        data = [item.__dict__ for item in objlist]
        for row in data:
            row.pop("_sa_instance_state", None)

        return pd.DataFrame([obj.__dict__ for obj in objlist])

    return None


def convert_to_hours(value):
    """
    Converts various time duration formats into a float representing hours.

    The function supports multiple formats including:
        - "HH:MM h" (e.g., "17:45 h") representing hours and minutes.
        - "10.5 h" or "10,5 h" for decimal hours.
        - "~ 240 minuti" or "240 min" for durations specified in minutes.
        - "2h 19min" representing hours and minutes.
        - "24heures" or "24 heures" for durations specified as whole hours.

    Args:
        value (str): A string containing a time duration in various possible formats.

    Returns:
        float: The duration converted to hours. Returns None if the format is not recognized.

    Examples:
        >>> convert_to_hours("17:45 h")
        17.75
        >>> convert_to_hours("10.5 h")
        10.5
        >>> convert_to_hours("240 minuti")
        4.0
        >>> convert_to_hours("2h 19min")
        2.316666666666667
        >>> convert_to_hours("24heures")
        24.0

    Example usage on a DataFrame column
        df["duration_hours"] = df["raw_duration"].apply(convert_to_hours)
    """
    # Remove extra spaces and convert to lowercase for consistency
    value = value.strip().lower()

    # Define specific cases and regular expressions for each format
    # Case 1: format "17:45 h" or similar (hour:minute)
    match = re.match(r"(\d{1,2}):(\d{2})\s?h?", value)
    if match:
        hours = int(match.group(1))
        minutes = int(match.group(2))
        return hours + minutes / 60.0

    # Case 2: format "10.5 h" or "10,5 h" (decimal hours)
    match = re.match(r"(\d+)[\.,](\d+)\s*[Hh]", value)
    if match:
        return float(match.group(1).replace(",", "."))

    # Case 3: format "240 minuti" (only minutes)
    match = re.match(r"\~*\s*(\d+)\s*[Mm]", value)
    if match:
        minutes = int(match.group(1))
        return minutes / 60.0

    # Case 4: format "2h 19min" (hours and minutes)
    match = re.match(r"(\d+)\s*[Hh][^\d]*(\d+)s*[Mm]", value)
    if match:
        hours = int(match.group(1))
        minutes = int(match.group(2)) if match.group(2) else 0
        return hours + minutes / 60.0

    # Case 5: format "24heures" (hours spelled out)
    match = re.match(r"(\d+)\s*[Hh]", value)
    if match:
        return float(match.group(1))

    # If no pattern is recognized, return None or a default value
    return None


def clean_number(value: str):
    """
    Removes any apostrophes from a number formatted as a string and converts it to a float.

    Args:
        value (str): A string representing a number, possibly containing apostrophes as
        thousands separators.

    Returns:
        value: The cleaned number as string.
    """
    # Remove apostrophes and convert to float
    value = value.replace("'", "")
    return float(value)
