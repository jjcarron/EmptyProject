## ChatGPT instructions for creating a script: ##
```PS
EMPTYPROJECT
│   .gitignore
│   .pylintrc
│   pytest.ini
│   README.md
│   requirements.txt
│   requirements_pro.txt
│   setup.py
│
├───data
│   ├───db
│   │       EmptyProj.accdb
│   │       EmptyProj.db
│   │
│   ├───init_data
│   │       Basic_Data.xlsx
│   │
│   ├───input
│   ├───log
│   ├───output
│   ├───references
│   └───templates
├───docs
├───emptyproject
│   │   empty_project.py
│   │   shared.py
│   │   this_db.py
│   │   this_project.py
│   │   __init__.py
│   │
│   ├───config
│   │       logging_config.yaml
│   │       project_config.yaml
│   │
│   ├───db
│   │       base.py
│   │       core_db.py
│   │       crud.py
│   │       db.py
│   │       models.json
│   │       models.py
│   │       sqlalchemy_extensions.py
│   │       __init__.py
│   │
│   ├───lib
│   │       logger.py
│   │       pd_version_dependent_code_example.py
│   │       project.py
│   │       singleton_meta.py
│   │       utils.py
│   │       __init__.py
│   │
│   └───xl
│           xl.py
│           xl_initial_data.py
│           __init__.py
│
├───msaccess_code
│   ├───db
│   ├───dbDefs
│   ├───dbInitData
│   └───docs
├───tests
│   │   conftest.py
│   │   test_shared.py
│   │   test_this_project.py
│   │   __init__.py
│   │
│   ├───config
│   ├───db
│   ├───lib
│   │       test_logger.py
│   │       test_utils.py
│   │
│   └───xl
└───tools
    │   compare_excel_result.py
    │   graph_test.py
    │   graph_test2.py
    │   json_2_classes.py
    │   process.py
    │   remove_trailing_whitespaces.py
    │   tabledefs_2_json.py
    │
    ├───lib
    │       db_class_generator.py
    │       easy_definition.py
    │
    └───powershell
            access_create_and_export.ps1
            CheckAgainstRefs.ps1
            pyclean.ps1
            sqlite_create_and_export.ps1
```

The directory structure above represents a project template called EmptyProject. It will be used to create new projects. 

Give me a python script that will be placed in the project's tools subdirectory. 

Features:
1) request the name of the new project “newProjectName”. This parameter must be defined. 
2) request the path name of the directory in which it is to be created `ProjectPath`. If not defined, it will be set two levels higher than the script and its path checked. If it does not exist, it will be requested again.

3) create the `ProjectPath/newProjectName` directory
4) copy everything in EmptyProject into this directory.
5) complete the script with the following commands executed in the main  `ProjectPath/newProjectName` directory, assuming that newproject = newProjectName.lower() 
a) delete .git
b) replace 'emptyproject' with newproject in `.pylintrc` global
c) Replace 'empty_project' with new_project in `tests/test_empty_project.py`
d) replace 'emptyproject' with newproject in `pytest.ini` global
e) replace 'EmpyProject' with newProjectName in `config/config_project.yaml` global
f) replace the value of the column in the row for which key=APP_NAME in the ResourceStrings sheet with the newProjectName in the file `data\init_data\Basic_Data.xlsx`
g) Rename the main file to newproject (lowercase)
h) rename the emptyproject directory with lowercase of the chosen newProjectName

i) Initialize a new Git repository with: 
```PS
git init
git add .
git commit -m "Initial commit"
```
j) Remove the .pytest_cache directory if it exists
 
k) run python -m pylint pytest newproject

l) run python -m pylint pylint newproject tests tools

m) add a module docstring and method docstring 

