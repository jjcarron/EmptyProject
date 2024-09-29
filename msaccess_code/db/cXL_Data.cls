VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "cXL_Data"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'' Class : cXL_Data
''
'' This class reads an Excel file and fills the database
'' with its content. The database structure should contain
'' fields according to the column names (first row) and the
'' content type.
'' It provides the capability to read only some columns defined
'' in the Optional toBeRead Collection passed by the initialize method
''

Private myDataSheets As Collection
Private myFullPath As String
Private myFk As Long 'optional key if needed
Private myToBeRead As Collection

Property Get dataSheets() As Collection
    '' Returns the collection of data sheets that have been read from the Excel file.
    Set dataSheets = myDataSheets
End Property

Property Get fk() As Long
    '' Returns the foreign key associated with the data (if any).
    fk = myFk
End Property

Property Get fullPath() As String
    '' Returns the full path of the Excel file being processed.
    fullPath = myFullPath
End Property

Sub readSheets(SheetName As String, ByRef obj As Object, XLBook)
    '' Reads the specified sheet from the Excel workbook and stores its content in a cXL_Rows object.
    '' The method iterates through the rows and columns of the sheet, processes the data types,
    '' and stores the cleaned-up values.
    Dim lRows As New cXL_Rows
    Dim lRow As New cXL_Row
    Dim i As Long
    Dim cellValue As Variant

    Set lRows = New cXL_Rows
    With XLBook.Worksheets(SheetName)
        ' Retrieve the number of used rows
        nRows = .Cells(.Rows.count, 1).End(xlUp).Row
        nCols = .Cells(1, .columns.count).End(xlToLeft).column
        
        For i = 1 To nRows
            Set lRow = New cXL_Row
            lRow.Initialize i
            For k = 1 To nCols
                cellValue = .Cells(i, k).value
                DataType = TypeName(cellValue)
                ' Process each data type accordingly
                Select Case DataType
                    Case "Boolean"
                        If cellValue Then
                           cellValue = "-1"
                        Else
                           cellValue = ""
                        End If
                    Case Else
                         cellValue = Trim(Trim(.Cells(i, k).Text))
                End Select
                lRow.Add (cellValue)
            Next k
            lRows.Add Row:=lRow
            Set lRow = Nothing
        Next i
    End With
    Set obj = lRows
End Sub

Function hasToBeRead(Name As String) As Boolean
    '' Checks if the specified sheet name is in the list of sheets to be read.
    '' If myToBeRead is not initialized, all sheets are read.
    Dim n As Variant
    If myToBeRead Is Nothing Then
        ' All sheets have to be read
        hasToBeRead = True
        Exit Function
    End If
    For Each n In myToBeRead
        If n = Name Then
            hasToBeRead = True
            Exit Function
        End If
    Next
    hasToBeRead = False
End Function

Sub Initialize(Name As String, Path As String, Optional fk As Long, Optional DataInfo As String = "", Optional toBeRead As Collection = Nothing)
    '' Initializes the cXL_Data object with the Excel file name, path, and optional parameters such as
    '' foreign key and a list of sheets to be read. The method reads the sheets and fills the database
    '' with their content.
    Dim CanClose As Boolean
    Dim Rows As cXL_Rows
    Dim dbData As cXL_dbData
    Dim xl As New cXL
    
    Set myToBeRead = toBeRead
    myFk = fk
    Set myDataSheets = New Collection
    myFullPath = Path & Name
    Set XLBook = xl.OpenBook(myFullPath)
    
    Set StatusBar = New cAccessStatusBar
    If DataInfo = "" Then DataInfo = "Basis Data"
    StatusBar.InitMeter "Load " & DataInfo & "... ", XLBook.Sheets.count
    
    For Each sheet In XLBook.Worksheets
        If hasToBeRead(sheet.Name) Then
            Set Rows = New cXL_Rows
            readSheets SheetName:=sheet.Name, obj:=Rows, XLBook:=XLBook
            Set dbData = New cXL_dbData
            dbData.Initialize tblName:=sheet.Name, Rows:=Rows
            myDataSheets.Add dbData
            StatusBar.NextMeter
        End If
    Next

    xl.CloseBook
End Sub

