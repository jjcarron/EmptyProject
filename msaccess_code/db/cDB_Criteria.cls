VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "cDB_Criteria"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

' Region "============================= Generated Code =============================="

'' Class : cDB_criteria

''
'' Code generated from the Class Definition 'Classes.def' at 23.05.2024
'' by cCG_DB_ClassWriter
''

Option Compare Database

'' Generated from Template Class Version 1.0
'' Author Caj
'' Last modification 28.01.2024
''
Const myTableName As String = "Criteria"

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

Property Get Item(filter As String) As cDB_Criterion
    Dim rec As cDB_Record
    Dim Criterion As New cDB_Criterion
    Set rec = FetchItem(Table:=myTableName, filter:=filter)
    If Not rec Is Nothing Then
        Criterion.InitializeFromDB_Record rec
        Set Item = Criterion
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

Property Get Criterion(id As Long) As cDB_Criterion
    Dim rec As cDB_Record
    Dim obj As New cDB_Criterion
    Set rec = FetchItem(Table:=myTableName, filter:="id = " & id)
    If Not rec Is Nothing Then
        obj.InitializeFromDB_Record rec
        Set Criterion = obj
    Else
        Set Criterion = Nothing
    End If
End Property

Property Get Collection(Optional filter As String = "", Optional ByRef PreCondition As String = "", Optional ByRef PostCondition As String = "", Optional error As String = "") As Collection ' of cDB_Criterion
'' return alls the records of the DB
'' The records shoud be interpreted externally
'' 0 is return in cas of error

    Dim records As cDB_Records
    Dim record As cDB_Record
    Dim Item As cDB_Criterion
    Dim myCriterions As New Collection
    Set records = FetchItems(Table:=myTableName, filter:=filter, PreCondition:=PreCondition, PostCondition:=PostCondition, error:=error)
    
    For Each record In records.records
        Set Item = New cDB_Criterion
        Item.InitializeFromDB_Record record
        myCriterions.Add Item
    Next record
    Set Collection = myCriterions
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


Property Get id_ByRef(Ref As String, Optional error As String = "") As Long
    '' Returns the ID associated with a specific reference from the table.
    '' This function assumes that the primary key in the table is named "id".
    '' If an error occurs (e.g., the reference is not found), the function returns 0.
    '' Parameters:
    ''   - Ref: The reference string used to search for the ID.
    ''   - error: An optional string parameter to capture any error messages.
    '' Returns:
    ''   - Long: The ID associated with the reference, or 0 if not found or in case of an error.

    id_ByRef = FetchId(Table:=myTableName, filter:="Reference = '" & Ref & "'", error:=error)
End Property

Property Get LB_Collection() As Collection
    '' Returns a collection of records from the table where the reference starts with "LB_".
    '' This is typically used to retrieve a subset of records that belong to a specific category or group.
    '' Returns:
    ''   - Collection: A collection of records matching the "LB_%" reference pattern.

    Set LB_Collection = Collection(filter:="Reference LIKE 'LB_%'")
End Property

Property Get OL_Collection() As Collection
    '' Returns a collection of records from the table where the reference starts with "OL_".
    '' This is typically used to retrieve a subset of records that belong to a specific category or group.
    '' Returns:
    ''   - Collection: A collection of records matching the "OL_%" reference pattern.

    Set OL_Collection = Collection(filter:="Reference LIKE 'OL_%'")
End Property

