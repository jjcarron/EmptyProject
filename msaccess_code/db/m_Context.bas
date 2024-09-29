Attribute VB_Name = "m_Context"
Option Compare Database
Option Explicit

'' ==============================================================================
'' Module : Context
''
'' Description:
'' This module defines global constants, variables, and functions that manage
'' application-wide settings, paths, logging, and common objects. It ensures the
'' proper initialization of paths, logging, and critical objects like Excel
'' application instances and database objects. This module serves as the foundation
'' for setting up the environment in which other parts of the application operate.
''
'' Key Responsibilities:
'' - Define global paths and constants used throughout the application.
'' - Initialize and manage logging with the `cLogger` class.
'' - Initialize and manage global objects, including database and Excel instances.
'' - Provide utility functions for environment-specific operations.
''
'' Usage:
'' 1. Include this module in your VBA project to ensure the necessary context and
''    environment are set up before other code is executed.
'' 2. Use the `Init_Context` function to set up paths, logging, and other critical
''    objects when the application starts.
'' 3. Access global paths, objects, and constants directly from this module as needed.
''
'' Dependencies:
'' - Requires various classes like `cLogger`, `cAccessStatusBar`, `cDB`, `cXL_App`,
''   and others for proper functionality.
'' - Utilizes Windows environment variables for user-specific settings.
''
'' ==============================================================================

' Global Constants
Public DbPath As String
Public DbDefPath As String
Public DbInitDataPath As String
Public TemplatesPath As String
Public InputPath As String
Public OutputPath As String
Public LogPath As String
Public dbDataPath As String
Public DocPath As String
Public dbDocPath As String
Public CodePath As String
Public dbCodePath As String
Public InitDataCSVPath As String

' Access Definitions Files
Public Const Common_TablesDef_FileName As String = "Common_Tables.def"
Public Const Common_ViewsDef_FileName As String = "Common_Views.def"
Public Const Table_Indexes_FileName As String = "Table_Indexes.def"
Public Const ClassDefs_FileName As String = "Classes.def"
Public Const Common_Data_FileName As String = "PlaySafeMetrics_Data.xlsx"

Public Const DefaultUserDomain As String = "EJPD"
Public Const DefaultLogFile As String = "DB.log"
Public Const LNameMax = 250 ' Maximum length for bonus names

Public Const cSOKFilter As String = ".*SOK.*[ -_](20\d\d).xlsx"
Public Const cGGRFileName As String = "BSE_Casino.xlsx"
Public Const cDZSFileName As String = "Activity_per_year.xlsx"

' Global Data
' Create new objects to ensure visibility after Office update in May 2024
Public log As cLogger
Public StatusBar As New cAccessStatusBar
Public LoggedIn As Boolean
Public Staging As Boolean
Public USERDOMAIN As String

Public db As New cDB
Public Resource As New cDB_ResourceStrings
Public TheCurrentUser As New cDB_User
Public MainMenu As cDB_Menu
Public xlApp As New cXL_App

' My table Objects
Public cross_view_infos As New cDB_CrossviewInfos
Public casinos As New cDB_Casinos
Public criteria As New cDB_Criteria
Public sok_files As New cDB_SOKFiles
Public criterion_values As New cDB_CriterionValues

Public Settings As New cDB_Settings
Public resource_strings As New cDB_ResourceStrings

Public Declare PtrSafe Sub Sleep Lib "kernel32" (ByVal Milliseconds As LongPtr)

Public Function GetLogger(Optional Filename As String = "") As cLogger
    '' Initializes and returns the global logger object.
    ''
    '' If the logger (`log`) is not already initialized, it creates a new instance
    '' and initializes it with the specified filename. If the logger is already
    '' initialized but the filename does not match, it resets the file.
    ''
    '' Parameters:
    '' - Filename: (Optional) The name of the log file to be used.
    ''
    '' Returns:
    '' - A `cLogger` object initialized with the specified or default filename.

    Init_Path
    If Filename = "" Then Filename = DefaultLogFile
    If log Is Nothing Then
        Set log = New cLogger
        log.Initialize LogPath & Filename, Verbosity.eAll, DebugPrint:=True
    ElseIf Not log.FileAlreadyOpen(Filename) Then
        log.resetFile Filename
    End If
    Set GetLogger = log
