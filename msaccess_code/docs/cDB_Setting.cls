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
'' Code generated from the Class Definition 'Classes.def' on 22.08.2024
'' by cCG_ClassWriter
''
' End Region

Private myid As Long
Private myName As String
Private myPBoolean As Boolean
Private myPValue As String

Property Get id () As Long
	id = myid
End Property

Property Let id (id As Long)
	myid = id
End Property

Property Get Name () As String
	Name = myName
End Property

Property Let Name (Name As String)
	myName = Name
End Property

Property Get PBoolean () As Boolean
	PBoolean = myPBoolean
End Property

Property Let PBoolean (PBoolean As Boolean)
	myPBoolean = PBoolean
End Property

Property Get PValue () As String
	PValue = myPValue
End Property

Property Let PValue (PValue As String)
	myPValue = PValue
End Property

Property Get record() As cDB_Record
'' Returns the DB-Record
	Dim lRecord As New cDB_Record
	Dim Field As cDB_Field

	Set Field = New cDB_Field
	Field.Initialize Col:="Name", val:=myName
	lRecord.add Field

	Set Field = New cDB_Field
	Field.Initialize Col:="PBoolean", val:=myPBoolean
	lRecord.add Field

	Set Field = New cDB_Field
	Field.Initialize Col:="PValue", val:=myPValue
	lRecord.add Field

	Set record = lRecord
End Property

Sub InitializeFromDB_Record(rec As cDB_Record)
'' initialize the object content from the database record
	On Error Resume Next
	myid = rec.column("id").Value
	myName = rec.column("Name").Value
	myPBoolean = rec.column("PBoolean").Value
	myPValue = rec.column("PValue").Value
	On Error Goto 0
End Sub


Public Sub Initialize(Name As String, PBoolean As Boolean, PValue As String)
	'' Initializes class properties with provided values.
	'' Note: Primary key properties are not initialized here.

	myName = Name
	myPBoolean = PBoolean
	myPValue = PValue
End Sub


' Region "============================= User Code  ==============================" 

