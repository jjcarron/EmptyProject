VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "cXL_DZS_Activity_File"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'' Class : cXL_DZS_Activity_File
''
'' This class reads the Excel file which contains some player-related data
'' and fills appropriate criterion_values the database.
''
'' The following data are read and put into the following additional criterion_values:
''  C_Yearly_Active_Players -> OL_98.1
''  C_Yearly_Played_Sessions -> OL_98.2
''  C_Yearly_Bets -> OL_98.3
''  C_Yearly_Wins -> OL_98.4
''  C_Yearly_Rake -> OL_98.5
''

Option Compare Database
Option Explicit

Private Const C_Yearly_Active_Players = "OL_98.1"
Private Const C_Yearly_Played_Sessions = "OL_98.2"
Private Const C_Yearly_Bets = "OL_98.3"
Private Const C_Yearly_Wins = "OL_98.4"
Private Const C_Yearly_Rake = "OL_98.5"
Private Const Year_col = 1
Private Const DZS_ID_col = 2
Private Const Yearly_Active_Players_col = 3
Private Const Yearly_Played_Sessions_col = 4
Private Const Yearly_Bets_col = 5
Private Const Yearly_Wins_col = 6
Private Const Yearly_Rake_col = 7
Private Const cSheet_Name = "Data"
Private XLBook As Workbook
Private myInitialized As Boolean

Sub ReadAndAddCriteria()
    '' Reads the Excel sheet, extracts player-related data, and adds these values to the `criterion_values` collection.
    '' The data includes yearly active players, played sessions, bets, wins, and rake.
    '' It identifies the correct casino using the DZS_Casino_Id and fills the database accordingly.
    
    Dim sh As Worksheet
    Dim xl As New cXL
    Dim Year As Long
    Dim Row As Integer
    Dim Col As Integer
    Dim Casino As cDB_Casino
    Dim DZSFilePath As String
    Dim DZS_Casino_Id As Long
    Dim Ref As String

    DZSFilePath = InputPath & cDZSFileName
On Error GoTo errHandler:
    Set XLBook = xl.OpenBook(DZSFilePath)
    Set sh = XLBook.Sheets(cSheet_Name)
    If sh Is Nothing Then 'Doesn't exist
        log.LogEvent "The Sheet " & cSheet_Name & " is not found in " & cDZSFileName, eInfo
        Exit Sub
    End If
    For Row = 2 To lastRow(sh, Year_col)
        On Error Resume Next
        DZS_Casino_Id = sh.Cells(Row, DZS_ID_col).value
        Set Casino = casinos.Casino_by_DZS_ID(DZS_Casino_Id)
        criterion_values.Add value:=Int(sh.Cells(Row, Yearly_Active_Players_col).value), Criterion_Ref:=C_Yearly_Active_Players, Casino:=Casino.Name, Year:=sh.Cells(Row, Year_col).Text, Operation:="OL"
        criterion_values.Add value:=Int(sh.Cells(Row, Yearly_Played_Sessions_col).value), Criterion_Ref:=C_Yearly_Played_Sessions, Casino:=Casino.Name, Year:=sh.Cells(Row, Year_col).Text, Operation:="OL"
        criterion_values.Add value:=Int(sh.Cells(Row, Yearly_Bets_col).value), Criterion_Ref:=C_Yearly_Bets, Casino:=Casino.Name, Year:=sh.Cells(Row, Year_col).Text, Operation:="OL"
        criterion_values.Add value:=Int(sh.Cells(Row, Yearly_Wins_col).value), Criterion_Ref:=C_Yearly_Wins, Casino:=Casino.Name, Year:=sh.Cells(Row, Year_col).Text, Operation:="OL"
        criterion_values.Add value:=Int(sh.Cells(Row, Yearly_Rake_col).value), Criterion_Ref:=C_Yearly_Rake, Casino:=Casino.Name, Year:=sh.Cells(Row, Year_col).Text, Operation:="OL"
    Next
    Set sh = Nothing
    xl.CloseBook
    Exit Sub
errHandler:
    xl.CloseBook
    log.LogEvent "The Sheet " & cSheet_Name & " could not be read in " & DZSFilePath, eWarning
End Sub

Function Initialize()
    '' Initializes the class, setting up necessary configurations or initial states.
    '' Currently, this function is a placeholder and does not contain any implementation.
End Function

