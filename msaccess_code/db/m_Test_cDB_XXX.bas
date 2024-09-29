Attribute VB_Name = "m_Test_cDB_XXX"
Option Compare Database

'' This module tests the functionality of Template class that will be used
'' by all Table's objects generated.
'' It's important to test every new functionality added to the template `cDB_XXXs` class,
'' which is a database class that manages records for the `XXXs` table.

Function Test_IsAvailable() As Boolean
    '' Tests if the `cDB_XXXs` class is available and initialized properly.
    '' Returns True if the class is available, False otherwise.
    
    Dim XXXs As New cDB_XXXs
    Test_IsAvailable = XXXs.isAvailable
End Function

Function Test_HasIndex() As Boolean
    '' Tests if the `cDB_XXXs` class does not have a specific index.
    '' Returns True if the index does not exist, False otherwise.
    
    Dim XXXs As New cDB_XXXs
    Test_HasIndex = Not XXXs.hasIndex("Index")
End Function

Function FillTable() As Boolean
    '' Fills the `XXXs` table with test data.
    '' Returns True if the table contains 3 records after filling, False otherwise.
    
    Dim XXXs As New cDB_XXXs
    Dim XXX As New cDB_XXX
    Dim inst As New cDB_Instruction
    
    XXXs.DeleteAll
    With inst
        XXX.Initialize IntValue:=1, StrValue:="Test1"
        .Initialize action:=eCreateRow, Table:="XXXs", record:=XXX.record
        .execute
        
        XXX.Initialize IntValue:=2, StrValue:="Test2"
        .Initialize action:=eCreateRow, Table:="XXXs", record:=XXX.record
        .execute
        
        XXX.Initialize IntValue:=3, StrValue:="Test3"
        .Initialize action:=eCreateRow, Table:="XXXs", record:=XXX.record
        .execute
    End With
    FillTable = RecordCount("XXXs") = 3
End Function

Function Test_Id() As Boolean
    '' Tests if the `id` method of `cDB_XXXs` correctly identifies records.
    '' Returns True if the method correctly identifies the records, False otherwise.
    
    Dim XXXs As New cDB_XXXs
    XXXs.DeleteAll
    FillTable
    Test_Id = (XXXs.id("IntValue = 3")) And Not (XXXs.id("IntValue = 4"))
End Function

Function Test_Count() As Boolean
    '' Tests if the `count` method of `cDB_XXXs` returns the correct number of records.
    '' Returns True if the count is correct, False otherwise.
    
    Dim XXXs As New cDB_XXXs
    XXXs.DeleteAll
    FillTable
    Test_Count = (XXXs.count = 3)
End Function

Function Test_Delete() As Boolean
    '' Tests if the `Delete` method of `cDB_XXXs` correctly deletes records.
    '' Returns True if the records are deleted correctly, False otherwise.
    
    Dim XXXs As New cDB_XXXs
    XXXs.DeleteAll
    FillTable
    XXXs.Delete "IntValue = 2"
    XXXs.Delete "StrValue = 'Test1'"
    Test_Delete = (XXXs.count = 1)
End Function

Function Test_DeleteALL() As Boolean
    '' Tests if the `DeleteAll` method of `cDB_XXXs` correctly deletes all records.
    '' Returns True if all records are deleted, False otherwise.
    
    Dim XXXs As New cDB_XXXs
    FillTable
    XXXs.DeleteAll
    Test_DeleteALL = RecordCount("XXXs") = 0
End Function

Function Test_Records() As Boolean
    '' Tests if the `records` method of `cDB_XXXs` returns the correct records.
    '' Returns True if the correct records are returned, False otherwise.
    
    Dim XXXs As New cDB_XXXs
    Dim records As cDB_Records
    FillTable
    Set records = XXXs.records
    Test_Records = records.count = 3 And TypeName(records.Item(1)) = "cDB_Record"
End Function

Function Test_Collection() As Boolean
    '' Tests if the `Collection` method of `cDB_XXXs` returns the correct collection of records.
    '' Returns True if the correct collection is returned, False otherwise.
    
    Dim XXXs As New cDB_XXXs
    Dim records As Collection
    FillTable
    Set records = XXXs.Collection
    Test_Collection = XXXs.Collection.count = 3 And TypeName(records(1)) = "cDB_XXX"
End Function

Function Test_XXX() As Boolean
    '' Tests if the `Item` and `XXX` methods of `cDB_XXXs` correctly retrieve specific records.
    '' Returns True if the records are retrieved correctly, False otherwise.
    
    Dim XXXs As New cDB_XXXs
    Dim XXX1 As cDB_XXX
    Dim XXX2 As cDB_XXX
    FillTable
    Set XXX1 = XXXs.Item(filter:="IntValue = 2")
    Set XXX2 = XXXs.XXX(XXX1.id)
    Test_XXX = Not XXX2 Is Nothing And XXX1.IntValue = XXX2.IntValue
End Function

