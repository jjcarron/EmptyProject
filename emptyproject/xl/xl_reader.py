"""
This module provides a class `Xl` that facilitates the reading, manipulation, and conversion
of data from Excel files using the pandas and openpyxl libraries. It includes functionality
to load all sheets from an Excel file into a dictionary of DataFrames, retrieve specific
DataFrames, find rows with specific references, and convert DataFrames into various formats
for further processing.

Classes:
    XlReader: A class to handle Excel file operations, including reading sheets, converting data,
    and retrieving specific rows.

Methods:
    __init__(self, file_path, header=0):
        Initializes the `XlReader` object by loading all sheets from the specified Excel file into a
        dictionary of DataFrames.

    get_dataframe(self, sheet_name):
        Retrieves the DataFrame for a specific sheet name.

    find_row_with_ref(self, df, ref):
        Finds the row index in the DataFrame where the reference value is found
        in the first column.

    data(self):
        Converts each DataFrame in the dictionary to a list of dictionaries.

    print_data(self):
        Prints the contents of the Excel sheets as a string of dictionaries.

    __str__(self):
        Returns a string representation of the Excel sheets and their contents.

    _correct_and_convert_value(self, value):
        Corrects and converts a string value to its appropriate numeric type, if possible.
"""

# pylint: disable=broad-exception-caught

import warnings

import pandas as pd
from shared import dlog


class XlReader:
    """
    The XlReader class is used to interact with Excel files, providing methods to load and
    manipulate data from Excel sheets into pandas DataFrames.

    Attributes:
        file_path (str): The path to the Excel file.
        df_dict (dict): A dictionary containing sheet names as keys and
        corresponding DataFrames as values.
    """

    def __init__(self, file_path, header=0):
        """
        Initializes the XlReader object by reading all sheets from the specified Excel file
        into a dictionary of DataFrames.

        Args:
            file_path (str): The path to the Excel file.
            header (int, optional): The row number to use as the column names for the DataFrame.
                                    Defaults to 0.
        """
        self.file_path = file_path
        self.df_dict = None
        try:
            # Suppress specific UserWarning from openpyxl
            with warnings.catch_warnings():
                warnings.simplefilter("ignore", UserWarning)
                # Read all sheets into a dictionary of DataFrames
                self.df_dict = pd.read_excel(
                    self.file_path, sheet_name=None, header=header)
        except Exception as e:
            dlog.info("Error reading Excel file %s: %s", self.file_path, e)

    def get_dataframe(self, sheet_name):
        """
        Retrieves the DataFrame for a specific sheet name.

        Args:
            sheet_name (str): The name of the sheet to retrieve.

        Returns:
            pandas.DataFrame: The DataFrame corresponding to the specified sheet name.

        Raises:
            ValueError: If the sheet name does not exist in the Excel file.
        """
        if sheet_name in self.df_dict:
            return self.df_dict[sheet_name]

        raise ValueError(
            f"No sheet named '{sheet_name}' found in the Excel file.")

    def find_row_with_ref(self, df, ref):
        """
        Finds the row index in the DataFrame where the reference value is found
        in the first column.

        Args:
            df (pandas.DataFrame): The DataFrame to search.
            ref (str): The reference value to find in the first column.

        Returns:
            int: The index of the row containing the reference value. Returns -1 if not found.
        """
        for index, value in enumerate(df.iloc[:, 0]):
            if value == ref:
                return index
        return -1

    def data(self):
        """
        Converts each DataFrame in the dictionary to a list of dictionaries.

        Returns:
            dict: A dictionary where each key is a sheet name and the corresponding value
            is a list of dictionaries representing the rows of the DataFrame.
        """
        if self.df_dict:
            return {sheet: df.to_dict(orient='records')
                    for sheet, df in self.df_dict.items()}

        return None

    def print_data(self):
        """
        Generates a string representation of the Excel sheets and their data.

        Returns:
            str: A string representation of the data from all sheets, or "None" if
            no data is available.
        """
        if self.data():
            output = []
            for sheet_name, sheet_data in self.data().items():
                output.append(f"Sheet: {sheet_name}")
                for record in sheet_data:
                    output.append(str(record))
            return "\n".join(output)

        return "None"

    def __str__(self):
        """
        Returns a string representation of the Excel sheets and their DataFrames.

        Returns:
            str: A string representation of the DataFrames from all sheets, or "None" if
            no data is available.
        """
        if self.df_dict:
            output = []
            for sheet_name, df in self.df_dict.items():
                output.append(f"Sheet: {sheet_name}")
                output.append(df.__repr__())
            return "\n".join(output)

        return "None"

    def _correct_and_convert_value(self, value):
        """
        Corrects and converts a string value to its appropriate numeric type, if possible.

        Args:
            value (str): The value to correct and convert.

        Returns:
            float | int | str: The corrected and converted value. Returns the original value if
            conversion is not possible.
        """
        if isinstance(value, str):
            # Remove unwanted characters like apostrophes and commas
            _value = value.replace("'", "").replace(",", "")
            try:
                # Convert to float or int
                return float(_value)
            except ValueError:
                # Handle the case where conversion is not possible
                return value
        return value
