"""
This module provides a function to process a pandas DataFrame by replacing
NaN values with an empty string (''). The behavior of the replacement depends
on the version of pandas being used.

Functions:
    - versiontuple(v): Converts a version string to a tuple of integers for comparison.
    - map(df): Replaces NaN values in the DataFrame with empty strings to avoid
      insertion errors, with different behavior based on the pandas version.
"""

import pandas as pd

# Get the pandas version
pandas_version = pd.__version__


def versiontuple(v):
    """
    Converts a version string into a tuple of integers for easy comparison.

    Args:
        v (str): The version string to convert (e.g., "2.2.1").

    Returns:
        tuple: A tuple of integers representing the version (e.g., (2, 2, 1)).
    """
    return tuple(map(int, v.split(".")))


def process_dataframe(df):
    """
    Processes the DataFrame by replacing NaN values with empty strings.

    The behavior depends on the pandas version:
    - For pandas versions <= 2.2.1, `applymap` is used.
    - For pandas versions > 2.2.1, `map` is used.

    Args:
        df (pandas.DataFrame): The DataFrame to process.

    Returns:
        pandas.DataFrame: The processed DataFrame with NaN values replaced.
    """
    if versiontuple(pandas_version) <= versiontuple("2.2.1"):
        df = df.applymap(lambda x: '' if pd.isna(x) else x)
    else:
        df = df.map(lambda x: '' if pd.isna(x) else x)
    return df
