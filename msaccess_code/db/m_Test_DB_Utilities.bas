Attribute VB_Name = "m_Test_DB_Utilities"
Option Compare Database

'' The sequence of the test functions is important because the state of the table is used.
'' This test suite assumes the database is already created and contains some data.

Private cnn As New ADODB.Connection
Private cmd As New ADODB.Command

Function TestFetchItems() As Boolean
    '' Tests the `FetchItems` function by retrieving records from the "ResourceStrings" table.
    '' Returns True if items are retrieved successfully, False otherwise.
    '' If no items are found, it logs a debug message.
    
    Dim rec As New cDB_Record
    Dim records As New cDB_Records
    
    ' Use ResourceStrings table for testing
    Set items = FetchItems("ResourceStrings")
    TestFetchItems = Not items Is Nothing
    If Not TestFetchItems Then
        TestFetchItems = False
        Debug.Print "No ResourceString Found"
    End If
End Function

Function TestFetchItem() As Boolean
    '' Tests the `FetchItem` function by retrieving a specific record from the "ResourceStrings" table.
    '' Returns True if the record with Ref "OK" is found and correctly initialized, False otherwise.
    '' If the record is not found or does not match the expected value, it logs a debug message.
    
    Dim rec As New cDB_Record
    Dim records As New cDB_Records
    Dim Resource As New cDB_ResourceString
    
    ' Use ResourceStrings table for testing
    Set rec = FetchItem(Table:="ResourceStrings", filter:="Ref LIKE 'OK'")
    If rec.count > 0 Then
        Resource.InitializeFromDB_Record rec
        TestFetchItem = Resource.Ref = "OK"
        If Not TestFetchItem Then
            Debug.Print "Not Found"
        End If
    Else
        TestFetchItem = False
        Debug.Print "OK Not Found in Resource as Ref"
    End If
End Function

