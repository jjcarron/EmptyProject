Attribute VB_Name = "m_XL_Exporter"
Option Compare Database
Option Explicit

'' ==============================================================================
'' Module : ExcelWorksheetFormatting
''
'' Description:
'' This module provides functions to format Excel worksheets, create index sheets,
'' add total rows, and export cross-tab data from Access to Excel. These utilities
'' are useful for generating well-structured and formatted Excel reports directly
'' from Access VBA.
''
'' Key Responsibilities:
'' - Format Excel worksheets with borders, headers, and data formatting.
'' - Create an index sheet that lists all cross-tab query results.
'' - Add a total row to the bottom of an Excel worksheet.
'' - Export cross-tab data from Access to Excel and generate corresponding charts.
''
'' Dependencies:
'' - Requires the Excel Object Library for handling Excel operations.
'' - Requires DAO for accessing and querying the Access database.
''
'' Usage:
'' 1. Call `FormatWorkSheet` to apply consistent formatting to an Excel worksheet.
'' 2. Use `CreateIndexSheet` to generate an index of cross-tab query results.
'' 3. Use `AddTotalRow` to add a sum row at the bottom of an Excel table.
'' 4. Call `ExportCrossTabCasinoYearToExcel` to export data and create charts.
''
'' ==============================================================================

Sub FormatWorkSheet(ws As Worksheet)
    '' Formats the entire worksheet by applying borders, styling headers, and
    '' setting the number format for data cells. This function ensures that the
    '' worksheet is presented in a clean and professional manner.
    ''
    '' Parameters:
    '' - ws: The Excel worksheet to be formatted.

    Dim usedRange As Excel.Range
    Dim headerRange As Excel.Range
    Dim columnHeadersRange As Excel.Range
    Dim DataRange As Excel.Range
    
    ' Define the used range of the worksheet
    Set usedRange = ws.usedRange

    ' Apply thin gridlines to the used range
    With usedRange.Borders
        .LineStyle = xlContinuous
        .Weight = xlThin
        .ColorIndex = 0
    End With

    ' Apply medium borders to column headers
    Set headerRange = ws.Range(usedRange.Rows(1), usedRange.columns(1))
    With headerRange.Borders(xlEdgeTop)
        .LineStyle = xlContinuous
        .Weight = xlMedium
    End With
    With headerRange.Borders(xlEdgeBottom)
        .LineStyle = xlContinuous
        .Weight = xlMedium
    End With
    With headerRange.Borders(xlEdgeLeft)
        .LineStyle = xlContinuous
        .Weight = xlMedium
    End With
    With headerRange.Borders(xlEdgeRight)
        .LineStyle = xlContinuous
        .Weight = xlMedium
    End With

    ' Apply medium borders to row headers
    Set headerRange = ws.Range(usedRange.columns(1), usedRange.Rows(1))
    With headerRange.Borders(xlEdgeTop)
        .LineStyle = xlContinuous
        .Weight = xlMedium
    End With
    With headerRange.Borders(xlEdgeBottom)
        .LineStyle = xlContinuous
        .Weight = xlMedium
    End With
    With headerRange.Borders(xlEdgeLeft)
        .LineStyle = xlContinuous
        .Weight = xlMedium
    End With
    With headerRange.Borders(xlEdgeRight)
        .LineStyle = xlContinuous
        .Weight = xlMedium
    End With

    ' Apply medium borders around the entire used range
    With usedRange.Borders(xlEdgeTop)
        .LineStyle = xlContinuous
        .Weight = xlMedium
    End With
    With usedRange.Borders(xlEdgeBottom)
        .LineStyle = xlContinuous
        .Weight = xlMedium
    End With
    With usedRange.Borders(xlEdgeLeft)
        .LineStyle = xlContinuous
        .Weight = xlMedium
    End With
    With usedRange.Borders(xlEdgeRight)
        .LineStyle = xlContinuous
        .Weight = xlMedium
    End With

    ' Style headers: make them bold and apply a theme color
    Set headerRange = ws.Range(usedRange.Rows(1).Address)
    With headerRange
        .Font.Bold = True
        .Interior.ThemeColor = xlThemeColorDark2
    End With
    
    ' Style row headers similarly
    Set headerRange = ws.Range(usedRange.columns(1).Address)
    With headerRange
        .Font.Bold = True
        .Interior.ThemeColor = xlThemeColorDark2
    End With
    
    ' Center column titles except the first column
    Set columnHeadersRange = ws.Range(ws.Cells(1, 2), ws.Cells(1, usedRange.columns.count))
    columnHeadersRange.HorizontalAlignment = xlCenter

    ' Format data cells as numbers with thousands separators
    If usedRange.Rows.count > 1 Then
        Set DataRange = usedRange.Offset(1, 1).Resize(usedRange.Rows.count - 1, usedRange.columns.count - 1)
        DataRange.NumberFormat = "#,##0"
    End If
