VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "_cDB_Resources"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Compare Database

Private myLanguage As String


Property Get str(Ref As String)
    Dim inst As New cDB_Instruction
On Error Resume Next ' catch null values
    Ref = ReplicateQuote(Ref)
    str = inst.First(Table:="ResourceStrings", column:=myLanguage, Where:="Ref LIKE '" & Ref & "'", default:="")
    If str = "" Then
        'assume english for not implemented languages
        str = inst.First(Table:="resource_strings", column:="EN", Where:="Ref LIKE '" & Ref & "'", default:=Ref)
    End If
End Property

Sub Initialize(Language As String)
   myLanguage = Language
End Sub

Sub Class_Initialize()
    If TheCurrentUser.userLanguage <> "" Then
        myLanguage = TheCurrentUser.userLanguage
    Else
        'assume english
        myLanguage = "EN"
    End If
End Sub
