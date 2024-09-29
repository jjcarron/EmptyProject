Attribute VB_Name = "m_DB_Utilities"
Option Compare Database
Option Base 1

Function HasTable(tableName As String) As Boolean
    '' Checks if a table exists in the current database.
    ''
    '' Parameters:
    '' - tableName: The name of the table to check.
    ''
    '' Returns:
    '' - True if the table exists, otherwise False.

    Dim db As Database
    Dim tbldef As TableDef
    Set db = CurrentDb
    On Error Resume Next
    Set tbldef = db.TableDefs(tableName)
    HasTable = (err.Number = 0)
    err.Clear
End Function

Function hasIndex(Idxs As Indexes, index As String) As Boolean
    '' Checks if an index exists in the provided index collection.
    ''
    '' Parameters:
    '' - Idxs: The collection of indexes to check.
    '' - index: The name of the index to look for.
    ''
    '' Returns:
    '' - True if the index exists, otherwise False.

    Dim Idx As index
    On Error Resume Next
    Set Idx = Idxs(index)
    hasIndex = (err.Number = 0)
    err.Clear
End Function

Function TableHasIndex(tableName As String, index As String) As Boolean
    '' Checks if a table has a specific index.
    ''
    '' Parameters:
    '' - tableName: The name of the table to check.
    '' - index: The name of the index to check.
    ''
    '' Returns:
    '' - True if the table has the index, otherwise False.

    Dim db As Database
    Dim tbldef As TableDef
    Dim Idx As index
    Set db = CurrentDb
    On Error GoTo ErrorHandler:
    Set tbldef = db.TableDefs(tableName)
    On Error Resume Next
    Set Idx = tbldef.Indexes(index)
    TableHasIndex = (err.Number = 0)
    err.Clear
    Exit Function
ErrorHandler:
    log.LogEvent "The table " & tableName & " is not available", eWarning
    TableHasIndex = False
End Function

Function FetchId(Table As String, filter As String, Optional ByRef error As String) As Long
    '' Fetches the ID of the first record matching the filter in the specified table.
    ''
    '' Parameters:
    '' - Table: The name of the table to query.
    '' - filter: The filter criteria to apply.
    '' - error (Optional): An output parameter that returns an error message if the operation fails.
    ''
    '' Returns:
    '' - The ID of the matching record, or 0 if no record is found or an error occurs.

    Dim inst As New cDB_Instruction
    Dim rec As New cDB_Record
    Dim records As New cDB_Records
    
    On Error GoTo errHandler
    With inst
        .InitFromStr action:=eReadRow, Table:=Table, columns:="id", Where:=filter
        .execute records:=records
    End With
    If records.count > 0 Then
        Set rec = records.Item(1)
        FetchId = rec.fields(1).value
        error = ""
        Exit Function
    Else
        FetchId = 0
        error = "No record found with " & inst.cmdText
        Exit Function
    End If

errHandler:
    Debug.Print vbCrLf & inst.cmdText & " cannot be executed. Check the tablename and the index" & vbCrLf
    FetchId = 0
    error = inst.cmdText & " cannot be executed."
End Function

Function FetchItems(Table As String, Optional filter As String = "", Optional ByRef PreCondition As String = "", Optional ByRef PostCondition As String = "", Optional ByRef error As String) As cDB_Records
    '' Fetches records from a table based on the specified filter and conditions.
    ''
    '' Parameters:
    '' - Table: The name of the table to query.
    '' - filter (Optional): The filter criteria to apply.
    '' - PreCondition (Optional): A condition applied before the main query.
    '' - PostCondition (Optional): A condition applied after the main query.
    '' - error (Optional): An output parameter that returns an error message if the operation fails.
    ''
    '' Returns:
    '' - A collection of records that match the criteria, or Nothing if an error occurs.

    Dim inst As New cDB_Instruction
    Dim records As cDB_Records

    On Error GoTo errHandler
    With inst
        .InitFromStr action:=eReadRow, Table:=Table, columns:="*", Where:=filter, PreCondition:=PreCondition, PostCondition:=PostCondition
        .execute records:=records
    End With
    Set FetchItems = records
    error = ""
    Exit Function