End Sub

Sub CreateIndexSheet(wb As Workbook, Name As String, resource_strings As cDB_ResourceStrings, Operation As String)
    '' Creates an index sheet in the specified workbook, listing titles, sheet prefixes,
    '' and query names from the 'CrossviewInfos' table in Access, filtered by the operation.
    ''
    '' Parameters:
    '' - wb: The Excel workbook where the index sheet will be added.
    '' - Name: The name of the sheet to be created.
    '' - resource_strings: A resource string manager for translating titles.
    '' - Operation: The operation filter to be applied to the 'CrossviewInfos' table.

    Dim ws As Worksheet
    Dim db As DAO.Database
    Dim rs As DAO.Recordset
    Dim rng As Excel.Range
    Dim i As Integer
    Dim Title As String
    Dim QueryName As String
    Dim SheetPrefix As String

    ' Assign the workbook and create a new sheet named "Index"
    On Error Resume Next
    Set ws = wb.Sheets("Index")
    If Not ws Is Nothing Then
        ws.Delete
    End If
    On Error GoTo 0
    
    Set ws = wb.Sheets.Add(After:=wb.Sheets(wb.Sheets.count))
    ws.Name = "Index"

    ' Open the Access database and retrieve data from the 'CrossviewInfos' table
    Set db = CurrentDb
    Set rs = db.OpenRecordset("SELECT Title, Sheet_Prefix, QueryName FROM CrossviewInfos WHERE Operation='" & Operation & "' ORDER BY Title")

    ' Fill the index sheet with data
    Title = resource_strings.str(Ref:="TITLE")
    SheetPrefix = resource_strings.str(Ref:="SHEET_PREFIX")
    QueryName = resource_strings.str(Ref:="QUERY_NAME")
    ws.Cells(1, 1).value = Title
    ws.Cells(1, 2).value = SheetPrefix
    ws.Cells(1, 3).value = QueryName

    i = 2
    Do While Not rs.EOF
        ws.Cells(i, 1).value = rs.fields("Title").value
        ws.Cells(i, 2).value = rs.fields("Sheet_Prefix").value
        ws.Cells(i, 3).value = rs.fields("QueryName").value
        rs.MoveNext
        i = i + 1
    Loop

    ' Close the recordset and database
    rs.Close
    db.Close
    Set rs = Nothing
    Set db = Nothing

    ' Define the data range
    Set rng = ws.Range(ws.Cells(1, 1), ws.Cells(i - 1, 3))

    ' Apply table formatting
    With rng
        .Font.Name = "Calibri"
        .Font.Size = 11
        .Borders.LineStyle = xlContinuous
        .Borders.Weight = xlThin
    End With

    ' Apply header formatting
    With ws.Range(ws.Cells(1, 1), ws.Cells(1, 3))
        .Font.Bold = True
        .Interior.Color = RGB(217, 217, 217)
        .HorizontalAlignment = xlCenter
    End With

    ' Sort data alphabetically by the first column
    ws.Sort.SortFields.Clear
    ws.Sort.SortFields.Add Key:=ws.Range("A2:A" & i - 1), _
        SortOn:=xlSortOnValues, Order:=xlAscending, DataOption:=xlSortNormal
    With ws.Sort
        .SetRange rng
        .Header = xlYes
        .MatchCase = False
        .Orientation = xlTopToBottom
        .SortMethod = xlPinYin
        .Apply
    End With
    rng.columns.EntireColumn.AutoFit
End Sub

Sub AddTotalRow(ws As Worksheet)
    '' Adds a total row at the bottom of the Excel worksheet, summing up
    '' all numeric columns.
    ''
    '' Parameters:
    '' - ws: The Excel worksheet where the total row will be added.

    Dim lastRow As Long
    Dim lastCol As Long
    Dim i As Long

    ' Find the last row and column of the table
    lastRow = ws.Cells(ws.Rows.count, 1).End(xlUp).Row
    lastCol = ws.Cells(1, ws.columns.count).End(xlToLeft).column

    ' Add a row for totals
    ws.Cells(lastRow + 1, 1).value = "Total"

    ' Calculate the sum of each column
    For i = 2 To lastCol ' Assuming the first column contains row titles
        ws.Cells(lastRow + 1, i).Formula = "=SUM(" & ws.Cells(2, i).Address & ":" & ws.Cells(lastRow, i).Address & ")"
    Next i
