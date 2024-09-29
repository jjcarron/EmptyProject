Attribute VB_Name = "m_DB_Code_Generator"
Option Compare Database
Option Base 0

'' ==============================================================================
'' Module : m_DB_Code_Generator
''
'' Description:
'' This module generates VBA class modules based on database table definitions.
'' It handles the creation of both record classes and business classes, providing
'' functionality for generating variable names, determining data types, and handling
'' common tasks like singularizing table names. The generated classes are used to
'' facilitate data manipulation within the application by providing a structured
'' and object-oriented approach to database interaction.
''
'' Key Responsibilities:
'' - Generate VBA classes for database records and business objects.
'' - Handle variable name formatting and data type determination.
'' - Create singular class names from plural table names.
''
'' Usage:
'' 1. Include this module in your VBA project.
'' 2. Call the appropriate subroutines (e.g., `Generate_DB_Record_Class`, `Generate_DB_Class`)
''    to generate the required classes.
'' 3. Customize the generation logic as needed to fit your database schema and application needs.
''
'' Dependencies:
'' - Requires the `cDB_Definitions`, `cCG_DB_Record_ClassWriter`, `cCG_DB_ClassWriter`,
''   and `cCG_Variable` classes for defining tables and generating classes.
''
'' ==============================================================================

Private dbTablesDefs As cDB_Definitions

Const varPrefix As String = "F_"  ' Prefix for field variables
Const classPrefix As String = "cDB_"  ' Prefix for class names
Const classExtension  As String = ".cls"  ' File extension for class files

Function GetVbType(dbType As String) As String
    '' Returns the VBA data type corresponding to a given database data type.
    ''
    '' Parameters:
    '' - dbType: The data type from the database (e.g., "INTEGER", "TEXT").
    ''
    '' Returns:
    '' - The corresponding VBA data type as a string (e.g., "Long", "String").

    Select Case UCase(Left(Trim(dbType), 7))
        Case "INTEGER", "LONG"
            GetVbType = "Long"
        Case "TEXT", "MEMO", "VARCHAR"
            GetVbType = "String"
        Case "BYTE"
            GetVbType = "Byte"
        Case "DOUBLE"
            GetVbType = "Double"
        Case "DATE"
            GetVbType = "Date"
        Case "BIT"
            GetVbType = "Boolean"
        Case "CURRENCY"
            GetVbType = "Currency"
        Case Else
            GetVbType = dbType & " is not supported yet"
    End Select
End Function

Function removeExtraSpaces(str As String) As String
    '' Removes extra spaces from a string, leaving only single spaces between words.
    ''
    '' Parameters:
    '' - str: The input string with potential extra spaces.
    ''
    '' Returns:
    '' - The input string with extra spaces removed.

    While InStr(str, "  ") > 0
        str = Replace(str, "  ", " ")
    Wend
    removeExtraSpaces = str
End Function

Function isLetter(x As String) As Boolean
    '' Checks if the input character is a letter (A-Z).
    ''
    '' Parameters:
    '' - x: A single character string.
    ''
    '' Returns:
    '' - True if the character is a letter, otherwise False.

    Select Case UCase(x)
        Case "A" To "Z"
            isLetter = True
        Case Else
            isLetter = False
    End Select
End Function

Function FixedVarName(Name As String) As String
    '' Converts a database field name into a valid VBA variable name.
    ''
    '' Parameters:
    '' - Name: The original database field name.
    ''
    '' Returns:
    '' - The adjusted variable name that is valid in VBA.

    Dim s As String
    s = Replace(Name, ".", "_")
    s = Replace(s, "!", "_")
    s = Replace(s, "@", "_")
    s = Replace(s, "$", "_")
    s = Replace(s, "&", "_")
    s = Replace(s, "#", "_")
    s = Replace(s, "[", "") ' Suppress database escape characters
    s = Replace(s, "]", "")
    If Not isLetter(Left(s, 1)) Then s = varPrefix & s
    FixedVarName = s
End Function

