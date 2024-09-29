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

'' Class : cDB_casinos

''
'' Code generated from the Class Definition 'Classes.def' at 23.05.2024
'' by cCG_DB_ClassWriter
''

Option Compare Database

'' Generated from Template Class Version 1.0
'' Author Caj
'' Last modification 28.01.2024
''
Const myTableName As String = "Casinos"

Property Get tableName() As String
'' returns true if the table exist in the database
   tableName = myTableName
End Property

Property Get isAvailable() As Boolean
'' returns true if the table exist in the database
    isAvailable = HasTable(tableName:=myTableName)
End Property

Property Get hasIndex(index As String) As Boolean
'' returns true if the table is indexed by Index
    hasIndex = TableHasIndex(myTableName, index:=index)
End Property

Property Get id(filter As String, Optional error As String = "") As Long
'' return the first id of the table for the given condition
'' This function assumes that the primary key is called "id"
'' 0 is return in cas of error
    id = FetchId(Table:=myTableName, filter:=filter, error:=error)
End Property

Property Get Item(filter As String) As cDB_Casino
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
'' return alls the records of the DB
'' The records shoud be interpreted externally
'' 0 is return in cas of error
    
    Set records = FetchItems(Table:=myTableName, filter:=filter, PreCondition:=PreCondition, PostCondition:=PostCondition, error:=error)
End Property

Property Get Casino(id As Long) As cDB_Casino
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

Property Get Collection(Optional filter As String = "", Optional ByRef PreCondition As String = "", Optional ByRef PostCondition As String = "", Optional error As String = "") As Collection ' of cDB_Casino
'' return alls the records of the DB
'' The records shoud be interpreted externally
'' 0 is return in cas of error

    Dim records As cDB_Records
    Dim record As cDB_Record
    Dim Item As cDB_Casino
    Dim mycasinos As New Collection
    Set records = FetchItems(Table:=myTableName, filter:=filter, PreCondition:=PreCondition, PostCondition:=PostCondition, error:=error)
    
    For Each record In records.records
        Set Item = New cDB_Casino
        Item.InitializeFromDB_Record record
        mycasinos.Add Item
    Next record
    Set Collection = mycasinos
End Property

Property Get count()
    count = RecordCount(myTableName)
End Property

Sub DeleteAll()
    DeleteLines Table:=myTableName
End Sub

Sub Delete(Optional filter As String = "", Optional error As String = "")
    DeleteLines Table:=myTableName, filter:=filter
End Sub

' Region "============================= User Code  =============================="

Property Get id_ByName(Name As String, Optional error As String = "") As Long
    '' Returns the ID associated with a specific Name from the table.
    '' This function assumes that the primary key in the table is named "id".
    '' If an error occurs (e.g., the Name is not found), the function returns 0.
    '' Parameters:
    ''   - Name: The name string used to search for the ID.
    ''   - error: An optional string parameter to capture any error messages.
    '' Returns:
    ''   - Long: The ID associated with the name, or 0 if not found or in case of an error.

    id_ByName = FetchId(Table:=myTableName, filter:="Name = '" & Name & "'", error:=error)
End Property

Property Get Casino_by_DZS_ID(DZS_ID As Long, Optional error As String = "") As cDB_Casino
    '' Retrieves a cDB_Casino object based on the provided DZS_ID.
    '' Parameters:
    ''   - DZS_ID: The DZS_ID (a unique identifier) used to search for the casino.
    ''   - error: An optional string parameter to capture any error messages.
    '' Returns:
    ''   - cDB_Casino: The cDB_Casino object that matches the DZS_ID, or Nothing if not found.

    Set Casino_by_DZS_ID = Item(filter:="DZS_ID = " & DZS_ID)
End Property

