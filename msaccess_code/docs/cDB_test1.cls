VERSION 1.0 CLASS
BEGIN
	MultiUse = -1  'True
END
Attribute VB_Name = "cDB_test1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

' Region "============================= Generated Code =============================="
'' Class : cDB_test1
''
'' Code generated from the Class Definition 'Classes.def' on 22.08.2024
'' by cCG_ClassWriter
''
' End Region

Private myp1 As String
Private myp2 As collection
Private myp3 As ArrayList
Private myp4 As Long

Property Get p1 () As String
	p1 = myp1
End Property

Property Let p1 (p1 As String)
	myp1 = p1
End Property

Property Get p2 () As collection
	 Set p2 = myp2
End Property

Property Set p2 (p2 As collection)
	Set myp2 = p2
End Property

Property Get p3 () As ArrayList
	 Set p3 = myp3
End Property

Property Set p3 (p3 As ArrayList)
	Set myp3 = p3
End Property

Property Get p4 () As Long
	p4 = myp4
End Property

Property Let p4 (p4 As Long)
	myp4 = p4
End Property

Public Sub Initialize(p1 As String, p2 As collection, p3 As ArrayList, p4 As Long)
	'' Initializes class properties with provided values.
	'' Note: Primary key properties are not initialized here.

	myp1 = p1
	Set myp2 = p2
	Set myp3 = p3
	myp4 = p4
End Sub


' Region "============================= User Code  =============================="
' End Region

