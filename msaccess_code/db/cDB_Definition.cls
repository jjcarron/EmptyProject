VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "cDB_Definition"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'' Class : cDB_Definition
''
'' This class provides the cDB_Definition object used by cDB_Definitions and
'' the access properties to its contents. It encapsulates a single definition,
'' storing the name and its associated value (definition).

Option Compare Database

Private myName As String
Private myDefinition As String

Sub Initialize(Name As String, definition As String)
    '' Initializes the cDB_Definition object with a name and its corresponding definition.
    '' Parameters:
    ''   - Name: The name of the definition.
    ''   - definition: The value or content of the definition.
    myName = Name
    myDefinition = definition
End Sub

Property Get definition() As String
    '' Returns the value or content of the definition.
    definition = myDefinition
End Property

Property Get Name() As String
    '' Returns the name of the definition.
    Name = myName
End Property

