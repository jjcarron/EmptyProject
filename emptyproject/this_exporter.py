"""
This module provides the ThisExporter class, which extends the DatabaseExporter class to implement
specific project-related Excel export functionalities. It includes methods to retrieve letter and
vowel counts from sentences in a database, export these counts to Excel sheets, and generate pivot
tables and charts based on the data.
Classes:
- ThisExporter: Handles the export of letter and vowel counts, pivot tables, and charts to Excel
  sheets.
Dependencies:
- pandas as pd
- DatabaseExporter from lib.db_exporter
- log from shared
- ChartLabels, XlSheetWriter, XlWriter from xl.xl_writer
"""

# import pandas as pd
from lib.db_exporter import DatabaseExporter
# from xl.xl_pivot_writer import
from lib.utils import get_df_from_slqalchemy_objectlist

# from xl.xl_writer import ChartLabels


class ThisExporter(DatabaseExporter):
    """
    ThisExporter is responsible for specific project-related Excel export functionalities.
    It extends the base functionalities provided by DatabaseExporter to implement the
    required project logic.
    """

    def __init__(self, database, file, writer=None, language="en"):
        """
        Initializes the DatabaseExporter object with the specified database type.

        Args:
            database: The database object.
            writer: The class responsible for writing the data.
            xl_file (str): The path to the Excel file.
            language: used for the export. It defaults to 'en'
        """
        self.language = language
        if writer is None:
            super().__init__(database, file)
        else:
            super().__init__(database, file, writer)

    # def get_letter_df(self, n=0):
        # """
        # Retrieve a DataFrame containing the letter counts from sentences in
        # the database.

        # Parameters:
        # - n (int): Number of sentences to process (default is 0, which means all sentences).

        # Returns:
        # - pd.DataFrame: A DataFrame containing letters and their respective counts.
        # """
        # return pd.DataFrame(self.database.get_sentences_letters_count(n))

    # def get_wowel_df(self, n=0):
        # """
        # Retrieve a DataFrame containing the vowel counts from sentences.

        # Parameters:
        # - n (int): Number of sentences to process (default is 0, which means all sentences).

        # Returns:
        # - pd.DataFrame: A DataFrame filtered to contain only vowels and their counts.
        # """
        # df_letter_count = self.get_letter_df(n)
        # vowels = ["a", "e", "i", "o", "u", "y"]

        # # Filter lines with vowels
        # return df_letter_count[df_letter_count["letter"].isin(vowels)]

    # def export_letter_count(self, sheet_name, title="", n=0):
        # """
        # Export the letter count data to an Excel sheet.

        # Parameters:
        # - sheet_name (str): Name of the Excel sheet.
        # - title (str): Title of the Excel sheet. If not provided, the sheet name is used.
        # - n (int): Number of sentences to process (default is 0, which means all sentences).

        # Returns:
        # - XlSheetWriter: The sheet object after export.
        # """
        # df_letter_count = self.get_letter_df(n)
        # sh = self.writer.add_sheet(sheet_name, df_letter_count)
        # sh.format_worksheet()
        # sh.page_print_setting()
        # sh.adjust_column_width()
        # if title == "":
            # title = sheet_name
        # sh.define_header_and_footer(title)
        # return sh

    # def export_wowel_count(self, sheet_name, title="", n=0):
        # """
        # Export the vowel count data to an Excel sheet.

        # Parameters:
        # - sheet_name (str): Name of the Excel sheet.
        # - title (str): Title of the Excel sheet. If not provided, the sheet name is used.
        # - n (int): Number of sentences to process (default is 0, which means all sentences).

        # Returns:
        # - XlSheetWriter: The sheet object after export.
        # """
        # df_letter_count = pd.DataFrame(
            # self.database.get_sentences_letters_count(n))
        # vowels = ["a", "e", "i", "o", "u", "y"]

        # # Filter lines with vowels
        # df_vowels = df_letter_count[df_letter_count["letter"].isin(vowels)]
        # sh = self.writer.add_sheet(sheet_name, df_vowels)
        # sh.finalize_sheet(title=title)
        # return sh

    # def export_pivot(self, df, sheet_name, title=""):
        # """
        # Export a pivot table to an Excel sheet, with letters as rows and
        # sentence IDs as columns.

        # Parameters:
        # - df (pd.DataFrame): DataFrame to pivot.
        # - sheet_name (str): Name of the Excel sheet.
        # - title (str): Title of the Excel sheet.

        # Returns:
        # - XlSheetWriter: The sheet object after export.
        # """
        # min_val = int(df["sentence_id"].min())
        # max_val = int(df["sentence_id"].max())
        # all_val = list(range(min_val, max_val + 1))
        # pivot_table_df = df.pivot(
            # index="letter", columns="sentence_id", values="occurrence"
        # )
        # pivot_table_df = pivot_table_df.reindex(columns=all_val, fill_value=0)
        # pivot_table_df = pivot_table_df.reset_index()
        # sh = self.writer.add_sheet(sheet_name, pivot_table_df)
        # sh.finalize_sheet(portrait=False, title=title)
        # return sh

    # def export_chart(self, data_sheet, chart_sheet_name, labels):
        # """
        # Export a chart based on the provided data sheet.

        # Parameters:
        # - data_sheet (XlSheetWriter): The sheet containing the data for the chart.
        # - chart_sheet_name (str): Name of the Excel chart sheet.
        # - labels (ChartLabels): ChartLabels object specifying the title and axis labels.

        # Returns:
        # - XlSheetWriter: The chart sheet object.
        # """
        # sh = self.writer.add_chart_sheet(data_sheet, chart_sheet_name, labels)
        # if sh:
            # sh.create_chart()
        # return sh

    def export_generated_pivots(self):
        """
        process formulas from pivot_information_df and create
        pivot tables

        """
        pivot_information_df = get_df_from_slqalchemy_objectlist(
            self.database.get_all("PivotInfos")
        )
        self.writer.add_index_sheet(pivot_information_df)
        data_df = get_df_from_slqalchemy_objectlist(
            self.database.get_all("CriterionValues")
        )

        # check for duplicates
        duplicated_rows = data_df[data_df.duplicated(
            subset=["criterion_key", "dimension_1", "dimension_2"], keep=False)]
        if not duplicated_rows.empty:
            print("Duplicates found (displaying the first 20):")
            print(duplicated_rows.head(20))
            print(f"Total number of duplicates: {len(duplicated_rows)}")
            raise ValueError("Duplicates exist in the data")

        data_df.columns = data_df.columns.str.strip()
        self.writer.create_pivot_tables(data_df, pivot_information_df)

    # def export_all(self):
        # """
        # Export all required sheets, including letter count, vowel count, and pivot tables.
        # Also generates corresponding charts.

        # Returns:
        # None
        # """
        # self.export_letter_count("letters", "letter title")
        # self.export_wowel_count("wowels")
        # self.export_letter_count("letters_20", 20)
        # self.export_wowel_count("wowels_20", 20)

        # sh = self.export_pivot(
        # self.get_letter_df(20), "letter_pivot", "Occurrences of letters"
        # )
        # labels = ChartLabels(
        # title="Occurrences of letters",
        # x_label="sentences",
        # y_label="occurrences")
        # self.export_chart(sh, "letter_chart", labels)

        # sh = self.export_pivot(
        # self.get_wowel_df(20), "wowel_pivot", "Occurrences of vowels"
        # )
        # labels = ChartLabels(
        # title="Occurrences of vowels",
        # x_label="sentences",
        # y_label="occurrences")
        # self.export_chart(sh, "wowel_chart", labels)
