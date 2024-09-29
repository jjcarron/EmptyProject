VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "cXL"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'' Class : cXL
''
'' This class manages an Excel File
''
Option Compare Database

Private myFullPath As String
Private myPath As String
Private myFileName As String
Private myBook As Workbook
Private mySaveChanges As Boolean
Private CanClose As Boolean

Private myXLApp As cXL_App

Property Get Filename() As String
    '' Returns the file name extracted from the full path of the workbook.
    If myFullPath <> "" Then
        Filename = Right(myFullPath, Len(myFullPath) - InStrRev(myFullPath, "\", Len(myFullPath)))
    Else
        Filename = ""
    End If
End Property

Property Get Path() As String
    '' Returns the directory path where the workbook is located.
    If myFullPath <> "" Then
        Path = Left(myFullPath, InStrRev(myFullPath, "\", Len(myFullPath)))
    Else
        Path = ""
    End If
End Property

Property Get fullPath() As String
    '' Returns the full path of the workbook.
    fullPath = myFullPath
End Property

Sub setStandardValues()
    '' Restores standard Excel settings such as screen updating, status bar visibility,
    '' automatic calculation mode, and event handling. This is typically called after
    '' speeding up operations or before closing the workbook.
    Dim myApp As Excel.Application
    Set myApp = myBook.Application
    myApp.ScreenUpdating = True
    myApp.DisplayStatusBar = True
    myApp.Calculation = xlCalculationAutomatic
    myApp.EnableEvents = True
    'myApp.WindowState = xlNormal
End Sub

Sub Speedup()
    '' Disables certain Excel features to speed up the execution of code, such as screen updating,
    '' status bar visibility, and event handling. This is useful when performing bulk operations
    '' to improve performance.
    Dim myApp As Excel.Application
    Set myApp = myBook.Application
    ' Turn off some Excel functionality so the code runs faster
    myApp.ScreenUpdating = False
    myApp.DisplayStatusBar = False
    myApp.Calculation = xlCalculationAutomatic ' Keep automatic to ensure correctness
    myApp.EnableEvents = False
    'myApp.WindowState = xlMinimized
End Sub

Function newBook() As Workbook
    '' Creates a new Excel workbook using the Excel application instance and returns it.
    Dim App As Excel.Application
    Set App = Get_XL_App
    Set newBook = App.Workbooks.Add
End Function

Function OpenBook(FilePath As String, Optional SaveOnClose As Boolean = False) As Workbook
    '' Opens an Excel workbook from the specified file path. If the workbook is already open in Excel,
    '' it will reference that instance. If not, it will open a new instance and optimize Excel settings for speed.
    '' The function also handles errors if the file cannot be opened and returns the workbook object.
    myFullPath = FilePath
    mySaveChanges = SaveOnClose
    Dim xl As Excel.Application
    
    ' Check if the workbook is already open in Excel
    If InStr(1, Application.Name, "Excel") > 0 Then
        Set myBook = Workbooks(Name)
        CanClose = False
    Else
    On Error GoTo ErrorHandler
        Set xl = Get_XL_App
        Set myBook = xl.Workbooks.Open(FilePath)
        CanClose = True
        Speedup
    End If
    
    ' Assume already saved file
    myBook.Saved = True
    Set OpenBook = myBook
    Exit Function
    
ErrorHandler:
    Namex = Right(myFullPath, Len(myFullPath) - InStrRev(myFullPath, "\"))
    msg = "File " & Namex & " couldn't be opened. It is probably open in another instance of Excel."
    MsgBox Prompt:="File " & msg, Buttons:=vbOK, Title:="WARNING"
End Function

Sub Save()
    '' Saves the currently open workbook.
    myBook.Save
End Sub

Sub CloseBook()
    '' Closes the workbook if it was opened by this instance. It also resets Excel settings
    '' to their standard values and optionally saves changes.
    On Error Resume Next
    If CanClose Then
        myBook.Application.DisplayAlerts = False
        myBook.Close SaveChanges:=mySaveChanges
        myBook.Application.DisplayAlerts = True
        setStandardValues
        Set myBook = Nothing
    End If
End Sub

Sub Class_Terminate()
    '' Ensures the workbook is properly closed when the class instance is destroyed.
    CloseBook
End Sub

