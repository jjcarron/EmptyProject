VERSION 1.0 CLASS
BEGIN
	MultiUse = -1  'True
END
Attribute VB_Name = "cDB_ResourceString"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

' Region "============================= Generated Code =============================="
'' Class : cDB_ResourceString
''
'' Code generated from the Class Definition 'Classes.def' on 22.08.2024
'' by cCG_ClassWriter
''
' End Region

Private myDE As String
Private myEN As String
Private myFR As String
Private myid As Long
Private myIT As String
Private myRef As String

Property Get DE () As String
	DE = myDE
End Property

Property Let DE (DE As String)
	myDE = DE
End Property

Property Get EN () As String
	EN = myEN
End Property

Property Let EN (EN As String)
	myEN = EN
End Property

Property Get FR () As String
	FR = myFR
End Property

Property Let FR (FR As String)
	myFR = FR
End Property

Property Get id () As Long
	id = myid
End Property

Property Let id (id As Long)
	myid = id
End Property

Property Get IT () As String
	IT = myIT
End Property

Property Let IT (IT As String)
	myIT = IT
End Property

Property Get Ref () As String
	Ref = myRef
End Property

Property Let Ref (Ref As String)
	myRef = Ref
End Property

Property Get record() As cDB_Record
'' Returns the DB-Record
	Dim lRecord As New cDB_Record
	Dim Field As cDB_Field

	Set Field = New cDB_Field
	Field.Initialize Col:="DE", val:=myDE
	lRecord.add Field

	Set Field = New cDB_Field
	Field.Initialize Col:="EN", val:=myEN
	lRecord.add Field

	Set Field = New cDB_Field
	Field.Initialize Col:="FR", val:=myFR
	lRecord.add Field

	Set Field = New cDB_Field
	Field.Initialize Col:="IT", val:=myIT
	lRecord.add Field

	Set Field = New cDB_Field
	Field.Initialize Col:="Ref", val:=myRef
	lRecord.add Field

	Set record = lRecord
End Property

Sub InitializeFromDB_Record(rec As cDB_Record)
'' initialize the object content from the database record
	On Error Resume Next
	myDE = rec.column("DE").Value
	myEN = rec.column("EN").Value
	myFR = rec.column("FR").Value
	myid = rec.column("id").Value
	myIT = rec.column("IT").Value
	myRef = rec.column("Ref").Value
	On Error Goto 0
End Sub


Public Sub Initialize(DE As String, EN As String, FR As String, IT As String, Ref As String)
	'' Initializes class properties with provided values.
	'' Note: Primary key properties are not initialized here.

	myDE = DE
	myEN = EN
	myFR = FR
	myIT = IT
	myRef = Ref
End Sub


' Region "============================= User Code  ==============================" 

