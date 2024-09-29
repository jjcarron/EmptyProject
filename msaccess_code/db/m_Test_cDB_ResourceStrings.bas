Attribute VB_Name = "m_Test_cDB_ResourceStrings"
Option Compare Database

'' This test suite requires an initialized tbl_Resources where IDM_EDIT is defined.
'' The sequence of the test functions is important as they test various resource string retrieval scenarios.

Function getStringWithoutLanguageDefinition() As Boolean
    '' Tests retrieval of a resource string without specifying a language.
    '' Returns True if the correct string is returned, False otherwise.
    
    TheCurrentUser.userLanguage = ""
    Dim s As New cDB_ResourceStrings
    getStringWithoutLanguageDefinition = s.str("MNU_EDIT") = "&Edit"
End Function

Function getStringWithLanguageDefinitionFromGlobal() As Boolean
    '' Tests retrieval of a resource string using the global language definition.
    '' Returns True if the correct string is returned for the global language, False otherwise.
    
    TheCurrentUser.userLanguage = "FR"
    Dim s As New cDB_ResourceStrings
    getStringWithLanguageDefinitionFromGlobal = s.str("MNU_EDIT") = "&Edition"
End Function

Function getStringWithLanguageDefinition() As Boolean
    '' Tests retrieval of a resource string by explicitly specifying the language.
    '' Returns True if the correct string is returned for the specified language, False otherwise.
    
    Dim s As New cDB_ResourceStrings
    s.Initialize ("FR")
    getStringWithLanguageDefinition = s.str("MNU_EDIT") = "&Edition"
End Function

Function getStringWithUndefinedLanguage() As Boolean
    '' Tests retrieval of a resource string with an undefined language.
    '' Returns True if the fallback string (typically English) is returned, False otherwise.
    
    Dim s As New cDB_ResourceStrings
    s.Initialize ("IT")
    getStringWithUndefinedLanguage = s.str("MNU_EDIT") = "&Edit"
End Function

Function getNonExistentString() As Boolean
    '' Tests retrieval of a non-existent resource string.
    '' Returns True if the function returns the key itself when the string does not exist, False otherwise.
    
    Dim s As New cDB_ResourceStrings
    getNonExistentString = s.str("MNU_NONEXISTENT") = "MNU_NONEXISTENT"
End Function

