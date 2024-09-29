VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "cXL_SOK_2020_20nn_File"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'' Class : cXL_SOK_2020_20nn_File
''
'' This class reads the Excel file which contains SOK Criterion_values from 2020 onwards
'' and fills the appropriate criterion_values in the database.
''
'' All the data available for criteria defined in the Criteria Table are read.

Option Compare Database
Option Explicit

Private myXL_file As cDB_SOKFile
Private Const cOL_Sheet As String = "Gesamtschau OL"
Private Const cLB_Sheet As String = "Gesamtschau LB"
Private XLBook As Workbook
Private myInitialized As Boolean

Sub ReadAndAddCriteria()
    '' Reads the Excel sheets for land-based (LB) and online (OL) casinos from the specified SOK file for 2020 onwards.
    '' Extracts the data for each criterion defined in the Criteria Table and adds these values to the `criterion_values` collection.
    '' The subroutine handles both LB and OL data and logs any issues encountered during the process.
    
    Dim sh As Worksheet
    Dim xl As New cXL
    Dim Year As Long
    Dim Row As Integer
    Dim Col As Integer
    Dim Ref As String
    Dim Criterion As cDB_Criterion
    Dim CasinoRow As Integer
    Dim Casino As String
    Const CasinoFirstCol As Integer = 5
    Const NumberOfCasino As Integer = 21
    
On Error GoTo errHandler:
    Set XLBook = xl.OpenBook(myXL_file.fullPath)
    CasinoRow = 3
    
    For Col = CasinoFirstCol To CasinoFirstCol + NumberOfCasino - 1
        On Error Resume Next
        
        ' Read LB Data
        Set sh = XLBook.Sheets(cLB_Sheet)
        If sh Is Nothing Then ' Sheet doesn't exist
            log.LogEvent "The sheet " & cLB_Sheet & " could not be read in " & myXL_file.fullPath, eInfo
        Else
            For Each Criterion In criteria.LB_Collection
                Ref = Mid(Criterion.Reference, 4)
                Row = FindRowWithRef(r:=sh.columns("A"), Ref:=Ref)
                Casino = sh.Cells(CasinoRow, Col).Text
                If Row > 0 And Casino <> "" Then
                    criterion_values.Add value:=sh.Cells(Row, Col).value, Criterion_Ref:=Criterion.Reference, Casino:=Casino, Year:=myXL_file.Year
                End If
            Next Criterion
        End If
            
        ' Read OL Data
        Set sh = XLBook.Sheets(cOL_Sheet)
        If sh Is Nothing Then ' Sheet doesn't exist
            log.LogEvent "The sheet " & cOL_Sheet & " could not be read in " & myXL_file.fullPath, eInfo
        Else
            Casino = sh.Cells(CasinoRow, Col).Text
            If Casino <> "" Then
                For Each Criterion In criteria.OL_Collection
                    Ref = Mid(Criterion.Reference, 4)
                    Row = FindRowWithRef(r:=sh.columns("A"), Ref:=Ref)
                    If Row > 0 Then
                        criterion_values.Add value:=sh.Cells(Row, Col).value, Criterion_Ref:=Criterion.Reference, Casino:=Casino, Year:=myXL_file.Year, Operation:="OL"
                    End If
                Next Criterion
            End If
        End If
        Set sh = Nothing
    Next Col
    
    xl.CloseBook
    Exit Sub
    
errHandler:
    xl.CloseBook
    log.LogEvent "The Sheet " & cLB_Sheet & " could not be read in " & myXL_file.fullPath, eWarning
End Sub

Function Initialize(xl_file As cDB_SOKFile)
    '' Initializes the class by setting the Excel file (cDB_SOKFile) to be processed.
    Set myXL_file = xl_file
End Function

