VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "cLogger"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'' Class : cLogger
''
'' This class manages the logging mechanism.
''
'' It allows reporting errors or information to a file and on the debug console.
'' The class can be used to write to any files and supports different levels of verbosity.

Private myFile As TextStream
Private myFullFileName As String
Private myFileName As String
Private myPath As String
Private myDebugPrint As Boolean
Private myLogVerbosity As Verbosity
Private myFSO As New FileSystemObject

Public Enum Verbosity
    eNONE = 0
    eError = 1
    eWarning = 2
    eInfo = 3
    eAll = 4
End Enum

Property Get Filename() As String
    '' Returns the name of the log file.
    If myFullFileName <> "" Then
        Filename = Right(myFullFileName, Len(myFullFileName) - InStrRev(myFullFileName, "\", Len(myFullFileName)))
    Else
        Filename = ""
    End If
End Property

Property Get Path() As String
    '' Returns the path where the log file is located.
    If myFullFileName <> "" Then
        Path = Left(myFullFileName, InStrRev(myFullFileName, "\", Len(myFullFileName)))
    Else
        Path = ""
    End If
End Property

Property Get FullName() As String
    '' Returns the full path and name of the log file.
    FullName = myPath & myFileName
End Property

Property Get currentLine() As Long
    '' Returns the current line number in the log file.
    currentLine = myFile.Line
End Property

Property Get FileAlreadyOpen(Name As String) As Boolean
    '' Returns True if the specified file is already open in the logger, False otherwise.
    FileAlreadyOpen = (Name = myFileName)
End Property

Private Property Get archiveName(Filename As String) As String
    '' Generates a timestamped archive name for the log file to avoid overwriting existing files.
    Dim t As Date
    Dim Prefix As String
    t = Now

    Prefix = "A" & Year(t) & Format(Month(t), "00") & Format(Day(t), "00") & _
            "_" & Format(Hour(t), "00") & Format(Minute(t), "00") & Format(Second(t), "00") & _
            "_"
    archiveName = Prefix & (Filename)
End Property

Sub LogEvent(ByVal Line As String, Optional VerbosityLevel As Verbosity = eError)
    '' Logs an event to the file and optionally to the debug console if the verbosity level is high enough.
    '' Parameters:
    ''   - Line: The text to log.
    ''   - VerbosityLevel: The verbosity level at which to log this event.
    If VerbosityLevel <= myLogVerbosity Then
        myFile.WriteLine Line
        If myDebugPrint Then
            Debug.Print Line
        End If
        DoEvents ' Allow other events to be processed
    End If
End Sub

Sub resetFile(Optional Filename As String = "")
    '' Closes the current log file and creates a new one. If an archive is enabled,
    '' the old file will be archived with a timestamp.
    '' Parameters:
    ''   - Filename: Optional. The name of the new log file. If omitted, the current name is used.
    If Not myFile Is Nothing Then
        myFile.Close
    End If
    If Filename <> "" Then
        If myArchive Then
            myFileName = archiveName(Filename)
        Else
            myFileName = Filename
        End If
    End If

    Set myFile = myFSO.CreateTextFile(FullName)
End Sub

Sub report(Col As Collection, Optional HeaderLines As Collection = Nothing, Optional VerbosityLevel As Verbosity = eError)
    '' Logs a collection of lines to the log file. Optionally, a header can be added before the collection.
    '' Parameters:
    ''   - Col: A collection of strings to log.
    ''   - HeaderLines: Optional. A collection of header strings to log before the main collection.
    ''   - VerbosityLevel: The verbosity level at which to log this report.
    If VerbosityLevel <= myLogVerbosity Then
        If Not HeaderLines Is Nothing Then
            If Col.count > 0 And HeaderLines.count > 0 Then
                For Each h In HeaderLines
                    LogEvent h
                Next
            End If
        End If
        If Col.count = 0 Then
            LogEvent "" ' Insert a blank line
        Else
            For Each P In Col
                LogEvent P
            Next
        End If
    End If
End Sub

Sub Initialize(FullFileName As String, Optional VerbosityLevel As Verbosity = eAll, Optional DebugPrint As Boolean = False, Optional archive As Boolean = False)
    '' Initializes the logger by creating the log file and setting the verbosity level and other options.
    '' Parameters:
    ''   - FullFileName: The full path and name of the log file.
    ''   - VerbosityLevel: Optional. The verbosity level to use for logging. Default is eAll.
    ''   - DebugPrint: Optional. If True, also prints logs to the debug console. Default is False.
    ''   - archive: Optional. If True, archives previous log files instead of overwriting them. Default is False.
    Set myFSO = CreateObject("Scripting.FileSystemObject")
    myLogVerbosity = VerbosityLevel
    myDebugPrint = DebugPrint
    myFullFileName = FullFileName
    myPath = Path
    myArchive = archive
    If myArchive Then
        myFileName = archiveName(Filename)
    Else
        myFileName = Filename
    End If
    Set myFile = myFSO.CreateTextFile(FullName)
End Sub

Sub Class_Terminate()
    '' Ensures that the log file is properly closed when the logger object is destroyed.
    myFile.Close
End Sub


