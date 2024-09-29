VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "cDB__Domain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Compare Database
Private myid As Long
Private myName As String
Private myDescription As String
Private myWeight As Integer
Private myFileName As String

Property Get id() As Long
    id = myid
End Property

Property Get Name() As String
    mame = myName
End Property

Property Get Description() As String
    Description = myDescription
End Property
Property Get Weight() As Integer
    Weight = myWeight
End Property

Property Get Filename() As String
    Filename = myFileName
End Property

Sub Initialize(Domain As cDB_Record)
On Error Resume Next
    With Domain
        myid = Domain.column("id").Value
        myName = Domain.column("Name").Value
        myDescription = Domain.column("Description").Value
        myWeight = Domain.column("Weighting").Value
        myFileName = Domain.column("RefFileName").Value
    End With
End Sub
