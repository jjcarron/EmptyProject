VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "cDB"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Compare Database

'' Class : cDB
''
'' This class implements the function to create, load, and update the database.

Private cnn As New ADODB.Connection
Private cmd As New ADODB.Command

Private dbTablesDefs As New cDB_Definitions
Private dbViewsDefs As New cDB_Definitions
Private dbIndexesDefs As New cDB_Definitions

Private error As String

Property Get Done(Optional error As String) As Boolean
    '' Returns True if no error occurred, otherwise False.
    Done = error = ""
End Property

Sub CreateTables()
    '' Creates all the database tables using the definitions provided in the external file.
    Dim definition As cDB_Definition
    Dim inst As New cDB_Instruction
    
    For Each definition In dbTablesDefs.definitions
        inst.InitQry ("CREATE TABLE " & definition.Name & "(" & definition.definition & ")")
        inst.execute
    Next
End Sub

Sub AddIndexes()
    '' Adds indexes to the database tables using the definitions provided in the external file.
    Dim definition As cDB_Definition
    Dim inst As New cDB_Instruction
    
    For Each definition In dbIndexesDefs.definitions
        inst.InitQry (definition.definition)
        inst.execute
    Next
End Sub

Sub DeleteConstraints()
    '' Deletes the constraints from all tables to allow for their deletion.
    Dim definition As cDB_Definition
    Dim inst As New cDB_Instruction
    On Error Resume Next ' Ignore errors for already deleted tables
    For Each definition In dbTablesDefs.definitions
        temp = UCase(definition.definition)
        i = InStr(1, temp, "CONSTRAINT")
        While i > 0
            temp = LTrim(Mid(temp, i + 11))
            k = InStr(1, temp, " ")
            constraintName = Left(temp, k - 1)
            inst.InitQry ("ALTER TABLE " & definition.Name & " DROP CONSTRAINT " & constraintName)
            inst.execute
            i = InStr(1, temp, "CONSTRAINT")
        Wend
    Next
    On Error GoTo 0
End Sub

Sub DeleteTables()
    '' Deletes all the tables defined in the external file.
    Dim inst As New cDB_Instruction
    Dim definition As cDB_Definition
    For Each definition In dbTablesDefs.definitions
        inst.InitQry ("DROP TABLE " & definition.Name)
        inst.execute
    Next
End Sub

Sub CreateViews()
    '' Creates all the views (queries) using the definitions provided in the external file.
    Dim definition As cDB_Definition
    Dim SQLString As String
    Dim qdf As DAO.QueryDef
    On Error Resume Next
    For Each definition In dbViewsDefs.definitions
        SQLString = AddSemicolonIfMissing(definition.definition)
        Set qdf = CurrentDb.CreateQueryDef(Name:=definition.Name, SQLtext:=SQLString)
        If qdf Is Nothing Then
            log.LogEvent definition.Name & " = " & SQLString, eWarning
        End If
        Set qdf = Nothing
    Next
End Sub

Sub DeleteView(Name As String)
    '' Deletes a single view (query) by name.
    Dim inst As New cDB_Instruction
    On Error Resume Next ' Ignore errors for already deleted views
    inst.InitQry ("DROP VIEW " & Name)
    inst.execute
    On Error GoTo 0
End Sub

Sub DeleteTable(Name As String)
    '' Deletes a single table by name.
    Dim inst As New cDB_Instruction
    On Error Resume Next ' Ignore errors for already deleted tables
    inst.InitQry ("DROP TABLE " & Name)
    inst.execute
    On Error GoTo 0
End Sub

Function DeleteViews() As Boolean
    '' Deletes all the views (queries) defined in the external file.
    Dim definition As cDB_Definition
    For Each definition In dbViewsDefs.definitions
        DeleteView Name:=definition.Name
    Next
End Function

Sub addData(Data As cXL_Data)
    '' Adds data from an external Excel source into the database.
    Dim inst As New cDB_Instruction
    Dim i As Integer
    On Error GoTo errHandler
    For Each lSheet In Data.dataSheets
        With inst
            i = 1
            While i <= lSheet.rowCount
                If lSheet.record(i).count > 0 Then
                    .Initialize action:=eCreateRow, Table:=lSheet.tableName, _
                                record:=lSheet.record(i)
                    .execute
                End If
                i = i + 1
            Wend
        End With
    Next
    Exit Sub
errHandler:
    log.LogEvent inst.cmdText & " cannot be executed. Check the tablename and the columnnames", eError
    Resume Next
End Sub

Sub RemoveFiles()
    '' Clears the 'SokFiles' table.
    Dim inst As New cDB_Instruction
    On Error GoTo errHandler
    inst.InitQry ("DELETE * FROM SokFiles;")
    inst.execute
    Exit Sub
errHandler:
    log.LogEvent inst.cmdText & " cannot be executed. Check the tablename and the columnnames", eError
    Resume Next
End Sub

Sub addFiles(files As Collection)
    '' Loads the files into the 'SokFiles' table.
    Dim f As cDB_SOKFile
    Dim inst As New cDB_Instruction
    RemoveFiles
    For Each f In files
        With inst
            .Initialize action:=eCreateRow, Table:="SokFiles", _
                        record:=f.record
            .execute
        End With
    Next
End Sub

Sub reloadViews()
    '' Reloads all the views from the definitions file.
    Set dbViewsDefs = New cDB_Definitions
    dbViewsDefs.Initialize (DbDefPath & Common_ViewsDef_FileName)
    DeleteViews
    CreateViews
End Sub

Sub DeleteDB()
    '' Deletes the entire database including views, constraints, and tables.
    DeleteViews
    DeleteConstraints
    DeleteTables
End Sub

Sub CreateDB()
    '' Creates the database from scratch using the definitions provided.
    CreateTables
    CreateViews
    AddIndexes
End Sub

Sub newDB()
    '' Deletes and recreates the database.
    initDefinitions
    DeleteDB
    CreateDB
End Sub

Private Sub initDefinitions()
    '' Initializes the database definitions by reading them from the external files.
    Init_Path
    dbTablesDefs.Initialize (DbDefPath & Common_TablesDef_FileName)
    dbViewsDefs.Initialize (DbDefPath & Common_ViewsDef_FileName)
    dbIndexesDefs.Initialize (DbDefPath & Table_Indexes_FileName)
End Sub

Private Sub Class_Initialize()
    '' Class initialization logic. Definitions initialization is done explicitly.
    'initDefinitions ' is done explicitly
End Sub

Private Sub Class_Terminate()
    '' Class termination logic.
    'statements
End Sub


