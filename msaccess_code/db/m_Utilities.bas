Attribute VB_Name = "m_Utilities"
Option Compare Database
Option Explicit

'' ==============================================================================
'' Module : Utilites
''
'' Description:
'' This module provides a collection of utility functions and subroutines that
'' perform a variety of tasks, including working with Excel sheets, handling
'' file system operations, and generating cryptographic hashes. These functions
'' are designed to simplify common tasks in VBA and make code more readable and
'' maintainable.
''
'' Key Responsibilities:
'' - Managing Excel sheet data and references.
'' - Performing file system operations like checking file existence, creating text
''   files, and retrieving file metadata.
'' - Providing helper functions for data type checking and conversion.
'' - Generating MD5 hash strings for given inputs.
''
'' Usage:
'' 1. Include this module in your VBA project.
'' 2. Call the appropriate functions as needed in your code to handle Excel sheets,
''    file operations, and other utility tasks.
''
'' Dependencies:
'' - Requires the `cLogger` class for error logging in some functions.
'' - Utilizes the Microsoft Scripting Runtime for file system operations.
''
'' ==============================================================================

Function lastRow(sh As Worksheet, Col As Long) As Long
    '' Returns the last row number with data in a specified column of a worksheet.
    ''
    '' Parameters:
    '' - sh: The worksheet object.
    '' - Col: The column number to check for the last used row.
    ''
    '' Returns:
    '' - The row number of the last non-empty cell in the specified column.

    On Error Resume Next
    lastRow = sh.Cells(sh.Rows.count, Col).End(xlUp).Row
    On Error GoTo 0
End Function

Function lastCol(sh As Worksheet, Row As Long) As Long
    '' Returns the last column number with data in a specified row of a worksheet.
    ''
    '' Parameters:
    '' - sh: The worksheet object.
    '' - Row: The row number to check for the last used column.
    ''
    '' Returns:
    '' - The column number of the last non-empty cell in the specified row.

    On Error Resume Next
    lastCol = sh.Cells(Row, sh.columns.count).End(xlToLeft).column
    On Error GoTo 0
End Function

Public Function FileFolderExists(strFullPath As String) As Boolean
    '' Checks if a file or folder exists at the given path.
    ''
    '' Parameters:
    '' - strFullPath: The full path to the file or folder.
    ''
    '' Returns:
    '' - True if the file or folder exists, otherwise False.

    On Error GoTo EarlyExit
    If Not Dir(strFullPath, vbDirectory) = vbNullString Then FileFolderExists = True
EarlyExit:
    On Error GoTo 0
End Function

Sub AddSheet(Name As String)
    '' Adds a new worksheet to the workbook if it does not already exist.
    ''
    '' Parameters:
    '' - Name: The name of the worksheet to add.

    Dim NewSheet As Worksheet
    On Error Resume Next
    Set NewSheet = ThisWorkbook.Worksheets(Name)
    If NewSheet Is Nothing Then ' If the worksheet doesn't exist, create it.
        Set NewSheet = ThisWorkbook.Worksheets.Add(After:=Worksheets(Worksheets.count))
        NewSheet.Name = Name
    End If
    On Error GoTo 0
End Sub

Function HasKey(coll As Collection, strKey As String) As Boolean
    '' Checks if a key exists in a collection.
    ''
    '' Parameters:
    '' - coll: The collection to check.
    '' - strKey: The key to check for in the collection.
    ''
    '' Returns:
    '' - True if the key exists, otherwise False.

    Dim Var As Variant
    On Error Resume Next
    Var = coll(strKey)
    HasKey = (err.Number = 0)
    err.Clear
End Function

Function IsLong(Val As Variant) As Boolean
    '' Checks if a given value is of type Long.
    ''
    '' Parameters:
    '' - Val: The value to check.
    ''
    '' Returns:
    '' - True if the value is a Long, otherwise False.

    IsLong = VarType(Val) = vbLong
End Function

Function IsString(Val As Variant) As Boolean
    '' Checks if a given value is of type String.
    ''
    '' Parameters:
    '' - Val: The value to check.
    ''
    '' Returns:
    '' - True if the value is a String, otherwise False.

    IsString = VarType(Val) = vbString
End Function

Function IsDouble(Val As Variant) As Boolean
    '' Checks if a given value is of type Double.
    ''
    '' Parameters:
    '' - Val: The value to check.
    ''
    '' Returns:
    '' - True if the value is a Double, otherwise False.

    IsDouble = VarType(Val) = vbDouble
End Function

Function IsInteger(Val As Variant) As Boolean
    '' Checks if a given value is of type Integer.
    ''
    '' Parameters:
    '' - Val: The value to check.
    ''
    '' Returns:
    '' - True if the value is an Integer, otherwise False.

    IsInteger = VarType(Val) = vbInteger
End Function

Function CastToLong(Val As Variant, ByRef result As Long) As Boolean
    '' Attempts to cast a given value to a Long data type.
    ''
    '' Parameters:
    '' - Val: The value to cast.
    '' - result: The variable to store the cast result.
    ''
    '' Returns:
    '' - True if the cast is successful, otherwise False.

    On Error GoTo ErrorHandler
    result = Val
    CastToLong = True
    Exit Function
ErrorHandler:
    CastToLong = False
End Function

