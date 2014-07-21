program ALTRun;

uses
  //CnMemProf,
  ExceptionLog,
  Forms,
  SysUtils,
  pngimage in '3rdUnit\pngimage\pngimage.pas',
  frmALTRun in 'Form\frmALTRun.pas' {ALTRunForm},
  frmConfig in 'Form\frmConfig.pas' {ConfigForm},
  frmShortCut in 'Form\frmShortCut.pas' {ShortCutForm},
  untUtilities in 'Unit\untUtilities.pas',
  untALTRunOption in 'Unit\untALTRunOption.pas',
  frmShortCutMan in 'Form\frmShortCutMan.pas' {ShortCutManForm},
  untShortCutMan in 'Unit\untShortCutMan.pas',
  frmAbout in 'Form\frmAbout.pas' {AboutForm},
  frmParam in 'Form\frmParam.pas' {ParamForm},
  frmHelp in 'Form\frmHelp.pas' {HelpForm},
  frmInvalid in 'Form\frmInvalid.pas' {InvalidForm},
  frmLang in 'Form\frmLang.pas' {LangForm},
  frmAutoHide in 'Form\frmAutoHide.pas' {AutoHideForm},
  untLogger in 'Unit\untLogger.pas',
  untClipboard in 'Unit\untClipboard.pas';

{$R *.res}

var
  IsExited: Boolean;
begin
  //----- 内存泄漏管理
//  mmPopupMsgDlg := DEBUG_MODE;
//  mmShowObjectInfo := DEBUG_MODE;
//  mmUseObjectList := DEBUG_MODE;
//  mmSaveToLogFile := DEBUG_MODE;

  //----- Trace
  //InitLogger(DEBUG_MODE,DEBUG_MODE, False);

  //----- 主程序开始
  Application.Initialize;

  IsRunFirstTime := not FileExists(ExtractFilePath(Application.ExeName) + TITLE + '.ini');
  LoadSettings;
  //SaveSettings;

  Application.Title := TITLE;
  Application.CreateForm(TParamForm, ParamForm);
  Application.CreateForm(TALTRunForm, ALTRunForm);
  Application.ShowMainForm := False;
  Application.OnMinimize := ALTRunForm.evtMainMinimize;

  //不这么做，会有内存泄露
  if not ALTRunForm.IsExited then Application.Run;

  SaveSettings;
end.

