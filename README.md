README.md# README

This README would normally document whatever steps are necessary to get your application up and running.

### What is this repository for?

- Quick summary
- Version
- [Learn Markdown](https://bitbucket.org/tutorials/markdowndemo)

### How do I get set up?

- Summary of set up
- Configuration
- Dependencies
- Database configuration
- How to run tests
- Deployment instructions

### Contribution guidelines

- Writing tests
- Code review
- Other guidelines

### Who do I talk to?

- Repo owner or admin
- Other community or team contact

### Directory structure

PLAYSAFEMETRICS  
│ .gitignore  
│ README.md  
│ requirements.txt  
│ setup.py  
│  
├── config  
│ ├── logging_config.yaml  
│ └── project_config.yaml  
│  
├── data  
│  
├── db  
│  
├── init_data  
│  
├── input  
│  
├── log  
│  
├── output  
│  
├── template  
│  
├── docs  
│  
├── PlaySafeMetrics  
│ │ gui.py  
│ │ libsqlalchemy_extensions.py  
│ │ play_safe_metrics.py  
│ │ shared.py  
│ │ sok_db.py  
│ │ this_project.py  
│ │  
│ ├── db  
│ │ ├── crud.py  
│ │ ├── db.py  
│ │ ├── utils.py  
│ │ └── **init**.py  
│ │  
│ ├── lib  
│ │ ├── easy_definition.py  
│ │ ├── logger.py  
│ │ ├── project.py  
│ │ ├── sqlalchemy_extensions.py  
│ │ └── **init**.py  
│ │  
│ ├── models  
│ │ ├── base.py  
│ │ ├── models.py  
│ │ ├── schema.json  
│ │ └── **init**.py  
│ │  
│ ├── xl  
│ │ ├── xl.py  
│ │ ├── xl_dzs_activity_file.py  
│ │ ├── xl_dzs_annual_player_data.py  
│ │ ├── xl_ggr.py  
│ │ ├── xl_initial_data.py  
│ │ ├── xl_sok_2002_2006.py  
│ │ ├── xl_sok_2007_2014.py  
│ │ ├── xl_sok_2015_2019.py  
│ │ └── xl_sok_2020_2023.py  
│  
├── tests  
│  
└── tools  
├── json_2_classes.py  
├── process.py  
├── tabledefs_2_json.py  
└── upgrade_mdb.ps1  
