Attribute VB_Name = "m_CodeManager"
Option Compare Database
Option Explicit

'' ==============================================================================
'' Module : CodeManager
''
'' Description:
'' This module provides functionality to export and import VBA code modules,
'' classes, and forms from an Access database project. It allows for easy
'' version control and code management by saving and loading code files to and
'' from the file system.
''
'' Key Responsibilities:
'' - Exporting VBA modules, class modules, and forms to the file system.
'' - Importing VBA modules, class modules, and forms back into the project.
''
'' Usage:
'' 1. Call `ExportCode` to save all modules, class modules, and forms to the
''    specified directory.
'' 2. Call `ImportCode` to load the modules, class modules, and forms from the
''    specified directory back into the project.
''
'' Dependencies:
'' - Requires that `dbCodePath` is set to the path where the code files will be
''   saved or loaded from.
'' - Utilizes the `VBE` object model, so the appropriate references need to be set
''   in the VBA editor.
''
'' ==============================================================================

Public Sub ExportCode()
    '' Exports all modules, class modules, and forms in the project to the file system.
    ''
    '' The code modules are saved with their respective extensions (.bas for modules,
    '' .cls for classes, .frm for forms) in the directory specified by `dbCodePath`.
    ''
    '' Usage:
    '' - Ensure `dbCodePath` is set to the desired export directory.
    '' - Call this subroutine to export the code.

    ' Declaration of variables
    Dim tobeSaved As Boolean
    Dim ext As String
    Dim el As VBComponent
    
    For Each el In Application.VBE.ActiveVBProject.VBComponents
        tobeSaved = False
        Select Case el.Type
            Case vbext_ct_StdModule
                ext = ".bas"
                tobeSaved = True
            Case vbext_ct_ClassModule
                ext = ".cls"
                tobeSaved = True
            Case vbext_ct_Document
                ext = ".frm"
                tobeSaved = True
            Case Else
                ' nothing to do
                ext = ""
        End Select
        
        If tobeSaved Then
            el.Export Filename:=dbCodePath & el.Name & ext
        End If
    Next
End Sub

Public Sub ImportCode()
    '' Imports all modules, class modules, and forms from the file system into the project.
    ''
    '' The code modules are loaded from files with their respective extensions (.bas
    '' for modules, .cls for classes, .frm for forms) located in the directory
    '' specified by `dbCodePath`.
    ''
    '' Usage:
    '' - Ensure `dbCodePath` is set to the desired import directory.
    '' - Call this subroutine to import the code.
    '' - Note: Forms cannot be imported correctly and will require manual updates.

    Dim tobeLoaded As Boolean
    Dim c As Integer
    Dim ext As String
    Dim file As String
    Dim el As VBComponent

    For Each el In Application.VBE.ActiveVBProject.VBComponents
        tobeLoaded = False
        ext = ""
        Select Case el.Type
            Case vbext_ct_StdModule
                ext = ".bas"
                tobeLoaded = True
            Case vbext_ct_ClassModule
                ext = ".cls"
                tobeLoaded = True
            Case vbext_ct_Document
                ext = ".frm"
                tobeLoaded = True
            Case Else
                ' nothing to do
        End Select
        
        If tobeLoaded And (el.Name <> "m_CodeManager") Then
            With Application.VBE.ActiveVBProject.VBComponents
                file = Application.CurrentProject.Path & dbCodePath & el.Name & ext
                c = el.Collection.count
                
                If el.Type <> vbext_ct_Document Then
                    .Remove el
                    If el.Collection.count = c Then
                        Debug.Print el.Name & " is in use and could not be removed. It was not updated."
                    Else
                        .Import Filename:=file
                    End If
                Else
                    ' Forms are not imported correctly
                    Debug.Print el.Name & ": Import of Form classes is not supported yet."
                End If
            End With
        End If
    Next
End Sub

