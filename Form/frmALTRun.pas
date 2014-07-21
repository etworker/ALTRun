unit frmALTRun;

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
  AppEvnts,
  CoolTrayIcon,
  ActnList,
  Menus,
  HotKeyManager,
  ExtCtrls,
  Buttons,
  ImgList,
  ShellAPI,
  MMSystem,
  frmParam,
  frmAutoHide,
  untShortCutMan,
  untClipboard,
  untALTRunOption,
  untUtilities, jpeg;

type
  TALTRunForm = class(TForm)
    lblShortCut: TLabel;
    edtShortCut: TEdit;
    lstShortCut: TListBox;
    evtMain: TApplicationEvents;
    ntfMain: TCoolTrayIcon;
    pmMain: TPopupMenu;
    actlstMain: TActionList;
    actShow: TAction;
    actShortCut: TAction;
    actConfig: TAction;
    actClose: TAction;
    hkmHotkey1: THotKeyManager;
    actAbout: TAction;
    Show1: TMenuItem;
    ShortCut1: TMenuItem;
    Config1: TMenuItem;
    About1: TMenuItem;
    Close1: TMenuItem;
    actExecute: TAction;
    actSelectChange: TAction;
    imgBackground: TImage;
    actHide: TAction;
    pmList: TPopupMenu;
    actAddItem: TAction;
    actEditItem: TAction;
    actDeleteItem: TAction;
    mniAddItem: TMenuItem;
    mniEditItem: TMenuItem;
    mniDeleteItem: TMenuItem;
    tmrHide: TTimer;
    ilHotRun: TImageList;
    btnShortCut: TSpeedButton;
    btnClose: TSpeedButton;
    edtHint: TEdit;
    edtCommandLine: TEdit;
    mniN1: TMenuItem;
    actOpenDir: TAction;
    mniOpenDir: TMenuItem;
    tmrExit: TTimer;
    edtCopy: TEdit;
    tmrCopy: TTimer;
    btnConfig: TSpeedButton;
    tmrFocus: TTimer;
    actUp: TAction;
    actDown: TAction;
    hkmHotkey2: THotKeyManager;
    pmCommandLine: TPopupMenu;
    actCopyCommandLine: TAction;
    hkmHotkey3: THotKeyManager;

    procedure WndProc(var Msg: TMessage); override;
    procedure edtShortCutChange(Sender: TObject);
    procedure edtShortCutKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure evtMainIdle(Sender: TObject; var Done: Boolean);
    procedure evtMainMinimize(Sender: TObject);
    procedure actShowExecute(Sender: TObject);
    procedure actConfigExecute(Sender: TObject);
    procedure actCloseExecute(Sender: TObject);
    procedure actAboutExecute(Sender: TObject);
    procedure hkmHotkeyHotKeyPressed(HotKey: Cardinal; Index: Word);
    procedure FormDestroy(Sender: TObject);
    procedure actExecuteExecute(Sender: TObject);
    procedure edtShortCutKeyPress(Sender: TObject; var Key: Char);
    procedure actSelectChangeExecute(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure lstShortCutKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure actHideExecute(Sender: TObject);
    procedure actShortCutExecute(Sender: TObject);
    procedure btnShortCutClick(Sender: TObject);
    procedure actAddItemExecute(Sender: TObject);
    procedure actEditItemExecute(Sender: TObject);
    procedure actDeleteItemExecute(Sender: TObject);
    procedure lblShortCutMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgBackgroundMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure tmrHideTimer(Sender: TObject);
    procedure evtMainDeactivate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ntfMainDblClick(Sender: TObject);
    procedure lstShortCutMouseActivate(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y, HitTest: Integer;
      var MouseActivate: TMouseActivate);
    procedure edtShortCutMouseActivate(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y, HitTest: Integer;
      var MouseActivate: TMouseActivate);
    procedure lblShortCutMouseActivate(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y, HitTest: Integer;
      var MouseActivate: TMouseActivate);
    procedure edtCommandLineKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure actOpenDirExecute(Sender: TObject);
    procedure lstShortCutMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pmListPopup(Sender: TObject);
    procedure tmrExitTimer(Sender: TObject);
    procedure tmrCopyTimer(Sender: TObject);
    procedure tmrFocusTimer(Sender: TObject);
    procedure evtMainActivate(Sender: TObject);
    procedure evtMainMessage(var Msg: tagMSG; var Handled: Boolean);
    procedure evtMainShortCut(var Msg: TWMKey; var Handled: Boolean);
    procedure actUpExecute(Sender: TObject);
    procedure actDownExecute(Sender: TObject);
    procedure MiddleMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure actCopyCommandLineExecute(Sender: TObject);
    procedure hkmHotkey3HotKeyPressed(HotKey: Cardinal; Index: Word);
  private
    m_IsShow: Boolean;
    m_IsFirstShow: Boolean;
    m_IsFirstDblClickIcon: Boolean;
    m_LastShortCutPointerList: array[0..9] of Pointer;
    m_LastShortCutCmdIndex: Integer;
    m_LastShortCutListCount: Integer;
    m_LastKeyIsNumKey: Boolean;
    m_LastActiveTime: Cardinal;
    m_IsExited: Boolean;
    m_AgeOfFile: Integer;
    m_NeedRefresh: Boolean;
    m_IsTop: Boolean;
    m_LastShortCutText: string;
    
    function ApplyHotKey1: Boolean;
    function ApplyHotKey2: Boolean;
    function GetHotKeyString: string;
    procedure GetLastCmdList;
    procedure RestartHideTimer(Delay: Integer);
    procedure StopTimer;
    function DirAvailable: Boolean;
    procedure RefreshOperationHint;
    function GetLangList(List: TStringList): Boolean;
    procedure RestartMe;
    procedure DisplayShortCutItem(Item: TShortCutItem);
    procedure ShowLatestShortCutList;
  public
    property IsExited: Boolean read m_IsExited;
  end;

var
  ALTRunForm: TALTRunForm;

const
  WM_ALTRUN_ADD_SHORTCUT = WM_USER + 2000;
  WM_ALTRUN_SHOW_WINDOW = WM_USER + 2001;

implementation
{$R *.dfm}

uses
  untLogger,
  frmConfig,
  frmAbout,
  frmShortCut,
  frmShortCutMan,
  frmLang;

procedure TALTRunForm.actAboutExecute(Sender: TObject);
var
  AboutForm: TAboutForm;
  hALTRun:HWND;
begin
  TraceMsg('actAboutExecute()');

  if DEBUG_MODE then
  begin
    hALTRun := Self.Handle;
    hALTRun := FindWindow(nil, TITLE);
    hALTRun := FindWindow('TALTRunForm', nil);
//    hALTRun := FindWindowByCaption(TITLE);
    SendMessage(hALTRun, WM_ALTRUN_ADD_SHORTCUT, 0, 0);
    //SendMessage(Self.Handle, WM_ALTRUN_ADD_SHORTCUT, 0, 0);
    Exit;
  end;

  try
    AboutForm := TAboutForm.Create(Self);
    AboutForm.Caption := Format('%s %s %s', [resAbout, TITLE, ALTRUN_VERSION]);
    AboutForm.ShowModal;
  finally
    AboutForm.Free;
  end;
end;

procedure TALTRunForm.actAddItemExecute(Sender: TObject);
begin
  TraceMsg('actAddItemExecute()');

  m_IsTop := False;
  ShortCutMan.AddFileShortCut(edtShortCut.Text);
  m_IsTop := True;
  if m_IsShow then edtShortCutChange(Self);
end;

procedure TALTRunForm.actCloseExecute(Sender: TObject);
begin
  TraceMsg('actCloseExecute()');

  //保存窗体位置
  if m_IsShow then
  begin
    WinTop := Self.Top;
    WinLeft := Self.Left;
  end;

  //保存最近使用快捷方式的列表
  LatestList := ShortCutMan.GetLatestShortCutIndexList;

  HandleID := 0;
  SaveSettings;

  //若保留此行，在右键添加后，直接退出本程序，此新添快捷项将丢失
  ShortCutMan.SaveShortCutList;

  Application.Terminate;
end;

procedure TALTRunForm.actConfigExecute(Sender: TObject);
var
  ConfigForm: TConfigForm;
  lg: longint;
  i: Cardinal;
  LangList: TStringList;
  IsNeedRestart: Boolean;
begin
  TraceMsg('actConfigExecute()');

  try
    //取消HotKey以免冲突
    hkmHotkey1.ClearHotKeys;
    hkmHotkey2.ClearHotKeys;

    ConfigForm := TConfigForm.Create(Self);

    IsNeedRestart := False;

    //调用当前配置
    with ConfigForm do
    begin
      DisplayHotKey1(HotKeyStr1);
      DisplayHotKey2(HotKeyStr2);

      //AutoRun
      chklstConfig.Checked[0] := AutoRun;
      //AddToSendTo
      chklstConfig.Checked[1] := AddToSendTo;
      //EnableRegex
      chklstConfig.Checked[2] := EnableRegex;
      //MatchAnywhere
      chklstConfig.Checked[3] := MatchAnywhere;
      //EnableNumberKey
      chklstConfig.Checked[4] := EnableNumberKey;
      //IndexFrom0to9
      chklstConfig.Checked[5] := IndexFrom0to9;
      //RememberFavouratMatch
      chklstConfig.Checked[6] := RememberFavouratMatch;
      //ShowOperationHint
      chklstConfig.Checked[7] := ShowOperationHint;
      //ShowCommandLine
      chklstConfig.Checked[8] := ShowCommandLine;
      //ShowStartNotification
      chklstConfig.Checked[9] := ShowStartNotification;
      //ShowTopTen
      chklstConfig.Checked[10] := ShowTopTen;
      //PlayPopupNotify
      chklstConfig.Checked[11] := PlayPopupNotify;
      //ExitWhenExecute
      chklstConfig.Checked[12] := ExitWhenExecute;
      //ShowSkin
      chklstConfig.Checked[13] := ShowSkin;
      //ShowMeWhenStart
      chklstConfig.Checked[14] := ShowMeWhenStart;
      //ShowTrayIcon
      chklstConfig.Checked[15] := ShowTrayIcon;
      //ShowShortCutButton
      chklstConfig.Checked[16] := ShowShortCutButton;
      //ShowConfigButton
      chklstConfig.Checked[17] := ShowConfigButton;
      //ShowCloseButton
      chklstConfig.Checked[18] := ShowCloseButton;
      //ExecuteIfOnlyOne
      chklstConfig.Checked[19] := ExecuteIfOnlyOne;
      //edtBGFileName.Text := BGFileName;

      StrToFont(TitleFontStr, lblTitleSample.Font);
      StrToFont(KeywordFontStr, lblKeywordSample.Font);
      StrToFont(ListFontStr, lblListSample.Font);

      for i := Low(ListFormatList) to High(ListFormatList) do
        cbbListFormat.Items.Add(ListFormatList[i]);

      if cbbListFormat.Items.IndexOf(ListFormat) < 0 then
        cbbListFormat.Items.Add(ListFormat);

      cbbListFormat.ItemIndex := cbbListFormat.Items.IndexOf(ListFormat);
      cbbListFormatChange(Sender);

      lstAlphaColor.Selected := AlphaColor;
      seAlpha.Value := Alpha;
      seRoundBorderRadius.Value := RoundBorderRadius;
      seFormWidth.Value := FormWidth;

      //语言
      try
        cbbLang.Items.Add(DEFAULT_LANG);
        cbbLang.ItemIndex := 0;

        LangList := TStringList.Create;
        if not GetLangList(LangList) then Exit;

        if LangList.Count > 0 then
        begin
          for i := 0 to LangList.Count - 1 do
            if cbbLang.Items.IndexOf(LangList.Strings[i]) < 0 then
              cbbLang.Items.Add(LangList.Strings[i]);

          for i := 0 to cbbLang.Items.Count - 1 do
            if cbbLang.Items[i] = Lang then
            begin
              cbbLang.ItemIndex := i;
              Break;
            end;
        end;
      finally
        LangList.Free;
      end;

      m_IsTop := False;
      ShowModal;
      m_IsTop := True;

      //如果确认
      case ModalResult of
        mrOk:
          begin
            HotKeyStr1 := GetHotKey1;
            HotKeyStr2 := GetHotKey2;

            AutoRun := chklstConfig.Checked[0];
            AddToSendTo := chklstConfig.Checked[1];
            EnableRegex := chklstConfig.Checked[2];
            MatchAnywhere := chklstConfig.Checked[3];
            EnableNumberKey := chklstConfig.Checked[4];
            IndexFrom0to9 := chklstConfig.Checked[5];
            RememberFavouratMatch := chklstConfig.Checked[6];
            ShowOperationHint := chklstConfig.Checked[7];
            ShowCommandLine := chklstConfig.Checked[8];
            ShowStartNotification := chklstConfig.Checked[9];
            ShowTopTen := chklstConfig.Checked[10];
            PlayPopupNotify := chklstConfig.Checked[11];
            ExitWhenExecute := chklstConfig.Checked[12];
            ShowSkin := chklstConfig.Checked[13];
            ShowMeWhenStart := chklstConfig.Checked[14];
            ShowTrayIcon := chklstConfig.Checked[15];
            ShowShortCutButton := chklstConfig.Checked[16];
            ShowConfigButton := chklstConfig.Checked[17];
            ShowCloseButton := chklstConfig.Checked[18];
            ExecuteIfOnlyOne := chklstConfig.Checked[19];

            TitleFontStr := FontToStr(lblTitleSample.Font);
            KeywordFontStr := FontToStr(lblKeywordSample.Font);
            ListFontStr := FontToStr(lblListSample.Font);

            ListFormat := cbbListFormat.Text;

            if not IsNeedRestart then IsNeedRestart := (AlphaColor <> lstAlphaColor.Selected);
            AlphaColor := lstAlphaColor.Selected;

            if not IsNeedRestart then IsNeedRestart := (Alpha <> seAlpha.Value);
            Alpha := Round(seAlpha.Value);

            if not IsNeedRestart then IsNeedRestart := (RoundBorderRadius <> seRoundBorderRadius.Value);
            RoundBorderRadius := Round(seRoundBorderRadius.Value);

            if not IsNeedRestart then IsNeedRestart := (FormWidth <> seFormWidth.Value);
            FormWidth := Round(seFormWidth.Value);

            if not IsNeedRestart then IsNeedRestart := (Lang <> cbbLang.Text);
            Lang := cbbLang.Text;

            //不让修改背景图片的文件名
            //BGFileName := edtBGFileName.Text;
            //if BGFileName <> '' then
            //begin
            //  if FileExists(BGFileName) then
            //    Self.imgBackground.Picture.LoadFromFile(BGFileName)
            //  else if FileExists(ExtractFilePath(Application.ExeName) + BGFileName) then
            //    Self.imgBackground.Picture.LoadFromFile(ExtractFilePath(Application.ExeName) + BGFileName)
            //  else
            //    Application.MessageBox(PChar(Format('File %s does not exist!',
            //      [BGFileName])), resInfo, MB_OK + MB_ICONINFORMATION + MB_TOPMOST);
            //end;

            //保存新的项目
            ShortCutMan.SaveShortCutList;
            ShortCutMan.LoadShortCutList;

            ShortCutMan.NeedRefresh := True;
          end;

        mrRetry:
          begin
            DeleteFile(ExtractFilePath(Application.ExeName) + TITLE + '.ini');
            LoadSettings;
            IsNeedRestart := True;
          end;

      else
        ApplyHotKey1;
        ApplyHotKey2;

        Exit;
      end;

      //应用修改的配置
      if (ModalResult = mrOk) or (ModalResult = mrRetry) then
      begin
        //SetAutoRun(TITLE, Application.ExeName, AutoRun);
        SetAutoRunInStartUp(TITLE, Application.ExeName, AutoRun);
        AddMeToSendTo(TITLE, AddToSendTo);

        StrToFont(TitleFontStr, Self.lblShortCut.Font);
        StrToFont(KeywordFontStr, Self.edtShortCut.Font);
        StrToFont(ListFontStr, Self.lstShortCut.Font);

        //应用快捷键
        ApplyHotKey1;
        ApplyHotKey2;
        ntfMain.Hint := Format(resMainHint, [TITLE, ALTRUN_VERSION, #13#10, GetHotKeyString]);

        if ShowSkin then
          imgBackground.Picture.LoadFromFile(ExtractFilePath(Application.ExeName) + BGFileName)
        else
          imgBackground.Picture := nil;

        //显示图标
        ntfMain.IconVisible := ShowTrayIcon;

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
            btnConfig.Left := Self.Width - btnConfig.Width - 10;
            lblShortCut.Width := btnConfig.Left - lblShortCut.Left;
          end
          else
          begin
            lblShortCut.Width := Self.Width - lblShortCut.Left;
          end
        end;

        //半透明效果
        lg := getWindowLong(Handle, GWL_EXSTYLE);
        lg := lg or WS_EX_LAYERED;
        SetWindowLong(handle, GWL_EXSTYLE, lg);
        SetLayeredWindowAttributes(handle, AlphaColor, Alpha, LWA_ALPHA or LWA_COLORKEY);

        //圆角矩形窗体
        SetWindowRgn(Handle, CreateRoundRectRgn(0, 0, Width, Height, RoundBorderRadius, RoundBorderRadius), True);

        //应用语言修改
        SetActiveLanguage;

        //数字编号顺序
        edtShortCutChange(Sender);

        //显示命令行
        if ShowCommandLine then
          Self.Height := 250
        else
          Self.Height := 230;

        SaveSettings;

        if IsNeedRestart then
        begin
          Application.MessageBox(PChar(resRestartMeInfo),
            PChar(resInfo), MB_OK + MB_ICONINFORMATION + MB_TOPMOST);
          RestartMe;
        end;
      end;
    end;
  finally
    ConfigForm.Free;
  end;
end;

procedure TALTRunForm.actCopyCommandLineExecute(Sender: TObject);
begin
  if lstShortCut.ItemIndex>=0 then
  begin
    //SetClipboardText(TShortCutItem(lstShortCut.Items.Objects[lstShortCut.ItemIndex]).CommandLine);
    Clipboard.AsUnicodeText := TShortCutItem(lstShortCut.Items.Objects[lstShortCut.ItemIndex]).CommandLine;
    edtCopy.Show;
    tmrCopy.Enabled := True;
  end;
end;

procedure TALTRunForm.actDeleteItemExecute(Sender: TObject);
var
  itm: TShortCutItem;
  Index: Integer;
begin
  TraceMsg('actDeleteItemExecute(%d)', [lstShortCut.ItemIndex]);

  if lstShortCut.ItemIndex < 0 then Exit;

  itm := TShortCutItem(lstShortCut.Items.Objects[lstShortCut.ItemIndex]);

  if Application.MessageBox(PChar(Format('%s %s(%s)?', [resDelete, itm.ShortCut, itm.Name])),
    PChar(resInfo), MB_OKCANCEL + MB_ICONQUESTION + MB_TOPMOST) = IDOK then
  begin
    Index := ShortCutMan.GetShortCutItemIndex(itm);
    ShortCutMan.DeleteShortCutItem(Index);

    //不加这一句，一旦添加“1111”，再删除“1111”，会报错
    m_LastShortCutListCount := 0;

    //刷新
    edtShortCutChange(Sender);
  end;
end;

procedure TALTRunForm.actDownExecute(Sender: TObject);
begin
  TraceMsg('actDownExecute');

  with lstShortCut do
    if Visible then
    begin
      if Count = 0 then Exit;

      //列表上下走
      if ItemIndex = -1 then
        ItemIndex := 0
      else
        if ItemIndex = Count - 1 then
          ItemIndex := 0
        else
          ItemIndex := ItemIndex + 1;

      DisplayShortCutItem(TShortCutItem(Items.Objects[ItemIndex]));
      m_LastShortCutCmdIndex := ItemIndex;

      if ShowOperationHint
        and (lstShortCut.ItemIndex >= 0)
        and (Length(edtShortCut.Text) < 10)
        and (lstShortCut.Items[lstShortCut.ItemIndex][2] in ['0'..'9']) then
        edtHint.Text := Format(resRunNum,
          [lstShortCut.Items[lstShortCut.ItemIndex][2],
          lstShortCut.Items[lstShortCut.ItemIndex][2]]);
    end;
end;

procedure TALTRunForm.actEditItemExecute(Sender: TObject);
var
  ShortCutForm: TShortCutForm;
  itm: TShortCutItem;
  Index: Integer;
begin
  TraceMsg('actEditItemExecute(%d)', [lstShortCut.ItemIndex]);

  if lstShortCut.ItemIndex < 0 then Exit;

  itm := TShortCutItem(lstShortCut.Items.Objects[lstShortCut.ItemIndex]);
  Index := ShortCutMan.GetShortCutItemIndex(itm);

  try
    ShortCutForm := TShortCutForm.Create(Self);
    with ShortCutForm do
    begin
      lbledtShortCut.Text := itm.ShortCut;
      lbledtName.Text := itm.Name;
      lbledtCommandLine.Text := itm.CommandLine;
      rgParam.ItemIndex := Ord(itm.ParamType);

      m_IsTop := False;
      ShowModal;
      m_IsTop := True;

      if ModalResult = mrCancel then Exit;

      //取得新的项目
      itm.ShortCutType := scItem;
      itm.ShortCut := lbledtShortCut.Text;
      itm.Name := lbledtName.Text;
      itm.CommandLine := lbledtCommandLine.Text;
      itm.ParamType := TParamType(rgParam.ItemIndex);

      //保存新的项目
      ShortCutMan.SaveShortCutList;
      ShortCutMan.LoadShortCutList;

      //刷新
      edtShortCutChange(Sender);
    end;
  finally
    ShortCutForm.Free;
  end;
end;

procedure TALTRunForm.actExecuteExecute(Sender: TObject);
var
  cmd: string;
  ret: Integer;
  ShortCutForm: TShortCutForm;
  Item: TShortCutItem;
  ShellApplication: Variant;
  i: Cardinal;
  ch: Char;
begin
  TraceMsg('actExecuteExecute(%d)', [lstShortCut.ItemIndex]);

  //若下面有选中某项
  if lstShortCut.Count > 0 then
  begin
    evtMainMinimize(Self);
    //Self.Hide;

    //WINEXEC//调用可执行文件
    //winexec('command.com /c copy *.* c:\',SW_Normal);
    //winexec('start abc.txt');
    //ShellExecute或ShellExecuteEx//启动文件关联程序
    //function executefile(const filename,params,defaultDir:string;showCmd:integer):THandle;
    //ExecuteFile('C:\abc\a.txt','x.abc','c:\abc\',0);
    //ExecuteFile('http://tingweb.yeah.net','','',0);
    //ExecuteFile('mailto:tingweb@wx88.net','','',0);
    //如果WinExec返回值小于32，就是失败，那就使用ShellExecute来搞

    //这种发送键盘的方法并不太好，所以屏蔽掉
    //    for i := 1 to Length(cmd) do
    //    begin
    //      ch := UpCase(cmd[i]);
    //      case ch of
    //        'A'..'Z': PostKeyEx32(ORD(ch), [], FALSE);
    //        '0'..'9': PostKeyEx32(ORD(ch), [], FALSE);                  R
    //        '.': PostKeyEx32(VK_DECIMAL, [], FALSE);
    //        '+': PostKeyEx32(VK_ADD, [], FALSE);
    //        '-': PostKeyEx32(VK_SUBTRACT, [], FALSE);
    //        '*': PostKeyEx32(VK_MULTIPLY, [], FALSE);
    //        '/': PostKeyEx32(VK_DIVIDE, [], FALSE);
    //        ' ': PostKeyEx32(VK_SPACE, [], FALSE);
    //        ';': PostKeyEx32(186, [], FALSE);
    //        '=': PostKeyEx32(187, [], FALSE);
    //        ',': PostKeyEx32(188, [], FALSE);
    //        '[': PostKeyEx32(219, [], FALSE);
    //        '\': PostKeyEx32(220, [], FALSE);
    //        ']': PostKeyEx32(221, [], FALSE);
    //      else
    //        ShowMessage(ch);
    //      end;
    //      //sleep(50);
    //    end;
    //
    //    PostKeyEx32(VK_RETURN, [], FALSE);

    //下面这种方法也不好
    //如果一种方式无法运行，就换一种
    //if WinExec(PChar(cmd), SW_SHOWNORMAL) < 33 then
    //begin
    //  if ShellExecute(0, 'open', PChar(cmd), nil, nil, SW_SHOWNORMAL) < 33 then
    //  begin
    //    //写批处理的这招，先不用
    //    //WriteLineToFile('D:\My\Code\Delphi\HotRun\Bin\shit.bat', cmd);
    //    //if ShellExecute(0, 'open', 'D:\My\Code\Delphi\HotRun\Bin\shit.bat', nil, nil, SW_HIDE) < 33 then
    //    Application.MessageBox(PChar(Format('Can not execute "%s"', [cmd])), 'Warning', MB_OK + MB_ICONWARNING);
    //  end;
    //end;

    //执行快捷项
    ShortCutMan.Execute(TShortCutItem(lstShortCut.Items.Objects[lstShortCut.ItemIndex]), edtShortCut.Text);

    //清空输入框
    edtShortCut.Text := '';

    //下面的方法，有时候键盘序列会发到其他窗口
    //打开“开始/运行”对话框，发送键盘序列
    //ShellApplication := CreateOleObject('Shell.Application');
    //ShellApplication.FileRun;
    //sleep(500);
    //SendKeys(PChar(cmd), False, True);
    //SendKeys('~', True, True);                         //回车

    //如果需要执行完就退出
    if ExitWhenExecute then tmrExit.Enabled := True;
  end
  else
    //如果没有合适项目，则提示是否添加之
    if Application.MessageBox(
      PChar(Format(resNoItemAndAdd, [edtShortCut.Text])),
      PChar(resInfo), MB_OKCANCEL + MB_ICONQUESTION) = IDOK then
      actAddItemExecute(Sender);
end;

procedure TALTRunForm.actHideExecute(Sender: TObject);
begin
  TraceMsg('actHideExecute()');

  evtMainMinimize(Sender);

  edtShortCut.Text := '';
end;

procedure TALTRunForm.actOpenDirExecute(Sender: TObject);
var
  itm: TShortCutItem;
  Index: Integer;
  cmdobj: TCmdObject;
  CommandLine: string;
  SlashPos: Integer;
  i: Cardinal;
begin
  TraceMsg('actOpenDirExecute(%d)', [lstShortCut.ItemIndex]);

  if lstShortCut.ItemIndex < 0 then Exit;

  itm := TShortCutItem(lstShortCut.Items.Objects[lstShortCut.ItemIndex]);
  Index := ShortCutMan.GetShortCutItemIndex(itm);

  //if not (FileExists(itm.CommandLine) or DirectoryExists(itm.CommandLine)) then Exit;

  cmdobj := TCmdObject.Create;
  cmdobj.Param := '';
  //cmdobj.Command := ExtractFileDir(RemoveQuotationMark(itm.CommandLine, '"'));

  //去除前导的@/@+/@-
  CommandLine := itm.CommandLine;
  if Pos(SHOW_MAX_FLAG, CommandLine) = 1 then
    CommandLine := CutLeftString(CommandLine, Length(SHOW_MAX_FLAG))
  else if Pos(SHOW_MIN_FLAG, CommandLine) = 1 then
    CommandLine := CutLeftString(CommandLine, Length(SHOW_MIN_FLAG))
  else if Pos(SHOW_HIDE_FLAG, CommandLine) = 1 then
    CommandLine := CutLeftString(CommandLine, Length(SHOW_HIDE_FLAG));

  cmdobj.Command := RemoveQuotationMark(CommandLine, '"');

  if (Pos('.\', itm.CommandLine) > 0) or (Pos('..\', itm.CommandLine) > 0) then
  begin
    TraceMsg('CommandLine = %s', [itm.CommandLine]);
    TraceMsg('Application.ExeName = %s', [Application.ExeName]);
    TraceMsg('WorkingDir = %s', [ExtractFilePath(Application.ExeName)]);

    cmdobj.Command := ExtractFileDir(CommandLine);
    cmdobj.WorkingDir := ExtractFilePath(Application.ExeName);
  end
  else if FileExists(ExtractFileDir(itm.CommandLine)) then
  begin
    cmdobj.Command := ExtractFileDir(CommandLine);
    cmdobj.WorkingDir := ExtractFileDir(itm.CommandLine);
  end
  else
  begin
    SlashPos := 0;
    if Length(cmdobj.Command) > 1 then
      for i := Length(cmdobj.Command) - 1 downto 1 do
        if cmdobj.Command[i] = '\' then
        begin
          SlashPos := i;
          Break;
        end;

    if SlashPos > 0 then
    begin
      // 如果第一个字符是"
      if cmdobj.Command[1] = '"' then
        cmdobj.Command := (Copy(cmdobj.Command, 2, SlashPos - 1))
      else
        cmdobj.Command := (Copy(cmdobj.Command, 1, SlashPos));

      cmdobj.WorkingDir := cmdobj.Command;
    end
    else
    begin
      cmdobj.Command := ExtractFileDir(cmdobj.Command);
      cmdobj.WorkingDir := '';
    end;

  end;

  ShortCutMan.Execute(cmdobj);
end;

procedure TALTRunForm.actSelectChangeExecute(Sender: TObject);
begin
  TraceMsg('actSelectChangeExecute(%d)', [lstShortCut.ItemIndex]);

  if lstShortCut.ItemIndex = -1 then Exit;

  lblShortCut.Caption := TShortCutItem(lstShortCut.Items.Objects[lstShortCut.ItemIndex]).Name;
  lblShortCut.Hint := TShortCutItem(lstShortCut.Items.Objects[lstShortCut.ItemIndex]).CommandLine;
  //edtCommandLine.Hint := lblShortCut.Hint;
  edtCommandLine.Text := resCMDLine + lblShortCut.Hint;

  if DirAvailable then lblShortCut.Caption := '[' + lblShortCut.Caption + ']';
end;

procedure TALTRunForm.actShortCutExecute(Sender: TObject);
const
  TEST_ITEM_COUNT = 10;
  Test_Array: array[0..TEST_ITEM_COUNT - 1] of Integer = (3, 0, 8, 2, 8, 6, 1, 3, 0, 8);

var
  ShortCutManForm: TShortCutManForm;
  StringList: TStringList;
  i: Cardinal;
  str: string;
  Item: TShortCutItem;
  ret:Integer;
  FileDate: Integer;
  hALTRun:HWND;
begin
  TraceMsg('actShortCutExecute()');

  if DEBUG_MODE then
  begin
    //Randomize;
    //StringList := TStringList.Create;
    //try
    //  TraceMsg('- Before QuickSort');
    //
    //  for i := 0 to TEST_ITEM_COUNT - 1 do
    //  begin
    //    Item := TShortCutItem.Create;
    //    with Item do
    //    begin
    //      ShortCutType := scItem;
    //      Freq := Test_Array[i];                       //Random(TEST_ITEM_COUNT);
    //      Rank := Freq;
    //      Name := IntToStr(Rank);
    //      ParamType := ptNone;
    //
    //      TraceMsg('  - [%d] = %d', [i, Freq]);
    //    end;
    //
    //    StringList.AddObject(Item.Name, Item);
    //  end;
    //
    //  ShortCutMan.QuickSort(StringList, 0, TEST_ITEM_COUNT - 1);
    //
    //  TraceMsg('- After QuickSort');
    //
    //  for i := 0 to TEST_ITEM_COUNT - 1 do
    //  begin
    //    Item := TShortCutItem(StringList.Objects[i]);
    //    with Item do
    //    begin
    //      TraceMsg('  - [%d] = %d', [i, Freq]);
    //    end;
    //
    //    Item.Free;
    //  end;
    //
    //  TraceMsg('- End QuickSort');
    //finally
    //  StringList.Free;
    //end;

    //ret := ShellExecute(0, nil, PChar(GetEnvironmentVariable('windir')), nil, nil, SW_SHOWNORMAL);
    //ret := WinExec('%windir%', 1);

    //FileDate := FileAge('123.txt');
    //FileDate := 975878736;
    //SetFileModifyTime('123.txt', FileDateToDateTime(FileDate));

    //hALTRun := FindWindowByCaption('ALTRun');
    //ShowMessage(IntToStr(hALTRun));
    //PostMessage(FindWindowByCaption('ALTRun'), WM_ALTRUN_ADD_SHORTCUT, 0, 0);
    //m_IsFirstDblClickIcon := True;
    //ntfMainDblClick(nil);

    //edtShortCut.ImeMode := imOpen;
    //TraceMsg('ImeMode = %d, ImeName = %s', [Ord(edtShortCut.ImeMode), edtShortCut.ImeName]);

    SetEnvironmentVariable(PChar('MyTool'), PChar('C:\'));
    Exit;
  end;

  try
    ShortCutManForm := TShortCutManForm.Create(Self);
    with ShortCutManForm do
    begin
      m_IsTop := False;
      StopTimer;
      ShowModal;
      m_IsTop := True;

      if ModalResult = mrOk then
      begin
        //刷新快捷项列表
        ShortCutMan.LoadFromListView(lvShortCut);
        ShortCutMan.SaveShortCutList;
        ShortCutMan.LoadShortCutList;

        if m_IsShow then
        begin
          edtShortCutChange(Sender);

          try
            edtShortCut.SetFocus;
          except
            TraceMsg('edtShortCut.SetFocus failed');
          end;
        end;
      end;

      RestartHideTimer(HideDelay);
    end;
  finally
    ShortCutManForm.Free;
  end;
end;

procedure TALTRunForm.actShowExecute(Sender: TObject);
var
  lg: longint;
  WinMediaFileName, PopupFileName: string;
  IsForeWindow: Boolean;
  TryTimes: Integer;
  OldTickCount: Cardinal;
begin
  TraceMsg('actShowExecute()');

  Self.Caption := TITLE;

  if ParamForm <> nil then ParamForm.ModalResult := mrCancel;

  ShortCutMan.LoadShortCutList;

  //如果输入框有字，则清空再刷新
  if (edtShortCut.Text <> '') then
  begin
    edtShortCut.Text := '';
  end
  else
  begin
    if m_IsFirstShow or m_NeedRefresh or ShortCutMan.NeedRefresh then
    begin
      m_NeedRefresh := False;
      edtShortCutChange(Sender);
      ShortCutMan.NeedRefresh := False;
    end
    else
    begin
      RefreshOperationHint;

      if lstShortCut.Items.Count > 0 then
      begin
        lstShortCut.ItemIndex := 0;
        lblShortCut.Caption := TShortCutItem(lstShortCut.Items.Objects[0]).Name;
        if DirAvailable then lblShortCut.Caption := '[' + lblShortCut.Caption + ']';
      end;
    end;

  end;

  Self.Show;

  if m_IsFirstShow then
  begin
    m_IsFirstShow := False;

    //设置窗体位置
    if (WinTop <= 0) or (WinLeft <= 0) then
    begin
      Self.Position := poScreenCenter;
    end
    else
    begin
      Self.Top := WinTop;
      Self.Left := WinLeft;
      Self.Width := FormWidth;
    end;

    //字体
    StrToFont(TitleFontStr, lblShortCut.Font);
    StrToFont(KeywordFontStr, edtShortCut.Font);
    StrToFont(ListFontStr, lstShortCut.Font);

    //修改背景图
    if not FileExists(ExtractFilePath(Application.ExeName) + BGFileName) then
      imgBackground.Picture.SaveToFile(ExtractFilePath(Application.ExeName) + BGFileName);

    if ShowSkin then
      imgBackground.Picture.LoadFromFile(ExtractFilePath(Application.ExeName) + BGFileName)
    else
      imgBackground.Picture := nil;

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
        btnConfig.Left := Self.Width - btnConfig.Width - 10;
        lblShortCut.Width := btnConfig.Left - lblShortCut.Left;
      end
      else
      begin
        lblShortCut.Width := Self.Width - lblShortCut.Left;
      end
    end;

    //半透明效果
    lg := getWindowLong(Handle, GWL_EXSTYLE);
    lg := lg or WS_EX_LAYERED;
    SetWindowLong(handle, GWL_EXSTYLE, lg);

    //第二个参数是指定透明颜色
    //第二个参数若为0则使用第四个参数设置alpha值，从0到255
    SetLayeredWindowAttributes(handle, AlphaColor, Alpha, LWA_ALPHA or LWA_COLORKEY);

    //圆角矩形窗体
    SetWindowRgn(Handle, CreateRoundRectRgn(0, 0, Width, Height, RoundBorderRadius, RoundBorderRadius), True);

    //获得最近使用快捷方式的列表
    ShortCutMan.SetLatestShortCutIndexList(LatestList);

    lstShortCut.Height := 10 * lstShortCut.ItemHeight;

    //显示命令行
    if ShowCommandLine then
      Self.Height := 250 {Self.Height + 20}
    else
      Self.Height := 230 {Self.Height - 20};

    {
    edtCommandLine.Top := lstShortCut.Top + lstShortCut.Height + 6;

    if ShowCommandLine then
    begin
      Self.Height := edtCommandLine.Top + edtCommandLine.Height + 6;
    end
    else
      Self.Height := edtCommandLine.Top;
    }
  end;

  //把窗体放到顶端
  Application.Restore;
  SetForegroundWindow(Application.Handle);
  m_IsShow := True;
  edtShortCut.SetFocus;
  GetLastCmdList;
  RestartHideTimer(HideDelay);
  tmrFocus.Enabled := True;

  //保存窗体位置
  WinTop := Self.Top;
  WinLeft := Self.Left;

  //取得最近一次击键时间
  m_LastActiveTime := GetTickCount;

  m_IsTop := True;

  //播放声音
  if PlayPopupNotify then
  begin
    PopupFileName := ExtractFilePath(Application.ExeName) + 'Popup.wav';
    //WinMediaFileName := GetEnvironmentVariable('windir') + '\Media\ding.wav';
    if not FileExists(PopupFileName) then
      //CopyFile(PChar(WinMediaFileName), PChar(PopupFileName), True);
      ExtractRes('WAVE', 'PopupWav', 'Popup.wav');

    if FileExists(PopupFileName) then
      PlaySound(PChar(PopupFileName), 0, snd_ASYNC)
    else
      PlaySound(PChar('PopupWav'), HInstance, snd_ASYNC or SND_RESOURCE);
  end;
end;

procedure TALTRunForm.actUpExecute(Sender: TObject);
begin
  TraceMsg('actUpExecute');

  with lstShortCut do
    if Visible then
    begin
      if Count = 0 then Exit;

      //列表上下走
      if ItemIndex = -1 then
        ItemIndex := Count - 1
      else
        if ItemIndex = 0 then
          ItemIndex := Count - 1
        else
          ItemIndex := ItemIndex - 1;

      DisplayShortCutItem(TShortCutItem(Items.Objects[ItemIndex]));
      m_LastShortCutCmdIndex := ItemIndex;

      if ShowOperationHint
        and (lstShortCut.ItemIndex >= 0)
        and (Length(edtShortCut.Text) < 10)
        and (lstShortCut.Items[lstShortCut.ItemIndex][2] in ['0'..'9']) then
        edtHint.Text := Format(resRunNum,
          [lstShortCut.Items[lstShortCut.ItemIndex][2],
          lstShortCut.Items[lstShortCut.ItemIndex][2]]);
    end;
end;

function TALTRunForm.ApplyHotKey1: Boolean;
var
  HotKeyVar: Cardinal;
begin
  Result := False;

  TraceMsg('ApplyHotKey1(%s)', [HotKeyStr1]);

  HotKeyVar := TextToHotKey(HotKeyStr1, LOCALIZED_KEYNAMES);

  if (HotKeyVar = 0) or (hkmHotkey1.AddHotKey(HotKeyVar) = 0) then
  begin
    Application.MessageBox(PChar(Format(resHotKeyError, [HotKeyStr1])),
      PChar(resWarning), MB_OK + MB_ICONWARNING);

    Exit;
  end;

  Result := True;
end;

function TALTRunForm.ApplyHotKey2: Boolean;
var
  HotKeyVar: Cardinal;
begin
  Result := False;

  TraceMsg('ApplyHotKey2(%s)', [HotKeyStr2]);

  HotKeyVar := TextToHotKey(HotKeyStr2, LOCALIZED_KEYNAMES);

  if (HotKeyVar = 0) or (hkmHotkey2.AddHotKey(HotKeyVar) = 0) then
  begin
    if (HotKeyStr2 <> '') and (HotKeyStr2 <> resVoidHotKey) then
    begin
      Application.MessageBox(PChar(Format(resHotKeyError, [HotKeyStr2])),
        PChar(resWarning), MB_OK + MB_ICONWARNING);

      HotKeyStr2 := '';
    end;
      
    Exit;
  end;

  Result := True;
end;

procedure TALTRunForm.btnShortCutClick(Sender: TObject);
begin
  TraceMsg('btnShortCutClick()');

  if DEBUG_MODE then
  begin
    if ShortCutMan.Test then
      ShowMessage('True')
    else
      ShowMessage('False');
  end
  else
  begin
    actShortCutExecute(Sender);
    if m_IsShow then
      try
        edtShortCut.SetFocus;
      except
        TraceMsg('edtShortCut.SetFocus failed');
      end;
  end;
end;

function TALTRunForm.DirAvailable: Boolean;
var
  itm: TShortCutItem;
  Index: Integer;
  CommandLine: string;
  SlashPos: Integer;
  i: Cardinal;
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

  if (FileExists(CommandLine) {or DirectoryExists(CommandLine)}) then
    Result := True
  else
  begin
    if Pos('.\', CommandLine) = 1 then
      Result := True
    else
    begin
      // 查找最后一个"\"，以此来定路径
      SlashPos := 0;
      if Length(CommandLine) > 1 then
        for i := Length(CommandLine) - 1 downto 1 do
          if CommandLine[i] = '\' then
          begin
            SlashPos := i;
            Break;
          end;

      if SlashPos > 0 then
      begin
        // 如果第一个字符是"
        if CommandLine[1] = '"' then
          Result := DirectoryExists(Copy(CommandLine, 2, SlashPos - 1))
        else
          Result := DirectoryExists(Copy(CommandLine, 1, SlashPos));
      end
      else
        Result := False;
    end;
  end;

  if Result then
    TraceMsg('DirAvailable(%s) = True', [itm.CommandLine])
  else
    TraceMsg('DirAvailable(%s) = False', [itm.CommandLine]);
end;

procedure TALTRunForm.DisplayShortCutItem(Item: TShortCutItem);
begin
  TraceMsg('DisplayShortCutItem()');

  lblShortCut.Caption := Item.Name;
  lblShortCut.Hint := Item.CommandLine;
  edtCommandLine.Text := resCMDLine + Item.CommandLine;
  if DirAvailable then lblShortCut.Caption := '[' + Item.Name + ']';
end;

procedure TALTRunForm.edtCommandLineKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  TraceMsg('edtCommandLineKeyDown( #%d = %s )', [Key, Chr(Key)]);

  if not ((ssShift in Shift) or (ssAlt in Shift) or (ssCtrl in Shift)) then
    case Key of
      //回车
      13: ;

      VK_PRIOR, VK_NEXT: ;
    else
      if m_IsShow then
      begin
        //传到这里的键，都转发给edtShortCut
        PostMessage(edtShortCut.Handle, WM_KEYDOWN, Key, 0);

        try
          edtShortCut.SetFocus;
        except
          TraceMsg('edtShortCut.SetFocus failed');
        end;
      end;
    end;
end;

procedure TALTRunForm.MiddleMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbMiddle then
  begin
    actExecuteExecute(Sender);
  end;
end;

procedure TALTRunForm.edtShortCutChange(Sender: TObject);
var
  i, j, k: Cardinal;
  Rank, ExistRank: Integer;
  IsInserted: Boolean;
  StringList: TStringList;
  HintIndex: Integer;
begin
  // 有时候内容没有变化，却触发这个消息，那是因为有人主动调用它了
  //if edtShortCut.Text = m_LastShortCutText then Exit;
  //m_LastShortCutText := edtShortCut.Text;

  TraceMsg('edtShortCutChange(%s)', [edtShortCut.Text]);

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

    //看最后一个字符是否是数字0-9
    if EnableNumberKey and m_LastKeyIsNumKey then
      if (edtShortCut.Text[Length(edtShortCut.Text)] in ['0'..'9']) then
      begin
        k := StrToInt(edtShortCut.Text[Length(edtShortCut.Text)]);

        if IndexFrom0to9 then
        begin
          if k <= m_LastShortCutListCount - 1 then
          begin
            evtMainMinimize(Self);

            ShortCutMan.Execute(TShortCutItem(m_LastShortCutPointerList[k]),
              Copy(edtShortCut.Text, 1, Length(edtShortCut.Text) - 1));

            edtShortCut.Text := '';
          end;
        end
        else
        begin
          if k = 0 then k := 10;

          if k <= m_LastShortCutListCount then
          begin
            evtMainMinimize(Self);

            ShortCutMan.Execute(TShortCutItem(m_LastShortCutPointerList[k - 1]),
              Copy(edtShortCut.Text, 1, Length(edtShortCut.Text) - 1));

            edtShortCut.Text := '';
          end;
        end;
      end;

    //最后一个如果是空格
    if (edtShortCut.Text <> '') and (edtShortCut.Text[Length(edtShortCut.Text)] in [' ']) then
    begin
      if (m_LastShortCutListCount > 0)
        and (m_LastShortCutCmdIndex >= 0)
        and (m_LastShortCutCmdIndex < m_LastShortCutListCount) then
      begin
        evtMainMinimize(Self);

        ShortCutMan.Execute(TShortCutItem(m_LastShortCutPointerList[m_LastShortCutCmdIndex]),
          Copy(edtShortCut.Text, 1, Length(edtShortCut.Text) - 1));

        edtShortCut.Text := '';

        //如果需要执行完就退出
        if ExitWhenExecute then tmrExit.Enabled := True;

      end;
    end;
  end
  else
  begin
    lstShortCut.ItemIndex := 0;
    lblShortCut.Caption := TShortCutItem(lstShortCut.Items.Objects[0]).Name;
    lblShortCut.Hint := TShortCutItem(lstShortCut.Items.Objects[0]).CommandLine;
    edtCommandLine.Text := resCMDLine + lblShortCut.Hint;

    //如果只有一项就立即执行
    if ExecuteIfOnlyOne and (lstShortCut.Count = 1) then
    begin
      actExecuteExecute(Sender);
    end;

  end;

  //如果可以打开文件夹，标记下
  if DirAvailable then lblShortCut.Caption := '[' + lblShortCut.Caption + ']';

  //刷新上一次的列表
  GetLastCmdList;

  //刷新提示
  RefreshOperationHint;
end;

procedure TALTRunForm.edtShortCutKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  Index: Integer;
begin
  TraceMsg('edtShortCutKeyDown( #%d = %s )', [Key, Chr(Key)]);

  m_LastKeyIsNumKey := False;

  //关闭tmrFocus
  tmrFocus.Enabled := False;

  case Key of
{    VK_UP:
      with lstShortCut do
        if Visible then
        begin
          //为了防止向上键导致光标位置移动，故吞掉之
          Key := VK_NONAME;

          //列表上下走
          if ItemIndex = -1 then
            ItemIndex := Count - 1
          else
            if ItemIndex = 0 then
              ItemIndex := Count - 1
            else
              ItemIndex := ItemIndex - 1;

          DisplayShortCutItem(TShortCutItem(Items.Objects[ItemIndex]));
        end;

    VK_DOWN:
      with lstShortCut do
        if Visible then
        begin
          //为了防止向下键导致光标位置移动，故吞掉之
          Key := VK_NONAME;

          //列表上下走
          if ItemIndex = -1 then
            ItemIndex := 0
          else
            if ItemIndex = Count - 1 then
              ItemIndex := 0
            else
              ItemIndex := ItemIndex + 1;

          DisplayShortCutItem(TShortCutItem(Items.Objects[ItemIndex]));
        end;
 }
    VK_PRIOR:
      with lstShortCut do
      begin
        Key := VK_NONAME;
        PostMessage(lstShortCut.Handle, WM_KEYDOWN, VK_PRIOR, 0);
      end;

    VK_NEXT:
      with lstShortCut do
      begin
        Key := VK_NONAME;
        PostMessage(lstShortCut.Handle, WM_KEYDOWN, VK_NEXT, 0);
      end;

    //数字键0-9，和小键盘数字键. ALT+Num 或 CTRL+Num 都可以执行
    48..57, 96..105:
      begin
        m_LastKeyIsNumKey := True;

        if (ssCtrl in Shift) or (ssAlt in Shift) then
        begin
          if Key >= 96 then
            Index := Key - 96
          else
            Index := Key - 48;

          //看看数字是否超出已有总数
          if IndexFrom0to9 and (Index > lstShortCut.Count - 1) then Exit;
          if (not IndexFrom0to9) and (Index > lstShortCut.Count) then Exit;

          evtMainMinimize(Self);

          if IndexFrom0to9 then
            ShortCutMan.Execute(TShortCutItem(lstShortCut.Items.Objects[Index]), edtShortCut.Text)
          else
            ShortCutMan.Execute(TShortCutItem(lstShortCut.Items.Objects[(Index + 9) mod 10]), edtShortCut.Text);

          edtShortCut.Text := '';
        end;
      end;

    //分号键 = No.2 , '号键 = No.3
    186, 222:
      begin
        if Key = 186 then
          Index := 2
        else
          Index := 3;

        //看看数字是否超出已有总数
        if IndexFrom0to9 and (Index > lstShortCut.Count - 1) then Exit;
        if (not IndexFrom0to9) and (Index > lstShortCut.Count) then Exit;

        evtMainMinimize(Self);

        if IndexFrom0to9 then
          ShortCutMan.Execute(TShortCutItem(lstShortCut.Items.Objects[Index]), edtShortCut.Text)
        else
          ShortCutMan.Execute(TShortCutItem(lstShortCut.Items.Objects[(Index + 9) mod 10]), edtShortCut.Text);

        edtShortCut.Text := '';
      end;

    //CTRL+D，打开文件夹
    68:
      begin
        if (ssCtrl in Shift) then
        begin
          KillMessage(Self.Handle, WM_CHAR);

          if not DirAvailable then Exit;

          evtMainMinimize(Self);
          actOpenDirExecute(Sender);
          edtShortCut.Text := '';

        end;
      end;

    //CTRL+C，复制CommandLine
    67:
      begin
        if (ssCtrl in Shift) then
        begin
          //这个方法对于中文是乱码，必须用Unicode来搞
          //Clipboard.SetTextBuf(PChar(TShortCutItem(lstShortCut.Items.Objects[lstShortCut.ItemIndex]).CommandLine));

          actCopyCommandLineExecute(Sender);
        end;
      end;

    //CTRL+L，列出最近使用的列表(最多只取10个)
    76:
      begin
        if (ssCtrl in Shift) then
        begin
         ShowLatestShortCutList;
         KillMessage(Self.Handle, WM_CHAR);
        end;
      end;

    VK_ESCAPE:
      begin
        //如果不为空，就清空，否则隐藏
        if edtShortCut.Text = '' then
          evtMainMinimize(Self)
        else
          edtShortCut.Text := '';
      end;
  end;

  if ShowOperationHint
    and (lstShortCut.ItemIndex >= 0)
    and (Length(edtShortCut.Text) < 10)
    and (lstShortCut.Items[lstShortCut.ItemIndex][2] in ['0'..'9']) then
    edtHint.Text := Format(resRunNum,
      [lstShortCut.Items[lstShortCut.ItemIndex][2],
      lstShortCut.Items[lstShortCut.ItemIndex][2]]);
end;

procedure TALTRunForm.edtShortCutKeyPress(Sender: TObject; var Key: Char);
begin
  TraceMsg('edtShortCutKeyPress(%d)', [Key]);

  // 看起来这块儿根本执行不到
  Exit;

  //如果回车，就执行程序
  if Key = #13 then
  begin
    Key := #0;
    actExecuteExecute(Sender);
  end;
end;

procedure TALTRunForm.edtShortCutMouseActivate(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y, HitTest: Integer;
  var MouseActivate: TMouseActivate);
begin
  TraceMsg('edtShortCutMouseActivate()');

  RestartHideTimer(HideDelay);
end;

procedure TALTRunForm.evtMainActivate(Sender: TObject);
begin
  TraceMsg('evtMainActivate()');

  RestartHideTimer(HideDelay);
end;

procedure TALTRunForm.evtMainDeactivate(Sender: TObject);
var
  IsActivated: Boolean;
begin
  TraceMsg('evtMainDeactivate(%d)', [GetTickCount - m_LastActiveTime]);

  // 失去焦点就一律隐藏
  evtMainMinimize(Sender);
  edtShortCut.Text := '';

//如果失去焦点，且离上一次击键超过一定时间，就隐藏
//  if (GetTickCount - m_LastActiveTime) > 500 then
//  begin
//    TraceMsg('Lost focus for a long time, so hide me');
//
//    evtMainMinimize(Sender);
//    edtShortCut.Text := '';
//  end
//  else
//  begin
//    if m_IsShow then
//    begin
//      //TraceMsg('Lost focus, try to activate me');
//
//      //tmrFocus.Enabled := True;
//      Exit;
//      {
//      IsActivated := False;
//      while not IsActivated do
//      begin
//        TraceMsg('SetForegroundWindow failed, try again');
//        IsActivated := SetForegroundWindow(Application.Handle);
//        Sleep(100);
//        Application.HandleMessage;
//      end;
//
//      TraceMsg('Application.Active = %s', [BoolToStr(Application.Active)]);
//
//      edtShortCut.SetFocus;
//      RestartHideTimer(HideDelay);
//      }
//    end;
//
//    //SetActiveWindow(Application.Handle);
//    //SetForegroundWindow(Application.Handle);
//    //Self.Show;
//    //Self.SetFocus;
////    try
////      edtShortCut.SetFocus;
////    except
////      TraceErr('edtShortCut.SetFocus = Fail');
////    end;
////
////    RestartHideTimer(1);
//  end;

end;

procedure TALTRunForm.evtMainIdle(Sender: TObject; var Done: Boolean);
begin
  ReduceWorkingSize;
end;

procedure TALTRunForm.evtMainMessage(var Msg: tagMSG; var Handled: Boolean);
var
  FileName: string;
begin
{
  // 本来想防止用户乱用输入法的，现在看来没必要
  case Msg.message of
    WM_INPUTLANGCHANGEREQUEST:
    begin
      TraceMsg('WM_INPUTLANGCHANGEREQUEST(%d, %d)',[Msg.wParam, Msg.lParam]);

      if AllowIMEinEditShortCut then
        Handled := False
      else
      begin
        if edtShortCut.Focused then
        begin
          TraceMsg('edtShortCut.Focused = True');

          Handled := True;
        end
        else
        begin
          TraceMsg('edtShortCut.Focused = False');

          Handled := False;
        end;
      end;
    end;
  end;
}

  case Msg.message of
    WM_SYSCOMMAND:                                     //点击关闭按钮
      if Msg.WParam = SC_CLOSE then
      begin
        if DEBUG_MODE then
          actCloseExecute(Self)                        //如果Debug模式，可以Alt-F4关闭
        else
        begin
          evtMainMinimize(Self);                       //正常模式，仅仅隐藏
          edtShortCut.Text := '';
        end
      end
      else
        inherited;

    WM_QUERYENDSESSION, WM_ENDSESSION:                 //系统关机
      begin
        TraceMsg('System shutdown');
        actCloseExecute(Self);

        inherited;
      end;

    WM_MOUSEWHEEL:
    begin
      if m_IsTop then
      begin
        if Msg.wParam > 0 then
          PostMessage(lstShortCut.Handle, WM_KEYDOWN, VK_UP, 0)
        else
          PostMessage(lstShortCut.Handle, WM_KEYDOWN, VK_DOWN, 0);
      end;

      Handled := False;    
    end;
  end;
end;

procedure TALTRunForm.evtMainMinimize(Sender: TObject);
begin
  inherited;

  TraceMsg('evtMainMinimize()');

  edtCopy.Visible := False;
  m_IsShow := False;
  self.Hide;
  StopTimer;
end;

procedure TALTRunForm.evtMainShortCut(var Msg: TWMKey; var Handled: Boolean);
begin
  // 在ActionList中创建actUp和actDown，分别对应SecondaryShortCuts为Shift+Tab和Tab
end;

procedure TALTRunForm.FormActivate(Sender: TObject);
begin
  TraceMsg('FormActivate()');

  RestartHideTimer(HideDelay);
end;

procedure TALTRunForm.FormCreate(Sender: TObject);
var
  lg: longint;
  LangForm: TLangForm;
  LangList: TStringList;
  i: Cardinal;
  hALTRun: HWND;
  FileName: string;
begin
  Self.Caption := TITLE;

  //初始化不显示图标
  ntfMain.IconVisible := False;

  //窗体防闪
  Self.DoubleBuffered := True;
  lstShortCut.DoubleBuffered := True;
  edtShortCut.DoubleBuffered := True;
  edtHint.DoubleBuffered := True;
  edtCommandLine.DoubleBuffered := True;
  edtCopy.DoubleBuffered := True;

  //Load 配置
  //LoadSettings;

  m_IsExited := False;

  //如果是第一次使用，提示选择语言
  if IsRunFirstTime then
  begin
    try
      LangForm := TLangForm.Create(Self);

      LangForm.cbbLang.Items.Add(DEFAULT_LANG);
      LangForm.cbbLang.ItemIndex := 0;

      LangList := TStringList.Create;
      if GetLangList(LangList) then
      begin
        if LangList.Count > 0 then
        begin
          for i := 0 to LangList.Count - 1 do
            if LangForm.cbbLang.Items.IndexOf(LangList.Strings[i]) < 0 then
              LangForm.cbbLang.Items.Add(LangList.Strings[i]);

          for i := 0 to LangForm.cbbLang.Items.Count - 1 do
            if LangForm.cbbLang.Items[i] = Lang then
            begin
              LangForm.cbbLang.ItemIndex := i;
              Break;
            end;
        end;
      end;

      if LangList.Count > 0 then
      begin
        // 专门为了简体中文
        if Lang = '简体中文' then
          LangForm.Caption := '请选择界面语言';

        LangForm.ShowModal;

        if LangForm.ModalResult = mrOk then
        begin
          Lang := LangForm.cbbLang.Text;
          SetActiveLanguage;
        end
        else
        begin
          DeleteFile(ExtractFilePath(Application.ExeName) + TITLE + '.ini');
          Halt(1);
        end;
      end;

    finally
      LangList.Free;
      LangForm.Free;
    end;
  end
  else
  begin
    SetActiveLanguage;
  end;

  //Load 快捷方式
  ShortCutMan := TShortCutMan.Create;
  ShortCutMan.LoadShortCutList;
  m_AgeOfFile := FileAge(ShortCutMan.ShortCutFileName);

  //初始化上次列表
  m_LastShortCutCmdIndex := -1;
  m_LastKeyIsNumKey := False;

  //若有参数，则判断之
  if ParamStr(1) <> '' then
  begin

    //自动重启软件
    if ParamStr(1) = RESTART_FLAG then
    begin
      Sleep(2000);
    end
    //删除软件时清理环境
    else if ParamStr(1) = CLEAN_FLAG then
    begin
      if Application.MessageBox(PChar(resCleanConfirm), PChar(resInfo),
        MB_YESNO + MB_ICONQUESTION + MB_TOPMOST) = IDYES then
      begin
        SetAutoRun(TITLE, '', False);
        SetAutoRunInStartUp(TITLE, '', False);
        AddMeToSendTo(TITLE, False);
      end;

      Application.Terminate;
      Exit;
    end
    else
    //添加快捷方式
    begin
      Self.Caption := TITLE + ' - Add ShortCut';
      
      {
      hALTRun := FindWindow('TALTRunForm', TITLE);
      if hALTRun <> 0 then
      begin
        SendMessage(hALTRun, WM_ALTRUN_ADD_SHORTCUT, 0, 0);

        //等待文件被写入，从而时间更改，以此为判断依据
        while FileAge(ShortCutMan.ShortCutFileName) = m_AgeOfFile  do
        begin
          Application.HandleMessage;
        end;

        //此时可以重载文件
        ShortCutMan.LoadShortCutList;
      end;
      }

      //读取当前的快捷项列表文件，如果ALTRun已经运行，
      //则通过 WM_ALTRUN_ADD_SHORTCUT 将快捷项字符串发送过去
      //如果ALTRun并未启动，则直接保存到快捷项列表文件中

      //处理长文件名, 对于路径中有空格的，前后带上""
      FileName := ParamStr(1);
      if Pos(' ', FileName) > 0 then FileName := '"' + FileName + '"';

      if DEBUG_MODE then
        ShowMessageFmt('Add %s', [FileName]);

      //查找ALTRun, 窗口不好查找，直接读取INI文件
      //hend;ALTRun := FindWindow('TALTRunForm', TITLE);
      hALTRun := HandleID;
      if (hALTRun <> 0) and IsWindow(hALTRun) then
      begin
        //Application.MessageBox(PChar(Format('ALTRun is running = %d', [hALTRun])),
        //  'Debug', MB_OK + MB_ICONINFORMATION + MB_TOPMOST);

        SendMessage(hALTRun, WM_SETTEXT, 1, Integer(PChar(FileName)));
      end
      else
      begin
        //Application.MessageBox(PChar('ALTRun is NOT running'),
        //  'Debug', MB_OK + MB_ICONINFORMATION + MB_TOPMOST);

        ShortCutMan.LoadShortCutList;
        ShortCutMan.AddFileShortCut(FileName);
      end;

      m_IsExited := True;
      Application.Terminate;
      Exit;
    end;
  end;

  if IsRunningInstance('ALTRUN_MUTEX') then
  begin
    // 发送消息，让ALTRun显示出来
    SendMessage(HandleID, WM_ALTRUN_SHOW_WINDOW, 0, 0);

    Halt(1);
    //Application.Terminate;
    //Exit;
  end;

  //LOG
  //InitLogger(DEBUG_MODE,DEBUG_MODE, False);
  InitLogger(DEBUG_MODE,False, False);

  //Trace
  TraceMsg('FormCreate()');

  //判断是否是Vista
  TraceMsg('OS is Vista = %s', [BoolToStr(IsVista)]);

  //干掉老的HotRun的启动项和SendTo
  if LowerCase(ExtractFilePath(GetAutoRunItemPath('HotRun')))
    = LowerCase(ExtractFilePath(Application.ExeName)) then
    SetAutoRun('HotRun', '', False);

  if LowerCase(ExtractFilePath(GetAutoRunItemPath('HotRun.exe')))
    = LowerCase(ExtractFilePath(Application.ExeName)) then
  begin
    SetAutoRun('HotRun.exe', '', False);
    SetAutoRunInStartUp('HotRun.exe', '', False);
  end;

  if LowerCase(ExtractFilePath(ResolveLink(GetSendToDir + '\HotRun.lnk')))
    = LowerCase(ExtractFilePath(Application.ExeName)) then
    AddMeToSendTo('HotRun', False);

  if FileExists(ExtractFilePath(Application.ExeName) + 'HotRun.ini') then
    RenameFile(ExtractFilePath(Application.ExeName) + 'HotRun.ini',
      ExtractFilePath(Application.ExeName) + TITLE + '.ini');

  if LowerCase(ExtractFilePath(GetAutoRunItemPath('ALTRun.exe')))
    = LowerCase(ExtractFilePath(Application.ExeName)) then
  begin
    SetAutoRun('ALTRun.exe', '', False);
    SetAutoRunInStartUp('ALTRun.exe', '', False);
  end;

  //配置设置
  ApplyHotKey1;
  ApplyHotKey2;

  //TODO: 暂时以ALT+L作为调用最近一次快捷项的热键
  hkmHotkey3.AddHotKey(TextToHotKey(LastItemHotKeyStr, LOCALIZED_KEYNAMES));

  //配置菜单语言
  actShow.Caption := resMenuShow;
  actShortCut.Caption := resMenuShortCut;
  actConfig.Caption := resMenuConfig;
  actAbout.Caption := resMenuAbout;
  actClose.Caption := resMenuClose;

  //配置Hint
  btnShortCut.Hint := resBtnShortCutHint;
  btnConfig.Hint := resBtnConfigHint;
  btnClose.Hint := resBtnFakeCloseHint;
  edtShortCut.Hint := resEdtShortCutHint;

  //先删除后增加，目的是防止有人放到别的目录运行，导致出现多个启动项
  SetAutoRun(TITLE, Application.ExeName, False);
  SetAutoRunInStartUp(TITLE, Application.ExeName, False);

  //如果是第一次使用，提示是否添加到自动启动
  if IsRunFirstTime then
    AutoRun := (Application.MessageBox(PChar(resAutoRunWhenStart),
      PChar(resInfo), MB_YESNO + MB_ICONQUESTION + MB_TOPMOST) = IDYES);

  //SetAutoRun(TITLE, Application.ExeName, AutoRun);
  SetAutoRunInStartUp(TITLE, Application.ExeName, AutoRun);

  AddMeToSendTo(TITLE, False);

  //如果是第一次使用，提示是否添加到发送到
  if IsRunFirstTime then
    AddToSendTo := (Application.MessageBox(PChar(resAddToSendToMenu),
      PChar(resInfo), MB_YESNO + MB_ICONQUESTION + MB_TOPMOST) = IDYES);

  //添加到发送到
  AddMeToSendTo(TITLE, AddToSendTo);

  //保存设置
  HandleID := Self.Handle;
  SaveSettings;

  //如果是第一次使用，重启一次以保证右键发送到不受影响
  if IsRunFirstTime then
  begin
    RestartMe;
    Exit;
  end;

  //第一次显示
  m_IsFirstShow := True;

  //第一次双击图标
  m_IsFirstDblClickIcon := True;

  //显示图标
  ntfMain.IconVisible := ShowTrayIcon;

  //显示按钮
  btnShortCut.Visible := ShowShortCutButton;
  btnConfig.Visible := ShowConfigButton;
  btnClose.Visible := ShowCloseButton;

  //提示
  if ShowStartNotification then
    ntfMain.ShowBalloonHint(resInfo,
      Format(resStarted + #13#10 + resPressKeyToShowMe,
      [TITLE, ALTRUN_VERSION, GetHotKeyString]), bitInfo, 5);

  //浮动提示
  ntfMain.Hint := Format(resMainHint, [TITLE, ALTRUN_VERSION, #13#10, GetHotKeyString]);

  //需要刷新
  m_NeedRefresh := True;

  if ShowMeWhenStart then actShowExecute(Sender);
end;

procedure TALTRunForm.FormDestroy(Sender: TObject);
begin
  //ShortCutMan.SaveShortCutList;

  //如果是右键添加启动的程序，保存文件时，不改变修改时间
  //这样正常运行的主程序不需要
  //if m_IsExited then FileSetDate(ShortCutMan.ShortCutFileName, m_AgeOfFile);
  
  ShortCutMan.Free;
end;

procedure TALTRunForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  TraceMsg('FormKeyDown( #%d = %s )', [Key, Chr(Key)]);

  //取得最近一次击键时间
  m_LastActiveTime := GetTickCount;

  //关闭tmrFocus
  tmrFocus.Enabled := False;

  //重起Timer
  RestartHideTimer(HideDelay);

  //如果命令行获得焦点，就什么也不管
  if edtCommandLine.Focused then Exit;

  case Key of
    VK_UP:
      with lstShortCut do
      begin
        //为了防止向上键导致光标位置移动，故吞掉之
        Key := VK_NONAME;

        if Count = 0 then Exit;

        //列表上下走
        if ItemIndex = -1 then
          ItemIndex := Count - 1
        else
          if ItemIndex = 0 then
            ItemIndex := Count - 1
          else
            ItemIndex := ItemIndex - 1;

        DisplayShortCutItem(TShortCutItem(Items.Objects[ItemIndex]));
        m_LastShortCutCmdIndex := ItemIndex;
      end;

    VK_DOWN:
      with lstShortCut do
      begin
        //为了防止向下键导致光标位置移动，故吞掉之
        Key := VK_NONAME;

        if Count = 0 then Exit;

        //列表上下走
        if ItemIndex = -1 then
          ItemIndex := 0
        else
          if ItemIndex = Count - 1 then
            ItemIndex := 0
          else
            ItemIndex := ItemIndex + 1;

        DisplayShortCutItem(TShortCutItem(Items.Objects[ItemIndex]));
        m_LastShortCutCmdIndex := ItemIndex;
      end;

    VK_F1:
      begin
        Key := VK_NONAME;
        actAboutExecute(Sender);
      end;

    VK_F2:
      begin
        Key := VK_NONAME;
        actEditItemExecute(Sender);
      end;

    VK_INSERT:
      begin
        Key := VK_NONAME;
        actAddItemExecute(Sender);
      end;

    VK_DELETE:
      begin
        if lstShortCut.ItemIndex >= 0 then
        begin
          Key := VK_NONAME;
          actDeleteItemExecute(Sender);
        end;
      end;

    VK_ESCAPE:
      begin
        Key := VK_NONAME;

        //如果不为空，就清空，否则隐藏
        if edtShortCut.Text = '' then
          evtMainMinimize(Self)
        else
          edtShortCut.Text := '';
      end;

    {分别对actConfig和actShortCut分配了快捷键
    //ALT+C，显示配置窗口
    $43:
      begin
        if (ssAlt in Shift) then actConfigExecute(Sender);
      end;

    //ALT+S，显示快捷键列表
    $53:
      begin
        if (ssAlt in Shift) then actShortCutExecute(Sender);
      end;
    }
  else
    begin
      if m_IsShow then
        try
          edtShortCut.SetFocus;
        except
          TraceMsg('edtShortCut.SetFocus failed');
        end;
    end;
  end;
end;

procedure TALTRunForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  TraceMsg('FormKeyPress(%s)', [Key]);

  //关闭tmrFocus
  tmrFocus.Enabled := False;
  
  case Key of
    //如果回车，就执行程序
    #13:
      begin
        Key := #0;
        if Self.Visible then actExecuteExecute(Sender);
      end;

    //如果ESC，就吞掉
    #27:
      begin
        Key := #0;
      end;
  end;
end;

function TALTRunForm.GetHotKeyString: string;
begin
  if (HotKeyStr2 = '') or (HotKeyStr2 = resVoidHotKey) then
    Result := HotKeyStr1
  else
    Result := Format('%s %s %s', [HotKeyStr1, resWordOr, HotKeyStr2]);
end;

function TALTRunForm.GetLangList(List: TStringList): Boolean;
var
  i: Cardinal;
  FileList: TStringList;
begin
  TraceMsg('GetLangList()');

  Result := False;

  try
    FileList := TStringList.Create;
    List.Clear;

    if GetFileListInDir(FileList, ExtractFileDir(Application.ExeName), 'lang', False) then
    begin
      if FileList.Count > 0 then
        for i := 0 to FileList.Count - 1 do
          List.Add(Copy(FileList.Strings[i], 1, Length(FileList.Strings[i]) - 5));

      Result := True;
    end
    else
      Result := False;
  finally
    FileList.Free;
  end;
end;

procedure TALTRunForm.GetLastCmdList;
var
  i, n: Cardinal;
  ShortCutItem: TShortCutItem;
begin
  TraceMsg('GetLastCmdList()');

  m_LastShortCutListCount := 0;
  m_LastShortCutCmdIndex := -1;

  if lstShortCut.Count > 0 then
  begin
    m_LastShortCutCmdIndex := lstShortCut.ItemIndex;

    if lstShortCut.Count > 10 then
      n := 10
    else
      n := lstShortCut.Count;

    for i := 0 to n - 1 do
    begin
      if lstShortCut.Items.Objects[i] <> nil then
      begin
        m_LastShortCutPointerList[m_LastShortCutListCount] := Pointer(lstShortCut.Items.Objects[i]);
        Inc(m_LastShortCutListCount);
      end;
    end;
  end;
end;

procedure TALTRunForm.hkmHotkey3HotKeyPressed(HotKey: Cardinal; Index: Word);
var
  Buf: array[0..254] of Char;
  StringList: TStringList;
begin
  TraceMsg('hkmHotkey3HotKeyPressed(%d)', [HotKey]);

  // 取得当前剪贴板中的文字
  ShortCutMan.Param[0] := Clipboard.AsUnicodeText;

  // 取得当前前台窗体ID及标题
  ShortCutMan.Param[1] := IntToStr(GetForegroundWindow);
  GetWindowText(GetForegroundWindow, Buf, 255);
  if Buf <> '' then ShortCutMan.Param[2] := Buf;
  GetClassName(GetForegroundWindow, Buf, 255);
  if Buf <> '' then ShortCutMan.Param[3] := Buf;

  TraceMsg('WinID = %s, WinCaption = %s, Class = %s',
    [ShortCutMan.Param[1], ShortCutMan.Param[2], ShortCutMan.Param[3]]);

  // 取得最近一次的项目
  try
    StringList := TStringList.Create;
    ShortCutMan.GetLatestShortCutItemList(StringList);
    if StringList.Count > 0 then
      ShortCutMan.Execute(TShortCutItem(StringList.Objects[0]));
  finally
    StringList.Free;
  end;
end;

procedure TALTRunForm.hkmHotkeyHotKeyPressed(HotKey: Cardinal; Index: Word);
var
  Buf: array[0..254] of Char;
begin
  TraceMsg('hkmMainHotKeyPressed(%d)', [HotKey]);

  if DEBUG_SORT then
  begin
    actShortCutExecute(Self);
    Exit;
  end;

  // 取得当前剪贴板中的文字
  ShortCutMan.Param[0] := Clipboard.AsUnicodeText;

  // 取得当前前台窗体ID, 标题, Class
  ShortCutMan.Param[1] := IntToStr(GetForegroundWindow);
  GetWindowText(GetForegroundWindow, Buf, 255);
  if Buf <> '' then ShortCutMan.Param[2] := Buf;
  GetClassName(GetForegroundWindow, Buf, 255);
  if Buf <> '' then ShortCutMan.Param[3] := Buf;

  TraceMsg('WinID = %s, WinCaption = %s, Class = %s',
    [ShortCutMan.Param[1], ShortCutMan.Param[2], ShortCutMan.Param[3]]);

  if m_IsShow then
    actHideExecute(Self)
  else
    actShowExecute(Self);
end;

procedure TALTRunForm.imgBackgroundMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    ReleaseCapture;
    SendMessage(Handle, WM_SYSCOMMAND, SC_DRAGMOVE, 0);
  end
  else if Button = mbMiddle then
  begin
    actExecuteExecute(Sender);
  end;
end;

procedure TALTRunForm.lblShortCutMouseActivate(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y, HitTest: Integer;
  var MouseActivate: TMouseActivate);
begin
  TraceMsg('lblShortCutMouseActivate()');

  RestartHideTimer(HideDelay);
end;

procedure TALTRunForm.lblShortCutMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    ReleaseCapture;
    SendMessage(Handle, WM_SYSCOMMAND, SC_DRAGMOVE, 0);
  end
  else if Button = mbMiddle then
  begin
    actExecuteExecute(Sender);
  end;
end;

procedure TALTRunForm.lstShortCutKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  TraceMsg('lstShortCutKeyDown( #%d = %s )', [Key, Chr(Key)]);

  //关闭tmrFocus
  tmrFocus.Enabled := False;
  
  case Key of
    //    VK_F2:
    //      actEditItemExecute(Sender);
    //
    //    VK_INSERT:
    //      actAddItemExecute(Sender);
    //
    //    VK_DELETE:
    //      actDeleteItemExecute(Sender);

    //回车
    13: ;

    VK_PRIOR, VK_NEXT: ;
  else
    if m_IsShow then
    begin
      //传到这里的键，都转发给edtShortCut
      PostMessage(edtShortCut.Handle, WM_KEYDOWN, Key, 0);

      try
        edtShortCut.SetFocus;
      except
        TraceMsg('edtShortCut.SetFocus failed');
      end;
    end;
  end;
end;

procedure TALTRunForm.lstShortCutMouseActivate(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y, HitTest: Integer;
  var MouseActivate: TMouseActivate);
begin
  TraceMsg('lstShortCutMouseActivate()');

  RestartHideTimer(HideDelay);
end;

procedure TALTRunForm.lstShortCutMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  TraceMsg('lstShortCutMouseDown()');

  //右键点击，就选中该项
  if Button = mbRight then
  begin
    lstShortCut.Perform(WM_LBUTTONDOWN, MK_LBUTTON, (y shl 16) + x);
    actSelectChangeExecute(Sender);
  end
  else if Button = mbMiddle then
  begin
    //lstShortCut.Perform(WM_LBUTTONDOWN, 0, (y shl 16) + x);
    actExecuteExecute(Sender);
  end;
end;

procedure TALTRunForm.ntfMainDblClick(Sender: TObject);
var
  AutoHideForm: TAutoHideForm;
begin
  TraceMsg('ntfMainDblClick()');

  if m_IsFirstDblClickIcon then
  begin
    m_IsFirstDblClickIcon := False;

    //对话框没法消失，不优秀，换成自动消失的
    //Application.MessageBox(
    //  PChar(Format(resShowMeByHotKey, [HotKeyStr])),
    //  PChar(resInfo), MB_OK + MB_ICONINFORMATION + MB_TOPMOST);

    try
      AutoHideForm := TAutoHideForm.Create(Self);
      AutoHideForm.Caption := resInfo;
      AutoHideForm.Info := Format(resShowMeByHotKey, [HotKeyStr1]);
      AutoHideForm.Info := Format(resShowMeByHotKey, [GetHotKeyString]);
      AutoHideForm.ShowModal;
    finally
      AutoHideForm.Free;
    end;
  end;

  if m_IsShow then
    actHideExecute(Self)
  else
    actShowExecute(Self);
end;

procedure TALTRunForm.pmListPopup(Sender: TObject);
begin
  mniOpenDir.Visible := DirAvailable;
  mniN1.Visible := mniOpenDir.Visible
end;

procedure TALTRunForm.RefreshOperationHint;
var
  HintIndex: Integer;
begin
  TraceMsg('RefreshOperationHint()');

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

procedure TALTRunForm.RestartMe;
begin
  TraceMsg('RestartMe()');

  ShellExecute(0, nil, PChar(Application.ExeName), RESTART_FLAG, nil, SW_SHOWNORMAL);
  actCloseExecute(Self);
end;

procedure TALTRunForm.RestartHideTimer(Delay: Integer);
begin
  TraceMsg('RestartHideTimer()');

  if m_IsShow then
  begin
    tmrHide.Enabled := False;
    tmrHide.Interval := Delay * 1000;
    tmrHide.Enabled := True;
  end;
end;

procedure TALTRunForm.ShowLatestShortCutList;
var
  StringList: TStringList;
begin
  TraceMsg('ShowLatestShortCutList');

  lblShortCut.Caption := '';
  lblShortCut.Hint := '';
  lstShortCut.Hint := '';
  edtCommandLine.Text := '';

  lstShortCut.Clear;

  try
    StringList := TStringList.Create;
    ShortCutMan.GetLatestShortCutItemList(StringList);
    lstShortCut.Items.Assign(StringList);
    m_NeedRefresh := True;
  finally
    StringList.Free;
  end;

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

  //如果可以打开文件夹，标记下
  if DirAvailable then lblShortCut.Caption := '[' + lblShortCut.Caption + ']';

  //更新最近的命令列表
  GetLastCmdList;
  
  //刷新提示
  RefreshOperationHint;
end;

procedure TALTRunForm.StopTimer;
begin
  TraceMsg('StopTimer()');

  tmrHide.Enabled := False;
  tmrFocus.Enabled := False;
end;

procedure TALTRunForm.tmrCopyTimer(Sender: TObject);
begin
  tmrCopy.Enabled := False;
  edtCopy.Hide;
end;

procedure TALTRunForm.tmrExitTimer(Sender: TObject);
begin
  TraceMsg('tmrExitTimer()');

  tmrExit.Enabled := False;
  actCloseExecute(Sender);
end;

procedure TALTRunForm.tmrFocusTimer(Sender: TObject);
var
  IsActivated: Boolean;
begin
  TraceMsg('tmrFocusTimer()');

  tmrFocus.Enabled := False;

  // 因为将窗体重新置于前台经常失败，故放弃这个Timer
  Exit;

  {
  // 如果窗体显示却没有获得焦点，则获得焦点
  if m_IsShow then
  begin
    try
      TraceMsg('Lost Focus, try again');

      SetForegroundWindow(Application.Handle);
      edtShortCut.SetFocus;
    except
      TraceMsg('edtShortCut.SetFocus failed');
      tmrFocus.Enabled := True;
    end;
  end;
  }
end;

procedure TALTRunForm.tmrHideTimer(Sender: TObject);
begin
  TraceMsg('tmrHideTimer()');

  evtMainMinimize(Sender);
  edtShortCut.Text := '';
end;

procedure TALTRunForm.WndProc(var Msg: TMessage);
var
  FileName: string;
begin
  case msg.Msg of
    WM_ALTRUN_ADD_SHORTCUT:
      begin
        TraceMsg('WM_ALTRUN_ADD_SHORTCUT');

        //ShortCutMan.AddFileShortCut(PChar(msg.WParam)));
        //ShortCutMan.SaveShortCutList;
        //ShowMessage('WM_ALTRUN_ADD_SHORTCUT');
      end;

    WM_ALTRUN_SHOW_WINDOW:
      begin
        TraceMsg('WM_ALTRUN_SHOW_WINDOW');

        actShowExecute(Self);
        SetForegroundWindow(Application.Handle);
      end;

    WM_SETTEXT:
      begin
        //Msg.WParam = 1 表示是自己程序发过来的
        if Msg.WParam = 1 then
        begin
          FileName := StrPas(PChar(msg.LParam));
          TraceMsg('Received FileName = %s', [FileName]);

          ShortCutMan.AddFileShortCut(FileName);
        end;
      end;

    WM_SETTINGCHANGE:
    begin
      // 用户环境变量发生变化，故强行再次读取，然后设置以生效

      // When the system sends this message as a result of a change in locale settings, this parameter is zero.
      // To effect a change in the environment variables for the system or the user,
      // broadcast this message with lParam set to the string "Environment".
      if (Msg.WParam = 0) and ((PChar(Msg.LParam)) = 'Environment') then
      begin
        // 根据注册表内容，强行刷新自身的环境变量
        RefreshEnvironmentVars;
      end;

      inherited;
    end;  

  else
    //TraceMsg('msg.Msg = %d, msg.LParam = %d, ms.WParam = %d', [msg.Msg, msg.LParam, msg.WParam]);
    inherited;
  end;
end;

end.

