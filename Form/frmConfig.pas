unit frmConfig;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  Buttons,
  HotKeyManager,
  ExtCtrls,
  CheckLst,
  ComCtrls,
  Mask,
  Spin,
  rxToolEdit,
  RXSpin,
  untShortCutMan,
  untALTRunOption,
  untUtilities, jpeg, ActnList, Menus;

type
  TConfigForm = class(TForm)
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    pgcConfig: TPageControl;
    tsConfig: TTabSheet;
    tsHotKey: TTabSheet;
    tsFont: TTabSheet;
    chklstConfig: TCheckListBox;
    grpKeys1: TGroupBox;
    chkWindows1: TCheckBox;
    chkAlt1: TCheckBox;
    chkCtrl1: TCheckBox;
    chkShift1: TCheckBox;
    lblPlus: TLabel;
    lbledtHotKey1: TLabeledEdit;
    mmoDesc: TMemo;
    spl1: TSplitter;
    dlgFont: TFontDialog;
    lblTitleFont: TLabel;
    lblKeywordFont: TLabel;
    lblListFont: TLabel;
    btnModifyTitleFont: TButton;
    lblTitleSample: TLabel;
    btnModifyKeywordFont: TButton;
    lblKeywordSample: TLabel;
    lblListSample: TLabel;
    btnModifyListFont: TButton;
    btnReset: TBitBtn;
    btnResetFont: TButton;
    lblResetFont: TLabel;
    cbbListFormat: TComboBox;
    lblListFormat: TLabel;
    lblListFormatSample: TLabel;
    shp1: TShape;
    lblFormatSample: TLabel;
    tsForm: TTabSheet;
    lblFormAlphaColor: TLabel;
    lstAlphaColor: TColorBox;
    lblFormAlpha: TLabel;
    lblBackGroundImage: TLabel;
    edtClientDBFileBGFileName: TFilenameEdit;
    lblAlphaHint: TLabel;
    tsLang: TTabSheet;
    lblLanguage: TLabel;
    cbbLang: TComboBox;
    lblLanguageHint: TLabel;
    seAlpha: TRxSpinEdit;
    seRoundBorderRadius: TRxSpinEdit;
    lblRoundBorderRadius: TLabel;
    lbledtHotKey2: TLabeledEdit;
    grpKeys2: TGroupBox;
    chkWindows2: TCheckBox;
    chkAlt2: TCheckBox;
    chkCtrl2: TCheckBox;
    chkShift2: TCheckBox;
    lbl1: TLabel;
    lblHotkeyHint: TLabel;
    seFormWidth: TRxSpinEdit;
    lblFormWidth: TLabel;
    tsStyle: TTabSheet;
    dlgColor: TColorDialog;
    pnlDemo: TPanel;
    edtCopy: TEdit;
    edtCommandLine: TEdit;
    lstShortCut: TListBox;
    edtShortCut: TEdit;
    edtHint: TEdit;
    lblShortCut: TLabel;
    imgBackground: TImage;
    btnClose: TSpeedButton;
    btnShortCut: TSpeedButton;
    btnConfig: TSpeedButton;
    pmColor: TPopupMenu;
    pmFont: TPopupMenu;
    actlstGUI: TActionList;
    actSelectChange: TAction;
    procedure lbledtHotKey1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure chklstConfigClick(Sender: TObject);
    procedure fontcbbTitleChange(Sender: TObject);
    procedure btnModifyTitleFontClick(Sender: TObject);
    procedure btnModifyKeywordFontClick(Sender: TObject);
    procedure btnModifyListFontClick(Sender: TObject);
    procedure btnResetClick(Sender: TObject);
    procedure btnResetFontClick(Sender: TObject);
    procedure cbbListFormatChange(Sender: TObject);
    procedure seAlphaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure seRoundBorderRadiusKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lbledtHotKey2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure seFormWidthKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtShortCutChange(Sender: TObject);
    procedure actSelectChangeExecute(Sender: TObject);
  private
    { Private declarations }
    procedure RefreshDemo;
    procedure RefreshOperationHint;
    function DirAvailable: Boolean;
  public
    { Public declarations }

    function DisplayHotKey1(KeyName: string): Boolean;
    function DisplayHotKey2(KeyName: string): Boolean;
    function GetHotKey1: string;
    function GetHotKey2: string;
  end;

var
  ConfigForm: TConfigForm;

implementation

{$R *.dfm}

const
  WIN_KEY = 'Win';
  ALT_KEY = 'Alt';
  CTRL_KEY = 'Ctrl';
  SHIFT_KEY = 'Shift';

