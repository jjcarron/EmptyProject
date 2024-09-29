VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "cDB_Menu"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'' Class : cDB_Menu
''
'' This class manages the menu of the MS Access application.

Option Compare Database

Private Const cMenus As String = "Menus"
Private Const tpopup As String = "POPUP"
Private Const tbutton As String = "BUTTON"
Private oldMenu As String
Private currentMenu As String

Function SetMenu(MenuName As String, Optional force As Boolean) As Boolean
    '' Sets the active menu bar to the specified MenuName, creating it from the database if necessary.
    '' The menu is created from records in the "Menus" table, and user permissions are considered.
    '' Parameters:
    ''   - MenuName: The name of the menu to set.
    ''   - force: Optional. If True, forces the menu to be reset even if it is already active.
    '' Returns:
    ''   - Boolean: True if the menu was successfully set, False otherwise.
    
    Dim customBar As CommandBar
    Dim MenuPopup As CommandBarPopup
    Dim MenuButton As CommandBarButton
    Dim r As New cDB_ResourceStrings
    Dim Menus As New cDB_Records
    Dim inst As New cDB_Instruction
    Dim Item As cDB_Record
    Dim ctrl As CommandBarControl
    
    If Not force And MenuName = CommandBars.ActiveMenuBar.Name Then
        ' Nothing to do if the menu is already active and force is not set
        Exit Function
    End If
    
    ' Save and disable the old menu bar
    oldMenu = CommandBars.ActiveMenuBar.Name
    ' CommandBars(oldMenu).Enabled = False
    
    ' Prevent error during development
    On Error Resume Next
    CommandBars(MenuName).Delete
    On Error GoTo 0

    ' Create the menu bar
    Set customBar = CommandBars.Add(Name:=MenuName, MenuBar:=True, Temporary:=True)
    
    ' Get the first menu level from the database
    inst.InitFromStr action:=eReadRow, Table:=cMenus, columns:="Menu_Ref, MenuType, Callback, UserLevel, NewGroup", _
                     Where:="(Form_Ref='" & MenuName & "' AND Parent_Ref='" & MenuName & "'  AND MenuLevel=1)", PostCondition:="ORDER BY MenuOrder ASC"
    inst.execute records:=Menus
    
    Dim MnuActive As Boolean
    For Each Item In Menus.records
        ' Determine if the user has the rights based on UserLevel
        Select Case Item.column(4).value
        Case 0:
            MnuActive = True
        Case 1:
            MnuActive = TheCurrentUser.isAdmin
        Case 2:
            MnuActive = TheCurrentUser.isAdmin ' Additional checks can be added here
        Case Else
            MnuActive = False
        End Select
        
        If MnuActive Then
            Select Case Item.column(2).value
            Case tpopup
                Set MenuPopup = customBar.Controls.Add(Type:=msoControlPopup)
                With MenuPopup
                    .Caption = r.str(Item.column(1).value)
                    .BeginGroup = Item.column(5).value
                End With
                SetMenuLevel2 MenuName:=MenuName, Parent:=MenuPopup, ParentStrID:=Item.column(1).value
            Case tbutton
                Set MenuButton = customBar.Controls.Add(Type:=msoControlButton)
                With MenuButton
                    .Caption = r.str(Item.column(1).value)
                    .BeginGroup = Item.column(5).value
                    .OnAction = Item.column(3).value
                End With
            Case Else
                MsgBox Prompt:="This type is not implemented", Buttons:=vbCritical + vbOKOnly, Title:=r.str("MSG_ERROR")
            End Select
        End If
    Next
        
    currentMenu = MenuName
    customBar.Visible = True
    SetMenu = True
End Function

