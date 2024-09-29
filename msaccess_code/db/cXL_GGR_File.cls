VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "cXL_GGR_File"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'' Class : cXL_GGR_File
''
'' This class reads the Excel file which contains GGR data
'' and fills appropriate criterion_values the database.
''
'' The following data are read and put into the following additional criterion_values:
''   cLB_GGR_Criterion As String -> LB_99.1
''   cOL_GGR_Criterion As String -> OL_99.1

Option Compare Database
Option Explicit

Private Const cLB_Sheet As String = "LB"
Private Const cOL_Sheet As String = "OL"
Private Const cLB_GGR_Criterion As String = "LB_99.1"
Private Const cOL_GGR_Criterion As String = "OL_99.1"
Private XLBook As Workbook
Private myInitialized As Boolean

Sub ReadAndAddCriteria()
    '' Reads the Excel sheets for land-based (LB) and online (OL) casinos from the specified GGR file.
    '' Extracts the GGR (Gross Gaming Revenue) data for each casino and adds these values to the `criterion_values` collection.
    '' The subroutine handles both land-based and online operations, logging any issues encountered during the process.
    
    Dim sh As Worksheet
    Dim xl As New cXL
    Dim Year As Long
    Dim Row As Integer
    Dim Col As Integer
    Dim Casino As cDB_Casino
    Dim GGRFilePath As String
    Dim Ref As String

    Const CasinoCol As String = "A"

    GGRFilePath = InputPath & cGGRFileName
On Error GoTo errHandler:
    Set XLBook = xl.OpenBook(GGRFilePath)
    For Each Casino In casinos.Collection
        On Error Resume Next
        Set sh = XLBook.Sheets(cLB_Sheet)
        If sh Is Nothing Then ' Sheet doesn't exist
            log.LogEvent "The Sheet " & cLB_Sheet & " is not found in " & GGRFilePath, eInfo
        Else
            Row = FindRowWithRef(r:=sh.columns(CasinoCol), Ref:=Casino.Name)
            If Row > 0 Then
                For Col = 2 To lastCol(sh, 1)
                    If Not IsEmpty(sh.Cells(Row, Col).value) And sh.Cells(Row, Col).value <> 0 Then
                        criterion_values.Add value:=sh.Cells(Row, Col).value, Criterion_Ref:=cLB_GGR_Criterion, Casino:=Casino.Name, Year:=Right(sh.Cells(1, Col).Text, 4)
                    End If
                Next Col
            Else
                log.LogEvent "The Casino " & Casino.Name & " could not be found in sheet " & cLB_Sheet & " from " & GGRFilePath, eInfo
            End If
            log.LogEvent "Casino " & Casino.Name & " GGRs loaded", eInfo
            Set sh = Nothing
        End If
        
        If Casino.Online Then
            Set sh = XLBook.Sheets(cOL_Sheet)
            If sh Is Nothing Then ' Sheet doesn't exist
                log.LogEvent "The Sheet " & cOL_Sheet & " is not found in " & GGRFilePath, eInfo
            Else
                Row = FindRowWithRef(r:=sh.columns(CasinoCol), Ref:=Casino.Name)
                If Row > 0 Then
                    For Col = 2 To lastCol(sh, 1)
                        If Not IsEmpty(sh.Cells(Row, Col).value) And sh.Cells(Row, Col).value <> 0 Then
                           criterion_values.Add value:=sh.Cells(Row, Col).value, Criterion_Ref:=cOL_GGR_Criterion, Casino:=Casino.Name, Year:=Right(sh.Cells(1, Col).Text, 4), Operation:="OL"
                        End If
                    Next Col
                Else
                    log.LogEvent "The Casino " & Casino.Name & " could not be found in sheet " & cOL_Sheet & " from " & GGRFilePath, eInfo
                End If
                log.LogEvent "Casino " & Casino.Name & " GGRs loaded", eInfo
                Set sh = Nothing
            End If
        End If
    Next Casino
    xl.CloseBook
    Exit Sub
errHandler:
    xl.CloseBook
    log.LogEvent "The Sheet " & cLB_Sheet & " could not be read in " & GGRFilePath, eWarning
End Sub

Function Initialize()
    '' Initializes the class, setting up necessary configurations or initial states.
    '' Currently, this function is a placeholder and does not contain any implementation.
End Function