Function isPrimaryKey(VarDef As Variant) As Boolean
    '' Determines if a given variable definition corresponds to a primary key.
    ''
    '' Parameters:
    '' - VarDef: An array containing the variable definition elements.
    ''
    '' Returns:
    '' - True if the variable is a primary key, otherwise False.

    If UBound(VarDef) > 2 Then
        isPrimaryKey = VarDef(2) = "IDENTITY"
    Else
        isPrimaryKey = False
    End If
End Function

Function Singularize(tableName As String) As String
    '' Converts a plural table name into its singular form.
    ''
    '' Parameters:
    '' - tableName: The name of the table in plural form.
    ''
    '' Returns:
    '' - The singular form of the table name.

    Dim irregulars As Object
    Set irregulars = CreateObject("Scripting.Dictionary")
    
    ' Add irregular plural forms that are not supported by the algorithm below
    irregulars.Add "XXXs", "XXX" ' Used by template class
    ' Add more irregulars as needed
    
    ' Check if the table name is in the list of irregulars
    If irregulars.Exists(tableName) Then
        Singularize = irregulars(tableName)
        Exit Function
    End If
    
    ' Handling common plural forms
    Select Case True
        Case tableName Like "*ches", tableName Like "*shes", tableName Like "*ses", tableName Like "*xes", tableName Like "*zes"
            Singularize = Left(tableName, Len(tableName) - 2)
        Case tableName Like "*ies"
            Singularize = Left(tableName, Len(tableName) - 3) & "y"
        Case tableName Like "*criteria"
            Singularize = Left(tableName, Len(tableName) - 8) & "Criterion"
        Case tableName Like "*ia"
            Singularize = Left(tableName, Len(tableName) - 2) & "ium"
        Case Else
            Singularize = Left(tableName, Len(tableName) - 1)
    End Select
End Function

Sub Generate_DB_Record_Class()
    '' Generates VBA classes that represent database records, based on table definitions.
    ''
    '' The generated classes include fields corresponding to database columns, with appropriate
    '' data types and names. The classes are written to the specified directory.
    ''
    '' This method uses the `cCG_DB_Record_ClassWriter` class to generate the class files.

    Dim definition As cDB_Definition
    Dim ClassName As String
    Dim VarName As String
    Dim Vars() As String
    Dim VarDef() As String
    Dim dbVars As ArrayList
    Dim dbVar As cCG_DB_Variable
    Dim clsWriter As cCG_DB_Record_ClassWriter
    Dim i As Long
    
    Init_Context
    If DoYouWantToContinueOnEJPD <> vbOK Then Exit Sub
    
    Set dbTablesDefs = New cDB_Definitions
    dbTablesDefs.Initialize DbDefPath & Common_TablesDef_FileName

    For Each definition In dbTablesDefs.definitions
        ClassName = classPrefix & Singularize(definition.Name)
        Vars = Split(definition.definition, ",")
        Set clsWriter = New cCG_DB_Record_ClassWriter
        Set dbVars = New ArrayList
        For i = LBound(Vars) To UBound(Vars)
            VarDef = Split(Trim(removeExtraSpaces(Vars(i))), " ")
            VarName = VarDef(0)
            If Trim(VarName) = "CONSTRAINT" Then Exit For
            Set dbVar = New cCG_DB_Variable
            dbVar.Initialize Name:=VarName, Typ:=GetVbType(VarDef(1)), isPrimaryKey:=isPrimaryKey(VarDef)
            dbVars.Add dbVar
        Next i
        
        clsWriter.Initialize ClassName, dbVars
        clsWriter.WriteClass DocPath
    Next definition
End Sub

Sub Generate_DB_Class()
    '' Generates VBA classes that represent business objects based on table definitions.
    ''
    '' This method generates classes that can be used to manage collections of database
    '' records or perform business logic on them. The classes are written to the specified directory.
    ''
    '' This method uses the `cCG_DB_ClassWriter` class to generate the class files.

    Dim definition As cDB_Definition
    Dim ClassName As String
    Dim dbVars As ArrayList
    Dim clsWriter As cCG_DB_ClassWriter
    Dim tblPrefix As String
    Dim i As Long
    
    Init_Context
    If DoYouWantToContinueOnEJPD <> vbOK Then Exit Sub
    
    Set dbTablesDefs = New cDB_Definitions
    dbTablesDefs.Initialize DbDefPath & Common_TablesDef_FileName

    For Each definition In dbTablesDefs.definitions
        ClassName = classPrefix & definition.Name
        tblPrefix = ""
        Set clsWriter = New cCG_DB_ClassWriter
        Set dbVars = New ArrayList
        
        clsWriter.Initialize ClassName, "cDB_XXXs", tblPrefix
        clsWriter.WriteClass DocPath
    Next definition
