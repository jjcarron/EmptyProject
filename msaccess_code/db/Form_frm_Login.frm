VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Form_frm_Login"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Compare Database

'' frm_login
'' This form manages the login process for users. It verifies user credentials, handles user authentication,
'' and displays appropriate messages based on the success or failure of the login attempt.
'' The form also initializes certain UI elements when loaded and closed, and manages the application menu upon successful login.

Private needToOpen As Boolean

Private Sub CANCEL_Click()
    '' Handles the event when the Cancel button is clicked.
    '' This will close the application when the Cancel button is clicked by the user.
    DoCmd.Quit
End Sub

Private Sub Form_Close()
    '' This event is triggered when the form is closed.
    '' It sets up the application menu using the cDB_Menu class when the form is closed.
    Dim menu As New cDB_Menu
    menu.SetMenu ("APP_SMSTAT")
End Sub

Private Sub OK_Click()
    '' Handles the event when the OK button is clicked.
    '' This function checks the username and password entered by the user.
    '' If the credentials are valid, the form is closed and the user is marked as logged in.
    '' If the credentials are invalid, an appropriate message is displayed to the user.
    Dim s As New cDB_ResourceStrings
    With TheCurrentUser
        .Initialize (LOGIN_USER.value)
        If Not .Initialized Or .isLocked Or .UserID = 0 Then
            MsgBox (s.str("MSG_UNKNOWN_USER"))
            Exit Sub
        ElseIf .Password = MD5(LOGIN_PW.value) Then
            DoCmd.Close acForm, "frm_Login"
            LoggedIn = True
            Exit Sub
        End If
    End With
    MsgBox (s.str("MSG_WRONG_PW"))
End Sub

Private Sub Form_Load()
    '' This event is triggered when the form is loaded.
    '' It translates the control labels on the form based on the current language settings.
    Dim translator As New cDB_Translator
    translator.TranslateControlLabels (Me)
End Sub

Private Sub Form_Open(Cancel As Integer)
    '' This event is triggered when the form is opened.
    '' It initializes the form caption and clears the password field.
    '' It also sets the username field to the current user's username.
    Dim s As New cDB_ResourceStrings
    Me.Caption = s.str("FRM_LOGIN")
    LOGIN_PW.value = ""
    LOGIN_USER.value = TheCurrentUser.USERNAME
End Sub

