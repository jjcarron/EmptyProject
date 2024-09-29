"""
This module provides functions to generate SQLAlchemy table classes from JSON schema
or custom definitions. It also includes utility functions for handling database field names
and types.

Functions:
    - fixed_var_name(name): Fixes variable names to be SQLAlchemy compatible.
    - get_db_type(db_type): Returns the SQLAlchemy type corresponding to the given database type.
    - singularize(table_name): Converts a plural table name to its singular form.
    - get_max_depth(data): Calculates the maximum depth of a nested dictionary or list.
    - custom_format(data, indent=4): Customizes the formatting of JSON data.
    - create_json_schema(definitions, filename): Creates a JSON schema from custom definitions.
    - generate_table_class_from_easy_definitions(definitions, filename): Generates SQLAlchemy table
      classes from custom definitions.
    - generate_table_class_from_json(json_filename, table_classes_filename):
      Generates SQLAlchemy table classes from a JSON schema file.
"""

import json
import re

from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()


def fixed_var_name(name):
    """
    Fixes a variable name to be SQLAlchemy compatible by replacing special characters.

    Args:
        name (str): The variable name to fix.

    Returns:
        str: The fixed variable name.
    """
    s = name.replace(
        ".",
        "_").replace(
        "!",
        "_").replace(
            "@",
            "_").replace(
                "$",
        "_")
    s = s.replace("&", "_").replace("#", "_").replace("[", "").replace("]", "")
    if not s[0].isalpha():
        s = "varPrefix" + s
    return s


def get_db_type(db_type):
    """
    Maps a database type to the corresponding SQLAlchemy type.

    Args:
        db_type (str): The database type to map.

    Returns:
        str: The corresponding SQLAlchemy type as a string.
    """
    db_type = db_type.strip().upper()

    type_mapping = {
        "INTEGER": "Integer",
        "LONG": "Integer",
        "TEXT": "String",
        "MEMO": "String",
        "VARCHAR": "String",
        "BYTE": "Integer",
        "DOUBLE": "Float",
        "DATE": "DateTime",
        "BIT": "Boolean",
        "CURRENCY": "Numeric"
    }

    for key, value in type_mapping.items():
        if db_type.startswith(key):
            return value

    return f"{db_type} is not supported yet"


def singularize(table_name):
    """
    Converts a plural table name to its singular form using common pluralization rules.

    Args:
        table_name (str): The plural table name.

    Returns:
        str: The singular table name.
    """
    irregulars = {
        "XXXs": "XXX"  # Used by template class
        # Add more irregulars as needed
    }

    # Check for irregulars
    if table_name in irregulars:
        result = irregulars[table_name]
    elif table_name.endswith(("ches", "shes", "ses", "xes", "zes")):
        result = table_name[:-2]
    elif table_name.endswith("ies"):
        result = table_name[:-3] + "y"
    elif table_name.endswith("Criteria"):
        result = table_name[:-8] + "Criterion"
    elif table_name.endswith("ia"):
        result = table_name[:-2] + "ium"
    else:
        result = table_name[:-1]

    return result


def get_max_depth(data, level=0):
    """
    Calculates the maximum depth of a nested dictionary or list.

    Args:
        data (dict or list): The nested dictionary or list to analyze.
        level (int): The current level of depth (used for recursion).

    Returns:
        int: The maximum depth of the nested structure.
    """
    if isinstance(data, dict):
        return max(get_max_depth(v, level + 1) for v in data.values())
    if isinstance(data, list):
        return max(get_max_depth(v, level + 1) for v in data)

    return level


def custom_format(data, indent=4):
    """
    Formats JSON data with custom indentation and line breaks.

    Args:
        data (dict): The JSON data to format.
        indent (int): The number of spaces to use for indentation.

    Returns:
        str: The formatted JSON data as a string.
    """
    max_depth = get_max_depth(data)

    def helper(data, indent, level):
        if isinstance(data, dict):
            if level != max_depth - 1:
                return '{\n' + ',\n'.join(
                    f'{" " * (indent * (level + 1))}{json.dumps(k)}: '
                    f'{helper(v, indent, level + 1)}' for k, v in data.items()
                ) + '\n' + ' ' * (indent * level) + '}'

            return '{' + ', '.join(
                f'{json.dumps(k)}: {helper(v, indent, level + 1)}'
                for k, v in data.items()
            ) + '}'
        if isinstance(data, list):
            return '[\n' + ',\n'.join(
                f'{" " * (indent * (level + 1))}{helper(v, indent, level + 1)}'
                for v in data
            ) + '\n' + ' ' * (indent * level) + ']'

        return json.dumps(data)

    return helper(data, indent, 0)


