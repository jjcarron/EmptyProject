Attribute VB_Name = "m_Command_Processing"
Option Compare Database
Option Explicit

'' ==============================================================================
'' Module : m_Command_Processing
''
'' Description:
'' This module handles various command operations within the application. It
'' contains subroutines that perform tasks such as user administration, generating
'' documentation, loading resources, and exporting data. These commands are typically
'' triggered by UI elements like buttons or menus and provide a bridge between the
'' user interface and the underlying application logic.
''
'' Key Responsibilities:
'' - Manage user interactions and trigger corresponding application functions.
'' - Handle data loading, exporting, and resource management tasks.
'' - Provide utility functions for database and Excel operations.
''
'' Usage:
'' 1. Include this module in your VBA project.
'' 2. Bind these subroutines to UI elements to trigger specific application actions.
'' 3. Customize the subroutines as needed to fit your application's requirements.
''
'' Dependencies:
'' - Requires the `Init_Context` function to initialize the application context.
'' - Relies on other modules and classes for database management, logging, and Excel operations.
''
'' ==============================================================================

Sub UserAdmin()
    '' Opens the User Administration form in datasheet view.
    Init_Context
    DoCmd.OpenForm "frm_Users", acFormDS
End Sub

Sub HelpAbout()
    '' Displays the "About" dialog with information about the application version and author.
    Dim s As New cDB_ResourceStrings
    MsgBox s.str("MSG_HELP_ABOUT_TXT") & vbCrLf & vbCrLf & _
           s.str("MSG_HELP_ABOUT_VERTXT") & " " & s.str("MSG_HELP_ABOUT_VER") & vbCrLf & vbCrLf & _
           s.str("MSG_HELP_ABOUT_AUT"), _
           vbOKOnly, s.str("MSG_HELP_ABOUT_CAPTION")
End Sub

Private Sub AppExit_Click()
    '' Prompts the user to back up the database before exiting the application.
    If MsgBox("Do you want to backup?", vbYesNo + vbQuestion, "Backup DB?") = vbYes Then
        Application.Quit
    Else
        Application.Quit acQuitSaveNone
    End If
End Sub

Sub GenerateDocumentation()
    '' Generates documentation for the current project using the cAutoDocReporter class.
    Dim reporter As New cAutoDocReporter
    Init_Context
    If DoYouWantToContinueOnEJPD <> vbOK Then Exit Sub
    reporter.Initialize DocPath & "DB_Code.txt"
    reporter.DocumentProject
End Sub

Sub LoadResourceStrings()
    '' Loads resource strings from an Excel file into the database.
    Init_Context
    LoadTableFromXLData fullPath:=DbInitDataPath & Common_Data_FileName, Table:="resource_strings"
End Sub

Sub Reload_Settings()
    '' Reloads settings from an Excel file into the database after deleting existing settings.
    Init_Context
    DeleteLines "Settings"
    LoadTableFromXLData fullPath:=DbInitDataPath & Common_Data_FileName, Table:="Settings"
End Sub

Sub Reload_Views()
    '' Reloads view definitions to apply changes made to them.
    Init_Context
    db.reloadViews
End Sub

Sub Reload_Menus()
    '' Reloads menu definitions and resource strings from an Excel file into the database.
    Init_Context
    DeleteLines "Menus"
    DeleteLines "resource_strings"
    LoadTableFromXLData fullPath:=DbInitDataPath & Common_Data_FileName, Table:="resource_strings"
    LoadTableFromXLData fullPath:=DbInitDataPath & Common_Data_FileName, Table:="Menus"
    Set MainMenu = New cDB_Menu
    MainMenu.SetMenu "APP_SMSTAT", force:=True
End Sub

Sub loadData_2002_2006(file As cDB_SOKFile)
    '' Loads data from an SOK file for the years 2002-2006.
    Dim SOKFile As New cXL_SOK_2002_2006_File
    SOKFile.Initialize file
    SOKFile.ReadAndAddCriteria
End Sub

Sub loadData_2007_2014(file As cDB_SOKFile)
    '' Loads data from an SOK file for the years 2007-2014.
    Dim SOKFile As New cXL_SOK_2007_2014_File
    SOKFile.Initialize file
    SOKFile.ReadAndAddCriteria
End Sub

Sub loadData_2015_2019(file As cDB_SOKFile)
    '' Loads data from an SOK file for the years 2015-2019.
    Dim SOKFile As New cXL_SOK_2015_2019_File
    SOKFile.Initialize file
    SOKFile.ReadAndAddCriteria
End Sub

Sub loadData_2020_20nn(file As cDB_SOKFile)
    '' Loads data from an SOK file for the years 2020 and beyond.
    Dim SOKFile As New cXL_SOK_2020_20nn_File
    SOKFile.Initialize file
    SOKFile.ReadAndAddCriteria
