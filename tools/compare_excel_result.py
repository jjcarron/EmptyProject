"""
This script compares two Excel files, identifying and documenting differences
between matching sheets that end with '_Data'. It excludes rows with specific
values in the first column and saves the differences to a new Excel file.

Functions:
    - compare_sheets: Compares two dataframes and returns differences.
    - remove_arosa_and_zermatt: Filters out specific rows.
    - main: Main function to execute the comparison.
"""

import argparse

import pandas as pd

# pylint: disable=abstract-class-instantiated
# this causes a false positive due to pylint error


def remove_arosa_and_zermatt(df):
    """
    Remove rows from DataFrame where the first column is 'Arosa' or 'Zermatt'.

    Args:
        df (DataFrame): DataFrame to filter.
        sheet_name (str): Name of the sheet being filtered.

    Returns:
        DataFrame: Filtered DataFrame.
    """
    first_column = df.columns[0]
    filtered_df = df[~df[first_column].isin(['Arosa', 'Zermatt'])]
    filtered_df.reset_index(drop=True, inplace=True)
    return filtered_df


def read_excel_files(file1_path, file2_path):
    """Reads the Excel files and returns the sheets that end with '_Data'."""
    excel1 = pd.ExcelFile(file1_path)
    excel2 = pd.ExcelFile(file2_path)

    sheets1 = [
        sheet for sheet in excel1.sheet_names if sheet.endswith('_Data')]
    sheets2 = [
        sheet for sheet in excel2.sheet_names if sheet.endswith('_Data')]

    return excel1, excel2, sheets1, sheets2


def find_missing_sheets(sheets1, sheets2, file1_path, file2_path):
    """Finds and prints sheets that are present in one file but not in the other."""
    only_in_file1 = set(sheets1) - set(sheets2)
    only_in_file2 = set(sheets2) - set(sheets1)

    for sheet in only_in_file1:
        print(f"{sheet} exists only in {file1_path}")
    for sheet in only_in_file2:
        print(f"{sheet} exists only in {file2_path}")


def compare_two_dataframes(df1, df2, sheet_name):
    """Compares two DataFrames and returns the differences."""

    # Remove the last row for comparison beccaus it contents a total which is
    # defined when the excel has been opened once
    df1 = df1.iloc[:-1]
    df2 = df2.iloc[:-1]

    if df1.shape != df2.shape:
        print(f"Dimensions of sheets {sheet_name} do not match.")
        return None

    diff = pd.DataFrame(index=df1.index, columns=df1.columns)
    differences_found = False

    for row in df1.index:
        for col in df1.columns:
            val1 = df1.loc[row, col] or 0
            val2 = df2.loc[row, col] or 0

            if pd.isna(val1):
                val1 = 0
            if pd.isna(val2):
                val2 = 0
            # Convertir les valeurs en entiers si possible
            try:
                val1_int = int(val1)
            except (ValueError, TypeError):
                val1_int = None

            try:
                val2_int = int(val2)
            except (ValueError, TypeError):
                val2_int = None

            # Comparaison des valeurs converties
            if val1_int != val2_int:
                diff.loc[row, col] = f"{val1} -> {val2}"
                differences_found = True

    return diff if differences_found else None


def compare_sheets(excel1, excel2, common_sheets):
    """Compares common sheets and returns the differences."""
    differences = {}
    for sheet_name in common_sheets:
        df1 = pd.read_excel(excel1, sheet_name=sheet_name)
        df2 = pd.read_excel(excel2, sheet_name=sheet_name)
        df1 = remove_arosa_and_zermatt(df1)
        df2 = remove_arosa_and_zermatt(df2)

        diff = compare_two_dataframes(
            df1, df2, sheet_name)  # Use the correct function
        if diff is not None:
            differences[sheet_name] = diff
            print(f"{sheet_name:<39} -- Differences found")
        else:
            print(f"{sheet_name:<39} OK")

    return differences


def save_differences(differences, output_file):
    """Saves the differences to an Excel file if there are any."""
    if differences:
        with pd.ExcelWriter(output_file, engine='openpyxl') as writer:
            if differences:
                for sheet_name, diff in differences.items():
                    if diff is not None:
                        diff.to_excel(writer, sheet_name=sheet_name)
                print(
                    f"Comparisons complete. Differences saved in '{output_file}'.")
    else:
        print("No differences found.")


def main(file1_path, file2_path, output_file):
    """
    Main function to compare two Excel files and save the differences.
    """
    excel1, excel2, sheets1, sheets2 = read_excel_files(file1_path, file2_path)

    find_missing_sheets(sheets1, sheets2, file1_path, file2_path)

    common_sheets = set(sheets1).intersection(set(sheets2))

    differences = compare_sheets(excel1, excel2, common_sheets)

    save_differences(differences, output_file)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description='Compare two Excel files and report differences.',
        usage="""Usage: compare_excel_result.py [ARGS]...

        Args:
        -f1, --file1-path   Path to the first file.
        -f2, --file2-path   Path to the second file.
        -of, --output-file  Path to the output file."""
    )

    parser.add_argument('path_to_file1', help='Path to the first Excel file')
    parser.add_argument('path_to_file2', help='Path to the second Excel file')
    parser.add_argument('-of', '--output-file', default='./diffs.xlsx',
                        help='Path to the output Excel file')

    args = parser.parse_args()
    main(args.path_to_file1, args.path_to_file2, args.output_file)
