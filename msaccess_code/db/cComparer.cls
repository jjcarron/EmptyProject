VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "cComparer"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'' Class : cComparer
''
'' This class implements comparison functions for an ArrayList of objects.
'' Each field to compare should be added to the IComparer interface.
''
'' Usage Example:
'' Assuming you have an ArrayList `myVariables` containing objects with a field `o.Name`,
'' you can define a comparer object, set the sorting field, and sort the list using the comparer:
''
'' Dim comp As New cComparer
'' comp.sortField = "Name"
'' myVariables.Sort_2 comp
''
'' This class implements the `mscorlib.IComparer` interface.

Option Compare Database

Implements mscorlib.IComparer

Private mySortField As String

Property Let sortField(sortField As String)
    '' Sets the field name by which the objects in the ArrayList will be sorted.
    mySortField = sortField
End Property

Function Str_Compare(ByRef x As String, ByRef y As String) As Long
    '' Compares two strings using case-insensitive text comparison.
    '' Returns 0 if they are equal, -1 if x < y, and 1 if x > y.
    Str_Compare = StrComp(x, y, vbTextCompare)
End Function

Function Long_Compare(ByVal a As Long, ByVal b As Long) As Long
    '' Compares two long integers.
    '' Returns 1 if a > b, -1 if a < b, and 0 if they are equal.
    If a > b Then
        Long_Compare = 1
    ElseIf a < b Then
        Long_Compare = -1
    ElseIf a = b Then
        Long_Compare = 0
    End If
End Function

Function IComparer_Compare(ByVal x As Variant, ByVal y As Variant) As Long
    '' Compares two objects based on the field specified by `mySortField`.
    '' Currently supports comparison of "Name" (as a string) and "id" (as a long integer).
    '' Returns 1 if x > y, -1 if x < y, and 0 if they are equal.
    Select Case mySortField
    Case "Name"
        IComparer_Compare = Str_Compare(x.Name, y.Name)
    Case "id"
        IComparer_Compare = Long_Compare(x.id, y.id)
    Case Else
        IComparer_Compare = 0  ' Comparison for this field is not yet implemented.
    End Select
End Function