End Sub

Sub ExportCrossTabCasinoYearToExcel(wb As Workbook, Title As String, QueryName As String, X_Name As String, Y_Name As String, SheetPrefix As String)
    '' Exports a cross-tab query from Access to an Excel workbook, creates a new worksheet
    '' for the data, and generates a corresponding line chart.
    ''
    '' Parameters:
    '' - wb: The Excel workbook where the data and chart will be added.
    '' - Title: The title of the chart.
    '' - QueryName: The name of the cross-tab query in Access.
    '' - X_Name: The label for the X-axis (typically years).
    '' - Y_Name: The label for the Y-axis (typically values).
    '' - SheetPrefix: The prefix used for naming the Excel sheets.

    Dim db As DAO.Database
    Dim rs As DAO.Recordset
    Dim ws As Object
    Dim wsChart As Object
    Dim colIndex As Integer
    Dim chartObject As Object
    Dim chartSeries As Object
    Dim SheetName As String
    Dim i As Integer
    Dim tmp As String

    ' Define the current Access database
    Set db = CurrentDb

    ' Open the recordset for the cross-tab query
    On Error GoTo errHandler
    Set rs = db.OpenRecordset(QueryName)

    ' Add a new sheet for the data
    Set ws = wb.Sheets.Add(After:=wb.Sheets(wb.Sheets.count))
    
    SheetName = SheetPrefix & "_Data"
    i = 1
    tmp = SheetName
    While SheetExists(tmp, wb)
        log.LogEvent "The name " & tmp & " is already used. It will be extended with a number", eInfo
        tmp = SheetName & "_" & i
        i = i + 1
    Wend
    SheetName = tmp
    ws.Name = SheetName
    
    ' Add headers
    For colIndex = 0 To rs.fields.count - 1
        ws.Cells(1, colIndex + 1).value = rs.fields(colIndex).Name
    Next colIndex

    ' Copy the data
    ws.Range("A2").CopyFromRecordset rs
    AddTotalRow ws
    FormatWorkSheet ws

    ' Add a new sheet for the chart
    Set wsChart = wb.Sheets.Add(After:=wb.Sheets(wb.Sheets.count))
    SheetName = SheetPrefix & "_Chart"
    i = 1
    tmp = SheetName
    While SheetExists(tmp, wb)
        log.LogEvent "The name " & tmp & " is already used. It will be extended with a number", eInfo
        tmp = SheetName & "_" & i
        i = i + 1
    Wend
    SheetName = tmp
    wsChart.Name = SheetName

    ' Create the chart
    Set chartObject = wsChart.ChartObjects.Add(Left:=50, Width:=1200, Top:=50, Height:=800)

    With chartObject.Chart
        .ChartType = xlLine

        ' Add titles and labels
        .HasTitle = True
        .ChartTitle.Text = Title
        .Axes(xlCategory, xlPrimary).HasTitle = True
        .Axes(xlCategory, xlPrimary).AxisTitle.Text = X_Name
        .Axes(xlValue, xlPrimary).HasTitle = True
        .Axes(xlValue, xlPrimary).AxisTitle.Text = Y_Name

        ' Add data series
        Dim lastRow As Long
        Dim lastCol As Long

        lastRow = ws.Cells(ws.Rows.count, 1).End(xlUp).Row
        lastCol = ws.Cells(1, ws.columns.count).End(xlToLeft).column

        ' For each casino (row), add a data series
        For i = 2 To lastRow
            Set chartSeries = .SeriesCollection.NewSeries
            With chartSeries
                .Name = ws.Cells(i, 1).value ' Casino name
                .XValues = ws.Range(ws.Cells(1, 2), ws.Cells(1, lastCol)) ' Years
                .values = ws.Range(ws.Cells(i, 2), ws.Cells(i, lastCol)) ' Values for the casino
            End With
        Next i

        ' Update the legend
        .HasLegend = True
        .Legend.Position = xlLegendPositionBottom
        ' Enable minor gridlines for the category axis
        .Axes(xlCategory, xlPrimary).HasMinorGridlines = True
    End With

    ' Release objects
    rs.Close
    Set rs = Nothing
    Set db = Nothing
    Exit Sub
errHandler:
    Set db = Nothing
    log.LogEvent "WARNING : The Query " & QueryName & " not found", eWarning
End Sub



