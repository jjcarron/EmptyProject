Attribute VB_Name = "m_DB_Definitions_Exporter"
Option Compare Database

'' ==============================================================================
'' Module : m_DB_Definition_Exporter
''
'' Description:
'' This module is designed to export the definitions of all queries in the current
'' Access database to a text file. The exported file contains the SQL definitions
'' of the queries, formatted and structured for readability. It also includes a
'' header with metadata about the export process.
''
'' Key Responsibilities:
'' - Generate a header for the export file containing metadata and structure description.
'' - Export SQL definitions of all queries in the database.
''
'' Usage:
'' 1. Include this module in your VBA project.
'' 2. Call the `ExportQueryDefs` subroutine with the full file path where the definitions
''    should be exported.
'' 3. The exported file will include a header and the SQL definitions of all queries.
''
'' Dependencies:
'' - Requires the `cLogger` class for managing file output and logging.
'' - Utilizes standard VBA Collection objects to manage lines of text.
''
'' ==============================================================================

Function FileHeader(DefType As String) As Collection
    '' Generates a collection of strings representing the header for the exported file.
    ''
    '' Parameters:
    '' - DefType: A string indicating the type of definitions being exported (e.g., "Queries").
    ''
    '' Returns:
    '' - A Collection object containing lines of text for the header.

    Dim Header As New Collection
    Header.Add "' Definitions of the " & DefType & " of the " & FileNameFromPath(CurrentDb.Name) & " database."
    Header.Add ""
    Header.Add "' Created by JJ-Carron with DTT_DB_Utilities"
    Header.Add "' " & Format(Date, "dd.mm.yyyy")
    Header.Add ""
    Header.Add "' File structure:"
    Header.Add "' name = definition;   "
    Header.Add ""
    Header.Add "' Lines beginning with ' are ignored."
    Header.Add "' The name is the last word before the =."
    Header.Add "' The definition includes all the words between the = and the ;."
    Header.Add ""
    Header.Add "' Warning:"
    Header.Add "' - Only ASCII characters are supported."
    Header.Add "' - Spaces in query names are not supported."
    Header.Add ""
    
    Set FileHeader = Header
End Function

Sub ExportQueryDefs(FullName As String, Optional archive As Boolean = True)
    '' Exports the SQL definitions of all queries in the current database to a text file.
    ''
    '' Parameters:
    '' - FullName: The full file path where the query definitions will be exported.
    '' - archive: A boolean indicating whether to archive existing files with the same name
    ''   before exporting. Defaults to True.

    On Error GoTo ErrorHandler

    Dim db As DAO.Database
    Dim qdf As DAO.QueryDef
    Dim QueryDefinitionLines As New Collection
    Dim reporter As New cLogger

    Set db = CurrentDb
    reporter.Initialize FullFileName:=FullName, DebugPrint:=True, archive:=archive  ' Prevent overwriting the current file
    
    For Each qdf In db.QueryDefs
        QueryDefinitionLines.Add qdf.Name & " = "
        QueryDefinitionLines.Add RemoveMultipleSpaces(qdf.sql) & vbCrLf
    Next qdf
    
    reporter.report QueryDefinitionLines, FileHeader("Queries")
    Exit Sub

ErrorHandler:
    MsgBox "An error occurred while exporting query definitions: " & err.Description, vbCritical, "Error"
End Sub


