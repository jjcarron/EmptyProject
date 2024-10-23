
# Workshop du 23.10.2024 #
*A. Préparation*
1. Installation de Python
2. Création de l'environnment
***
*B. Utilisation du projet de référence*
1.	Création d'un projet vide basé sur le modèle
2.	Adaptation de la configuration
3.	Extension du modèle de données
4.	Génération de la base de donnée
5.	Création d'un module d'import spécifique
6.	Création d'export simples
7.	Extension du modèle de données pour créer des pivots
8.	Export de pivot explicite avec des graphiques
9.	Extension du modèle de données pour créer des pivots automatisés
10.	Export de pivots automatisés avec des graphiques
***
# A. Préparation #
## 1. Installation de Python ##
    Portail clients SPT de l'OFIT (https://myaps.bit.admin.ch/web/user/software-kiosk/assigned) 
    GPL Python 3.11.2150.0	| Couche 3B	|Installation SCCM

## 2. Création de l'environnment ##
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
# B. Utilisation du projet de référence #
## 1. Création d'un projet vide basé sur le modèle ##
### a. Adaptation de l'environnement powershell ###
   ```ps
   . "$env:HOMESHARE\data\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
   ```
### b. Setup ###
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
    
### c. Examen des fichiers  ###

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
```

## 2.	Adaptation de la configuration ##
Explication du contenu du fichier (à compléter)
## 3.	Extension du modèle de données ##
Fichier : Simple_File.xlsx
contenu : deux tables
`` Sentences (sentence, category_key, sequence_number,category_fk) ``
`` Categories (key, category) ``

Ajouter à db\models.json
```json
        "Sentences": {
            "id": { "type": "Integer", "primary_key": true },
            "category_key": { "type": "String" },
            "category_fk": { "type": "String" },
            "sentence": { "type": "String" },
            "year": { "type": "Integer" }
        },
        "Categories": {
            "id": { "type": "Integer", "primary_key": true },
            "key": { "type": "String", "unique": true },
            "category": { "type": "String" }
        },
```
Exécuter:
```PS
python .\tools\json_2_classes.py .\simpleproject\db\models.json .\simpleproject\db\models.py
```
## 4.	Génération de la base de donnée ##
```PS
python .\simpleproject\simple_project.py create
ou
python .\simpleproject\simple_project.py create -db_type access
```
Vérification de la base de données
Exécuter dans une fenêtre séparée
```PS
sqlite_bro 
```
puis ouvrir la base de données C:\Work\SimpleProject\data\db\Database.db
ou 
aller dans le répertoire  C:\Work\SimpleProject\data\db\
et double-cliquer Database.accdb
## 5.	Création d'un module d'import spécifique ##
### a. variante simple pour un fichier propre ###
ajouter 
```PS
import os
....
# dans case "create" ajouter
dbl.load_all_sheets(
    XlCleanReader, os.path.join(project.input_dir, "Simple_File.xlsx")
)
```
Vérifier votre base de donnée
### b. variante pour un import multiple avec un module d'import adapté ###
Créer des données
Copier le fichier generate_altered_data.py dans simpleproject
```python
from generate_altered_data import generate_data_from_template
...


```
## 6.	Création d'export simples ##
## 7.	Extension du modèle de données pour créer des pivots ##
## 8.	Export de pivot explicite avec des graphiques ##
## 9.	Extension du modèle de données pour créer des pivots automatisés ##
## 10.	Export de pivots automatisés avec des graphiques  ##  
    
    
    