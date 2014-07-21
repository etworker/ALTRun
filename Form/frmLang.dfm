object LangForm: TLangForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Please choose language'
  ClientHeight = 38
  ClientWidth = 294
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = #23435#20307
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    294
    38)
  PixelsPerInch = 96
  TextHeight = 13
  object btnOK: TBitBtn
    Left = 211
    Top = 8
    Width = 75
    Height = 25
    Anchors = [akTop, akRight, akBottom]
    TabOrder = 0
    Kind = bkOK
  end
  object cbbLang: TComboBox
    Left = 8
    Top = 9
    Width = 197
    Height = 21
    Style = csDropDownList
    Ctl3D = False
    ItemHeight = 13
    ParentCtl3D = False
    TabOrder = 1
  end
end
