
*A. Preparation
1. Install Python
2. Creating the environment
***
*B. Using the reference project
1.	Create an empty project based on the model
2.	Adapting the configuration
3.	Extend data model
4.	Database generation
5.	Creation of a specific Import module
6.	Creation of simple Exports
7.	Extend data model to create pivots
8.	Explicit pivot export with graphics
9.	Data model extension to create automated pivots
10.	Export of automated pivots with graphics
***
# A. Preparation #
## 1. install Python ##
BIT SPT customer portal (https://myaps.bit.admin.ch/web/user/software-kiosk/assigned) 
GPL Python 3.11.2150.0 | Layer 3B |Installation SCCM

## 2. Creation of environment ##
in a Powershell (PS) terminal
1. Run
   ```ps
   M:\Teams\Gremien\DB-Casinoaufsicht\ENVs\setup_python_env.ps1 -WorkDirectory "C:\my_venv_path"
   ```

2. Test venv 
   ```ps
   PS C:\Users\Uxxxxxxxx> venv
   (myenv) PS C:\Users\U80750753>
   ```
3. Working
......
4. Deactivate venv with
   ```ps
   deactivate
   PS C:\Users\Uxxxxxxxx>
   ```
Hint: your powershell profile has been adapted
1. the file `DocumentsWindowsPowerShell\Microsoft.PowerShell_profile.ps1` has been created or modified
   ```ps
   set-Alias venv c:\Work\myenv\scripts\activate.ps1
   function pytest { python -m pytest }
   function pip { python.exe -m pip }
   ```
2. the file `WindowsPowerShellMicrosoft.PowerShellISE_profile.ps1` has been created or modified
   ```ps
   . "$env:HOMESHARE\data\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
   ```
# B. Using the reference project ## 1.
## 1. create an empty project based on the model ##
### a. Adapting the powershell environment ###
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
Hint: The git has been initialized

### c. File review ###
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
│   │   │   db_Exporter.py
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
            access_create_and_Export.ps1
            CheckAgainstRefs.ps1
            pyclean.ps1
            sqlite_create_and_Export.ps1
```

## 2.	Adapting the configuration ##
Explanation of file contents (to be completed)
## 3.	Data model extension ##
File: Simple_File.xlsx
contents: two tables
Sentences (sentence, category_key, sequence_number,category_fk) ``
`` Categories (key, category) ``

Add to db\models.json
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
Run:
```PS
python .\tools\json_2_classes.py .\simpleproject\db\models.json .\simpleproject\db\models.py
```
## 4. database generation ##
```PS
python .\simpleproject\simple_project.py create
ou
python .\simpleproject\simple_project.py create -db_type access
```
Check database
Run in a separate window
```PS
sqlite_bro 
```
then open the database C:\Work\SimpleProject\datadb\Database.db
or 
go to the C:\Work\SimpleProject\datadb\ directory
and double-click Database.accdb
## 5.	Creating a specific Import module ##
### a. simple variant for a clean file ###
add  
```PS
Import os
....
# dans case "create" ajouter
dbl.load_all_sheets(
    XlCleanReader, os.path.join(project.input_dir, "Simple_File.xlsx")
)
```
Check your database
### b. variant for multiple Import with adapted Import module ###
add a specific loader and file reader
```python
from lib.db_loader Import DatabaseLoader
from xl.xl_simple_reader Import XlSimpleReader
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
The xl_simple_reader.py file inherits the properties of XlReader. 
It reads tables from the file `Simple_File.xlsx`

```python
from xl.xl_reader Import XlReader

class XlSimpleReader(XlReader):
```
Import example
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
Load desired tables from file
XLRreader handles loading and reading the Excel file, as well as calling load_data for each table
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
## 6.	Creating simple exports ##
add a basic Exporter
```python
from lib.db_Exporter Import DatabaseExporter
...
def handle_Export(this_db):
    """
    Handle the 'Export' command, which Exports data from the database into Excel files.

    Parameters:
    - args: The command-line arguments.
    - this_db: The database object to interact with.
    """
    log.info("Exporting data...")

    # Using DatabaseExporter to Export data
    db_Exporter_test_file = os.path.join(
        project.output_dir, "db_Exporter_test.xlsx")
    with DatabaseExporter(this_db, db_Exporter_test_file) as dbe:
        dbe.Export_tables(["Categories", "Sentences"])

        # Reformat one sheet
        sh = dbe.writer.get_sheet("Sentences")
        sh.format_worksheet()
        sh.adjust_column_width()
        sh.page_print_setting(portrait=False)
        sh.define_header_and_footer(title="My Sentences")
``` 
use of a specific Exporter
```python
from this_Exporter Import ThisExporter
...
from lib.db_Exporter Import DatabaseExporter
    # Using ThisExporter for a customized Export
    customized_db_Exporter_test_file = os.path.join(
        project.output_dir, "customized_Exporter_test.xlsx"
    )
    with ThisExporter(this_db, customized_db_Exporter_test_file) as cdbe:
        cdbe.Export_all()
```
## 7.	Extending the data model to create pivots ##
### Define in the data file basic_data.XLSX ###
a table of data evaluation criteria (Criteria)

| key  | definition           |
|------|----------------------|
| C_1  | Number of Letters     |
| C_2  | Number of Letter_A    |
| C_3  | Number of words       |

desired pivots (PivotInfos) for automated pivot export

| query_name        | formula           | draw_rows | draw_total | draw_delta |
|-------------------|-------------------|-----------|------------|------------|
| number_of_letters | C_1               | VRAI      | VRAI       | VRAI       |
| number_of_words   | C_3               | VRAI      | VRAI       | FAUX       |
| number_of_a       | C_2               | VRAI      | VRAI       | FAUX       |
| aA_percentage     | C_2 / C_1 * 100   | VRAI      | FAUX       | FAUX       |

The formula column lets you define simple mathematical formulas for the criteria. (`+, -, *, /` as well as the notation of powers of 10 in the form 1E4 for 10'000) 

in ResourceStrings, the resources required to display the labels of each desired automated pivot. 

| key                             | en                | de              | fr              | it              |
|----------------------------------|-------------------|-----------------|-----------------|-----------------|
| number_of_letters_sheet_prefix   | NbLetters         | sheet_prefix_de | sheet_prefix_fr | sheet_prefix_it |
| number_of_letters_title          | Number of letters | Title_de        | Title_fr        | Title_it        |
| number_of_letters_x_label        | order             | x_label_de      | x_label_fr      | x_label_it      |
| number_of_letters_y_label        | category          | y_label_de      | y_label_fr      | y_label_it      

in this example, 
number_of_letters` corresponds to the query_name 
`_sheet_prefix` indicates that it will be used to prefix the name of the output sheet, which will be completed by `_data` or `_chart`.
Similarly, `_title`, `_x_label` and `_y_label` specify the sheet title and labels to be used.
### Completing the database definition file (models.json) ### 
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
Update the `models.py` file with the `json_2_classes.py` tool
### Create an explicit Import for importing criteria into the database ###
example:

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
## 8.	Explicit pivot export with graphics ##
```python
   def Export_generated_pivots(self):
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
## 9.	Extend data model to create automated pivots ##
```python
   def Export_generated_pivots(self):
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
## 10.	Export automated pivots with graphics ##
```Python 
   def Export_generated_pivots(self):
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
        if not duplicated_rows.empty:
            print("Duplicates found (displaying the first 20):")
            print(duplicated_rows.head(20))
            print(f"Total number of duplicates: {len(duplicated_rows)}")
            raise ValueError("Duplicates exist in the data")

        data_df.columns = data_df.columns.str.strip()
        self.writer.create_pivot_tables(data_df, pivot_information_df)
```
    
    