"""
This module provides a class to handle the loading and processing of Gross Gaming Revenue (GGR)
data from an Excel file.

The `XlSimpleReader` class is used to read and process data from specified sheets within an
Excel file.

Classes:
    XlSimpleReader: A class for handling and processing SimpleFile data from an Excel file.

Usage:
    The `XlSimpleReader` class is instantiated with the path to an Excel file and can be used
    to load data by calling the `load_data()` method. This method returns a list of dictionaries,
    where each dictionary represents a row to be inserted into the database.

Example:
    ggr_loader = XlSimpleReader('path_to_excel_file.xlsx')
    data_to_insert = ggr_loader.load_data()

    # `data_to_insert` can then be used to insert records into a database.
"""

from xl.xl_reader import XlReader


class XlSimpleReader(XlReader):
    """
    A class to handle the loading and processing of data from an Excel file.

    This class reads data from specified sheets within an Excel file and
    prepares it for insertion into a database.

    Args:
        file_path (str): The path to the Excel file.
        match (object): Regex match object containing metadata for the file.
    """

    def cleanup_df(self, df):
        """
        Clean up the DataFrame by removing unnecessary columns.

        This method removes columns without a title and those named 'Unnamed',
        which typically represent empty or irrelevant data in Excel sheets.

        Args:
            df (pd.DataFrame): The DataFrame to clean.

        Returns:
            pd.DataFrame: The cleaned DataFrame.
        """
        df = df.dropna(axis=1, how="all")
        df = df.loc[:, ~df.columns.str.contains("^Unnamed")]
        return df

    def load_categories(self):
        """
        Load and process data from the 'Categories' sheet in the Excel file.

        This method reads data from the 'Categories' sheet, cleans up the DataFrame,
        and converts it into a list of dictionaries for database insertion.

        Returns:
            list: A list of dictionaries representing the 'Categories' data.
        """
        df = self.get_dataframe("Categories")
        df = self.cleanup_df(df)

        data = []
        try:
            for _, row in df.iterrows():
                new_entry = {"key": row["key"], "category": row["category"]}
                data.append(new_entry)
        except KeyError as e:
            print(f"KeyError: {e} not found in the row")

        return data

    def load_sentences(self):
        """
        Load and process data from the 'Sentences' sheet in the Excel file.

        This method reads data from the 'Sentences' sheet, cleans up the DataFrame,
        and converts it into a list of dictionaries for database insertion. The 'year' field
        is extracted from the file name using the match object.

        Returns:
            list: A list of dictionaries representing the 'Sentences' data.
        """
        df = self.get_dataframe("Sentences")
        df = self.cleanup_df(df)

        data = []
        try:
            for _, row in df.iterrows():
                new_entry = {
                    "category_key": row["category_key"],
                    "sentence": row["sentence"],
                    "year": self.match.group(2),
                }
                data.append(new_entry)
        except KeyError as e:
            print(f"KeyError: {e} not found in the row")

        return data

    def load_data(self, table):
        """
        Load and process data from the specified sheet in the Excel file.

        This method reads data from the specified table ('Categories' or 'Sentences'),
        processes it, and prepares it for database insertion.

        Args:
            table (str): The name of the table/sheet to load ('Categories' or 'Sentences').

        Returns:
            list: A list of dictionaries, where each dictionary represents a row to be inserted
            into the database.
        """
        if table == "Categories":
            data_to_insert = self.load_categories()
        elif table == "Sentences":
            data_to_insert = self.load_sentences()
        else:
            data_to_insert = []

        return data_to_insert