def create_json_schema(definitions, filename):
    """
    Creates a JSON schema from custom definitions and writes it to a file.

    Args:
        definitions (list): A list of custom definitions to convert into a JSON schema.
        filename (str): The path to the file where the JSON schema will be written.
    """
    schema = {"tables": {}}

    for definition in definitions:
        table_name, fields = definition

        fields = fields.split(',')
        fields = [re.split(r'\s+', field.strip()) for field in fields]

        schema["tables"][table_name] = {}

        for field in fields:
            if field[0] == 'CONSTRAINT':
                continue
            field_name = fixed_var_name(field[0])
            field_type = field[1].lower()
            field_attributes = {"type": get_db_type(field_type)}
            if len(field) > 2 and field[2] == 'IDENTITY':
                field_attributes["primary_key"] = True

            schema["tables"][table_name][field_name] = field_attributes

    with open(filename, 'w', encoding='utf-8') as file:
        file.write(custom_format(schema))


def check_primary_key(args):
    """
    Checks if 'primary_key' is present in the arguments and returns the corresponding string.

    Args:
        args (str or list): The arguments to search for 'primary_key'.

    Returns:
        str: Returns 'primary_key=True' if found, otherwise an empty string.
    """
    if isinstance(args, str) and "primary_key" in args:
        return "Primary Key"
    if isinstance(args, list) and any("primary key" in arg for arg in args):
        return "Primary Key"
    return ""


def format_class_name(table_name):
    """
    Removes the 'tbl_' prefix from the table name (if it exists) and converts the name to CamelCase.

    Args:
        table_name (str): The table name to format.

    Returns:
        str: The formatted class name in CamelCase.
    """
    # Remove 'tbl_' prefix if it exists
    if table_name.startswith('tbl_'):
        table_name = table_name[4:]

    # Split the name by underscores and capitalize each part
    parts = table_name.split('_')
    if len(parts) > 1:
        class_name = ''.join(word.capitalize() for word in parts)
    else:
        class_name = parts[0]
    return class_name


def generate_table_class_from_json(json_filename, table_classes_filename):
    """
    Generates SQLAlchemy table classes from a JSON schema file and writes them to a file.

    Args:
        json_filename (str): The path to the JSON schema file.
        table_classes_filename (str): The path to the file where the table classes will be written.
    """
    with open(json_filename, 'r', encoding='utf-8') as f:
        json_data = json.load(f)

    module_docstring = """\"\"\"
This module was generated automatically.

It contains ORM classes for SQLAlchemy representing the database tables.
\"\"\"\n\n"""

    python_code = module_docstring + """
# pylint: disable=too-few-public-methods
# pylint: disable=unused-import

from sqlalchemy import Column, Integer, String, DateTime, Boolean, Float, Numeric
from sqlalchemy.orm import declarative_base
#from sqlalchemy.ext.declarative import declarative_base #old fashion

Base = declarative_base()


"""

    for table_name, table_info in json_data['tables'].items():
        table_name = format_class_name(table_name)
        python_code += f"class {table_name}(Base):\n"
        python_code += f"""    \"\"\"
    Represents the '{table_name}' table.
    \n"""
        python_code += "    Columns:\n"
        for column_name, column_info in table_info.items():
            column_type = column_info['type']
            column_args = ', '.join(
                f"{k}={v}" for k, v in column_info.items() if k != 'type'
            )
            python_code += f"""        {column_name}
                            ({column_type}):
                            {check_primary_key(column_args)}\n"""

        python_code += "    \"\"\"\n\n"
        python_code += f"    __tablename__ = '{table_name}'\n"

        for column_name, column_info in table_info.items():
            column_type = column_info['type']
            column_args = ', '.join(
                f"{k}={v}" for k, v in column_info.items() if k != 'type'
            )
            python_code += f"    {column_name} = Column({column_type}, {column_args})\n"

        python_code += "\n"

    with open(table_classes_filename, 'w', encoding='utf-8') as f:
        f.write(python_code)
