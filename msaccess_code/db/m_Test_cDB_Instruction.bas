Attribute VB_Name = "m_Test_cDB_Instruction"
Option Compare Database

'' The sequence of the test functions is important because the state of the table is used.
'' This module tests various operations on a test database table using cDB_Instruction.

Private cnn As New ADODB.Connection
Private cmd As New ADODB.Command

Function CreateTestTable() As Boolean
    '' Creates a test table named 'tbl_Testcasinos'.
    '' Returns True if the table is created successfully, False otherwise.
    
    Set cnn = CurrentProject.Connection
    cmd.ActiveConnection = cnn
    
    On Error Resume Next
    ' Delete previously generated table.
    cmd.CommandText = "DROP TABLE tbl_Testcasinos"
    cmd.execute
    
    On Error GoTo errHandler
    cmd.CommandText = "CREATE TABLE tbl_Testcasinos (id INTEGER IDENTITY PRIMARY KEY, City varchar(255), Organisation varchar(255), Test INTEGER)"
    cmd.execute
    
    Set cnn = Nothing
    CreateTestTable = True
    Exit Function

errHandler:
    Set cnn = Nothing
    log.LogEvent vbCrLf & cmd.CommandText & " cannot be executed. Check the table name and the column names." & vbCrLf, eWarning
    CreateTestTable = False
End Function

Function TableExistsInCurrentDB() As Boolean
    '' Checks if the test table 'tbl_Testcasinos' exists in the current database.
    '' Returns True if the table exists, False otherwise.
    
    TableExistsInCurrentDB = HasTable("tbl_Testcasinos")
End Function

Function CreateIndex() As Boolean
    '' Creates an index on the 'Test' column in the test table.
    '' Returns True if the index is created successfully, False otherwise.
    
    Set cnn = CurrentProject.Connection
    cmd.ActiveConnection = cnn
    
    On Error GoTo errHandler
    cmd.CommandText = "CREATE INDEX TestIdx ON tbl_Testcasinos (Test);"
    cmd.execute
    
    Set cnn = Nothing
    CreateIndex = True
    Exit Function

errHandler:
    Set cnn = Nothing
    log.LogEvent vbCrLf & cmd.CommandText & " cannot be executed. Check the table name and the index." & vbCrLf, eWarning
    CreateIndex = False
End Function

Function CreateIndexUsingInstruction() As Boolean
    '' Creates an index on the 'City' column using cDB_Instruction.
    '' Returns True if the index is created successfully, False otherwise.
    
    Dim inst As New cDB_Instruction
    On Error GoTo errHandler
    inst.InitQry ("CREATE INDEX CityIdx ON tbl_Testcasinos (City);")
    CreateIndexUsingInstruction = inst.execute
    Exit Function

errHandler:
    log.LogEvent vbCrLf & inst.cmdText & " cannot be executed. Check the table name and the index." & vbCrLf, eWarning
    CreateIndexUsingInstruction = False
End Function

Function CheckIfIndexNotExist() As Boolean
    '' Checks if the index 'CityXXXIdx' does not exist in the test table.
    '' Returns True if the index does not exist, False otherwise.
    
    Dim db As Database
    Dim tbldef As TableDef
    Dim Idx As index
    Set db = CurrentDb
    Set tbldef = db.TableDefs("tbl_Testcasinos")
    CheckIfIndexNotExist = Not hasIndex(tbldef.Indexes, "CityXXXIdx")
End Function

Function CheckIfIndexExist() As Boolean
    '' Checks if the index 'CityIdx' exists in the test table.
    '' Returns True if the index exists, False otherwise.
    
    Dim db As Database
    Dim tbldef As TableDef
    Dim Idx As index
    Set db = CurrentDb
    
    Set tbldef = db.TableDefs("tbl_Testcasinos")
    CheckIfIndexExist = hasIndex(tbldef.Indexes, "CityIdx")
End Function

Function CheckIfTableHasIndex() As Boolean
    '' Checks if the test table 'tbl_Testcasinos' has the index 'CityIdx'.
    '' Returns True if the index exists, False otherwise.
    
    CheckIfTableHasIndex = TableHasIndex("tbl_Testcasinos", "CityIdx")
End Function

Function TestExistsTable() As Boolean
    '' Tests the ExistsTable method for the test table and a non-existent table.
    '' Returns True if the test passes, False otherwise.
    
    Dim inst As New cDB_Instruction
    TestExistsTable = inst.ExistsTable("tbl_Testcasinos") And Not inst.ExistsTable("nonexistentTable")
