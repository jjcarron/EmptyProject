VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "cDB_ResourceStrings"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'Extra variables
Private myLanguage As String

' Region "============================= Generated Code =============================="

'' Class : cDB_ResourceStrings

''
'' Code generated from the Class Definition 'Classes.def' at 02.03.2024
'' by cCG_DB_ClassWriter
''

Option Compare Database

'' Generated from Template Class Version 1.0
'' Author Caj
'' Last modification 28.01.2024
''
Const myTableName As String = "ResourceStrings"

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

Property Get Item(filter As String) As cDB_ResourceString
    Dim rec As cDB_Record
    Dim ResourceString As New cDB_ResourceString
    Set rec = FetchItem(Table:=myTableName, filter:=filter)
    If Not rec Is Nothing Then
        ResourceString.InitializeFromDB_Record rec
        Set Item = ResourceString
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

Property Get ResourceString(id As Long) As cDB_ResourceString
    Dim rec As cDB_Record
    Dim obj As New cDB_ResourceString
    Set rec = FetchItem(Table:=myTableName, filter:="id = " & id)
    If Not rec Is Nothing Then
        obj.InitializeFromDB_Record rec
        Set ResourceString = obj
    Else
        Set ResourceString = Nothing
    End If
End Property

Property Get Collection(Optional filter As String = "", Optional ByRef PreCondition As String = "", Optional ByRef PostCondition As String = "", Optional error As String = "") As Collection ' of cDB_ResourceString
'' return alls the records of the DB
'' The records shoud be interpreted externally
'' 0 is return in cas of error

    Dim records As cDB_Records
    Dim record As cDB_Record
    Dim Item As cDB_ResourceString
    Dim myResourceStrings As New Collection
    Set records = FetchItems(Table:=myTableName, filter:=filter, PreCondition:=PreCondition, PostCondition:=PostCondition, error:=error)
    
    For Each record In records.records
        Set Item = New cDB_ResourceString
        Item.InitializeFromDB_Record record
        myResourceStrings.Add Item
    Next record
    Set Collection = myResourceStrings
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


Property Get str(Ref As String) As String
    '' Retrieves a translated string from the ResourceStrings table based on the provided reference.
    '' The method first attempts to find the string in the user's selected language.
    '' If the string is not found, it defaults to English.
    '' Parameters:
    ''   - Ref: The reference key for the string to be translated.
    '' Returns:
    ''   - String: The translated string, or the reference key if no translation is found.
    
    Dim inst As New cDB_Instruction
    On Error Resume Next ' Catch null values
    
    Ref = ReplicateQuote(Ref)
    str = inst.First(Table:="ResourceStrings", column:=myLanguage, Where:="Ref LIKE '" & Ref & "'", default:="")
    
    If str = "" Then
        ' Assume English for not implemented languages
        str = inst.First(Table:="ResourceStrings", column:="EN", Where:="Ref LIKE '" & Ref & "'", default:=Ref)
    End If
End Property

Sub Initialize(Language As String)
    '' Initializes the translator with the specified language.
    '' Parameters:
    ''   - Language: The language code to use for translations (e.g., "EN" for English).
    
    myLanguage = Language
End Sub

Sub Class_Initialize()
    '' Automatically initializes the class with the current user's language.
    '' If the user's language is not set, it defaults to English.
    
    If TheCurrentUser.userLanguage <> "" Then
        myLanguage = TheCurrentUser.userLanguage
    Else
        ' Assume English if no user language is set
        myLanguage = "EN"
    End If
End Sub


