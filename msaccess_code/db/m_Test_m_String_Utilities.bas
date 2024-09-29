Attribute VB_Name = "m_Test_m_String_Utilities"
Option Compare Database

Function Test_ReplicateQuote() As Boolean
    '' Tests the ReplicateQuote function by checking if it correctly doubles the single quotes in a string.
    '' Returns True if the quotes are correctly replicated, False otherwise.
    
    Dim s As String
    s = "bla'Bla'Bla'"
    Test_ReplicateQuote = ReplicateQuote(s) = "bla''Bla''Bla''"
End Function

Function Test_CleanUp() As Boolean
    '' Tests the cleanup function to ensure it correctly trims leading and trailing spaces and removes surrounding single quotes.
    '' Returns True if the string is correctly cleaned, False otherwise.
    
    Dim s As String
    s = "   ' bla'Bla'Bla'  "
    Test_CleanUp = cleanup(s) = " bla'Bla'Bla"
End Function

Function Test_EscapeDelim() As Boolean
    '' Tests the EscapeDelim function to verify that it correctly escapes single quotes in a string.
    '' Returns True if the quotes are correctly escaped, False otherwise.
    
    Dim s As String
    s = "bla'Bla''Bla'"
    Test_EscapeDelim = EscapeDelim(s) = "bla''Bla''''Bla''"
End Function

Function Test_NextCommaPos() As Boolean
    '' Tests the NextCommaPos function to ensure it correctly identifies the positions of commas in a complex string.
    '' Returns True if the positions are correctly identified, False otherwise.
    
    Dim s As String
    Dim r As Boolean
    Dim pos As Integer
    s = " 'bla', Bla, 'Bla,bla', 'bla''bla,', bla"
    
    pos = NextCommaPos(s)
    r = (pos = 6)
    s = Mid(s, pos + 1)
    
    pos = NextCommaPos(s)
    r = r And (pos = 4)
    s = Mid(s, pos + 1)
    
    pos = NextCommaPos(s)
    r = r And (pos = 10)
    s = Mid(s, pos + 1)
    
    pos = NextCommaPos(s)
    r = r And (pos = 12)
    s = Mid(s, pos + 1)
    Test_NextCommaPos = r
End Function

Function TestRemoveMultipleSpaces() As Boolean
    '' Tests the RemoveMultipleSpaces function to ensure it correctly reduces multiple spaces to a single space.
    '' Returns True if the spaces are correctly reduced, False otherwise.
    
    Dim testString As String
    Dim resultString As String
    
    testString = "Ceci   est    une     chaîne    avec   des   espaces   multiples."
    resultString = RemoveMultipleSpaces(testString)
    TestRemoveMultipleSpaces = resultString = "Ceci est une chaîne avec des espaces multiples."
End Function

Function Test_CreateShortName() As Boolean
    '' Tests the CreateShortName function by verifying it creates the correct short name from a given string.
    '' Returns True if the short name is correct, False otherwise.
    
    Dim originalName As String
    Dim expectedShortName As String
    Dim actualShortName As String
    
    originalName = "EarlyDetection_Processes_for_100K_Entries"
    expectedShortName = "EDP100KE"
    actualShortName = CreateShortName(originalName)
    
    If actualShortName = expectedShortName Then
        Test_CreateShortName = True
    Else
        Test_CreateShortName = False
        Debug.Print "Test failed: Expected " & expectedShortName & " but got " & actualShortName
    End If
End Function
 
Function Test_CreateTitle() As Boolean
    '' Tests the CreateTitle function by verifying it creates a correctly formatted title from a given string.
    '' Returns True if the title is correctly formatted, False otherwise.
    
    Dim originalString As String
    Dim titleString As String
    Dim expectedString As String
    
    expectedString = "Early Detection Processes Pro 100K Entries"
    originalString = "EarlyDetection_ProcessesPro_100K_Entries"
    titleString = CreateTitle(originalString)

    If titleString = expectedString Then
        Test_CreateTitle = True
    Else
        Test_CreateTitle = False
        Debug.Print "Test failed: Expected " & expectedString & " but got " & titleString
    End If
End Function

Function Test_ExtractFirstWord() As Boolean
    '' Tests the ExtractFirstWord function by verifying it correctly extracts the first word from a given string.
    '' Returns True if the first word is correctly extracted, False otherwise.
    
    Dim originalString As String
    Dim extractedWord As String
    Dim expectedWord As String

    originalString = "EarlyDetection_Processes_Pro_100K_Entries"
    expectedWord = "EarlyDetection"
    extractedWord = ExtractFirstWord(originalString)

    If extractedWord = expectedWord Then
        Test_ExtractFirstWord = True
    Else
        Test_ExtractFirstWord = False
        Debug.Print "Test failed: Expected " & expectedWord & " but got " & extractedWord
    End If
End Function

Function Test_CountWords() As Boolean
    '' Tests the CountWords function by verifying it correctly counts the number of words in a given string.
    '' Returns True if the word count is correct, False otherwise.
    
    Dim testString As String
    Dim wordCount As Integer
    Dim expectedCount As Integer

    testString = "This is a test string with eight words"
    expectedCount = 8
    wordCount = CountWords(testString)

    If wordCount = expectedCount Then
        Test_CountWords = True
    Else
        Test_CountWords = False
        Debug.Print "Test failed: Expected " & expectedCount & " but got " & wordCount
    End If
End Function

Function Test_DefaultRatioTitle() As Boolean
    '' Tests the DefaultRatioTitle function by verifying it correctly formats a ratio string.
    '' Returns True if the ratio string is correctly formatted, False otherwise.
    
    Dim testString As String
    Dim result As String

    testString = "SomePrefix_ExampleWord_Ratio"
    result = DefaultRatioTitle(testString)

    Test_DefaultRatioTitle = result = "Some Prefix / Example Word [%]"
End Function

