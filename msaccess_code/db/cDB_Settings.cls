VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "cDB_Settings"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

' Region "============================= Generated Code =============================="

'' Class : cDB_Settings

''
'' Code generated from the Class Definition 'Classes.def' at 28.01.2024
'' by cCG_DB_ClassWriter
''

Option Compare Database

'' Generated from Template Class Version 1.0
'' Author Caj
'' Last modification 28.01.2024
''
Const myTableName As String = "Settings"

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

Property Get Item(filter As String) As cDB_Setting
    Dim rec As cDB_Record
    Dim Setting As New cDB_Setting
    Set rec = FetchItem(Table:=myTableName, filter:=filter)
    If Not rec Is Nothing Then
        Setting.InitializeFromDB_Record rec
        Set Item = Setting
    Else
        Set Item = Nothing
    End If
End Property

Property Get records(Optional filter As String = "", Optional error As String = "") As cDB_Records
'' return alls the records of the DB
'' The records shoud be interpreted externally
'' 0 is return in cas of error
    
    Set records = FetchItems(Table:=myTableName, filter:=filter, error:=error)
End Property

Property Get Setting(id As Long) As cDB_Setting
    Dim rec As cDB_Record
    Dim obj As New cDB_Setting
    Set rec = FetchItem(Table:=myTableName, filter:="id = " & id)
    If Not rec Is Nothing Then
        obj.InitializeFromDB_Record rec
        Set Setting = obj
    Else
        Set Setting = Nothing
    End If
End Property

Property Get Collection(Optional filter As String = "", Optional error As String = "") As Collection ' of cDB_Parameter
'' return alls the records of the DB
'' The records shoud be interpreted externally
'' 0 is return in cas of error

    Dim records As cDB_Records
    Dim record As cDB_Record
    Dim Item As cDB_Setting
    Dim myParameters As New Collection
    Set records = FetchItems(Table:=myTableName, filter:=filter, error:=error)
    
    For Each record In records.records
        Set Item = New cDB_Setting
        Item.InitializeFromDB_Record record
        myParameters.Add Item
    Next record
    Set Collection = myParameters
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

Property Get PValue(Name As String) As Variant
    '' Retrieves the parameter value as a Variant based on the provided parameter name.
    '' The function looks for a setting with a name matching the provided Name.
    '' If the setting is found and is numeric, it converts it to either a Double or Long.
    '' Otherwise, it returns the original string value.
    '' Parameters:
    ''   - Name: The name of the parameter to retrieve.
    '' Returns:
    ''   - Variant: The value of the parameter, either as a numeric value or as a string.

    Dim Param As cDB_Setting
    Dim result As Variant
    
    Set Param = Item("Name LIKE '" & Name & "'")
    
    If Param Is Nothing Then
        result = ""
    ElseIf IsNumeric(Param.PValue) Then
        If InStr(Param.PValue, ".") > 0 Then
            result = CDbl(Param.PValue) ' If it's a decimal number, return Double
        Else
            result = CLng(Param.PValue) ' If it's an integer, return Long
        End If
    Else
        result = Param.PValue ' Otherwise, return the original string
    End If
    
    PValue = result
End Property

Property Get PBoolean(Name As String) As Boolean
    '' Retrieves the parameter value as a Boolean based on the provided parameter name.
    '' If the parameter is found, its Boolean value is returned.
    '' If not found, the function returns False.
    '' Parameters:
    ''   - Name: The name of the parameter to retrieve.
    '' Returns:
    ''   - Boolean: The Boolean value of the parameter, or False if not found.
    
    Dim Param As cDB_Setting
    
    Set Param = Item("Name LIKE '" & Name & "'")
    
    If Param Is Nothing Then
        PBoolean = False
    Else
        PBoolean = Param.PBoolean ' Return the Boolean value
    End If
End Property

Sub Update_PBoolean(Name As String, bool As Boolean)
    '' Updates the Boolean value of a parameter in the database.
    '' If the parameter exists, it updates its Boolean value and writes the changes to the database.
    '' Parameters:
    ''   - Name: The name of the parameter to update.
    ''   - bool: The Boolean value to set.
    
    Dim Param As cDB_Setting
    Dim inst As New cDB_Instruction
    
    Set Param = Item("Name LIKE '" & Name & "'")
    
    If Not Param Is Nothing Then
        Param.PBoolean = bool
        With inst
            .Initialize action:=eUpdateRow, Table:=myTableName, record:=Param.record, Where:="id=" & Param.id
            .execute
        End With
    End If
End Sub

