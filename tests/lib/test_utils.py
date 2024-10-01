import pytest
from lib.utils import create_short_name, format_class_name, get_uri_str


def test_create_short_name():
    assert create_short_name("HelloWorld123") == "HW123"
    assert create_short_name("NoDigits") == "ND"
    assert create_short_name("123456") == "123456"
    assert create_short_name("lowercase") == ""
    assert create_short_name("") == ""


def test_format_class_name():
    assert format_class_name("tbl_user_account") == "UserAccount"
    assert format_class_name("user_account") == "UserAccount"
    assert format_class_name("tbl_user") == "User"
    assert format_class_name("user") == "User"
    assert format_class_name("tbl_") == ""
    assert format_class_name("") == ""


def test_get_uri_str():
    assert get_uri_str("sqlite") == "sqlite_uri"
    assert get_uri_str("access") == "access_uri"
    assert get_uri_str("mysql") is None
    assert get_uri_str("") is None
    assert get_uri_str(None) is None
