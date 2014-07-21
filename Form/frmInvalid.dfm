object InvalidForm: TInvalidForm
  Left = 0
  Top = 0
  Caption = 'Invalid ShortCut List'
  ClientHeight = 326
  ClientWidth = 472
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    472
    326)
  PixelsPerInch = 96
  TextHeight = 13
  object btnOK: TBitBtn
    Left = 308
    Top = 293
    Width = 75
    Height = 25
    Hint = 'Save and close this window'
    Anchors = [akRight, akBottom]
    Caption = '&OK'
    Default = True
    ModalResult = 1
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    TabStop = False
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333333333333333330000333333333333333333333333F33333333333
      00003333344333333333333333388F3333333333000033334224333333333333
      338338F3333333330000333422224333333333333833338F3333333300003342
      222224333333333383333338F3333333000034222A22224333333338F338F333
      8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
      33333338F83338F338F33333000033A33333A222433333338333338F338F3333
      0000333333333A222433333333333338F338F33300003333333333A222433333
      333333338F338F33000033333333333A222433333333333338F338F300003333
      33333333A222433333333333338F338F00003333333333333A22433333333333
      3338F38F000033333333333333A223333333333333338F830000333333333333
      333A333333333333333338330000333333333333333333333333333333333333
      0000}
    NumGlyphs = 2
  end
  object btnCancel: TBitBtn
    Left = 389
    Top = 293
    Width = 75
    Height = 25
    Hint = 'Cancel all modification'
    Anchors = [akRight, akBottom]
    Caption = '&Cancel'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    TabStop = False
    Kind = bkCancel
  end
  object lvShortCut: TListView
    Left = 0
    Top = 0
    Width = 472
    Height = 287
    Hint = 'Checked ShortCut will be removed when "OK" button clicked'
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    Checkboxes = True
    Columns = <
      item
        Caption = 'ShortCut'
        Width = 100
      end
      item
        Caption = 'Name'
        Width = 100
      end
      item
        Caption = 'Param Type'
        Width = 100
      end
      item
        Caption = 'Command Line'
        Width = 400
      end>
    Ctl3D = False
    DragMode = dmAutomatic
    FlatScrollBars = True
    FullDrag = True
    GridLines = True
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    ParentShowHint = False
    PopupMenu = pmInvalid
    ShowHint = True
    TabOrder = 2
    ViewStyle = vsReport
  end
  object pmInvalid: TPopupMenu
    Left = 104
    Top = 40
    object S1: TMenuItem
      Caption = 'Select &All'#13#10
      OnClick = S1Click
    end
    object mniUnselectAll1: TMenuItem
      Caption = '&Unselect All'
      OnClick = mniUnselectAll1Click
    end
    object mniN1: TMenuItem
      Caption = '-'
    end
    object mniTest: TMenuItem
      Caption = '&Test'
      OnClick = mniTestClick
    end
  end
end
