VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "cXL_Row"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'' Class : cXL_Row
''
'' This class manages a single row
''

Private myColumns As Collection
Private myInitialized As Boolean
Private myRowNumber As Long

Sub Add(ByVal Text As String)
    '' Adds a new column value (Text) to the collection (myColumns).
    '' The column is added with a key that corresponds to its position in the collection.
    myColumns.Add Item:=Text, Key:=CStr(myColumns.count + 1)
End Sub

Property Get Initialized() As Boolean
    '' Returns True if the collection (myColumns) has been initialized; otherwise, False.
    Initialized = myInitialized
End Property

Property Get rowNumber() As Long
    '' Returns the row number associated with the current row of data.
    rowNumber = myRowNumber
End Property

Property Get column(ByVal Item As Integer) As String
    '' Retrieves the value of a specific column in the collection based on the index provided (1-based index).
    column = myColumns(Item)
End Property

Property Get count() As Integer
    '' Returns the number of columns in the collection (myColumns).
    count = myColumns.count
End Property

Sub AlterColumn(column As Long, Text As String)
    '' Alters the value of an existing column in the collection (myColumns).
    '' The existing column is removed and replaced with the new value (Text).
    '' The new value is added at the correct position in the collection.
    Dim s As String
    myColumns.Remove CStr(column)
    If column > myColumns.count Then
        myColumns.Add Item:=Text, Key:=CStr(column)
    Else
        myColumns.Add Item:=Text, Key:=CStr(column), Before:=CStr(column + 1)
    End If
End Sub

Public Sub Initialize(rowNumber As Long)
    '' Initializes the collection (myColumns) and sets the row number (myRowNumber).
    '' This subroutine ensures that the collection is ready to store column values.
    myRowNumber = rowNumber
    If Not myInitialized Then
        Set myColumns = New Collection
        myInitialized = True
    End If
End Sub

