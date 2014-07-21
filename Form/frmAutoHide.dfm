object AutoHideForm: TAutoHideForm
  Left = 0
  Top = 0
  AlphaBlend = True
  BorderStyle = bsDialog
  Caption = 'AutoHideForm'
  ClientHeight = 208
  ClientWidth = 394
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    394
    208)
  PixelsPerInch = 96
  TextHeight = 16
  object lblInfo: TLabel
    Left = 8
    Top = 16
    Width = 378
    Height = 153
    Alignment = taCenter
    Anchors = [akLeft, akTop, akRight, akBottom]
    AutoSize = False
    Caption = 'Info'
    Layout = tlCenter
    ExplicitWidth = 218
    ExplicitHeight = 47
  end
  object btnOK: TBitBtn
    Left = 159
    Top = 175
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    TabOrder = 0
    Kind = bkOK
  end
  object tmrHide: TTimer
    Interval = 1500
    OnTimer = tmrHideTimer
    Left = 8
    Top = 16
  end
  object tmrAlpha: TTimer
    Enabled = False
    Interval = 50
    OnTimer = tmrAlphaTimer
    Left = 8
    Top = 64
  end
end
