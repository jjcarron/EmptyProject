VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "cCG_ClassWriter"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Compare Database

'' ==============================================================================
'' Class : cCG_ClassWriter
''
'' Description:
'' This class automates the generation of VBA class modules by assembling various
'' components such as headers, variable declarations, property procedures (Get/Set),
'' and initialization methods. It leverages a collection of variables to dynamically
'' create structured and well-formatted class files, facilitating rapid and consistent
'' code generation.
''
'' Key Responsibilities:
'' - Define and store class names and associated variables.
'' - Generate standard VBA class headers with appropriate attributes and metadata.
'' - Create variable declarations based on provided variable definitions.
'' - Construct Get and Set property procedures for encapsulation and data access control.
'' - Generate an Initialize subroutine to set up class instances with provided values.
'' - Compile and write the complete class code to a file using a logging mechanism.
''
'' Dependencies:
'' - Requires the 'ArrayList' class for managing collections of variables.
'' - Utilizes the 'cLogger' class for writing output to files.
'' - Relies on the 'cComparer' class for sorting variables based on specified criteria.
''
'' Usage:
'' 1. Initialize the class with a class name and an optional collection of variables.
'' 2. Call 'WriteClass' with a specified path to generate and save the class file.
''
'' Example:
'' Dim classWriter As New cCG_ClassWriter
'' classWriter.Initialize "MyClassName", myVariablesArrayList
'' classWriter.WriteClass "C:\Path\To\Output\"
''
'' ==============================================================================

Private myClassName As String
Private myVariables As ArrayList
Private Const strQuote As String = """"

Property Get ClassName() As String
'' Gets or sets the name of the class to be generated.
    ClassName = myClassName
End Property

Property Let ClassName(value As String)
'' Sets the name of the class to be generated.
    myClassName = value
End Property

Property Get Variables() As ArrayList
'' Gets or sets the collection of variables that define the class structure.
'' The variables should be provided as an ArrayList of cCG_Variable objects.
    Set Variables = myVariables
End Property

Property Set Variables(value As ArrayList)
'' Sets the collection of variables that define the class structure.
    Set myVariables = value
End Property

Property Get Header() As Collection
'' Generates and returns a collection of strings representing the standard VBA
'' class header, including versioning, attributes, and auto-generation comments.
    Dim HeaderLines As New Collection
    
    HeaderLines.Add "VERSION 1.0 CLASS"
    HeaderLines.Add "BEGIN"
    HeaderLines.Add vbTab & "MultiUse = -1  'True"
    HeaderLines.Add "END"
    HeaderLines.Add "Attribute VB_Name = " & strQuote & myClassName & strQuote
    HeaderLines.Add "Attribute VB_GlobalNameSpace = False"
    HeaderLines.Add "Attribute VB_Creatable = False"
    HeaderLines.Add "Attribute VB_PredeclaredId = False"
    HeaderLines.Add "Attribute VB_Exposed = False"
    HeaderLines.Add ""
    HeaderLines.Add "' Region ""============================= Generated Code =============================="""
    HeaderLines.Add "'' Class : " & myClassName
    HeaderLines.Add "''"
    HeaderLines.Add "'' Code generated from the Class Definition 'Classes.def' on " & Date
    HeaderLines.Add "'' by cCG_ClassWriter"
    HeaderLines.Add "''"
    HeaderLines.Add "' End Region"
    HeaderLines.Add ""
    
    Set Header = HeaderLines
End Property

Property Get Declarations() As Collection
'' Generates and returns a collection of strings representing the variable
'' declarations for the class based on the provided variables.
    Dim DeclarationsCode As New Collection
    Dim Var As Variant
    
    If Not myVariables Is Nothing Then
        For Each Var In myVariables
            DeclarationsCode.Add Var.Declaration
        Next Var
    End If
    
    Set Declarations = DeclarationsCode
End Property