procedure TConfigForm.actSelectChangeExecute(Sender: TObject);
begin
  if lstShortCut.ItemIndex = -1 then Exit;

  lblShortCut.Caption := TShortCutItem(lstShortCut.Items.Objects[lstShortCut.ItemIndex]).Name;
  lblShortCut.Hint := TShortCutItem(lstShortCut.Items.Objects[lstShortCut.ItemIndex]).CommandLine;
  //edtCommandLine.Hint := lblShortCut.Hint;
  edtCommandLine.Text := resCMDLine + lblShortCut.Hint;

  if DirAvailable then lblShortCut.Caption := '[' + lblShortCut.Caption + ']';
end;

procedure TConfigForm.btnModifyKeywordFontClick(Sender: TObject);
begin
  dlgFont.Font := lblKeywordSample.Font;
  if dlgFont.Execute then
    lblKeywordSample.Font := dlgFont.Font;
end;

procedure TConfigForm.btnModifyListFontClick(Sender: TObject);
begin
  dlgFont.Font := lblListSample.Font;
  if dlgFont.Execute then
  begin
    lblListSample.Font := dlgFont.Font;
    lblListFormatSample.Font := dlgFont.Font;
  end;

end;

procedure TConfigForm.btnResetClick(Sender: TObject);
begin
  if Application.MessageBox(PChar(resResetAllConfig),
    PChar(resInfo), MB_OKCANCEL + MB_ICONQUESTION + MB_TOPMOST) = IDCANCEL then
    Exit;

  ModalResult := mrRetry;
end;

procedure TConfigForm.btnResetFontClick(Sender: TObject);
begin
  if Application.MessageBox(PChar(resResetAllFonts), PChar(resInfo),
    MB_OKCANCEL + MB_ICONQUESTION + MB_TOPMOST) = IDCANCEL then
    Exit;

  StrToFont(DEFAULT_TITLE_FONT_STR, lblTitleSample.Font);
  StrToFont(DEFAULT_KEYWORD_FONT_STR, lblKeywordSample.Font);
  StrToFont(DEFAULT_LIST_FONT_STR, lblListSample.Font);
end;

procedure TConfigForm.btnModifyTitleFontClick(Sender: TObject);
begin
  dlgFont.Font := lblTitleSample.Font;
  if dlgFont.Execute then
  begin
    lblTitleSample.Font := dlgFont.Font;
    lblTitleSample.Font.Pitch := fpFixed;
  end;
  //  if dlgFont.Execute then
  //  begin
  //    if (dlgFont.Font.Pitch in [fpFixed]) and
  //      (Application.MessageBox('FontPitch is not Fixed type, still choose it?',
  //      PChar(resInfo), MB_OKCANCEL + MB_ICONQUESTION + MB_TOPMOST) = IDCANCEL) then
  //      Exit
  //    else
  //      lblTitleFontSample.Font := dlgFont.Font;
  //  end;
end;

procedure TConfigForm.cbbListFormatChange(Sender: TObject);
begin
  try
    lblListFormatSample.Font := lblListSample.Font;
    lblListFormatSample.Caption := Format(cbbListFormat.Text, ['calc', '计算器']);
  except
    Exit;
  end;
end;

procedure TConfigForm.chklstConfigClick(Sender: TObject);
begin
  mmoDesc.Text := ConfigDescList[chklstConfig.ItemIndex];
end;

function TConfigForm.DirAvailable: Boolean;
var
  itm: TShortCutItem;
  Index: Integer;
  CommandLine: string;
