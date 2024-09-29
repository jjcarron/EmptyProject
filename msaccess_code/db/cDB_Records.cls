VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "cDB_Records"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'' Class : cDB_Records
''
'' This class manages a collection of cDB_Record objects.

Option Compare Database

Private myTable As String
Private myRecords As New Collection

Sub Remove(index As Long)
    '' Removes a record from the collection based on the provided index.
    '' Parameters:
    ''   - index: The position of the record to remove from the collection.
    myRecords.Remove (index)
End Sub

Property Get count() As Long
    '' Returns the number of records in the collection.
    count = myRecords.count
End Property

Property Get Item(index As Long) As cDB_Record
    '' Retrieves a cDB_Record object from the collection based on the provided index.
    '' Parameters:
    ''   - index: The position of the record to retrieve.
    '' Returns:
    ''   - cDB_Record: The record at the specified index.
    Set Item = myRecords.Item(index)
End Property

Sub Add(record As cDB_Record)
    '' Adds a cDB_Record object to the collection.
    '' Parameters:
    ''   - record: The cDB_Record object to add to the collection.
    myRecords.Add record
End Sub

Property Get Table() As String
    '' Returns the name of the table associated with the records.
    Table = myTable
End Property

Property Get records() As Collection
    '' Returns the collection of cDB_Record objects.
    '' Returns:
    ''   - Collection: The collection of records managed by this class.
    Set records = myRecords
End Property

Sub Initialize(tableName As String)
    '' Initializes the class with the name of the table associated with the records.
    '' Parameters:
    ''   - tableName: The name of the table to associate with the records.
    myTable = tableName
End Sub

