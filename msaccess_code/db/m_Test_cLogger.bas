Attribute VB_Name = "m_Test_cLogger"
Option Compare Database
Dim log As New cLogger

'' This module tests the functionality of the `cLogger` class, which is responsible for logging events.

Function TestNewLogger() As Boolean
    '' Tests the initialization of a new logger instance.
    '' Returns True if the logger is initialized correctly and the log file exists, False otherwise.
    
    Dim x As String
    Dim Name As String: Name = LogPath & "LoggerTest.log"
    log.Initialize LogPath & "LoggerTest.log", eAll
    x = log.FullName
    TestNewLogger = Dir(x) = log.Filename
End Function

Function TestNewLoggerArchive() As Boolean
    '' Tests the initialization of a new logger instance with archiving enabled.
    '' Returns True if the logger is initialized correctly and the archived log file has the correct prefix, False otherwise.
    
    Dim log As New cLogger ' Just a local test instance
    Dim x As String
    Dim Name As String: Name = "V:\Work\" & "LoggerTest.log"
    log.Initialize LogPath & "LoggerTest.log", eAll, DebugPrint:=False, archive:=True
    x = log.FullName
    TestNewLoggerArchive = Left(Dir(x), 3) = "A20"
End Function

Function TestLogEvent() As Boolean
    '' Tests logging of multiple events to the log file.
    '' Returns True if the events are logged correctly and the line count matches the expected value, False otherwise.
    
    Dim x As String
    x = "It works..."
    log.Initialize LogPath & "LoggerTest.log", eAll, DebugPrint:=False, archive:=True
    For i = 1 To 100
        log.LogEvent x, eInfo
    Next
    TestLogEvent = log.currentLine = 101
End Function

Function TestResetFile() As Boolean
    '' Tests the resetting of the log file.
    '' Returns True if the log file is reset correctly and the line count is 1, False otherwise.
    
    log.resetFile
    TestResetFile = log.currentLine = 1
End Function

Function TestResetFileNewName() As Boolean
    '' Tests resetting the log file with a new name.
    '' Returns True if the log file is reset with the new name, False otherwise.
    
    Dim NewName As String
    NewName = "MyNewName.log"
    log.resetFile NewName
    TestResetFileNewName = Right(Dir(log.FullName), Len(NewName)) = NewName
End Function