End Function

Public Function Get_XL_App() As Excel.Application
    '' Initializes and returns the global Excel application object.
    ''
    '' This function ensures that an Excel application instance (`xlApp`) is
    '' initialized and returns it for use in other parts of the application.
    ''
    '' Returns:
    '' - An `Excel.Application` object.

    Init_Path
    If xlApp Is Nothing Then
        Set xlApp = New cXL_App
        xlApp.Application.Workbooks.Add
    End If
    Set Get_XL_App = xlApp.Application
End Function

Public Sub Close_XL_App()
    '' Closes the global Excel application object if it is no longer needed.
    ''
    '' This subroutine should be called only when the application is closing
    '' or when the Excel instance is no longer needed for performance reasons.

    Set xlApp = Nothing
End Sub

Sub Init_Path()
    '' Initializes the global paths used throughout the application.
    ''
    '' This subroutine sets up various paths that are used to store and retrieve
    '' data, templates, logs, and other necessary files in the application. The
    '' paths are based on the current project's location.

    DbPath = Application.CurrentProject.Path & "\"
    CodePath = DbPath & "..\..\msaccess_code\"
    dbCodePath = CodePath & "db\"
    DbDefPath = CodePath & "dbdefs\"
    dbDataPath = DbPath & "..\"
    DbInitDataPath = dbDataPath & "\init_data\"
    TemplatesPath = dbDataPath & "templates\"
    InputPath = dbDataPath & "input\"
    OutputPath = dbDataPath & "output\"
    LogPath = dbDataPath & "log\"
    DocPath = CodePath & "docs\"
    InitDataCSVPath = CodePath & "dbInitData\"
End Sub

Function DoYouWantToContinueOnEJPD() As Integer
    '' Asks the user whether to continue in the EJPD environment.
    ''
    '' This function displays a message box warning the user about potential
    '' application freezing issues in the EJPD environment due to library
    '' incompatibilities. It returns the user's choice.
    ''
    '' Returns:
    '' - vbOK or vbCancel depending on the user's choice.

    Dim res As Integer
    res = vbOK
    If USERDOMAIN = "EJPD" Then
        res = MsgBox("This function can freeze the application in the EJPD environment due to some library incompatibilities. Do you want to continue?", Buttons:=vbOKCancel)
    End If
    DoYouWantToContinueOnEJPD = res
End Function

Function Init_Context()
    '' Initializes the application context and sets up global objects and settings.
    ''
    '' This function is the entry point for setting up the application's environment.
    '' It initializes paths, logging, user context, and other critical objects that
    '' are necessary for the application's operation.
    ''
    '' Returns:
    '' - Initializes necessary objects and variables but has no return value.

    Dim USERNAME As String
    ' Stop ' Just an entry point for debugging if necessary

    LoggedIn = True ' for testing only

    Init_Path
    Set log = GetLogger

    Set TheCurrentUser = New cDB_User
    USERDOMAIN = Environ("USERDOMAIN")
    USERNAME = Environ("USERINITIALS") ' EJPD
    If USERNAME = "" Then USERNAME = Environ("USERNAME")  ' Other environments
    
    TheCurrentUser.Initialize USERNAME
    
    Set Resource = New cDB_ResourceStrings

    If MainMenu Is Nothing Then
        Set MainMenu = New cDB_Menu
        MainMenu.SetMenu "APP_SMSTAT"
    End If
    
    If Not LoggedIn Then
        DoCmd.OpenForm "frm_Login"
    End If
    If db Is Nothing Then Set db = New cDB
    
    ' Close all remaining Excel instances to avoid conflicts
    If Not xlApp Is Nothing Then
        On Error Resume Next
        xlApp.Application.Workbooks.Close
    End If
    
    ' Set staging to true or false
    Staging = True
End Function

Sub NotImplemented()
    '' Displays a message indicating that a function is not implemented.
    ''
    '' This subroutine can be used as a placeholder for features or functions
    '' that have not yet been implemented in the application.

    MsgBox "This function is not implemented"
End Sub

Sub TestMenu()
    '' Tests the `cDB_Menu` class by initializing it with the "APP_SMSTAT" menu.
    
    Dim menu As cDB_Menu
    Set menu = New cDB_Menu
    menu.SetMenu ("APP_SMSTAT")
End Sub
