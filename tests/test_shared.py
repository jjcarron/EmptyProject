"""
Test module to verify the functionality of logs and project objects imported
from the `shared` module.

This module uses pytest to assert that the `log`, `dlog`, and `project` objects
are properly initialized, and it also checks the log file names being used.
"""

import os

from shared import dlog, log, project


def test_logs():
    """
    Tests if the `log` and `dlog` objects are properly initialized.

    Verifies that the imported `log` and `dlog` objects are not `None`,
    meaning they have been correctly created and imported.
    """
    assert log is not None
    assert dlog is not None


def test_log_file_names():
    """
    Tests the log file names for the 'user' and 'debug' handlers.

    Iterates over the handlers associated with the `log` object and verifies
    that the log files correspond to `user.log` and `debug.log`, based on
    the handler's name.
    """
    for handler in log.handlers:
        match handler.name:
            case 'user':
                assert os.path.basename(os.path.abspath(
                    handler.baseFilename)) == 'user.log'
            case 'debug':
                assert os.path.basename(os.path.abspath(
                    handler.baseFilename)) == 'debug.log'


def test_project():
    """
    Tests if the `project` object is properly initialized.

    Verifies that the imported `project` object is not `None`, meaning it
    has been correctly created and imported.
    """
    assert project is not None
