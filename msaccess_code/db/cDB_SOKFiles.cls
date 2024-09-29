VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "cDB_SOKFiles"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'Extra Variables
Private myTree As cTree
Private myFiles As Collection

' Region "============================= Generated Code =============================="

'' Class : cDB_sok_files

''
'' Code generated from the Class Definition 'Classes.def' at 24.05.2024
'' by cCG_DB_ClassWriter
''

Option Compare Database

'' Generated from Template Class Version 1.0
'' Author Caj
'' Last modification 28.01.2024
''
Const myTableName As String = "SokFiles"

Property Get tableName() As String
'' returns true if the table exist in the database
   tableName = myTableName
End Property

Property Get isAvailable() As Boolean
'' returns true if the table exist in the database
    isAvailable = HasTable(tableName:=myTableName)
End Property

Property Get hasIndex(index As String) As Boolean
'' returns true if the table is indexed by Index
    hasIndex = TableHasIndex(myTableName, index:=index)
End Property

Property Get id(filter As String, Optional error As String = "") As Long
'' return the first id of the table for the given condition
'' This function assumes that the primary key is called "id"
'' 0 is return in cas of error
    id = FetchId(Table:=myTableName, filter:=filter, error:=error)
End Property

Property Get Item(filter As String) As cDB_SOKFile
    Dim rec As cDB_Record
    Dim sok_file As New cDB_SOKFile
    Set rec = FetchItem(Table:=myTableName, filter:=filter)
    If Not rec Is Nothing Then
        sok_file.InitializeFromDB_Record rec
        Set Item = sok_file
    Else
        Set Item = Nothing
    End If
End Property

Property Get records(Optional filter As String = "", Optional ByRef PreCondition As String = "", Optional ByRef PostCondition As String = "", Optional error As String = "") As cDB_Records
'' return alls the records of the DB
'' The records shoud be interpreted externally
'' 0 is return in cas of error
    
    Set records = FetchItems(Table:=myTableName, filter:=filter, PreCondition:=PreCondition, PostCondition:=PostCondition, error:=error)
End Property

Property Get sok_file(id As Long) As cDB_SOKFile
    Dim rec As cDB_Record
    Dim obj As New cDB_SOKFile
    Set rec = FetchItem(Table:=myTableName, filter:="id = " & id)
    If Not rec Is Nothing Then
        obj.InitializeFromDB_Record rec
        Set sok_file = obj
    Else
        Set sok_file = Nothing
    End If
End Property

Property Get Collection(Optional filter As String = "", Optional ByRef PreCondition As String = "", Optional ByRef PostCondition As String = "", Optional error As String = "") As Collection ' of cDB_SokFile
'' return alls the records of the DB
'' The records shoud be interpreted externally
'' 0 is return in cas of error

    Dim records As cDB_Records
    Dim record As cDB_Record
    Dim Item As cDB_SOKFile
    Dim mySOK_Files As New Collection
    Set records = FetchItems(Table:=myTableName, filter:=filter, PreCondition:=PreCondition, PostCondition:=PostCondition, error:=error)
    
    For Each record In records.records
        Set Item = New cDB_SOKFile
        Item.InitializeFromDB_Record record
        mySOK_Files.Add Item
    Next record
    Set Collection = mySOK_Files
End Property

Property Get count()
    count = RecordCount(myTableName)
End Property

Sub DeleteAll()
    DeleteLines Table:=myTableName
End Sub

Sub Delete(Optional filter As String = "", Optional error As String = "")
    DeleteLines Table:=myTableName, filter:=filter
End Sub

' Region "============================= User Code  =============================="

Property Get files()
    '' Returns the collection of Forms containing the Application Data collected by the formal checks of the application.
    Set files = myFiles
End Property

Sub Initialize(root As String, filter As String)
    '' Initializes the object by creating an instance of cTree and using it to populate the myFiles collection.
    '' Parameters:
    ''   - root: The root directory to search for files.
    ''   - filter: A string pattern used to filter files in the root directory.
    Set myTree = New cTree
    myTree.Initialize root
    Set myFiles = myTree.RootFiles(filter)
End Sub

Function SetFileAsLoaded(record As cDB_Record, LastChange As Date, Optional error As String) As Boolean
    '' Marks a file record as loaded and updates its last change date in the database.
    '' Parameters:
    ''   - record: The cDB_Record object representing the file to update.
    ''   - LastChange: The date to set as the last change date.
    ''   - error: Optional. A string to store error details.
    '' Returns:
    ''   - Boolean: True if the update is successful, False otherwise.
    
    Dim inst As New cDB_Instruction
    Dim id As Long: id = record.column("id").value
    
    On Error GoTo errHandler
    With inst
        Set record = New cDB_Record
        record.Initialize columns:="IsLoaded, LastChange", values:="'1', '" & LastChange & "'"
        .Initialize action:=eUpdateRow, Table:="SokFiles", record:=record, Where:="id =" & id & " ;"
        SetFileAsLoaded = .execute
    End With
    Exit Function

errHandler:
    Debug.Print vbCrLf & inst.cmdText & " cannot be executed. Check the table name and the index." & vbCrLf
    error = "unknown error"
End Function

Function FetchFiles(Optional NameFilter As String = "", Optional ByRef error As String) As cDB_Records
    '' Retrieves records from the SokFiles table that match the optional name filter.
    '' Parameters:
    ''   - NameFilter: Optional. A string pattern to filter records by name.
    ''   - error: Optional. A string to store error details.
    '' Returns:
    ''   - cDB_Records: A collection of records that match the filter criteria, or Nothing if an error occurs.
    
    Dim inst As New cDB_Instruction
    Dim records As cDB_Records
    Dim filter As String
    
    If NameFilter <> "" Then
        filter = " Name LIKE '" & NameFilter & "'"
    End If
    
    On Error GoTo errHandler
    With inst
        .InitFromStr action:=eReadRow, Table:="SokFiles", columns:="*", Where:=filter
        .execute records:=records
    End With
    Set FetchFiles = records
    error = ""
    Exit Function

errHandler:
    Debug.Print vbCrLf & inst.cmdText & " cannot be executed. Check the table name and the index." & vbCrLf
    Set FetchFiles = Nothing
    error = "Not Found"
End Function

