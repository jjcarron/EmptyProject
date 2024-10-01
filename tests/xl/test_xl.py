import pandas as pd
import pytest
from xl.xl import Xl


@pytest.fixture
def xl_instance(tmp_path):
    # Create a temporary Excel file for testing
    file_path = tmp_path / "test.xlsx"
    df1 = pd.DataFrame({"A": [1, 2, 3], "B": [4, 5, 6]})
    df2 = pd.DataFrame({"A": ["x", "y", "z"], "B": ["a", "b", "c"]})
    with pd.ExcelWriter(file_path) as writer:
        df1.to_excel(writer, sheet_name="Sheet1", index=False)
        df2.to_excel(writer, sheet_name="Sheet2", index=False)
    return Xl(file_path)


def test_get_dataframe(xl_instance):
    df = xl_instance.get_dataframe("Sheet1")
    assert df.equals(pd.DataFrame({"A": [1, 2, 3], "B": [4, 5, 6]}))

    df = xl_instance.get_dataframe("Sheet2")
    assert df.equals(pd.DataFrame(
        {"A": ["x", "y", "z"], "B": ["a", "b", "c"]}))

    with pytest.raises(ValueError):
        xl_instance.get_dataframe("NonExistentSheet")


def test_find_row_with_ref(xl_instance):
    df = xl_instance.get_dataframe("Sheet1")
    assert xl_instance.find_row_with_ref(df, 2) == 1
    assert xl_instance.find_row_with_ref(df, 5) == -1

    df = xl_instance.get_dataframe("Sheet2")
    assert xl_instance.find_row_with_ref(df, "y") == 1
    assert xl_instance.find_row_with_ref(df, "d") == -1


def test_data(xl_instance):
    data = xl_instance.data()
    expected_data = {
        "Sheet1": [{"A": 1, "B": 4}, {"A": 2, "B": 5}, {"A": 3, "B": 6}],
        "Sheet2": [{"A": "x", "B": "a"}, {"A": "y", "B": "b"}, {"A": "z", "B": "c"}]
    }
    assert data == expected_data


def test_print_data(xl_instance):
    output = xl_instance.print_data()
    expected_output = (
        "Sheet: Sheet1\n"
        "{'A': 1, 'B': 4}\n"
        "{'A': 2, 'B': 5}\n"
        "{'A': 3, 'B': 6}\n"
        "Sheet: Sheet2\n"
        "{'A': 'x', 'B': 'a'}\n"
        "{'A': 'y', 'B': 'b'}\n"
        "{'A': 'z', 'B': 'c'}"
    )
    assert output == expected_output


def test_str(xl_instance):
    output = str(xl_instance)
    expected_output = (
        "Sheet: Sheet1\n"
        "   A  B\n"
        "0  1  4\n"
        "1  2  5\n"
        "2  3  6\n"
        "Sheet: Sheet2\n"
        "   A  B\n"
        "0  x  a\n"
        "1  y  b\n"
        "2  z  c"
    )
    assert output == expected_output


def test_correct_and_convert_value(xl_instance):
    assert xl_instance._correct_and_convert_value("1,234") == 1234.0
    assert xl_instance._correct_and_convert_value("1.234") == 1.234
    assert xl_instance._correct_and_convert_value("1234") == 1234.0
    assert xl_instance._correct_and_convert_value("abc") == "abc"
    assert xl_instance._correct_and_convert_value(1234) == 1234
