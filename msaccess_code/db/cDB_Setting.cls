VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "cDB_Setting"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

' Region "============================= Generated Code =============================="

'' Class : cDB_Setting

''
'' Code generated from the Class Definition 'Classes.def' at 28.01.2024
'' by cCG_ClassWriter
''

Private myid As Long
Private myName As String
Private myPValue As String
Private myPBoolean As Boolean

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

Property Get PValue() As String
        PValue = myPValue
End Property

Property Let PValue(PValue As String)
        myPValue = PValue
End Property

Property Get PBoolean() As Boolean
        PBoolean = myPBoolean
End Property

Property Let PBoolean(PBoolean As Boolean)
        myPBoolean = PBoolean
End Property

Property Get record() As cDB_Record
'' Returns the DB-Record
        Dim lRecord As New cDB_Record
        Dim Field As cDB_Field

        Set Field = New cDB_Field
        Field.Initialize Col:="Name", Val:=myName
        lRecord.Add Field

        Set Field = New cDB_Field
        Field.Initialize Col:="PValue", Val:=myPValue
        lRecord.Add Field
        
        Set Field = New cDB_Field
        Field.Initialize Col:="PBoolean", Val:=myPBoolean
        lRecord.Add Field

        Set record = lRecord
End Property

Sub InitializeFromDB_Record(rec As cDB_Record)
'' initialize the object content from the database record
        On Error Resume Next
        myid = rec.column("id").value
        myName = rec.column("Name").value
        myPValue = rec.column("PValue").value
        myPBoolean = rec.column("PBoolean").value
        On Error GoTo 0
End Sub


Sub Initialize(Name As String, PValue As String, PBoolean As Boolean)
'' If you need to initialize with Primary key, add the corresponding field manually
        myid = id
        myName = Name
        myPValue = PValue
        myPBoolean = PBoolean
End Sub

' Region "============================= User Code  =============================="

