VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "cDB_Casino"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
' Region "============================= Generated Code =============================="

'' Class : cDB_Casino

''
'' Code generated from the Class Definition 'Classes.def' at 30.05.2024
'' by cCG_ClassWriter
''

Private myDZS_ID As Long
Private myid As Long
Private myName As String
Private myOnline As Boolean

Property Get DZS_ID() As Long
    DZS_ID = myDZS_ID
End Property

Property Let DZS_ID(DZS_ID As Long)
    myDZS_ID = DZS_ID
End Property

Property Get id() As Long
    id = myid
End Property

Property Let id(id As Long)
    myid = id
End Property

Property Get Name() As String
    Name = myName
End Property

Property Let Name(Name As String)
    myName = Name
End Property

Property Get Online() As Boolean
    Online = myOnline
End Property

Property Let Online(Online As Boolean)
    myOnline = Online
End Property

Property Get record() As cDB_Record
'' Returns the DB-Record
    Dim lRecord As New cDB_Record
    Dim Field As cDB_Field

    Set Field = New cDB_Field
    Field.Initialize Col:="DZS_ID", Val:=myDZS_ID
    lRecord.Add Field

    Set Field = New cDB_Field
    Field.Initialize Col:="Name", Val:=myName
    lRecord.Add Field

    Set Field = New cDB_Field
    Field.Initialize Col:="Online", Val:=myOnline
    lRecord.Add Field

    Set record = lRecord
End Property

Sub InitializeFromDB_Record(rec As cDB_Record)
'' initialize the object content from the database record
    On Error Resume Next
    myDZS_ID = rec.column("DZS_ID").value
    myid = rec.column("id").value
    myName = rec.column("Name").value
    myOnline = rec.column("Online").value
    On Error GoTo 0
End Sub


Sub Initialize(DZS_ID As Long, Name As String, Online As Boolean)
'' If you need to initialize with Primary key, add the corresponding field manually
    myDZS_ID = DZS_ID
    myid = id
    myName = Name
    myOnline = Online
End Sub

' Region "============================= User Code  =============================="