Property Get GetSetStatements() As Collection
'' Generates and returns a collection of strings representing the Get and Set
'' property procedures for each variable in the class, enabling encapsulated
'' access to class properties.
    Dim GetSetCode As New Collection
    Dim Var As Variant
    
    If Not myVariables Is Nothing Then
        For Each Var In myVariables
            GetSetCode.Add Var.GetStatement
            GetSetCode.Add Var.SetStatement
        Next Var
    End If
    
    Set GetSetStatements = GetSetCode
End Property

Property Get SubInitialize() As Collection
'' Generates and returns a collection of strings representing the Initialize
'' subroutine for the class, which sets up the class properties with provided
'' values. Primary key variables are excluded from initialization by default.
    Dim InitializeCode As New Collection
    Dim InitSignature As String
    Dim Var As Variant
    Dim ParamList As String
    Dim InitStatements As String
    
    ' Construct the parameter list for the Initialize subroutine
    For Each Var In myVariables
        If Not Var.isPrimaryKey Then
            ParamList = ParamList & Var.InitString & ", "
        End If
    Next Var
    
    ' Remove trailing comma and space
    If Len(ParamList) > 0 Then
        ParamList = Left(ParamList, Len(ParamList) - 2)
    End If
    
    ' Construct the Initialize subroutine signature
    InitSignature = "Public Sub Initialize(" & ParamList & ")"
    InitializeCode.Add vbCrLf & InitSignature
    InitializeCode.Add vbTab & "'' Initializes class properties with provided values."
    InitializeCode.Add vbTab & "'' Note: Primary key properties are not initialized here."
    InitializeCode.Add ""
    
    ' Add initialization statements for each variable
    For Each Var In myVariables
        If Not Var.isPrimaryKey Then
            InitializeCode.Add vbTab & Var.InitStatement
        End If
    Next Var
    
    InitializeCode.Add "End Sub"
    InitializeCode.Add ""
    
    Set SubInitialize = InitializeCode
End Property

Public Function MergedCollection(Col As Collection, ColToAdd As Collection) As Collection
'' Merges two collections by adding all items from the second collection to the first.
''
'' Parameters:
'' - Col: The primary collection to which items will be added.
'' - ColToAdd: The collection containing items to add to the primary collection.
''
'' Returns:
'' - A new collection containing all items from both input collections.
    Dim Item As Variant
    
    For Each Item In ColToAdd
        Col.Add Item
    Next Item
    
    Set MergedCollection = Col
End Function

Public Sub WriteClass(Path As String)
'' Generates and writes the complete class code to a .cls file at the specified path.
'' The method assembles the class header, declarations, property procedures, and
'' initialization method before writing to the file using the cLogger utility.
''
'' Parameters:
'' - Path: The directory path where the class file will be saved.
    Dim FullFileName As String
    Dim Writer As New cLogger
    Dim Code As New Collection
    
    ' Construct the full file path
    FullFileName = Path & myClassName & ".cls"
    
    ' Initialize the logger/writer
    Writer.Initialize FullFileName:=FullFileName, DebugPrint:=True, archive:=False
    
    ' Assemble the class code
    Set Code = MergedCollection(Declarations, GetSetStatements)
    Set Code = MergedCollection(Code, SubInitialize)
    
    ' Add a region for user-defined code
    Code.Add vbCrLf & "' Region ""============================= User Code  =============================="""
    Code.Add "' End Region"
    Code.Add ""
    
    ' Write the assembled code to the file with the header
    Writer.report Code, Header
End Sub

Public Sub Initialize(ClassName As String, Optional Variables As Object = Nothing)
'' Initializes the cCG_ClassWriter instance with the specified class name and
'' an optional collection of variables. If variables are provided, they are sorted
'' alphabetically by name for consistency.
''
'' Parameters:
'' - ClassName: The name of the class to be generated.
'' - Variables: (Optional) An ArrayList of cCG_Variable objects defining the class properties.
    Dim comp As New cComparer
    
    myClassName = ClassName
    
    If Not Variables Is Nothing Then
        Set myVariables = Variables
        ' Sort variables alphabetically by name
        comp.sortField = "Name"
        myVariables.Sort_2 comp
    Else
        Set myVariables = New ArrayList
    End If
End Sub

