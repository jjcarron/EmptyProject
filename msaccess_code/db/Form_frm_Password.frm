VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Form_frm_Password"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Compare Database

'' frm_Password
'' This form allows the user to change their password.
'' It includes fields for the old password, the new password, and confirmation of the new password.
'' The form verifies that the old password is correct and that the new password matches the confirmation before allowing the change.

Private Sub CANCEL_Click()
    '' This event is triggered when the "Cancel" button is clicked.
    '' If the user has not entered a password, it clears the current password and closes the form.
    If USER_PASSWORD = MD5("") Then USER_PASSWORD = ""
    DoCmd.Close acForm, "frm_Password"
End Sub

Private Sub OK_Click()
    '' This event is triggered when the "OK" button is clicked.
    '' It checks the old password for correctness, ensures the new password matches its confirmation,
    '' and then updates the user's password if all checks pass.
    Dim s As New cDB_ResourceStrings
    Dim lOPW As String
    Dim lNPW As String
    Dim lConfirmation As String
    
    lOPW = MD5(PW_OLDPW.value)
    lNPW = MD5(PW_NEWPW.value)
    lConfirmation = MD5(PW_CONFIRMATION.value)
    
    If lOPW <> USER_PASSWORD.value Then
        MsgBox s.str("MSG_OLDPW_MISMATCH")
    ElseIf lConfirmation <> lNPW Then
        MsgBox s.str("MSG_NEWPW_MISMATCH")
    Else
        If lNPW = MD5("") Then
            USER_PASSWORD = ""
        Else
            USER_PASSWORD = lNPW
        End If
        DoCmd.Close
    End If
End Sub

Private Sub Form_Load()
    '' This event is triggered when the form is loaded.
    '' It sets the form's caption to include the user's name, translates the control labels into the user's language,
    '' and manages the enabling of the old password field based on whether the user currently has a password set.
    Dim translator As New cDB_Translator
    Dim s As New cDB_ResourceStrings

    translator.TranslateControlLabels Me
    Me.Caption = s.str("FRM_PASSWORD") & " - " & USER_NAME & " " & USER_FIRSTNAME
    
    Dim myPassword As String
    If USER_PASSWORD = "" Or VarType(USER_PASSWORD) = vbNull Then
        USER_PASSWORD = MD5("")
    Else
        myPassword = USER_PASSWORD
        USER_PASSWORD = myPassword
    End If

    PW_OLDPW.value = ""
    PW_NEWPW.value = ""
    PW_CONFIRMATION.value = ""
    
    If USER_PASSWORD = MD5("") Then
        PW_OLDPW.value = ""
        PW_OLDPW.Enabled = False
        PW_NEWPW.SetFocus
    End If
End Sub