End Function

Function AddRecord() As Boolean
    '' Adds a record to the test table and verifies the operation.
    '' Returns True if the record is added successfully, False otherwise.
    
    Dim inst As New cDB_Instruction
    Dim record As New cDB_Record

    On Error GoTo errHandler
    With inst
        record.Initialize columns:="City, Organisation", values:="'Martigny', 'FC Sion'"
        .Initialize action:=eCreateRow, Table:="tbl_Testcasinos", record:=record
        .execute
    End With
    AddRecord = True
    Exit Function

errHandler:
    AddRecord = False
End Function

Function ReadRecord_UsingInitialize() As Boolean
    '' Reads a record from the test table using Initialize method and verifies it.
    '' Returns True if the record matches, False otherwise.
    
    Dim inst As New cDB_Instruction
    Dim record As New cDB_Record
    Dim rec As New cDB_Record
    Dim records As New cDB_Records
    
    ReadRecord_UsingInitialize = False
    With inst
        record.Initialize "City, Organisation"
        .Initialize action:=eReadRow, Table:="tbl_Testcasinos", record:=record, Where:="id=1"
        .execute records:=records
    End With
    Set rec = records.Item(1)
    record.Initialize columns:="City, Organisation", values:="'Martigny', 'FC Sion'"
    ReadRecord_UsingInitialize = rec.IdentiqueAs(record)
End Function

Function ReadRecord_UsingInitializeByString() As Boolean
    '' Reads a record from the test table using InitFromStr method and verifies it.
    '' Returns True if the record matches, False otherwise.
    
    Dim inst As New cDB_Instruction
    Dim record As New cDB_Record
    Dim records As New cDB_Records
    Dim rec As New cDB_Record
    
    ReadRecord_UsingInitializeByString = False
    With inst
        record.Initialize columns:="City, Organisation"
        .InitFromStr action:=eReadRow, Table:="tbl_Testcasinos", columns:="City, Organisation", Where:="id=1"
        .execute records:=records
    End With
    Set rec = records.Item(1)
    record.Initialize columns:="City, Organisation", values:="'Martigny', 'FC Sion'"
    ReadRecord_UsingInitializeByString = rec.IdentiqueAs(record)
End Function

Function AddRecordWithQuotes() As Boolean
    '' Adds a record with quotes in the field values and verifies the operation.
    '' Returns True if the record is added and retrieved successfully, False otherwise.
    
    Dim inst As New cDB_Instruction
    Dim record1 As New cDB_Record
    Dim record2 As New cDB_Record
    Dim records As New cDB_Records
    Dim rec As New cDB_Record
    
    With inst
        record1.Initialize columns:="City, Organisation", values:="'Sati'gny', 'FC Sion'"
        .Initialize action:=eCreateRow, Table:="tbl_Testcasinos", record:=record1
        .execute
        
        record2.Initialize columns:="City, Organisation"
        .Initialize action:=eReadRow, Table:="tbl_Testcasinos", record:=record2, Where:="City LIKE 'Sati''gny'"
        .execute records:=records
    End With
    If records.count > 0 Then
        Set rec = records.Item(1)
        AddRecordWithQuotes = rec.IdentiqueAs(record1)
    Else
        AddRecordWithQuotes = False
    End If
End Function

Function DeleteRecord() As Boolean
    '' Deletes a record from the test table and verifies the operation.
    '' Returns True if the record is deleted successfully, False otherwise.
    
    Dim inst As New cDB_Instruction
    Dim record As New cDB_Record
    Dim records As New cDB_Records
    
    With inst
        .Initialize action:=eDeleteRow, Table:="tbl_Testcasinos", Where:="id=20"
        .execute
        
        record.Initialize columns:="City, Organisation"
        .Initialize action:=eReadRow, Table:="tbl_Testcasinos", record:=record, Where:="id=20"
        .execute records:=records
    End With
    DeleteRecord = records.count = 0
End Function

Function AddAndDeleteRecord() As Boolean
    '' Adds and then deletes a record from the test table, verifying each operation.
    '' Returns True if the operations are successful, False otherwise.
    
    Dim inst As New cDB_Instruction
    Dim record1 As New cDB_Record
    Dim record2 As New cDB_Record
    Dim records As New cDB_Records
    
    With inst
        record1.Initialize columns:="id, City, Organisation", values:="20, 'Martigny', 'FC Sion'"
        .Initialize action:=eCreateRow, Table:="tbl_Testcasinos", record:=record1
        .execute
        
        .Initialize action:=eDeleteRow, Table:="tbl_Testcasinos", Where:="id=20"
        .execute
        
        record2.Initialize columns:="City, Organisation"
        .Initialize action:=eReadRow, Table:="tbl_Testcasinos", record:=record2, Where:="id=20"
        .execute records:=records
    End With
    AddAndDeleteRecord = (records.count = 0)
