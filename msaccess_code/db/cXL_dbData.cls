VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "cXL_dbData"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

'' Class : cXL_dbData

''
'' This class allows to fill a database tables from an Excel File
'' The first Row contains the field's name as column's title
''

Option Compare Database

Private myTableName As String
Private myRows As cXL_Rows

Property Get tableName() As String
    '' Returns the name of the table associated with the current object.
    tableName = myTableName
End Property

Property Get Rows() As cXL_Rows
    '' Returns the entire collection of rows (cXL_Rows) associated with the table.
    Set Rows = myRows
End Property

Property Get dataRows() As cXL_Rows
    '' Returns the data rows (cXL_Rows) associated with the table.
    '' This is a synonym for the Rows property.
    Set dataRows = myRows
End Property

Property Get columnTitle(index As Integer) As String
    '' Returns the title of the column at the specified index (1-based).
    Dim Row As cXL_Row
    Set Row = myRows.items(1)
    columnTitle = Row.column(1)
End Property

Property Get columnTitles() As String
    '' Returns a comma-separated string of all column titles.
    '' If a column title is empty, it assigns a default name "Column_" followed by its index.
    Dim lcolumnTitle As String
    Dim Row As cXL_Row
    Set Row = myRows.items(1)
    lcolumnTitle = Row.column(1)
    For i = 2 To Row.count
        If Row.column(i) <> "" Then
            lcolumnTitle = lcolumnTitle & ", " & Row.column(i)
        Else
            lcolumnTitle = lcolumnTitle & ", " & "Column_" & i
        End If
    Next
    columnTitles = lcolumnTitle
End Property

Public Property Get record(index As Integer) As cDB_Record
    '' Returns a cDB_Record object representing a single record (row) from the data.
    '' Only non-empty fields are added to the record.
    Dim lRecord As New cDB_Record
    Dim Field As cDB_Field
    Dim Val As String
    i = 1
    While i <= myRows.items(1).count
        Set Field = New cDB_Field
        Val = myRows.items(index + 1).column(i)
        If Val <> "" Then ' only add non-empty fields
            Field.Initialize Col:=myRows.items(1).column(i), Val:=myRows.items(index + 1).column(i)
            lRecord.Add Field
        End If
        i = i + 1
    Wend
    Set record = lRecord
End Property

Public Property Get records() As cDB_Records
    '' Returns a cDB_Records collection containing all records from the data rows.
    '' Each record is created from non-empty fields in each row.
    Dim lRecord As cDB_Record
    Dim lrecords As New cDB_Records
    Dim Field As cDB_Field
    Dim Val As String
    Dim r As cXL_Row
    Dim index As Long
    
    For index = 2 To myRows.Rows.count
        i = 1
        Set lRecord = New cDB_Record

        While i <= myRows.items(1).count
            Set Field = New cDB_Field
            Val = myRows.items(index).column(i)
            If Val <> "" Then ' only add non-empty fields
                Field.Initialize Col:=myRows.items(1).column(i), Val:=myRows.items(index).column(i)
                lRecord.Add Field
            End If
            i = i + 1
        Wend
        lrecords.Add lRecord
    Next
    Set records = lrecords
End Property

Property Get rowValues(index As Integer) As String
    '' Returns a comma-separated string of values for a specified row (by index).
    '' Each value is enclosed in single quotes.
    Dim lrowValues As String
    Set Row = myRows.items(index + 1)
    lrowValues = "'" & Row.column(1) & "'"
    For i = 2 To Row.count
        lrowValues = lrowValues & ", '" & Row.column(i) & "'"
    Next
    rowValues = lrowValues
End Property

Property Get rowCount() As Integer
    '' Returns the number of data rows (excluding the header row) in the table.
    rowCount = myRows.items.count - 1
End Property

Sub Initialize(tblName As String, Rows As cXL_Rows)
    '' Initializes the object with a table name and a collection of rows.
    myTableName = tblName
    Set myRows = Rows
End Sub

