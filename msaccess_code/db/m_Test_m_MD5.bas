Attribute VB_Name = "m_Test_m_MD5"
Option Compare Database

Function Encryption() As Boolean
    '' Tests the MD5 encryption by encoding a numeric password and checking the length of the encoded string.
    '' Returns True if the encoded string is 32 characters long, which is the expected length of an MD5 hash.
    
    Dim pw As String
    Dim encoded As String
    pw = 1234567
    encoded = MD5_string(pw)
    If Len(encoded) = 32 Then
        Encryption = True
    Else
        Encryption = False
    End If
End Function

Function EncryptionCheckOk() As Boolean
    '' Tests the consistency of the MD5 encryption by encoding the same password twice and comparing the results.
    '' Returns True if both encoded strings are identical, indicating that the encryption is consistent.
    
    Dim pw As String
    Dim encoded As String
    Dim check As String
    pw = 1234567
    encoded = MD5_string(pw)
    check = MD5_string(pw)
    If encoded = check Then
        EncryptionCheckOk = True
    Else
        EncryptionCheckOk = False
    End If
End Function

Function EncryptionCheckNotOk() As Boolean
    '' Tests the MD5 encryption by encoding a password and comparing it to an encoding of a different password.
    '' Returns True if the two encoded strings are different, which is the expected behavior.
    
    Dim pw As String
    Dim encoded As String
    Dim check As String
    pw = 1234567
    encoded = MD5_string(pw)
    check = MD5_string(pw & "8")
    If encoded <> check Then
        EncryptionCheckNotOk = True
    Else
        EncryptionCheckNotOk = False
    End If
End Function

