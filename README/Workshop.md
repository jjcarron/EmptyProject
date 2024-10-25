
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
ajouter un chargeur et un lecteur de fichiers spécifique
```python
from lib.db_loader import DatabaseLoader
from xl.xl_simple_reader import XlSimpleReader
...
def handle_load(this_db):
    """
    Handle the 'load' command, which loads data into the existing database.

    Parameters:
    - args: The command-line arguments.
    - this_db: The database object to interact with.
    """
    
    dbl = DatabaseLoader(this_db)
    pattern = project.input_files_pattern.replace("{year}", r"\d{4}")

    log.info(f"Loading data from project.input_dir: {project.input_dir}")
    dbl.load_data_from_files(
        XlSimpleReader,
        tables=["Categories", "Sentences"],
        path=project.input_dir,
        pattern=pattern,
        post_processing=this_db.update_sentences_category_fk,
        recursive=True,
    )
...
```
Le fichier xl_simple_reader.py hérite les propriété de xl_reader. 
Il lit les tables du fichier Simple_File.xlsx 

```python
from xl.xl_reader import XlReader

class XlSimpleReader(XlReader):
```
Exemple d'import
```python
    def load_sentences(self):
        """
        Load and process data from the 'Sentences' sheet in the Excel file.

        This method reads data from the 'Sentences' sheet, cleans up the DataFrame,
        and converts it into a list of dictionaries for database insertion. The 'year' field
        is extracted from the file name using the match object.

        Returns:
            list: A list of dictionaries representing the 'Sentences' data.
        """
        df = self.get_dataframe("Sentences")
        df = self.cleanup_df(df)

        data = []
        try:
            for _, row in df.iterrows():
                new_entry = {
                    "category_key": row["category_key"],
                    "sentence": row["sentence"],
                    "year": self.match.group(2),
                }
                data.append(new_entry)
        except KeyError as e:
            print(f"KeyError: {e} not found in the row")

        return data
 ```
 Chargement des tables souhaitées à partir du fichier
 xl_reader gère le chargement et la lecture du fichier Excel ainsi que l'appel de load_data pour chaque table
 ```python
    def load_data(self, table):
        """
        Load and process data from the specified sheet in the Excel file.

        This method reads data from the specified table ('Categories' or 'Sentences'),
        processes it, and prepares it for database insertion.

        Args:
            table (str): The name of the table/sheet to load ('Categories' or 'Sentences').

        Returns:
            list: A list of dictionaries, where each dictionary represents a row to be inserted
            into the database.
        """
        if table == "Categories":
            data_to_insert = self.load_categories()
        elif table == "Sentences":
            data_to_insert = self.load_sentences()
        else:
            data_to_insert = []

        return data_to_insert        
```
## 6.	Création d'export simples ##
ajouter un exportateur de base
```python
from lib.db_exporter import DatabaseExporter
...
def handle_export(this_db):
    """
    Handle the 'export' command, which exports data from the database into Excel files.

    Parameters:
    - args: The command-line arguments.
    - this_db: The database object to interact with.
    """
    log.info("Exporting data...")

    # Using DatabaseExporter to export data
    db_exporter_test_file = os.path.join(
        project.output_dir, "db_exporter_test.xlsx")
    with DatabaseExporter(this_db, db_exporter_test_file) as dbe:
        dbe.export_tables(["Categories", "Sentences"])

        # Reformat one sheet
        sh = dbe.writer.get_sheet("Sentences")
        sh.format_worksheet()
        sh.adjust_column_width()
        sh.page_print_setting(portrait=False)
        sh.define_header_and_footer(title="My Sentences")
``` 
utlisation d'un exportateur spécifique
```python
from this_exporter import ThisExporter
...
from lib.db_exporter import DatabaseExporter
    # Using ThisExporter for a customized export
    customized_db_exporter_test_file = os.path.join(
        project.output_dir, "customized_exporter_test.xlsx"
    )
    with ThisExporter(this_db, customized_db_exporter_test_file) as cdbe:
        cdbe.export_all()
```
## 7.	Extension du modèle de données pour créer des pivots ##
### Définir dans le fichier de données basic_data.XLSX  ###
une table de critères d'évaluation de ses données (Criteria)

| key  | definition           |
|------|----------------------|
| C_1  | Number of Letters     |
| C_2  | Number of Letter_A    |
| C_3  | Number of words       |

