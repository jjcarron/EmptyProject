VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "cCG_DB_Record_ClassWriter"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Private myClassWriter As cCG_ClassWriter
Const strQuote As String = """"

Property Get ClassName() As String
    ClassName = myClassWriter.ClassName
End Property

Property Let ClassName(ClassName As String)
        myClassWriter.ClassName = ClassName
End Property

Property Get Variables() As Collection
     Set Variables = myClassWriter.Variables
End Property

Property Set Variables(Variables As Collection)
     Set myClassWriter.Variables = Variables
End Property

Property Get Header() As Collection
    Set Header = myClassWriter.Header
End Property

Property Get Declarations() As Collection
    Set Declarations = myClassWriter.Declarations
End Property

Property Get GetSetStatements() As Collection
    Set GetSetStatements = myClassWriter.GetSetStatements
End Property

Property Get SubInitialize() As Collection
    Set SubInitialize = myClassWriter.SubInitialize
End Property

Property Get SubInitializeFromDB_Record() As Collection
    Dim Code As New Collection
    Dim Var As cCG_DB_Variable
    InitStr = vbCrLf & "Sub InitializeFromDB_Record(rec As cDB_Record)"
    InitStr = InitStr & vbCrLf & "'' initialize the object content from the database record"
    Code.Add InitStr
    Code.Add vbTab & "On Error Resume Next" ' skip not available fields
    For Each Var In myClassWriter.Variables
            Code.Add vbTab & "my" & Var.Name & " = " & "rec.column(" & strQuote & Var.Name & strQuote & ").Value"
    Next
    Code.Add vbTab & "On Error Goto 0" ' skip not available fields
    Code.Add "End Sub" & vbCrLf
    Set SubInitializeFromDB_Record = Code
End Property

Property Get GetDB_Record() As Collection
    Dim Code As New Collection
    Dim Var As cCG_DB_Variable
    Dim InitStr As String
    InitStr = vbCrLf & "Property Get record() As cDB_Record"
    InitStr = InitStr & vbCrLf & "'' Returns the DB-Record"
    InitStr = InitStr & vbCrLf & vbTab & "Dim lRecord As New cDB_Record"
    InitStr = InitStr & vbCrLf & vbTab & "Dim Field As cDB_Field"
    Code.Add InitStr

    For Each Var In myClassWriter.Variables
        If Not Var.isPrimaryKey Then '' Primary Key is not exported in the record as it should not be modified
            InitStr = vbCrLf & vbTab & "Set Field = New cDB_Field"
            InitStr = InitStr & vbCrLf & vbTab & "Field.Initialize Col:=" & strQuote & Var.DBName & strQuote & ", val:=my" & Var.Name
            InitStr = InitStr & vbCrLf & vbTab & "lRecord.add Field"
            Code.Add InitStr
        End If
    Next
    
    InitStr = vbCrLf & vbTab & "Set record = lRecord"
    InitStr = InitStr & vbCrLf & "End Property"
    Code.Add InitStr
    
    Set GetDB_Record = Code
End Property


Sub WriteClass(Path As String)
'' Write a class according to the collection of variables
    
    Dim Code As New Collection
    Dim Writer As New cLogger
    Dim Var As cCG_Variable
    Dim InitStr As String

    
    Dim FullFileName As String
    FullFileName = Path & myClassWriter.ClassName & ".cls"
    
    Writer.Initialize FullFileName:=FullFileName, DebugPrint:=True, archive:=False
    
    Set Code = myClassWriter.Declarations
    
    Set Code = myClassWriter.MergedCollection(Code, GetSetStatements)
    
    Set Code = myClassWriter.MergedCollection(Code, GetDB_Record)
    
    Set Code = myClassWriter.MergedCollection(Code, SubInitializeFromDB_Record)
    
    Set Code = myClassWriter.MergedCollection(Code, SubInitialize)
    
    Code.Add vbCrLf & "' Region ""============================= User Code  =============================="" " & vbCrLf
            
    Writer.report Code, myClassWriter.Header

End Sub

Sub Initialize(ClassName As String, Variables As ArrayList)
    Set myClassWriter = New cCG_ClassWriter
    myClassWriter.Initialize ClassName, Variables
End Sub
