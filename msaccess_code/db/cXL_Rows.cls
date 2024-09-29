VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "cXL_Rows"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'' Class : cXL_Rows
''
'' This class manages a row collection
''

Option Compare Database

Private myRows As Collection
Private myInitialized As Boolean

Sub Add(ByVal Row As cXL_Row)
    '' Adds a new row (cXL_Row) to the collection of rows (myRows).
    '' If the collection has not been initialized, it calls the Initialize subroutine.
    If Not myInitialized Then
      Initialize
    End If
    myRows.Add Item:=Row
End Sub

Property Get Initialized() As Boolean
    '' Returns True if the collection (myRows) has been initialized; otherwise, False.
    Initialized = myInitialized
End Property

Property Get Row(ByVal Item As Integer) As cXL_Row
    '' Retrieves a specific row (cXL_Row) from the collection based on the index provided (1-based index).
    Row = myRows.items(Item)
End Property

Property Get count() As Integer
    '' Returns the number of rows in the collection (myRows).
    count = myRows.items.count
End Property

Property Get items() As Collection
    '' Returns the entire collection of rows (myRows).
    Set items = myRows
End Property

Property Get Rows() As Collection
    '' Returns the entire collection of rows (myRows).
    Set Rows = myRows
End Property

Public Sub Initialize()
    '' Initializes the collection (myRows) and sets the myInitialized flag to True.
    '' This ensures that the collection is ready to store rows.
    If Not myInitialized Then
        Set myRows = New Collection
        myInitialized = True
    End If
End Sub

