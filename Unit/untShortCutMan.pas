unit untShortCutMan;

interface
uses
  Windows,
  Dialogs,
  SysUtils,
  Classes,
  Forms,
  Contnrs,
  ComCtrls,
  ShellAPI,
  RegExpr,
  Controls,
  frmParam,
  untClipboard,
  untUtilities,
  untALTRunOption,
  untLogger;

const
  SHORTCUT_FILENAME = 'ShortCutList.txt';
  FAVOURIT_FILENAME = 'FavoriteList.txt';

  PARAM_DELIMITER = '/\';

  MAX_LATEST_NUM = 10;
type
  //快捷项类型
  TShortCutType = (scOther, scItem, scBlank, scRemark);

  //参数类型
  TParamType = (ptNone, ptNoEncoding, ptURLQuery, ptUTF8Query);

  //快捷项图标
  TShortCutIcon = (siItem, siInfo);

  TCmdObject = class
  public
    Command: string;
    WorkingDir: string;
    Param: string;
    ParamType: TParamType;
  end;

  //快捷项
  TShortCutItem = class
  public
    ShortCutType: TShortCutType;
    ParamType: TParamType;
    ShortCut: string;
      Name: string;
    CommandLine: string;
    Rank: Integer;
    Freq: Integer;
  end;

  //快捷项列表
  TShortCutList = TObjectList;

  //快捷项管理器
  TShortCutMan = class
  private
    m_WriteDefaultShortCutList: Boolean;
    m_ShortCutFileName: string;
    m_FavoriteListFileName: string;
    m_FileModifyTime: string;
    m_ShortCutList: TShortCutList;
    m_SortedShortCutList: TStringList;
    m_FavoriteList: TStringList;
    m_LatestList: TStringList;
    m_Regex: TRegExpr;
    m_NeedRefresh: Boolean;
    m_Param: array[0..5] of string;
    function GetParam(Index: Integer): string;
    procedure SetParam(Index: Integer; const Value: string);

  public
    property WriteDefaultShortCutList: Boolean read m_WriteDefaultShortCutList write m_WriteDefaultShortCutList;
    property ShortCutFileName: string read m_ShortCutFileName write m_ShortCutFileName;
    property ShortCutList: TShortCutList read m_ShortCutList write m_ShortCutList;
    property NeedRefresh: Boolean read m_NeedRefresh write m_NeedRefresh;
    property Param[Index: Integer]: string read GetParam write SetParam;

    constructor Create;
    destructor Destroy; override;

    function LoadShortCutList(FileName: string = ''): Boolean;
    function SaveShortCutList(FileName: string = ''): Boolean;
    procedure CloneShortCutList(SrcList: TShortCutList; var NewList: TShortCutList);
    procedure FillListView(lvw: TListView);
    procedure LoadFromListView(lvw: TListView);

    function LoadFavoriteList: Boolean;
    function SaveFavoriteList: Boolean;

    function AddLatestShortCutItem(ShortCutItem: TShortCutItem):Boolean;
    function GetLatestShortCutItemList(var StringList: TStringList): Boolean;
    function GetLatestShortCutIndexList:string;
    function SetLatestShortCutIndexList(IndexList: string): Boolean;
    function LoadLatestList: Boolean;
    function SaveLatestList: Boolean;

    function ParamTypeToString(ParamType: TParamType): string;
    function StringToParamType(str: string; var ParamType: TParamType): Boolean;
    function ShortCutItemToString(ShortCutType: TShortCutType; ParamType: TParamType = ptNone;
      ShortCut: string = ''; Name: string = ''; CommandLine: string = ''; Freq: Integer = 0): string; overload;
    function ShortCutItemToString(ShortCutItem: TShortCutItem): string; overload;
    function StringToShortCutItem(str: string; var ShortCutItem: TShortCutItem): Boolean;

    procedure CloneShortCutItem(ShortCutItem: TShortCutItem; var NewItem: TShortCutItem);
    procedure AppendShortCutItem(ShortCutType: TShortCutType; ShortCut, Name, CommandLine: string); overload;
    procedure AppendShortCutItem(ShortCutItem: TShortCutItem); overload;
    procedure ModifyShortCutItem(ShortCutType: TShortCutType; ShortCut, Name, CommandLine: string; Index: Integer); overload;
    procedure ModifyShortCutItem(ShortCutItem: TShortCutItem; Index: Integer); overload;
    function ContainShortCutItem(ShortCutType: TShortCutType;
      ParamType: TParamType; ShortCut, Name, CommandLine: string): Boolean; overload;
    function ContainShortCutItem(ShortCutItem: TShortCutItem): Boolean; overload;
    function InsertShortCutItem(ShortCutType: TShortCutType;
      ParamType: TParamType; ShortCut, Name, CommandLine: string; Index: Integer): Boolean; overload;
    function InsertShortCutItem(ShortCutItem: TShortCutItem; Index: Integer): Boolean; overload;
    function DeleteShortCutItem(Index: Integer): Boolean; overload;
    function GetShortCutItemIndex(ShortCutItem: TShortCutItem): Integer;
    function GetShortCutItemByShortCut(ShortCut: string; var ShortCutItem: TShortCutItem): Boolean;

    function FilterKeyWord(KeyWord: string; var StringList: TStringList): Boolean;

    //Sort
    function SelectPivot(p, r: Integer): Integer; overload;
    function Partition(var StringList: TStringList; p, r: Integer): Integer; overload;
    procedure QuickSort(var StringList: TStringList; p, r: integer); overload;
    procedure BubbleSort(var StringList: TStringList; p, r: integer); overload;
    function Partition(var StringList: TObjectList; p, r: Integer): Integer; overload;
    procedure QuickSort(var StringList: TObjectList; p, r: integer); overload;
    procedure BubbleSort(var StringList: TObjectList; p, r: integer); overload;

    procedure Sort;

    //Execute
    function Execute(ShortCutItem: TShortCutItem): Boolean; overload;
    function Execute(cmdobj: TCmdObject): Boolean; overload;
    function Execute(ShortCutItem: TShortCutItem; KeyWord: string): Boolean; overload;

    function AddFileShortCut(FileName: string): Boolean;
    function ExtractShortCutItemFromFileName(var ShortCutItem: TShortCutItem; FileName: string): Boolean;
    function ReplaceEnvStr(str: string): string;
    function Test: Boolean;
    procedure PrintStringList(Title: string; StringList: TStringList; p, q: Integer); overload;
    procedure PrintStringList(Title: string; StringList: TObjectList; p, q: Integer); overload;
  end;

var
  ShortCutMan: TShortCutMan;

implementation
uses
  frmShortCut;

function ExecuteCmd(cmd: Pointer): LongInt; stdcall;
var
  PCommandStr, PParamStr, PWorkingDir: PChar;
  cmdobj: TCmdObject;
  Regex: TRegExpr;
  strCommand, strTemp: string;
  ret: Integer;
  ShowCmd: Integer;