begin
  Result := False;

  if lstShortCut.ItemIndex < 0 then Exit;

  itm := TShortCutItem(lstShortCut.Items.Objects[lstShortCut.ItemIndex]);
  Index := ShortCutMan.GetShortCutItemIndex(itm);

  //去除前导的@/@+/@-
  CommandLine := itm.CommandLine;
  if Pos(SHOW_MAX_FLAG, CommandLine) = 1 then
    CommandLine := CutLeftString(CommandLine, Length(SHOW_MAX_FLAG))
  else if Pos(SHOW_MIN_FLAG, CommandLine) = 1 then
    CommandLine := CutLeftString(CommandLine, Length(SHOW_MIN_FLAG))
  else if Pos(SHOW_HIDE_FLAG, CommandLine) = 1 then
    CommandLine := CutLeftString(CommandLine, Length(SHOW_HIDE_FLAG));

  CommandLine := RemoveQuotationMark(CommandLine, '"');

  if Pos('\\', CommandLine) > 0 then Exit;

  if (FileExists(CommandLine) or DirectoryExists(CommandLine)) then
    Result := True
  else
  begin
    if Pos('.\', CommandLine) = 1 then
      Result := True
    else
      Result := False;
  end;
end;

function TConfigForm.DisplayHotKey1(KeyName: string): Boolean;
var
  KeyList: TStringList;
  i: Cardinal;
begin
  Result := False;

  lbledtHotKey1.Text := '';
  chkWindows1.Checked := False;
  chkAlt1.Checked := False;
  chkCtrl1.Checked := False;
  chkShift1.Checked := False;

  if Trim(KeyName) = '' then
  begin
    lbledtHotKey1.Text := resVoidHotKey;
    Exit;
  end;

  try
    KeyList := TStringList.Create;

    KeyList.Delimiter := '+';
    KeyList.DelimitedText := KeyName;

    if KeyList.Count > 1 then
      for i := 0 to KeyList.Count - 2 do
      begin
        if LowerCase(Trim(KeyList.Strings[i])) = LowerCase(Trim(WIN_KEY)) then
          chkWindows1.Checked := True
        else if LowerCase(Trim(KeyList.Strings[i])) = LowerCase(Trim(ALT_KEY)) then
          chkAlt1.Checked := True
        else if LowerCase(Trim(KeyList.Strings[i])) = LowerCase(Trim(CTRL_KEY)) then
          chkCtrl1.Checked := True
        else if LowerCase(Trim(KeyList.Strings[i])) = LowerCase(Trim(SHIFT_KEY)) then
          chkShift1.Checked := True;
      end;

    lbledtHotKey1.Text := KeyList.Strings[KeyList.Count - 1];
  finally
    KeyList.Free;
  end;
end;

function TConfigForm.DisplayHotKey2(KeyName: string): Boolean;
var
  KeyList: TStringList;
  i: Cardinal;
begin
  Result := False;

  lbledtHotKey2.Text := '';
  chkWindows2.Checked := False;
  chkAlt2.Checked := False;
  chkCtrl2.Checked := False;
  chkShift2.Checked := False;

  if Trim(KeyName) = '' then
  begin
    lbledtHotKey2.Text := resVoidHotKey;
    Exit;
  end;

  try
    KeyList := TStringList.Create;

    SplitString(KeyName, '+', KeyList);

    // 下面的方法，对于"Scroll Lock" 将只显示"Lock"
    // 说明 TStringList 的 Delimiter 不靠谱

    //KeyList.Delimiter := '+';
    //KeyList.DelimitedText := KeyName;

    if KeyList.Count > 1 then
      for i := 0 to KeyList.Count - 2 do
      begin
        if LowerCase(Trim(KeyList.Strings[i])) = LowerCase(Trim(WIN_KEY)) then
          chkWindows2.Checked := True
        else if LowerCase(Trim(KeyList.Strings[i])) = LowerCase(Trim(ALT_KEY)) then
          chkAlt2.Checked := True
        else if LowerCase(Trim(KeyList.Strings[i])) = LowerCase(Trim(CTRL_KEY)) then
          chkCtrl2.Checked := True
        else if LowerCase(Trim(KeyList.Strings[i])) = LowerCase(Trim(SHIFT_KEY)) then
          chkShift2.Checked := True;
      end;

    lbledtHotKey2.Text := KeyList.Strings[KeyList.Count - 1];
  finally
    KeyList.Free;
  end;
end;

procedure TConfigForm.edtShortCutChange(Sender: TObject);
var
  i, j, k: Cardinal;
  Rank, ExistRank: Integer;
  IsInserted: Boolean;
  StringList: TStringList;
  HintIndex: Integer;
begin
  lblShortCut.Caption := '';
  lblShortCut.Hint := '';
  lstShortCut.Hint := '';
  edtCommandLine.Text := '';

  lstShortCut.Clear;

  //更新列表
  try
    StringList := TStringList.Create;

    //lstShortCut.Hide;

    if ShortCutMan.FilterKeyWord(edtShortCut.Text, StringList) then
    begin
      if ShowTopTen then
      begin
        for i := 0 to 9 do
          if i >= StringList.Count then
            Break
          else
            lstShortCut.Items.AddObject(StringList[i], StringList.Objects[i])
      end
      else
        lstShortCut.Items.Assign(StringList);
    end;

  finally
    StringList.Free;
  end;

  //显示第一项
  if lstShortCut.Count = 0 then
  begin
    lblShortCut.Caption := '';
    lblShortCut.Hint := '';
    lstShortCut.Hint := '';
    edtCommandLine.Text := '';
  end
  else
  begin
    lstShortCut.ItemIndex := 0;
    lblShortCut.Caption := TShortCutItem(lstShortCut.Items.Objects[0]).Name;
    lblShortCut.Hint := TShortCutItem(lstShortCut.Items.Objects[0]).CommandLine;
    edtCommandLine.Text := resCMDLine + lblShortCut.Hint;
  end;

  RefreshOperationHint;
end;

procedure TConfigForm.fontcbbTitleChange(Sender: TObject);
begin
  if dlgFont.Execute then
  begin
    ShowMessage(dlgFont.Font.Name);
  end;
end;

procedure TConfigForm.FormCreate(Sender: TObject);
var
  i: Cardinal;
begin
  Self.DoubleBuffered := True;
  Self.Caption := resConfigFormCaption;

  tsStyle.TabVisible := False;
  
  btnOK.Caption := resBtnOK;
  btnCancel.Caption := resBtnCancel;
  btnReset.Caption := resBtnReset;

  tsConfig.Caption := resPageConfig;
  tsHotKey.Caption := resPageHotKey;
  tsFont.Caption := resPageFont;
  tsForm.Caption := resPageForm;
  tsLang.Caption := resPageLang;

  chklstConfig.Clear;
  chklstConfig.Items.Add(resConfigList_0);
  chklstConfig.Items.Add(resConfigList_1);
  chklstConfig.Items.Add(resConfigList_2);
  chklstConfig.Items.Add(resConfigList_3);
  chklstConfig.Items.Add(resConfigList_4);
  chklstConfig.Items.Add(resConfigList_5);
  chklstConfig.Items.Add(resConfigList_6);
  chklstConfig.Items.Add(resConfigList_7);
  chklstConfig.Items.Add(resConfigList_8);
  chklstConfig.Items.Add(resConfigList_9);
  chklstConfig.Items.Add(resConfigList_10);
  chklstConfig.Items.Add(resConfigList_11);
  chklstConfig.Items.Add(resConfigList_12);
  chklstConfig.Items.Add(resConfigList_13);
  chklstConfig.Items.Add(resConfigList_14);
  chklstConfig.Items.Add(resConfigList_15);
  chklstConfig.Items.Add(resConfigList_16);
  chklstConfig.Items.Add(resConfigList_17);
  chklstConfig.Items.Add(resConfigList_18);
  chklstConfig.Items.Add(resConfigList_19);

  lblHotkeyHint.Caption := resLblHotKeyHint;
  lbledtHotKey1.EditLabel.Caption := resLblHotKey1;
  lbledtHotKey2.EditLabel.Caption := resLblHotKey2;
  lbledtHotKey1.Hint:=resLblHotKeyHint1;
  lbledtHotKey2.Hint:=resLblHotKeyHint2;
  LblTitleFont.Caption := resLblTitleFont;
  LblTitleSample.Caption := resLblTitleSample;
  LblKeywordFont.Caption := resLblKeywordFont;
  LblKeywordSample.Caption := resLblKeywordSample;
  LblListFont.Caption := resLblListFont;
  LblListSample.Caption := resLblListSample;
  LblListFormat.Caption := resLblListFormat;
  lblResetFont.Caption := resLblResetFont;
  lblFormatSample.Caption := resLblFormatSample;
  LblListFormatSample.Caption := resLblListFormatSample;
  LblFormAlphaColor.Caption := resLblFormAlphaColor;
  LblFormAlpha.Caption := resLblFormAlpha;
  lblRoundBorderRadius.Caption := resLblRoundBorderRadius;
  lblFormWidth.Caption := resLblFormWidth;
  LblBackGroundImage.Caption := resLblBackGroundImage;
  LblAlphaHint.Caption := resLblAlphaHint;
  LblLanguage.Caption := resLblLanguage;
  LblLanguageHint.Caption := resLblLanguageHint;

  BtnModifyTitleFont.Caption := resBtnModifyTitleFont;
  btnModifyKeywordFont.Caption := resBtnModifyKeywordFont;
  BtnModifyListFont.Caption := resBtnModifyListFont;
  BtnResetFont.Caption := resBtnResetAllFonts;

  //RefreshDemo;
end;

function TConfigForm.GetHotKey1: string;
begin
  Result := '';

  if chkWindows1.Checked then Result := Result + WIN_KEY + ' + ';
  if chkAlt1.Checked then Result := Result + ALT_KEY + ' + ';
  if chkCtrl1.Checked then Result := Result + CTRL_KEY + ' + ';
  if chkShift1.Checked then Result := Result + SHIFT_KEY + ' + ';

  Result := Result + lbledtHotKey1.Text;
end;

function TConfigForm.GetHotKey2: string;
begin
  Result := '';

  if chkWindows2.Checked then Result := Result + WIN_KEY + ' + ';
  if chkAlt2.Checked then Result := Result + ALT_KEY + ' + ';
  if chkCtrl2.Checked then Result := Result + CTRL_KEY + ' + ';
  if chkShift2.Checked then Result := Result + SHIFT_KEY + ' + ';

  Result := Result + lbledtHotKey2.Text;
end;

procedure TConfigForm.lbledtHotKey1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  lbledtHotKey1.Text := HotKeyManager.HotKeyToText(Key, LOCALIZED_KEYNAMES);
end;

procedure TConfigForm.lbledtHotKey2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_DELETE then
  begin
    chkWindows2.Checked := False;
    chkAlt2.Checked := False;
    chkShift2.Checked := False;
    chkCtrl2.Checked := False;
    
    lbledtHotKey2.Text := HotKeyManager.HotKeyToText(0, LOCALIZED_KEYNAMES);
  end
  else
    lbledtHotKey2.Text := HotKeyManager.HotKeyToText(Key, LOCALIZED_KEYNAMES);
end;

procedure TConfigForm.RefreshDemo;
begin
  //字体
  StrToFont(TitleFontStr, lblShortCut.Font);
  StrToFont(KeywordFontStr, edtShortCut.Font);
  StrToFont(ListFontStr, lstShortCut.Font);

  //修改背景图
  if not FileExists(ExtractFilePath(Application.ExeName) + BGFileName) then
    imgBackground.Picture.SaveToFile(ExtractFilePath(Application.ExeName) + BGFileName);

  if ShowSkin then
  begin
    imgBackground.Picture.LoadFromFile(ExtractFilePath(Application.ExeName) + BGFileName);
    imgBackground.Show;
  end
  else
  begin
    imgBackground.Picture := nil;
    imgBackground.Hide;
  end;


  //按钮是否显示
  btnShortCut.Visible := ShowShortCutButton;
  btnConfig.Visible := ShowConfigButton;
  btnClose.Visible := ShowCloseButton;

  //根据按钮显示决定标题栏显示长度
  //快捷项管理按钮
  if ShowShortCutButton then
    lblShortCut.Left := btnShortCut.Left + btnShortCut.Width
  else
    lblShortCut.Left := 0;

  //配置按钮和关闭按钮
  if ShowCloseButton then
  begin
    if ShowConfigButton then
    begin
      btnConfig.Left := btnClose.Left - btnConfig.Width - 10;
      lblShortCut.Width := btnConfig.Left - lblShortCut.Left;
    end
    else
    begin
      lblShortCut.Width := btnClose.Left - lblShortCut.Left;
    end;
  end
  else
  begin
    if ShowConfigButton then
    begin
      btnConfig.Left := pnlDemo.Width - btnConfig.Width - 10;
      lblShortCut.Width := btnConfig.Left - lblShortCut.Left;
    end
    else
    begin
      lblShortCut.Width := pnlDemo.Width - lblShortCut.Left;
    end
  end;

  //显示命令行
  if ShowCommandLine then
    pnlDemo.Height := 250 {Self.Height + 20}
  else
    pnlDemo.Height := 230 {Self.Height - 20};
//
  edtShortCut.Text := '';
  edtShortCutChange(nil);
end;

procedure TConfigForm.RefreshOperationHint;
var
  HintIndex: Integer;
begin
  //刷新提示
  if not ShowOperationHint then
    edtHint.Hide
  else
  begin
    edtHint.Show;
    if Length(edtShortCut.Text) = 0 then
    begin
      //随机挑选一个提示显示出来
      Randomize;

      repeat
        HintIndex := Random(Length(HintList));
      until Trim(HintList[HintIndex]) <> '';

      edtHint.Text := HintList[HintIndex];
    end
    else if Length(edtShortCut.Text) < 6 then
    begin
      if lstShortCut.Count = 0 then
      begin
        edtHint.Text := resKeyToAdd;
      end
      else if DirAvailable then
        edtHint.Text := resKeyToOpenFolder
      else
        edtHint.Text := resKeyToRun;
    end
    else
      edtHint.Hide;
  end;
end;

procedure TConfigForm.seAlphaKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    13: ModalResult := mrOk;                           //回车
    VK_ESCAPE: ModalResult := mrCancel;                //ESC
  end;
end;

procedure TConfigForm.seFormWidthKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    13: ModalResult := mrOk;                           //回车
    VK_ESCAPE: ModalResult := mrCancel;                //ESC
  end;
end;

procedure TConfigForm.seRoundBorderRadiusKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    13: ModalResult := mrOk;                           //回车
    VK_ESCAPE: ModalResult := mrCancel;                //ESC
  end;
end;

end.

