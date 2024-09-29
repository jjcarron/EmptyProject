VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "cDB_User"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'' Class : cDB_User
''
'' This class provides a simple user management system.
'' Each user has a password, can be an administrator or not, and can be locked.

Option Compare Database

Private myUserId As Long
Private myUsername As String
Private myName As String
Private myFirstName As String
Private myPassword As String
Private myLanguage As String
Private myIsAdmin As Boolean
Private myIsLocked As Boolean
Private myIsInitialized As Boolean

Property Get Initialized() As Boolean
    '' Returns True if the user object has been initialized with user data.
    Initialized = myIsInitialized
End Property

Property Get isAdmin() As Boolean
    '' Returns True if the user has administrative privileges.
    isAdmin = myIsAdmin
End Property

Property Get isLocked() As Boolean
    '' Returns True if the user account is locked.
    isLocked = myIsLocked
End Property

Property Get USERNAME() As String
    '' Returns the username of the user.
    USERNAME = myUsername
End Property

Property Get Name() As String
    '' Returns the last name of the user.
    Name = myName
End Property

Property Get Firstname() As String
    '' Returns the first name of the user.
    Firstname = myFirstName
End Property

Property Get UserID() As String
    '' Returns the user ID of the user.
    UserID = myUserId
End Property

Property Get Password() As String
    '' Returns the password of the user.
    Password = myPassword
End Property

Property Get userLanguage() As String
    '' Returns the preferred language of the user.
    userLanguage = myLanguage
End Property

Property Let userLanguage(l As String)
    '' Sets the preferred language of the user.
    myLanguage = l
End Property

Public Function Initialize(usr As String) As Boolean
    '' Initializes the user object with data from the database based on the provided username.
    '' If the user is found, the object's properties are populated, and the function returns True.
    '' Parameters:
    ''   - usr: The username to initialize the user object with.
    
    Dim inst As New cDB_Instruction
    Dim users As New cDB_Records
    Dim user As cDB_Record
    
    inst.InitFromStr action:=eReadRow, Table:="Users", columns:="*", Where:="Username = '" & usr & "'"
    
    If inst.execute(users) And (users.count > 0) Then
        On Error Resume Next
        Set user = users.Item(1)
        With user
            myUsername = usr
            myUserId = user.column("id").value
            myName = user.column("Name").value
            myFirstName = user.column("First_Name").value
            If Not IsNull(user.column("Passwd").value) Then
                myPassword = user.column("Passwd").value
            End If
            myLanguage = user.column("PrefLanguage").value
            myIsAdmin = user.column("isAdmin").value
            myIsLocked = user.column("isLocked").value
            If myPassword = "" Or myPassword = MD5("") Then
                myPassword = MD5(Right(usr, 3) & "$1234")
            End If
        End With
        myIsInitialized = True
    End If
    
    Initialize = myIsInitialized
End Function

Public Function InitializedFromEnvironment() As Boolean
    '' Initializes the user object based on the current environment's username and domain.
    '' This is useful for automatically loading the user based on the current session's user.
    
    If Environ("USERDOMAIN") = DefaultUserDomain Then
        myIsInitialized = Initialize(Environ("USERNAME"))
    ElseIf Environ("USERDOMAIN") = "HPKNZ" Then
        ' Facilitates debugging by initializing with a specific username when working from home.
        myIsInitialized = Initialize("jjcarron")
    End If
    
    InitializedFromEnvironment = myIsInitialized
End Function

