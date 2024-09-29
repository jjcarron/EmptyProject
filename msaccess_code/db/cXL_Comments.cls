VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "cXL_Comments"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Compare Database

Private myComments As Collection

Property Get Comments() As Collection
   Set Comments = myRequirements
End Property

Sub Initialize(sheet As Worksheet, Domain_id As Long, Path As String, Rating As Boolean)
    Dim i As Long
    Set myComments = New Collection
    For i = 1 To sheet.usedRange.Rows.count
        Set Comment = New Collection
        If sheet.Cells(i, 1).Value = "Allgemeine Bemerkungen Prüfer/In 1:" And Comment.count < 2 Then
            Comment.Add sheet.Cells(i, 3).Value
        End If
        If sheet.Cells(i, 1).Value = "Allgemeine Bemerkungen Prüfer/In 2:" And Comment.count < 2 Then
            Comment.Add sheet.Cells(i, 3).Value
        End If
        Comment.Add Domain_id
        myComments.Add Comment
    Next i
End Sub
