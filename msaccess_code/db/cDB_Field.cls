VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "cDB_Field"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'' Class : cDB_Field
''
'' This class manages abstract single records fields
''

Option Compare Database

Private myColumn As String
Private myValue As Variant

Sub Initialize(Col As String, Val As Variant)
    myColumn = Col
    myValue = Val
End Sub

Property Get column() As String
    column = myColumn
End Property

Property Get value() As Variant
    value = myValue
End Property

Property Get IdentiqueAs(rec As cDB_Field) As Boolean
    IdentiqueAs = (rec.column = myColumn) And (rec.value = myValue)
End Property
