VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "cCG_DB_ClassWriter"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Compare Database

'' Class : cCG_DB_ClassWriter
''
'' This class implements the writer of database classes in the code generator.
'' It is responsible for generating class modules based on templates or reference classes,
'' and customizing them for specific database tables.

Private myClassWriter As cCG_ClassWriter
Const strQuote As String = """"

Private myClassName As String
Private myReferenceClass As String
Private mytblPrefix As String
Private Code As Collection

Property Get ClassName() As String
    '' Returns the name of the class being generated.
    ClassName = myClassName
End Property

Property Get ReferenceClass() As String
    '' Returns the name of the reference class used as a template for generating the new class.
    ReferenceClass = myReferenceClass
End Property

Property Get SubClassName(ClassName As String) As String
    '' Returns the singularized version of the class name, after removing the 'cDB_' prefix.
    '' This is used to generate appropriate names for class properties or methods.
    SubClassName = Singularize(Mid(ClassName, 5, Len(ClassName) - 4))
End Property

Property Get tableName(ClassName As String) As String
    '' Returns the database table name associated with the class,
    '' applying the appropriate prefix and removing the 'cDB_' prefix.
    tableName = mytblPrefix & (Mid(ClassName, 5, Len(ClassName) - 4))
End Property

Property Get Header() As Collection
    '' Generates and returns the header lines for the class file,
    '' including attributes and version information.
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
    HeaderLines.Add "' Region ""============================= Generated Code =============================="" " & vbCrLf
    HeaderLines.Add "'' Class : " & ClassName & vbCrLf
    HeaderLines.Add "'' "
    HeaderLines.Add "'' Code generated from the Class Definition 'Classes.def' at " & Date
    HeaderLines.Add "'' by cCG_DB_ClassWriter"
    HeaderLines.Add "''" & vbCrLf

    Set Header = HeaderLines
End Property

Property Get ClassContent() As Collection
    '' Generates and returns the complete content of the class,
    '' including the header and code derived from the reference class.
    Dim Code As New Collection
    Dim CodeModule As Variant
    Dim lines As String
    
    Set Code = Header
    
    Set CodeModule = CurrentProject.Application.VBE.ActiveVBProject.VBComponents(ReferenceClass).CodeModule
    
    lines = CodeModule.lines(7, CodeModule.CountOfLines) ' Skip the first 6 lines
    lines = Replace(lines, "tbl_", mytblPrefix) ' Handle correctly other prefixes
    lines = Replace(lines, tableName(ReferenceClass), tableName(ClassName))
    Code.Add Replace(lines, SubClassName(ReferenceClass), SubClassName(ClassName))
    
    Code.Add "' Region ""============================= User Code  =============================="" " & vbCrLf
     
    Set ClassContent = Code
End Property

Function MergedCollection(Col As Collection, ColToAdd As Collection) As Collection
    '' Merges two collections into one, appending all items from ColToAdd to Col.
    Dim o As Variant
    For Each o In ColToAdd
        Col.Add o
    Next
    Set MergedCollection = Col
End Function

Sub WriteClass(Path As String)
    '' Writes the generated class to a .cls file at the specified path.
    '' The class content is created based on the reference class and the current class's properties.
    
    Dim Code As New Collection
    Dim Writer As New cLogger
    Dim Var As cCG_Variable

    Dim FullFileName As String
    FullFileName = Path & myClassName & ".cls"
    
    Writer.Initialize FullFileName:=FullFileName, DebugPrint:=True, archive:=False
           
    Writer.report ClassContent
End Sub

Sub Initialize(ClassName As String, ReferenceClass As String, tblPrefix As String)
    '' Initializes the class writer with the necessary parameters for generating the class.
    '' - ClassName: The name of the class to be generated.
    '' - ReferenceClass: The name of the reference class used as a template.
    '' - tblPrefix: The prefix to be used for the associated database table name.
    myClassName = ClassName
    myReferenceClass = ReferenceClass
    mytblPrefix = tblPrefix
End Sub