les pivots souhaités (PivotInfos)
| query_name        | formula           | draw_rows | draw_total | draw_delta |
|-------------------|-------------------|-----------|------------|------------|
| number_of_letters | C_1               | VRAI      | VRAI       | VRAI       |
| number_of_words   | C_3               | VRAI      | VRAI       | FAUX       |
| number_of_a       | C_2               | VRAI      | VRAI       | FAUX       |
| aA_percentage     | C_2 / C_1 * 100   | VRAI      | FAUX       | FAUX       |
La colonne formula permet de définir des formules mathématique simple sur les critères. (+, -, *, / ainsi que la notation des puissance de 10 sous la forme 1E4 pour 10'000) 
### Compléter le fichier de définition de la base de données (models.json) ### 
```json
        "Criteria": {
            "id": { "type": "Integer", "primary_key": true },
            "key": { "type": "String" },
            "definition": { "type": "String" },
            "comment": { "type": "String" }
        },
        "CriterionValues": {
            "id": { "type": "Integer", "primary_key": true },
            "dimension_1": { "type": "String" },
            "dimension_2": { "type": "String" },
            "criterion_key": { "type": "String" },
            "numeric_value": { "type": "Float" },
            "text_value": { "type": "String" }
        },
        "PivotInfos": {
            "id": { "type": "Integer", "primary_key": true },
            "query_name": { "type": "String" },
            "title": { "type": "String" },
            "x_name": { "type": "String" },
            "y_name": { "type": "String" },
            "sheet_prefix": { "type": "String" },
            "formula": { "type": "String" },
            "draw_rows": { "type": "Boolean" },
            "draw_total": { "type": "Boolean" },
            "draw_delta": { "type": "Boolean" }
        }
```
Mettre à jour le fichier `models.py`. avec l'outils `json_2_classes.py`
### Créer un import explicite pour l'importation des critère dans la base de données ###
exemple:
```python
   def load_data(self, tables):
        """
        Load and process data from the 'Sentences' sheet in the Excel file.

        This method reads data from the 'Sentences' sheet, processes the data,
        and prepares it for insertion into a table with columns: dimension_1, dimension_2,
        criterion_key, numeric_value, and text_value.

        Returns:
            list: A list of dictionaries representing the processed data.
        """
        _ = tables  # not used in this case
        df = self.get_dataframe("Sentences")
        df = self.cleanup_df(df)

        data = []
        try:
            for index, row in df.iterrows():
                sentence = row["sentence"]
                sentence = sentence[:-32]
                category_key = row["category_key"]

                # Calculate numeric values based on the sentence
                # Number of letters in the sentence
                num_letters = len(sentence)
                num_a = sum(
                    1 for char in sentence if char.lower() == "a"
                )  # Number of 'a' or 'A'
                # Number of words in the sentence
                num_words = len(sentence.split())

                # Prepare entries for each criterion
                criteria = [
                    {"criterion_key": "C_1", "numeric_value": num_letters},
                    {"criterion_key": "C_2", "numeric_value": num_a},
                    {"criterion_key": "C_3", "numeric_value": num_words},
                ]

                # Populate new entries for each criterion
                for criterion in criteria:
                    new_entry = {
                        "dimension_1": f"S_{(index + 1):02}",
                        "dimension_2": category_key,
                        "criterion_key": criterion["criterion_key"],
                        "numeric_value": criterion["numeric_value"],
                        "text_value": sentence,
                    }
                    data.append(new_entry)

        except KeyError as e:
            print(f"KeyError: {e} not found in the row")

        return data
```
## 8.	Export de pivot explicite avec des graphiques ##
```python
   def export_generated_pivots(self):
        """
        process formulas from pivot_information_df and create
        pivot tables

        """
        pivot_information_df = get_df_from_slqalchemy_objectlist(
            self.database.get_all("PivotInfos")
        )
        self.writer.add_index_sheet(pivot_information_df)
        data_df = get_df_from_slqalchemy_objectlist(
            self.database.get_all("CriterionValues")
        )

        # check for duplicates
        duplicated_rows = data_df[data_df.duplicated(
            subset=["criterion_key", "dimension_1", "dimension_2"], keep=False)]
        # dimension_1 = columns, dimension_2 = rows
        data_df.columns = data_df.columns.str.strip()
        self.writer.create_pivot_tables(data_df, pivot_information_df)
```
## 9.	Extension du modèle de données pour créer des pivots automatisés ##
## 10.	Export de pivots automatisés avec des graphiques  ##  
    
    
    