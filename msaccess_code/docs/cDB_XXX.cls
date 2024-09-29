VERSION 1.0 CLASS
BEGIN
	MultiUse = -1  'True
END
Attribute VB_Name = "cDB_XXX"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

' Region "============================= Generated Code =============================="
'' Class : cDB_XXX
''
'' Code generated from the Class Definition 'Classes.def' on 22.08.2024
'' by cCG_ClassWriter
''
' End Region

Private myid As Long
Private myIntValue As Long
Private myStrValue As String

Property Get id () As Long
	id = myid
End Property

Property Let id (id As Long)
	myid = id
End Property

Property Get IntValue () As Long
	IntValue = myIntValue
End Property

Property Let IntValue (IntValue As Long)
	myIntValue = IntValue
End Property

Property Get StrValue () As String
	StrValue = myStrValue
End Property

Property Let StrValue (StrValue As String)
	myStrValue = StrValue
End Property

Property Get record() As cDB_Record
'' Returns the DB-Record
	Dim lRecord As New cDB_Record
	Dim Field As cDB_Field

	Set Field = New cDB_Field
	Field.Initialize Col:="IntValue", val:=myIntValue
	lRecord.add Field

	Set Field = New cDB_Field
	Field.Initialize Col:="StrValue", val:=myStrValue
	lRecord.add Field

	Set record = lRecord
End Property

Sub InitializeFromDB_Record(rec As cDB_Record)
'' initialize the object content from the database record
	On Error Resume Next
	myid = rec.column("id").Value
	myIntValue = rec.column("IntValue").Value
	myStrValue = rec.column("StrValue").Value
	On Error Goto 0
End Sub


Public Sub Initialize(IntValue As Long, StrValue As String)
	'' Initializes class properties with provided values.
	'' Note: Primary key properties are not initialized here.

	myIntValue = IntValue
	myStrValue = StrValue
End Sub


' Region "============================= User Code  ==============================" 

