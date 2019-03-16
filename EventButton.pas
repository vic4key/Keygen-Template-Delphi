unit eventButton;

interface

uses Windows, SysUtils;

const
  ID_TXTNAME   = 1001;
  ID_TXTSERIAL = 1002;

Procedure GenOnClick(MainHandle: HWND); stdcall;

implementation

uses mrvic;

Procedure GenOnClick(MainHandle: HWND); stdcall;
var
  pName: PAnsiChar;
  szName: String;
const MAX_TEXTSIZE = 256;
begin
  pName:= AllocMem(MAX_TEXTSIZE);
  GetDlgItemTextA(MainHandle,ID_TXTNAME,pName,MAX_TEXTSIZE);
  szName:= StrPas(pName);
  SetDlgItemTextA(MainHandle,ID_TXTSERIAL,pName);
end;

end.
