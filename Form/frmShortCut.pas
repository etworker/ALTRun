unit frmShortCut;

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
  Buttons,
  StdCtrls,
  ExtCtrls,
  ShellAPI,
  FileCtrl,
  frmHelp,
  untALTRunOption,
  untUtilities;

type
  TShortCutForm = class(TForm)
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    dlgOpenFile: TOpenDialog;
    grpShortCut: TGroupBox;
    btnFile: TButton;
    lbledtCommandLine: TLabeledEdit;
    lbledtName: TLabeledEdit;
    lbledtShortCut: TLabeledEdit;
    rgParam: TRadioGroup;
    btnDir: TButton;
    btnHelp: TBitBtn;
    btnTest: TBitBtn;
    procedure btnFileClick(Sender: TObject);
    procedure MyDrag(var Msg: TWMDropFiles); message WM_DropFiles;
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnDirClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure btnTestClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure Createparams(var params: TCreateParams); override;
  public
    { Public declarations }
  end;

var
  ShortCutForm: TShortCutForm;

implementation
uses
  untShortCutMan;

{$R *.dfm}

procedure TShortCutForm.btnDirClick(Sender: TObject);
var
  strDir, strShortDir: string;
  SlashPos: Integer;
  i: Cardinal;
begin
  //为了防止点击文件/文件夹对话框出来后，被挡在后面
  Self.FormStyle := fsNormal;

  SelectDirectory(PChar(resSelectDir), '', strDir,
    [sdNewFolder, sdShowShares, sdNewUI, sdValidateDir]);

  if strDir <> '' then
  begin
    lbledtCommandLine.text := strDir;

    SlashPos := 0;
    for i := Length(strDir) downto 1 do
      if strDir[i] = '\' then
      begin
        SlashPos := i;
        Break;
      end;

    if SlashPos = 0 then Exit;

    strShortDir := Copy(strDir, SlashPos + 1, Length(strDir) - SlashPos);

    if lbledtShortCut.Text = '' then
      lbledtShortCut.Text := strShortDir
    else
      if lbledtShortCut.Text <> strShortDir then
        if Application.MessageBox(PChar(Format(resReplaceConfirm, [lbledtShortCut.Text, strShortDir])),
          PChar(resReplaceShortCutConfirm), MB_YESNO + MB_ICONQUESTION + MB_TOPMOST) = IDYES then
          lbledtShortCut.Text := strShortDir;

    if lbledtName.Text = '' then
      lbledtName.Text := strShortDir
    else
      if lbledtName.Text <> strShortDir then
        if Application.MessageBox(PChar(Format(resReplaceConfirm, [lbledtName.Text, strShortDir])),
          PChar(resReplaceNameConfirm), MB_YESNO + MB_ICONQUESTION + MB_TOPMOST) = IDYES then
          lbledtName.Text := strShortDir;
  end;

  Self.FormStyle := fsStayOnTop;
end;

procedure TShortCutForm.btnFileClick(Sender: TObject);
var
  strFileName, strShortFileName: string;
begin
  //为了防止点击文件/文件夹对话框出来后，被挡在后面
  Self.FormStyle := fsNormal;

  if dlgOpenFile.Execute then
  begin
    strFileName := ExtractFileName(dlgOpenFile.FileName);
    lbledtCommandLine.Text := dlgOpenFile.FileName;

    strShortFileName := Copy(strFileName, 1, Length(strFileName) - Length(ExtractFileExt(strFileName)));

    if lbledtShortCut.Text = '' then
      lbledtShortCut.Text := strShortFileName
    else
      if lbledtShortCut.Text <> strShortFileName then
        if Application.MessageBox(PChar(Format(resReplaceConfirm, [lbledtShortCut.Text, strShortFileName])),
          PChar(resReplaceShortCutConfirm), MB_YESNO + MB_ICONQUESTION + MB_TOPMOST) = IDYES then
          lbledtShortCut.Text := strShortFileName;

    if lbledtName.Text = '' then
      lbledtName.Text := strShortFileName
    else
      if lbledtName.Text <> strShortFileName then
        if Application.MessageBox(PChar(Format(resReplaceConfirm, [lbledtName.Text, strShortFileName])),
          PChar(resReplaceNameConfirm), MB_YESNO + MB_ICONQUESTION + MB_TOPMOST) = IDYES then
          lbledtName.Text := strShortFileName;
  end;

  Self.FormStyle := fsStayOnTop;
end;

procedure TShortCutForm.btnHelpClick(Sender: TObject);
var
  HelpForm: THelpForm;
begin
  try
    HelpForm := THelpForm.Create(Self);
    HelpForm.ShowModal;
  finally
    HelpForm.Free;
  end;
end;

