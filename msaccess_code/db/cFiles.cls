VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "cFiles"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'' Class : cFiles
''
'' This class manages a Scripting.File collection.

Option Compare Database
Private myTree As cTree
Private myFiles As Collection

Property Get count()
    '' Returns the number of files in the collection.
    count = myFiles.count
End Property

Property Get files()
    '' Returns the collection of files that match the specified filter.
    Set files = myFiles
End Property

Sub Initialize(root As String, filter As String)
    '' Initializes the cFiles class by creating a cTree instance and populating the file collection.
    '' Parameters:
    ''   - root: The root directory to search for files.
    ''   - filter: A string pattern used to filter files in the root directory.
    Set myTree = New cTree
    myTree.Initialize root
    Set myFiles = myTree.RootFiles(filter)
End Sub

