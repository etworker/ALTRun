unit untLogger;

interface
uses
  Windows,
  Forms,
  SysUtils,
  Variants,
  Classes,
  CnDebug;

var
  MutexHandle: THandle;
  TraceEnable: Boolean;
  CnDebugEnable: Boolean;
  LogFileName: string;
  CriticalSection: TRTLCriticalSection;

//Traceº¯Êý
procedure InitLogger(IsTraceEnable:Boolean = False; IsCnDebugEnable: Boolean = False; IsAppendMode:Boolean = False);
procedure AddLog(const str: string);
procedure TraceErr(const Msg: string); overload;
procedure TraceErr(const AFormat: string; Args: array of const); overload;
procedure TraceMsg(const Msg: string); overload;
procedure TraceMsg(const AFormat: string; Args: array of const); overload;

implementation

function GetCurrentUserName: string;
const
  cnMaxUserNameLen = 254;
var
  sUserName: string;
  dwUserNameLen: Cardinal;
begin
  dwUserNameLen := cnMaxUserNameLen - 1;
  SetLength(sUserName, cnMaxUserNameLen);
  GetUserName(Pchar(sUserName), dwUserNameLen);
  SetLength(sUserName, dwUserNameLen - 1);
  Result := sUserName;
end;

procedure InitLogger(IsTraceEnable:Boolean = False; IsCnDebugEnable: Boolean = False; IsAppendMode:Boolean = False);
var
  LogFile: TextFile;
begin
  TraceEnable := IsTraceEnable;
  CnDebugEnable := IsCnDebugEnable;

  if TraceEnable then
  begin
    LogFileName := StringReplace(Application.ExeName, '.exe', '.' + GetCurrentUserName + '.log', [rfReplaceAll]);

    try
      AssignFile(LogFile, LogFileName);

      if (FileExists(LogFileName)) and IsAppendMode then
        Append(LogFile)
      else
        Rewrite(LogFile);

      Writeln(LogFile, Format('[%s] Logon user = %s', [DateTimeToStr(Now), GetCurrentUserName]));
    finally
      CloseFile(LogFile);
    end;
  end;
end;

procedure AddLog(const str: string);
var
  LogFile: TextFile;
begin
  EnterCriticalSection(CriticalSection);
  try
    AssignFile(LogFile, LogFileName);
    Append(LogFile);

    Writeln(LogFile, str);
  finally
    LeaveCriticalSection(CriticalSection);
    CloseFile(LogFile);
  end;
end;

procedure TraceErr(const Msg: string);
begin
  if TraceEnable then
    //hLog.Add(Format('[%s] ERROR: %s', [DateTimeToStr(Now), Msg]));
    AddLog(Format('[%s] ERROR: %s', [DateTimeToStr(Now), Msg]));

  if CnDebugEnable then
    CnDebugger.TraceMsg('ERROR: ' + Msg);
end;

procedure TraceErr(const AFormat: string; Args: array of const);
begin
  if TraceEnable then
    AddLog(Format('[%s] ERROR: ', [DateTimeToStr(Now)]) + Format(AFormat, Args));

  if CnDebugEnable then
    CnDebugger.TraceMsg(Format('ERROR: %s', [Format(AFormat, Args)]));
end;

procedure TraceMsg(const Msg: string);
begin
  if TraceEnable then
    //hLog.Add(Format('[%s] ', [DateTimeToStr(Now)]) + Msg);
    AddLog(Format('[%s] ', [DateTimeToStr(Now)]) + Msg);

  if CnDebugEnable then
    CnDebugger.TraceMsg(Msg);
end;

procedure TraceMsg(const AFormat: string; Args: array of const);
begin
  if TraceEnable then
    //hLog.Add(Format('[%s] ', [DateTimeToStr(Now)]) + Format(AFormat, Args));
    AddLog(Format('[%s] ', [DateTimeToStr(Now)]) + Format(AFormat, Args));

  if CnDebugEnable then
    CnDebugger.TraceFmt(AFormat, Args);
end;

initialization
  InitializeCriticalSection(CriticalSection);

finalization
  DeleteCriticalSection(CriticalSection);

end.
