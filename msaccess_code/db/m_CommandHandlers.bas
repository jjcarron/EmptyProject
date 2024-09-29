Attribute VB_Name = "m_CommandHandlers"
Option Compare Database
Option Explicit

'' ==============================================================================
'' Module : CommandHandlers
''
'' Description:
'' This module defines various subroutines that handle command operations for
'' the application. Each subroutine is responsible for initializing the application
'' context and then calling specific functions or procedures that perform tasks
'' such as exporting data, loading files, generating documentation, and more.
'' These subroutines are typically bound to UI elements like buttons in forms
'' or menu items, allowing users to execute these commands with a single action.
''
'' Key Responsibilities:
'' - Initialize the application context before executing commands.
'' - Handle user interactions and execute corresponding application functions.
'' - Provide clear and consistent command execution flow.
''
'' Usage:
'' 1. Include this module in your VBA project.
'' 2. Bind these command subroutines to the appropriate UI elements (e.g., buttons).
'' 3. Customize the subroutines as needed to suit the specific needs of your application.
''
'' Dependencies:
'' - Requires the `Init_Context` function to properly initialize the application context.
'' - Relies on other modules and classes for specific operations like exporting data,
''   generating documentation, and managing database content.
''
'' ==============================================================================

Sub UserAdmin_Cmd()
    '' Initializes the context and opens the User Administration interface.
    Init_Context
    UserAdmin
End Sub

Sub InitializeNewDB_Cmd()
    '' Initializes the context, closes any open objects, and initializes a new database.
    Init_Context
    CloseAllObjects "frm_Main", "frm_CleanUp" ' Close objects first
    InitializeNewDB
End Sub

Sub HelpAbout_Cmd()
    '' Initializes the context and opens the Help/About dialog.
    Init_Context
    HelpAbout
End Sub

Sub ChangePassword_Cmd()
    '' Initializes the context and opens the Change Password interface.
    Init_Context
    ChangePassword
End Sub

Sub ExportSheetsToCSV_cmd()
    '' Initializes the context and exports Excel sheets to CSV format.
    Init_Context
    ExportSheetsToCSV
End Sub

Sub ReloadCSVToExistingWorkbook_cmd()
    '' Initializes the context and reloads CSV data into an existing workbook.
    Init_Context
    ReloadCSVToExistingWorkbook
End Sub

Sub ExportCode_Cmd()
    '' Initializes the context and exports VBA code modules to files.
    Init_Context
    ExportCode
End Sub

Sub ImportCode_Cmd()
    '' Initializes the context, warns the user about overwriting code, and imports VBA code modules.
    Const MSG_IMPORT_CODE_WARNING As String = "This will overwrite your code!" & vbCrLf & "Do you want to continue?"
    Const MSG_WARNING As String = "Warning"
    Dim res As VbMsgBoxResult
    
    Init_Context
    res = MsgBox(MSG_IMPORT_CODE_WARNING, vbYesNo, MSG_WARNING)
    
    If res = vbYes Then
        ImportCode
    End If
End Sub

Sub Close_Tabs_Cmd()
    '' Initializes the context and closes all open objects except the main form and cleanup form.
    Init_Context
    CloseAllObjects "frm_Main", "frm_CleanUp" ' Close objects first
    DoCmd.Hourglass False
End Sub

Sub DoTestSuite_Cmd()
    '' Initializes the context, closes all open objects, and runs the test suite.
    Init_Context
    CloseAllObjects "frm_Main", "frm_CleanUp" ' Close objects first
    DoTestSuite
    DoCmd.Hourglass False
End Sub

Sub Load_File_List_Cmd()
    '' Initializes the context and loads a list of files into the database.
    Init_Context
    dbLoadFilesList
    DoCmd.Hourglass False
End Sub

Sub Load_Files_Cmd()
    '' Initializes the context and loads files into the database.
    Init_Context
    dbLoadFiles
    DoCmd.Hourglass False
End Sub

Sub GenerateDocumentation_Cmd()
    '' Initializes the context and generates project documentation.
    Init_Context
    GenerateDocumentation
End Sub

Sub ExportQueries_Cmd()
    '' Initializes the context and exports queries.
    Init_Context
    ExportQueries
End Sub

Sub Generate_DB_Classes_Cmd()
    '' Initializes the context and generates database record and class modules.
    Init_Context
    Generate_DB_Record_Class
    Generate_DB_Class
End Sub

Sub Generate_Classes_Cmd()
    '' Initializes the context and generates class modules.
    Init_Context
    Generate_Classes
End Sub

Sub Load_GGR_Cmd()
    '' Initializes the context and loads GGR (Gross Gaming Revenue) data.
    Init_Context
    dbLoadGGR
    DoCmd.Hourglass False
End Sub

Sub Load_DZS_Cmd()
    '' Initializes the context and loads DZS data.
    Init_Context
    dbLoadDZS
    DoCmd.Hourglass False
End Sub

Sub Load_DB_Cmd()
    '' Initializes the context, logs the start of the database load process,
    '' closes open objects, initializes the new database, and loads various datasets.
    DoCmd.Hourglass True
    Init_Context
    log.LogEvent vbCrLf & "========== Load full database ============= " & vbCrLf, VerbosityLevel:=eInfo
    CloseAllObjects "frm_Main", "frm_CleanUp" ' Close objects first
    InitializeNewDB
    dbLoadFilesList
    dbLoadFiles
    dbLoadGGR
    dbLoadDZS
    dbLoadCrossViewsInfos "DE"
    log.LogEvent vbCrLf & "========== Full database Loaded ============= " & vbCrLf, VerbosityLevel:=eInfo
    DoCmd.Hourglass False
End Sub

Sub Export_LB_Cmd()
    '' Initializes the context, loads cross-view information based on the selected language,
    '' and exports the "LB" cross-view data to Excel.
    Dim Language As String
    DoCmd.Hourglass True
    Init_Context
    Language = Form_frm_Main.CB_LANGUAGES
    dbLoadCrossViewsInfos Language
    Export_CrossViews_To_Excel "LB", Language
    DoCmd.Hourglass False
End Sub

Sub Export_OL_Cmd()
    '' Initializes the context, loads cross-view information based on the selected language,
    '' and exports the "OL" cross-view data to Excel.
    Dim Language As String
    DoCmd.Hourglass True
    Init_Context
    Language = Form_frm_Main.CB_LANGUAGES
    dbLoadCrossViewsInfos Language
    Export_CrossViews_To_Excel "OL", Language
    DoCmd.Hourglass False
End Sub

Sub Export_BO_Cmd()
    '' Initializes the context, loads cross-view information based on the selected language,
    '' and exports the "BO" cross-view data to Excel.
    Dim Language As String
    DoCmd.Hourglass True
    Init_Context
    Language = Form_frm_Main.CB_LANGUAGES
    dbLoadCrossViewsInfos Language
    Export_CrossViews_To_Excel "BO", Language
    DoCmd.Hourglass False
End Sub

Sub Export_All_Cmd()
    '' Exports all cross-view data ("OL", "LB", "BO") to Excel.
    Dim Language As String
    Language = Form_frm_Main.CB_LANGUAGES
    Export_OL_Cmd
    Export_LB_Cmd
    Export_BO_Cmd
End Sub

Sub Load_Query_Cmd()
    '' Initializes the context and reloads database views.
    Init_Context
    db.reloadViews
End Sub


