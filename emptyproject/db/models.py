"""
This module was generated automatically.

It contains ORM classes for SQLAlchemy representing the database tables.
"""


# pylint: disable=too-few-public-methods
# pylint: disable=unused-import

from sqlalchemy import (Boolean, Column, DateTime, Float, Integer, Numeric,
                        String)
from sqlalchemy.orm import declarative_base

# from sqlalchemy.ext.declarative import declarative_base #old fashion

Base = declarative_base()


class Settings(Base):
    """
    Represents the 'Settings' table.

    Columns:
        id
                            (Integer):
                            Primary Key
        Name
                            (String):

        PValue
                            (String):

        PBoolean
                            (Boolean):

    """

    __tablename__ = 'Settings'
    id = Column(Integer, primary_key=True)
    Name = Column(String, )
    PValue = Column(String, )
    PBoolean = Column(Boolean, )


class Casinos(Base):
    """
    Represents the 'Casinos' table.

    Columns:
        id
                            (Integer):
                            Primary Key
        Name
                            (String):

        Online
                            (Boolean):

        DZS_ID
                            (Integer):

    """

    __tablename__ = 'Casinos'
    id = Column(Integer, primary_key=True)
    Name = Column(String, )
    Online = Column(Boolean, )
    DZS_ID = Column(Integer, )


class ResourceStrings(Base):
    """
    Represents the 'ResourceStrings' table.

    Columns:
        id
                            (Integer):
                            Primary Key
        Ref
                            (String):

        EN
                            (String):

        DE
                            (String):

        FR
                            (String):

        IT
                            (String):

    """

    __tablename__ = 'ResourceStrings'
    id = Column(Integer, primary_key=True)
    Ref = Column(String, )
    EN = Column(String, )
    DE = Column(String, )
    FR = Column(String, )
    IT = Column(String, )
