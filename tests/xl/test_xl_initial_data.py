from unittest.mock import MagicMock, patch

import pandas as pd
import pytest
from xl.xl_initial_data import XlInitialData


@pytest.fixture
def mock_db_instance():
    mock_db = MagicMock()
    mock_db.get_session.return_value = MagicMock()
    mock_db.get_table_class.return_value = MagicMock()
    return mock_db


@pytest.fixture
def mock_project(mock_db_instance):
    with patch('xl.xl_initial_data.project.get_this_db', return_value=mock_db_instance):
        yield


@pytest.fixture
def mock_log():
    with patch('xl.xl_initial_data.log') as mock_log:
        yield mock_log


@pytest.fixture
def xl_initial_data():
    with patch('xl.xl_initial_data.Xl.__init__', return_value=None):
        xl_initial_data = XlInitialData("dummy_path")
        xl_initial_data.df_dict = {
            'Sheet1': pd.DataFrame({
                'Column1': [1, 2],
                'Column2': ['A', 'B']
            })
        }
        yield xl_initial_data


def test_load_data_success(
        mock_project,
        mock_log,
        xl_initial_data,
        mock_db_instance):
    session = mock_db_instance.get_session.return_value
    table_class = mock_db_instance.get_table_class.return_value

    xl_initial_data.load_data()

    assert session.add.call_count == 2
    assert session.commit.called
    assert mock_log.info.called_with("Data inserted successfully.")


def test_load_data_error(
        mock_project,
        mock_log,
        xl_initial_data,
        mock_db_instance):
    session = mock_db_instance.get_session.return_value
    session.add.side_effect = Exception("Insertion error")

    xl_initial_data.load_data()

    assert session.rollback.called
    assert mock_log.error.called_with("Error inserting data: Insertion error")


def test_load_data_no_db_instance(mock_log):
    with patch('xl.xl_initial_data.project.get_this_db', return_value=None):
        with pytest.raises(SystemExit):
            xl_initial_data = XlInitialData("dummy_path")
            xl_initial_data.load_data()

    assert mock_log.error.called_with(
        "The database instance is not initialized: None")
