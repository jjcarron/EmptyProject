VERSION 1.0 CLASS
BEGIN
	MultiUse = -1  'True
END
Attribute VB_Name = "cDB_SOK_File"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

' Region "============================= Generated Code ==============================" 

'' Class : cDB_SOK_File

'' 
'' Code generated from the Class Definition 'Classes.def' at 19.07.2024
'' by cCG_ClassWriter
''

Private myFileSize As Long
Private myid As Long
Private myisLoaded As Boolean
Private myLastChange As Date
Private myName As String
Private myPath As String
Private myYear As Long

Property Get FileSize () As Long
	FileSize = myFileSize
End Property

Property Let FileSize (FileSize As Long)
	myFileSize = FileSize
End Property

Property Get id () As Long
	id = myid
End Property

Property Let id (id As Long)
	myid = id
End Property

Property Get isLoaded () As Boolean
	isLoaded = myisLoaded
End Property

Property Let isLoaded (isLoaded As Boolean)
	myisLoaded = isLoaded
End Property

Property Get LastChange () As Date
	LastChange = myLastChange
End Property

Property Let LastChange (LastChange As Date)
	myLastChange = LastChange
End Property

Property Get Name () As String
	Name = myName
End Property

Property Let Name (Name As String)
	myName = Name
End Property

Property Get Path () As String
	Path = myPath
End Property

Property Let Path (Path As String)
	myPath = Path
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
	Field.Initialize Col:="FileSize", val:=myFileSize
	lRecord.add Field

	Set Field = New cDB_Field
	Field.Initialize Col:="isLoaded", val:=myisLoaded
	lRecord.add Field

	Set Field = New cDB_Field
	Field.Initialize Col:="LastChange", val:=myLastChange
	lRecord.add Field

	Set Field = New cDB_Field
	Field.Initialize Col:="Name", val:=myName
	lRecord.add Field

	Set Field = New cDB_Field
	Field.Initialize Col:="Path", val:=myPath
	lRecord.add Field

	Set Field = New cDB_Field
	Field.Initialize Col:="[Year]", val:=myYear
	lRecord.add Field

	Set record = lRecord
End Property

Sub InitializeFromDB_Record(rec As cDB_Record)
'' initialize the object content from the database record
	On Error Resume Next
	myFileSize = rec.column("FileSize").Value
	myid = rec.column("id").Value
	myisLoaded = rec.column("isLoaded").Value
	myLastChange = rec.column("LastChange").Value
	myName = rec.column("Name").Value
	myPath = rec.column("Path").Value
	myYear = rec.column("Year").Value
	On Error Goto 0
End Sub


Sub Initialize(FileSize As Long, isLoaded As Boolean, LastChange As Date, Name As String, Path As String, Year As Long)
'' If you need to initialize with Primary key, add the corresponding field manually
	myFileSize = FileSize
	myid = id
	myisLoaded = isLoaded
	myLastChange = LastChange
	myName = Name
	myPath = Path
	myYear = Year
End Sub

' Region "============================= User Code  ==============================" 

