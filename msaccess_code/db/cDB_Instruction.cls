VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "cDB_Instruction"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'' Class : cDB_Instruction
''
'' This class provides the low-level interface to access the database
'' with SQL Statements.

Option Compare Database

Public Enum eAction
    eCreateRow
    eReadRow
    eUpdateRow
    eUpdateOrCreateRow
    eDeleteRow
    eExecuteQuery
End Enum

Private cnn As New ADODB.Connection
Private cmd As New ADODB.Command
Private myRecord As New cDB_Record
Private myAction As eAction
Private myPreCondition As String
Private myPostCondition As String
Private myTable As String
Private myWhere As String
Private myColumns As String
Private myValues As String
Private myQuery As String

Private Sub connect()
    '' Establishes a connection to the current database.
    Set cnn = CurrentProject.Connection
    cmd.ActiveConnection = cnn
End Sub

Private Sub disconnect()
    '' Closes the connection to the database.
    Set cnn = Nothing
End Sub

Property Get cmdText() As String
    '' Returns the SQL command text currently set in the command object.
    cmdText = cmd.CommandText
End Property

Function RemoveExtraQuotes(str As String) As String
    '' Removes extra quotes from a string if they exist at both the start and end.
    If Left(str, 1) = "'" And Right(str, 1) = "'" Then
        RemoveExtraQuotes = Mid(str, 2, Len(str) - 2)
    Else
        RemoveExtraQuotes = str
    End If
End Function

Function FormatValueForSQL(value As Variant) As String
    '' Formats a given value for use in an SQL statement, converting it to a string
    '' appropriate for its data type (e.g., Boolean, Integer, String, Date, etc.).
    Dim valueType As String
    valueType = TypeName(value)
    
    Select Case valueType
        Case "Boolean"
            FormatValueForSQL = IIf(value, "1", "0")
        Case "Integer", "Long", "Byte", "Single", "Double", "Decimal"
            FormatValueForSQL = Replace(CStr(value), ",", ".")
        Case "String"
            value = RemoveExtraQuotes(CStr(value))
            FormatValueForSQL = "'" & Replace(value, "'", "''") & "'"
        Case "Date"
            FormatValueForSQL = "#" & Format(value, "yyyy-mm-dd") & "#"
        Case "Null"
            FormatValueForSQL = "NULL"
        Case Else
            FormatValueForSQL = "NULL"
            Debug.Print "Unsupported type: " & valueType
    End Select
End Function

Private Sub prepareSQL_Data()
    '' Prepares SQL data by iterating over fields in the record and
    '' building a list of columns and corresponding values for the SQL statement.
    Dim Field As cDB_Field
    myColumns = ""
    myValues = ""

    For Each Field In myRecord.fields
        myColumns = myColumns & Field.column & ", "
        myValues = myValues & FormatValueForSQL(Field.value) & " ,"
    Next
    If myColumns <> "" Then
        i = InStrRev(myColumns, ",")
        myColumns = Left(myColumns, i - 1)
    End If
    If myValues <> "" Then
        i = InStrRev(myValues, ",")
        myValues = Left(myValues, i - 1)
    End If
End Sub

Private Function createRec() As Boolean
    '' Creates a new record in the database by executing an INSERT SQL statement.
    Dim rst As ADODB.Recordset
    Dim sql As String
    On Error GoTo errHandler
    prepareSQL_Data
    With cmd
        .CommandText = "INSERT INTO " & myTable & " (" & myColumns & ") VALUES (" & myValues & ")"
        .execute
    End With

    createRec = True
    Exit Function
    
errHandler:
     log.LogEvent cmd.CommandText & " could not be executed", eError
     createRec = False

End Function

Private Function executeQuery(Optional ByRef records As cDB_Records) As Boolean
    '' Executes a custom SQL query and optionally returns the results in a cDB_Records collection.
    Dim rst As New ADODB.Recordset
    Dim Field As cDB_Field
    Dim record As cDB_Record
    Set records = New cDB_Records

    On Error GoTo errHandler
    With cmd
        .CommandText = myQuery
        .execute
    End With
    executeQuery = True
    Exit Function
    
errHandler:
     log.LogEvent cmd.CommandText & " could not be executed", eError
     log.LogEvent err.Source & ": " & err.Description
     executeQuery = False

End Function

