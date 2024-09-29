"""
This module sets up logging configurations for the application using a YAML file.

The logging configuration can be customized by providing a path to a specific
YAML file. If no path is provided, it defaults to a `logging_config.yaml` file
located in the `config` directory of the project.

Functions:
    - setup_logging(logging_config_path): Configures logging for the application
      based on a YAML configuration file.
"""

import logging
import logging.config
import os

import yaml


def setup_logging(logging_config_path=''):
    """
    Sets up logging configuration for the application.

    This function reads a YAML configuration file to set up logging. If no path
    is provided, it defaults to a `logging_config.yaml` file located in the `config`
    directory at the root of the project. The function also resolves absolute paths
    for log file handlers.

    Args:
        logging_config_path (str): The path to the logging configuration YAML file.
                                   Defaults to an empty string, which triggers the use
                                   of the default path.
    """
    if logging_config_path == '':
        # Assuming the script is in the 'lib' directory
        project_dir = os.path.dirname(
            os.path.dirname(
                os.path.abspath(__file__)))
        logging_config_path = os.path.join(
            project_dir, 'config', 'logging_config.yaml')

    if os.path.exists(logging_config_path):
        with open(logging_config_path, 'r', encoding='utf-8') as f:
            config = yaml.safe_load(f)

        # Resolve absolute paths for file handlers
        for handler, handler_config in config['handlers'].items():
            # just to avoid pylint error
            _ = handler
            if 'filename' in handler_config:
                handler_config['filename'] = os.path.abspath(
                    os.path.join(
                        os.path.dirname(
                            os.path.dirname(
                                os.path.dirname(logging_config_path))),
                        handler_config['filename']))

        logging.config.dictConfig(config)
    else:
        print(f"{os.path.abspath(logging_config_path)} doesn't exist")


# Initialize logging configuration
setup_logging()

# Get the loggers
user_logger = logging.getLogger('user_logger')
debug_logger = logging.getLogger('debug_logger')
