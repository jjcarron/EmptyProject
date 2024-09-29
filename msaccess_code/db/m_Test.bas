Attribute VB_Name = "m_Test"
Option Compare Database

Const vbext_pk_Get As Integer = 3 'A Property Get procedure.
Const vbext_pk_Let As Integer = 1 'A Property Let procedure.
Const vbext_pk_Set As Integer = 2 'A Property Set procedure.
Const vbext_pk_Proc As Integer = 0 'A Sub or Function procedure.

Const TestModuleNamePrefix As String = "m_Test_"

Sub DoTestSuite()
    '' Initializes the context and runs all test functions in modules with the prefix `m_Test_`.
    '' Outputs the results to the Immediate Window (Debug.Print).
    
    Init_Context
    Dim Name As String
    Dim a As Application
    Set a = CurrentProject.Application
    Dim Module As Variant
    
    Debug.Print vbCrLf & vbCrLf & "New test Sequence" & vbCrLf
    Debug.Print "=================" & vbCrLf
    
    moduleTested = 0
    modulePassed = 0
    
    For Each Module In a.CodeProject.AllModules
        Name = Module.Name
        If InStr(1, Name, TestModuleNamePrefix) = 1 Then
            moduleTested = moduleTested + 1
            If test(Name) Then
                modulePassed = modulePassed + 1
            End If
        End If
    Next
    
    Debug.Print vbCrLf & vbCrLf & modulePassed & "/" & moduleTested & " modules tested successfully" & vbCrLf
End Sub

Function test(Name As String) As Boolean
    '' Runs all procedures in a specified module and checks if they return True.
    ''
    '' Parameters:
    '' - Name: The name of the module to test.
    ''
    '' Returns:
    '' - True if all test procedures pass, False otherwise.
    
    Dim LineNum As Long
    Dim NumLines As Long
    Dim ProcName As String
    Dim CodeMod As Variant
    
    Set CodeMod = CurrentProject.Application.VBE.ActiveVBProject.VBComponents(Name).CodeModule
    
    Debug.Print vbCrLf & "Module " & Name & vbCrLf & vbCrLf
    With CodeMod
        LineNum = .CountOfDeclarationLines + 1
        procTested = 0
        Passed = 0
        Failed = 0

        Do Until LineNum >= .CountOfLines
            ProcName = .ProcOfLine(LineNum, vbext_pk_Proc)
                
            procTested = procTested + 1
            
            Debug.Print Format(procTested, "\ \ 0\ ") & ProcName
            ' assume Failed in case of Error
            resStr = "Failed"
            Failed = Failed + 1
            res = False
            
            res = Eval(ProcName & "()")
            If res Then
                resStr = "Passed"
                Passed = Passed + 1
                Failed = Failed - 1
            End If
            Debug.Print Tab(50), resStr & vbCrLf
        
            LineNum = .ProcStartLine(ProcName, vbext_pk_Proc) + _
                      .ProcCountLines(ProcName, vbext_pk_Proc) + 1
        Loop
    End With
    
    Debug.Print vbCrLf & Passed & "/" & procTested & " Test Passed" & vbCrLf
    test = (Passed = procTested)
End Function