End Sub

Sub dbLoadFiles()
    '' Loads SOK files into the database, checking for modifications and updates as needed.
    Dim rec As cDB_Record
    Dim records As New cDB_Records
    Dim file As New cDB_SOKFile
    Dim LastChange As Date
    Set records = sok_files.FetchFiles
    
    Set StatusBar = New cAccessStatusBar
    StatusBar.InitMeter "Read File ... ", records.count
    log.LogEvent "================== Start Loading Files =================================", VerbosityLevel:=eInfo

    On Error GoTo ErrorHandler:
    For Each rec In records.records
        file.InitializeFromDB_Record rec
        LastChange = GetLastModifiedDate(file.fullPath)
        
        If Staging Or file.isLoaded = 0 Or LastChange > file.LastChange Then
            log.LogEvent "Load " & file.fullPath & "...", VerbosityLevel:=eInfo
            Select Case file.Year
            Case 2006:
                loadData_2002_2006 file
            Case 2014:
                loadData_2007_2014 file
            Case 2015 To 2019:
                loadData_2015_2019 file
            Case Else: '2020 to 2030
                loadData_2020_20nn file
            End Select
            sok_files.SetFileAsLoaded rec, LastChange
            log.LogEvent file.fullPath & " loaded", VerbosityLevel:=eInfo
        End If
Continue:
        StatusBar.NextMeter
    Next
    log.LogEvent "================== Files Loaded =================================", VerbosityLevel:=eInfo
    Set StatusBar = Nothing
    Exit Sub

ErrorHandler:
    log.LogEvent "File " & file.fullPath & " Couldn't be loaded", VerbosityLevel:=eWarning
    Resume Continue
End Sub

Sub dbLoadGGR()
    '' Loads Gross Gaming Revenue (GGR) data into the database.
    Set StatusBar = New cAccessStatusBar
    StatusBar.InitMeter "Read GGRs ... ", 1
    log.LogEvent "================== Start Loading GGR =================================", VerbosityLevel:=eInfo

    On Error GoTo ErrorHandler:
    Dim GGRFile As New cXL_GGR_File
    GGRFile.Initialize
    GGRFile.ReadAndAddCriteria
Continue:
    StatusBar.NextMeter
    log.LogEvent "================== GGR Loaded =================================", VerbosityLevel:=eInfo
    Set StatusBar = Nothing
    Exit Sub

ErrorHandler:
    log.LogEvent "GGRs Couldn't be loaded", VerbosityLevel:=eWarning
    Resume Continue
End Sub

Sub dbLoadDZS()
    '' Loads DZS activity data into the database.
    Set StatusBar = New cAccessStatusBar
    StatusBar.InitMeter "Read DZS Activity ... ", 1
    log.LogEvent "================== Start Loading DZS Activity =================================", VerbosityLevel:=eInfo

    On Error GoTo ErrorHandler:
    Dim DZSActivityFile As New cXL_DZS_Activity_File
    DZSActivityFile.Initialize
    DZSActivityFile.ReadAndAddCriteria
Continue:
    StatusBar.NextMeter
    log.LogEvent "================== DZS Activity Loaded =================================", VerbosityLevel:=eInfo
    Set StatusBar = Nothing
    Exit Sub

ErrorHandler:
    log.LogEvent "DZS Activity couldn't be loaded", VerbosityLevel:=eWarning
    Resume Continue
End Sub

Sub dbLoadFilesList()
    '' Loads the list of SOK files into the database, initializing from the file system.
    Dim files As New Collection
    Dim sf As Scripting.file
    Dim sokf As cDB_SOKFile
    
    Init_Context
    Set log = GetLogger

    sok_files.Initialize InputPath, cSOKFilter
    
    log.LogEvent "======================= Load Files Table  ======================", VerbosityLevel:=eInfo
    Set StatusBar = New cAccessStatusBar
    StatusBar.InitMeter "Load DB ... ", sok_files.count
    
    Set files = New Collection
    For Each sf In sok_files.files
        Set sokf = New cDB_SOKFile
        sokf.initializeFromFileSystem sf
        files.Add sokf
        StatusBar.NextMeter
        DoEvents
    Next
       
    db.addFiles files
    log.LogEvent "======================= Files Table Loaded ======================", VerbosityLevel:=eInfo

    Set StatusBar = Nothing
End Sub

Sub ChangePassword()
    '' Opens the Change Password form for the current user.
    Init_Context
    If TheCurrentUser.UserID <> 0 Then
        DoCmd.OpenForm FormName:="frm_Password", WhereCondition:="USER_ID = " & TheCurrentUser.UserID
    End If
