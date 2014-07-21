{*******************************************************}
{                                                       }
{       CodeGear Delphi Visual Component Library        }
{                                                       }
{           Copyright (c) 1995-2007 CodeGear            }
{                                                       }
{*******************************************************}

unit untClipboard;

{$R-,T-,H+,X+}

interface

{$IFDEF LINUX}
uses WinUtils, Windows, Messages, Classes, Graphics;
{$ENDIF}
{$IFDEF MSWINDOWS}
uses Windows, Messages, Classes, Graphics;
{$ENDIF}

var
  CF_PICTURE: Word;
  CF_COMPONENT: Word;

{ TClipboard }

{ The clipboard object encapsulates the Windows clipboard.

  Assign - Assigns the given object to the clipboard.  If the object is
    a TPicture or TGraphic desendent it will be placed on the clipboard
    in the corresponding format (e.g. TBitmap will be placed on the
    clipboard as a CF_BITMAP). Picture.Assign(Clipboard) and
    Bitmap.Assign(Clipboard) are also supported to retrieve the contents
    of the clipboard.
  Clear - Clears the contents of the clipboard.  This is done automatically
    when the clipboard object adds data to the clipboard.
  Close - Closes the clipboard if it is open.  Open and close maintain a
    count of the number of times the clipboard has been opened.  It will
    not actually close the clipboard until it has been closed the same
    number of times it has been opened.
  Open - Open the clipboard and prevents all other applications from changeing
    the clipboard.  This is call is not necessary if you are adding just one
    item to the clipboard.  If you need to add more than one format to
    the clipboard, call Open.  After all the formats have been added. Call
    close.
  HasFormat - Returns true if the given format is available on the clipboard.
  GetAsHandle - Returns the data from the clipboard in a raw Windows handled
    for the specified format.  The handle is not owned by the application and
    the data should be copied.
  SetAsHandle - Places the handle on the clipboard in the given format.  Once
    a handle has been given to the clipboard it should *not* be deleted.  It
    will be deleted by the clipboard.
  GetTextBuf - Retrieves
  AsText - Allows placing and retrieving text from the clipboard.  This property
    is valid to retrieve if the CF_TEXT format is available.
  FormatCount - The number of formats in the Formats array.
  Formats - A list of all the formats available on the clipboard. }

type
  TClipboard = class(TPersistent)
  private
    FOpenRefCount: Integer;
    FClipboardWindow: HWND;
    FAllocated: Boolean;
    FEmptied: Boolean;
    procedure Adding;
    procedure AssignGraphic(Source: TGraphic);
    procedure AssignPicture(Source: TPicture);
    procedure AssignToBitmap(Dest: TBitmap);
    procedure AssignToMetafile(Dest: TMetafile);
    procedure AssignToPicture(Dest: TPicture);
    function GetAsText: string;
    function GetClipboardWindow: HWND;
    function GetFormatCount: Integer;
    function GetFormats(Index: Integer): Word;
    procedure SetAsText(const Value: string);
    function GetAsUnicodeText: string;
    procedure SetAsUnicodeText(const Value: string);
  protected
    procedure AssignTo(Dest: TPersistent); override;
    procedure SetBuffer(Format: Word; var Buffer; Size: Integer);
    procedure WndProc(var Message: TMessage); virtual;
    procedure MainWndProc(var Message: TMessage);
    property Handle: HWND read GetClipboardWindow;
    property OpenRefCount: Integer read FOpenRefCount;
  public
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure Clear; virtual;
    procedure Close; virtual;
    function GetComponent(Owner, Parent: TComponent): TComponent;
    function GetAsHandle(Format: Word): THandle;
    function GetTextBuf(Buffer: PChar; BufSize: Integer): Integer;
    function HasFormat(Format: Word): Boolean;
    procedure Open; virtual;
    procedure SetComponent(Component: TComponent);
    procedure SetAsHandle(Format: Word; Value: THandle);
    procedure SetTextBuf(Buffer: PChar);
    property AsText: string read GetAsText write SetAsText;
    property AsUnicodeText: string read GetAsUnicodeText write SetAsUnicodeText;
    property FormatCount: Integer read GetFormatCount;
    property Formats[Index: Integer]: Word read GetFormats;
  end;

