VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "cXL_SOK_2002_2006_File"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'' Class : cXL_SOK_2002_2006_File
''
'' This class reads the Excel file which contains DOK Criterion_values from 2002-2006
'' and fills the appropriate criterion_values in the database.
''
'' Only the following data are available for that date range:
''   yearly Total Bans: LB_4.2
''   yearly Total Revoked Bans: LB_5.2.1
''
Option Compare Database
Option Explicit

Private myXL_file As cDB_SOKFile
Private Const cSheet As String = "Annexe2a"
Private XLBook As Workbook

Sub ReadAndAddCriteria()
    '' Reads the Excel sheet "Annexe2a" from the specified SOK file and adds the relevant data to the `criterion_values` collection.
    '' The subroutine processes yearly total bans and revoked bans for the years 2002-2006 and associates them with the correct casino and year.
    
    Dim sh As Worksheet
    Dim xl As New cXL
    Dim Casino As String
    Dim Year As Long
    Dim Row As Integer
    Dim Col As Integer
    
On Error GoTo errHandler:
    Set XLBook = xl.OpenBook(myXL_file.fullPath)
    Set sh = XLBook.Sheets(cSheet)
    
    For Row = 3 To 23
        For Col = 4 To 8
            criterion_values.Add value:=sh.Cells(Row, Col).value, Criterion_Ref:="LB_4.2", Casino:=sh.Cells(Row, 1).Text, Year:=Col + 1998
            criterion_values.Add value:=sh.Cells(Row, Col + 8).value, Criterion_Ref:="LB_5.2.1", Casino:=sh.Cells(Row, 1).Text, Year:=Col + 1998
        Next Col
    Next Row
    
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

