VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "cCG_DB_Variable"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Compare Database

'' Class : cCG_DB_Variable
''
'' This class implements the management of variables for database classes in the code generator.
'' It provides properties and methods to generate code for variable declaration,
'' initialization, and property methods (Get/Set) based on the variable's type.

Private myVariable As cCG_Variable
Private myIsPrimaryKey As Boolean
Private myDBName As String

Property Get Name() As String
    '' Returns the name of the variable as used in the code.
    Name = myVariable.Name
End Property

Property Get DBName() As String
    '' Returns the database name of the variable, which may differ from the code variable name.
    DBName = myDBName
End Property

Property Get isObject() As Boolean
    '' Returns True if the variable is an object type; otherwise, False.
    isObject = myVariable.isObject
End Property

Property Get isPrimaryKey() As Boolean
    '' Returns True if the variable is marked as a primary key.
    isPrimaryKey = myIsPrimaryKey
End Property

Property Get Declaration() As String
    '' Returns the declaration string for the variable in the format used in class modules.
    Declaration = myVariable.Declaration
End Property

Property Get InitString() As String
    '' Returns the initialization string for the variable, used in method parameters or initialization blocks.
    InitString = myVariable.InitString
End Property

Property Get InitStatement() As String
    '' Returns the initialization statement for the variable, used to set the variable's value in the class.
    InitStatement = myVariable.InitStatement
End Property

Property Get SetStatement() As String
    '' Returns the Set property method for the variable, allowing external code to set the variable's value.
    SetStatement = myVariable.SetStatement
End Property

Property Get GetStatement() As String
    '' Returns the Get property method for the variable, allowing external code to retrieve the variable's value.
    GetStatement = myVariable.GetStatement
End Property

Sub Initialize(Name As String, Typ As String, Optional isPrimaryKey As Boolean = False)
    '' Initializes the variable with the given name, type, and optionally marks it as a primary key.
    '' - Name: The name of the database column.
    '' - Typ: The data type of the variable (e.g., String, Integer).
    '' - isPrimaryKey: (Optional) Boolean indicating whether this variable is a primary key. Default is False.
    myIsPrimaryKey = isPrimaryKey
    myDBName = Name
    Set myVariable = New cCG_Variable
    myVariable.Initialize FixedVarName(myDBName), Typ
End Sub

