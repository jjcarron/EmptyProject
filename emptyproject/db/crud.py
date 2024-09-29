"""
This module provides a generic CRUD repository class for performing basic
create, read, update, and delete operations on SQLAlchemy models.

The CRUDRepository class is designed to be reusable across different
SQLAlchemy models by leveraging Python's generics. It includes methods for
handling common operations and specific updates for foreign key references
in the PlaySafeMetrics project.

Classes:
    - CRUDRepository: A generic class for CRUD operations on SQLAlchemy models.
"""

from typing import Any, Dict, Generic, List, Optional, Type, TypeVar

from db.base import Base
from sqlalchemy.orm import Session

T = TypeVar('T', bound=Base)


class CRUDRepository(Generic[T]):
    """
    A generic CRUD repository class that provides basic create, read, update,
    and delete operations for SQLAlchemy models.

    Attributes:
        model (Type[T]): The SQLAlchemy model class associated with the repository.
    """

    def __init__(self, model: Type[T]):
        """
        Initializes the CRUDRepository with the given SQLAlchemy model.

        Args:
            model (Type[T]): The SQLAlchemy model class.
        """
        self.model = model

    @classmethod
    def create(cls, db: Session, obj_in: T) -> T:
        """
        Creates a new record in the database.

        Args:
            db (Session): The SQLAlchemy session.
            obj_in (T): The object to be created.

        Returns:
            T: The created object.
        """
        db.add(obj_in)
        db.flush()
        db.refresh(obj_in)
        return obj_in

    @classmethod
    def get(cls, db: Session, model: Type[T], record_id: int) -> Optional[T]:
        """
        Retrieves a record from the database by its ID.

        Args:
            db (Session): The SQLAlchemy session.
            model (Type[T]): The model class.
            record_id (int): The ID of the record to retrieve.

        Returns:
            Optional[T]: The retrieved object, or None if not found.
        """
        return db.query(model).filter(model.id == record_id).first()

    @classmethod
    def get_all(cls, db: Session, model: Type[T]) -> List[T]:
        """
        Retrieves all records from the database for the given model.

        Args:
            db (Session): The SQLAlchemy session.
            model (Type[T]): The model class.

        Returns:
            List[T]: A list of all records for the model.
        """
        return db.query(model).all()

    @classmethod
    def update(cls,
               db: Session,
               model: Type[T],
               record_id: int,
               obj_in: Dict[str,
                            Any]) -> Optional[T]:
        """
        Updates a record in the database by its ID.

        Args:
            db (Session): The SQLAlchemy session.
            model (Type[T]): The model class.
            record_id (int): The ID of the record to update.
            obj_in (Dict[str, Any]): A dictionary of fields to update.

        Returns:
            Optional[T]: The updated object, or None if not found.
        """
        db_obj = db.query(model).filter(model.id == record_id).first()
        if not db_obj:
            return None
        for key, value in obj_in.items():
            if key != "id" and value is not None:
                setattr(db_obj, key, value)
        db.flush()
        db.refresh(db_obj)
        return db_obj

    @classmethod
    def delete(
            cls,
            db: Session,
            model: Type[T],
            record_id: int) -> Optional[T]:
        """
        Deletes a record from the database by its ID.

        Args:
            db (Session): The SQLAlchemy session.
            model (Type[T]): The model class.
            record_id (int): The ID of the record to delete.

        Returns:
            Optional[T]: The deleted object, or None if not found.
        """
        db_obj = db.query(model).filter(model.id == record_id).first()
        if not db_obj:
            return None
        db.delete(db_obj)
        db.flush()
        return db_obj
