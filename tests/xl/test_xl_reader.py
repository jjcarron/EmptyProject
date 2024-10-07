import pandas as pd
import pytest
from xl.xl_reader import XlReader

"""
This module contains unit tests for the Excel reader functionality.
"""


@pytest.fixture
def mock_excel_file(tmp_path):
    """
    Fixture that creates a temporary Excel file with test data.

    Args:
        tmp_path (pathlib.Path): Temporary directory provided by pytest.

    Returns:
        pathlib.Path: Path to the created temporary Excel file.
    """
    file_path = tmp_path / "test.xlsx"
    with pd.ExcelWriter(file_path) as writer:
        pd.DataFrame({"A": [1, 2, 3], "B": [4, 5, 6]}).to_excel(
            writer, sheet_name="Sheet1", index=False)
        pd.DataFrame({"A": ["ref1", "ref2", "ref3"], "B": [7, 8, 9]}).to_excel(
            writer, sheet_name="Sheet2", index=False)
    return file_path


def test_init(mock_excel_file):
    """
    Test the initialization of XlReader.

    Args:
        mock_excel_file (pathlib.Path): Path to the mock Excel file.
    """
    xl_reader = XlReader(mock_excel_file)
    assert "Sheet1" in xl_reader.df_dict
    assert "Sheet2" in xl_reader.df_dict


def test_get_dataframe(mock_excel_file):
    """
    Test the get_dataframe method of XlReader.

    Args:
        mock_excel_file (pathlib.Path): Path to the mock Excel file.
    """
    xl_reader = XlReader(mock_excel_file)
    df = xl_reader.get_dataframe("Sheet1")
    assert df.equals(pd.DataFrame({"A": [1, 2, 3], "B": [4, 5, 6]}))

    with pytest.raises(ValueError):
        xl_reader.get_dataframe("NonExistentSheet")


def test_find_row_with_ref(mock_excel_file):
    """
    Test the find_row_with_ref method of XlReader.

    Args:
        mock_excel_file (pathlib.Path): Path to the mock Excel file.
    """
    xl_reader = XlReader(mock_excel_file)
    df = xl_reader.get_dataframe("Sheet2")
    assert xl_reader.find_row_with_ref(df, "ref2") == 1
    assert xl_reader.find_row_with_ref(df, "nonexistent") == -1


def test_data(mock_excel_file):
    """
    Test the data method of XlReader.

    Args:
        mock_excel_file (pathlib.Path): Path to the mock Excel file.
    """
    xl_reader = XlReader(mock_excel_file)
    data = xl_reader.data()
    assert data["Sheet1"] == [{"A": 1, "B": 4},
                              {"A": 2, "B": 5}, {"A": 3, "B": 6}]
    assert data["Sheet2"] == [{"A": "ref1", "B": 7},
                              {"A": "ref2", "B": 8}, {"A": "ref3", "B": 9}]


def test_print_data(mock_excel_file):
    """
    Test the print_data method of XlReader.

    Args:
        mock_excel_file (pathlib.Path): Path to the mock Excel file.
    """
    xl_reader = XlReader(mock_excel_file)
    output = xl_reader.print_data()
    expected_output = (
        "Sheet: Sheet1\n"
        "{'A': 1, 'B': 4}\n"
        "{'A': 2, 'B': 5}\n"
        "{'A': 3, 'B': 6}\n"
        "Sheet: Sheet2\n"
        "{'A': 'ref1', 'B': 7}\n"
        "{'A': 'ref2', 'B': 8}\n"
        "{'A': 'ref3', 'B': 9}"
    )
    assert output == expected_output


def test_str(mock_excel_file):
    """
    Test the __str__ method of XlReader.

    Args:
        mock_excel_file (pathlib.Path): Path to the mock Excel file.
    """
    xl_reader = XlReader(mock_excel_file)
    output = str(xl_reader)
    expected_output = (
        "Sheet: Sheet1\n"
        "   A  B\n"
        "0  1  4\n"
        "1  2  5\n"
        "2  3  6\n"
        "Sheet: Sheet2\n"
        "      A  B\n"
        "0  ref1  7\n"
        "1  ref2  8\n"
        "2  ref3  9"
    )
    assert output == expected_output


def test_correct_and_convert_value():
    """
    Test the _correct_and_convert_value method of XlReader.
    """
    xl_reader = XlReader("dummy_path")
    assert xl_reader._correct_and_convert_value("1,234") == 1234.0
    assert xl_reader._correct_and_convert_value("5678") == 5678.0
    assert xl_reader._correct_and_convert_value(
        "not_a_number") == "not_a_number"
