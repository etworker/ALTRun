unit frmInvalid;

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
  ComCtrls,
  StdCtrls,
  Buttons,
  Menus,
  untALTRunOption;

type
  TInvalidForm = class(TForm)
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    lvShortCut: TListView;
    pmInvalid: TPopupMenu;
    S1: TMenuItem;
    mniUnselectAll1: TMenuItem;
    mniN1: TMenuItem;
    mniTest: TMenuItem;
    procedure S1Click(Sender: TObject);
    procedure mniUnselectAll1Click(Sender: TObject);
    procedure mniTestClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  InvalidForm: TInvalidForm;

implementation
uses
  untShortCutMan;

{$R *.dfm}

procedure TInvalidForm.FormCreate(Sender: TObject);
begin
  Self.Caption:=resInvalidFormCaption;
  btnOK.Caption := resBtnOK;
  btnCancel.Caption := resBtnCancel;

  lvShortCut.Columns.Items[0].Caption:=resShortCut;
  lvShortCut.Columns.Items[1].Caption:=resName;
  lvShortCut.Columns.Items[2].Caption:=resParamType;
  lvShortCut.Columns.Items[3].Caption:=resCommandLine;
end;

procedure TInvalidForm.mniTestClick(Sender: TObject);
var
  ShortCutItem: TShortCutItem;
begin
  if lvShortCut.ItemIndex < 0 then Exit;

  //命令行不能为空
  if lvShortCut.Selected.SubItems[2] = '' then
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
      ShortCut := lvShortCut.Selected.Caption;
      Name := lvShortCut.Selected.SubItems[0];
      ShortCutMan.StringToParamType(lvShortCut.Selected.SubItems[1], ParamType);
      CommandLine := lvShortCut.Selected.SubItems[2];
    end;

    //执行
    ShortCutMan.Execute(ShortCutItem);
  finally
    ShortCutItem.Free;
  end;
end;

procedure TInvalidForm.mniUnselectAll1Click(Sender: TObject);
var
  i: Cardinal;
begin
  if lvShortCut.Items.Count > 0 then
    for i := 0 to lvShortCut.Items.Count - 1 do
      lvShortCut.Items[i].Checked := False;
end;

procedure TInvalidForm.S1Click(Sender: TObject);
var
  i: Cardinal;
begin
  if lvShortCut.Items.Count > 0 then
    for i := 0 to lvShortCut.Items.Count - 1 do
      lvShortCut.Items[i].Checked := True;
end;

end.

