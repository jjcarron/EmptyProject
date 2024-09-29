"""
This script removes trailing whitespaces from files. It can process a specific file,
all files matching a given mask (e.g., `*.py`) in the current directory, or
recursively in subdirectories.

Usage:
    python remove_trailing_whitespaces.py myfile.py
    python remove_trailing_whitespaces.py "*.py"
    python remove_trailing_whitespaces.py "*.py" -r

Arguments:
    file_mask (str): File name or mask to process (e.g., `*.py`).
    -r, --recursive: Process files in subdirectories.

Functions:
    remove_trailing_whitespaces(file_path): Removes trailing whitespaces from a specific file.
    process_directory(directory, file_mask, sub_directory): Processes files in a directory and
    optionally in subdirectories.
    main(): The main function that parses command-line arguments and calls the processing functions.
"""

import argparse
import os


def remove_trailing_whitespaces(file_path):
    """
    Remove trailing whitespaces from a file.

    Args:
        file_path (str): Path to the file.
    """
    with open(file_path, 'r', encoding='utf-8') as file:
        lines = file.readlines()

    with open(file_path, 'w', encoding='utf-8') as file:
        for line in lines:
            file.write(line.rstrip() + '\n')


def process_directory(directory, file_masks, sub_directory):
    """
    Process all files matching the file masks in the given directory.

    Args:
        directory (str): The base directory to search in.
        file_masks (list of str): The file masks to match files (e.g., *.py).
        sub_directory (bool): Whether to include subdirectories in the search.
    """
    for root, _, files in os.walk(directory):
        for file_name in files:
            if any(file_name.endswith(mask) for mask in file_masks):
                file_path = os.path.join(root, file_name)
                print(f"Processing file: {file_path}")
                remove_trailing_whitespaces(file_path)
        if not sub_directory:
            break


def main():
    """
    Main function to parse arguments and process files.
    """
    parser = argparse.ArgumentParser(
        description="Remove trailing whitespaces from files."
    )
    parser.add_argument(
        "file_mask",
        type=str,
        nargs='+',  # Accept multiple arguments
        help="File name or mask to process (e.g., *.py)."
    )
    parser.add_argument(
        "-r",
        "--recursive",
        action="store_true",
        help="Process files in subdirectories."
    )

    args = parser.parse_args()

    base_directory = os.getcwd()
    process_directory(base_directory, args.file_mask, args.recursive)


if __name__ == "__main__":
    main()
