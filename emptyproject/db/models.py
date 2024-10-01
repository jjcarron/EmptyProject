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
        key
                            (String):

        p_value
                            (String):

        p_bool
                            (Boolean):

    """

    __tablename__ = 'Settings'
    id = Column(Integer, primary_key=True)
    key = Column(String, )
    p_value = Column(String, )
    p_bool = Column(Boolean, )


class Casinos(Base):
    """
    Represents the 'Casinos' table.

    Columns:
        id
                            (Integer):
                            Primary Key
        name
                            (String):

        online
                            (Boolean):

        dzs_id
                            (Integer):

    """

    __tablename__ = 'Casinos'
    id = Column(Integer, primary_key=True)
    name = Column(String, )
    online = Column(Boolean, )
    dzs_id = Column(Integer, )


class ResourceStrings(Base):
    """
    Represents the 'ResourceStrings' table.

    Columns:
        id
                            (Integer):
                            Primary Key
        key
                            (String):

        en
                            (String):

        de
                            (String):

        fr
                            (String):

        it
                            (String):

    """

    __tablename__ = 'ResourceStrings'
    id = Column(Integer, primary_key=True)
    key = Column(String, )
    en = Column(String, )
    de = Column(String, )
    fr = Column(String, )
    it = Column(String, )
