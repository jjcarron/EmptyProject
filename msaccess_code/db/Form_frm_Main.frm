VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Form_frm_Main"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Compare Database

'' frm_Main
'' This form serves as the main interface of the application. It provides various controls and menu options
'' for loading files, initializing databases, exporting data, and managing application settings.
'' The form handles user interactions through buttons and menu items, initializing the necessary processes
'' when these controls are activated.

Private Sub BTN_LOAD_FILE_LIST_Click()
    '' Triggered when the "Load File List" button is clicked.
    '' This event calls the Load_File_List_Cmd function to load the file list into the application.
    Load_File_List_Cmd
End Sub

Private Sub BTN_NEW_DB_Click()
    '' Triggered when the "New DB" button is clicked.
    '' This event calls the InitializeNewDB_Cmd function to initialize a new database.
    InitializeNewDB_Cmd
End Sub

Private Sub BTN_RELOAD_DB_Click()
    '' Triggered when the "Reload DB" button is clicked.
    '' This event calls the Load_DB_Cmd function to reload the database into the application.
    Load_DB_Cmd
End Sub

Private Sub MNU_CLOSE_TABS_Click()
    '' Triggered when the "Close Tabs" menu item is clicked.
    '' This event calls the Close_Tabs_Cmd function to close all open tabs in the application.
    Close_Tabs_Cmd
End Sub

Private Sub InitComboBoxes()
    '' Initializes the combo boxes on the form with the appropriate values.
    '' Specifically, it sets the language combo box to the current user's language preference.
    If CB_LANGUAGES.ListCount > 0 Then
        CB_LANGUAGES = TheCurrentUser.userLanguage
    End If
End Sub

Private Sub Form_Load()
    '' Triggered when the form is loaded.
    '' This event initializes the application context, logs the user in, translates the form's labels based on the selected language,
    '' opens the hidden cleanup form, and initializes the combo boxes.
    Init_Context
    LoggedIn = True ' Set to False if login functionality is required
    Dim translator As New cDB_Translator
    translator.TranslateForm (Me)
    DoCmd.OpenForm "frm_CleanUp", WindowMode:=acHidden
    InitComboBoxes
End Sub

Private Sub Form_Close()
    '' Triggered when the form is closed.
    '' This event ensures that any open Excel applications are closed when the main form is closed.
    Close_XL_App
End Sub

Private Sub MNU_EXPORT_ALL_Click()
    '' Triggered when the "Export All" menu item is clicked.
    '' This event calls the Export_All_Cmd function to export all relevant data.
    Export_All_Cmd
End Sub

Private Sub MNU_EXPORT_BO_Click()
    '' Triggered when the "Export BO" menu item is clicked.
    '' This event calls the Export_BO_Cmd function to export BO-related data.
    Export_BO_Cmd
End Sub

Private Sub MNU_EXPORT_LB_Click()
    '' Triggered when the "Export LB" menu item is clicked.
    '' This event calls the Export_LB_Cmd function to export LB-related data.
    Export_LB_Cmd
End Sub

Private Sub MNU_EXPORT_OL_Click()
    '' Triggered when the "Export OL" menu item is clicked.
    '' This event calls the Export_OL_Cmd function to export OL-related data.
    Export_OL_Cmd
End Sub

Private Sub MNU_LOAD_DZS_Click()
    '' Triggered when the "Load DZS" menu item is clicked.
    '' This event calls the Load_DZS_Cmd function to load DZS data into the application.
    Load_DZS_Cmd
End Sub

Private Sub MNU_LOAD_FILES_Click()
    '' Triggered when the "Load Files" menu item is clicked.
    '' This event calls the Load_Files_Cmd function to load files into the application.
    Load_Files_Cmd
End Sub

Private Sub MNU_LOAD_GGR_Click()
    '' Triggered when the "Load GGR" menu item is clicked.
    '' This event calls the Load_GGR_Cmd function to load GGR data into the application.
    Load_GGR_Cmd
End Sub

Private Sub MNU_LOAD_QUERY_Click()
    '' Triggered when the "Load Query" menu item is clicked.
    '' This event calls the Load_Query_Cmd function to load and execute a query in the application.
    Load_Query_Cmd
End Sub

