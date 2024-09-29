VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "cXL_SOK_2015_2019_File"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'' Class : cXL_SOK_2015_2019_File
''
'' This class reads the Excel file which contains SOK Criterion_values from 2015-2019
'' and fills the appropriate criterion_values in the database.
''
'' All the data available for criteria defined in the Criteria Table are read.

Option Compare Database
Option Explicit

Private myXL_file As cDB_SOKFile
Private Const cSheet As String = "Vue d'ensemble"
Private XLBook As Workbook
Private myInitialized As Boolean

Sub ReadAndAddCriteria()
    '' Reads the Excel sheet "Vue d'ensemble" for the years 2015-2019 and adds the relevant data to the `criterion_values` collection.
    '' The subroutine processes all criteria defined in the Criteria Table and associates the data with the correct casino and year.
    
    Dim sh As Worksheet
    Dim xl As New cXL
    Dim Year As Long
    Dim Row As Integer
    Dim Col As Integer
    Dim Ref As String
    Dim Criterion As cDB_Criterion
    Dim CasinoRow As Integer
    Const CasinoFirstCol As Integer = 5
    Const NumberOfCasino As Integer = 21
    
On Error GoTo errHandler:
    Set XLBook = xl.OpenBook(myXL_file.fullPath)
    
    If myXL_file.Year = 2015 Then
        CasinoRow = 1
    Else
        CasinoRow = 3
    End If
    
    For Col = CasinoFirstCol To CasinoFirstCol + NumberOfCasino - 1
        On Error Resume Next
        Set sh = XLBook.Sheets(cSheet)
        If sh Is Nothing Then ' Sheet doesn't exist
            log.LogEvent "The sheet " & cSheet & " could not be read in " & myXL_file.fullPath, eWarning
        Else
            For Each Criterion In criteria.LB_Collection
                Ref = Mid(Criterion.Reference, 4)
                Row = FindRowWithRef(r:=sh.columns("A"), Ref:=Ref)
                If Row > 0 Then
                    criterion_values.Add value:=sh.Cells(Row, Col).value, Criterion_Ref:=Criterion.Reference, Casino:=sh.Cells(CasinoRow, Col).Text, Year:=myXL_file.Year
                End If
            Next Criterion
            Set sh = Nothing
        End If
    Next Col
    
    xl.CloseBook
    Exit Sub
    
errHandler:
    xl.CloseBook
    log.LogEvent "The Sheet " & cSheet & " could not be read in " & myXL_file.fullPath, eWarning
End Sub

Function Initialize(xl_file As cDB_SOKFile)
    '' Initializes the class by setting the Excel file (cDB_SOKFile) to be processed.
    Set myXL_file = xl_file
End Function

