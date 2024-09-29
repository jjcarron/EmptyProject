"""
This script converts a JSON schema to SQLAlchemy table classes.

It uses the `generate_table_class_from_json` function from `lib.db_class_generator`
to generate the table classes from a provided JSON schema.

Usage:
    python script_name.py path_to_json_file path_to_classes_file

Arguments:
    json_file (str): Path to the JSON schema file.
    classes_file (str): Path to the output file where the table classes will be written.
"""

import argparse

from lib.db_class_generator import generate_table_class_from_json


def main():
    """
    Main function that parses command-line arguments and generates SQLAlchemy table classes
    from a provided JSON schema file.
    """
    parser = argparse.ArgumentParser(
        description='Convert JSON schema to SQLAlchemy table classes'
    )
    parser.add_argument('json_file', help='Path to the JSON schema file')
    parser.add_argument(
        'classes_file',
        help='Path to the output file for the table classes'
    )
    args = parser.parse_args()

    # Check if all arguments are present
    if args.json_file and args.classes_file:
        # Generate the table classes from the JSON schema
        generate_table_class_from_json(args.json_file, args.classes_file)
    else:
        parser.print_usage()
        print(
            "Please provide both the JSON schema file and the table classes output file paths."
        )


if __name__ == '__main__':
    main()
