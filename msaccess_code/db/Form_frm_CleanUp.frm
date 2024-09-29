VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Form_frm_CleanUp"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Compare Database

'' frm_CleanUp
'' This form is a hidden utility designed to ensure that all objects are properly cleaned up when the program exits.
'' It automatically closes any open Excel applications and other resources that need to be released upon program termination.

Private Sub Form_Unload(Cancel As Integer)
    '' This event is triggered when the form is unloaded, typically when the application is closing.
    '' It calls the Close_XL_App function to close any open Excel applications.
    Close_XL_App
End Sub

Private Sub Form_Open(Cancel As Integer)
    '' This event is triggered when the form is opened.
    '' It makes the form invisible, as it is intended to run in the background without user interaction.
    Me.Visible = False
End Sub

