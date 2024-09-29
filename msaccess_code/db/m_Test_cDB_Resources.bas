Attribute VB_Name = "m_Test_cDB_Resources"
Option Compare Database
'This test suite need an initialized tbl_Resources where IDM_EDIT is defined

Function getStringWithoutLanguageDefinition() As Boolean
    TheCurrentUser.userLanguage = ""
    Dim s As New cDB_ResourceStrings
    getStringWithoutLanguageDefinition = s.str("MNU_EDIT") = "&Edit"
End Function

Function getStringWithLanguageDefinitionFromGlobal() As Boolean
     TheCurrentUser.userLanguage = "FR"
    Dim s As New cDB_ResourceStrings
    getStringWithLanguageDefinitionFromGlobal = s.str("MNU_EDIT") = "&Edition"
End Function

Function getStringWithLanguageDefinition() As Boolean
    Dim s As New cDB_ResourceStrings
    s.Initialize ("FR")
    getStringWithLanguageDefinition = s.str("MNU_EDIT") = "&Edition"
End Function

Function getStringWithUndefinedLanguage() As Boolean
    Dim s As New cDB_ResourceStrings
    s.Initialize ("IT")
    getStringWithUndefinedLanguage = s.str("MNU_EDIT") = "&Edit"
End Function

Function getNonExistentString() As Boolean
    Dim s As New cDB_ResourceStrings
    getNonExistentString = s.str("MNU_NONEXISTENT") = "MNU_NONEXISTENT"
End Function