End Function

Function UpdateRecord() As Boolean
    '' Updates a record in the test table and verifies the operation.
    '' Returns True if the record is updated successfully, False otherwise.
    
    On Error Resume Next
    Dim Inst1 As New cDB_Instruction
    Dim res As Boolean
    Dim rec As New cDB_Record
    Dim record As New cDB_Record
    Dim record2 As New cDB_Record
    Dim records As New cDB_Records
    
    UpdateRecord = False
    With Inst1
        record.Initialize columns:="id, City, Organisation", values:="15, 'Martigny', 'FC Sion'"
        .Initialize action:=eCreateRow, Table:="tbl_Testcasinos", record:=record
        .execute
        
        record.Initialize columns:="City, Organisation", values:="'Bovernier', 'Sarrasin'"
        .Initialize action:=eUpdateRow, Table:="tbl_Testcasinos", record:=record, Where:="id=15"
        UpdateRecord = .execute
        
        record2.Initialize columns:="City, Organisation"
        .Initialize action:=eReadRow, Table:="tbl_Testcasinos", record:=record2, Where:="id=15"
        .execute records:=records
        
        Set rec = records.Item(1)
        res = rec.IdentiqueAs(record)
        
        record.Initialize columns:="City, Organisation", values:="'Bern', 'Rebord'"
        .Initialize action:=eUpdateRow, Table:="tbl_Testcasinos", record:=record, Where:="id=15"
        .execute
        
        record2.Initialize columns:="City, Organisation"
        .Initialize action:=eReadRow, Table:="tbl_Testcasinos", record:=record2, Where:="id=15"
        .execute records:=records
    End With
    Set rec = records.Item(1)
    UpdateRecord = res And rec.IdentiqueAs(record)
End Function

Function MinId() As Boolean
    '' Retrieves the minimum 'id' value from the test table and verifies the result.
    '' Returns True if the result matches the expected value, False otherwise.
    
    Dim inst As New cDB_Instruction
    Dim res As Integer
    res = inst.Min(Table:="tbl_Testcasinos", column:="id")
    MinId = res = 1
End Function

Function MaxId() As Boolean
    '' Retrieves the maximum 'id' value from the test table and verifies the result.
    '' Returns True if the result matches the expected value, False otherwise.
    
    Dim inst As New cDB_Instruction
    Dim res As Integer
    res = inst.Max(Table:="tbl_Testcasinos", column:="id")
    MaxId = res = 15
End Function

Function FirstId() As Boolean
    '' Retrieves the first 'id' value from the test table and verifies the result.
    '' Returns True if the result matches the expected value, False otherwise.
    
    Dim inst As New cDB_Instruction
    Dim res As Integer
    res = inst.First(Table:="tbl_Testcasinos", column:="id")
    FirstId = res = 1
End Function

Function LastId() As Boolean
    '' Retrieves the last 'id' value from the test table and verifies the result.
    '' Returns True if the result matches the expected value, False otherwise.
    
    Dim inst As New cDB_Instruction
    Dim res As Integer
    res = inst.Last(Table:="tbl_Testcasinos", column:="id")
    LastId = res = 15
End Function

Function SumId() As Boolean
    '' Retrieves the sum of 'id' values from the test table and verifies the result.
    '' Returns True if the result matches the expected value, False otherwise.
    
    Dim inst As New cDB_Instruction
    Dim res As Integer
    res = inst.Sum(Table:="tbl_Testcasinos", column:="id")
    SumId = res = 18
End Function

Function DeleteTestTable() As Boolean
    '' Deletes the test table 'tbl_Testcasinos'.
    '' Returns True if the table is deleted successfully, False otherwise.
    
    Set cnn = CurrentProject.Connection
    cmd.ActiveConnection = cnn

    On Error GoTo errHandler:
    cmd.CommandText = "DROP TABLE tbl_Testcasinos"
    cmd.execute
    Set cnn = Nothing
    DeleteTestTable = True
    Exit Function

errHandler:
    Set cnn = Nothing
    log.LogEvent vbCrLf & cmd.CommandText & " cannot be executed. Check the table name." & vbCrLf, eWarning
    DeleteTestTable = False
End Function

