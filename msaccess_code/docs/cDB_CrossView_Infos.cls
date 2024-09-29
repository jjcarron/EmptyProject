VERSION 1.0 CLASS
BEGIN
	MultiUse = -1  'True
END
Attribute VB_Name = "cDB_Crossview_Infos"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

' Region "============================= Generated Code ==============================" 

'' Class : cDB_Crossview_Infos

'' 
'' Code generated from the Class Definition 'Classes.def' at 15.08.2024
'' by cCG_DB_ClassWriter
''

Option Compare Database

'' Generated from Template Class Version 1.0
'' Author Caj
'' Last modification 28.01.2024
''
Const myTableName As String = "Crossview_Infos"

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

Property Get Item(filter As String) As cDB_Crossview_Info
    Dim rec As cDB_Record
    Dim Crossview_Info As New cDB_Crossview_Info
    Set rec = FetchItem(Table:=myTableName, filter:=filter)
    If Not rec Is Nothing Then
        Crossview_Info.InitializeFromDB_Record rec
        Set Item = Crossview_Info
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

Property Get Crossview_Info(id As Long) As cDB_Crossview_Info
    Dim rec As cDB_Record
    Dim obj As New cDB_Crossview_Info
    Set rec = FetchItem(Table:=myTableName, filter:="id = " & id)
    If Not rec Is Nothing Then
        obj.InitializeFromDB_Record rec
        Set Crossview_Info = obj
    Else
        Set Crossview_Info = Nothing
    End If
End Property

Property Get Collection(Optional filter As String = "", Optional ByRef PreCondition As String = "", Optional ByRef PostCondition As String = "", Optional error As String = "") As Collection ' of cDB_Crossview_Info
'' return alls the records of the DB
'' The records shoud be interpreted externally
'' 0 is return in cas of error

    Dim records As cDB_Records
    Dim record As cDB_Record
    Dim Item As cDB_Crossview_Info
    Dim myCrossview_Infos As New Collection
    Set records = FetchItems(Table:=myTableName, filter:=filter, PreCondition:=PreCondition, PostCondition:=PostCondition, error:=error)
    
    For Each record In records.records
        Set Item = New cDB_Crossview_Info
        Item.InitializeFromDB_Record record
        myCrossview_Infos.Add Item
    Next record
    Set Collection = myCrossview_Infos
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

