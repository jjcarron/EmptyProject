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
'' Code generated from the Class Definition 'Classes.def' on 22.08.2024
'' by cCG_ClassWriter
''
' End Region

Private myDraw_Casino As Boolean
Private myDraw_Delta As Boolean
Private myDraw_Total As Boolean
Private myFormula As String
Private myid As Long
Private myOperation As String
Private myQueryName As String
Private mySheet_Prefix As String
Private myTitle As String
Private myX_Name As String
Private myY_Name As String

Property Get Draw_Casino () As Boolean
	Draw_Casino = myDraw_Casino
End Property

Property Let Draw_Casino (Draw_Casino As Boolean)
	myDraw_Casino = Draw_Casino
End Property

Property Get Draw_Delta () As Boolean
	Draw_Delta = myDraw_Delta
End Property

Property Let Draw_Delta (Draw_Delta As Boolean)
	myDraw_Delta = Draw_Delta
End Property

Property Get Draw_Total () As Boolean
	Draw_Total = myDraw_Total
End Property

Property Let Draw_Total (Draw_Total As Boolean)
	myDraw_Total = Draw_Total
End Property

Property Get Formula () As String
	Formula = myFormula
End Property

Property Let Formula (Formula As String)
	myFormula = Formula
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

Property Get QueryName () As String
	QueryName = myQueryName
End Property

Property Let QueryName (QueryName As String)
	myQueryName = QueryName
End Property

Property Get Sheet_Prefix () As String
	Sheet_Prefix = mySheet_Prefix
End Property

Property Let Sheet_Prefix (Sheet_Prefix As String)
	mySheet_Prefix = Sheet_Prefix
End Property

Property Get Title () As String
	Title = myTitle
End Property

Property Let Title (Title As String)
	myTitle = Title
End Property

Property Get X_Name () As String
	X_Name = myX_Name
End Property

Property Let X_Name (X_Name As String)
	myX_Name = X_Name
End Property

Property Get Y_Name () As String
	Y_Name = myY_Name
End Property

Property Let Y_Name (Y_Name As String)
	myY_Name = Y_Name
End Property

Property Get record() As cDB_Record
'' Returns the DB-Record
	Dim lRecord As New cDB_Record
	Dim Field As cDB_Field

	Set Field = New cDB_Field
	Field.Initialize Col:="Draw_Casino", val:=myDraw_Casino
	lRecord.add Field

	Set Field = New cDB_Field
	Field.Initialize Col:="Draw_Delta", val:=myDraw_Delta
	lRecord.add Field

	Set Field = New cDB_Field
	Field.Initialize Col:="Draw_Total", val:=myDraw_Total
	lRecord.add Field

	Set Field = New cDB_Field
	Field.Initialize Col:="Formula", val:=myFormula
	lRecord.add Field

	Set Field = New cDB_Field
	Field.Initialize Col:="Operation", val:=myOperation
	lRecord.add Field

	Set Field = New cDB_Field
	Field.Initialize Col:="QueryName", val:=myQueryName
	lRecord.add Field

	Set Field = New cDB_Field
	Field.Initialize Col:="Sheet_Prefix", val:=mySheet_Prefix
	lRecord.add Field

	Set Field = New cDB_Field
	Field.Initialize Col:="Title", val:=myTitle
	lRecord.add Field

	Set Field = New cDB_Field
	Field.Initialize Col:="X_Name", val:=myX_Name
	lRecord.add Field

	Set Field = New cDB_Field
	Field.Initialize Col:="Y_Name", val:=myY_Name
	lRecord.add Field

	Set record = lRecord
End Property

Sub InitializeFromDB_Record(rec As cDB_Record)
'' initialize the object content from the database record
	On Error Resume Next
	myDraw_Casino = rec.column("Draw_Casino").Value
	myDraw_Delta = rec.column("Draw_Delta").Value
	myDraw_Total = rec.column("Draw_Total").Value
	myFormula = rec.column("Formula").Value
	myid = rec.column("id").Value
	myOperation = rec.column("Operation").Value
	myQueryName = rec.column("QueryName").Value
	mySheet_Prefix = rec.column("Sheet_Prefix").Value
	myTitle = rec.column("Title").Value
	myX_Name = rec.column("X_Name").Value
	myY_Name = rec.column("Y_Name").Value
	On Error Goto 0
End Sub


Public Sub Initialize(Draw_Casino As Boolean, Draw_Delta As Boolean, Draw_Total As Boolean, Formula As String, Operation As String, QueryName As String, Sheet_Prefix As String, Title As String, X_Name As String, Y_Name As String)
	'' Initializes class properties with provided values.
	'' Note: Primary key properties are not initialized here.

	myDraw_Casino = Draw_Casino
	myDraw_Delta = Draw_Delta
	myDraw_Total = Draw_Total
	myFormula = Formula
	myOperation = Operation
	myQueryName = QueryName
	mySheet_Prefix = Sheet_Prefix
	myTitle = Title
	myX_Name = X_Name
	myY_Name = Y_Name
End Sub


' Region "============================= User Code  ==============================" 