errHandler:
    Debug.Print vbCrLf & inst.cmdText & " cannot be executed. Check the tablename and the index" & vbCrLf
    Set FetchItems = Nothing
    error = "Not Found"
End Function

Function RecordCount(Table As String) As Long
    '' Returns the count of records in the specified table.
    ''
    '' Parameters:
    '' - Table: The name of the table to count records in.
    ''
    '' Returns:
    '' - The count of records, or 0 if an error occurs.

    Dim inst As New cDB_Instruction
    Dim records As cDB_Records
    
    On Error GoTo errHandler
    With inst
        .InitFromStr action:=eReadRow, Table:=Table, columns:="*"
        .execute records:=records
    End With
    If records.count > 0 Then
        RecordCount = records.count
    Else
        RecordCount = 0
    End If
    Exit Function
errHandler:
    Debug.Print vbCrLf & inst.cmdText & " cannot be executed. Check the tablename" & vbCrLf
    RecordCount = 0
End Function

Function FetchItem(Table As String, filter As String, Optional ByRef error As String) As cDB_Record
    '' Fetches the first record from a table that matches the specified filter.
    ''
    '' Parameters:
    '' - Table: The name of the table to query.
    '' - filter: The filter criteria to apply.
    '' - error (Optional): An output parameter that returns an error message if the operation fails.
    ''
    '' Returns:
    '' - The matching record, or Nothing if no record is found or an error occurs.

    Dim inst As New cDB_Instruction
    Dim records As cDB_Records
    Dim rec As New cDB_Record
    
    On Error GoTo errHandler
    With inst
        .InitFromStr action:=eReadRow, Table:=Table, columns:="*", Where:=filter
        .execute records:=records
    End With
    If records.count > 0 Then
        Set rec = records.Item(1)
        Set FetchItem = rec
        error = ""
    Else
        Set FetchItem = Nothing
        error = "Not Found"
    End If
    Exit Function
errHandler:
    Debug.Print vbCrLf & inst.cmdText & " cannot be executed. Check the tablename and the index" & vbCrLf
    Set FetchItem = Nothing
    error = "Not Found"
End Function

Sub DeleteLines(Table As String, Optional filter As String = "")
    '' Deletes all lines from a table according to the specified filter.
    '' If no filter is provided, all records in the table are deleted.
    ''
    '' Parameters:
    '' - Table: The name of the table to delete records from.
    '' - filter (Optional): The filter criteria to apply.

    Dim inst As New cDB_Instruction
    
    On Error GoTo errHandler
    With inst
        .InitFromStr action:=eDeleteRow, Table:=Table, columns:="*", Where:=filter
        .execute
    End With
    Exit Sub

errHandler:
    Debug.Print vbCrLf & inst.cmdText & " cannot be executed. Check the tablename and the index" & vbCrLf
End Sub

Sub createTemporaryTable(Table As String, Structure As String)
    '' Creates a temporary table with the specified structure.
    '' If a table with the same name exists, it is deleted first.
    ''
    '' Parameters:
    '' - Table: The name of the table to create.
    '' - Structure: The structure of the table in SQL syntax.

    Dim Query As String
    
    ' Delete if exists
    On Error Resume Next
    DoCmd.Close acTable, Table, acSaveYes
    CurrentDb.TableDefs.Delete Table
    On Error GoTo 0

    Query = "CREATE TABLE " & Table & " (" & Structure & ")"
    CurrentDb.execute Query
End Sub

Function QueryDefinitions() As QueryDefs
    '' Returns the collection of all query definitions in the current database.
    ''
    '' Returns:
    '' - A collection of QueryDefs.

    Set QueryDefinitions = CurrentDb.QueryDefs
End Function