End Sub

Sub Generate_Classes()
    '' Generates general-purpose VBA classes based on the provided definitions.
    ''
    '' This method generates classes that do not directly correspond to database tables
    '' but may be used for other parts of the application. The classes are written to
    '' the specified directory.
    ''
    '' This method uses the `cCG_ClassWriter` class to generate the class files.

    Dim definition As cDB_Definition
    Dim ClassName As String
    Dim VarName As String
    Dim Vars() As String
    Dim VarDef() As String
    Dim clsVars As ArrayList
    Dim Var As cCG_Variable
    Dim clsWriter As cCG_ClassWriter
    Dim i As Long
    
    Init_Context
    If DoYouWantToContinueOnEJPD <> vbOK Then Exit Sub
    Set dbTablesDefs = New cDB_Definitions
    dbTablesDefs.Initialize DbDefPath & ClassDefs_FileName

    For Each definition In dbTablesDefs.definitions
        ClassName = classPrefix & Mid(definition.Name, 5)
        Vars = Split(definition.definition, ",")
        Set clsWriter = New cCG_ClassWriter
        Set clsVars = New ArrayList
        For i = LBound(Vars) To UBound(Vars)
            VarDef = Split(Trim(removeExtraSpaces(Vars(i))), " ")
            VarName = FixedVarName(VarDef(0))
            Set Var = New cCG_Variable
            Var.Initialize VarName, VarDef(1)
            clsVars.Add Var
        Next i
        
        clsWriter.Initialize ClassName, clsVars
        clsWriter.WriteClass DocPath
    Next definition
End Sub

Sub Test_cCG_Variable()
    '' Tests the `cCG_Variable` class by initializing a variable and printing its properties.
    
    Dim Var As New cCG_Variable
    Var.Initialize "ClassName", "String"
    Debug.Print Var.Declaration
    Debug.Print Var.GetStatement
    Debug.Print Var.SetStatement
    
    Debug.Print vbCrLf & "Sub Initialize(" & Var.InitString & ")"
    Debug.Print Var.InitStatement
    Debug.Print "End Sub"
End Sub

Sub Test_cCG_CodeWriter()
    '' Tests the `cCG_ClassWriter` class by initializing it with variables and writing a class file.
    
    Dim Var As New cCG_Variable
    Dim ClassWriter As New cCG_ClassWriter
    Dim Vars As New ArrayList

    Set Var = New cCG_Variable
    Var.Initialize "Name", "String"
    Vars.Add Var

    Set Var = New cCG_Variable
    Var.Initialize "Count", "String"
    Vars.Add Var

    Set Var = New cCG_Variable
    Var.Initialize "col", "Collection"
    Vars.Add Var

    ClassWriter.Initialize "cMyTestClass", Vars

    Init_Context
    ClassWriter.WriteClass DocPath
End Sub

Sub Test_cCG_DB_CodeWriter()
    '' Tests the `cCG_DB_Record_ClassWriter` class by initializing it with database variables and writing a class file.
    
    Dim Var As New cCG_DB_Variable
    Dim ClassWriter As New cCG_DB_Record_ClassWriter
    Dim Vars As New ArrayList

    Set Var = New cCG_DB_Variable
    Var.Initialize "Name", "String"
    Vars.Add Var

    Set Var = New cCG_DB_Variable
    Var.Initialize "Count", "String"
    Vars.Add Var

    Set Var = New cCG_DB_Variable
    Var.Initialize "col", "Collection"
    Vars.Add Var

    ClassWriter.Initialize "cDB_TestClass", Vars

    Init_Context
    ClassWriter.WriteClass DocPath
End Sub
