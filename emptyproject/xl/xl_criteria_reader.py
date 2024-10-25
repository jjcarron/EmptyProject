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


class XlCriteriaReader(XlReader):
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

    def load_data(self, tables):
        """
        Load and process data from the 'Sentences' sheet in the Excel file.

        This method reads data from the 'Sentences' sheet, processes the data,
        and prepares it for insertion into a table with columns: dimension_1, dimension_2,
        criterion_key, numeric_value, and text_value.

        Returns:
            list: A list of dictionaries representing the processed data.
        """
        _ = tables  # not used in this case
        df = self.get_dataframe("Sentences")
        df = self.cleanup_df(df)

        data = []
        try:
            for index, row in df.iterrows():
                sentence = row["sentence"]
                sentence = sentence[:-32]
                category_key = row["category_key"]

                # Calculate numeric values based on the sentence
                # Number of letters in the sentence
                num_letters = len(sentence)
                num_a = sum(
                    1 for char in sentence if char.lower() == "a"
                )  # Number of 'a' or 'A'
                # Number of words in the sentence
                num_words = len(sentence.split())

                # Prepare entries for each criterion
                criteria = [
                    {"criterion_key": "C_1", "numeric_value": num_letters},
                    {"criterion_key": "C_2", "numeric_value": num_a},
                    {"criterion_key": "C_3", "numeric_value": num_words},
                ]

                # Populate new entries for each criterion
                for criterion in criteria:
                    new_entry = {
                        "dimension_1": f"S_{(index + 1):02}",
                        "dimension_2": category_key,
                        "criterion_key": criterion["criterion_key"],
                        "numeric_value": criterion["numeric_value"],
                        "text_value": sentence,
                    }
                    data.append(new_entry)

        except KeyError as e:
            print(f"KeyError: {e} not found in the row")

        return data
