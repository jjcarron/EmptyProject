VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "cXL_App"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'' Class : cXL_App
''
'' This class creates an Excel Application object and
'' ensures that it is destroyed when the object is destroyed.
''

Option Compare Database
Private myApp As Excel.Application
Private myBook As Workbook

Property Get Application() As Excel.Application
    '' Returns the Excel Application object.
    Set Application = myApp
End Property

Private Sub Class_Initialize()
    '' Initializes the class by creating a new instance of the Excel Application.
    Set myApp = CreateObject("Excel.Application")
End Sub

Private Sub Class_Terminate()
    '' Terminates the class by closing any open workbooks and quitting the Excel Application.
    '' This ensures that the Excel Application is properly destroyed when the object is destroyed.
    On Error Resume Next
    myApp.Workbooks.Close
    myApp.Quit
    Set myApp = Nothing
End Sub