begin
  cmdobj := TCmdObject(cmd);

  ShowCmd := SW_SHOWNORMAL;
  if Pos(SHOW_MAX_FLAG, cmdobj.Command) = 1 then
  begin
    cmdobj.Command := Trim(CutLeftString(cmdobj.Command, Length(SHOW_MAX_FLAG)));
    ShowCmd := SW_SHOWMAXIMIZED;
  end
  else if Pos(SHOW_MIN_FLAG, cmdobj.Command) = 1 then
  begin
    cmdobj.Command := Trim(CutLeftString(cmdobj.Command, Length(SHOW_MIN_FLAG)));
    ShowCmd := SW_SHOWMINIMIZED;
  end
  else if Pos(SHOW_HIDE_FLAG, cmdobj.Command) = 1 then
  begin
    cmdobj.Command := Trim(CutLeftString(cmdobj.Command, Length(SHOW_HIDE_FLAG)));
    ShowCmd := SW_HIDE
  end;

  //处理相对路径 ".\", "..\"，如果有，就将本程序的路径代入
  if (Pos('.\', cmdobj.Command) > 0) or (Pos('..\', cmdobj.Command) > 0) then
    cmdobj.WorkingDir := ExtractFileDir(Application.ExeName);

  case cmdobj.ParamType of
    ptNone:
      begin
        PCommandStr := PChar(cmdobj.Command);
        PParamStr := nil;
        PWorkingDir := PChar(cmdobj.WorkingDir);
      end;

    ptNoEncoding:
      begin
        //如果命令行有参数标志，则替换参数
        if Pos(NEW_PARAM_FLAG, cmdobj.Command) > 0 then
        begin
          try
            Regex := TRegExpr.Create;
            Regex.Expression := NEW_PARAM_FLAG;
            cmdobj.Command := Regex.Replace(cmdobj.Command, cmdobj.Param, False);
          finally
            Regex.Free;
          end;

          PCommandStr := PChar(cmdobj.Command);
          PParamStr := nil;
        end
        else if Pos(PARAM_FLAG, cmdobj.Command) > 0 then
        begin
          try
            Regex := TRegExpr.Create;
            Regex.Expression := PARAM_FLAG;
            cmdobj.Command := Regex.Replace(cmdobj.Command, cmdobj.Param, False);
          finally
            Regex.Free;
          end;

          PCommandStr := PChar(cmdobj.Command);
          PParamStr := nil;
        end
        else if Pos(CLIPBOARD_FLAG, cmdobj.Command) > 0 then
        begin
          try
            Regex := TRegExpr.Create;
            Regex.Expression := CLIPBOARD_FLAG;
            cmdobj.Command := Regex.Replace(cmdobj.Command, cmdobj.Param, False);
          finally
            Regex.Free;
          end;

          PCommandStr := PChar(cmdobj.Command);
          PParamStr := nil;
        end
        else if Pos(FOREGROUND_WINDOW_ID_FLAG, cmdobj.Command) > 0 then
        begin
          try
            Regex := TRegExpr.Create;
            Regex.Expression := FOREGROUND_WINDOW_ID_FLAG;
            cmdobj.Command := Regex.Replace(cmdobj.Command, cmdobj.Param, False);
          finally
            Regex.Free;
          end;

          PCommandStr := PChar(cmdobj.Command);
          PParamStr := nil;
        end
        else if Pos(FOREGROUND_WINDOW_TEXT_FLAG, cmdobj.Command) > 0 then
        begin
          try
            Regex := TRegExpr.Create;
            Regex.Expression := FOREGROUND_WINDOW_TEXT_FLAG;
            cmdobj.Command := Regex.Replace(cmdobj.Command, cmdobj.Param, False);
          finally
            Regex.Free;
          end;

          PCommandStr := PChar(cmdobj.Command);
          PParamStr := nil;
        end
        else if Pos(FOREGROUND_WINDOW_CLASS_FLAG, cmdobj.Command) > 0 then
        begin
          try
            Regex := TRegExpr.Create;
            Regex.Expression := FOREGROUND_WINDOW_CLASS_FLAG;
            cmdobj.Command := Regex.Replace(cmdobj.Command, cmdobj.Param, False);
          finally
            Regex.Free;
          end;

          PCommandStr := PChar(cmdobj.Command);
          PParamStr := nil;
        end
        else
        begin
          PCommandStr := PChar(cmdobj.Command);
          PParamStr := PChar(cmdobj.Param);
        end;

        PWorkingDir := PChar(cmdobj.WorkingDir);
      end;

    ptURLQuery, ptUTF8Query:
      begin
        //如果命令行有参数标志，则替换参数
        if Pos(NEW_PARAM_FLAG, cmdobj.Command) > 0 then
        begin
          try
            Regex := TRegExpr.Create;
            Regex.Expression := NEW_PARAM_FLAG;
            cmdobj.Command := Regex.Replace(cmdobj.Command, cmdobj.Param, False);
          finally
            Regex.Free;
          end;

          PCommandStr := PChar(cmdobj.Command);
        end
        else if Pos(PARAM_FLAG, cmdobj.Command) > 0 then
        begin
          try
            Regex := TRegExpr.Create;
            Regex.Expression := PARAM_FLAG;
            cmdobj.Command := Regex.Replace(cmdobj.Command, cmdobj.Param, False);
          finally
            Regex.Free;
          end;

          PCommandStr := PChar(cmdobj.Command);
        end
        else if Pos(CLIPBOARD_FLAG, cmdobj.Command) > 0 then
        begin
          try
            Regex := TRegExpr.Create;
            Regex.Expression := CLIPBOARD_FLAG;
            cmdobj.Command := Regex.Replace(cmdobj.Command, cmdobj.Param, False);
          finally
            Regex.Free;
          end;

          PCommandStr := PChar(cmdobj.Command);
        end
        else
        begin
          PCommandStr := PChar(cmdobj.Command + cmdobj.Param);
        end;

        PParamStr := nil;
        PWorkingDir := nil;
      end;
  end;

  //替换环境变量
  PCommandStr := PChar(ReplaceEnvStr(StrPas(PCommandStr)));

  ret := ShellExecute(GetDesktopWindow, nil, PCommandStr, PParamStr, PWorkingDir, ShowCmd);
  if ret < 33 then
  begin
    TraceMsg('ShellExecute(%s, %s, %s) Failed',
      [StrPas(PCommandStr), StrPas(PParamStr), StrPas(PWorkingDir)]);

    ret := WinExec(PCommandStr, ShowCmd);
    if ret < 33 then
    begin
      TraceMsg('WinExec(%s) Failed', [StrPas(PCommandStr)]);

      Application.MessageBox(PChar(Format(resCanNotExecute, [StrPas(PCommandStr),
        StrPas(PParamStr)])), PChar(resWarning), MB_OK + MB_ICONWARNING);
    end;
  end;

  //释放对象；
  cmdobj.Free;
end;

{ TShortCutMan }

procedure TShortCutMan.AppendShortCutItem(ShortCutType: TShortCutType;
  ShortCut, Name, CommandLine: string);
var
  Item: TShortCutItem;
begin
  Item := TShortCutItem.Create;
  Item.ShortCutType := ShortCutType;
  Item.ShortCut := ShortCut;
  Item.Name := Name;
  Item.CommandLine := CommandLine;

  m_ShortCutList.Add(Item);
end;

function TShortCutMan.AddFileShortCut(FileName: string): Boolean;
var
  ShortCutForm: TShortCutForm;
  Item: TShortCutItem;
  ExistItem: TShortCutItem;
  TempFileName: string;
begin
  TraceMsg('AddFileShortCut(%s)', [FileName]);

  Result := False;

  Item := TShortCutItem.Create;
  ShortCutForm := TShortCutForm.Create(nil);

  try
    with ShortCutForm do
    begin
      if not ExtractShortCutItemFromFileName(Item, FileName) then
      begin
        Application.MessageBox(PChar(resGetFileNameFail), PChar(resInfo),
          MB_OK + MB_ICONINFORMATION + MB_TOPMOST);

        Item.Free;
        Exit;
      end;

      lbledtShortCut.Text := Item.ShortCut;
      lbledtName.Text := Item.Name;
      lbledtCommandLine.Text := Trim(Item.CommandLine);
      rgParam.ItemIndex := 0;

      ShowModal;

      if ModalResult = mrCancel then
      begin
        Item.Free;
        Exit;
      end;

      if (Trim(lbledtShortCut.Text) <> '') and (Trim(lbledtCommandLine.Text) <> '') then
      begin
        Item.ShortCutType := scItem;
        Item.ParamType := TParamType(rgParam.ItemIndex);
        Item.ShortCut := lbledtShortCut.Text;
        Item.Name := lbledtName.Text;
        Item.CommandLine := Trim(lbledtCommandLine.Text);
      end
      else
      begin
        Application.MessageBox(PChar(resBlankLineAdded), PChar(resInfo),
          MB_OK + MB_ICONINFORMATION + MB_TOPMOST);

        Item.ShortCutType := scBlank;
        Item.ParamType := ptNone;
        Item.ShortCut := '';
        Item.Name := '';
        Item.CommandLine := '';
      end;

      //相对路径建议
      if Pos(LowerCase(ExtractFileDir(Application.ExeName)), LowerCase(Item.CommandLine)) > 0 then
      begin
        if Application.MessageBox(PChar(resRelativePathSuggestion), PChar(resInfo),
          MB_OKCANCEL + MB_ICONQUESTION + MB_TOPMOST) = IDOK then
        begin
          Item.CommandLine := StringReplace(Item.CommandLine, ExtractFileDir(Application.ExeName), '.', [rfReplaceAll, rfIgnoreCase]);
        end;
      end;

      //若有重复，则报错
      {if ContainShortCutItem(Item) then
      begin
        Application.MessageBox(PChar(resShortCutExisted), PChar(resInfo),
          MB_OK + MB_ICONINFORMATION + MB_TOPMOST);

        //如果不释放Item，就会内存泄露
        Item.Free;
        Exit;
      end;}

      //如有ShortCut相同(或者Name相同)，则提示是否替换原有的
      if (Item.ShortCutType = scItem) and GetShortCutItemByShortCut(Item.ShortCut, ExistItem) then
      begin
        if Application.MessageBox(PChar(Format(resShortCutExisted,
          [ExistItem.ShortCut, ExistItem.Name, ExistItem.CommandLine])),
          PChar(resInfo), MB_YESNO + MB_ICONINFORMATION + MB_TOPMOST) = IDYES then
        begin
          CloneShortCutItem(Item, ExistItem);
          Item.Free;
          SaveShortCutList;
          LoadShortCutList(m_ShortCutFileName);
          Exit;
        end
        else
        begin
          Item.Free;
          Exit;
        end;
      end;

      //如果Append此项，就不用Free此Item
      AppendShortCutItem(Item);
      SaveShortCutList;
      LoadShortCutList(m_ShortCutFileName);

      Result := True;
    end;
  finally
    ShortCutForm.Free;
  end;
end;

function TShortCutMan.AddLatestShortCutItem(ShortCutItem: TShortCutItem): Boolean;
var
  ItemIndex: Integer;
  ShortCutItemIndex: Integer;
begin
  ItemIndex := m_LatestList.IndexOfObject(ShortCutItem);

  //如果此项已经在最近列表中，则移到第一项
  if ItemIndex >= 0 then
    m_LatestList.Move(ItemIndex, 0)
  else
  begin
    //如果当前列表已经超过最大项，则删除最后一个
    if m_LatestList.Count >= MAX_LATEST_NUM then m_LatestList.Delete(MAX_LATEST_NUM - 1);

    m_LatestList.InsertObject(0, ShortCutItem.Name, ShortCutItem);
  end;
end;

procedure TShortCutMan.AppendShortCutItem(ShortCutItem: TShortCutItem);
begin
  m_ShortCutList.Add(ShortCutItem);
end;

procedure TShortCutMan.BubbleSort(var StringList: TObjectList; p, r: integer);
var
  i, j: Integer;
  v: Integer;
  Flag: Boolean;
begin
  PrintStringList(Format('Before BubbleSort(%d, %d)', [p, r]), StringList, p, r);

  if (r - p) < 1 then Exit;

  if (r - p) = 1 then
    if TShortCutItem(StringList.Items[p]).Rank < TShortCutItem(StringList.Items[r]).Rank then
      StringList.Exchange(p, r);

  if (r - p) > 1 then
    for i := p to r - 1 do
    begin
      Flag := True;
      for j := r - 1 downto i do
        if TShortCutItem(StringList.Items[j + 1]).Rank > TShortCutItem(StringList.Items[j]).Rank then
        begin
          StringList.Exchange(j, j + 1);
          Flag := False;
        end;

      if Flag then Exit;
    end;

  PrintStringList(Format('After BubbleSort(%d, %d)', [p, r]), StringList, p, r);
end;

procedure TShortCutMan.CloneShortCutItem(ShortCutItem: TShortCutItem; var NewItem: TShortCutItem);
begin
  if ShortCutItem = nil then ShowMessage('Error NIL');

  NewItem.ShortCutType := ShortCutItem.ShortCutType;
  NewItem.ParamType := ShortCutItem.ParamType;
  NewItem.ShortCut := ShortCutItem.ShortCut;
  NewItem.Name := ShortCutItem.Name;
  NewItem.CommandLine := ShortCutItem.CommandLine;
end;

procedure TShortCutMan.CloneShortCutList(SrcList: TShortCutList; var NewList: TShortCutList);
var
  i: Cardinal;
begin
  NewList.Clear;
  if SrcList.Count = 0 then Exit;

  for i := 0 to SrcList.Count - 1 do
    NewList.Add(SrcList.Items[i]);
end;

function TShortCutMan.ContainShortCutItem(ShortCutItem: TShortCutItem): Boolean;
var
  i: Cardinal;
  Item: TShortCutItem;
begin
  Result := False;

  //列表为空，当然不存在
  if m_ShortCutList.Count = 0 then Exit;

  //只要不是快捷项类型，随便加
  if ShortCutItem.ShortCutType <> scItem then Exit;

  for i := 0 to m_ShortCutList.Count - 1 do
  begin
    Item := TShortCutItem(m_ShortCutList.Items[i]);

    //全都一样，就是包含了
    if (Item.ShortCutType = scItem) and
      (Item.ParamType = ShortCutItem.ParamType) and
      (Item.ShortCut = ShortCutItem.ShortCut) and
      (Item.Name = ShortCutItem.Name) and
      (Item.CommandLine = ShortCutItem.CommandLine) then
    begin
      Result := True;
      Exit;
    end;
  end;
end;

function TShortCutMan.ContainShortCutItem(ShortCutType: TShortCutType;
  ParamType: TParamType; ShortCut, Name, CommandLine: string): Boolean;
var
  ShortCutItem: TShortCutItem;
begin
  ShortCutItem.ShortCutType := ShortCutType;
  ShortCutItem.ShortCut := ShortCut;
  ShortCutItem.Name := Name;
  ShortCutItem.CommandLine := CommandLine;
  ShortCutItem.ParamType := ParamType;

  Result := ContainShortCutItem(ShortCutItem);
end;

constructor TShortCutMan.Create;
begin
  //初始化快捷项列表文件名
  m_ShortCutFileName := ExtractFilePath(Application.ExeName) + SHORTCUT_FILENAME;

  //如果快捷项列表文件不存在，写入之
  m_WriteDefaultShortCutList := True;

  //初始化文件修改时间
  m_FileModifyTime := '';

  //初始化列表，自动释放对象
  m_ShortCutList := TShortCutList.Create(True);

  m_SortedShortCutList := TStringList.Create;
  m_LatestList := TStringList.Create;

  //初始化爱好列表文件名
  m_FavoriteListFileName := ExtractFilePath(Application.ExeName) + FAVOURIT_FILENAME;
  m_FavoriteList := TStringList.Create;
  LoadFavoriteList;

  //正则表达式
  m_Regex := TRegExpr.Create;
end;

function TShortCutMan.DeleteShortCutItem(Index: Integer): Boolean;
var
  ItemIndex: Integer;
begin
  Result := False;

  if (Index < 0) or (Index >= m_ShortCutList.Count) then Exit;

  //如果最近列表中包含此项，则删除之
  ItemIndex := m_LatestList.IndexOfObject(m_ShortCutList.Items[Index]);
  if ItemIndex >= 0 then m_LatestList.Delete(ItemIndex);

  m_ShortCutList.Delete(Index);
  
  SaveShortCutList(m_ShortCutFileName);
  LoadShortCutList(m_ShortCutFileName);

  Result := True;
end;

destructor TShortCutMan.Destroy;
begin
  //备份 m_ShortCutFileName
  TraceMsg('Backup the ShortCutFileName file');

  if GetFileSize(m_ShortCutFileName) >0  then
    CopyFile(PChar(m_ShortCutFileName), PChar(m_ShortCutFileName + '.bak'), False);

  m_Regex.Free;
  m_ShortCutList.Free;
  m_SortedShortCutList.Free;
  m_LatestList.Free;

  SaveFavoriteList;
  m_FavoriteList.Free;
end;

function TShortCutMan.Execute(ShortCutItem: TShortCutItem): Boolean;
var
  str: string;
  cmdobj: TCmdObject;
  FlagPos: Integer;
  TrueCmdFile: string;
begin
  Result := False;

  if ShortCutItem.ShortCutType <> scItem then Exit;

  //注意: 这个对象不在这里释放，需要在线程里面释放！
  cmdobj := TCmdObject.Create;

  //先初始化清空
  cmdobj.Command := '';
  cmdobj.WorkingDir := '';
  cmdobj.Param := '';
  cmdobj.ParamType := ptNone;

  //赋值
  cmdobj.Command := ShortCutItem.CommandLine;

  //替换环境变量
  cmdobj.Command := ReplaceEnvStr(cmdobj.Command);

  //对于"..."这样的文件名，先剥去两端的""
  str := RemoveQuotationMark(Trim(ShortCutItem.CommandLine), '"');

  //对于"\\"开头的，不要去查找FileExist，否则很慢！
  if Pos('\\', str) <> 1 then
  begin
    if FileExists(str) then
      cmdobj.WorkingDir := ExtractFileDir(str)
    else
    begin
      //这种的也要正确处理
      //"C:\Program Files\Mozilla Firefox\firefox.exe" -Profile "Profiles"
      if str[1] = '"' then
      begin
        //先初始化为空白
        cmdobj.WorkingDir := '';

        // 去掉开头的"
        TrueCmdFile := Copy(str, 2, Length(str) - 1);

        FlagPos := Pos('"', TrueCmdFile);
        if FlagPos > 0 then
        begin
          //取得第一个"之前的内容
          TrueCmdFile := Copy(TrueCmdFile, 1, FlagPos - 1);

          if FileExists(TrueCmdFile) then
          begin
            cmdobj.Command := TrueCmdFile;
            cmdobj.WorkingDir := ExtractFileDir(TrueCmdFile);
            cmdobj.Param := Trim(Copy(str, FlagPos + 2, Length(str) - FlagPos - 1));
          end;

        end;
      end;
    end;
  end;

  if ShortCutItem.ParamType = ptNone then
  begin
    //cmdobj.Param := '';
    //cmdobj.ParamType := ptNone;

    if cmdobj.Param = '' then
      cmdobj.ParamType := ptNone
    else
      cmdobj.ParamType := ptNoEncoding;

    Result := Execute(cmdobj);
  end
  else
  begin
    if Pos(CLIPBOARD_FLAG, cmdobj.Command) > 0 then               // 剪贴板
    begin
      cmdobj.Param := m_Param[0];
    end
    else
    if Pos(FOREGROUND_WINDOW_ID_FLAG, cmdobj.Command) > 0 then    // 前台窗口ID
    begin
      cmdobj.Param := m_Param[1];
    end
    else
    if Pos(FOREGROUND_WINDOW_TEXT_FLAG, cmdobj.Command) > 0 then  // 前台窗口Text
    begin
      cmdobj.Param := m_Param[2];
    end
    else
    if Pos(FOREGROUND_WINDOW_CLASS_FLAG, cmdobj.Command) > 0 then  // 前台窗口Class
    begin
      cmdobj.Param := m_Param[3];
    end
    else
    begin
      ParamForm.Caption := ShortCutItem.Name;
      if ParamForm <> nil then
        if ParamForm.ShowModal = mrCancel then
        begin
          cmdobj.Free;
          Exit;
        end;

      cmdobj.Param := ParamForm.cbbParam.Text;
    end;

    cmdobj.ParamType := ShortCutItem.ParamType;

    case ShortCutItem.ParamType of
      ptNoEncoding: ;

      ptURLQuery:
        cmdobj.Param := GetURLQueryString(cmdobj.Param);

      ptUTF8Query:
        cmdobj.Param := GetUTF8QueryString(cmdobj.Param);
    end;

    Result := Execute(cmdobj);
  end;
end;

function TShortCutMan.ExtractShortCutItemFromFileName(var ShortCutItem: TShortCutItem; FileName: string): Boolean;
var
  TempFileName: string;
begin
  Result := False;

  if Trim(FileName) = '' then
  begin
    with ShortCutItem do
    begin
      ShortCutType := scBlank;
      ParamType := ptNone;
      ShortCut := '';
      Name := '';
      CommandLine := '';
    end;
  end
  else
  begin
    //如果是LNK快捷方式文件，则提取里面的文件路径
    //要考虑到"....lnk"这种前后带有"的文件
    if (LowerCase(Copy(FileName, Length(FileName) - 3, 4)) = '.lnk') or
      ( (FileName[1] = '"') and
        (FileName[Length(FileName)] = '"') and
        (LowerCase(Copy(FileName, Length(FileName) - 4, 4)) = '.lnk'))
    then
    begin
      TempFileName := ResolveLink(FileName);

      //有的时候，快捷方式指向空，那就直接把这个快捷方式搞成快捷项
      //对于下面这种解出来的文件，其实没法直接调用，不如直接调用lnk文件
      //C:\WINDOWS\Installer\{90120000-0011-0000-0000-0000000FF1CE}\wordicon.exe
      if (Trim(TempFileName) <> '') and (Pos(GetEnvironmentVariable('windir') + '\Installer\{', TempFileName) <= 0) then
        FileName := TempFileName;
    end;

    with ShortCutItem do
    begin
      ShortCutType := scItem;
      ParamType := ptNone;
      CommandLine := FileName;
      if Pos('http://', LowerCase(FileName)) = 1 then
      begin
        FileName := Copy(FileName, 8, Length(FileName) - 7);
        if Pos('/', FileName) > 0 then
          ShortCut := Copy(FileName, 1, Pos('/', FileName) - 1)
        else
          ShortCut := FileName;
      end
      else
      begin
        FileName := ExtractFileName(FileName);

        //对于前后都是""的文件名或目录名，删掉最后的"
        if FileName[Length(FileName)] = '"' then
          FileName := Copy(FileName, 1, Length(FileName) - 1);

        //对于Chrome的快捷方式，如
        //"C:\Documents and Settings\cnh31515\Local Settings\Application Data\Google\Chrome\Application\chrome.exe"  --app=http://www.douban.com/group/topic/4876691/
        //ExtractFileName之后就是 '//www.douban.com/group/topic/4876691/'
        if (Pos('//', FileName) = 1) then
        begin
          //对于https://shit.com之类的网址，ExtractFileName之后就是'//shit.com'
          if (FileName[Length(FileName)] = '/') then
            ShortCut := Copy(FileName, 3, Length(FileName) - 3)
          else
            ShortCut := Copy(FileName, 3, Length(FileName) - 2);
        end
        else
        begin
          // 如果是文件夹，如文件夹叫做"1.2图片"，就不除去后面的"扩展名 (.2图片)"
          if DirectoryExists(RemoveQuotationMark(ShortCutItem.CommandLine, '"')) then
            ShortCut := FileName
          else
            ShortCut := Copy(FileName, 1, Length(FileName) - Length(ExtractFileExt(FileName)));
        end;
      end;

      Name := ShortCut;
    end;
  end;

  Result := True;
end;

procedure TShortCutMan.FillListView(lvw: TListView);
var
  i: Cardinal;
  ShortCutItem: TShortCutItem;
  lvwitm: TListItem;
begin
  lvw.Clear;
  if m_ShortCutList.Count = 0 then Exit;

  for i := 0 to m_ShortCutList.Count - 1 do
  begin
    ShortCutItem := TShortCutItem(m_ShortCutList.Items[i]);

    case ShortCutItem.ShortCutType of
      scItem:
        begin
          lvwitm := lvw.Items.Add;
          lvwitm.Caption := ShortCutItem.ShortCut;
          lvwitm.SubItems.Add(ShortCutItem.Name);
          lvwitm.SubItems.Add(ParamTypeToString(ShortCutItem.ParamType));
          lvwitm.SubItems.Add(ShortCutItem.CommandLine);
          lvwitm.Data := Pointer(ShortCutItem.Freq);
          lvwitm.ImageIndex := Ord(siItem);
        end;

      scBlank:
        begin
          lvwitm := lvw.Items.Add;
          lvwitm.Caption := '';
          lvwitm.SubItems.Add('');
          lvwitm.SubItems.Add('');
          lvwitm.SubItems.Add('');
          lvwitm.ImageIndex := Ord(siInfo);
        end;

      scRemark, scOther: ;
    else ;
    end;
  end;
end;

function TShortCutMan.FilterKeyWord(KeyWord: string; var StringList: TStringList): Boolean;
var
  i, j, k: Cardinal;
  Item: TShortCutItem;
  Rank, ExistRank: Integer;
  IsInserted: Boolean;
  CostTick: Cardinal;
begin
  Result := False;

  CostTick := GetTickCount;

  TraceMsg('FilterKeyWord(%s)',[KeyWord]);

  //清空结果列表
  StringList.Clear;

  //如果没有东西，退出
  if m_SortedShortCutList.Count = 0 then Exit;

  //如果KeyWord为' '，则退出
  if KeyWord = ' ' then Exit;

  //如果KeyWord为空，则按照使用频率显示全部内容，否则只显示过滤内容
  if KeyWord = '' then
    StringList.Assign(m_SortedShortCutList)
  else
  begin
    KeyWord := LowerCase(KeyWord);

    TraceMsg('FilterKeyWord - 10');

    //如果支持Regex，对KeyWord进行预处理，对单独的*都替换为.*, 对单独的?都替换为.?
    if EnableRegex then
    begin
      //----- 处理*
      //先把.*临时变为~！@#
      KeyWord := StringReplace(KeyWord, '.*', '~!@#', [rfReplaceAll]);

      //再把*都变为.*
      KeyWord := StringReplace(KeyWord, '*', '.*', [rfReplaceAll]);

      //最后把~!@#变回.*
      KeyWord := StringReplace(KeyWord, '~!@#', '.*', [rfReplaceAll]);

      //----- 处理?
      KeyWord := StringReplace(KeyWord, '?', '.', [rfReplaceAll]);

      //先把.?临时变为~！@#
      //KeyWord:=StringReplace(KeyWord,'.?','~!@#',[rfReplaceAll]);

      //再把?都变为.?
      //KeyWord:=StringReplace(KeyWord,'?','.?',[rfReplaceAll]);

      //最后把~!@#变回.?
      //KeyWord:=StringReplace(KeyWord,'~!@#','.?',[rfReplaceAll]);
    end;

    TraceMsg('FilterKeyWord - 20, m_SortedShortCutList.Count = %d', [m_SortedShortCutList.Count]);

    for i := 0 to m_SortedShortCutList.Count - 1 do
    begin
      Item := TShortCutItem(m_SortedShortCutList.Objects[i]);

      //不是快捷项，不理
      if Item.ShortCutType <> scItem then Continue;

      //如果长度太小，不理
      if Length(KeyWord) > Length(Item.ShortCut) then Continue;

      if EnableRegex then
      begin
        m_Regex.Expression := KeyWord;
        try
          if not m_Regex.Exec(LowerCase(Item.ShortCut)) then Continue;
        except
          on E: Exception do
            Result := False;
        end;

        //如果必须从头匹配
        if (not MatchAnywhere) and (m_Regex.MatchPos[0] > 1) then
          Continue
        else
          Item.Rank := m_Regex.MatchPos[0];
      end
      else
      begin
        Item.Rank := Pos(LowerCase(KeyWord), LowerCase(Item.ShortCut));

        //如果必须从头匹配
        if (not MatchAnywhere) and (Item.Rank > 1) then Continue;
      end;

      TraceMsg('FilterKeyWord - 30');

      if Item.Rank > 0 then
      begin
        //加权系数作为排列值
        //Item.Rank := Item.Rank * 10000 + (Length(Item.ShortCut) - Length(KeyWord));
        //Item.Rank := Item.Rank * 100 + (Length(Item.ShortCut) - Length(KeyWord)) * 2 - Item.Freq * 5;
        Item.Rank := 1024 + Item.Freq * 4 - Item.Rank * 128 - (Length(Item.ShortCut) - Length(KeyWord)) * 16;

        TraceMsg('FilterKeyWord - 40');

        StringList.AddObject(Format(ListFormat, [Item.ShortCut, Item.Name]), TObject(Item));
        //StringList.AddObject(Format('%s - %d/%d (%s)', [Item.ShortCut, Item.Rank, Item.Freq, Item.Name]), TObject(Item));

        TraceMsg('FilterKeyWord - 50');
      end;
    end;

    TraceMsg('FilterKeyWord - 60');

    //对StringList进行快速排序
    QuickSort(StringList, 0, StringList.Count - 1);
  end;

  TraceMsg('FilterKeyWord - 70');

  //如果KeyWord出现在FavoriteList内，且当前列表内也有它对应的名称，则将其移到第一项
  if RememberFavouratMatch then
    if StringList.Count > 0 then
      if m_FavoriteList.IndexOfName(KeyWord) >= 0 then
        for i := 0 to StringList.Count - 1 do
          if m_FavoriteList.Values[KeyWord] = TShortCutItem(StringList.Objects[i]).Name then
          begin
            StringList.Move(i, 0);
            Break;
          end;

  TraceMsg('FilterKeyWord - 80');

  if EnableNumberKey then
    if StringList.Count > 0 then
      for i := 0 to StringList.Count - 1 do
      begin
        if i < 10 then
        begin
          if IndexFrom0to9 then
          begin
            if TShortCutItem(StringList.Objects[i]).ParamType = ptNone then
              StringList.Strings[i] := Format(' %d|%s', [i, StringList.Strings[i]])
            else
              StringList.Strings[i] := Format('*%d|%s', [i, StringList.Strings[i]]);
          end
          else
          begin
            if TShortCutItem(StringList.Objects[i]).ParamType = ptNone then
              StringList.Strings[i] := Format(' %d|%s', [(i + 1) mod 10, StringList.Strings[i]])
            else
              StringList.Strings[i] := Format('*%d|%s', [(i + 1) mod 10, StringList.Strings[i]]);
          end;
        end
        else
          StringList.Strings[i] := Format('  |%s', [StringList.Strings[i]]);
      end;

  CostTick := GetTickCount - CostTick;
  TraceMsg('FilterKeyWord(%s) = %d', [KeyWord, CostTick]);

  TraceMsg('FilterKeyWord - Exit');

  Result := StringList.Count > 0;
end;

function TShortCutMan.GetLatestShortCutIndexList: string;
var
  i: Cardinal;
  Item: TShortCutItem;
begin
  Result := '';

  //如果没有东西，退出
  if m_LatestList.Count = 0 then Exit;

  //取出对应的快捷方式
  for i := 0 to m_LatestList.Count - 1 do
  begin
    if m_ShortCutList.IndexOf(m_LatestList.Objects[i]) < 0 then Continue;

    Result := Result + IntToStr(m_ShortCutList.IndexOf(m_LatestList.Objects[i]));

    if i < m_LatestList.Count - 1 then
      Result := Result + ', ';
  end;
end;

function TShortCutMan.GetLatestShortCutItemList(var StringList: TStringList): Boolean;
var
  i: Cardinal;
  Item: TShortCutItem;
begin
  Result := False;

  //清空结果列表
  StringList.Clear;

  //如果没有东西，退出
  if m_LatestList.Count = 0 then Exit;

  //取出对应的快捷方式
  for i := 0 to m_LatestList.Count - 1 do
  begin
    if m_LatestList.Objects[i] <> nil then
    begin
      try
        Item := TShortCutItem(m_LatestList.Objects[i]);
        StringList.AddObject(Format(ListFormat, [Item.ShortCut, Item.Name]), TObject(Item));
      except
        TraceErr('StringList.AddObject Error = %d',[i]);
      end;
    end;
  end;

  if EnableNumberKey and (StringList.Count > 0) then
    for i := 0 to StringList.Count - 1 do
    begin
      if i < 10 then
      begin
        if IndexFrom0to9 then
        begin
          if TShortCutItem(StringList.Objects[i]).ParamType = ptNone then
            StringList.Strings[i] := Format(' %d|%s', [i, StringList.Strings[i]])
          else
            StringList.Strings[i] := Format('*%d|%s', [i, StringList.Strings[i]]);
        end
        else
        begin
          if TShortCutItem(StringList.Objects[i]).ParamType = ptNone then
            StringList.Strings[i] := Format(' %d|%s', [(i + 1) mod 10, StringList.Strings[i]])
          else
            StringList.Strings[i] := Format('*%d|%s', [(i + 1) mod 10, StringList.Strings[i]]);
        end;
      end
      else
        StringList.Strings[i] := Format('  |%s', [StringList.Strings[i]]);
    end;
end;

function TShortCutMan.GetParam(Index: Integer): string;
begin
  Result := m_Param[Index];
end;

function TShortCutMan.GetShortCutItemByShortCut(ShortCut: string; var ShortCutItem: TShortCutItem): Boolean;
var
  i: Cardinal;
  Item: TShortCutItem;
begin
  Result := False;

  for i := 0 to m_ShortCutList.Count - 1 do
  begin
    ShortCutItem := TShortCutItem(m_ShortCutList.Items[i]);

    if (ShortCutItem.ShortCut = ShortCut) then
    begin
      Result := True;
      Exit;
    end;
  end;
end;

function TShortCutMan.GetShortCutItemIndex(ShortCutItem: TShortCutItem): Integer;
var
  i: Cardinal;
  Item: TShortCutItem;
begin
  Result := -1;

  for i := 0 to m_ShortCutList.Count - 1 do
  begin
    Item := TShortCutItem(m_ShortCutList.Items[i]);

    if (ShortCutItem.ShortCut = Item.ShortCut)
      and (ShortCutItem.Name = Item.Name)
      and (ShortCutItem.CommandLine = Item.CommandLine) then
    begin
      Result := i;
      Break;
    end;
  end;
end;

function TShortCutMan.InsertShortCutItem(ShortCutType: TShortCutType;
  ParamType: TParamType; ShortCut, Name, CommandLine: string; Index: Integer): Boolean;
var
  Item: TShortCutItem;
begin
  Result := False;

  if (Index < 0) or (Index >= m_ShortCutList.Count) then Exit;

  Item := TShortCutItem.Create;
  Item.ShortCutType := ShortCutType;
  Item.ShortCut := ShortCut;
  Item.Name := Name;
  Item.CommandLine := CommandLine;

  m_ShortCutList.Insert(Index, Item);

  Result := True;
end;

procedure TShortCutMan.BubbleSort(var StringList: TStringList; p, r: integer);
var
  i, j: Integer;
  v: Integer;
  Flag: Boolean;
begin
  PrintStringList(Format('Before BubbleSort(%d, %d)', [p, r]), StringList, p, r);

  if (r - p) < 1 then Exit;

  if (r - p) = 1 then
    if TShortCutItem(StringList.Objects[p]).Rank < TShortCutItem(StringList.Objects[r]).Rank then
      StringList.Exchange(p, r);

  if (r - p) > 1 then
    for i := p to r - 1 do
    begin
      Flag := True;
      for j := r - 1 downto i do
        if TShortCutItem(StringList.Objects[j + 1]).Rank > TShortCutItem(StringList.Objects[j]).Rank then
        begin
          StringList.Exchange(j, j + 1);
          Flag := False;
        end;

      if Flag then Exit;
    end;

  PrintStringList(Format('After BubbleSort(%d, %d)', [p, r]), StringList, p, r);
end;

function TShortCutMan.InsertShortCutItem(ShortCutItem: TShortCutItem; Index: Integer): Boolean;
begin
  Result := False;

  if (Index < 0) or (Index >= m_ShortCutList.Count) then Exit;

  m_ShortCutList.Insert(Index, ShortCutItem);

  Result := True;
end;

function TShortCutMan.LoadFavoriteList: Boolean;
var
  MyFile: TextFile;
  strLine: string;
  NewFileModifyTime: string;
  ParamItem: TStringList;
  cnt: Integer;
  Param: string;
begin
  Result := False;

  //若文件不存在，则写入缺省内容
  if not FileExists(m_FavoriteListFileName) then
  begin
    try
      try
        AssignFile(MyFile, m_FavoriteListFileName);
        ReWrite(MyFile);
      except
        Exit;
      end;
    finally
      CloseFile(MyFile);
    end;
  end;

  //读取快捷项列表文件
  try
    try
      AssignFile(MyFile, m_FavoriteListFileName);
      Reset(MyFile);
      ParamItem := TStringList.Create;

      //清空历史列表
      m_FavoriteList.Clear;

      while not Eof(MyFile) do
      begin
        Readln(MyFile, strLine);
        strLine := Trim(strLine);

        SplitString(Trim(strLine), '|', ParamItem);

        m_FavoriteList.Values[Trim(ParamItem[0])] := Trim(ParamItem[1]);
      end;
    except
      Exit;
    end;
  finally
    ParamItem.Free;
    CloseFile(MyFile);
  end;

  Result := True;
end;

procedure TShortCutMan.LoadFromListView(lvw: TListView);
var
  i: Cardinal;
  Item: TShortCutItem;
begin
  m_ShortCutList.Clear;

  if lvw.Items.Count = 0 then Exit;

  for i := 0 to lvw.Items.Count - 1 do
  begin
    Item := TShortCutItem.Create;
    StringToParamType(lvw.Items.Item[i].SubItems[1], Item.ParamType);
    Item.ShortCut := lvw.Items.Item[i].Caption;
    Item.Name := lvw.Items.Item[i].SubItems[0];
    Item.CommandLine := lvw.Items.Item[i].SubItems[2];
    Item.Freq := Integer(lvw.Items.Item[i].Data);

    if lvw.Items.Item[i].ImageIndex = Ord(siItem) then
      Item.ShortCutType := scItem
    else
      Item.ShortCutType := scBlank;

    m_ShortCutList.Add(Item);
  end;
end;

function TShortCutMan.LoadLatestList: Boolean;
begin

end;

function TShortCutMan.LoadShortCutList(FileName: string = ''): Boolean;
var
  MyFile: TextFile;
  strLine: string;
  Item: TShortCutItem;
  NewFileModifyTime: string;
  CmdDir: string;
  CmdFile: string;
  CmdList: TStringList;
begin
  Result := False;

  //若参数不空，则替换文件名
  if FileName <> '' then m_ShortCutFileName := FileName;

  //若文件名为空，则返回
  if Trim(m_ShortCutFileName) = '' then Exit;

  //其实没必要添加一个自定义命令的目录
  {
  //自定义命令存放位置
  CmdDir := ExtractFilePath(Application.ExeName) + CMD_DIR;
  if not DirectoryExists(CmdDir) then CreateDir(CmdDir);
  }

  //若文件不存在，则写入缺省内容
  if not FileExists(m_ShortCutFileName) then
  begin
    try
      try
        AssignFile(MyFile, m_ShortCutFileName);
        ReWrite(MyFile);

        //写入文件头（因为太麻烦，不要这个文件头了）
        //WriteLn(MyFile, '%------------------------------------------------------------------------------%');
        //WriteLn(MyFile, '%Please follow [ShortCut, Name, Command Line], DO NOT rename or delete me      %');
        //WriteLn(MyFile, '%------------------------------------------------------------------------------%');

        //若需要写入示例
        if m_WriteDefaultShortCutList then
        begin
          WriteLn(MyFile, ShortCutItemToString(scItem, ptNone, 'Computer', resDefault_ShortCut_Name_0, '::{20D04FE0-3AEA-1069-A2D8-08002B30309D}', 100));
          WriteLn(MyFile, ShortCutItemToString(scItem, ptNone, 'Explorer', resDefault_ShortCut_Name_1, 'explorer.exe /e,::{20D04FE0-3AEA-1069-A2D8-08002B30309D}'));
          WriteLn(MyFile, ShortCutItemToString(scItem, ptNone, 'MyDocument', resDefault_ShortCut_Name_2, 'explorer.exe'));
          WriteLn(MyFile, ShortCutItemToString(scItem, ptNone, 'ie', resDefault_ShortCut_Name_3, 'iexplore.exe', 8));
          WriteLn(MyFile, ShortCutItemToString(scItem, ptNone, 'notepad', resDefault_ShortCut_Name_4, 'notepad', 7));
          WriteLn(MyFile, ShortCutItemToString(scItem, ptNone, 'mspaint', resDefault_ShortCut_Name_5, 'mspaint'));
          WriteLn(MyFile, ShortCutItemToString(scItem, ptNoEncoding, 'cmd', resDefault_ShortCut_Name_6, 'cmd /k %p', 6));
          WriteLn(MyFile, ShortCutItemToString(scItem, ptNone, 'Calc', resDefault_ShortCut_Name_7, 'calc', 5));

          //因为有了自写的WinCtl.exe，所以不需要做这个啰嗦事儿了
          {
          //中文版Windows下是“显示桌面.scf”，英文版是"Show Desktop.scf"，别的语言不知道，所以干脆存到自己目录吧
          CmdFile := CmdDir + '\Desktop.scf';
          if not FileExists(CmdFile) then
          try
            CmdList := TStringList.Create;
            CmdList.Add('[Shell]');
            CmdList.Add('Command=2');
            CmdList.Add('IconFile=explorer.exe,3');
            CmdList.Add('[Taskbar]');
            CmdList.Add('Command=ToggleDesktop');
            CmdList.SaveToFile(CmdFile);
          finally
            CmdList.Free;
          end;
          }

          //这条被改变为 WinCtl.exe MinAll
          //WriteLn(MyFile, ShortCutItemToString(scItem, ptNone, 'Desktop', resDefault_ShortCut_Name_8, '.\' + CMD_DIR + '\Desktop.scf'));
          WriteLn(MyFile, ShortCutItemToString(scItem, ptNone, 'Desktop', resDefault_ShortCut_Name_8, '@.\WinCtl.exe MinAll'));

          WriteLn(MyFile, ShortCutItemToString(scItem, ptNone, 'msconfig', resDefault_ShortCut_Name_9, 'msconfig'));
          WriteLn(MyFile, ShortCutItemToString(scItem, ptNone, 'Reg', resDefault_ShortCut_Name_10, 'regedt32', 4));
          WriteLn(MyFile, ShortCutItemToString(scItem, ptNone, 'myip', resDefault_ShortCut_Name_11, 'nslookup'));
          WriteLn(MyFile, ShortCutItemToString(scItem, ptNone, 'dev', resDefault_ShortCut_Name_12, 'devmgmt.msc'));
          WriteLn(MyFile, ShortCutItemToString(scItem, ptNone, 'Taskmgr', resDefault_ShortCut_Name_13, 'taskmgr'));
          //WriteLn(MyFile, ShortCutItemToString(scItem, ptNone, 'ShutDown', resDefault_ShortCut_Name_14, 'tsshutdn 3 /delay:0'));
          //WriteLn(MyFile, ShortCutItemToString(scItem, ptNone, 'Reboot', resDefault_ShortCut_Name_15, 'tsshutdn 3 /delay:0 /reboot'));
          WriteLn(MyFile, ShortCutItemToString(scItem, ptNone, 'ShutDown', resDefault_ShortCut_Name_14, 'shutdown /s /t 5'));
          WriteLn(MyFile, ShortCutItemToString(scItem, ptNone, 'Reboot', resDefault_ShortCut_Name_15, 'shutdown /r /t 5'));
          WriteLn(MyFile, ShortCutItemToString(scBlank));
          WriteLn(MyFile, ShortCutItemToString(scItem, ptNone, 'Windows', resDefault_ShortCut_Name_16, '%WINDIR%'));
          WriteLn(MyFile, ShortCutItemToString(scItem, ptNone, 'System32', resDefault_ShortCut_Name_17, '%WINDIR%\System32'));
          WriteLn(MyFile, ShortCutItemToString(scItem, ptNone, 'ProgramFiles', resDefault_ShortCut_Name_18, '%PROGRAMFILES%'));
          WriteLn(MyFile, ShortCutItemToString(scItem, ptNone, 'Recent', resDefault_ShortCut_Name_19, '%USERPROFILE%\Recent', 10));
          WriteLn(MyFile, ShortCutItemToString(scBlank));
          WriteLn(MyFile, ShortCutItemToString(scItem, ptURLQuery, 'b', resDefault_ShortCut_Name_20, 'http://www.baidu.com/s?wd=', 12));
          WriteLn(MyFile, ShortCutItemToString(scItem, ptUTF8Query, 'g', resDefault_ShortCut_Name_21, 'http://www.google.com/search?q=', 14));
          WriteLn(MyFile, ShortCutItemToString(scItem, ptURLQuery, 's', resDefault_ShortCut_Name_22, 'http://mp3.sogou.com/music.so?query='));
          WriteLn(MyFile, ShortCutItemToString(scItem, ptURLQuery, 'zd', resDefault_ShortCut_Name_23, 'http://zhidao.baidu.com/q?ct=17&pn=0&tn=ikaslist&rn=10&word=', 9));
          WriteLn(MyFile, ShortCutItemToString(scItem, ptUTF8Query, 'v', resDefault_ShortCut_Name_24, 'http://www.verycd.com/search/folders?kw='));
          WriteLn(MyFile, ShortCutItemToString(scItem, ptUTF8Query, 'y', resDefault_ShortCut_Name_25, 'http://search.yahoo.com/search?p='));
          WriteLn(MyFile, ShortCutItemToString(scBlank));
          WriteLn(MyFile, ShortCutItemToString(scItem, ptNone, 'Upgrade', resDefault_ShortCut_Name_26, UPGRADE_URL, 15));
          WriteLn(MyFile, ShortCutItemToString(scItem, ptNone, 'Config', resDefault_ShortCut_Name_27, '.\ALTRun.ini'));
          WriteLn(MyFile, ShortCutItemToString(scBlank));
          WriteLn(MyFile, ShortCutItemToString(scItem, ptNone, 'AddRemoveProgram', resDefault_ShortCut_Name_28, 'appwiz.cpl', 0));
          WriteLn(MyFile, ShortCutItemToString(scItem, ptNone, 'ControlPanel', resDefault_ShortCut_Name_29, 'control.exe', 0));
          WriteLn(MyFile, ShortCutItemToString(scItem, ptNone, 'InternetConnection', resDefault_ShortCut_Name_30, 'control.exe Inetcpl.cpl ,4', 0));
          WriteLn(MyFile, ShortCutItemToString(scItem, ptNone, 'SystemProperty', resDefault_ShortCut_Name_31, 'Sysdm.cpl', 0));
          WriteLn(MyFile, ShortCutItemToString(scItem, ptNoEncoding, 'r', resDefault_ShortCut_Name_32, NEW_PARAM_FLAG, 100));
          WriteLn(MyFile, ShortCutItemToString(scItem, ptURLQuery, 'cb', resDefault_ShortCut_Name_33, 'http://www.baidu.com/s?wd=' + CLIPBOARD_FLAG, 12));
          WriteLn(MyFile, ShortCutItemToString(scItem, ptUTF8Query, 'cg', resDefault_ShortCut_Name_34, 'http://www.google.com/search?q=' + CLIPBOARD_FLAG, 24));
          WriteLn(MyFile, ShortCutItemToString(scItem, ptNoEncoding, 'ShowOnly', resDefault_ShortCut_Name_35, '@.\WinCtl.exe ShowOnly ' + FOREGROUND_WINDOW_ID_FLAG, 15));
          WriteLn(MyFile, ShortCutItemToString(scItem, ptNoEncoding, 'Hide', resDefault_ShortCut_Name_36, '@.\WinCtl.exe Hide ' + FOREGROUND_WINDOW_ID_FLAG, 20));
          WriteLn(MyFile, ShortCutItemToString(scItem, ptNone, 'UnHide', resDefault_ShortCut_Name_37, '@.\WinCtl.exe UnHide', 20));
        end;
      except
        Exit;
      end;
    finally
      CloseFile(MyFile);
    end;
  end;

  //如果文件长度为0，则使用备份的文件
  if GetFileSize(m_ShortCutFileName) = 0 then
  begin
    TraceErr('Size of ShortCutFileName = 0, restore the backup file');

    CopyFile(PChar(m_ShortCutFileName + '.bak'), PChar(m_ShortCutFileName), False);
  end;  

  //取得文件修改时间
  NewFileModifyTime := GetFileModifyTime(m_ShortCutFileName);

  //如果文件修改时间没有改变，就不用刷新了
  if m_FileModifyTime = NewFileModifyTime then
    Exit
  else
  begin
    m_FileModifyTime := NewFileModifyTime;
    m_NeedRefresh := True;
  end;


  //读取快捷项列表文件
  try
    try
      AssignFile(MyFile, m_ShortCutFileName);
      Reset(MyFile);

      //清空快捷项列表
      m_ShortCutList.Clear;

      while not Eof(MyFile) do
      begin
        Readln(MyFile, strLine);
        strLine := Trim(strLine);

        //先增加一项再说
        Item := TShortCutItem.Create;

        //解析当前行
        StringToShortCutItem(strLine, Item);

        case Item.ShortCutType of
          scItem, scBlank:
            m_ShortCutList.Add(TObject(Item));

          scRemark, scOther:
            Item.Free;
        end;
      end;
    except
      Exit;
    end;
  finally
    CloseFile(MyFile);
  end;

  Sort;

  Result := True;
end;

procedure TShortCutMan.ModifyShortCutItem(ShortCutType: TShortCutType; ShortCut,
  Name, CommandLine: string; Index: Integer);
var
  Item: TShortCutItem;
begin
  Item := TShortCutItem(m_ShortCutList.Items[Index]);

  Item.ShortCutType := ShortCutType;
  Item.ShortCut := ShortCut;
  Item.Name := Name;
  Item.CommandLine := CommandLine;

  SaveShortCutList(m_ShortCutFileName);
  LoadShortCutList(m_ShortCutFileName);
end;

procedure TShortCutMan.ModifyShortCutItem(ShortCutItem: TShortCutItem;
  Index: Integer);
var
  Item: TShortCutItem;
begin
  with ShortCutItem do
    ModifyShortCutItem(ShortCutType, ShortCut, Name, CommandLine, Index);
end;

function TShortCutMan.ParamTypeToString(ParamType: TParamType): string;
begin
  case ParamType of
    ptNone:
      Result := '';
    ptNoEncoding:
      Result := 'No_Encoding';
    ptURLQuery:
      Result := 'URL_Query';
    ptUTF8Query:
      Result := 'UTF8_Query';
  end;
end;

function TShortCutMan.Partition(var StringList: TObjectList; p, r: Integer): Integer;
var
  PivotIndex, PivotValue: Integer;
  i, j: Integer;
begin
  PrintStringList(Format('Before Partition(%d, %d)', [p, r]), StringList, p, r);

  PivotIndex := SelectPivot(p, r);                     //在L[p..r]中选择一个支点元素pivot
  PivotValue := TShortCutItem(StringList.Items[PivotIndex]).Rank;

  i := p - 1;
  j := r + 1;

  while True do
  begin
    //移动右指针，注意这里不能用while循环
    repeat
      j := j - 1
    until TShortCutItem(StringList.Items[j]).Rank
      >= PivotValue;

    //移动左指针，注意这里不能用while循环
    repeat
      i := i + 1
    until TShortCutItem(StringList.Items[i]).Rank <= PivotValue;

    if i < j then
      StringList.Exchange(i, j)                        //交换L[i]和L[j]
    else
      if j <> r then
      begin
        Result := j;                                   //返回j的值作为分割点
        Break;
      end
      else
      begin
        Result := j - 1;                               //返回j前一位置作为分割点
        Break;
      end;
  end;

  PrintStringList(Format('After Partition(%d, %d) = %d', [p, r, Result]), StringList, p, r);
end;

procedure TShortCutMan.PrintStringList(Title: string; StringList: TObjectList; p, q: Integer);
var
  i: Cardinal;
  Item: TShortCutItem;
begin
  if not DEBUG_SORT then Exit;

  TraceMsg('  - %s', [Title]);

  for i := p to q do
  begin
    Item := TShortCutItem(StringList.Items[i]);
    with Item do TraceMsg('  - [%d] = %d', [i, Freq]);
  end;
end;

function TShortCutMan.Partition(var StringList: TStringList; p, r: Integer): Integer;
var
  PivotIndex, PivotValue: Integer;
  i, j: Integer;
begin
  //Bug
  //3,0,8,2,8,6,1,3,0,8，如果 PivotIndex = 1，返回 3,8,8,2,8,6,1,3,0,0

  PrintStringList(Format('Before Partition(%d, %d)', [p, r]), StringList, p, r);

  PivotIndex := SelectPivot(p, r);                     //在L[p..r]中选择一个支点元素pivot
  PivotValue := TShortCutItem(StringList.Objects[PivotIndex]).Rank;

  i := p - 1;
  j := r + 1;

  while True do
  begin
    //移动右指针，注意这里不能用while循环
    repeat
      j := j - 1
    until TShortCutItem(StringList.Objects[j]).Rank
      >= PivotValue;

    //移动左指针，注意这里不能用while循环
    repeat
      i := i + 1
    until TShortCutItem(StringList.Objects[i]).Rank
      <= PivotValue;

    if i < j then
      StringList.Exchange(i, j)                        //交换L[i]和L[j]
    else
      if j <> r then
      begin
        Result := j;                                   //返回j的值作为分割点
        Break;
      end
      else
      begin
        Result := j - 1;                               //返回j前一位置作为分割点
        Break;
      end;
  end;

  PrintStringList(Format('After Partition(%d, %d) = %d', [p, r, Result]), StringList, p, r);
end;

procedure TShortCutMan.PrintStringList(Title: string; StringList: TStringList; p, q: Integer);
var
  i: Cardinal;
  Item: TShortCutItem;
begin
  if not DEBUG_SORT then Exit;

  TraceMsg('  - %s', [Title]);

  for i := p to q do
  begin
    Item := TShortCutItem(StringList.Objects[i]);
    with Item do TraceMsg('  - [%d] = %d', [i, Freq]);
  end;
end;

procedure TShortCutMan.QuickSort(var StringList: TObjectList; p, r: integer);
const
  Q_MIN = 12;
var
  q: Integer;
begin
  PrintStringList(Format('Before QuickSort(%d, %d)', [p, r]), StringList, p, r);

  //若L[p..r]足够小则直接对L[p..r]进行插入排序
  if r - p <= Q_MIN then
    BubbleSort(StringList, p, r)
  else
  begin
    q := Partition(StringList, p, r);

    //将L[p..r]分解为L[p..q]和L[q+1..r]两部分
    QuickSort(StringList, p, q);                       //递归排序L[p..q]
    QuickSort(StringList, q + 1, r);                   //递归排序L[q+1..r]
  end;

  PrintStringList(Format('After QuickSort(%d, %d)', [p, r]), StringList, p, r);
end;

procedure TShortCutMan.QuickSort(var StringList: TStringList; p, r: integer);
const
  Q_MIN = 12;
var
  q: Integer;
begin
  PrintStringList(Format('Before QuickSort(%d, %d)', [p, r]), StringList, p, r);

  //若L[p..r]足够小则直接对L[p..r]进行插入排序
  if r - p <= Q_MIN then
    BubbleSort(StringList, p, r)
  else
  begin
    q := Partition(StringList, p, r);

    //将L[p..r]分解为L[p..q]和L[q+1..r]两部分
    QuickSort(StringList, p, q);                       //递归排序L[p..q]
    QuickSort(StringList, q + 1, r);                   //递归排序L[q+1..r]
  end;

  PrintStringList(Format('After QuickSort(%d, %d)', [p, r]), StringList, p, r);
end;

function TShortCutMan.ReplaceEnvStr(str: string): string;
begin
  Result := str;

  m_Regex.Expression := '(%)(.*?)(%)';

  if m_Regex.Exec(str) then
    if GetEnvironmentVariable(m_Regex.Match[2]) <> '' then
      //Result := m_Regex.Replace(str, GetEnvironmentVariable(m_Regex.Match[2]), True);
      Result := StringReplace(str, '%' + m_Regex.Match[2] + '%', GetEnvironmentVariable(m_Regex.Match[2]), [rfReplaceAll]);
end;

function TShortCutMan.SaveFavoriteList: Boolean;
var
  i: Cardinal;
  MyFile: TextFile;
  strLine: string;
  ParamItem: TStringList;
  MaxCnt: Integer;
  Param: string;
begin
  Result := False;

  //若文件不存在，则写入缺省内容
  try
    try
      AssignFile(MyFile, m_FavoriteListFileName);
      ReWrite(MyFile);

      if m_FavoriteList.Count > 0 then
        for i := 0 to m_FavoriteList.Count - 1 do
        begin
          WriteLn(MyFile, Format('%-30s|%-30s%',
            [LowerCase(m_FavoriteList.Names[i]), m_FavoriteList.Values[m_FavoriteList.Names[i]]]));
        end;
    except
      Exit;
    end;
  finally
    CloseFile(MyFile);
  end;
end;

function TShortCutMan.SaveLatestList: Boolean;
begin

end;

function TShortCutMan.SaveShortCutList(FileName: string = ''): Boolean;
var
  i: Cardinal;
  MyFile: TextFile;
  strLine: string;
  Item: TShortCutItem;
begin
  TraceMsg('SaveShortCutList');

  Result := False;

  //若参数不空，则替换文件名
  if FileName <> '' then m_ShortCutFileName := FileName;

  //若文件名为空，则返回
  if Trim(m_ShortCutFileName) = '' then Exit;

  //若文件不存在，则写入缺省内容
  try
    try
      AssignFile(MyFile, m_ShortCutFileName);
      ReWrite(MyFile);

      if m_ShortCutList.Count > 0 then
        for i := 0 to m_ShortCutList.Count - 1 do
        begin
          WriteLn(MyFile, ShortCutItemToString(TShortCutItem(m_ShortCutList.Items[i])));
        end;
    except
      Exit;
    end;
  finally
    CloseFile(MyFile);
  end;
end;

function TShortCutMan.SelectPivot(p, r: Integer): Integer;
begin
  Randomize;
  Result := p + Random(r - p + 1);

  if DEBUG_SORT then
    TraceMsg('SelectPivot(%d, %d) = %d', [p, r, Result]);
end;

function TShortCutMan.SetLatestShortCutIndexList(IndexList: string): Boolean;
var
  i: Cardinal;
  Index: Integer;
  ShortCutIndex: Integer;
begin
  Result := False;

  if Trim(IndexList) = '' then Exit;

  SplitString(IndexList, ',', m_LatestList);
  if m_LatestList.Count = 0 then Exit;

  //因为有时会出现最后一个字符是','，导致报错
  for i := m_LatestList.Count - 1 downto 0 do
    if Trim(m_LatestList.Strings[i]) = '' then
      m_LatestList.Delete(i);

  Index := 0;
  for i := 0 to m_LatestList.Count - 1 do
  begin
    ShortCutIndex := StrToInt(m_LatestList.Strings[i]);
    if (ShortCutIndex >= 0) and (ShortCutIndex <= m_ShortCutList.Count) then
    begin
      m_LatestList.Objects[Index] := m_ShortCutList.Items[ShortCutIndex];
      Inc(Index);
    end;
  end;
end;

procedure TShortCutMan.SetParam(Index: Integer; const Value: string);
begin
  m_Param[Index] := Value;
end;

function TShortCutMan.ShortCutItemToString(ShortCutType: TShortCutType;
  ParamType: TParamType; ShortCut, Name, CommandLine: string; Freq: Integer): string;
begin
  case ShortCutType of
    scItem:
      Result := Format('F%-8d|%-20s|%-30s|%-30s|%s',
        [Freq, ParamTypeToString(ParamType), ShortCut, Name, CommandLine]);
    scBlank:
      Result := '';
    scRemark, scOther:
      Result := Name;
  end;
end;

function TShortCutMan.ShortCutItemToString(ShortCutItem: TShortCutItem): string;
begin
  with ShortCutItem do
    Result := ShortCutItemToString(ShortCutType, ParamType, ShortCut, Name, CommandLine, Freq);
end;

procedure TShortCutMan.Sort;
var
  i, j, k: Integer;
  Item: TShortCutItem;
begin
  if m_ShortCutList.Count = 0 then Exit;

  m_SortedShortCutList.Clear;

  for i := 0 to m_ShortCutList.Count - 1 do
  begin
    Item := TShortCutItem(m_ShortCutList.Items[i]);

    if Item.ShortCutType = scItem then
    begin
      Item.Rank := Item.Freq * 1000;
      k := 8;
      for j := 1 to Length(Item.ShortCut) do
      begin
        k := k div 2;

        if j > 3 then
          Break
        else
          Item.Rank := Item.Rank - k * (Ord(UpCase(Item.ShortCut[j])) - Ord('A'));
      end;

      Item.Rank := Item.Rank - Length(Item.ShortCut);

      m_SortedShortCutList.AddObject(Format(ListFormat, [Item.ShortCut, Item.Name]), TObject(Item));
    end;
  end;

  //快速排序
  QuickSort(m_SortedShortCutList, 0, m_SortedShortCutList.Count - 1);
end;

function TShortCutMan.StringToParamType(str: string; var ParamType: TParamType): Boolean;
begin
  Result := True;

  if Trim(str) = '' then
    ParamType := ptNone
  else if LowerCase(Trim(str)) = 'no_encoding' then
    ParamType := ptNoEncoding
  else if LowerCase(Trim(str)) = 'url_query' then
    ParamType := ptURLQuery
  else if LowerCase(Trim(str)) = 'utf8_query' then
    ParamType := ptUTF8Query
  else
    Result := False;
end;

function TShortCutMan.StringToShortCutItem(str: string; var ShortCutItem: TShortCutItem): Boolean;
var
  ShortCutSubItemList: TStringList;
  i, offset: Cardinal;
  CmdPos: Integer;
  strTemp: string;
begin
  Result := False;

  //将全角逗号替换为半角逗号
  str := StringReplace(Trim(str), '，', ',', [rfReplaceAll]);

  with ShortCutItem do
  begin
    //默认是Other，Name = strLine
    ShortCutType := scOther;
    ShortCut := '';
    Name := str;
    CommandLine := '';
    Freq := 0;

    //若是空白行，添加此行
    if str = '' then
    begin
      ShortCutType := scBlank;
      Result := True;
      Exit;
    end;

    //若是注释行
    //if str[1] = '%' then
    //begin
    //  ShortCutType := scRemark;
    //  Result := True;
    //  Exit;
    //end;

    //看看是不是Item
    try
      ShortCutSubItemList := TStringList.Create;

      //古时候的版本用","来分隔各项, 新版本用"|"来分隔各项
      SplitString(str, ',', ShortCutSubItemList);

      //如 explorer.exe /e,::{20D04FE0-3AEA-1069-A2D8-08002B30309D}
      if (ShortCutSubItemList.Count < 3) or (Pos('F', str) = 1) then
        SplitString(str, '|', ShortCutSubItemList);

      if ShortCutSubItemList.Count >= 3 then
      begin
        ShortCutType := scItem;

        //为了继承老的List文件，需要判断第一项
        //如果第一项是"F"开头，后跟数字，说明是最新版本的文件
        //如果第一项为空，说明是最近版本的文件
        //如果第一项非空，且为参数类型，也说明是最近版本的文件
        //否则就是老版本文件
        //offset是偏移

        offset := 0;

        ShortCutSubItemList.Strings[0] := Trim(ShortCutSubItemList.Strings[0]);
        if Length(ShortCutSubItemList.Strings[0]) >= 1 then
          if ShortCutSubItemList.Strings[0][1] = 'F' then
          begin
            //去掉最前面的"F"
            ShortCutSubItemList.Strings[0] := Copy(ShortCutSubItemList.Strings[0], 2, Length(ShortCutSubItemList.Strings[0]) - 1);
            if IsNumericStr(ShortCutSubItemList.Strings[0]) then
            begin
              //如比“99999999”还要长，就无法解析了
              if Length(ShortCutSubItemList.Strings[0]) > 8 then
                Freq := 10000
              else
                Freq := StrToInt(ShortCutSubItemList.Strings[0]);
            end
            else
              Freq := 0;

            Inc(offset);
          end;

        ParamType := ptNone;
        if StringToParamType(Trim(ShortCutSubItemList.Strings[offset]), ParamType) then
          Inc(offset);

        ShortCut := Trim(ShortCutSubItemList.Strings[offset]);
        Name := Trim(ShortCutSubItemList.Strings[offset + 1]);

        //把剩下的都拼在一起好了
        //注意，拼在一起，不如按照原样拷贝！
        //如http://translate.google.cn/translate_t?hl=zh-CN#en|zh-CN|这样带有|的

        strTemp := str;
        for i := 0 to offset + 1 do
          strTemp := StringReplace(strTemp, ShortCutSubItemList.Strings[i], '', [rfIgnoreCase]);

        CmdPos := Pos(ShortCutSubItemList.Strings[offset + 2], strTemp);
        CommandLine := Copy(strTemp, CmdPos, Length(strTemp) - CmdPos + 1);

        //CommandLine := '';
        //for i := offset + 2 to ShortCutSubItemList.Count - 1 do
        //  if i = ShortCutSubItemList.Count - 1 then
        //    CommandLine := CommandLine + Trim(ShortCutSubItemList.Strings[i])
        //  else
        //    CommandLine := CommandLine + Trim(ShortCutSubItemList.Strings[i]) + ', ';
      end;
    finally
      ShortCutSubItemList.Free;
    end;
  end;

  Result := True;
end;

function TShortCutMan.Test: Boolean;
var
  ret: Integer;
  str, querystr: string;
  i: Cardinal;
begin

  Result := True;
end;

function TShortCutMan.Execute(ShortCutItem: TShortCutItem; KeyWord: string): Boolean;
begin
  m_FavoriteList.Values[LowerCase(KeyWord)] := ShortCutItem.Name;
  AddLatestShortCutItem(ShortCutItem);
  Inc(ShortCutItem.Freq);
  Result := Execute(ShortCutItem);
end;

function TShortCutMan.Execute(cmdobj: TCmdObject): Boolean;
var
  hThread: THandle;
  ThreadID: DWORD;
  str: string;
begin
  Result := False;

  if cmdobj.Command = '' then Exit;

  hThread := CreateThread(nil, 0, @ExecuteCmd, Pointer(cmdobj), 0, ThreadID);

  //Count ++
  Inc(ShortCutRunCount);

  if (ShortCutRunCount mod 10000) = 0 then
    Application.MessageBox(
      PChar(Format(resCongratulations, [ShortCutRunCount])),
      PChar(resInfo), MB_OK + MB_ICONINFORMATION + MB_TOPMOST);

  Result := True;
end;

end.

