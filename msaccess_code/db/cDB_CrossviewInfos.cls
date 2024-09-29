VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "cDB_CrossviewInfos"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
' Region "============================= Generated Code =============================="

'' Class : cDB_cross_view_infos

''
'' Code generated from the Class Definition 'Classes.def' at 01.06.2024
'' by cCG_DB_ClassWriter
''

Option Compare Database

'' Generated from Template Class Version 1.0
'' Author Caj
'' Last modification 28.01.2024
''
Const myTableName As String = "CrossviewInfos"

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

Property Get Item(filter As String) As cDB_CrossviewInfo
    Dim rec As cDB_Record
    Dim CrossView_Info As New cDB_CrossviewInfo
    Set rec = FetchItem(Table:=myTableName, filter:=filter)
    If Not rec Is Nothing Then
        CrossView_Info.InitializeFromDB_Record rec
        Set Item = CrossView_Info
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

Property Get CrossView_Info(id As Long) As cDB_CrossviewInfo
    Dim rec As cDB_Record
    Dim obj As New cDB_CrossviewInfo
    Set rec = FetchItem(Table:=myTableName, filter:="id = " & id)
    If Not rec Is Nothing Then
        obj.InitializeFromDB_Record rec
        Set CrossView_Info = obj
    Else
        Set CrossView_Info = Nothing
    End If
End Property

Property Get Collection(Optional filter As String = "", Optional ByRef PreCondition As String = "", Optional ByRef PostCondition As String = "", Optional error As String = "") As Collection ' of cDB_CrossviewInfo
'' return alls the records of the DB
'' The records shoud be interpreted externally
'' 0 is return in cas of error

    Dim records As cDB_Records
    Dim record As cDB_Record
    Dim Item As cDB_CrossviewInfo
    Dim mycross_view_infos As New Collection
    Set records = FetchItems(Table:=myTableName, filter:=filter, PreCondition:=PreCondition, PostCondition:=PostCondition, error:=error)
    
    For Each record In records.records
        Set Item = New cDB_CrossviewInfo
        Item.InitializeFromDB_Record record
        mycross_view_infos.Add Item
    Next record
    Set Collection = mycross_view_infos
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

Sub Add(QueryName As String, Operation As String, Title As String, X_Name As String, Y_Name As String, SheetPrefix As String)
    '' Adds or updates a record in the cross-view table with the provided details.
    '' Parameters:
    ''   - QueryName: The name of the query being added or updated.
    ''   - Operation: The operation type (e.g., OL_, LB_).
    ''   - Title: The title of the cross-view.
    ''   - X_Name: The name for the X-axis.
    ''   - Y_Name: The name for the Y-axis.
    ''   - SheetPrefix: The prefix to be used for the sheet name.

    Dim inst As New cDB_Instruction
    Dim i As Integer
    Dim CV_Info As New cDB_CrossviewInfo
    
    CV_Info.Initialize Operation:=Operation, QueryName:=QueryName, Title:=Title, X_Name:=X_Name, Y_Name:=Y_Name, Sheet_Prefix:=SheetPrefix

    On Error GoTo errHandler
    With inst
        Dim rec As cDB_Record
        Set rec = CV_Info.record
        .Initialize action:=eUpdateOrCreateRow, Table:=myTableName, record:=rec, _
            Where:="QueryName = '" & QueryName & "'"
        .execute
    End With
    Exit Sub

errHandler:
    log.LogEvent inst.cmdText & " cannot be executed. Check the tablename and the columnnames", eError
End Sub

Property Get StringValue(resource_strings As cDB_ResourceStrings, QueryName As String, ResourceStringExtension As String, defaultValue As String) As String
    '' Retrieves a string value from the resource strings based on the query name and extension.
    '' If the string is not found, the default value is used.
    '' Parameters:
    ''   - resource_strings: An instance of cDB_ResourceStrings for fetching strings.
    ''   - QueryName: The name of the query.
    ''   - ResourceStringExtension: The extension to append to the query name to form the resource string key.
    ''   - defaultValue: The default value to return if the resource string is not found.
    '' Returns:
    ''   - String: The translated string or the default value.

    StringValue = resource_strings.str(Ref:=QueryName & ResourceStringExtension)
    If Right(StringValue, Len(ResourceStringExtension)) = ResourceStringExtension Then
        'StringValue not found in ResourceStrings, use the default value created automatically
        StringValue = defaultValue
        log.LogEvent "No Translation found for " & QueryName & ResourceStringExtension, eInfo
    End If
End Property

Sub Initialize(resource_strings As cDB_ResourceStrings)
    '' Initializes the cross-view table by reading queries from the database and setting up their corresponding titles, X/Y names, and sheet prefixes.
    '' The naming conventions should be respected, where:
    ''   - prefix = crw_
    ''   - Operation = OL_ | LB_ | BO_
    ''   - Title is derived from the string without prefix and underscores.
    ''   - SheetPrefix is created from the capital letters and numbers from the Title.
    ''   - Y_Name is created from the capital letter of the first name in the title.
    '' Translation will be made if the string Title is found in ResourceStrings.
    '' Parameters:
    ''   - resource_strings: An instance of cDB_ResourceStrings for fetching translated strings.

    Dim db As Object
    Dim qdf As Object
    Dim qryType As String
    Dim Operation As String
    Dim Title As String
    Dim X_Name As String
    Dim Y_Name As String
    Dim SheetPrefix As String
    Dim QueryDefinitionLines As New Collection
    Dim QueryNameMainPart As String
    Dim DefaultTitle As String
    Dim DefaultX_Name As String
    Dim DefaultY_Name As String
    Dim DefaultSheetPrefix As String
    
    Set db = CurrentDb
    
    log.LogEvent "========== Start loading translation for graphics   ============", eInfo
    For Each qdf In db.QueryDefs
        qryType = Left(qdf.Name, 4)
        If qryType = "crw_" Then
            Operation = Mid(qdf.Name, 5, 2)
            QueryNameMainPart = Mid(qdf.Name, 8)
            DefaultX_Name = "Year"
            DefaultSheetPrefix = CreateShortName(QueryNameMainPart)
            If Right(QueryNameMainPart, 6) = "_Ratio" Then
                DefaultTitle = DefaultRatioTitle(QueryNameMainPart)
                DefaultY_Name = DefaultTitle
            Else
                DefaultTitle = CreateTitle(QueryNameMainPart)
                DefaultY_Name = CreateTitle(ExtractFirstWord(QueryNameMainPart))
            End If
            Select Case Operation
            Case "OL", "LB", "BO":
                Title = StringValue(resource_strings, qdf.Name, "_Title", DefaultTitle)
                X_Name = StringValue(resource_strings, qdf.Name, "_X_Name", DefaultX_Name)
                Y_Name = StringValue(resource_strings, qdf.Name, "_Y_Name", DefaultY_Name)
                SheetPrefix = StringValue(resource_strings, qdf.Name, "_Sheet_Prefix", DefaultSheetPrefix)
                Add QueryName:=qdf.Name, Operation:=Operation, Title:=Title, X_Name:=X_Name, Y_Name:=Y_Name, SheetPrefix:=SheetPrefix
            End Select
        End If
    Next qdf
    log.LogEvent "========== Translation for graphics loaded  ============", eInfo
End Sub


