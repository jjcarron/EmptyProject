VERSION 1.0 CLASS
BEGIN
	MultiUse = -1  'True
END
Attribute VB_Name = "cDB_Criterion"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

' Region "============================= Generated Code =============================="
'' Class : cDB_Criterion
''
'' Code generated from the Class Definition 'Classes.def' on 22.08.2024
'' by cCG_ClassWriter
''
' End Region

Private myAbbreviation As String
Private myComment As String
Private myid As Long
Private myLegal_Basis As String
Private myReference As String

Property Get Abbreviation () As String
	Abbreviation = myAbbreviation
End Property

Property Let Abbreviation (Abbreviation As String)
	myAbbreviation = Abbreviation
End Property

Property Get Comment () As String
	Comment = myComment
End Property

Property Let Comment (Comment As String)
	myComment = Comment
End Property

Property Get id () As Long
	id = myid
End Property

Property Let id (id As Long)
	myid = id
End Property

Property Get Legal_Basis () As String
	Legal_Basis = myLegal_Basis
End Property

Property Let Legal_Basis (Legal_Basis As String)
	myLegal_Basis = Legal_Basis
End Property

Property Get Reference () As String
	Reference = myReference
End Property

Property Let Reference (Reference As String)
	myReference = Reference
End Property

Property Get record() As cDB_Record
'' Returns the DB-Record
	Dim lRecord As New cDB_Record
	Dim Field As cDB_Field

	Set Field = New cDB_Field
	Field.Initialize Col:="Abbreviation", val:=myAbbreviation
	lRecord.add Field

	Set Field = New cDB_Field
	Field.Initialize Col:="Comment", val:=myComment
	lRecord.add Field

	Set Field = New cDB_Field
	Field.Initialize Col:="Legal_Basis", val:=myLegal_Basis
	lRecord.add Field

	Set Field = New cDB_Field
	Field.Initialize Col:="Reference", val:=myReference
	lRecord.add Field

	Set record = lRecord
End Property

Sub InitializeFromDB_Record(rec As cDB_Record)
'' initialize the object content from the database record
	On Error Resume Next
	myAbbreviation = rec.column("Abbreviation").Value
	myComment = rec.column("Comment").Value
	myid = rec.column("id").Value
	myLegal_Basis = rec.column("Legal_Basis").Value
	myReference = rec.column("Reference").Value
	On Error Goto 0
End Sub


Public Sub Initialize(Abbreviation As String, Comment As String, Legal_Basis As String, Reference As String)
	'' Initializes class properties with provided values.
	'' Note: Primary key properties are not initialized here.

	myAbbreviation = Abbreviation
	myComment = Comment
	myLegal_Basis = Legal_Basis
	myReference = Reference
End Sub


' Region "============================= User Code  ==============================" 

