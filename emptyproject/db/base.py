"""
This module extends the SQLAlchemy declarative base class with additional
functionality to enhance the usability and introspection of ORM models.

The `ExtendedBase` class provides:
    - A method to display all non-internal attributes of an instance (`display`).
    - Custom `__repr__` and `__str__` methods for better string representations.
    - A method to set the instance name dynamically (`set_name`).

The module also defines a custom SQLAlchemy declarative base (`Base`) that
automatically incorporates these extensions into any ORM models derived from it.

Classes:
    - ExtendedBase: A base class that extends SQLAlchemy ORM models with additional
      methods for displaying attributes and customizing string representations.
    - Base: A custom declarative base class that uses `ExtendedBase` as its base class,
      allowing all models to inherit the additional functionality.
"""

from sqlalchemy.orm import declarative_base


class ExtendedBase:
    """
    Base class extended with additional functionality for SQLAlchemy models.

    This class provides methods to display model attributes, set the instance
    name, and customize string representations.
    """

    def __init__(self):
        """
        Initializes the ExtendedBase with default id and name attributes.
        """
        self.id = None
        self.__name__ = ""  # Initialize as an empty string

    def display(self):
        """
        Displays the attributes of the instance, excluding SQLAlchemy internal
        attributes.
        """
        # Check if the __tablename__ attribute exists
        tablename = getattr(self.__class__, '__tablename__', None)
        if tablename:
            print(f"{tablename}:")
        else:
            print(f"{self.__class__.__name__}:")

        for attr, value in self.__dict__.items():
            if not attr.startswith(
                    '_sa_'):  # Exclude SQLAlchemy internal attributes
                print(f"  {attr}: {value}")

    def __repr__(self):
        """
        Provides a string representation of the instance for debugging.
        """
        tablename = getattr(self.__class__, '__tablename__', None)
        if tablename:
            return f"{tablename}({self.id})"

        return f"{self.__class__.__name__}({self.id})"

    def __str__(self):
        """
        Provides a user-friendly string representation of the instance.
        """
        tablename = getattr(self.__class__, '__tablename__', None)
        if tablename:
            return f"{tablename}({self.id})"

        return f"{self.__class__.__name__}({self.id})"

    def set_name(self, name):
        """
        Sets the name of the instance.

        Args:
            name (str): The name to be set for the instance.
        """
        self.__name__ = name


# Create a declarative base class using ExtendedBase as the base class
Base = declarative_base(cls=ExtendedBase)
