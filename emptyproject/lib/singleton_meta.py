"""
This module provides a metaclass for creating singleton classes.

Classes:
    - SingletonMeta: A metaclass that ensures a class has only one instance.
"""


class SingletonMeta(type):
    """
    A metaclass that ensures a class has only one instance (Singleton pattern).

    This metaclass overrides the __call__ method to check if an instance of the
    class already exists. If it does, the existing instance is returned. If not,
    a new instance is created, stored, and then returned.

    Attributes:
        _instances (dict): A dictionary to store instances of the classes that
                           use this metaclass.
    """
    _instances = {}

    def __call__(cls, *args, **kwargs):
        """
        Overrides the __call__ method to control instance creation.

        If an instance of the class already exists in _instances, it returns that
        instance. Otherwise, it creates a new instance, stores it in _instances,
        and returns it.

        Args:
            *args: Variable length argument list.
            **kwargs: Arbitrary keyword arguments.

        Returns:
            object: The single instance of the class.
        """
        if cls not in cls._instances:
            instance = super().__call__(*args, **kwargs)
            cls._instances[cls] = instance
        return cls._instances[cls]
