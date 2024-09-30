import os
import shutil
import sys
import subprocess
import openpyxl

def get_new_project_name():
    while True:
        new_project_name = input("Enter the new project name: ").strip()
        if new_project_name:
            return new_project_name
        print("Project name cannot be empty. Please try again.")

def get_project_path():
    default_path = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
    while True:
        project_path = input(f"Enter the project path (default: {default_path}): ").strip()
        if not project_path:
            project_path = default_path
        if os.path.exists(project_path) and os.path.isdir(project_path):
            return project_path
        print(f"The directory '{project_path}' does not exist. Please try again.")

def replace_in_file(file_path, search_text, replace_text):
    with open(file_path, 'r') as file:
        content = file.read()
    content = content.replace(search_text, replace_text)
    with open(file_path, 'w') as file:
        file.write(content)

def update_excel_file(file_path, sheet_name, search_value, new_value):
    wb = openpyxl.load_workbook(file_path)
    sheet = wb[sheet_name]
    for row in sheet.iter_rows():
        if row[0].value == search_value:
            row[1].value = new_value  # Assuming EN is the second column
            break
    wb.save(file_path)

def copy_project_template(src, dst):
    try:
        shutil.copytree(src, dst)
        print(f"New project created at: {dst}")
    except Exception as e:
        print(f"Failed to copy project template: {e}")
        sys.exit(1)

def run_command(command, cwd=None):
    try:
        subprocess.run(command, cwd=cwd, check=True, shell=True)
    except subprocess.CalledProcessError as e:
        print(f"Command '{command}' failed: {e}")
        sys.exit(1)

def main():
    empty_project_path = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))

    if not os.path.exists(empty_project_path):
        print(f"EmptyProject template directory not found at {empty_project_path}")
        sys.exit(1)

    new_project_name = get_new_project_name()
    new_project = new_project_name.lower()
    project_path = get_project_path()

    new_project_path = os.path.join(project_path, new_project_name)

    if os.path.exists(new_project_path):
        print(f"Error: Directory {new_project_path} already exists.")
        sys.exit(1)

    print(f"Creating new project '{new_project_name}' at {new_project_path}...")
    copy_project_template(empty_project_path, new_project_path)

    # a) Supprimer le répertoire .git s'il existe
    git_dir = os.path.join(new_project_path, ".git")
    if os.path.exists(git_dir):
        try:
            shutil.rmtree(git_dir)
        except PermissionError:
            # Change the permissions of the directory and try again
            for root, dirs, files in os.walk(git_dir):
                for dir in dirs:
                    os.chmod(os.path.join(root, dir), 0o777)
                for file in files:
                    os.chmod(os.path.join(root, file), 0o777)
            shutil.rmtree(git_dir)

    # b) Remplacer 'emptyproject' par newproject dans .pylintrc
    replace_in_file(os.path.join(new_project_path, ".pylintrc"), "emptyproject", new_project)

    # c) Remplacer 'emptyproject' par newproject dans pytest.ini
    replace_in_file(os.path.join(new_project_path, "pytest.ini"), "emptyproject", new_project)

    # d) Remplacer 'EmptyProject' par le newProjectName dans config/project_config.yaml
    replace_in_file(os.path.join(new_project_path, "emptyproject", "config", "project_config.yaml"), "EmptyProject", new_project_name)

    # e) Modifier le fichier Excel pour APP_DATA dans la feuille ResourceStrings
    basic_data_path = os.path.join(new_project_path, "data", "init_data", "Basic_Data.xlsx")
    update_excel_file(basic_data_path, "ResourceStrings", "APP_DATA", new_project_name)

    # f) Renommer le répertoire emptyproject en newproject (en minuscule)
    old_project_dir = os.path.join(new_project_path, "emptyproject")
    new_project_dir = os.path.join(new_project_path, new_project)
    os.rename(old_project_dir, new_project_dir)

    # g) Initialiser un nouveau dépôt git
    print("Initializing new git repository...")
    run_command("git init", cwd=new_project_path)
    run_command("git add .", cwd=new_project_path)
    run_command(f'git commit -m "Initial commit"', cwd=new_project_path)

    # h) Exécuter pytest
    print("Running pytest...")
    run_command("pytest", cwd=new_project_path)

    # i) Exécuter pylint
    print("Running pylint...")
    run_command(f"pylint {new_project}", cwd=new_project_path)
    run_command(f"pylint tools", cwd=new_project_path)

if __name__ == "__main__":
    main()
