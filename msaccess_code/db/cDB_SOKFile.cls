VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "cDB_SOKFile"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

' Region "============================= Generated Code =============================="

'' Class : cDB_SokFile

''
'' Code generated from the Class Definition 'Classes.def' at 24.05.2024
'' by cCG_ClassWriter
''

Private myFileSize As Long
Private myid As Long
Private myisLoaded As Boolean
Private myLastChange As Date
Private myName As String
Private myPath As String
Private myYear As Long

Property Get FileSize() As Long
        FileSize = myFileSize
End Property

Property Let FileSize(FileSize As Long)
        myFileSize = FileSize
End Property

Property Get id() As Long
        id = myid
End Property

Property Let id(id As Long)
        myid = id
End Property

Property Get isLoaded() As Boolean
        isLoaded = myisLoaded
End Property

Property Let isLoaded(isLoaded As Boolean)
        myisLoaded = isLoaded
End Property

Property Get LastChange() As Date
        LastChange = myLastChange
End Property

Property Let LastChange(LastChange As Date)
        myLastChange = LastChange
End Property

Property Get Name() As String
        Name = myName
End Property

Property Let Name(Name As String)
        myName = Name
End Property

Property Get Path() As String
        Path = myPath
End Property

Property Let Path(Path As String)
        myPath = Path
End Property

Property Get Year() As Long
        Year = myYear
End Property

Property Let Year(Year As Long)
        myYear = Year
End Property

Property Get record() As cDB_Record
'' Returns the DB-Record
        Dim lRecord As New cDB_Record
        Dim Field As cDB_Field

        Set Field = New cDB_Field
        Field.Initialize Col:="FileSize", Val:=myFileSize
        lRecord.Add Field

        Set Field = New cDB_Field
        Field.Initialize Col:="isLoaded", Val:=myisLoaded
        lRecord.Add Field

        Set Field = New cDB_Field
        Field.Initialize Col:="LastChange", Val:=myLastChange
        lRecord.Add Field

        Set Field = New cDB_Field
        Field.Initialize Col:="Name", Val:=myName
        lRecord.Add Field

        Set Field = New cDB_Field
        Field.Initialize Col:="Path", Val:=myPath
        lRecord.Add Field

        Set Field = New cDB_Field
        Field.Initialize Col:="[Year]", Val:=myYear
        lRecord.Add Field

        Set record = lRecord
End Property

Sub InitializeFromDB_Record(rec As cDB_Record)
'' initialize the object content from the database record
        On Error Resume Next
        myFileSize = rec.column("FileSize").value
        myid = rec.column("id").value
        myisLoaded = rec.column("isLoaded").value
        myLastChange = rec.column("LastChange").value
        myName = rec.column("Name").value
        myPath = rec.column("Path").value
        myYear = rec.column("Year").value
        On Error GoTo 0
End Sub


Sub Initialize(FileSize As Long, isLoaded As Boolean, LastChange As Date, Name As String, Path As String, Year As Long)
'' If you need to initialize with Primary key, add the corresponding field manually
        myFileSize = FileSize
        myid = id
        myisLoaded = isLoaded
        myLastChange = LastChange
        myName = Name
        myPath = Path
        myYear = Year
End Sub

' Region "============================= User Code  =============================="

Property Get fullPath() As String
    '' Returns the full path of the file by concatenating the path and the file name.
    fullPath = myPath & myName
End Property

Sub initializeFromFileSystem(file As Scripting.file)
    '' Initializes the object content from a file system object.
    '' The method extracts the file name, path, last modified date, and size from the provided file object.
    '' If the file name matches a specified pattern (cSOKFilter), it also extracts and sets the year from the file name.
    '' Parameters:
    ''   - file: The Scripting.file object representing the file to initialize the object with.
    
    Dim Regexp As New cRegExp
    Dim Casino As String
    Dim matches As Collection
    
    myName = file.Name
    
    If Regexp.Match_Pattern(myName, cSOKFilter) Then
        Set matches = Regexp.matches
        myYear = matches(1) ' Assumes the year is the first captured group in the regex pattern
    End If
    
    myFullPath = file.Path
    myPath = Left(myFullPath, Len(myFullPath) - Len(myName))
    myLastChange = file.DateLastModified
    myFileSize = file.Size
    myisLoaded = 0 ' Presumably indicates that the file has not yet been processed or loaded
End Sub

