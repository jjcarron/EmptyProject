VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "cDB_CriterionValues"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

' Region "============================= Generated Code =============================="

'' Class : cDB_criterion_values

''
'' Code generated from the Class Definition 'Classes.def' at 26.05.2024
'' by cCG_DB_ClassWriter
''

Option Compare Database

'' Generated from Template Class Version 1.0
'' Author Caj
'' Last modification 28.01.2024
''
Const myTableName As String = "CriterionValues"

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

Property Get Item(filter As String) As cDB_CriterionValue
    Dim rec As cDB_Record
    Dim Casino_Period_Criterion_Value As New cDB_CriterionValue
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

Property Get Casino_Period_Criterion_Value(id As Long) As cDB_CriterionValue
    Dim rec As cDB_Record
    Dim obj As New cDB_CriterionValue
    Set rec = FetchItem(Table:=myTableName, filter:="id = " & id)
    If Not rec Is Nothing Then
        obj.InitializeFromDB_Record rec
        Set Casino_Period_Criterion_Value = obj
    Else
        Set Casino_Period_Criterion_Value = Nothing
    End If
End Property

Property Get Collection(Optional filter As String = "", Optional ByRef PreCondition As String = "", Optional ByRef PostCondition As String = "", Optional error As String = "") As Collection ' of cDB_CriterionValue
'' return alls the records of the DB
'' The records shoud be interpreted externally
'' 0 is return in cas of error

    Dim records As cDB_Records
    Dim record As cDB_Record
    Dim Item As cDB_CriterionValue
    Dim myCasino_Period_Criterion_Values As New Collection
    Set records = FetchItems(Table:=myTableName, filter:=filter, PreCondition:=PreCondition, PostCondition:=PostCondition, error:=error)
    
    For Each record In records.records
        Set Item = New cDB_CriterionValue
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

Sub Add(value As Double, Criterion_Ref As String, Casino As String, Year As Long, Optional ByRef error As String, Optional Operation As String = "LB")
    '' Adds or updates a record in the "CriterionValues" table with the provided details.
    '' Parameters:
    ''   - Value: The numerical value to be stored.
    ''   - Criterion_Ref: A reference to the criterion associated with this value.
    ''   - Casino: The name of the casino associated with this value.
    ''   - Year: The year associated with this value.
    ''   - error: An optional parameter to capture error messages.
    ''   - Operation: An optional parameter specifying the operation type (default is "LB").
    '' The function tries to update an existing record or create a new one if it doesn't exist.

    Dim inst As New cDB_Instruction
    Dim i As Integer
    Dim CPC_Value As New cDB_CriterionValue

    '' Initialize the cDB_CriterionValue object with the provided values.
    CPC_Value.Initialize _
        Val:=value, _
        Criterion_fk:=criteria.id_ByRef(Criterion_Ref), _
        Casino_fk:=casinos.id_ByName(Casino), _
        Year:=Year, _
        Operation:=Operation, _
        Criterion_Ref:=Criterion_Ref, _
        Casino:=Casino

    On Error GoTo errHandler
    With inst
        '' Initialize the cDB_Instruction object for updating or creating a row.
        .Initialize action:=eUpdateOrCreateRow, Table:="CriterionValues", record:=CPC_Value.record, _
            Where:="Criterion_fk = " & CPC_Value.Criterion_fk & " AND [Year] = " & Year & " AND Casino_fk=" & CPC_Value.Casino_fk & " AND Operation ='" & Operation & "'"
        '' Execute the instruction.
        .execute
    End With
    Exit Sub

errHandler:
    '' Handle any errors that occur during the execution.
    log.LogEvent inst.cmdText & " cannot be executed. Check the tablename and the columnnames", eError
    error = "Execution error in Add function"
End Sub


