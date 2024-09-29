VERSION 1.0 CLASS
BEGIN
	MultiUse = -1  'True
END
Attribute VB_Name = "cDB_Menu"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

' Region "============================= Generated Code =============================="
'' Class : cDB_Menu
''
'' Code generated from the Class Definition 'Classes.def' on 22.08.2024
'' by cCG_ClassWriter
''
' End Region

Private myCallback As String
Private myForm_Ref As String
Private myid As Long
Private myMenu_Ref As String
Private myMenuLevel As Long
Private myMenuOrder As Long
Private myMenuType As String
Private myNewGroup As Boolean
Private myParent_Ref As String
Private myUserLevel As Long

Property Get Callback () As String
	Callback = myCallback
End Property

Property Let Callback (Callback As String)
	myCallback = Callback
End Property

Property Get Form_Ref () As String
	Form_Ref = myForm_Ref
End Property

Property Let Form_Ref (Form_Ref As String)
	myForm_Ref = Form_Ref
End Property

Property Get id () As Long
	id = myid
End Property

Property Let id (id As Long)
	myid = id
End Property

Property Get Menu_Ref () As String
	Menu_Ref = myMenu_Ref
End Property

Property Let Menu_Ref (Menu_Ref As String)
	myMenu_Ref = Menu_Ref
End Property

Property Get MenuLevel () As Long
	MenuLevel = myMenuLevel
End Property

Property Let MenuLevel (MenuLevel As Long)
	myMenuLevel = MenuLevel
End Property

Property Get MenuOrder () As Long
	MenuOrder = myMenuOrder
End Property

Property Let MenuOrder (MenuOrder As Long)
	myMenuOrder = MenuOrder
End Property

Property Get MenuType () As String
	MenuType = myMenuType
End Property

Property Let MenuType (MenuType As String)
	myMenuType = MenuType
End Property

Property Get NewGroup () As Boolean
	NewGroup = myNewGroup
End Property

Property Let NewGroup (NewGroup As Boolean)
	myNewGroup = NewGroup
End Property

Property Get Parent_Ref () As String
	Parent_Ref = myParent_Ref
End Property

Property Let Parent_Ref (Parent_Ref As String)
	myParent_Ref = Parent_Ref
End Property

Property Get UserLevel () As Long
	UserLevel = myUserLevel
End Property

Property Let UserLevel (UserLevel As Long)
	myUserLevel = UserLevel
End Property

Property Get record() As cDB_Record
'' Returns the DB-Record
	Dim lRecord As New cDB_Record
	Dim Field As cDB_Field

	Set Field = New cDB_Field
	Field.Initialize Col:="Callback", val:=myCallback
	lRecord.add Field

	Set Field = New cDB_Field
	Field.Initialize Col:="Form_Ref", val:=myForm_Ref
	lRecord.add Field

	Set Field = New cDB_Field
	Field.Initialize Col:="Menu_Ref", val:=myMenu_Ref
	lRecord.add Field

	Set Field = New cDB_Field
	Field.Initialize Col:="MenuLevel", val:=myMenuLevel
	lRecord.add Field

	Set Field = New cDB_Field
	Field.Initialize Col:="MenuOrder", val:=myMenuOrder
	lRecord.add Field

	Set Field = New cDB_Field
	Field.Initialize Col:="MenuType", val:=myMenuType
	lRecord.add Field

	Set Field = New cDB_Field
	Field.Initialize Col:="NewGroup", val:=myNewGroup
	lRecord.add Field

	Set Field = New cDB_Field
	Field.Initialize Col:="Parent_Ref", val:=myParent_Ref
	lRecord.add Field

	Set Field = New cDB_Field
	Field.Initialize Col:="UserLevel", val:=myUserLevel
	lRecord.add Field

	Set record = lRecord
End Property

Sub InitializeFromDB_Record(rec As cDB_Record)
'' initialize the object content from the database record
	On Error Resume Next
	myCallback = rec.column("Callback").Value
	myForm_Ref = rec.column("Form_Ref").Value
	myid = rec.column("id").Value
	myMenu_Ref = rec.column("Menu_Ref").Value
	myMenuLevel = rec.column("MenuLevel").Value
	myMenuOrder = rec.column("MenuOrder").Value
	myMenuType = rec.column("MenuType").Value
	myNewGroup = rec.column("NewGroup").Value
	myParent_Ref = rec.column("Parent_Ref").Value
	myUserLevel = rec.column("UserLevel").Value
	On Error Goto 0
End Sub


Public Sub Initialize(Callback As String, Form_Ref As String, Menu_Ref As String, MenuLevel As Long, MenuOrder As Long, MenuType As String, NewGroup As Boolean, Parent_Ref As String, UserLevel As Long)
	'' Initializes class properties with provided values.
	'' Note: Primary key properties are not initialized here.

	myCallback = Callback
	myForm_Ref = Form_Ref
	myMenu_Ref = Menu_Ref
	myMenuLevel = MenuLevel
	myMenuOrder = MenuOrder
	myMenuType = MenuType
	myNewGroup = NewGroup
	myParent_Ref = Parent_Ref
	myUserLevel = UserLevel
End Sub


' Region "============================= User Code  ==============================" 

