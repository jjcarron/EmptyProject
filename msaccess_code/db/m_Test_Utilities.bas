Attribute VB_Name = "m_Test_Utilities"
Option Compare Database

'' Tests various utility functions to ensure they work correctly with different data types.

'' Tests the IsLong function with an Integer input.
'' Returns True if the function correctly identifies the input as not a Long.
Function Test_IsLong_with_Integer() As Boolean
    Dim x As Integer: x = 100
    Test_IsLong_with_Integer = Not IsLong(x)
End Function

'' Tests the IsLong function with a String input.
'' Returns True if the function correctly identifies the input as not a Long.
Function Test_IsLong_with_String() As Boolean
    Dim x As String: x = "XXX"
    Test_IsLong_with_String = Not IsLong(x)
End Function

'' Tests the IsLong function with a Double input.
'' Returns True if the function correctly identifies the input as not a Long.
Function Test_IsLong_with_Double() As Boolean
    Dim x As Double: x = 3.14159
    Test_IsLong_with_Double = Not IsLong(x)
End Function

'' Tests the IsLong function with a Long input.
'' Returns True if the function correctly identifies the input as a Long.
Function Test_IsLong_with_Long() As Boolean
    Dim x As Long: x = 153
    Test_IsLong_with_Long = IsLong(x)
End Function

'' Tests the IsInteger function with an Integer input.
'' Returns True if the function correctly identifies the input as an Integer.
Function Test_IsInteger_with_Integer() As Boolean
    Dim x As Integer: x = 153
    Test_IsInteger_with_Integer = IsInteger(x)
End Function

'' Tests the IsDouble function with a Double input.
'' Returns True if the function correctly identifies the input as a Double.
Function Test_IsDouble_with_Double() As Boolean
    Dim x As Double: x = 153.3445
    Test_IsDouble_with_Double = IsDouble(x)
End Function

'' Tests the IsString function with a String input.
'' Returns True if the function correctly identifies the input as a String.
Function Test_IsString_with_String() As Boolean
    Dim x As String: x = "XXX"
    Test_IsString_with_String = IsString(x)
End Function

'' Tests the CastToLong function with a String input.
'' Returns True if the function correctly fails to cast the input to a Long.
Function Test_CastToLong_with_String() As Boolean
    Dim x As String: x = "XXX"
    Dim myLong As Long
    Test_CastToLong_with_String = Not CastToLong(x, myLong)
End Function

'' Tests the CastToLong function with an Integer input.
'' Returns True if the function correctly casts the input to a Long.
Function Test_CastToLong_with_Integer() As Boolean
    Dim x As Integer: x = 100
    Dim myLong As Long
    Test_CastToLong_with_Integer = CastToLong(x, myLong) And x = myLong
End Function

'' Tests the MD5 encryption function.
'' Returns True if the encrypted string has a length of 32 characters.
Function Test_Encryption() As Boolean
    Dim pw As String
    Dim encoded As String
    pw = 1234567
    encoded = MD5(pw)
    If Len(encoded) = 32 Then
        Test_Encryption = True
    Else
        Test_Encryption = False
    End If
End Function

'' Tests if the MD5 encryption produces consistent results for the same input.
'' Returns True if the two encrypted strings are identical.
Function Test_EncryptionCheckOk() As Boolean
    Dim pw As String
    Dim encoded As String
    Dim check As String
    pw = 1234567
    encoded = MD5(pw)
    check = MD5(pw)
    If encoded = check Then
        Test_EncryptionCheckOk = True
    Else
        Test_EncryptionCheckOk = False
    End If
End Function

'' Tests the GetLastModifiedDate function to ensure it returns consistent results.
'' Returns True if the function returns a valid date that matches expected results.
Function Test_GetLastModifiedDate() As Boolean
    Dim res As Boolean
    res = GetLastModifiedDate("C:\Windows\System32\attrib.exe") = GetLastModifiedDate("C:\Windows\System32\attrib.exe")
    Test_GetLastModifiedDate = res And GetLastModifiedDate("C:\Windows\System32\attrib.exe") <> DateTime.DateSerial(-1000, 1, 1)
End Function

