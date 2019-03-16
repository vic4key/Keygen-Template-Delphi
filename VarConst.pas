unit varconst;

interface

uses Windows;

type
  TCtlInfo = record
    pClassName: PAnsiChar;
    iX: Integer;
    iY: Integer;
    iWidth: Integer;
    iHeight: Integer;
  end;

const
  WND_TITLE   = 'Windows API (c) vic4key';
  IDE_NAME    = 1001;
  IDE_SERIAL  = 1002;
  IDB_GEN     = 1003;
  IDB_ABOUT   = 1004;
  IDB_EXIT    = 1005;
  IDB_MUSIC   = 1006;
  IDD_ABOUT   = 1010;
  IDB_CLOSE   = 1011;

  IDT_ONE     = 101;
  IDT_TWO     = 102;

  TEXT_SCROLL = 'Template keygen was coded by vic4key {CiN1}';
  
  CRLF = #13#10;
  TXT_SOFTNAME = 'None';
  TXT_PRT      = 'None';
  TXT_AUTHOR   = 'vic4key';
  TXT_TEAM     = 'CiN1';
  TXT_CODEIN   = 'Borland Delphi';
  TXT_HPAGE    = 'www.cin1team.biz';
  TXT_GRRE     = 'CiN1, REA, SnD, AT4RE, iNF';  

  TMain: TCtlInfo = (pClassName: 'Windows API'; iX: 0; iY: 0; iWidth: 350; iHeight: 270);
  TEdit: TCtlInfo = (pClassName: 'EDIT'; iX: 93; iY: 98; iWidth: 210; iHeight: 16);
  TBtn:  TCtlInfo = (pClassName: 'BUTTON'; iX: 100; iY: 180; iWidth: 67; iHeight: 27);

var
  h_Inst: HInst;
  wcl: TWndClassA;
  msg: TMsg;

  hMain, hMainAbout: HWND;
  hEditName, hEditSerial: HWND;
  hBtnGen, hBtnAbout, hBtnExit, hBtnMusic, hBtnClose: HWND;

  pEditNameProc, pEditSerialProc: Pointer;
  pBtnGenProc, pBtnAboutProc, pBtnExitProc, pBtnMusicProc, pBtnCloseProc: Pointer;

  hMemDcMain, hMemCtl, ChildDc, hMemDcAbout, hMemAboutCtl, hDcBtn, hMemDcBtn: HDC;

  hCurNormal, hCurText: HCURSOR;

  h_Font: HFONT;
  h_Icon: HICON;

  hBmpMain, hBmpAbout: HBITMAP;
  hBmpGenUp, hBmpGenDown: HBITMAP;
  hBmpAboutUp, hBmpAboutDown: HBITMAP;
  hBmpExitUp, hBmpExitDown: HBITMAP;
  hBmpMusicEna, hBmpMusicDis: HBITMAP;
  hBmpCloseUp, hBmpCloseDown: HBITMAP;

  Left: Integer = 330;
  Top:  Integer = 195;
  
  MusicPlaying: Boolean = True;

  size: TSize;

  ARR_TXTINFO: array[1..10] of String  = (
  'Software: '   + TXT_SOFTNAME,
  'Protection: ' + TXT_PRT,
  'Keygen (c) '  + TXT_AUTHOR,
  'Graphic: '    + TXT_AUTHOR,
  'Team: '       + TXT_TEAM,
  'Code in '     + TXT_CODEIN,
  'Home page: '  + TXT_HPAGE,
  CRLF,
  'Greetings',
  TXT_GRRE);

implementation

end.