function Clipboard: TClipboard;
function SetClipboard(NewClipboard: TClipboard): TClipboard;

implementation

uses SysUtils, Forms, Consts;

procedure TClipboard.Clear;
begin
  Open;
  try
    EmptyClipboard;
  finally
    Close;
  end;
end;

procedure TClipboard.Adding;
begin
  if (FOpenRefCount <> 0) and not FEmptied then
  begin
    Clear;
    FEmptied := True;
  end;
end;

procedure TClipboard.Close;
begin
  if FOpenRefCount = 0 then Exit;
  Dec(FOpenRefCount);
  if FOpenRefCount = 0 then
  begin
    CloseClipboard;
    if FAllocated then
{$IFDEF MSWINDOWS}       
      Classes.DeallocateHWnd(FClipboardWindow);
{$ENDIF}
{$IFDEF LINUX}
      WinUtils.DeallocateHWnd(FClipboardWindow);
{$ENDIF}     
    FClipboardWindow := 0;
  end;
end;

procedure TClipboard.Open;
begin
  if FOpenRefCount = 0 then
  begin
    FClipboardWindow := Application.Handle;
    if FClipboardWindow = 0 then
    begin
{$IFDEF MSWINDOWS}
      FClipboardWindow := Classes.AllocateHWnd(MainWndProc);
{$ENDIF}
{$IFDEF LINUX}
      FClipboardWindow := WinUtils.AllocateHWnd(MainWndProc);
{$ENDIF}       
      FAllocated := True;
    end;
    if not OpenClipboard(FClipboardWindow) then
      raise Exception.CreateRes(@SCannotOpenClipboard);
    FEmptied := False;
  end;
  Inc(FOpenRefCount);
end;

procedure TClipboard.WndProc(var Message: TMessage);
begin
  with Message do
    Result := DefWindowProc(FClipboardWindow, Msg, wParam, lParam);
end;

function TClipboard.GetComponent(Owner, Parent: TComponent): TComponent;
var
  Data: THandle;
  DataPtr: Pointer;
  MemStream: TMemoryStream;
  Reader: TReader;
begin
  Result := nil;
  Open;
  try
    Data := GetClipboardData(CF_COMPONENT);
    if Data = 0 then Exit;
    DataPtr := GlobalLock(Data);
    if DataPtr = nil then Exit;
    try
      MemStream := TMemoryStream.Create;
      try
        MemStream.WriteBuffer(DataPtr^, GlobalSize(Data));
        MemStream.Position := 0;
        Reader := TReader.Create(MemStream, 256);
        try
          Reader.Parent := Parent;
          Result := Reader.ReadRootComponent(nil);
          try
            if Owner <> nil then
              Owner.InsertComponent(Result);
          except
            Result.Free;
            raise;
          end;
        finally
          Reader.Free;
        end;
      finally
        MemStream.Free;
      end;
    finally
      GlobalUnlock(Data);
    end;
  finally
    Close;
  end;
end;

procedure TClipboard.SetBuffer(Format: Word; var Buffer; Size: Integer);
var
  Data: THandle;
  DataPtr: Pointer;
begin
  Open;
  try
    Data := GlobalAlloc(GMEM_MOVEABLE+GMEM_DDESHARE, Size);
    try
      DataPtr := GlobalLock(Data);
      try
        Move(Buffer, DataPtr^, Size);
        Adding;
        SetClipboardData(Format, Data);
      finally
        GlobalUnlock(Data);
      end;
    except
      GlobalFree(Data);
      raise;
    end;
  finally
    Close;
  end;
end;

procedure TClipboard.SetComponent(Component: TComponent);
var
  MemStream: TMemoryStream;
begin
  MemStream := TMemoryStream.Create;
  try
    MemStream.WriteComponent(Component);
    SetBuffer(CF_COMPONENT, MemStream.Memory^, MemStream.Size);
  finally
    MemStream.Free;
  end;
