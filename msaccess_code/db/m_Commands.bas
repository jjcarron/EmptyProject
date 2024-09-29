Attribute VB_Name = "m_Commands"
Sub UserAdmin_Cmd()
    Init_Context
    UserAdmin
End Sub

Sub InitializeNewDB_Cmd()
    Init_Context
    CloseAllObjects "frm_Main", "frm_CleanUp"    'close objects first
    InitializeNewDB
End Sub

Sub HelpAbout_Cmd()
    Init_Context
    HelpAbout
End Sub

Sub ChangePassword_Cmd()
    Init_Context
    ChangePassword
End Sub

Sub ExportSheetsToCSV_cmd()
    Init_Context
    ExportSheetsToCSV
End Sub

Sub ReloadCSVToExistingWorkbook_cmd()
    Init_Context
    ReloadCSVToExistingWorkbook
End Sub

Sub ExportCode_Cmd()
    Init_Context
    ExportCode
End Sub

Sub ImportCode_Cmd()
'' the DB is not yet initialized => No translator available
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
    Init_Context
    CloseAllObjects "frm_Main", "frm_CleanUp"    'close objects first 'close objects first
    DoCmd.Hourglass (False)
End Sub

Sub DoTestSuite_Cmd()
    Init_Context
    CloseAllObjects "frm_Main", "frm_CleanUp"    'close objects first 'close objects first
    DoTestSuite
    DoCmd.Hourglass (False)
End Sub

Sub Load_File_List_Cmd()
    Init_Context
    dbLoadFilesList
        DoCmd.Hourglass (False)
End Sub

Sub Load_Files_Cmd()
    Init_Context
    dbLoadFiles
    DoCmd.Hourglass (False)
End Sub

Sub GenerateDocumentation_Cmd()
    Init_Context
    GenerateDocumentation
End Sub

Sub ExportQueries_Cmd()
    Init_Context
    ExportQueries
End Sub

Sub Generate_DB_Classes_Cmd()
    Init_Context
    Generate_DB_Record_Class
    Generate_DB_Class
End Sub

Sub Generate_Classes_Cmd()
    Init_Context
    Generate_Classes
End Sub

Sub Load_GGR_Cmd()
    Init_Context
    dbLoadGGR
    DoCmd.Hourglass (False)
End Sub

Sub Load_DZS_Cmd()
    Init_Context
    dbLoadDZS
    DoCmd.Hourglass (False)
End Sub


Sub Load_DB_Cmd()
    DoCmd.Hourglass (True)
    Init_Context
    log.LogEvent vbCrLf & "========== Load full database ============= " & vbCrLf, VerbosityLevel:=eInfo
    CloseAllObjects "frm_Main", "frm_CleanUp"   'close objects first
    InitializeNewDB
    dbLoadFilesList
    dbLoadFiles
    dbLoadGGR
    dbLoadDZS
    dbLoadCrossViewsInfos "DE"
    log.LogEvent vbCrLf & "========== Full database Loaded ============= " & vbCrLf, VerbosityLevel:=eInfo
    DoCmd.Hourglass (False)
End Sub

Sub Export_LB_Cmd()
    DoCmd.Hourglass (True)
    Init_Context
    Language = Form_frm_Main.CB_LANGUAGES
    dbLoadCrossViewsInfos Language
    Export_CrossViews_To_Excel "LB", Language
    DoCmd.Hourglass (False)
End Sub

Sub Export_OL_Cmd()
    DoCmd.Hourglass (True)
    Init_Context
    Language = Form_frm_Main.CB_LANGUAGES
    dbLoadCrossViewsInfos Language
    Export_CrossViews_To_Excel "OL", Language
    DoCmd.Hourglass (False)
End Sub

Sub Export_BO_Cmd()
    DoCmd.Hourglass (True)
    Init_Context
    Language = Form_frm_Main.CB_LANGUAGES
    dbLoadCrossViewsInfos Language
    Export_CrossViews_To_Excel "BO", Language
    DoCmd.Hourglass (False)
End Sub

Sub Export_All_Cmd()
    Language = Form_frm_Main.CB_LANGUAGES
    Export_OL_Cmd
    Export_LB_Cmd
    Export_BO_Cmd
End Sub
Sub Load_Query_Cmd()
    Init_Context
    db.reloadViews
End Sub


