import pytest
import pandas as pd
from emptyproject.lib.pd_version_dependent_code_example import versiontuple, process_dataframe

def test_versiontuple():
    assert versiontuple("2.2.1") == (2, 2, 1)
    assert versiontuple("1.10.5") == (1, 10, 5)
    assert versiontuple("0.23.4") == (0, 23, 4)

def test_process_dataframe_applymap(monkeypatch):
    # Mock pandas version to be <= 2.2.1
    monkeypatch.setattr(pd, '__version__', '2.2.1')
    
    df = pd.DataFrame({
        'A': [1, None, 3],
        'B': [None, 2, 3]
    })
    
    expected_df = pd.DataFrame({
        'A': [1, '', 3],
        'B': ['', 2, 3]
    })
    
    result_df = process_dataframe(df)
    pd.testing.assert_frame_equal(result_df, expected_df)

def test_process_dataframe_map(monkeypatch):
    # Mock pandas version to be > 2.2.1
    monkeypatch.setattr(pd, '__version__', '2.2.2')
    
    df = pd.DataFrame({
        'A': [1, None, 3],
        'B': [None, 2, 3]
    })
    
    expected_df = pd.DataFrame({
        'A': [1, '', 3],
        'B': ['', 2, 3]
    })
    
    result_df = process_dataframe(df)
    pd.testing.assert_frame_equal(result_df, expected_df)