Private Sub SetMenuLevel2(MenuName As String, Parent As CommandBarPopup, ParentStrID As String)
    '' Sets the second level of the menu, adding items as either popups or buttons.
    '' This method is called recursively to build out submenus.
    '' Parameters:
    ''   - MenuName: The name of the menu to set.
    ''   - Parent: The CommandBarPopup object representing the parent menu item.
    ''   - ParentStrID: The string identifier of the parent menu item.
    
    Dim customBar As CommandBar
    Dim MenuPopup As CommandBarPopup
    Dim MenuButton As CommandBarButton
    Dim r As New cDB_ResourceStrings
    Dim Menus As New cDB_Records
    Dim inst As New cDB_Instruction
    Dim Item As cDB_Record
    
    ' Get the second menu level from the database
    inst.InitFromStr action:=eReadRow, Table:=cMenus, columns:="Menu_Ref, MenuType, Callback, UserLevel, NewGroup", _
                     Where:="(Form_Ref='" & MenuName & "' AND Parent_Ref='" & ParentStrID & "' AND MenuLevel=2)", PostCondition:="ORDER BY MenuOrder ASC"
    inst.execute records:=Menus

    For Each Item In Menus.records
        ' Determine if the user has the rights based on UserLevel
        If (Item.column(4).value = 0) Or TheCurrentUser.isAdmin Then
            Select Case Item.column(2).value
            Case tpopup
                Set MenuPopup = Parent.Controls.Add(Type:=msoControlPopup)
                With MenuPopup
                    .Caption = r.str(Item.column(1).value)
                    .BeginGroup = Item.column(5).value
                End With
                SetMenuLevel3 MenuName:=MenuName, Parent:=MenuPopup, ParentStrID:=Item.column(1).value
            Case tbutton
                Set MenuButton = Parent.Controls.Add(Type:=msoControlButton)
                With MenuButton
                    .Caption = r.str(Item.column(1).value)
                    .BeginGroup = Item.column(5).value
                    If Item.column(3).value <> "" Then
                       .OnAction = Item.column(3).value
                    End If
                End With
            Case Else
                MsgBox Prompt:="This type is not implemented", Buttons:=vbCritical + vbOKOnly, Title:=r.str("MSG_ERROR")
            End Select
        End If
    Next
End Sub

Private Sub SetMenuLevel3(MenuName As String, Parent As CommandBarPopup, ParentStrID As String)
    '' Sets the third level of the menu, adding items as either popups or buttons.
    '' Parameters:
    ''   - MenuName: The name of the menu to set.
    ''   - Parent: The CommandBarPopup object representing the parent menu item.
    ''   - ParentStrID: The string identifier of the parent menu item.
    
    Dim customBar As CommandBar
    Dim MenuPopup As CommandBarPopup
    Dim MenuButton As CommandBarButton
    Dim r As New cDB_ResourceStrings
    Dim Menus As New cDB_Records
    Dim inst As New cDB_Instruction
    Dim Item As cDB_Record
    
    ' Get the third menu level from the database
    inst.InitFromStr action:=eReadRow, Table:=cMenus, columns:="Menu_Ref, MenuType, Callback, UserLevel, NewGroup", _
                     Where:="(Form_Ref='" & MenuName & "' AND Parent_Ref='" & ParentStrID & "' AND MenuLevel=3)", PostCondition:="ORDER BY MenuOrder ASC"
    inst.execute records:=Menus

    For Each Item In Menus.records
        ' Determine if the user has the rights based on UserLevel
        If (Item.column(4).value = 0) Or TheCurrentUser.isAdmin Then
            Select Case Item.column(2).value
            Case tpopup
                Set MenuPopup = Parent.Controls.Add(Type:=msoControlPopup)
                With MenuPopup
                    .Caption = r.str(Item.column(1).value)
                    .BeginGroup = Item.column(5).value
                End With
            Case tbutton
                Set MenuButton = Parent.Controls.Add(Type:=msoControlButton)
                With MenuButton
                    .Caption = r.str(Item.column(1).value)
                    .BeginGroup = Item.column(5).value
                    .OnAction = Item.column(3).value
                End With
            Case Else
                MsgBox Prompt:="This type is not implemented", Buttons:=vbCritical + vbOKOnly, Title:=r.str("MSG_ERROR")
            End Select
        End If
    Next
End Sub

Sub resetMenu()
    '' Resets the current menu bar to the default state.
    On Error Resume Next
    CommandBars(currentMenu).Delete
    CommandBars("Menu Bar").Reset
    CommandBars("Menu Bar").Enabled = True
    CommandBars("Menu Bar").Visible = True
End Sub

Sub restoreMenu()
    '' Restores the previous menu bar that was active before the current menu was set.
    On Error Resume Next
    CommandBars(currentMenu).Delete
    CommandBars(oldMenu).Enabled = True
    CommandBars(oldMenu).Visible = True
End Sub