Private Function readRec(ByRef records As cDB_Records) As Boolean
    '' Reads records from the database based on the specified criteria
    '' and returns the results in a cDB_Records collection.
    Dim rst As New ADODB.Recordset
    Dim openStr As String
    Dim Field As cDB_Field
    Dim record As cDB_Record
    Set records = New cDB_Records

    On Error GoTo errHandler
    prepareSQL_Data
    If myPreCondition <> "" Then
        openStr = "SELECT " & myPreCondition & "(" & myColumns & ")" & " FROM " & myTable
    Else
        openStr = "SELECT " & myColumns & " FROM " & myTable
    End If
    If myWhere <> "" Then
        openStr = openStr & " WHERE " & myWhere
    End If
    openStr = openStr & " " & myPostCondition
    rst.Open openStr, cnn, adOpenKeyset
    While Not rst.EOF
        Set record = New cDB_Record
        Dim Col As Variant
        For Each f In rst.fields
            Set Field = New cDB_Field
            Field.Initialize Col:=f.Name, Val:=f.value
            record.Add Field
        Next
        records.Add record:=record
        rst.MoveNext
    Wend
    rst.Close
    readRec = True
    Exit Function
    
errHandler:
     readRec = False
     log.LogEvent openStr & " could not be executed", eError
End Function

Private Function get_SET_Statment() As String
    '' Generates an SQL SET statement by iterating over the fields in the record,
    '' formatting each field as "column = value".
    Dim setInstruction As String
    Dim Field As cDB_Field

    setInstruction = "SET "
    For Each Field In myRecord.fields
        setInstruction = setInstruction & " " & Field.column & " = " & FormatValueForSQL(Field.value) & ","
    Next
    i = InStrRev(setInstruction, ",")
    setInstruction = Left(setInstruction, i - 1)
    get_SET_Statment = setInstruction
End Function

Private Function UpdateOrCreateRec() As Boolean
    '' Updates a record if it exists or creates a new one if it doesn't.
    Dim rst As New ADODB.Recordset
    On Error GoTo errHandler
    prepareSQL_Data
    With cmd
        rst.Open "SELECT " & myColumns & " FROM " & myTable & " WHERE " & myWhere, cnn, adOpenKeyset
        If Not rst.EOF Then
            .CommandText = "UPDATE " & myTable & " " & get_SET_Statment & " WHERE " & myWhere
            rst.Close
            .execute
        Else
            .CommandText = "INSERT INTO " & myTable & " (" & myColumns & ") VALUES (" & myValues & ")"
            rst.Close
            .execute
        End If
        UpdateOrCreateRec = True
    End With
    Exit Function
errHandler:
     UpdateOrCreateRec = False
     log.LogEvent cmd.CommandText & " could not be executed", eError
End Function

Private Function updateRec() As Boolean
    '' Updates a record in the database by executing an UPDATE SQL statement.
    Dim rst As New ADODB.Recordset
    On Error GoTo errHandler
    prepareSQL_Data
    With cmd
        .CommandText = "UPDATE " & myTable & " " & get_SET_Statment & " WHERE " & myWhere
        .execute
        updateRec = True
    End With
    Exit Function
    
errHandler:
     updateRec = False
     log.LogEvent cmd.CommandText & " could not be executed", eError
End Function

Private Function deleteRec() As Boolean
    '' Deletes a record from the database by executing a DELETE SQL statement.
    On Error GoTo errHandler
    With cmd
        If myWhere <> "" Then
            .CommandText = "DELETE FROM " & myTable & " WHERE " & myWhere
        Else
            .CommandText = "DELETE FROM " & myTable
        End If
        .execute
    End With
    deleteRec = True
    Exit Function
    
errHandler:
     deleteRec = False
     log.LogEvent cmd.CommandText & " could not be executed", eError
End Function

Public Function ExistsTable(ByVal Table As String) As Boolean
    '' Checks if a specified table exists in the database.
    Dim rst As New ADODB.Recordset
    On Error GoTo errHandler
    rst.Open "SELECT * FROM " & Table & " WHERE 1=0", cnn, adOpenKeyset
    rst.Close
    ExistsTable = True
    Exit Function
    
errHandler:
     ExistsTable = False
End Function

Sub InitQry(Query As String)
    '' Initializes the SQL command to be executed.
    myAction = eExecuteQuery
    myQuery = Query
    myTable = ""
    myWhere = ""
End Sub

Public Function Max(Table As String, column As String, _
                    Optional Where As String = "", Optional PostCondition As String = "", Optional default As Variant = 0) As Variant
    '' Retrieves the maximum value from a specified column in a table.
    Dim lrec As New cDB_Records
    InitFromStr action:=eReadRow, Table:=Table, columns:=column, Where:=Where, PreCondition:="MAX"
    execute records:=lrec
    Max = default
    If lrec.count > 0 Then
        With lrec.Item(1)
            If .count > 0 Then
                If VarType(.column(1).value) <> vbNull Then
                    Max = .column(1).value
                End If
            End If
        End With
    End If
