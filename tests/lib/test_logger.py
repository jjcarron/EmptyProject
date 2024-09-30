import logging
import os

import pytest
from logger import debug_logger, setup_logging, user_logger


def test_log_configuration():
    setup_logging()
    assert user_logger is not None
    assert debug_logger is not None

    # Get the 'user' handler from the logger
    logger = logging.getLogger('user')
    for handler in logger.handlers:
        match handler.name:
            case 'user':
                assert os.path.basename(os.path.abspath(
                    handler.baseFilename)) == 'user.log'
            case 'debug':
                assert os.path.basename(os.path.abspath(
                    handler.baseFilename)) == 'debug.log'
