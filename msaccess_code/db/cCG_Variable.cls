VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "cCG_Variable"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Compare Database

'' Class : cCG_Variable
''
'' This class implements the management of variables of VBA classes in the code generator.
'' It provides properties and methods to generate code for variable declaration,
'' initialization, and property methods (Get/Set) based on the variable's type.

Private myName As String
Private myType As String

Property Get Name() As String
    '' Returns the name of the variable.
    Name = myName
End Property

Property Get isObject() As Boolean
    '' Determines if the variable is an object or a primitive data type.
    '' Returns True if the variable is an object, otherwise False.
    Select Case myType
    Case "String", "Integer", "Long", "Double", "Byte", "Decimal", "Date", "Currency", "Variant", "Boolean"
        isObject = False
    Case Else
        isObject = True
    End Select
End Property

Property Get isPrimaryKey() As Boolean
    '' Determines if the variable is a primary key.
    '' Returns False since this is not a database object.
    isPrimaryKey = False
End Property

Property Get Declaration()
    '' Returns the declaration string for the variable.
    '' Example: "Private myVariableName As VariableType"
    Declaration = "Private my" & myName & " As " & myType
End Property

Property Get InitString() As String
    '' Returns the initialization string for the variable in function signatures.
    '' Example: "VariableName As VariableType"
    InitString = myName & " As " & myType
End Property

Property Get InitStatement() As String
    '' Returns the initialization statement for the variable.
    '' Example: "Set myVariableName = VariableName" (if it's an object)
    '' or "myVariableName = VariableName" (if it's a primitive type)
    Dim s As String
    If isObject Then s = s & "Set "
    s = s & "my" & myName & " = " & myName
    InitStatement = s
End Property

Property Get SetStatement() As String
    '' Generates the Set property method for the variable.
    '' Example:
    '' Property Set VariableName (VariableName As VariableType)
    ''    Set myVariableName = VariableName
    '' End Property
    Dim s As String
    Dim cmd As String
    If isObject Then
        cmd = "Set"
    Else
        cmd = "Let"
    End If
    s = vbCrLf & "Property " & cmd & " " & myName & " (" & myName & " As " & myType & ")" & vbCrLf & vbTab
    s = s & InitStatement
    s = s & vbCrLf & "End Property"
    SetStatement = s
End Property

Property Get GetStatement() As String
    '' Generates the Get property method for the variable.
    '' Example:
    '' Property Get VariableName () As VariableType
    ''    Set/Get VariableName = myVariableName
    '' End Property
    Dim s As String
    s = vbCrLf & "Property Get " & myName & " () As " & myType & vbCrLf & vbTab
    If isObject Then s = s & " Set "
    s = s & myName & " = my" & myName & vbCrLf
    s = s & "End Property"
    GetStatement = s
End Property

Sub Initialize(Name As String, Typ As String)
    '' Initializes the variable with a name and type.
    myName = Name
    myType = Typ
End Sub

