VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "cDB_Translator"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'' Class : cDB_Translator
''
'' This class provides a translation mechanism for the internationalization of menus and panels.

Option Compare Database

Sub TranslateControlLabels(ctrls As Controls)
    '' Translates the labels and captions of controls in a given collection of controls.
    '' The function checks the type of each control and updates its Caption property using a resource string.
    '' Parameters:
    ''   - ctrls: A collection of controls (e.g., from a form) whose labels and captions need to be translated.
    
    Dim s As cDB_ResourceStrings
    Dim cName As String
    Dim eName As String
    Dim i As Long
    Dim ctrl As Control
    
    Set s = New cDB_ResourceStrings
    For Each ctrl In ctrls
        Select Case ctrl.ControlType
        Case acLabel
            ctrl.Caption = s.str(ctrl.Name)
        Case acCommandButton
            ctrl.Caption = s.str(ctrl.Name)
        Case Else
            ' Other control types can be added here as needed
        End Select
    Next
End Sub

Sub TranslateForm(ctrls As Controls)
    '' Translates the caption of a form and the labels/captions of all its controls.
    '' The function first updates the form's caption, then calls TranslateControlLabels to handle the controls.
    '' Parameters:
    ''   - ctrls: A collection of controls from the form to be translated.
    
    Dim s As New cDB_ResourceStrings
    
    ' Translate the form's caption
    ctrls.Parent.Form.Caption = s.str(UCase(ctrls.Parent.Form.Caption))
    
    ' Translate the labels and buttons within the form
    TranslateControlLabels ctrls:=ctrls
End Sub

