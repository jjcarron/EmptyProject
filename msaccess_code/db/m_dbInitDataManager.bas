Attribute VB_Name = "m_dbInitDataManager"
Option Compare Database

'' ==============================================================================
'' Module : m_dbInitDataManager
''
'' Description:
'' This module manages the export and import of Excel sheets that are used to
'' initialize relatively static database tables. It allows these sheets to be
'' exported to CSV format for version control with Git and provides functionality
'' to reload the data back into the original Excel file.
''
'' Key Responsibilities:
'' - Export sheets from an Excel file to CSV files.
'' - Reload CSV files back into the original Excel file.
''
'' Usage:
'' 1. Use `ExportSheetsToCSV` to export all sheets in the specified Excel workbook
''    to individual CSV files.
'' 2. Use `ReloadCSVToExistingWorkbook` to reload the data from these CSV files back
''    into the original Excel workbook.
''
'' Dependencies:
'' - Requires a valid Excel file path (`Common_Data_FileName`).
'' - Utilizes the Microsoft Excel object library.
''
'' ==============================================================================

Sub ExportSheetsToCSV()
    '' Exports each sheet from the specified Excel workbook to a CSV file.
    ''
    '' The CSV files are saved in the `InitDataCSVPath` directory, with each file
    '' named after the corresponding sheet.
    
    Dim wb As Workbook
    Dim ws As Worksheet
    Dim csvFileName As String
    
    On Error GoTo ErrorHandler

    ' Open the Excel workbook containing initialization data
    Set wb = Workbooks.Open(DbInitDataPath & Common_Data_FileName)
       
    ' Disable alerts to overwrite existing files without prompt
    wb.Application.DisplayAlerts = False
    
    ' Loop through each sheet in the workbook and save as CSV
    For Each ws In wb.Sheets
        ' Construct the CSV file name using the sheet name
        csvFileName = InitDataCSVPath & ws.Name & ".csv"
        
        ' Save the current sheet as CSV format
        ws.SaveAs csvFileName, xlCSV
    Next ws
    
    ' Enable alerts again
    wb.Application.DisplayAlerts = True
    
    ' Close the Excel workbook without saving changes (to avoid saving as CSV file)
    wb.Close SaveChanges:=False
    Exit Sub

ErrorHandler:
    MsgBox "Error exporting sheets to CSV: " & err.Description, vbCritical, "Export Error"
    If Not wb Is Nothing Then
        wb.Application.DisplayAlerts = True
        wb.Close SaveChanges:=False
    End If
End Sub

Sub ReloadCSVToExistingWorkbook()
    '' Reloads data from CSV files into the corresponding sheets of an existing Excel workbook.
    ''
    '' The CSV files are assumed to be in the `InitDataCSVPath` directory, with filenames
    '' matching the sheet names in the workbook. If a sheet does not exist, it will be created.
    
    Dim wb As Workbook
    Dim ws As Worksheet
    Dim csvFileName As String
    Dim SheetName As String
    Dim excelFilePath As String
    
    On Error GoTo ErrorHandler

    ' Define the path to the Excel file
    excelFilePath = DbInitDataPath & Common_Data_FileName
    
    ' Check if the Excel file exists, and create it if it doesn't
    If Dir(excelFilePath) = "" Then
        Set wb = Workbooks.Add
        wb.SaveAs excelFilePath
    Else
        Set wb = Workbooks.Open(excelFilePath)
    End If
    
    ' Disable alerts to overwrite existing content without prompt
    wb.Application.DisplayAlerts = False
    
    ' Loop through each CSV file in the specified folder
    csvFileName = Dir(InitDataCSVPath & "*.csv")
    Do While csvFileName <> ""
        SheetName = Left(csvFileName, Len(csvFileName) - 4)
        
        ' Check if a sheet with the same name already exists in the workbook
        On Error Resume Next
        Set ws = wb.Sheets(SheetName)
        On Error GoTo 0
        
        ' If the sheet does not exist, create a new one
        If ws Is Nothing Then
            Set ws = wb.Sheets.Add(, wb.Sheets(wb.Sheets.count))
            ws.Name = SheetName
        End If
        
        ' Clear existing content in the sheet
        ws.Cells.Clear
        
        ' Load the CSV file into the sheet while preserving formatting
        With ws.QueryTables.Add(Connection:="TEXT;" & InitDataCSVPath & csvFileName, Destination:=ws.Cells(1, 1))
            .TextFileParseType = xlDelimited
            .TextFileConsecutiveDelimiter = False
            .TextFileTabDelimiter = False
            .TextFileSemicolonDelimiter = False
            .TextFileCommaDelimiter = True ' CSV delimiter
            .TextFileSpaceDelimiter = False
            .TextFileColumnDataTypes = Array(2) ' Treat all columns as text
            .Refresh BackgroundQuery:=False
        End With
        
        ' Move to the next CSV file
        csvFileName = Dir
    Loop
    
    ' Enable alerts again
    wb.Application.DisplayAlerts = True
    
    ' Save the modified workbook
    wb.Save
    
    ' Close the Excel workbook
    wb.Close
    Exit Sub

ErrorHandler:
    MsgBox "Error reloading CSV into workbook: " & err.Description, vbCritical, "Import Error"
    If Not wb Is Nothing Then
        wb.Application.DisplayAlerts = True
        wb.Close SaveChanges:=False
    End If
End Sub


