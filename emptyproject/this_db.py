
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
    - __init__: Initializes the ThisDB class with a database connection URI.
    - update_criterion_fk: Updates foreign keys for criteria in the
      CriterionValues table.
    - update_casino_fk: Updates foreign keys for casinos in the CriterionValues table.
    - update_all_fk: Updates all foreign keys in the CriterionValues table.
    - update_crossview_infos: Updates the CrossViewInfos table with resource strings in
      the specified language.
    - add_annual_computed_exclusions: Adds annual computed exclusions to the database.
    - replace_ref: Replaces old criterion references with new ones.
"""
# pylint: disable=broad-exception-caught
# pylint: disable=not-callable
# pylint: disable=duplicate-code

from db.core_db import CoreDB
from db.models import Casinos
from db.sqlalchemy_extensions import Nz
from shared import log
from sqlalchemy import String, and_, func, select, update
from sqlalchemy.orm import Session, aliased


class ThisDB(CoreDB):
    """
    ThisDB extends the CoreDB class, providing methods to perform specific
    database operations related to casino criteria and values.
    """


