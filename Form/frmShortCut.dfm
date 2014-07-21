object ShortCutForm: TShortCutForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'ShortCut'
  ClientHeight = 257
  ClientWidth = 494
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = #23435#20307
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    494
    257)
  PixelsPerInch = 96
  TextHeight = 13
  object btnOK: TBitBtn
    Left = 330
    Top = 224
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    TabOrder = 2
    OnClick = btnOKClick
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
    Left = 411
    Top = 224
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    TabOrder = 3
    Kind = bkCancel
  end
  object grpShortCut: TGroupBox
    Left = 8
    Top = 8
    Width = 478
    Height = 105
    Anchors = [akLeft, akTop, akRight]
    Caption = 'ShortCut'
    TabOrder = 0
    DesignSize = (
      478
      105)
    object btnFile: TButton
      Left = 360
      Top = 71
      Width = 52
      Height = 21
      Hint = 'Select File Name'
      Anchors = [akRight]
      Caption = 'File'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnClick = btnFileClick
    end
    object lbledtCommandLine: TLabeledEdit
      Left = 96
      Top = 71
      Width = 258
      Height = 19
      Hint = 
        '"%p" in Command Line will be replaced with param; "%c" will be r' +
        'eplaced with Clipboard text'
      Anchors = [akLeft, akRight]
      Ctl3D = False
      EditLabel.Width = 84
      EditLabel.Height = 13
      EditLabel.Caption = 'Command Line'
      ImeMode = imClose
      LabelPosition = lpLeft
      ParentCtl3D = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
    end
    object lbledtName: TLabeledEdit
      Left = 96
      Top = 42
      Width = 372
      Height = 19
      Anchors = [akLeft, akRight]
      Ctl3D = False
      EditLabel.Width = 28
      EditLabel.Height = 13
      EditLabel.Caption = 'Name'
      LabelPosition = lpLeft
      ParentCtl3D = False
      TabOrder = 1
    end
    object lbledtShortCut: TLabeledEdit
      Left = 96
      Top = 13
      Width = 372
      Height = 19
      Anchors = [akLeft, akRight]
      Ctl3D = False
      EditLabel.Width = 56
      EditLabel.Height = 13
      EditLabel.Caption = 'ShortCut'
      ImeMode = imClose
      LabelPosition = lpLeft
      ParentCtl3D = False
      TabOrder = 0
    end
    object btnDir: TButton
      Left = 416
      Top = 71
      Width = 52
      Height = 21
      Hint = 'Select Directory Name'
      Anchors = [akRight]
      Caption = 'Dir'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      OnClick = btnDirClick
    end
  end
  object rgParam: TRadioGroup
    Left = 8
    Top = 119
    Width = 478
    Height = 98
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Param Type'
    Ctl3D = True
    ItemIndex = 0
    Items.Strings = (
      'No Param'
      'Param without encoding'
      'Param with URL encoding (e.g. Baidu/Google search query)'
      'Param with UTF-8 encoding (e.g. Yahoo/MSN search query)')
    ParentCtl3D = False
    TabOrder = 1
  end
  object btnHelp: TBitBtn
    Left = 249
    Top = 223
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    TabOrder = 4
    Visible = False
    OnClick = btnHelpClick
    Kind = bkHelp
  end
  object btnTest: TBitBtn
    Left = 8
    Top = 224
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = '&Test'
    TabOrder = 5
    OnClick = btnTestClick
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00344446333334
      44433333FFFF333333FFFF33000033AAA43333332A4333338833F33333883F33
      00003332A46333332A4333333383F33333383F3300003332A2433336A6633333
      33833F333383F33300003333AA463362A433333333383F333833F33300003333
      6AA4462A46333333333833FF833F33330000333332AA22246333333333338333
      33F3333300003333336AAA22646333333333383333F8FF33000033444466AA43
      6A43333338FFF8833F383F330000336AA246A2436A43333338833F833F383F33
      000033336A24AA442A433333333833F33FF83F330000333333A2AA2AA4333333
      333383333333F3330000333333322AAA4333333333333833333F333300003333
      333322A4333333333333338333F333330000333333344A433333333333333338
      3F333333000033333336A24333333333333333833F333333000033333336AA43
      33333333333333833F3333330000333333336663333333333333333888333333
      0000}
    NumGlyphs = 2
  end
  object dlgOpenFile: TOpenDialog
    Left = 280
    Top = 80
  end
end
