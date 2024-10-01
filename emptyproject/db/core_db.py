"""
This module defines the CoreDB class, which extends the Database class
to provide specific database operations for the PlaySafeMetrics project.

The CoreDB class provides methods for retrieving and manipulating data
from the project's database, including casinos, criteria, settings,
crossview information, and resource strings.

Classes:
    - CoreDB: A class that extends the Database class to include methods
      specific to the PlaySafeMetrics project.
"""

# pylint: disable=broad-exception-caught
# pylint: disable=duplicate-code

from db.db import Database
from db.models import Casinos, ResourceStrings, Settings
from shared import log
from sqlalchemy.orm import Session


class CoreDB(Database):
    """
    A class that extends the Database class to include methods specific
    to the PlaySafeMetrics project. Provides methods for retrieving
    and manipulating data related to casinos, criteria, settings,
    crossview information, and resource strings.
    """

    def get_casinos(self):
        """
        Retrieves all casinos from the database.

        Returns:
            list: A list of all casinos.
        """

        db: Session = self.get_session()
        try:
            casinos = db.query(Casinos).all()
            return casinos
        except Exception as e:
            db.rollback()
            log.error("An error occurred while fetching casinos: %s", e)
            return []
        finally:
            db.close()

    def get_casino_name_from_dzs_id(self, dzs_id):
        """
        Retrieves the name of a casino based on its DZS ID.

        Args:
            dzs_id (int): The DZS ID of the casino.

        Returns:
            str: The name of the casino, or None if not found.
        """
        db: Session = self.get_session()
        try:
            casino = db.query(Casinos).filter(
                Casinos.DZS_ID == dzs_id).first()
            return casino.Name if casino else None
        except Exception as e:
            db.rollback()
            log.error(
                "An error occurred while fetching the casino name: %s", e)
            return []
        finally:
            db.close()

    def get_casino_count(self):
        """
        Retrieves the total number of casinos in the database.

        Returns:
            int: The total number of casinos.
        """
        db: Session = self.get_session()
        try:
            casino_count = db.query(Casinos).count()
            return casino_count
        except Exception as e:
            db.rollback()
            log.error(
                "An error occurred while fetching the casino count: %s", e
            )
            return []
        finally:
            db.close()

    def get_online_casino_count(self):
        """
        Retrieves the number of online casinos in the database.

        Returns:
            int: The number of online casinos.
        """
        db: Session = self.get_session()
        try:
            online_casino_count = db.query(
                Casinos).filter(Casinos.Online).count()
            return online_casino_count
        except Exception as e:
            db.rollback()
            log.error(
                "An error occurred while fetching the online casino count: %s", e)
            return []
        finally:
            db.close()

    def get_settings(self):
        """
        Retrieves all settings from the database.

        Returns:
            list: A list of all settings.
        """
        db: Session = self.get_session()
        try:
            settings = db.query(Settings).all()
            return settings
        except Exception as e:
            db.rollback()
            log.error("An error occurred while fetching settings: %s", e)
            return []
        finally:
            db.close()

    def get_resource_strings(self):
        """
        Retrieves all resource strings from the database.

        Returns:
            list: A list of all resource strings.
        """
        db: Session = self.get_session()
        try:
            resource_strings = db.query(ResourceStrings).all()
            return resource_strings
        except Exception as e:
            db.rollback()
            log.error(
                "An error occurred while fetching resource strings: %s", e
            )
            return []
        finally:
            db.close()

    def get_resource_string(self, ref, language):
        """
        Retrieves a resource string based on its reference and language.

        Args:
            ref (str): The reference identifier for the resource string.
            language (str): The language code ('EN', 'FR', 'IT', 'DE').

        Returns:
            str: The resource string in the specified language, or the English version if not found.
        """
        db: Session = self.get_session()
        try:
            row = db.query(ResourceStrings).filter(
                ResourceStrings.Ref == ref).first()

            if row is None:
                log.warning(
                    "Resource string not found for ref: %s. None returned", ref)
                return None

            match language:
                case 'EN':
                    resource_string = row.EN
                case 'FR':
                    resource_string = row.FR
                case 'IT':
                    resource_string = row.IT
                case 'DE':
                    resource_string = row.DE
                case _:
                    resource_string = row.EN  # Default to English

            if not resource_string or str.strip(resource_string) == '':
                if row.EN:
                    resource_string = row.EN
                else:
                    log.warning(
                        "Resource string not found for ref: %s language: %s"
                        "or EN. None returned",
                        ref, language
                    )
                    return None

            return resource_string
        except Exception as e:
            db.rollback()
            log.error(
                "An error occurred while fetching the resource string: %s", e)
            return []
        finally:
            db.close()
