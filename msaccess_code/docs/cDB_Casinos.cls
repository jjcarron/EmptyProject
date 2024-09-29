VERSION 1.0 CLASS
BEGIN
	MultiUse = -1  'True
END
Attribute VB_Name = "cDB_Casinos"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

' Region "============================= Generated Code ==============================" 

'' Class : cDB_Casinos

'' 
'' Code generated from the Class Definition 'Classes.def' at 22.08.2024
'' by cCG_DB_ClassWriter
''

Option Compare Database

'' Generated from Template Class Version 1.0
'' Author Caj
'' Last modification 28.01.2024
''
Const myTableName As String = "Casinos"

Property Get tableName() As String
    '' Returns the table name for the object. This is a constant value.
    tableName = myTableName
End Property

Property Get isAvailable() As Boolean
    '' Checks if the table exists in the database and returns True if it exists.
    isAvailable = HasTable(tableName:=myTableName)
End Property

Property Get hasIndex(index As String) As Boolean
    '' Checks if the table is indexed by the specified index and returns True if it is.
    '' Parameters:
    ''   - index: The index name to check for.
    hasIndex = TableHasIndex(myTableName, index:=index)
End Property

Property Get id(filter As String, Optional error As String = "") As Long
    '' Returns the first ID from the table for the given filter condition.
    '' Assumes the primary key column is called "id".
    '' Returns 0 in case of an error.
    '' Parameters:
    ''   - filter: A filter condition to retrieve the specific ID.
    ''   - error: Optional. A string to store error details.
    id = FetchId(Table:=myTableName, filter:=filter, error:=error)
End Property

Property Get Item(filter As String) As cDB_Casino
    '' Returns an object of type cDB_Casino for the given filter condition.
    '' Parameters:
    ''   - filter: A filter condition to retrieve the specific object.
    
    Dim rec As cDB_Record
    Dim Casino As New cDB_Casino
    Set rec = FetchItem(Table:=myTableName, filter:=filter)
    If Not rec Is Nothing Then
        Casino.InitializeFromDB_Record rec
        Set Item = Casino
    Else
        Set Item = Nothing
    End If
End Property

Property Get records(Optional filter As String = "", Optional ByRef PreCondition As String = "", Optional ByRef PostCondition As String = "", Optional error As String = "") As cDB_Records
    '' Returns all records from the table that match the optional filter condition.
    '' If an error occurs, it returns 0.
    '' Parameters:
    ''   - filter: Optional. A filter condition to retrieve specific records.
    ''   - PreCondition: Optional. A precondition to be applied to the query.
    ''   - PostCondition: Optional. A postcondition to be applied to the query.
    ''   - error: Optional. A string to store error details.
    
    Set records = FetchItems(Table:=myTableName, filter:=filter, PreCondition:=PreCondition, PostCondition:=PostCondition, error:=error)
End Property

Property Get Casino(id As Long) As cDB_Casino
    '' Returns a cDB_Casino object for the specified ID.
    '' Parameters:
    ''   - id: The ID of the record to retrieve.
    
    Dim rec As cDB_Record
    Dim obj As New cDB_Casino
    Set rec = FetchItem(Table:=myTableName, filter:="id = " & id)
    If Not rec Is Nothing Then
        obj.InitializeFromDB_Record rec
        Set Casino = obj
    Else
        Set Casino = Nothing
    End If
End Property

Property Get Collection(Optional filter As String = "", Optional ByRef PreCondition As String = "", Optional ByRef PostCondition As String = "", Optional error As String = "") As Collection
    '' Returns a collection of cDB_Casino objects for all records in the table that match the optional filter condition.
    '' Parameters:
    ''   - filter: Optional. A filter condition to retrieve specific records.
    ''   - PreCondition: Optional. A precondition to be applied to the query.
    ''   - PostCondition: Optional. A postcondition to be applied to the query.
    ''   - error: Optional. A string to store error details.

    Dim records As cDB_Records
    Dim record As cDB_Record
    Dim Item As cDB_Casino
    Dim myCasinos As New Collection
    Set records = FetchItems(Table:=myTableName, filter:=filter, PreCondition:=PreCondition, PostCondition:=PostCondition, error:=error)
    
    For Each record In records.records
        Set Item = New cDB_Casino
        Item.InitializeFromDB_Record record
        myCasinos.Add Item
    Next record
    Set Collection = myCasinos
End Property

Property Get count()
    '' Returns the count of records in the table.
    count = RecordCount(myTableName)
End Property

Sub DeleteAll()
    '' Deletes all records from the table.
    DeleteLines Table:=myTableName
End Sub

Sub Delete(Optional filter As String = "", Optional error As String = "")
    '' Deletes records from the table that match the optional filter condition.
    '' Parameters:
    ''   - filter: Optional. A filter condition to delete specific records.
    ''   - error: Optional. A string to store error details.
    DeleteLines Table:=myTableName, filter:=filter
End Sub


' Region "============================= User Code  ==============================" 

