"""
This module initializes the project environment by setting up the project
configuration and loggers. The project configuration is loaded from a YAML
file, and loggers are set up for both user-level and debug-level logging.

Classes:
    ThisProject: Handles project-specific configuration and paths.

Functions:
    setup_project(): Initializes the project by setting up the configuration
                     and loggers.
"""

import os

from logger import debug_logger, user_logger
from this_project import ThisProject


def setup_project():
    """
    Initializes the project environment by setting up the configuration and loggers.

    The function retrieves the directory of the currently executed script,
    defines the path to the project configuration file relative to the script
    directory, and initializes the project using the ThisProject class.
    It also sets up user-level and debug-level loggers for the project.

    Returns:
        tuple: A tuple containing the initialized project object, user logger,
               and debug logger.
    """
    # Obtain the directory path of the currently executed script
    script_dir = os.path.dirname(os.path.abspath(__file__))

    # Define the path to the project configuration file relative to the script
    # directory.
    config_path = os.path.join(script_dir, 'config/project_config.yaml')

    # Initialize the project with the script directory and configuration file
    # path.
    proj = ThisProject(script_dir, config_path)

    # Set up loggers for the project.
    user_log = user_logger
    debug_log = debug_logger

    return proj, user_log, debug_log


# Initialize the project environment
project, log, dlog = setup_project()