End Sub

Function InitializeNewDB()
    '' Initializes a new database by loading common data and setting up resources.
    Init_Context

    Set log = GetLogger
    log.LogEvent "========== newDB Start ============ ", VerbosityLevel:=eInfo
    db.newDB
    DoCmd.Hourglass True
    LoadCommonDB db:=db
    log.LogEvent "========== newDB End   ============ ", VerbosityLevel:=eInfo
    DoCmd.Hourglass False

    Set resource_strings = New cDB_ResourceStrings
End Function

Sub LoadCommonDB(db As cDB)
    '' Loads common data into the database during initialization.
    Dim Common_Data As New cXL_Data
  
    Init_Context

    Set StatusBar = New cAccessStatusBar
    StatusBar.InitMeter "Create Database ... ", 2
  
    Common_Data.Initialize Name:=Common_Data_FileName, Path:=DbInitDataPath
    StatusBar.NextMeter
  
    db.addData Data:=Common_Data
    StatusBar.NextMeter
    Set StatusBar = Nothing
End Sub

Sub UpdateCommonDB()
    '' Updates common data in the database with new data from the source file.
    Dim Common_Data As New cXL_Data
    Init_Context
  
    Common_Data.Initialize Name:=Common_Data_FileName, Path:=DbInitDataPath
    db.addData Data:=Common_Data
End Sub

Sub ExportQueries()
    '' Exports the current database queries to a file.
    Init_Context
    ExportQueryDefs DocPath & Common_ViewsDef_FileName
End Sub

Sub dbLoadCrossViewsInfos(ByVal Language As String)
    '' Loads cross-view information into the database based on the selected language.
    Dim resource_strings As New cDB_ResourceStrings
    resource_strings.Initialize Language:=Language
    cross_view_infos.Initialize resource_strings
End Sub

Function Get_ExportWorkBook(Operation As String, Language As String) As Excel.Workbook
    '' Creates a new Excel workbook for exporting cross-view data and initializes it.
    Dim resource_strings As New cDB_ResourceStrings
    resource_strings.Initialize Language:=Language
    Dim wb As Excel.Workbook
    Dim ws As Excel.Worksheet

    Set wb = Get_XL_App().Workbooks.Add
    
    CreateIndexSheet wb:=wb, Name:=resource_strings.str("INDEX"), resource_strings:=resource_strings, Operation:=Operation
    Set ws = wb.Sheets.Item(1)
    If Not ws Is Nothing Then
        ws.Delete
    End If
    Set Get_ExportWorkBook = wb
End Function

Sub Export_CrossViews_To_Excel(Operation As String, ByVal Language As String)
    '' Exports cross-view data to an Excel file based on the operation and language.
    Const Export_Base_Name As String = "Sok_Stats"
    Dim Output_FileName As String
    Dim wb As Excel.Workbook
    Dim CrossView As cDB_CrossviewInfo
    Dim CrossViewsToExport As Collection
    
    Output_FileName = CurrentProject.Path & "\..\Output\" & Operation & "_" & Export_Base_Name & "_" & Language & "_" & Format(Date, "yyyymmdd") & ".xlsx"
    
    log.LogEvent "========== Export " & Operation & " Stats Started ============ ", VerbosityLevel:=eInfo
    Set StatusBar = New cAccessStatusBar
    Set CrossViewsToExport = cross_view_infos.Collection(filter:="Operation = '" & Operation & "'")
    StatusBar.InitMeter "Export " & Operation & " Stats ... ", CrossViewsToExport.count
    
    Set wb = Get_ExportWorkBook(Operation:=Operation, Language:=Language)
    
    For Each CrossView In CrossViewsToExport
        With CrossView
            ExportCrossTabCasinoYearToExcel wb:=wb, _
                                            Title:=.Title, _
                                            QueryName:=.QueryName, _
                                            X_Name:=.X_Name, _
                                            Y_Name:=.Y_Name, _
                                            SheetPrefix:=.Sheet_Prefix
        End With
        StatusBar.NextMeter
    Next
    StatusBar.RemoveMeter

    wb.Parent.DisplayAlerts = False
    wb.SaveAs Filename:=Output_FileName, FileFormat:=xlOpenXMLWorkbook
    wb.Parent.DisplayAlerts = True
    wb.Close

    log.LogEvent "========== Export " & Operation & " Stats Completed   ============ ", VerbosityLevel:=eInfo
End Sub

Private Sub Application_Quit()
    '' Closes all Excel workbooks and quits the Excel application when quitting.
    Dim App As Excel.Application
    Set App = Get_XL_App()
    If Not App Is Nothing Then
        App.Workbooks.Close
        App.Quit
    End If
End Sub


