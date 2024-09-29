VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "cTimer"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

'' Class : cTimer

''
'' This class provides simple timer finctionality
''

Dim myLaps As New Collection
Dim myStartTime, myCurrTime, myElapsed
Dim myLapIndex As Integer
Dim myTimeTicks As Double
Dim myLastTicks As Double
Const secPerMinute As Double = 60
Const secPerHour As Double = 60 * secPerMinute
Const secPerDay As Double = 24 * secPerHour

Property Get StartTime() As Double
    '' Returns the start time of the first lap.
    If myLaps.count > 0 Then
        StartTime = myLaps(1)
    Else
        StartTime = 0
    End If
End Property

Property Get HMS(ByVal time As Double) As String
    '' Converts a time value in seconds to a formatted string in "hh:mm:ss" format.
    HMS = Format(time / 86400, "hh:nn:ss")
End Property

Property Get Elapsed() As Double
    '' Returns the elapsed time from the start of the first lap to the current time.
    Elapsed = Timer - myLaps(1)
End Property

Property Get Lap(n As Integer) As Double
    '' Returns the duration of the nth lap.
    '' The lap duration is calculated as the difference between the nth and (n+1)th lap times.
    myLapsIndex = n
    If n <= myLaps.count - 1 And n >= 1 Then
        Lap = myLaps(n + 1) - myLaps(n)
    Else
        Lap = 0
    End If
End Property

'Property Get nextLap() As Double
' implemented yet
'    '' Returns the duration of the next lap and increments the lap index.
'    nextLap = Lap(myLapsIndex)
'    myLapsIndex = myLapsIndex + 1
'End Property

Property Let TimeTicks(TimeInterval As Double)
    '' Sets the time interval (in seconds) for checking time ticks.
    myTimeTicks = TimeInterval
End Property

Property Get TimeTicksElapsed() As Boolean
    '' Checks if the specified time interval (TimeTicks) has elapsed since the last tick.
    '' Returns True if the time interval has elapsed, and updates the last tick time.
    If Timer > myLastTicks + myTimeTicks Then
        TimeTicksElapsed = True
        myLastTicks = Timer
    Else
        TimeTicksElapsed = False
    End If
End Property

Sub TStart()
    '' Starts the timer by recording the current time as the first lap and initializes the lap index.
    Dim t As Double
    myLapsIndex = 1
    Set myLaps = New Collection
    t = Timer
    myLastTicks = t
    myLaps.Add t
End Sub

Sub TStop()
    '' Stops the timer by recording the current time as the final lap.
    Dim t As Double
    t = Timer
    myLaps.Add t
End Sub

Sub TReset()
    '' Resets the timer and clears all recorded laps.
    myLapsIndex = 1
    Set myLaps = New Collection
End Sub


