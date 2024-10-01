
"""
This module defines the ThisDB class, which extends the CoreDB class to provide
specific database operations for the PlaySafeMetrics project.

The ThisDB class includes methods for updating foreign keys, managing resource
strings, and handling computed exclusions in the database. The class is designed
to work with SQLAlchemy ORM sessions to interact with the database.

Classes:
    - ThisDB: A class that extends CoreDB to perform specialized database operations
      related to casino period criterion values and cross-view information.

Methods:

"""

# pylint: disable=too-few-public-methods

from db.core_db import CoreDB


class ThisDB(CoreDB):
    """
    ThisDB extends the CoreDB class, providing methods to perform specific
    database operations related to casino criteria and values.
    """
