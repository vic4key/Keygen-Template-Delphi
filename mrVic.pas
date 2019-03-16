unit mrvic;

interface

uses Windows, SysUtils, Messages;

Procedure fmMsgA(szFormat: String; arrConst: array of const); stdcall; overload;
Procedure fmMsgA(szText: String); stdcall; overload;
Procedure SetRegion(hInstance: HInst; Handle: HWND; pResName, pResType: PAnsiChar); stdcall;
Procedure MovingWindow(Handle: HWND; lPr: LParam); stdcall;
Function SetLayered(Wnd: HWND; nAlpha: Integer = 0): Boolean; stdcall;

implementation

Function SetLayered(Wnd: HWND; nAlpha: Integer = 0): Boolean; stdcall;
type
  TSetLayeredWindowAttributes = function(
    hwnd: HWND;
    crKey: COLORREF;
    bAlpha: Byte;
    dwFlags: Longint): LongInt; stdcall;
const
  LWA_COLORKEY = 9;
  LWA_ALPHA = 2;
  WS_EX_LAYERED = $80000;
var
  hUser32: HMODULE;
  SetLayeredWindowAttributes: TSetLayeredWindowAttributes;
begin
  Result:= False;
  hUser32:= GetModuleHandle('USER32.DLL');
  if (hUser32 <> 0) then
  begin
    @SetLayeredWindowAttributes:= GetProcAddress(hUser32,'SetLayeredWindowAttributes');
    if (@SetLayeredWindowAttributes <> NIL) then
    begin
      SetWindowLong(Wnd,GWL_EXSTYLE,GetWindowLong(Wnd,GWL_EXSTYLE) or WS_EX_LAYERED);
      SetLayeredWindowAttributes(Wnd,0,Trunc((255 / 100)*(100 - nAlpha)),LWA_ALPHA);
      Result:= True;
    end;
  end;
end;

Procedure MovingWindow(Handle: HWND; lPr: LParam); stdcall;
begin
  ReleaseCapture;
  SendMessage(Handle,WM_SYSCOMMAND,SC_MOVE or 2,lPr);
end;

Procedure SetRegion(hInstance: HInst; Handle: HWND; pResName, pResType: PAnsiChar); stdcall;
var
  hRes: HRsrc;
  hGlb: HGlobal;
  pRgn: PRgnData;
  cbRes: DWord;
  rgn: HRgn;
begin
  hRes:= FindResource(hInstance,pResName,pResType);
  hGlb:= LoadResource(hInstance,hRes);
  cbRes:= SizeOfResource(hInstance,hres);
  pRgn:= LockResource(hGlb);
  rgn:= ExtCreateRegion(NIL,cbRes,pRgn^);
  SetWindowRgn(Handle,rgn,True);
end;

Procedure fmMsgA(szFormat: String; arrConst: array of const); stdcall; overload;
var fm: String;
begin
  fm:= Format(szFormat,arrConst);
  MessageBoxA(0,PAnsiChar(fm),PAnsiChar(''),MB_ICONINFORMATION);
end;

Procedure fmMsgA(szText: String); stdcall; overload;
begin
  MessageBoxA(0,PAnsiChar(szText),PAnsiChar(''),MB_ICONINFORMATION);
end;

end.
