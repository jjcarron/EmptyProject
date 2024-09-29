VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "cDB_Period"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

' Region "============================= Generated Code =============================="

'' Class : cDB_Period

''
'' Code generated from the Class Definition 'Classes.def' at 23.05.2024
'' by cCG_ClassWriter
''

Private myid As Long
Private myYear As Long

Property Get id() As Long
        id = myid
End Property

Property Let id(id As Long)
        myid = id
End Property

Property Get Year() As Long
        Year = myYear
End Property

Property Let Year(Year As Long)
        myYear = Year
End Property

Property Get record() As cDB_Record
'' Returns the DB-Record
        Dim lRecord As New cDB_Record
        Dim Field As cDB_Field

        Set Field = New cDB_Field
        Field.Initialize Col:="[Year]", Val:=myYear
        lRecord.Add Field

        Set record = lRecord
End Property

Sub InitializeFromDB_Record(rec As cDB_Record)
'' initialize the object content from the database record
        On Error Resume Next
        myid = rec.column("id").Value
        myYear = rec.column("Year").Value
        On Error GoTo 0
End Sub


Sub Initialize(Year As Long)
'' If you need to initialize with Primary key, add the corresponding field manually
        myid = id
        myYear = Year
End Sub

' Region "============================= User Code  =============================="

