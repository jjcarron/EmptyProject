VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "cAccessStatusBar"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Compare Database

Private myMaxMeter As Long
Private myCurrVal As Long

'' ==============================================================================
'' Class : cAccessStatusBar
''
'' Description:
'' The `cAccessStatusBar` class simplifies the management of the Access status bar,
'' particularly for displaying progress meters and status messages during operations.
'' It provides methods for initializing, updating, and clearing the status bar,
'' as well as managing the progress meter in a streamlined manner.
''
'' Key Responsibilities:
'' - Initialize and display a progress meter on the Access status bar.
'' - Update the progress meter as tasks are processed.
'' - Display and update status messages on the status bar.
'' - Clear the status bar and remove the progress meter when operations are complete.
''
'' Dependencies:
'' - Utilizes Access's built-in `SysCmd` function for managing the status bar.
''
'' Usage:
'' 1. Use `InitMeter` to initialize the progress meter with a message and the maximum value.
'' 2. Use `UpdateMeter` or `NextMeter` to update the progress meter as tasks progress.
'' 3. Use `SetStatus` to display custom messages on the status bar.
'' 4. Use `ClearStatus` and `RemoveMeter` to clear the status bar and remove the meter.
''
'' Example:
'' Dim statusBar As New cAccessStatusBar
'' statusBar.InitMeter "Processing records...", 100
'' For i = 1 To 100
''     ' Process records...
''     statusBar.NextMeter
'' Next i
'' statusBar.ClearStatus
'' statusBar.RemoveMeter
''
'' ==============================================================================

Sub InitMeter(msg As String, MaxMeter As Long)
'' Initializes the status bar with a progress meter.
''
'' Parameters:
'' - msg: The message to display on the status bar.
'' - MaxMeter: The total number of elements to be processed, representing the maximum value of the progress meter.
    myMaxMeter = MaxMeter
    myCurrVal = 0
    SysCmd acSysCmdInitMeter, msg, MaxMeter
End Sub

Sub UpdateMeter(value As Long)
'' Updates the current position of the progress meter.
'' This should be called with a value less than or equal to the total number of elements.
''
'' Parameters:
'' - value: The current value to set the progress meter to.
    myCurrVal = value
    SysCmd acSysCmdUpdateMeter, myCurrVal
    DoEvents
End Sub

Sub NextMeter(Optional Increment As Long = 1)
'' Increments the progress meter by a specified amount.
'' This is typically used within a loop to advance the meter as each task is completed.
''
'' Parameters:
'' - Increment: (Optional) The amount to increment the meter by. Default is 1.
    myCurrVal = myCurrVal + Increment
    If myCurrVal > myMaxMeter Then myCurrVal = myMaxMeter
    SysCmd acSysCmdUpdateMeter, myCurrVal
End Sub

Sub SetStatus(msg As String)
'' Sets a new message on the status bar.
''
'' Parameters:
'' - msg: The message to display on the status bar.
    SysCmd acSysCmdSetStatus, msg
End Sub

Sub ClearStatus()
'' Clears any message currently displayed on the status bar.
    SysCmd acSysCmdClearStatus
End Sub

Sub RemoveMeter()
'' Removes the progress meter from the status bar.
    SysCmd acSysCmdRemoveMeter
End Sub

Sub Class_Terminate()
'' Cleans up the status bar by clearing the message and removing the meter when the object is destroyed.
    ClearStatus
    RemoveMeter
End Sub

