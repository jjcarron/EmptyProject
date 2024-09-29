Attribute VB_Name = "m_Test_cDB_User"
Option Compare Database

'' This test suite verifies the functionality of the `cDB_User` class by performing operations
'' such as adding, removing, and initializing users, and by checking user properties like
'' username, password, name, first name, admin status, and lock status.

Function addTestUser() As Boolean
    '' Adds a test user to the `Users` table and verifies the addition.
    '' Returns True if the user is added successfully and the record matches, False otherwise.
    
    Dim inst As New cDB_Instruction
    Dim rec As New cDB_Record
    Dim rec2 As New cDB_Record
    Dim records As New cDB_Records
    Dim pw As String
    pw = MD5("9876")
    With inst
        rec.Initialize columns:="Username, Name, First_Name, Passwd, PrefLanguage", _
        values:="'esbk-Test', 'Test', 'first_test', " & pw & ", 'DE'"
        .Initialize action:=eCreateRow, Table:="Users", record:=rec
        .execute
        
        rec2.Initialize columns:="Username, Name, First_Name, Passwd, PrefLanguage"
        .Initialize action:=eReadRow, Table:="Users", record:=rec2, Where:="Username LIKE 'esbk-Test' AND Name LIKE 'Test'"
        .execute records:=records
    End With
    If records.count > 0 Then
        Set rec2 = records.Item(1)
        addTestUser = rec.IdentiqueAs(rec2)
    Else
        addTestUser = False
    End If
End Function

Function removeTestUser() As Boolean
    '' Removes the test user from the `Users` table and verifies the removal.
    '' Returns True if the user is removed successfully, False otherwise.
    
    Dim inst As New cDB_Instruction
    Dim record As New cDB_Record
    Dim records As New cDB_Records
    
    With inst
        .Initialize action:=eDeleteRow, Table:="Users", Where:="Username='esbk-Test'"
        .execute
        
        record.Initialize columns:="Username"
        .Initialize action:=eReadRow, Table:="Users", record:=record, Where:="Username='esbk-Test'"
        .execute records:=records
    End With
    removeTestUser = records.count = 0
End Function

Function initializeUser() As Boolean
    '' Initializes the `cDB_User` object for the test user and verifies successful initialization.
    '' Returns True if the user is initialized successfully, False otherwise.
    
    Dim usr As New cDB_User
    Dim inst As New cDB_Instruction
    Dim rec As New cDB_Record
    Dim pw As String
    pw = MD5("9876")
    With inst
        rec.Initialize columns:="Username, Name, First_Name, Passwd, PrefLanguage, IsAdmin, IsLocked", _
        values:="'esbk-Test', 'Test', 'first_test', " & pw & ", 'DE', -1, -1"
        .Initialize action:=eCreateRow, Table:="Users", record:=rec
        .execute
    End With
    initializeUser = usr.Initialize("esbk-Test") And usr.Initialized
End Function

Function USERNAME() As Boolean
    '' Verifies that the `USERNAME` property of the `cDB_User` object is correctly set.
    '' Returns True if the property matches the expected value, False otherwise.
    
    Dim usr As New cDB_User
    USERNAME = usr.Initialize("esbk-Test") And usr.USERNAME = "esbk-Test"
End Function

Function Password() As Boolean
    '' Verifies that the `Password` property of the `cDB_User` object is correctly set.
    '' Returns True if the property matches the expected MD5 hashed value, False otherwise.
    
    Dim usr As New cDB_User
    Password = usr.Initialize("esbk-Test") And usr.Password = MD5("9876")
End Function

Function Name() As Boolean
    '' Verifies that the `Name` property of the `cDB_User` object is correctly set.
    '' Returns True if the property matches the expected value, False otherwise.
    
    Dim usr As New cDB_User
    Name = usr.Initialize("esbk-Test") And usr.Name = "Test"
End Function

Function Firstname() As Boolean
    '' Verifies that the `Firstname` property of the `cDB_User` object is correctly set.
    '' Returns True if the property matches the expected value, False otherwise.
    
    Dim usr As New cDB_User
    Firstname = usr.Initialize("esbk-Test") And usr.Firstname = "first_test"
End Function

Function isLocked() As Boolean
    '' Verifies that the `isLocked` property of the `cDB_User` object is correctly set.
    '' Returns True if the property matches the expected value, False otherwise.
    
    Dim usr As New cDB_User
    isLocked = usr.Initialize("esbk-Test") And usr.isLocked = True
End Function

Function isAdmin() As Boolean
    '' Verifies that the `isAdmin` property of the `cDB_User` object is correctly set.
    '' Returns True if the property matches the expected value, False otherwise.
    
    Dim usr As New cDB_User
    isAdmin = usr.Initialize("esbk-Test") And usr.isAdmin = True
End Function