End Function

Public Function Min(Table As String, column As String, _
                    Optional Where As String = "", Optional PostCondition As String = "", Optional default As Variant = 0) As Variant
    '' Retrieves the minimum value from a specified column in a table.
    Dim lrec As New cDB_Records
    Me.InitFromStr action:=eReadRow, Table:=Table, columns:=column, Where:=Where, PreCondition:="MIN"
    execute records:=lrec
    Min = default
    If lrec.count > 0 Then
        With lrec.Item(1)
            If .count > 0 Then
                If VarType(.column(1).value) <> vbNull Then
                    Min = .column(1).value
                End If
            End If
        End With
    End If
End Function

Public Function Last(Table As String, column As String, _
                    Optional Where As String = "", Optional PostCondition As String = "", Optional default As Variant = 0) As Variant
    '' Retrieves the last value from a specified column in a table.
    Dim lrec As New cDB_Records
    InitFromStr action:=eReadRow, Table:=Table, columns:=column, Where:=Where, PreCondition:="LAST"
    execute records:=lrec
    Last = default
    If lrec.count > 0 Then
        With lrec.Item(1)
            If .count > 0 Then
                If VarType(.column(1).value) <> vbNull Then
                    Last = .column(1).value
                End If
            End If
        End With
    End If
End Function

Public Function First(Table As String, column As String, _
                    Optional Where As String = "", Optional PostCondition As String = "", Optional default As Variant = 0) As Variant
    '' Retrieves the first value from a specified column in a table.
    Dim lrec As New cDB_Records
    Me.InitFromStr action:=eReadRow, Table:=Table, columns:=column, Where:=Where, PreCondition:="FIRST"
    execute records:=lrec
    First = default
    If lrec.count > 0 Then
        With lrec.Item(1)
            If .count > 0 Then
                If VarType(.column(1).value) <> vbNull Then
                    First = .column(1).value
                End If
            End If
        End With
    End If
End Function

Public Function Sum(Table As String, column As String, _
                    Optional Where As String = "", Optional PostCondition As String = "", Optional default As Integer = 0) As Integer
    '' Retrieves the sum of values from a specified column in a table.
    Dim lrec As New cDB_Records
    Me.InitFromStr action:=eReadRow, Table:=Table, columns:=column, Where:=Where, PreCondition:="SUM"
    execute records:=lrec
    Sum = default
    If lrec.count > 0 Then
        With lrec.Item(1)
            If .count > 0 Then
                If VarType(.column(1).value) <> vbNull Then
                    Sum = .column(1).value
                End If
            End If
        End With
    End If
End Function

Public Sub InitFromStr(action As eAction, Table As String, Optional columns As String, Optional values As String, _
                      Optional Where As String = "", _
                      Optional PreCondition As String = "", _
                      Optional PostCondition As String = "")
    '' Initializes the record object from a string, setting action, table, columns, values, and conditions.
    myAction = action
    myTable = Table
    myWhere = Where
    myPreCondition = PreCondition
    myPostCondition = PostCondition
    myRecord.Initialize columns:=columns, values:=values
End Sub

Public Sub Initialize(action As eAction, Table As String, Optional record As cDB_Record, _
                      Optional Where As String = "", _
                      Optional PreCondition As String, _
                      Optional PostCondition As String)
    '' Initializes the record object from a cDB_Record object, setting action, table, where clause, and conditions.
    myAction = action
    myTable = Table
    myWhere = Where
    myPreCondition = PreCondition
    myPostCondition = PostCondition
    Set myRecord = record
End Sub

Public Function execute(Optional ByRef records As cDB_Records) As Boolean
    '' Executes the SQL command based on the action type (e.g., create, read, update, delete, etc.).
    Select Case myAction
        Case eCreateRow
          execute = createRec()
          Exit Function
        Case eReadRow
          execute = readRec(records)
          Exit Function
        Case eUpdateRow
          execute = updateRec()
          Exit Function
        Case eUpdateOrCreateRow
          execute = UpdateOrCreateRec()
          Exit Function
        Case eDeleteRow
          execute = deleteRec()
          Exit Function
        Case eExecuteQuery
          execute = executeQuery()
          Exit Function
    End Select
    execute = False
End Function
    
Private Sub Class_Initialize()
    '' Initializes the class, establishing a connection to the database.
    connect
End Sub

Private Sub Class_Terminate()
    '' Terminates the class, closing the connection to the database.
    disconnect
End Sub


