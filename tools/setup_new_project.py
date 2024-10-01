"""
Project creation script based on the EmptyProject template.

This script allows you to create a new project based on the `EmptyProject` template
and perform the following actions:
    1. Prompt for the new project's name and the directory path.
    2. Copy the `EmptyProject` structure into the new directory.
    3. Delete the `.git` directory in the new project.
    4. Replace 'emptyproject' with the new project name in certain configuration files.
    5. Modify a specific value in an Excel file.
    6. Rename the `emptyproject` directory to the lowercase version of the new project name.
    7. Initialize a new Git repository.
    8. Run `pytest` to validate the tests.
    9. Run `pylint` to check code style compliance.
"""
import os
import shutil
import subprocess
import sys

import openpyxl


def get_new_project_name():
    """
    Prompts the user for the new project name and ensures that the input is not empty.

    Returns:
        str: The name of the new project.
    """
    while True:
        new_project_name = input("Enter the new project name: ").strip()
        if new_project_name:
            return new_project_name
        print("Project name cannot be empty. Please try again.")


def get_project_path():
    """
    Prompts the user for the project directory path where the new project will be created.
    If no path is provided, the default is two levels above the script's directory.
    The path is checked for existence.

    Returns:
        str: The valid directory path where the project will be created.
    """
    default_path = os.path.abspath(os.path.join(
        os.path.dirname(__file__), "..", ".."))
    while True:
        project_path = input(
            f"Enter the project path (default: {default_path}): ").strip()
        if not project_path:
            project_path = default_path
        if os.path.exists(project_path) and os.path.isdir(project_path):
            return project_path
        print(
            f"The directory '{project_path}' does not exist. Please try again.")


def replace_in_file(file_path, search_text, replace_text):
    """
    Replaces all occurrences of a search string with a replacement string in a file.

    Args:
        file_path (str): The path to the file where text replacement will occur.
        search_text (str): The text to be replaced.
        replace_text (str): The text that will replace the search text.
    """
    with open(file_path, 'r', encoding='utf-8') as file:
        content = file.read()
    content = content.replace(search_text, replace_text)
    with open(file_path, 'w', encoding='utf-8') as file:
        file.write(content)


def update_excel_file(file_path, sheet_name, search_value, new_value):
    """
    Updates a specific cell in an Excel file, replacing the value in a column if it matches
    a search value.

    Args:
        file_path (str): The path to the Excel file.
        sheet_name (str): The name of the sheet where the update will be made.
        search_value (str): The value to search for in the first column.
        new_value (str): The new value to set in the target column (en).
    """
    wb = openpyxl.load_workbook(file_path)
    sheet = wb[sheet_name]
    for row in sheet.iter_rows():
        if row[0].value == search_value:
            row[1].value = new_value  # Assuming en is the second column
            break
    wb.save(file_path)


def copy_project_template(src, dst):
    """
    Copies the entire EmptyProject directory template to the new project location.

    Args:
        src (str): The source directory (EmptyProject template).
        dst (str): The destination directory (new project location).
    """
    try:
        shutil.copytree(src, dst)
        print(f"New project created at: {dst}")
    except (shutil.Error, OSError) as e:
        print(f"Failed to copy project template: {e}")
        sys.exit(1)


def run_command(command, cwd=None):
    """
    Runs a shell command and checks for success.

    Args:
        command (str): The shell command to be executed.
        cwd (str, optional): The directory where the command should be executed. Defaults to None.
    """
    try:
        subprocess.run(command, cwd=cwd, check=True, shell=True)
    except subprocess.CalledProcessError as e:
        print(f"Command '{command}' failed: {e}")
        sys.exit(1)


def main():
    """
    Main function that orchestrates the project creation process by performing all the
    required steps:
    1. Prompts the user for project name and path.
    2. Copies the EmptyProject structure to the new project.
    3. Updates various configuration files and renames directories.
    4. Initializes a Git repository and runs pytest and pylint for verification.
    """
    empty_project_path = os.path.abspath(
        os.path.join(os.path.dirname(__file__), ".."))

    if not os.path.exists(empty_project_path):
        print(
            f"EmptyProject template directory not found at {empty_project_path}")
        sys.exit(1)

    new_project_name = get_new_project_name()
    new_project = new_project_name.lower()
    project_path = get_project_path()

    new_project_path = os.path.join(project_path, new_project_name)

    if os.path.exists(new_project_path):
        print(f"Error: Directory {new_project_path} already exists.")
        sys.exit(1)

    print(
        f"Creating new project '{new_project_name}' at {new_project_path}...")
    copy_project_template(empty_project_path, new_project_path)

    # a) Remove the .git directory if it exists
    git_dir = os.path.join(new_project_path, ".git")
    if os.path.exists(git_dir):
        try:
            shutil.rmtree(git_dir)
        except PermissionError:
            # Change the permissions of the directory and try again
            for root, dirs, files in os.walk(git_dir):
                for directory in dirs:
                    os.chmod(os.path.join(root, directory), 0o777)
                for file in files:
                    os.chmod(os.path.join(root, file), 0o777)
            shutil.rmtree(git_dir)

    # b) Replace 'emptyproject' with newproject in .pylintrc
    replace_in_file(
        os.path.join(
            new_project_path,
            ".pylintrc"),
        "emptyproject",
        new_project)

    # c) Replace 'emptyproject' with newproject in pytest.ini
    replace_in_file(
        os.path.join(
            new_project_path,
            "pytest.ini"),
        "emptyproject",
        new_project)

    # d) Replace 'EmptyProject' with the newProjectName in
    # config/project_config.yaml
    replace_in_file(os.path.join(
        new_project_path, "emptyproject", "config", "project_config.yaml"),
        "EmptyProject", new_project_name)

    # e) Modify the Excel file for APP_NAME in the ResourceStrings sheet
    basic_data_path = os.path.join(
        new_project_path,
        "data",
        "init_data",
        "Basic_Data.xlsx")
    update_excel_file(
        basic_data_path,
        "ResourceStrings",
        "APP_NAME",
        new_project_name)

    # f) Rename the directory emptyproject to newproject (lowercase)
    old_project_dir = os.path.join(new_project_path, "emptyproject")
    new_project_dir = os.path.join(new_project_path, new_project)
    os.rename(old_project_dir, new_project_dir)

    # g) Initialize a new Git repository
    print("Initializing new git repository...")
    run_command("git init", cwd=new_project_path)
    run_command("git add .", cwd=new_project_path)
    run_command('git commit -m "Initial commit"', cwd=new_project_path)

    # h) Run pytest
    print("Running pytest...")
    run_command("pytest", cwd=new_project_path)

    # i) Run pylint
    print("Running pylint...")
    run_command(f"pylint {new_project}", cwd=new_project_path)
    run_command("pylint tools", cwd=new_project_path)
    run_command("pylint tests", cwd=new_project_path)


if __name__ == "__main__":
    main()
