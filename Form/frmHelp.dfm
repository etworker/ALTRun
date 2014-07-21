object HelpForm: THelpForm
  Left = 0
  Top = 0
  Caption = 'Help'
  ClientHeight = 326
  ClientWidth = 442
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    442
    326)
  PixelsPerInch = 96
  TextHeight = 15
  object mmoAbout: TMemo
    Left = 8
    Top = 8
    Width = 426
    Height = 279
    Anchors = [akLeft, akTop, akRight, akBottom]
    Ctl3D = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #23435#20307
    Font.Style = []
    ParentCtl3D = False
    ParentFont = False
    ParentShowHint = False
    ReadOnly = True
    ScrollBars = ssBoth
    ShowHint = False
    TabOrder = 0
    WordWrap = False
  end
  object btnOK: TBitBtn
    Left = 359
    Top = 293
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    TabOrder = 1
    Kind = bkOK
  end
end
