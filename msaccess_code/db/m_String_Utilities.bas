Attribute VB_Name = "m_String_Utilities"
Function ReplicateQuote(Text As String) As String
    '' Duplicates any single quotes found in the input text.
    ''
    '' Parameters:
    '' - Text: A string in which single quotes will be duplicated.
    ''
    '' Returns:
    '' - A string where each single quote in the original text is duplicated.
    ''
    Dim temp As String
    Dim i As Integer
    temp = Text
    i = InStr(1, Text, "'")
    If i > 0 Then
        temp = Left(Text, i) & "'" & ReplicateQuote(Mid(Text, i + 1))
    End If
    ReplicateQuote = temp
End Function

Function cleanup(Text As String) As String
    '' Cleans up a string by trimming whitespace and removing outer single quotes if they exist.
    ''
    '' Parameters:
    '' - Text: A string that may contain leading and trailing single quotes.
    ''
    '' Returns:
    '' - A string with leading and trailing single quotes removed, if present.
    ''
    Text = Trim(Text)
    i = InStr(1, Text, "'")
    j = InStrRev(Text, "'")
    If j = Len(Text) And i = 1 Then
        Text = Left(Text, j - 1)
        Text = Mid(Text, i + 1)
    End If
    cleanup = Text
End Function

Function EscapeDelim(Text As String) As String
    '' Escapes any single quotes in the input text by duplicating them.
    ''
    '' Parameters:
    '' - Text: A string that may contain single quotes.
    ''
    '' Returns:
    '' - A string with all single quotes escaped by duplication.
    ''
    EscapeDelim = ReplicateQuote(Text)
End Function

Public Function NextCommaPos(ByRef Text As String) As Integer
    '' Finds the position of the next comma in a comma-delimited string, accounting for quoted segments.
    ''
    '' Parameters:
    '' - Text: A comma-delimited string that may contain quoted segments.
    ''
    '' Returns:
    '' - The position of the next comma outside any quoted segments.
    ''
    Dim SQ, EQ, NQ, NNQ
    
    Text = Trim(Text)
    c = InStr(1, Text, ",")
    SQ = InStr(1, Text, "'")
    If SQ = 1 Then 'find EQ
        NQ = InStr(SQ + 1, Text, "'")
        EQFound = False
        Do
            NNQ = InStr(NQ + 1, Text, "'")
            If NNQ = NQ + 1 Then
                NQ = InStr(NNQ + 1, Text, "'")
            Else
              EQFound = True
            End If
        Loop Until EQFound
        EQ = NQ
        c = InStr(1, Text, ",")
        While c > SQ And c < EQ
            c = InStr(c + 1, Text, ",")
        Wend
    End If
    NextCommaPos = c
End Function

Function toDouble(Val As Variant) As Double
    '' Converts a given value to a double, removing any thousand separators.
    ''
    '' Parameters:
    '' - Val: The value to convert, which may be a string or numeric.
    ''
    '' Returns:
    '' - The value converted to a Double, or 0 if conversion is not possible.
    ''
    Dim tempStr As String
    
    If IsNumeric(Val) Then
        toDouble = CDbl(Val)
    Else
        tempStr = Replace(Val, "'", "")
        tempStr = Replace(tempStr, ",", "")
        tempStr = Replace(tempStr, " ", "")
        
        If IsNumeric(tempStr) Then
            toDouble = CDbl(tempStr)
        Else
            toDouble = 0
        End If
    End If
End Function

Function cleanStr(str As String) As String
    '' Cleans a string by retaining only alphanumeric characters, spaces, and certain special characters.
    ''
    '' Parameters:
    '' - str: The input string to be cleaned.
    ''
    '' Returns:
    '' - A cleaned string containing only alphanumeric characters, spaces, and specific special characters.
    ''
    Dim re As New cRegExp
    If str <> "" Then
        re.Match_Pattern str, "([\s0-9a-zA-Z‰ˆ¸ÈË‡˘Íƒ‹÷_'\.]+)", True
        cleanStr = Trim(re.matches.Item(1))
    Else
        cleanStr = str
    End If
End Function

Function RemoveMultipleSpaces(str As String) As String
    '' Removes multiple consecutive spaces in a string, replacing them with a single space.
    ''
    '' Parameters:
    '' - str: The input string potentially containing multiple consecutive spaces.
    ''
    '' Returns:
    '' - A string with multiple spaces reduced to a single space.
    ''
    Dim regex As Object
    Set regex = CreateObject("VBScript.RegExp")
    
    regex.pattern = "\s+"
    regex.Global = True
    
    RemoveMultipleSpaces = regex.Replace(str, " ")
