unit ProcSubClassing;

interface

uses Windows, Messages;

Function EditNameProc(hWdEdit: HWND; uiMsgEdit: UInt; wPrEdit: WParam; lPrEdit: LParam): LRESULT; stdcall;
Function EditSerialProc(hWdEdit: HWND; uiMsgEdit: UInt; wPrEdit: WParam; lPrEdit: LParam): LRESULT; stdcall;
Function BtnGenProc(hWdBtn: HWND; uiMsgBtn: UInt; wPrBtn: WParam; lPrBtn: LParam): LRESULT; stdcall;
Function BtnAboutProc(hWdBtn: HWND; uiMsgBtn: UInt; wPrBtn: WParam; lPrBtn: LParam): LRESULT; stdcall;
Function BtnExitProc(hWdBtn: HWND; uiMsgBtn: UInt; wPrBtn: WParam; lPrBtn: LParam): LRESULT; stdcall;
Function BtnMusicProc(hWdBtn: HWND; uiMsgBtn: UInt; wPrBtn: WParam; lPrBtn: LParam): LRESULT; stdcall;
Function BtnCloseProc(hWdBtn: HWND; uiMsgBtn: UInt; wPrBtn: WParam; lPrBtn: LParam): LRESULT; stdcall;

implementation

uses varconst;

Function EditNameProc(hWdEdit: HWND; uiMsgEdit: UInt; wPrEdit: WParam; lPrEdit: LParam): LRESULT; stdcall;
var ret: LRESULT;
begin
  ret:= 0;
  case uiMsgEdit of
    WM_SETCURSOR:
    begin
      SetCursor(hCurText);
    end
    else ret:= CallWindowProcA(pEditNameProc,hWdEdit,uiMsgEdit,wPrEdit,lPrEdit);
  end;
  Result:= ret;
end;

Function EditSerialProc(hWdEdit: HWND; uiMsgEdit: UInt; wPrEdit: WParam; lPrEdit: LParam): LRESULT; stdcall;
var ret: LRESULT;
begin
  ret:= 0;
  case uiMsgEdit of
    WM_SETCURSOR:
    begin
      SetCursor(hCurText);
    end
    else ret:= CallWindowProcA(pEditSerialProc,hWdEdit,uiMsgEdit,wPrEdit,lPrEdit);
  end;
  Result:= ret;
end;

Function BtnGenProc(hWdBtn: HWND; uiMsgBtn: UInt; wPrBtn: WParam; lPrBtn: LParam): LRESULT; stdcall;
var ret: LRESULT;
begin
  ret:= 0;
  case uiMsgBtn of
    WM_SETCURSOR:
    begin
      SetCursor(hCurNormal);
    end
    else ret:= CallWindowProcA(pBtnGenProc,hWdBtn,uiMsgBtn,wPrBtn,lPrBtn);
  end;
  Result:= ret;
end;

Function BtnAboutProc(hWdBtn: HWND; uiMsgBtn: UInt; wPrBtn: WParam; lPrBtn: LParam): LRESULT; stdcall;
var ret: LRESULT;
begin
  ret:= 0;
  case uiMsgBtn of
    WM_SETCURSOR:
    begin
      SetCursor(hCurNormal);
    end
    else ret:= CallWindowProcA(pBtnAboutProc,hWdBtn,uiMsgBtn,wPrBtn,lPrBtn);
  end;
  Result:= ret;
end;

Function BtnExitProc(hWdBtn: HWND; uiMsgBtn: UInt; wPrBtn: WParam; lPrBtn: LParam): LRESULT; stdcall;
var ret: LRESULT;
begin
  ret:= 0;
  case uiMsgBtn of
    WM_SETCURSOR:
    begin
      SetCursor(hCurNormal);
    end
    else ret:= CallWindowProcA(pBtnExitProc,hWdBtn,uiMsgBtn,wPrBtn,lPrBtn);
  end;
  Result:= ret;
end;

Function BtnMusicProc(hWdBtn: HWND; uiMsgBtn: UInt; wPrBtn: WParam; lPrBtn: LParam): LRESULT; stdcall;
var ret: LRESULT;
begin
  ret:= 0;
  case uiMsgBtn of
    WM_SETCURSOR:
    begin
      SetCursor(hCurNormal);
    end
    else ret:= CallWindowProcA(pBtnMusicProc,hWdBtn,uiMsgBtn,wPrBtn,lPrBtn);
  end;
  Result:= ret;
end;

Function BtnCloseProc(hWdBtn: HWND; uiMsgBtn: UInt; wPrBtn: WParam; lPrBtn: LParam): LRESULT; stdcall;
var ret: LRESULT;
begin
  ret:= 0;
  case uiMsgBtn of
    WM_SETCURSOR:
    begin
      SetCursor(hCurNormal);
    end
    else ret:= CallWindowProcA(pBtnCloseProc,hWdBtn,uiMsgBtn,wPrBtn,lPrBtn);
  end;
  Result:= ret;
end;

end.
