VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "cDB_CrossviewInfo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

' Region "============================= Generated Code =============================="

'' Class : cDB_CrossviewInfo

''
'' Code generated from the Class Definition 'Classes.def' at 01.06.2024
'' by cCG_ClassWriter
''

Private myOperation As String
Private myid As Long
Private myQueryName As String
Private mySheet_Prefix As String
Private myTitle As String
Private myX_Name As String
Private myY_Name As String

Property Get Operation() As String
    Operation = myOperation
End Property

Property Let Operation(Operation As String)
    myOperation = Operation
End Property

Property Get id() As Long
    id = myid
End Property

Property Let id(id As Long)
    myid = id
End Property

Property Get QueryName() As String
    QueryName = myQueryName
End Property

Property Let QueryName(QueryName As String)
    myQueryName = QueryName
End Property

Property Get Sheet_Prefix() As String
    Sheet_Prefix = mySheet_Prefix
End Property

Property Let Sheet_Prefix(Sheet_Prefix As String)
    mySheet_Prefix = Sheet_Prefix
End Property

Property Get Title() As String
    Title = myTitle
End Property

Property Let Title(Title As String)
    myTitle = Title
End Property

Property Get X_Name() As String
    X_Name = myX_Name
End Property

Property Let X_Name(X_Name As String)
    myX_Name = X_Name
End Property

Property Get Y_Name() As String
    Y_Name = myY_Name
End Property

Property Let Y_Name(Y_Name As String)
    myY_Name = Y_Name
End Property

Property Get record() As cDB_Record
'' Returns the DB-Record
    Dim lRecord As New cDB_Record
    Dim Field As cDB_Field

    Set Field = New cDB_Field
    Field.Initialize Col:="Operation", Val:=myOperation
    lRecord.Add Field

    Set Field = New cDB_Field
    Field.Initialize Col:="QueryName", Val:=myQueryName
    lRecord.Add Field

    Set Field = New cDB_Field
    Field.Initialize Col:="Sheet_Prefix", Val:=mySheet_Prefix
    lRecord.Add Field

    Set Field = New cDB_Field
    Field.Initialize Col:="Title", Val:=myTitle
    lRecord.Add Field

    Set Field = New cDB_Field
    Field.Initialize Col:="X_Name", Val:=myX_Name
    lRecord.Add Field

    Set Field = New cDB_Field
    Field.Initialize Col:="Y_Name", Val:=myY_Name
    lRecord.Add Field

    Set record = lRecord
End Property

Sub InitializeFromDB_Record(rec As cDB_Record)
'' initialize the object content from the database record
    On Error Resume Next
    myOperation = rec.column("Operation").value
    myid = rec.column("id").value
    myQueryName = rec.column("QueryName").value
    mySheet_Prefix = rec.column("Sheet_Prefix").value
    myTitle = rec.column("Title").value
    myX_Name = rec.column("X_Name").value
    myY_Name = rec.column("Y_Name").value
    On Error GoTo 0
End Sub


Sub Initialize(Operation As String, QueryName As String, Sheet_Prefix As String, Title As String, X_Name As String, Y_Name As String)
'' If you need to initialize with Primary key, add the corresponding field manually
    myOperation = Operation
    myid = id
    myQueryName = QueryName
    mySheet_Prefix = Sheet_Prefix
    myTitle = Title
    myX_Name = X_Name
    myY_Name = Y_Name
End Sub

' Region "============================= User Code  =============================="


