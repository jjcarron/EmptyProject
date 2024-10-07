import pytest
from lib.singleton_meta import SingletonMeta


class SingletonClass(metaclass=SingletonMeta):
    pass


def test_singleton_instance_creation():
    instance1 = SingletonClass()
    instance2 = SingletonClass()
    assert instance1 is instance2, "SingletonMeta did not return the same instance"


def test_singleton_instance_attributes():
    instance1 = SingletonClass()
    instance1.some_attribute = "test"
    instance2 = SingletonClass()
    assert instance2.some_attribute == "test", "SingletonMeta instances do not share attributes"


def test_singleton_instance_reset():
    SingletonMeta._instances = {}  # Reset the instances for testing
    instance1 = SingletonClass()
    SingletonMeta._instances = {}  # Reset the instances again
    instance2 = SingletonClass()
    assert instance1 is not instance2, "SingletonMeta did not reset instances correctly"
