Attribute VB_Name = "m_XL_DBTables"
Option Compare Database
Option Explicit

'' ==============================================================================
'' Module : ExcelDataTransfer
''
'' Description:
'' This module provides utilities for transferring data between Access tables and
'' Excel worksheets. It includes subroutines to export multiple or single tables
'' to Excel, and to import data from Excel back into Access. Special handling is
'' provided for importing data row by row to avoid truncation of text fields.
''
'' Key Responsibilities:
'' - Export Access tables to Excel files.
'' - Import Excel worksheets into Access tables.
'' - Handle potential errors during data transfer operations and log them appropriately.
''
'' Dependencies:
'' - Requires the `cLogger` class for logging errors and events.
'' - Utilizes the `cXL` class for Excel workbook handling.
''
'' Usage:
'' 1. Call `SaveTablesToXLData` to export a collection of tables to Excel.
'' 2. Use `LoadTablesFromXLData` to import multiple worksheets back into Access.
'' 3. Use `LoadTableFromXLData2` for line-by-line import to handle large text fields.
''
'' ==============================================================================

Sub SaveTablesToXLData(tables As Collection, fullExportPath As String)
    '' Exports each table in the given collection to an Excel file at the specified path.
    ''
    '' Parameters:
    '' - tables: A collection of table names to be exported.
    '' - fullExportPath: The file path where the Excel file will be saved.

    On Error GoTo errHandler
    Dim Table As Variant
    For Each Table In tables
        DoCmd.TransferSpreadsheet TransferType:=acExport, _
                                  SpreadsheetType:=acSpreadsheetTypeExcel12Xml, _
                                  tableName:=Table, _
                                  Filename:=fullExportPath, _
                                  HasFieldNames:=True
    Next
    Exit Sub

errHandler:
    log.LogEvent "ERROR: " & err.Number & " - " & err.Description, eError
    Resume Next
End Sub

Sub SaveTableToXLData(Table As String, fullExportPath As String)
    '' Exports a single table to an Excel file at the specified path.
    ''
    '' Parameters:
    '' - Table: The name of the table to be exported.
    '' - fullExportPath: The file path where the Excel file will be saved.

    On Error GoTo errHandler
    DoCmd.TransferSpreadsheet TransferType:=acExport, _
                              SpreadsheetType:=acSpreadsheetTypeExcel12Xml, _
                              tableName:=Table, _
                              Filename:=fullExportPath, _
                              HasFieldNames:=True
    Exit Sub

errHandler:
    log.LogEvent "ERROR: " & err.Number & " - " & err.Description, eError
    Resume Next
End Sub

Sub LoadTablesFromXLData(fullPath As String)
    '' Imports data from each worksheet in the specified Excel file into corresponding Access tables.
    ''
    '' Parameters:
    '' - fullPath: The file path of the Excel file to be imported.

    On Error GoTo errHandler
    Dim xl As New cXL
    Dim wb As Workbook
    Dim xlSheet As Worksheet
    Dim i As Integer

    Set wb = xl.OpenBook(fullPath)
    
    ' Loop through all worksheets in the workbook
    For i = 1 To wb.Sheets.count
        Set xlSheet = wb.Sheets(i)

        ' Import data from the Excel worksheet into the Access table
        DoCmd.TransferSpreadsheet TransferType:=acImport, _
                                  SpreadsheetType:=acSpreadsheetTypeExcel12Xml, _
                                  tableName:=xlSheet.Name, _
                                  Filename:=fullPath, _
                                  HasFieldNames:=True, _
                                  Range:=xlSheet.Name & "$"
    Next i
    xl.CloseBook
    Exit Sub

errHandler:
    log.LogEvent "ERROR: " & err.Number & " - " & err.Description, eError
    Resume Next
End Sub

Sub LoadTableFromXLData(fullPath As String, Table As String)
    '' Imports data from a specific worksheet in the specified Excel file into an Access table.
    ''
    '' Parameters:
    '' - fullPath: The file path of the Excel file to be imported.
    '' - Table: The name of the Access table to be populated.

    On Error GoTo errHandler
    DoCmd.TransferSpreadsheet TransferType:=acImport, _
                              SpreadsheetType:=acSpreadsheetTypeExcel12Xml, _
                              tableName:=Table, _
                              Filename:=fullPath, _
                              HasFieldNames:=True, _
                              Range:=Table & "$"
    Exit Sub

errHandler:
    log.LogEvent "ERROR: " & err.Number & " - " & err.Description, eError
    Resume Next
End Sub

Sub LoadTableFromXLData2(fullPath As String, Table As String, Optional firstRow As Long = 2)
    '' Imports data from a specific worksheet in the Excel file into an Access table,
    '' processing each row individually to avoid truncation of text fields longer than 255 characters.
    ''
    '' Parameters:
    '' - fullPath: The file path of the Excel file to be imported.
    '' - Table: The name of the Access table to be populated.
    '' - firstRow: The first row of data to be imported (default is 2, assuming row 1 contains headers).

    On Error GoTo errHandler
    Dim xl As New cXL
    Dim wb As Workbook
    Dim sh As Worksheet
    Dim rs As DAO.Recordset
    Dim i As Long, k As Integer

    Set wb = xl.OpenBook(fullPath)
    Set sh = wb.Sheets(Table)
    Set rs = CurrentDb.OpenRecordset(Table, dbOpenDynaset)

    With sh
        For i = firstRow To lastRow(sh, 1) ' Start reading from the specified row
            rs.AddNew
            For k = 1 To rs.fields.count
                rs.fields(k - 1).value = .Cells(i, k).value
            Next k
            rs.Update
        Next i
    End With
    
    rs.Close
    Set rs = Nothing
    xl.CloseBook
    Exit Sub

errHandler:
    log.LogEvent "ERROR: " & err.Number & " - " & err.Description, eError
    Resume Next
End Sub