end;

function TClipboard.GetTextBuf(Buffer: PChar; BufSize: Integer): Integer;
var
  Data: THandle;
begin
  Open;
  Data := GetClipboardData(CF_TEXT);
  if Data = 0 then Result := 0 else
  begin
    Result := StrLen(StrLCopy(Buffer, GlobalLock(Data), BufSize - 1));
    GlobalUnlock(Data);
  end;
  Close;
end;

procedure TClipboard.SetTextBuf(Buffer: PChar);
begin
  SetBuffer(CF_TEXT, Buffer^, StrLen(Buffer) + 1);
end;

function TClipboard.GetAsText: string;
var
  Data: THandle;
begin
  Open;
  Data := GetClipboardData(CF_TEXT);
  try
    if Data <> 0 then
      Result := PChar(GlobalLock(Data))
    else
      Result := '';
  finally
    if Data <> 0 then GlobalUnlock(Data);
    Close;
  end;
end;

function TClipboard.GetAsUnicodeText: string;
var
  Data: THandle;
  strUnicode: WideString;
begin
  // ET Worker: Ö§³ÖUnicode
  Result := '';

  Open;
  Data := GetClipboardData(CF_UNICODETEXT{CF_TEXT});
  try
    if Data <> 0 then
      strUnicode := PWideChar{PChar}(GlobalLock(Data))
    else
      strUnicode := '';

    Result := strUnicode;
  finally
    if Data <> 0 then GlobalUnlock(Data);
    Close;
  end;
end;

function TClipboard.GetClipboardWindow: HWND;
begin
  if FClipboardWindow = 0 then
    Open;
  Result := FClipboardWindow;
end;

procedure TClipboard.SetAsText(const Value: string);
begin
  SetBuffer(CF_TEXT, PChar(Value)^, Length(Value) + 1);
end;

procedure TClipboard.SetAsUnicodeText(const Value: String);
var
  Data: THandle;
  DataPtr: Pointer;
  Size: Integer;
  WStr: PWideChar;
begin
  Size := Length(Value) * 4;
  WStr := AllocMem(Size);
  try
    // convert to Unicode
    StringToWideChar(Value, WStr, Size);
    OpenClipboard(0);
    EmptyClipboard;
    Data := GlobalAlloc(GMEM_MOVEABLE+GMEM_DDESHARE, Size);
    try
      DataPtr := GlobalLock(Data);
      try
        Move(WStr^, DataPtr^, Size);
        SetClipboardData(CF_UNICODETEXT, Data);
      finally
        GlobalUnlock(Data);
      end;
    except
      GlobalFree(Data);
      raise;
    end;
  finally
    CloseClipboard;
    FreeMem(WStr);
  end;
end;

procedure TClipboard.AssignToPicture(Dest: TPicture);
var
  Data: THandle;
  Format: Word;
  Palette: HPALETTE;
begin
  Open;
  try
    Format := EnumClipboardFormats(0);
    while Format <> 0 do
    begin
      if TPicture.SupportsClipboardFormat(Format) then
      begin
        Data := GetClipboardData(Format);
        Palette := GetClipboardData(CF_PALETTE);
        Dest.LoadFromClipboardFormat(Format, Data, Palette);
        Exit;
      end;
      Format := EnumClipboardFormats(Format);
    end;
    raise Exception.CreateRes(@SInvalidClipFmt);
  finally
    Close;
  end;
end;

procedure TClipboard.AssignToBitmap(Dest: TBitmap);
var
  Data: THandle;
  Palette: HPALETTE;
begin
  Open;
  try
    Data := GetClipboardData(CF_BITMAP);
    Palette := GetClipboardData(CF_PALETTE);
    Dest.LoadFromClipboardFormat(CF_BITMAP, Data, Palette);
  finally
    Close;
  end;
end;

procedure TClipboard.AssignToMetafile(Dest: TMetafile);
var
  Data: THandle;
  Palette: HPALETTE;
