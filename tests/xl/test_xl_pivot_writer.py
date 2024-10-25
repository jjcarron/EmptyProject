import pandas as pd
import pytest
from xl_pivot_writer import XlPivotWriter


@pytest.fixture
def sample_data():
    """
    Fixture that provides sample data for the pivot table.
    """
    data = {
        "criterion_key": ["criterion_1", "criterion_2"],
        "index": ["casino", "setting"],
        "columns": ["data_1", "data_2"],
        "value": [10, 40]
    }
    return pd.DataFrame(data)


@pytest.fixture
def sample_pivot_info():
    """
    Fixture that provides sample pivot table information (mock formulas).
    """
    data = {
        "query_name": ["query_1", "query_2"],
        "formula": ["4 + 4 * 5 * data_1", "data_2"],
        "draw_total": [True, True],
        "draw_delta": [False, True]
    }
    return pd.DataFrame(data)


@pytest.fixture
def xl_pivot_writer_instance(tmp_path):
    """
    Fixture that provides an instance of XlPivotWriter with a temporary file path.
    """
    xl_file = tmp_path / "test_pivot.xlsx"
    writer = XlPivotWriter(str(xl_file))
    return writer


def test_create_criterion_pivots(xl_pivot_writer_instance, sample_data):
    """
    Test the creation of pivot tables for unique criterion keys.
    """
    criterion_pivots, criteria = xl_pivot_writer_instance.create_criterion_pivots(
        sample_data)

    # Ensure two criteria are found
    assert len(criterion_pivots) == 2
    assert "criterion_1" in criterion_pivots
    assert "criterion_2" in criterion_pivots

    # Validate the shape of the pivot table for "criterion_1"
    pivot_table = criterion_pivots["criterion_1"]
    # Criterion 1 has 2 rows and 2 columns (data_1)
    assert pivot_table.shape == (1, 2)


def test_process_formula(
        xl_pivot_writer_instance,
        sample_data,
        sample_pivot_info):
    """
    Test the processing of formulas on the generated pivot tables.
    """
    criterion_pivots, criteria = xl_pivot_writer_instance.create_criterion_pivots(
        sample_data)

    # Process the formula for the first query
    formula = "3*4"
    result_df = xl_pivot_writer_instance.process_formula(
        criterion_pivots, criteria, formula)

    # Ensure result is a DataFrame and is not empty
    assert isinstance(result_df, pd.DataFrame)
    assert not result_df.empty
    assert result_df.shape[0] > 0


def test_process_formula(
        xl_pivot_writer_instance,
        sample_data,
        sample_pivot_info):
    """
    Test the processing of formulas on the generated pivot tables.
    """
    criterion_pivots, criteria = xl_pivot_writer_instance.create_criterion_pivots(
        sample_data)

    # Process the formula for the first query
    formula = "data_2 + data_1"
    result_df = xl_pivot_writer_instance.process_formula(
        criterion_pivots, criteria, formula)

    # Ensure result is a DataFrame and is not empty
    assert isinstance(result_df, pd.DataFrame)
    assert not result_df.empty
    assert result_df.shape[0] > 0
