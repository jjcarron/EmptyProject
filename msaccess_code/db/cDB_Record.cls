VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "cDB_Record"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'' Class : cDB_Record
''
'' This class manages a single cDB_Record, which is a collection of cDB_Field objects.

Option Compare Database

Private myFields As New Collection

Sub Add(Field As cDB_Field)
    '' Adds a cDB_Field object to the record's collection of fields.
    '' Parameters:
    ''   - Field: The cDB_Field object to add to the record.
    myFields.Add Field
End Sub

Property Get fields() As Collection
    '' Returns the collection of cDB_Field objects that make up the record.
    '' Returns:
    ''   - Collection: The collection of fields in the record.
    Set fields = myFields
End Property

Property Get count() As Long
    '' Returns the number of fields in the record.
    count = myFields.count
End Property

Property Get column(index As Variant) As cDB_Field
    '' Retrieves a cDB_Field object based on the provided index or column name.
    '' Parameters:
    ''   - index: The index (numeric) or column name (string) of the field to retrieve.
    '' Returns:
    ''   - cDB_Field: The field object corresponding to the index or column name.
    Dim Col As cDB_Field
    If VarType(index) = vbString Then
        Set column = Nothing
        For Each Col In myFields
            If Col.column = index Then
                Set column = Col
                Exit Property
            End If
        Next
    Else
        ' Assume number
        Set column = myFields.Item(index)
    End If
End Property

Property Get value(Col As Variant) As Variant
    '' Retrieves the value of a field based on the provided index or column name.
    '' Parameters:
    ''   - Col: The index (numeric) or column name (string) of the field whose value is to be retrieved.
    '' Returns:
    ''   - Variant: The value of the specified field.
    value = column(Col).value
End Property

Property Get IdentiqueAs(rec As cDB_Record) As Boolean
    '' Compares the current record with another record to determine if they have the same content.
    '' Parameters:
    ''   - rec: The cDB_Record object to compare against.
    '' Returns:
    ''   - Boolean: True if the records are identical, False otherwise.
    Dim Size As Integer
    Dim i As Long
    Dim Field As cDB_Field
    IdentiqueAs = True
    
    Size = rec.count
    If Size = myFields.count Then
        i = 1
        While i <= Size
            Set Field = myFields.Item(i)
            If Not Field.IdentiqueAs(rec.column(i)) Then
                IdentiqueAs = False
            End If
            i = i + 1
        Wend
    Else
        IdentiqueAs = False
    End If
End Property

Public Sub Initialize(columns As String, Optional values As String = "")
    '' Initializes the record by parsing a comma-separated list of columns and optional values.
    '' The fields are created and added to the record's collection based on these inputs.
    '' Parameters:
    ''   - columns: A comma-separated string of column names.
    ''   - values: Optional. A comma-separated string of values corresponding to the columns.
    Dim record As New cDB_Record
    Dim Field As cDB_Field
    Dim colName As String
    Dim valStr As String
    Set myFields = New Collection
    i = InStr(1, columns, ",")
    While i > 0
        colName = Left(columns, i - 1)
        columns = Mid(columns, i + 1)
        
        i = NextCommaPos(values)
        If i > 0 Then
            valStr = Left(values, i - 1)
            values = Mid(values, i + 1)
        Else
            valStr = values
        End If
        
        Set Field = New cDB_Field
        Field.Initialize Col:=cleanup(colName), Val:=cleanup(valStr)
        myFields.Add Field
        i = InStr(1, columns, ",")
    Wend
    
    ' Add the last field (or the only field if no commas were found)
    Set Field = New cDB_Field
    Field.Initialize Col:=cleanup(columns), Val:=cleanup(values)
    myFields.Add Field, Field.column
End Sub

