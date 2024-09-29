VERSION 1.0 CLASS
BEGIN
	MultiUse = -1  'True
END
Attribute VB_Name = "cDB_Casino_Period_Criterion_Value"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

' Region "============================= Generated Code ==============================" 

'' Class : cDB_Casino_Period_Criterion_Value

'' 
'' Code generated from the Class Definition 'Classes.def' at 19.07.2024
'' by cCG_ClassWriter
''

Private myCasino As String
Private myCasino_fk As Long
Private myCriterion_fk As Long
Private myCriterion_Ref As String
Private myid As Long
Private myOperation As String
Private myVal As Double
Private myYear As Long

Property Get Casino () As String
	Casino = myCasino
End Property

Property Let Casino (Casino As String)
	myCasino = Casino
End Property

Property Get Casino_fk () As Long
	Casino_fk = myCasino_fk
End Property

Property Let Casino_fk (Casino_fk As Long)
	myCasino_fk = Casino_fk
End Property

Property Get Criterion_fk () As Long
	Criterion_fk = myCriterion_fk
End Property

Property Let Criterion_fk (Criterion_fk As Long)
	myCriterion_fk = Criterion_fk
End Property

Property Get Criterion_Ref () As String
	Criterion_Ref = myCriterion_Ref
End Property

Property Let Criterion_Ref (Criterion_Ref As String)
	myCriterion_Ref = Criterion_Ref
End Property

Property Get id () As Long
	id = myid
End Property

Property Let id (id As Long)
	myid = id
End Property

Property Get Operation () As String
	Operation = myOperation
End Property

Property Let Operation (Operation As String)
	myOperation = Operation
End Property

Property Get Val () As Double
	Val = myVal
End Property

Property Let Val (Val As Double)
	myVal = Val
End Property

Property Get Year () As Long
	Year = myYear
End Property

Property Let Year (Year As Long)
	myYear = Year
End Property

Property Get record() As cDB_Record
'' Returns the DB-Record
	Dim lRecord As New cDB_Record
	Dim Field As cDB_Field

	Set Field = New cDB_Field
	Field.Initialize Col:="Casino", val:=myCasino
	lRecord.add Field

	Set Field = New cDB_Field
	Field.Initialize Col:="Casino_fk", val:=myCasino_fk
	lRecord.add Field

	Set Field = New cDB_Field
	Field.Initialize Col:="Criterion_fk", val:=myCriterion_fk
	lRecord.add Field

	Set Field = New cDB_Field
	Field.Initialize Col:="Criterion_Ref", val:=myCriterion_Ref
	lRecord.add Field

	Set Field = New cDB_Field
	Field.Initialize Col:="Operation", val:=myOperation
	lRecord.add Field

	Set Field = New cDB_Field
	Field.Initialize Col:="Val", val:=myVal
	lRecord.add Field

	Set Field = New cDB_Field
	Field.Initialize Col:="[Year]", val:=myYear
	lRecord.add Field

	Set record = lRecord
End Property

Sub InitializeFromDB_Record(rec As cDB_Record)
'' initialize the object content from the database record
	On Error Resume Next
	myCasino = rec.column("Casino").Value
	myCasino_fk = rec.column("Casino_fk").Value
	myCriterion_fk = rec.column("Criterion_fk").Value
	myCriterion_Ref = rec.column("Criterion_Ref").Value
	myid = rec.column("id").Value
	myOperation = rec.column("Operation").Value
	myVal = rec.column("Val").Value
	myYear = rec.column("Year").Value
	On Error Goto 0
End Sub


Sub Initialize(Casino As String, Casino_fk As Long, Criterion_fk As Long, Criterion_Ref As String, Operation As String, Val As Double, Year As Long)
'' If you need to initialize with Primary key, add the corresponding field manually
	myCasino = Casino
	myCasino_fk = Casino_fk
	myCriterion_fk = Criterion_fk
	myCriterion_Ref = Criterion_Ref
	myid = id
	myOperation = Operation
	myVal = Val
	myYear = Year
End Sub

' Region "============================= User Code  ==============================" 

