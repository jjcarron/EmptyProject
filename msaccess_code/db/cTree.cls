VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "cTree"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'' Class : cTree
''
'' This class allows to retrieve files from a folder and its subfolders
'' according to a filter defined as a Regex pattern using the FileSystemObject.

Private myRoot  As String
Private oFSO As Scripting.FileSystemObject
Private oFolder As Scripting.Folder
Private FileList As Collection
Private DirList As Collection
Private Regexp As New cRegExp
Private myProblems As Collection

Property Get Problems() As Collection
    '' Returns a collection of problems encountered during file operations, such as errors or deleted hidden files.
    Set Problems = myProblems
End Property

Private Sub removeFile(index As Long)
    '' Removes a file from the collection if it is hidden, deletes the file, and logs the action or any errors encountered.
    Dim Name As String
    Dim f As Scripting.file
    Set f = FileList(index)
    Name = f.Name
    
    On Error GoTo err:
    If (f.Attributes And Hidden) Then
        FileList.Remove index
        f.Delete
        deletedFilesNumber = deletedFilesNumber + 1
        Problems.Add "HIDDEN FILE: " & Name & " has been deleted."
    End If
    Exit Sub
    
err:
    Problems.Add "ERROR: " & Name & " couldn't be removed."
End Sub

Property Get files(DirList As Collection, Optional filter As String = "") As Collection
    '' Returns a collection of files from the directories specified in DirList that match the optional filter pattern.
    Dim file As Scripting.file
    Dim err As String
    Dim Folder As Scripting.Folder
    Set FileList = New Collection
    
    For Each Folder In DirList
        For Each file In Folder.files
            If (filter = "" Or Regexp.Match_Pattern(file.Name, filter)) Then
                FileList.Add file
            End If
        Next
    Next
    Set files = FileList
End Property

Property Get RootFiles(Optional filter As String = "") As Collection
    '' Returns a collection of files from the root folder that match the optional filter pattern.
    Dim file As Scripting.file
    Set FileList = New Collection
    
    For Each file In oFolder.files
        If filter = "" Or Regexp.Match_Pattern(file.Name, filter) Then
            FileList.Add file
        End If
    Next
    Set RootFiles = FileList
End Property

Private Sub addDirRecurs(ByRef f As Scripting.Folder, Optional filter As String = "", Optional FilterRootOnly As Boolean = False)
    '' Recursively adds directories to the DirList collection that match the optional filter pattern.
    Dim s As Scripting.Folder
    If f.SubFolders.count > 0 Then
        For Each s In f.SubFolders
            If filter = "" Or Regexp.Match_Pattern(s.Name, filter) Then
                DirList.Add s
                If FilterRootOnly Then
                    addDirRecurs s
                Else
                    addDirRecurs s, filter, FilterRootOnly
                End If
            End If
        Next
    End If
End Sub

Property Get dirs(Optional recursive As Boolean = False, Optional filter As String = "", Optional FilterRootOnly As Boolean = False) As Collection
    '' Returns a collection of directories from the root folder that match the optional filter pattern.
    '' If recursive is True, subdirectories are also included based on the specified options.
    Set DirList = New Collection
    Dim s As Scripting.Folder
    
    For Each s In oFolder.SubFolders
        If filter = "" Or Regexp.Match_Pattern(s.Name, filter) Then
            DirList.Add s
            If recursive Then
                If FilterRootOnly Then
                    addDirRecurs s
                Else
                    addDirRecurs s, filter, FilterRootOnly
                End If
            End If
        End If
    Next
    Set dirs = DirList
End Property

Property Get fso()
    '' Returns the FileSystemObject instance.
    Set fso = oFSO
End Property

Property Get Folder()
    '' Returns the root folder object.
    Set Folder = oFolder
End Property

Sub Initialize(root As String)
    '' Initializes the class by setting the root directory and creating the necessary FileSystemObject and folder objects.
    Set myProblems = New Collection
    myRoot = root
    ' Create an instance of the FileSystemObject
    Set oFSO = CreateObject("Scripting.FileSystemObject")
    ' Get the folder object
    Set oFolder = oFSO.GetFolder(myRoot)
End Sub

