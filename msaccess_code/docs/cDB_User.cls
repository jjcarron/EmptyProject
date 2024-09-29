VERSION 1.0 CLASS
BEGIN
	MultiUse = -1  'True
END
Attribute VB_Name = "cDB_User"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

' Region "============================= Generated Code =============================="
'' Class : cDB_User
''
'' Code generated from the Class Definition 'Classes.def' on 22.08.2024
'' by cCG_ClassWriter
''
' End Region

Private myFirst_Name As String
Private myid As Long
Private myisAdmin As Boolean
Private myisLocked As Boolean
Private myName As String
Private myPasswd As String
Private myPrefLanguage As String
Private myUsername As String

Property Get First_Name () As String
	First_Name = myFirst_Name
End Property

Property Let First_Name (First_Name As String)
	myFirst_Name = First_Name
End Property

Property Get id () As Long
	id = myid
End Property

Property Let id (id As Long)
	myid = id
End Property

Property Get isAdmin () As Boolean
	isAdmin = myisAdmin
End Property

Property Let isAdmin (isAdmin As Boolean)
	myisAdmin = isAdmin
End Property

Property Get isLocked () As Boolean
	isLocked = myisLocked
End Property

Property Let isLocked (isLocked As Boolean)
	myisLocked = isLocked
End Property

Property Get Name () As String
	Name = myName
End Property

Property Let Name (Name As String)
	myName = Name
End Property

Property Get Passwd () As String
	Passwd = myPasswd
End Property

Property Let Passwd (Passwd As String)
	myPasswd = Passwd
End Property

Property Get PrefLanguage () As String
	PrefLanguage = myPrefLanguage
End Property

Property Let PrefLanguage (PrefLanguage As String)
	myPrefLanguage = PrefLanguage
End Property

Property Get Username () As String
	Username = myUsername
End Property

Property Let Username (Username As String)
	myUsername = Username
End Property

Property Get record() As cDB_Record
'' Returns the DB-Record
	Dim lRecord As New cDB_Record
	Dim Field As cDB_Field

	Set Field = New cDB_Field
	Field.Initialize Col:="First_Name", val:=myFirst_Name
	lRecord.add Field

	Set Field = New cDB_Field
	Field.Initialize Col:="isAdmin", val:=myisAdmin
	lRecord.add Field

	Set Field = New cDB_Field
	Field.Initialize Col:="isLocked", val:=myisLocked
	lRecord.add Field

	Set Field = New cDB_Field
	Field.Initialize Col:="Name", val:=myName
	lRecord.add Field

	Set Field = New cDB_Field
	Field.Initialize Col:="Passwd", val:=myPasswd
	lRecord.add Field

	Set Field = New cDB_Field
	Field.Initialize Col:="PrefLanguage", val:=myPrefLanguage
	lRecord.add Field

	Set Field = New cDB_Field
	Field.Initialize Col:="Username", val:=myUsername
	lRecord.add Field

	Set record = lRecord
End Property

Sub InitializeFromDB_Record(rec As cDB_Record)
'' initialize the object content from the database record
	On Error Resume Next
	myFirst_Name = rec.column("First_Name").Value
	myid = rec.column("id").Value
	myisAdmin = rec.column("isAdmin").Value
	myisLocked = rec.column("isLocked").Value
	myName = rec.column("Name").Value
	myPasswd = rec.column("Passwd").Value
	myPrefLanguage = rec.column("PrefLanguage").Value
	myUsername = rec.column("Username").Value
	On Error Goto 0
End Sub


Public Sub Initialize(First_Name As String, isAdmin As Boolean, isLocked As Boolean, Name As String, Passwd As String, PrefLanguage As String, Username As String)
	'' Initializes class properties with provided values.
	'' Note: Primary key properties are not initialized here.

	myFirst_Name = First_Name
	myisAdmin = isAdmin
	myisLocked = isLocked
	myName = Name
	myPasswd = Passwd
	myPrefLanguage = PrefLanguage
	myUsername = Username
End Sub


' Region "============================= User Code  ==============================" 

