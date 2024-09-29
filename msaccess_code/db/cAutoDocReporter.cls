VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "cAutoDocReporter"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Compare Database
Option Explicit

'' ==============================================================================
'' Class : cAutoDocReporter
''
'' Description:
'' The `cAutoDocReporter` class is designed to automate the documentation process
'' for a VBA project. It scans the entire project, including all modules, classes,
'' and forms, extracting and organizing the function headers and associated docstrings
'' (lines beginning with two single quotes ''). The output is a text document that
'' provides a structured overview of the project's codebase.
''
'' Key Responsibilities:
'' - Scan and document all standard modules, class modules, and form modules.
'' - Extract function and procedure headers along with their associated docstrings.
'' - Generate a comprehensive text report documenting the entire project.
''
'' Dependencies:
'' - Requires the 'ArrayList' class for managing collections of modules, classes, and forms.
'' - Utilizes the 'cLogger' class for writing the output to a text file.
''
'' Usage:
'' 1. Initialize the `cAutoDocReporter` class with a log file path.
'' 2. Call `DocumentProject` to generate the documentation for the entire project.
''
'' Example:
'' Dim reporter As New cAutoDocReporter
'' reporter.Initialize "C:\Path\To\Documentation.txt"
'' reporter.DocumentProject
''
'' ==============================================================================

Private log As cLogger

'' Initializes the `cAutoDocReporter` instance and sets up the logging mechanism.
''
'' Parameters:
'' - FullFileName: The full path to the log file where the documentation will be saved.
'' - DebugPrint: (Optional) A Boolean indicating whether to print debug information to the console. Default is True.

Sub Initialize(FullFileName As String, Optional DebugPrint As Boolean = True)
    Set log = New cLogger
    log.Initialize FullFileName:=FullFileName, VerbosityLevel:=eAll, DebugPrint:=DebugPrint
End Sub

'' Documents the entire VBA project by scanning all modules, classes, and forms.
'' The results are written to the log file specified during initialization.

Sub DocumentProject()
    Dim Name As String
    Dim el As VBComponent
    Dim Module As Variant
    Dim Modules As New ArrayList
    Dim Classes As New ArrayList
    Dim Forms As New ArrayList
    
    Dim Title As String: Title = "Start of the project documentation"
    log.LogEvent vbCrLf & vbCrLf & Title
    log.LogEvent String(Len(Title), "=")
    
    For Each el In Application.VBE.ActiveVBProject.VBComponents
        Select Case el.Type
            Case vbext_ct_StdModule
                Modules.Add el.Name
            Case vbext_ct_ClassModule
                Classes.Add el.Name
            Case vbext_ct_Document
                Forms.Add el.Name
            Case Else
                ' DO NOTHING
                Name = el.Name
        End Select
    Next
    
    log.LogEvent vbCrLf & "Modules Documentation"

    Modules.Sort
    For Each Module In Modules
        DocumentModule CStr(Module), "Module"
    Next
    
    log.LogEvent vbCrLf & "Classes Documentation"
    Classes.Sort
    For Each Module In Classes
        DocumentModule CStr(Module), "Class"
    Next
    
    log.LogEvent vbCrLf & "Forms Documentation"
    Forms.Sort
    For Each Module In Forms
        DocumentModule CStr(Module), "Form"
    Next
    
    log.LogEvent vbCrLf & vbCrLf & "End of the project documentation" & vbCrLf
End Sub

'' Checks if a given line of code is an autodoc line (starts with two single quotes).
'' If it is, the line is reformatted by removing the leading three characters.
''
'' Parameters:
'' - Line: The line of code to check and potentially reformat.
''
'' Returns:
'' - Boolean: True if the line is an autodoc line, otherwise False.

Function AutoDocLine(ByRef Line As String) As Boolean
    Line = Trim(Line)
    If Left(Line, 2) = "''" Then
        Line = Mid(Line, 4)
        AutoDocLine = True
    Else
        AutoDocLine = False
    End If
End Function

'' Documents a single module (standard module, class module, or form module).
'' The module's name and type are logged, followed by the function headers and
'' autodoc lines contained within the module.
''
'' Parameters:
'' - Name: The name of the module to document.
'' - ModType: The type of the module (e.g., "Module", "Class", "Form").

Sub DocumentModule(Name As String, ModType As String)
    Dim LineNum As Long
    Dim NumLines As Long
    Dim LastProcName As String
    Dim ProcName As String
    Dim CodeMod As Variant
    Dim Line As String
    Dim Kind As Long

    Set CodeMod = CurrentProject.Application.VBE.ActiveVBProject.VBComponents(Name).CodeModule
    
    log.LogEvent vbCrLf & String(1, vbTab) & ModType & " : " & Name
    
    With CodeMod
        LineNum = 1
        ProcName = ""
        LastProcName = ""
        Do Until LineNum >= .CountOfLines
            Line = .lines(LineNum, 1)
            If AutoDocLine(Line) Then
                log.LogEvent String(3, vbTab) & Line
            Else
                ProcName = .ProcOfLine(LineNum, Kind) ' Kind is passed by reference and returned here
                If LastProcName <> ProcName Then
                    If LineNum = .ProcBodyLine(ProcName, Kind) Then
                        log.LogEvent vbCrLf & String(2, vbTab) & Trim(.lines(LineNum, 1))
                        LastProcName = ProcName
                    End If
                End If
            End If
            LineNum = LineNum + 1
        Loop
    End With
End Sub

