
# Workshop du 23.10.2024 #
**Utilisation du projet de référence**
### 1. Installation de Python 
Portail clients SPT de l'OFIT (https://myaps.bit.admin.ch/web/user/software-kiosk/assigned) 
GPL Python 3.11.2150.0	| Couche 3B	|Installation SCCM

### 2. Création de l'environnment ###
dans un terminal Powershell (PS)
1. Exécuter 
   ```ps
   M:\Teams\Gremien\DB-Casinoaufsicht\ENVs\setup_python_env.ps1 -WorkDirectory "C:\my_venv_path"
   ```

2. Tester venv 
   ```ps
   PS C:\Users\Uxxxxxxxx> venv
   (myenv) PS C:\Users\U80750753>
   ```

3. Travailler
  ......
4. Désactiver avec la commande
   ```ps
   deactivate
   PS C:\Users\Uxxxxxxxx>
   ```

Hint: votre profile powershell a été adapté
1. le fichier`Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1` a été créé ou modifié
   ```ps
   set-Alias venv c:\Work\myenv\scripts\activate.ps1
   function pytest { python -m pytest }
   function pip { python.exe -m pip }
   ```
2. le fichier `\Documents\WindowsPowerShell\Microsoft.PowerShellISE_profile.ps1` a été créé ou modifié
   ```ps
   . "$env:HOMESHARE\data\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
   ```

### 4. Création du projet
   ```ps
   . "$env:HOMESHARE\data\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
   ```
    ```ps
    PS C:\Work> cd .\EmptyProject\
    PS C:\Work\EmptyProject> venv
    (myenv) PS C:\Work\EmptyProject> python .\tools\setup_new_project.py
    ```
    
    ```PS
    Enter the new project name: SimpleProject
    Enter the project path (default: C:\Work): SimpleProject
    Creating new project 'SimpleProject' at C:\Work\SimpleProject...
   ```
    Hint: Le git a été initialisé
    
### 5. Examen des fichiers
```PS
(myenv) PS C:\Work\EmptyProject> cd ..\SimpleProject\
(myenv) PS C:\Work\SimpleProject> tree -f
│   .gitignore
│   .pylintrc
│   pytest.ini
│   README.md
│   setup.py
│
├───data
│   ├───db
│   │       Database.accdb
│   │       Database.db
│   │
│   ├───init_data
│   │       Basic_Data.xlsx
│   │
│   ├───input
│   ├───log
│   │       debug.log
│   │       user.log
│   │
│   ├───output
│   ├───references
│   └───templates
├───docs
├───msaccess_code
│   ├───db
│   ├───dbDefs
│   ├───dbInitData
│   └───docs
├───README
│       NewProjectSetupCommands.txt
│
├───simpleproject
│   │   shared.py
│   │   simple_project.py
│   │   this_db.py
│   │   this_project.py
│   │   __init__.py
│   │
│   ├───config
│   │       logging_config.yaml
│   │       project_config.yaml
│   │
│   ├───db
│   │   │   base.py
│   │   │   core_db.py
│   │   │   crud.py
│   │   │   db.py
│   │   │   models.json
│   │   │   models.py
│   │   │   sqlalchemy_extensions.py
│   │   │   __init__.py
│   │
│   ├───lib
│   │   │   db_exporter.py
│   │   │   db_loader.py
│   │   │   logger.py
│   │   │   pd_version_dependent_code_example.py
│   │   │   project.py
│   │   │   singleton_meta.py
│   │   │   utils.py
│   │   │   __init__.py
│   │
│   ├───xl
│   │   │   xl_clean_reader.py
│   │   │   xl_reader.py
│   │   │   xl_writer.py
│   │   │   __init__.py
│
├───tests
│   │   conftest.py
│   │   test_shared.py
│   │   test_simple_project.py
│   │   test_this_db.py
│   │   test_this_project.py
│   │   __init__.py
│   │
│   ├───config
│   ├───db
│   │   │   test_base.py
│   │   │   test_core_db.py
│   │   │   test_crud.py
│   │   │   test_db.py
│   │   │   test_models.py
│   │   │   test_sqlalchemy_extensions.py
│   │   │
│   │
│   ├───lib
│   │   │   test_db_loader.py
│   │   │   test_logger.py
│   │   │   test_pd_version_dependent_code_example.py
│   │   │   test_project.py
│   │   │   test_singleton_meta.py
│   │   │   test_utils.py
│   │   │
│   │
│   ├───xl
│   │   │   test_xl.py
│   │   │   test_xl_clean_reader.py
│   │   │   test_xl_reader.py
│
└───tools
    │   compare_excel_result.py
    │   json_2_classes.py
    │   process.py
    │   remove_trailing_whitespaces.py
    │   setup_new_project.py
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
    
    
    
    