import pytest
from db.base import ExtendedBase

class TestExtendedBase:
    def test_initialization(self):
        instance = ExtendedBase()
        assert instance.id is None
        assert instance.__name__ == ""

    def test_set_name(self):
        instance = ExtendedBase()
        instance.set_name("TestName")
        assert instance.__name__ == "TestName"

    def test_display(self, capsys):
        instance = ExtendedBase()
        instance.id = 1
        instance.set_name("TestName")
        instance.display()
        captured = capsys.readouterr()
        assert "ExtendedBase:" in captured.out
        assert "  id: 1" in captured.out
        assert "  __name__: TestName" in captured.out

    def test_repr(self):
        instance = ExtendedBase()
        instance.id = 1
        assert repr(instance) == "ExtendedBase(1)"

    def test_str(self):
        instance = ExtendedBase()
        instance.id = 1
        assert str(instance) == "ExtendedBase(1)"
        class TestExtendedBase:
            def test_initialization(self):
                instance = ExtendedBase()
                assert instance.id is None
                assert instance.__name__ == ""

            def test_set_name(self):
                instance = ExtendedBase()
                instance.set_name("TestName")
                assert instance.__name__ == "TestName"

            def test_display(self, capsys):
                instance = ExtendedBase()
                instance.id = 1
                instance.set_name("TestName")
                instance.display()
                captured = capsys.readouterr()
                assert "ExtendedBase:" in captured.out
                assert "  id: 1" in captured.out
                assert "  __name__: TestName" in captured.out

            def test_repr(self):
                instance = ExtendedBase()
                instance.id = 1
                assert repr(instance) == "ExtendedBase(1)"

            def test_str(self):
                instance = ExtendedBase()
                instance.id = 1
                assert str(instance) == "ExtendedBase(1)"
