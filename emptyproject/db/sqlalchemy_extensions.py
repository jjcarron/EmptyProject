""" This module provides definitions for functions depending on the atabase engine """

# sqlalchemy_extensions.py
# pylint: disable=too-few-public-methods
# pylint: disable=mixed-line-endings
# pylint: disable=unused-argument
# pylint: disable=consider-using-f-string

from sqlalchemy.ext.compiler import compiles
from sqlalchemy.sql.functions import FunctionElement, GenericFunction
from sqlalchemy.types import Float, String

# Définir la fonction SQL Substr pour SQLAlchemy


class Substr(FunctionElement):
    """
    This class provides the right database access functionality for Substring searches for
    different database engines
    """
    type = String()
    inherit_cache = True  # Set the inherit_cache attribute to True


@compiles(Substr, 'default')
def default_compile(element, compiler, **kw):
    """ used for unknown database """
    return "SubstrING(%s, %s, %s)" % (compiler.process(
        element.clauses.clauses[0]),
        compiler.process(
        element.clauses.clauses[1]),
        compiler.process(
            element.clauses.clauses[2]))


@compiles(Substr, 'sqlite')
def sqlite_compile(element, compiler, **kw):
    """ used for sqlite database """
    return "Substr(%s, %s, %s)" % (compiler.process(
        element.clauses.clauses[0]),
        compiler.process(
        element.clauses.clauses[1]),
        compiler.process(
            element.clauses.clauses[2]))


@compiles(Substr, 'mysql')
def mysql_compile(element, compiler, **kw):
    """ used for sqlite database """
    return "SubstrING(%s, %s, %s)" % (compiler.process(
        element.clauses.clauses[0]),
        compiler.process(
        element.clauses.clauses[1]),
        compiler.process(
            element.clauses.clauses[2]))


@compiles(Substr, 'postgresql')
def postgresql_compile(element, compiler, **kw):
    """ used for sqlite database """
    return "SubstrING(%s FROM %s FOR %s)" % (compiler.process(
        element.clauses.clauses[0]),
        compiler.process(
        element.clauses.clauses[1]),
        compiler.process(
            element.clauses.clauses[2]))


@compiles(Substr, 'mssql')
def mssql_compile(element, compiler, **kw):
    """ used for sqlite database """
    return "SubstrING(%s, %s, %s)" % (compiler.process(
        element.clauses.clauses[0]),
        compiler.process(
        element.clauses.clauses[1]),
        compiler.process(
            element.clauses.clauses[2]))


@compiles(Substr, 'access')
def access_compile(element, compiler, **kw):
    """ used for sqlite database """
    return "MID(%s, %s, %s)" % (compiler.process(element.clauses.clauses[0]),
                                compiler.process(element.clauses.clauses[1]),
                                compiler.process(element.clauses.clauses[2]))


class Nz(GenericFunction):
    """ This class provides a versatile version of Nz functionality """
    type = Float()
    inherit_cache = True


@compiles(Nz, 'sqlite')
@compiles(Nz, 'mysql')
@compiles(Nz, 'postgresql')
def compile_nz_default(element, compiler, **kw):
    """
    used for sqlite,
             mysql and
             posgrresql databases
    """
    return "coalesce(%s, 0)" % compiler.process(element.clauses)


@compiles(Nz, 'mssql')
def compile_nz_mssql(element, compiler, **kw):
    """ used for mssql database """
    return "isnull(%s, 0)" % compiler.process(element.clauses)


@compiles(Nz, 'access')
def compile_nz_access(element, compiler, **kw):
    """ used for access database """
    return "IIf(IsNull(%s), 0, %s)" % (compiler.process(element.clauses),
                                       compiler.process(element.clauses))
