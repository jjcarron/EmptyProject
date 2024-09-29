import os

import pytest

from utils import \
    create_short_name  # Assurez-vous d'importer correctement votre fonction


def test_create_short_name():
    original_name = "EarlyDetection_Processes_for_100K_Entries"
    expected_short_name = "EDP100KE"
    actual_short_name = create_short_name(original_name)

    assert actual_short_name == expected_short_name, f"Test failed: Expected {expected_short_name} but got {actual_short_name}"
