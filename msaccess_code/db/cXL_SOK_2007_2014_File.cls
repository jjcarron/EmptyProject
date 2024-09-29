VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "cXL_SOK_2007_2014_File"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'' Class : cXL_SOK_2007_2014_File
''
'' This class reads the Excel file which contains SOK Criterion_values from 2007-2014
'' and fills the appropriate criterion_values in the database.
''
'' Only the following yearly data are available for that date range:
'' LB_2.1       : Entries
'' LB_3.1       : EarlyDetectionProcessOpenings
'' LB_3.1.1     : EmployeeObservations
'' LB_3.1.4     : ThirdPartyInformations
'' LB_3.3       : EarlyDetectionProcessClosures
'' LB_3.3.1     : EarlyDetectionProcessesClosedWithoutMeasure
'' LB_3.3.2     : EarlyDetectionProcessesClosedWithSelfBans
'' LB_3.3.3     : EarlyDetectionProcessesClosedWithForcedBans
'' LB_4.2       : Bans
'' LB_4.2.1     : FinancialBans
'' LB_4.2.2     : SocialAuthorityBans
'' LB_4.2.3     : SelfBans
'' LB_5.2.1     : Total Revoked Bans

Option Compare Database
Option Explicit

Private myXL_file As cDB_SOKFile
Private XLBook As Workbook
Private myInitialized As Boolean

Sub ReadAndAddCriteria()
    '' Reads the Excel sheets corresponding to each casino for the years 2007-2014 and adds the relevant data to the `criterion_values` collection.
    '' The subroutine processes various DOK criteria, such as entries, bans, and early detection process openings, among others, and associates them with the correct casino and year.
    
    Dim sh As Worksheet
    Dim xl As New cXL
    Dim Casino As cDB_Casino
    Dim Year As Long
    Dim Row As Integer
    Dim Col As Integer
    Dim Ref As String
    Dim Criterion As cDB_Criterion
    
On Error GoTo errHandler:
    Set XLBook = xl.OpenBook(myXL_file.fullPath)
    For Each Casino In casinos.Collection
        On Error Resume Next
        Set sh = XLBook.Sheets(Casino.Name)
        If sh Is Nothing Then ' Sheet doesn't exist
            log.LogEvent "The Casino " & Casino.Name & " is not found in " & myXL_file.fullPath, eInfo
        Else
            For Each Criterion In criteria.LB_Collection
                Ref = Criterion.Reference
                Row = FindRowWithRef(r:=sh.columns("A"), Ref:=Ref)
                If Row > 0 Then
                    For Col = 3 To 10
                        Year = sh.Cells(3, Col).value
                        If Year <> 0 Then criterion_values.Add value:=sh.Cells(Row, Col).value, Criterion_Ref:=Ref, Casino:=Casino.Name, Year:=Year
                    Next Col
                End If
            Next Criterion
            log.LogEvent "Data 2007-2014 for " & Casino.Name & " loaded", eInfo
            Set sh = Nothing
        End If
    Next Casino
    xl.CloseBook
    Exit Sub
errHandler:
    xl.CloseBook
    log.LogEvent "The Sheet " & Casino.Name & " could not be read in " & myXL_file.fullPath, eWarning
End Sub

Function Initialize(xl_file As cDB_SOKFile)
    '' Initializes the class by setting the Excel file (cDB_SOKFile) to be processed.
    Set myXL_file = xl_file
End Function

