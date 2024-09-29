VERSION 1.0 CLASS
BEGIN
	MultiUse = -1  'True
END
Attribute VB_Name = "cDB_Casino_Period_Criterion_Values"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

' Region "============================= Generated Code ==============================" 

'' Class : cDB_Casino_Period_Criterion_Values

'' 
'' Code generated from the Class Definition 'Classes.def' at 19.07.2024
'' by cCG_DB_ClassWriter
''

Option Compare Database

'' Generated from Template Class Version 1.0
'' Author Caj
'' Last modification 28.01.2024
''
Const myTableName As String = "tbl_Casino_Period_Criterion_Values"

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

Property Get Item(filter As String) As cDB_Casino_Period_Criterion_Value
    Dim rec As cDB_Record
    Dim Casino_Period_Criterion_Value As New cDB_Casino_Period_Criterion_Value
    Set rec = FetchItem(Table:=myTableName, filter:=filter)
    If Not rec Is Nothing Then
        Casino_Period_Criterion_Value.InitializeFromDB_Record rec
        Set Item = Casino_Period_Criterion_Value
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

Property Get Casino_Period_Criterion_Value(id As Long) As cDB_Casino_Period_Criterion_Value
    Dim rec As cDB_Record
    Dim obj As New cDB_Casino_Period_Criterion_Value
    Set rec = FetchItem(Table:=myTableName, filter:="id = " & id)
    If Not rec Is Nothing Then
        obj.InitializeFromDB_Record rec
        Set Casino_Period_Criterion_Value = obj
    Else
        Set Casino_Period_Criterion_Value = Nothing
    End If
End Property

Property Get Collection(Optional filter As String = "", Optional ByRef PreCondition As String = "", Optional ByRef PostCondition As String = "", Optional error As String = "") As Collection ' of cDB_Casino_Period_Criterion_Value
'' return alls the records of the DB
'' The records shoud be interpreted externally
'' 0 is return in cas of error

    Dim records As cDB_Records
    Dim record As cDB_Record
    Dim Item As cDB_Casino_Period_Criterion_Value
    Dim myCasino_Period_Criterion_Values As New Collection
    Set records = FetchItems(Table:=myTableName, filter:=filter, PreCondition:=PreCondition, PostCondition:=PostCondition, error:=error)
    
    For Each record In records.records
        Set Item = New cDB_Casino_Period_Criterion_Value
        Item.InitializeFromDB_Record record
        myCasino_Period_Criterion_Values.Add Item
    Next record
    Set Collection = myCasino_Period_Criterion_Values
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

