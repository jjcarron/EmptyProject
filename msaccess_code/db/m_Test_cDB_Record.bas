Attribute VB_Name = "m_Test_cDB_Record"
Option Compare Database

Function CreateAndReadField() As Boolean
    Dim Col As String
    Dim Val As String
    Col = "x_id"
    Val = "abc"
    Dim f1 As New cDB_Field
    Dim f2 As New cDB_Field
    f1.Initialize Col:=Col, Val:=Val
    CreateAndReadField = (f1.column = Col) And (f1.value = Val)
End Function

Function FieldIsIdentiqueAs() As Boolean
    Dim Col As String
    Dim Val As String
    Col = "x_id"
    Val = "abc"
    Dim f1 As New cDB_Field
    Dim f2 As New cDB_Field
    f1.Initialize Col:=Col, Val:=Val
    f2.Initialize Col:=Col, Val:=Val
    FieldIsIdentiqueAs = f1.IdentiqueAs(f2)
End Function

Function CreateAndReadRecord() As Boolean
    Dim r As New cDB_Record
    Dim res As Boolean
    Dim Col As String
    Dim Val As String
    Col = "x_id"
    Val = "abc"
    Dim f1 As New cDB_Field
    Dim f2 As New cDB_Field
    f1.Initialize Col:=Col, Val:=Val
    f2.Initialize Col:=Col & "3", Val:=Val & "3"
    
    r.Add f1
    r.Add f2
    
    res = (r.count = 2)
    res = res And r.column(1).column = Col
    res = res And r.column(Col).column = Col
    res = res And r.column(2).column = Col & 3
    res = res And r.column(Col & "3").column = Col & 3
    res = res And r.column(1).value = Val
    res = res And r.column(Col).value = Val
    res = res And r.column(2).value = Val & 3
    res = res And r.column(Col & "3").value = Val & 3
    CreateAndReadRecord = res
End Function

Function CreateRecordAndReadValue() As Boolean
    Dim r As New cDB_Record
    Dim res As Boolean
    Dim Col As String
    Dim Val As String
    Col = "x_id"
    Val = "abc"
    Dim f1 As New cDB_Field
    Dim f2 As New cDB_Field
    f1.Initialize Col:=Col, Val:=Val
    f2.Initialize Col:=Col & "3", Val:=Val & "3"
    
    r.Add f1
    r.Add f2
    
    res = (r.count = 2)
    res = res And r.value(1) = Val
    res = res And r.value("x_id") = Val
    res = res And r.value(2) = Val & "3"
    res = res And r.value("x_id" & "3") = Val & "3"
    CreateRecordAndReadValue = res
End Function

Function RecordIsIdentiqueAs() As Boolean
    Dim R1 As New cDB_Record
    Dim R2 As New cDB_Record
    Dim res As Boolean
    Dim Col As String
    Dim Val As String
    Col = "x_id"
    Val = "abc"
    Dim f1 As New cDB_Field
    Dim f2 As New cDB_Field
    f1.Initialize Col:=Col, Val:=Val
    f2.Initialize Col:=Col & "3", Val:=Val & "3"
    
    R1.Add f1
    R1.Add f1
    
    R2.Add f1
    R2.Add f2
    
    res = R1.IdentiqueAs(R1)
    res = res And Not (R1.IdentiqueAs(R2))
    RecordIsIdentiqueAs = res
End Function
