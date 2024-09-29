VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "cDB_Definitions"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'' Class : cDB_Definitions
''
'' This class allows reading simple database definition files and creating a
'' collection of cDB_Definition objects. It is designed to parse and manage
'' definitions from a file, storing them in a collection for easy access.

Option Compare Database

'' A collection to store the cDB_Definition objects
Private myDefinitions As Collection

Property Get definitions() As Collection
    '' Returns the collection of cDB_Definition objects.
    Set definitions = myDefinitions
End Property

Property Get count() As Long
    '' Returns the number of cDB_Definition objects in the collection.
    count = myDefinitions.count
End Property

Private Function ReplaceTab(Line As String) As String
    '' Replaces tab characters in a line with a single space.
    '' This function recursively processes the string to replace all tabs.
    '' Parameters:
    ''   - Line: The input string that may contain tab characters.
    '' Returns:
    ''   - String: The processed string with tabs replaced by spaces.

    Dim temp As String
    temp = Line
    i = InStr(1, Line, Chr(9))
    If i > 0 Then
        temp = Left(Line, i - 1) & " " & ReplaceTab(Mid(Line, i + 1))
    End If
    ReplaceTab = temp
End Function

Private Function CleanupLine(Line As String) As String
    '' Cleans up a line by removing comments and replacing tabs with spaces.
    '' This function also trims leading and trailing spaces from the line.
    '' Parameters:
    ''   - Line: The input string to be cleaned up.
    '' Returns:
    ''   - String: The cleaned-up string.

    If Left(Trim(Line), 1) = "'" Then
        CleanupLine = ""
    Else
        Line = ReplaceTab(Line)
        CleanupLine = Trim(Line)
    End If
End Function

Private Sub AddDefinitions(fStream As String)
    '' Parses a string stream containing multiple definitions and adds them
    '' to the myDefinitions collection as cDB_Definition objects.
    '' Parameters:
    ''   - fStream: The input string containing the definitions separated by semicolons.

    Dim token As String, Name As String, definition As cDB_Definition
    i = InStr(1, fStream, ";")
    While i > 0
        token = Left(fStream, i - 1)
        fStream = Mid(fStream, i + 1)
        k = InStr(1, token, "=")
        If k > 0 Then
            Set definition = New cDB_Definition
            definition.Initialize Name:=Trim(Left(token, k - 1)), definition:=Trim(Mid(token, k + 1))
            myDefinitions.Add definition
        End If
        i = InStr(1, fStream, ";")
    Wend
End Sub

Private Sub ReadFile(Filename As String)
    '' Reads a definition file and processes it into a single string stream.
    '' Each line of the file is cleaned up, and the result is passed to AddDefinitions.
    '' Parameters:
    ''   - Filename: The path to the definition file to be read.

    Const ForReading = 1, ForWriting = 2, ForAppending = 3
    Const TristateUseDefault = -2, TristateTrue = -1, TristateFalse = 0
    
    Dim fs, f, ts
    Dim Line As String, fStream As String
    
    Set fs = CreateObject("Scripting.FileSystemObject")
    Set f = fs.GetFile(Filename)
    Set ts = f.OpenAsTextStream(ForReading, TristateUseDefault)
    
    While Not ts.AtEndOfStream
        Line = ts.readLine
        CleanupLine (Line)
        fStream = fStream & " " & CleanupLine(Line)
    Wend
    ts.Close
    AddDefinitions (fStream)
End Sub

Sub Initialize(Filename As String)
    '' Initializes the class by reading the specified definition file
    '' and creating a collection of cDB_Definition objects.
    '' Parameters:
    ''   - Filename: The path to the definition file to be read.

    Set myDefinitions = New Collection
    ReadFile (Filename)
End Sub