End Function

Function FileNameFromPath(Path As String) As String
    '' Extracts the filename from a full file path.
    ''
    '' Parameters:
    '' - Path: The full file path from which to extract the filename.
    ''
    '' Returns:
    '' - The filename extracted from the path.
    ''
    If Path <> "" Then
        FileNameFromPath = Right(Path, Len(Path) - InStrRev(Path, "\", Len(Path)))
    Else
        FileNameFromPath = ""
    End If
End Function

Function AddSemicolonIfMissing(str As String) As String
    '' Ensures that a string ends with a semicolon.
    ''
    '' Parameters:
    '' - str: The input string to check.
    ''
    '' Returns:
    '' - The string with a semicolon appended if it was missing.
    ''
    If Right(str, 1) <> ";" Then
        str = str & ";"
    End If
    AddSemicolonIfMissing = str
End Function

Function CreateShortName(inputString As String) As String
    '' Generates a short name by extracting capital letters and digits from a string.
    ''
    '' Parameters:
    '' - inputString: The input string from which to generate a short name.
    ''
    '' Returns:
    '' - A short name composed of capital letters and digits from the input string.
    ''
    Dim regex As Object
    Dim matches As Object
    Dim match As Object
    Dim resultString As String

    Set regex = CreateObject("VBScript.RegExp")
    regex.pattern = "[A-Z0-9]"
    regex.Global = True
    
    resultString = ""
    Set matches = regex.execute(inputString)
    
    For Each match In matches
        resultString = resultString & match.value
    Next match
    
    CreateShortName = resultString
End Function

Function CreateTitle(inputString As String) As String
    '' Converts a string to title format, replacing underscores with spaces and adding spaces before capital letters.
    ''
    '' Parameters:
    '' - inputString: The input string to format as a title.
    ''
    '' Returns:
    '' - The title-formatted string.
    ''
    Dim regex As Object
    Dim resultString As String

    inputString = Replace(inputString, "_", " ")
    Set regex = CreateObject("VBScript.RegExp")
    regex.pattern = "([a-z])([A-Z])"
    regex.Global = True

    resultString = regex.Replace(inputString, "$1 $2")
    CreateTitle = resultString
End Function

Function ExtractFirstWord(inputString As String) As String
    '' Extracts the first word from a string, defined as the characters before the first underscore or space.
    ''
    '' Parameters:
    '' - inputString: The input string from which to extract the first word.
    ''
    '' Returns:
    '' - The first word from the input string, or an empty string if no word is found.
    ''
    Dim regex As Object
    Dim matches As Object

    Set regex = CreateObject("VBScript.RegExp")
    regex.pattern = "^[^_ ]+"
    regex.Global = False
    
    Set matches = regex.execute(inputString)
    
    If matches.count > 0 Then
        ExtractFirstWord = matches(0).value
    Else
        ExtractFirstWord = ""
    End If
End Function

Function CountWords(inputString As String) As Integer
    '' Counts the number of words in a string.
    ''
    '' Parameters:
    '' - inputString: The input string in which to count words.
    ''
    '' Returns:
    '' - The number of words in the input string.
    ''
    Dim regex As Object
    Dim matches As Object

    Set regex = CreateObject("VBScript.RegExp")
    regex.pattern = "\b\w+\b"
    regex.Global = True
    
    Set matches = regex.execute(inputString)
    CountWords = matches.count
End Function

Function DefaultRatioTitle(inputString As String) As String
    '' Generates a default title for ratio expressions in a string by extracting components and formatting them.
    ''
    '' Parameters:
    '' - inputString: The input string containing a ratio expression.
    ''
    '' Returns:
    '' - A formatted title string for the ratio, or "No match found" if no ratio expression is identified.
    ''
    Dim regex As Object
    Dim matches As Object
    Dim resultString As String

    Set regex = CreateObject("VBScript.RegExp")
    regex.pattern = "^(.*_)([^_]+)_Ratio$"
    regex.Global = False
    
    Set matches = regex.execute(inputString)
    
    If matches.count > 0 Then
        resultString = Trim(CreateTitle(matches(0).SubMatches(0))) & " / " & Trim(CreateTitle(matches(0).SubMatches(1))) & " [%]"
    Else
        resultString = "No match found"
    End If
    
    DefaultRatioTitle = resultString
End Function

