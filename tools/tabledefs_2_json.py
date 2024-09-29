"""
This script converts table definitions from a file to a JSON schema.

It uses the `create_json_schema` function from `lib.db_class_generator` to generate
a JSON schema from the provided table definitions.

Usage:
    python script_name.py path_to_definition_file path_to_json_output_file

Arguments:
    definition_file (str): Path to the file containing the table definitions.
    json_file (str): Path to the output file where the JSON schema will be written.
"""

import argparse

from lib.db_class_generator import create_json_schema
from lib.easy_definition import Definitions


def main():
    """
    Main function that parses command-line arguments and generates a JSON schema
    from the provided table definitions file.
    """
    parser = argparse.ArgumentParser(
        description='Convert table definitions to JSON'
    )
    parser.add_argument('definition_file', help='Path to the definitions file')
    parser.add_argument('json_file', help='Path to the JSON output file')
    args = parser.parse_args()

    # Check if all arguments are present
    if args.definition_file and args.json_file:
        # Load the definitions and create the JSON schema
        defs = Definitions(args.definition_file)
        create_json_schema(defs.definitions, args.json_file)
    else:
        parser.print_usage()
        print("Please provide both the definition file and JSON output file paths.")


if __name__ == '__main__':
    main()