Function archiveName(fName As String) As String
    '' Generates an archive name by appending the current date and time to the filename.
    ''
    '' Parameters:
    '' - fName: The original file name.
    ''
    '' Returns:
    '' - A new string with the archive prefix and the original file name.

    Dim t As Date
    Dim Prefix As String
    t = Now

    Prefix = "A" & Year(t) & Format(Month(t), "00") & Format(Day(t), "00") & _
             "_" & Format(Hour(t), "00") & Format(Minute(t), "00") & Format(Second(t), "00") & "_"
    archiveName = Prefix & fName
End Function

Sub FSOCreateAndWriteToTextFile()
    '' Creates a text file and writes a line of text to it.
    ''
    '' This subroutine demonstrates creating a text file using the FileSystemObject and
    '' writing a single line to it. The file is created in the specified location.
    ''
    '' Note: Adjust the file path as needed.
    
    Dim FileToCreate As TextStream
    Dim fso As New FileSystemObject
    Dim i As Long
    Set fso = CreateObject("Scripting.FileSystemObject")
    Set FileToCreate = fso.CreateTextFile("V:\Work\TestFile.txt")
    FileToCreate.Write CStr(i) & " test line" & vbCrLf
    FileToCreate.Close
End Sub

Function GetLastModifiedDate(fullPath As String) As Date
    '' Retrieves the last modified date of a file.
    ''
    '' Parameters:
    '' - fullPath: The full path of the file.
    ''
    '' Returns:
    '' - The date and time the file was last modified, or a very old date if the file doesn't exist.

    Dim fso As Object
    Set fso = CreateObject("Scripting.FileSystemObject")
    If fso.FileExists(fullPath) Then
        GetLastModifiedDate = fso.GetFile(fullPath).DateLastModified
    Else
        GetLastModifiedDate = DateSerial(-1000, 1, 1)
    End If
End Function

Function MD5(ByVal sIn As String) As String
    '' Generates an MD5 hash for a given input string.
    ''
    '' Parameters:
    '' - sIn: The input string to hash.
    ''
    '' Returns:
    '' - The MD5 hash of the input string as a hexadecimal string.
    ''
    '' Note: Ensure that the required references are set for MD5 functionality.

    Dim sOut As String
    sOut = MD5_string(sIn)
    MD5 = sOut
End Function

Function ConvertCellReferencesintoA1(Row As Long, column As Long) As String
    '' Converts row and column indices into an A1-style Excel cell reference.
    ''
    '' Parameters:
    '' - Row: The row index.
    '' - column: The column index.
    ''
    '' Returns:
    '' - The corresponding cell reference in A1 notation (e.g., "A1").

    ' Implementation logic to convert row and column indices to A1 notation
End Function

Public Function FindRowWithRef(r As Excel.Range, Ref As String) As Long
    '' Finds the row number that contains a specific reference in a given range.
    ''
    '' Parameters:
    '' - r: The range to search within.
    '' - Ref: The reference string to find.
    ''
    '' Returns:
    '' - The row number where the reference is found, or an error if not found.

    On Error Resume Next
    FindRowWithRef = r.Application.WorksheetFunction.match(Ref, r, 0)
    On Error GoTo 0
End Function

Sub AddCrosstabQuery()
    '' Adds a crosstab query to the current database.
    ''
    '' This subroutine creates a new crosstab query in the current Access database
    '' based on the SQL string provided. The query is first deleted if it already exists.
    ''
    '' Note: Adjust the SQL string and query name as needed.

    Dim db As DAO.Database
    Dim qdf As DAO.QueryDef
    Dim strSQL As String
    Dim QueryName As String

    Set db = CurrentDb
    QueryName = "MyCrosstabQuery"

    strSQL = "TRANSFORM First(IIf([Val_LB_99_1] <> 0, [Val_LB_4_2] / [Val_LB_99_1], 0)) AS Ratio " & _
             "SELECT Casinos.casino_id, dt, COUNT(*) AS n_players, SUM(cte_sp.n_sessions) " & _
             "FROM (cte_ps INNER JOIN cte_sp ON cte_ps.player_id = cte_sp.player_id) " & _
             "INNER JOIN Casinos ON cte_sp.casino_fk = Casinos.id " & _
             "GROUP BY cte_sp.dt, Casinos.casino_id " & _
             "PIVOT cte_sp.dt"

    On Error Resume Next
    db.QueryDefs.Delete QueryName
    On Error GoTo 0

    Set qdf = db.CreateQueryDef(QueryName, strSQL)

    Set qdf = Nothing
    Set db = Nothing

    MsgBox "La requête croisée a été ajoutée avec succès.", vbInformation
End Sub

Function SheetExists(SheetName As String, wb As Workbook) As Boolean
    '' Checks if a sheet with the given name exists in the workbook.
    ''
    '' Parameters:
    '' - SheetName: The name of the sheet to check.
    '' - wb: The workbook in which to check for the sheet.
    ''
    '' Returns:
    '' - True if the sheet exists, otherwise False.

    Dim ws As Worksheet
    On Error Resume Next
    Set ws = wb.Sheets(SheetName)
    On Error GoTo 0

    If Not ws Is Nothing Then
        SheetExists = True
    Else
        SheetExists = False
    End If
End Function

Sub testReporter()
    '' Tests the `cAutoDocReporter` by generating a documentation report for a specific module.
    
    Dim reporter As New cAutoDocReporter
    Dim MyModule As String
    Init_Context
    reporter.Initialize LogPath & "Doc.txt"
    
    MyModule = "cAutoDocReporter"
    reporter.DocumentModule MyModule, Application.VBE.ActiveVBProject.VBComponents(MyModule).Type
End Sub
