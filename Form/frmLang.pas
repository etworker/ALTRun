unit frmLang;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TLangForm = class(TForm)
    btnOK: TBitBtn;
    cbbLang: TComboBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  LangForm: TLangForm;

implementation

{$R *.dfm}

end.
