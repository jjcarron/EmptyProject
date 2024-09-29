VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "cDB_XXX"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'' Class : cDB_XXX
''
'' First version created automatically on 26.01.2024
'' by cCG_ClassWriter

Private myid As Long
Private myIntValue As Long
Private myStrValue As String

Property Get id() As Long
    '' Returns the ID of the object.
    id = myid
End Property

Property Let id(id As Long)
    '' Sets the ID of the object.
    '' Parameters:
    ''   - id: The ID value to set.
    myid = id
End Property

Property Get IntValue() As Long
    '' Returns the integer value stored in the object.
    IntValue = myIntValue
End Property

Property Let IntValue(IntValue As Long)
    '' Sets the integer value in the object.
    '' Parameters:
    ''   - IntValue: The integer value to set.
    myIntValue = IntValue
End Property

Property Get StrValue() As String
    '' Returns the string value stored in the object.
    StrValue = myStrValue
End Property

Property Let StrValue(StrValue As String)
    '' Sets the string value in the object.
    '' Parameters:
    ''   - StrValue: The string value to set.
    myStrValue = StrValue
End Property

Property Get record() As cDB_Record
    '' Returns the database record representation of the object.
    '' The record includes all fields (IntValue, StrValue) and their values.

    Dim lRecord As New cDB_Record
    Dim Field As cDB_Field

    Set Field = New cDB_Field
    Field.Initialize Col:="IntValue", Val:=myIntValue
    lRecord.Add Field

    Set Field = New cDB_Field
    Field.Initialize Col:="StrValue", Val:=myStrValue
    lRecord.Add Field

    Set record = lRecord
End Property

Sub InitializeFromDB_Record(rec As cDB_Record)
    '' Initializes the object with data from a database record.
    '' Parameters:
    ''   - rec: The database record containing the values to initialize the object with.
    
    On Error Resume Next
    myid = rec.column("id").value
    myIntValue = rec.column("IntValue").value
    myStrValue = rec.column("StrValue").value
    On Error GoTo 0
End Sub

Sub Initialize(IntValue As Long, StrValue As String)
    '' Initializes the object with specified integer and string values.
    '' If you need to initialize with a primary key, add the corresponding field manually.
    '' Parameters:
    ''   - IntValue: The integer value to initialize with.
    ''   - StrValue: The string value to initialize with.
    
    myIntValue = IntValue
    myStrValue = StrValue
End Sub