Function QueryDefinition(QueryName As String) As QueryDef
    '' Returns a specific query definition by name.
    ''
    '' Parameters:
    '' - QueryName: The name of the query to retrieve.
    ''
    '' Returns:
    '' - The QueryDef object for the specified query, or Nothing if not found.

    Set QueryDefinition = Nothing
    On Error Resume Next
    Set QueryDefinition = CurrentDb.QueryDefs(QueryName)
    On Error GoTo 0
End Function

Public Function CloseAllObjects(ParamArray varExceptions()) As Boolean
    '' Closes all open database objects except those specified in the exceptions list.
    ''
    '' Parameters:
    '' - varExceptions: A ParamArray of object names to exclude from closing.
    ''
    '' Returns:
    '' - True if the operation completes without errors.

    Dim aob As AccessObject
    Dim varX As Variant
    Dim blnObjectFound As Boolean

    On Error GoTo errHandler

    With CurrentProject
        ' "Forms"
        For Each aob In .AllForms
            If aob.isLoaded Then
                For Each varX In varExceptions
                    If Not (aob Is Nothing) And aob.Name = varX Then
                        blnObjectFound = True
                        Exit For
                    End If
                Next
                If Not blnObjectFound Then DoCmd.Close acForm, aob.Name, acSaveYes
            End If
            blnObjectFound = False ' RESET
        Next aob

        ' "Reports"
        For Each aob In .AllReports
            If Not (aob Is Nothing) And aob.isLoaded Then
                DoCmd.Close acReport, aob.Name, acSaveYes
            End If
        Next aob
        
        ' "Pages"
        For Each aob In .AllDataAccessPages
            If Not (aob Is Nothing) And aob.isLoaded Then
                DoCmd.Close acDataAccessPage, aob.Name, acSaveYes
            End If
        Next aob
        
        ' "Macros"
        For Each aob In .AllMacros
            If Not (aob Is Nothing) And aob.isLoaded Then
                DoCmd.Close acMacro, aob.Name, acSaveYes
            End If
        Next aob
        
        ' "Modules"
        For Each aob In .AllModules
            If Not (aob Is Nothing) And aob.isLoaded Then
                ' DoCmd.Close acModule, aob.Name, acSaveYes ' do not close yet
            End If
        Next aob
        
        Dim tbl As TableDef
        For Each tbl In CurrentDb.TableDefs
            If Not (tbl Is Nothing) Then
                DoCmd.Close acTable, tbl.Name, acSaveYes
            End If
        Next tbl

        ' "Queries"
        Dim Qry As QueryDef
        For Each Qry In CurrentDb.QueryDefs
            If Not (Qry Is Nothing) Then
                DoCmd.Close acQuery, Qry.Name, acSaveYes
            End If
        Next Qry
    End With
    CloseAllObjects = True
    Exit Function
errHandler:
    log.LogEvent "Error " & err.Number & " " & err.Description, eWarning
    CloseAllObjects = False
    Resume Next
End Function

Sub DeleteInvisibleQueries()
    '' Deletes all invisible queries (those whose names start with a "~") from the current database.
    ''
    '' Displays a message box with the count of deleted queries.

    Dim db As DAO.Database
    Dim qdf As DAO.QueryDef
    Dim i As Integer
    Dim queryNames() As String
    Dim count As Integer

    ' Define the current database
    Set db = CurrentDb

    ' Initialize a counter
    count = 1

    ' Loop through all queries in the database
    For Each qdf In db.QueryDefs
        ' Check if the query name starts with "~"
        If Left(qdf.Name, 1) = "~" Then
            ' Add the query name to the array
            ReDim Preserve queryNames(count)
            queryNames(count) = qdf.Name
            count = count + 1
        End If
    Next qdf

    ' Delete the collected queries
    For i = LBound(queryNames) To UBound(queryNames)
        db.QueryDefs.Delete queryNames(i)
    Next i

    ' Release objects
    Set qdf = Nothing
    Set db = Nothing

    MsgBox count - 1 & " invisible queries have been deleted.", vbInformation
End Sub

