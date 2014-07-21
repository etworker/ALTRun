unit frmAutoHide;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TAutoHideForm = class(TForm)
    btnOK: TBitBtn;
    lblInfo: TLabel;
    tmrHide: TTimer;
    tmrAlpha: TTimer;
    procedure FormShow(Sender: TObject);
    procedure tmrHideTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tmrAlphaTimer(Sender: TObject);
  private
    m_Info: string;
    m_IsHiding: Boolean;
  public
    property Info: string read m_Info write m_Info;
  end;

var
  AutoHideForm: TAutoHideForm;

implementation

{$R *.dfm}

procedure TAutoHideForm.FormCreate(Sender: TObject);
begin
  m_IsHiding := False;
end;

procedure TAutoHideForm.FormShow(Sender: TObject);
begin
  lblInfo.Caption := m_Info;
end;

procedure TAutoHideForm.tmrAlphaTimer(Sender: TObject);
const
  AlphaStep = 10;
begin
  tmrAlpha.Enabled := False;
  //SetForegroundWindow(Self.Handle);
  if Self.AlphaBlendValue >= AlphaStep then
  begin
    Self.AlphaBlendValue := Self.AlphaBlendValue - AlphaStep;
    tmrAlpha.Enabled := True;
  end
  else
  begin
    ModalResult := mrOk;
  end;
end;

procedure TAutoHideForm.tmrHideTimer(Sender: TObject);
begin
  tmrHide.Enabled := False;
  tmrAlpha.Enabled := True;
end;

end.
