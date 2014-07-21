//TComboBox控件有Bug，对中文支持不好
//TComboBoxEx控件还不错，就用的它的这个
unit frmParam;

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
  untALTRunOption,
  untUtilities,
  untLogger,
  ExtCtrls,
  ComCtrls, RzButton;

const
  PARAM_HISTORY_FILE = 'ParamHistory.txt';

type
  TParamForm = class(TForm)
    tmrHide: TTimer;
    cbbParam: TComboBoxEx;
    btnOK: TRzButton;

    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tmrHideTimer(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure cbbParamKeyPress(Sender: TObject; var Key: Char);
    procedure FormHide(Sender: TObject);
    procedure cbbParamChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbbParamKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    m_ParamHistoryFileName: string;
    m_FileModifyTime: string;

    procedure Createparams(var params: TCreateParams); override;

    procedure RestartTimer;
    procedure StopTimer;
  public
    function LoadParamHistory: Boolean;
    function SaveParamHistory: Boolean;
  end;

var
  ParamForm: TParamForm;

implementation

{$R *.dfm}

procedure TParamForm.btnOKClick(Sender: TObject);
var
  i, Index: Integer;
  RankMin, IndexMin: Integer;
  TempKeyword: string;
begin
  StopTimer;

  //当删除combobox的某一项时，text属性也会跟着改变，所以需要暂存之
  TempKeyword := cbbParam.Text;
  Index := cbbParam.Items.IndexOf(TempKeyword);

  //如果列表中不存在，就新添这一项，否则就将变量+1
  if TempKeyword <> '' then
    if Index < 0 then
    begin
      //如果列表未超过容量，就增加它，否则就删除一个太差的再增加它
      if cbbParam.Items.Count >= ParamHistoryLimit then
      begin
        RankMin := MaxInt;
        IndexMin := 0;

        //从后向前，找到一个用的最少的
        for i := cbbParam.Items.Count - 1 downto 0 do
          if Integer(Pointer(cbbParam.Items.Objects[i])) < RankMin then
          begin
            IndexMin := i;
            RankMin := Integer(Pointer(cbbParam.Items.Objects[i]));
          end;

        //删除之
        cbbParam.Items.Delete(IndexMin);
      end;

      //插在第一项
      cbbParam.Items.InsertObject(0, TempKeyword, Pointer(0));
    end
    else
    begin
      cbbParam.Items.Objects[Index] := Pointer(Integer(cbbParam.Items.Objects[Index]) + 1);
    end;

  cbbParam.Text := TempKeyword;
  ModalResult := mrOk;
end;

procedure TParamForm.cbbParamChange(Sender: TObject);
var
  ParamList: TStringList;
begin
  try
    ParamList := TStringList.Create;

    //根据Text填充下拉列表内容
    //FilterKeyWord(cbbParam.Text, ParamList);
    //cbbParam.Items.Assign(ParamList);
  finally
    ParamList.Free;
  end;
end;

procedure TParamForm.cbbParamKeyPress(Sender: TObject; var Key: Char);
var
  strLeft, strRight, str: WideString;                  //不设成WideString就有Bug
begin
  //如果回车，就等于按下确定
  if Key = #13 then btnOKClick(Sender);

  //  if Key = #8 then
  //  begin
  //    key := #0;
  //
  //    //因为Delphi自带的TComboBox有Bug，如果打开AutoComplete选项，退格键就会删除错误
  //    //原因是ComboBox的Text是双字节的编码，但是退格时只退了1个字节，导致问题
  //    //解决方法是先用WideString将Text取出，操作结束，再写回Text
  //
  //    str := cbbParam.Text;
  //
  //    strLeft := '';
  //    if cbbParam.SelStart >= 1 then
  //      if cbbParam.SelLength = 0 then
  //        strLeft := Copy(str, 1, cbbParam.SelStart - 1)
  //      else
  //        strLeft := Copy(str, 1, cbbParam.SelStart);
  //
  //    strRight := Copy(str, cbbParam.SelStart + cbbParam.SelLength + 1,
  //      Length(str) - cbbParam.SelStart - cbbParam.SelLength + 1);
  //
  //    cbbParam.Text := strLeft + strRight;
  //    cbbParam.SelStart := Length(strLeft);
  //    cbbParam.SelLength := 0;
  //  end;
end;

procedure TParamForm.cbbParamKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //如果回车，就等于按下确定
  //if Key = 13 then btnOKClick(Sender);
end;

procedure TParamForm.Createparams(var params: TCreateParams);
begin
  inherited;

  with params do
  begin
    params.Style := params.Style or WS_POPUP { or WS_BORDER};
    params.ExStyle := params.ExStyle or WS_EX_TOPMOST {or WS_EX_NOACTIVATE or WS_EX_WINDOWEDGE};
    params.WndParent := GetDesktopWindow;
  end;
end;

procedure TParamForm.FormActivate(Sender: TObject);
begin
  RestartTimer;
end;

procedure TParamForm.FormCreate(Sender: TObject);
begin
  btnOK.Caption := resBtnOK;

  m_ParamHistoryFileName := ExtractFilePath(Application.ExeName) + PARAM_HISTORY_FILE;
  LoadParamHistory;
end;

procedure TParamForm.FormDestroy(Sender: TObject);
begin
  SaveParamHistory;
end;

procedure TParamForm.FormHide(Sender: TObject);
begin
  StopTimer;
end;

procedure TParamForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  RestartTimer;

  case Key of
    VK_ESCAPE:
      begin
        Key := VK_NONAME;

        //如果不为空，就清空，否则隐藏
        if cbbParam.Text = '' then
          ModalResult := mrCancel
        else
        begin
          cbbParam.Text := '';
          cbbParam.SetFocus;
        end;
      end;
  end;

end;

procedure TParamForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  TraceMsg('FormKeyPress(%s)', [Key]);
  
  case Key of
    //如果回车，就执行程序
    #13:
      begin
        Key := #0;
        btnOKClick(Sender);
      end;
  end;
end;

procedure TParamForm.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  RestartTimer;
end;

procedure TParamForm.FormShow(Sender: TObject);
begin
  btnOK.Caption := resBtnOK;
  cbbParam.SetFocus;
end;

function TParamForm.LoadParamHistory: Boolean;
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
  if not FileExists(m_ParamHistoryFileName) then
  begin
    try
      try
        AssignFile(MyFile, m_ParamHistoryFileName);
        ReWrite(MyFile);
      except
        Exit;
      end;
    finally
      CloseFile(MyFile);
    end;
  end;

  //取得文件修改时间
  NewFileModifyTime := GetFileModifyTime(m_ParamHistoryFileName);

  //如果文件修改时间没有改变，就不用刷新了
  if m_FileModifyTime = NewFileModifyTime then
    Exit
  else
    m_FileModifyTime := NewFileModifyTime;

  //读取快捷项列表文件
  try
    try
      AssignFile(MyFile, m_ParamHistoryFileName);
      Reset(MyFile);
      ParamItem := TStringList.Create;

      //清空历史列表
      cbbParam.Items.Clear;

      while not Eof(MyFile) do
      begin
        Readln(MyFile, strLine);
        strLine := Trim(strLine);

        SplitString(Trim(strLine), '|', ParamItem);

        //若已经满了，就不读了
        if cbbParam.Items.Count >= ParamHistoryLimit then Exit;

        //取得Rank
        cnt := StrToInt(Trim(ParamItem[0]));

        //取得参数
        Param := Trim(ParamItem[1]);

        //如果参数不存在，就添加
        if cbbParam.Items.IndexOf(Param) < 0 then
          cbbParam.Items.AddObject(Param, Pointer(cnt));
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

procedure TParamForm.RestartTimer;
begin
  if DEBUG_MODE then Exit;

  if Visible then
  begin
    tmrHide.Enabled := False;
    tmrHide.Interval := HideDelay * 1000;
    tmrHide.Enabled := True;
  end;
end;

function TParamForm.SaveParamHistory: Boolean;
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
      AssignFile(MyFile, m_ParamHistoryFileName);
      ReWrite(MyFile);

      if cbbParam.Items.Count > 0 then
      begin
        if cbbParam.Items.Count > ParamHistoryLimit then
          MaxCnt := ParamHistoryLimit
        else
          MaxCnt := cbbParam.Items.Count;

        for i := 0 to MaxCnt - 1 do
        begin
          WriteLn(MyFile, Format('%-10d|%-30s%',
            [Integer(Pointer(cbbParam.Items.Objects[i])), cbbParam.Items.Strings[i]]));
        end;
      end;

    except
      Exit;
    end;
  finally
    CloseFile(MyFile);
  end;
end;

procedure TParamForm.StopTimer;
begin
  tmrHide.Enabled := False;
end;

procedure TParamForm.tmrHideTimer(Sender: TObject);
begin
  StopTimer;
  ModalResult := mrCancel;
end;

end.

