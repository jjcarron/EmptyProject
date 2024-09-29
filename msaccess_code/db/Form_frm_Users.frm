VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Form_frm_Users"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Compare Database

'' frm_Users
'' This form manages user data within the application.
'' It initializes the application context on load and handles password updates when the user double-clicks the password field.

Private Sub Form_Load()
    '' Triggered when the form is loaded.
    '' This event initializes the application context and translates the form's labels based on the selected language.
    Init_Context
    Dim translator As New cDB_Translator
    translator.TranslateForm Me
End Sub

Private Sub USER_PASSWORD_DblClick(Cancel As Integer)
    '' Triggered when the user double-clicks on the password field.
    '' If a valid user ID is present, this event opens the password change form (frm_Password) for the selected user.
    If Me.USER_ID <> 0 Then
        DoCmd.OpenForm FormName:="frm_Password", WhereCondition:="USER_ID = " & Me.USER_ID
    End If
End Sub

