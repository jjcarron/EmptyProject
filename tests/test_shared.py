import os

import pytest

from shared import dlog, log, project


def test_logs():
    assert log is not None
    assert dlog is not None


def test_log_file_names():

    for handler in log.handlers:
        match handler.name:
            case 'user':
                assert os.path.basename(os.path.abspath(
                    handler.baseFilename)) == 'user.log'
            case 'debug':
                assert os.path.basename(os.path.abspath(
                    handler.baseFilename)) == 'debug.log'


def test_project():
    assert project is not None
