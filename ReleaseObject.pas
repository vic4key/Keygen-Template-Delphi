unit ReleaseObject;

interface

uses Windows;

Procedure DelObject;

implementation

uses VarConst;

Procedure DelObject;
begin
  DeleteObject(hBmpMain);
  DeleteObject(hBmpGenUp);
  DeleteObject(hBmpGenDown);
  DeleteObject(hBmpAboutUp);
  DeleteObject(hBmpAboutDown);
  DeleteObject(hBmpExitUp);
  DeleteObject(hBmpExitDown);
  DeleteObject(hBmpMusicEna);
  DeleteObject(hBmpMusicDis);
  DeleteObject(hBmpCloseUp);
  DeleteObject(hBmpCloseDown);
  DeleteObject(hCurNormal);
  DeleteObject(hCurText);
  DeleteObject(h_Font);
  DeleteObject(h_Icon);
end;

end.