procedure TShortCutForm.btnOKClick(Sender: TObject);
begin
  //判断Name是否含逗号
  if Pos(',', lbledtName.Text) > 0 then
  begin
    Application.MessageBox(PChar(resNameCanNotInclude), PChar(resInfo),
      MB_OK + MB_ICONINFORMATION + MB_TOPMOST);

    lbledtName.SetFocus;
    Exit;
  end;

  //如果选中无参数，而命令行中有参数匹配符，提示
  if rgParam.ItemIndex = 0 then
  begin
    if (Pos(NEW_PARAM_FLAG, lbledtCommandLine.Text) > 0)
      or (Pos(PARAM_FLAG, lbledtCommandLine.Text) > 0)
      or (Pos(CLIPBOARD_FLAG, lbledtCommandLine.Text) > 0)
      or (Pos(FOREGROUND_WINDOW_ID_FLAG, lbledtCommandLine.Text) > 0)
      or (Pos(FOREGROUND_WINDOW_CLASS_FLAG, lbledtCommandLine.Text) > 0)
      or (Pos(FOREGROUND_WINDOW_TEXT_FLAG, lbledtCommandLine.Text) > 0) then
    begin
      if Application.MessageBox(PChar(resParamConfirm),
        PChar(resInfo), MB_YESNO + MB_ICONQUESTION + MB_TOPMOST) = IDYES then
      begin
        rgParam.SetFocus;
        Exit;
      end;
    end;
  end;

  ModalResult := mrOk;
end;

procedure TShortCutForm.btnTestClick(Sender: TObject);
var
  ShortCutItem: TShortCutItem;
begin
  //命令行不能为空
  if lbledtCommandLine.Text = '' then
  begin
    Application.MessageBox(PChar(resCommandLineEempty), PChar(resInfo),
      MB_OK + MB_ICONINFORMATION + MB_TOPMOST);
    Exit;
  end;

  //组一个
  ShortCutItem := TShortCutItem.Create;
  try
    with ShortCutItem do
    begin
      ShortCutType := scItem;
      ShortCut := lbledtShortCut.Text;
      Name := lbledtName.Text;
      CommandLine := lbledtCommandLine.Text;
      ParamType := TParamType(rgParam.ItemIndex);
    end;

    //执行
    ShortCutMan.Execute(ShortCutItem);
  finally
    ShortCutItem.Free;
  end;
end;

procedure TShortCutForm.Createparams(var params: TCreateParams);
begin
  inherited;

  with params do
  begin
    params.Style := params.Style or WS_POPUP { or WS_BORDER};
    params.ExStyle := params.ExStyle or WS_EX_TOPMOST {or WS_EX_NOACTIVATE or WS_EX_WINDOWEDGE};
    params.WndParent := GetDesktopWindow;
  end;
end;

procedure TShortCutForm.FormCreate(Sender: TObject);
begin
  Self.Caption := resShortCutFormCaption;
  grpShortCut.Caption := resGrpShortCut;
  lbledtShortCut.EditLabel.Caption := resShortCut;
  lbledtName.EditLabel.Caption := resName;
  lbledtCommandLine.EditLabel.Caption := resCommandLine;
  lbledtCommandLine.Hint := resLblEdtCommandLineHint;
  btnFile.Caption := resBtnFile;
  btnDir.Caption := resBtnDir;
  rgParam.Caption := resGrpParamType;
  rgParam.Items.Clear;
  rgParam.Items.Add(resParamType_0);
  rgParam.Items.Add(resParamType_1);
  rgParam.Items.Add(resParamType_2);
  rgParam.Items.Add(resParamType_3);
  rgParam.ItemIndex := 0;

  btnTest.Caption := resBtnTest;
  btnOK.Caption := resBtnOK;
  btnCancel.Caption := resBtnCancel;
  btnHelp.Caption := resBtnHelp;

  DragAcceptFiles(Handle, True);
end;

procedure TShortCutForm.FormShow(Sender: TObject);
begin
  SetForegroundWindow(Application.Handle);
  lbledtShortCut.SetFocus;
end;

procedure TShortCutForm.MyDrag(var Msg: TWMDropFiles);
var
  hDrop: Cardinal;
  FileName: string;
  Item: TShortCutItem;
begin
  hDrop := Msg.Drop;

  FileName := GetDragFileName(hDrop);

  try
    Item := TShortCutItem.Create;

    if not ShortCutMan.ExtractShortCutItemFromFileName(Item, FileName) then
    begin
      Application.MessageBox(PChar(resGetFileNameFail), PChar(resInfo),
        MB_OK + MB_ICONINFORMATION + MB_TOPMOST);

      Exit;
    end;

    lbledtShortCut.Text := Item.ShortCut;
    lbledtName.Text := Item.Name;
    lbledtCommandLine.Text := Trim(Item.CommandLine);
    rgParam.ItemIndex := 0;
  finally
    Item.Free;
  end;
//
//  lbledtName.Text := ExtractFileName(FileName);
//  lbledtCommandLine.Text := FileName;
//
//  FileName := ExtractFileName(FileName);
//  lbledtShortCut.Text := Copy(FileName, 1, Length(FileName) - Length(ExtractFileExt(FileName)));

  DragFinish(hDrop);
  Msg.Result := 0;
end;

end.

