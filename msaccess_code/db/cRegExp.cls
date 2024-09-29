VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "cRegExp"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'' Class : cRegExp
''
'' This class simplifies the usage of regular expressions (regex) in VBA.
'' It provides functionality to match text against regex patterns.
'' The Library VBScript_RegExp_55.Regexp should be added to the references of the project.

Public reg As VBScript_RegExp_55.Regexp
Public myMatches As VBScript_RegExp_55.MatchCollection

Public Function Match_Pattern(ByVal Text As String, ByVal pattern As String, Optional GlobalSearch As Boolean = True, Optional MultiLine As Boolean = True, Optional IgnoreCase As Boolean = True) As Boolean
    '' Matches the provided text against the given regex pattern.
    '' Returns True if there is a match and stores the match collection in myMatches.
    '' Parameters:
    ''   - Text: The text to search for the pattern.
    ''   - pattern: The regex pattern to match.
    ''   - GlobalSearch: If True, finds all matches in the text; otherwise, only the first match is found.
    ''   - MultiLine: If True, allows the pattern to match across multiple lines.
    ''   - IgnoreCase: If True, ignores case when matching the pattern.

    Dim res As Boolean
    Dim reg As VBScript_RegExp_55.Regexp
    
    Set myMatches = Nothing
    
    Set reg = CreateObject("vbscript.regexp")
    reg.Global = GlobalSearch
    reg.MultiLine = MultiLine
    reg.IgnoreCase = IgnoreCase
    reg.pattern = pattern
    
    If reg.test(Text) Then
        Match_Pattern = True
        Set myMatches = reg.execute(Text)
    Else
        Match_Pattern = False
    End If
End Function

Property Get matches(Optional index As Long = 0) As Collection
    '' Returns a collection of submatches from the regex match collection.
    '' If an index is provided, it returns submatches for that specific match.
    '' Parameters:
    ''   - index: Optional. The index of the match to retrieve submatches from (0-based).
    '' If no matches are found, an empty collection is returned.
    
    Dim Val As Variant
    Dim Col As New Collection
    Dim m As match
    
    If Not myMatches Is Nothing Then
        If myMatches.count > 0 Then
            Set m = myMatches(index)
            For Each Val In m.SubMatches
                Col.Add Val
            Next
        End If
    End If
    
    Set matches = Col
End Property

Property Get regex()
    '' Returns a new instance of the RegExp object.
    Set reg = CreateObject("vbscript.regexp")
    Set regex = reg
End Property

