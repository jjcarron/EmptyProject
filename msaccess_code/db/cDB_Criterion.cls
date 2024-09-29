VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "cDB_Criterion"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

' Region "============================= Generated Code =============================="

'' Class : cDB_Criterion

''
'' Code generated from the Class Definition 'Classes.def' at 23.05.2024
'' by cCG_ClassWriter
''

Private myAbbreviation As String
Private myComment As String
Private myid As Long
Private myReference As String

Property Get Abbreviation() As String
        Abbreviation = myAbbreviation
End Property

Property Let Abbreviation(Abbreviation As String)
        myAbbreviation = Abbreviation
End Property

Property Get Comment() As String
        Comment = myComment
End Property

Property Let Comment(Comment As String)
        myComment = Comment
End Property

Property Get id() As Long
        id = myid
End Property

Property Let id(id As Long)
        myid = id
End Property

Property Get Reference() As String
        Reference = myReference
End Property

Property Let Reference(Reference As String)
        myReference = Reference
End Property

Property Get record() As cDB_Record
'' Returns the DB-Record
        Dim lRecord As New cDB_Record
        Dim Field As cDB_Field

        Set Field = New cDB_Field
        Field.Initialize Col:="Abbreviation", Val:=myAbbreviation
        lRecord.Add Field

        Set Field = New cDB_Field
        Field.Initialize Col:="Comment", Val:=myComment
        lRecord.Add Field

        Set Field = New cDB_Field
        Field.Initialize Col:="Reference", Val:=myReference
        lRecord.Add Field

        Set record = lRecord
End Property

Sub InitializeFromDB_Record(rec As cDB_Record)
'' initialize the object content from the database record
        On Error Resume Next
        myAbbreviation = rec.column("Abbreviation").value
        myComment = rec.column("Comment").value
        myid = rec.column("id").value
        myReference = rec.column("Reference").value
        On Error GoTo 0
End Sub


Sub Initialize(Abbreviation As String, Comment As String, Reference As String)
'' If you need to initialize with Primary key, add the corresponding field manually
        myAbbreviation = Abbreviation
        myComment = Comment
        myid = id
        myReference = Reference
End Sub

' Region "============================= User Code  =============================="