begin
  Open;
  try
    Data := GetClipboardData(CF_METAFILEPICT);
    Palette := GetClipboardData(CF_PALETTE);
    Dest.LoadFromClipboardFormat(CF_METAFILEPICT, Data, Palette);
  finally
    Close;
  end;
end;

procedure TClipboard.AssignTo(Dest: TPersistent);
begin
  if Dest is TPicture then
    AssignToPicture(TPicture(Dest))
  else if Dest is TBitmap then
    AssignToBitmap(TBitmap(Dest))
  else if Dest is TMetafile then
    AssignToMetafile(TMetafile(Dest))
  else inherited AssignTo(Dest);
end;

procedure TClipboard.AssignPicture(Source: TPicture);
var
  Data: THandle;
  Format: Word;
  Palette: HPALETTE;
begin
  Open;
  try
    Adding;
    Palette := 0;
    Source.SaveToClipboardFormat(Format, Data, Palette);
    SetClipboardData(Format, Data);
    if Palette <> 0 then SetClipboardData(CF_PALETTE, Palette);
  finally
    Close;
  end;
end;

procedure TClipboard.AssignGraphic(Source: TGraphic);
var
  Data: THandle;
  Format: Word;
  Palette: HPALETTE;
begin
  Open;
  try
    Adding;
    Palette := 0;
    Source.SaveToClipboardFormat(Format, Data, Palette);
    SetClipboardData(Format, Data);
    if Palette <> 0 then SetClipboardData(CF_PALETTE, Palette);
  finally
    Close;
  end;
end;

procedure TClipboard.Assign(Source: TPersistent);
begin
  if Source is TPicture then
    AssignPicture(TPicture(Source))
  else if Source is TGraphic then
    AssignGraphic(TGraphic(Source))
  else inherited Assign(Source);
end;

function TClipboard.GetAsHandle(Format: Word): THandle;
begin
  Open;
  try
    Result := GetClipboardData(Format);
  finally
    Close;
  end;
end;

procedure TClipboard.SetAsHandle(Format: Word; Value: THandle);
begin
  Open;
  try
    Adding;
    SetClipboardData(Format, Value);
  finally
    Close;
  end;
end;

function TClipboard.GetFormatCount: Integer;
begin
  Result := CountClipboardFormats;
end;

function TClipboard.GetFormats(Index: Integer): Word;
begin
  Open;
  try
    Result := EnumClipboardFormats(0);
    while Index > 0 do
    begin
      Dec(Index);
      Result := EnumClipboardFormats(Result);
    end;
  finally
    Close;
  end;
end;

function TClipboard.HasFormat(Format: Word): Boolean;

  function HasAPicture: Boolean;
  var
    Format: Word;
  begin
    Open;
    try
      Result := False;
      Format := EnumClipboardFormats(0);
      while Format <> 0 do
        if TPicture.SupportsClipboardFormat(Format) then
        begin
          Result := True;
          Break;
        end
        else Format := EnumClipboardFormats(Format);
    finally
      Close;
    end;
  end;

begin
  Result := IsClipboardFormatAvailable(Format) or ((Format = CF_PICTURE) and
    HasAPicture);
end;


var
  FClipboard: TClipboard;

function Clipboard: TClipboard;
begin
  if FClipboard = nil then
    FClipboard := TClipboard.Create;
  Result := FClipboard;
end;

function SetClipboard(NewClipboard: TClipboard): TClipboard;
begin
  Result := FClipboard;
  FClipboard := NewClipboard;
end;

procedure TClipboard.MainWndProc(var Message: TMessage);
begin
  try
    WndProc(Message);
  except
    if Assigned(ApplicationHandleException) then
      ApplicationHandleException(Self)
    else
      raise;
  end;
end;

destructor TClipboard.Destroy;
begin
  if (FClipboard = Self) then
    FClipboard := nil;
  inherited Destroy;
end;

initialization
  { The following strings should not be localized }
  CF_PICTURE := RegisterClipboardFormat('Delphi Picture');
  CF_COMPONENT := RegisterClipboardFormat('Delphi Component');
  FClipboard := nil;
finalization
  FClipboard.Free;
end.

