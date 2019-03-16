program Keygen;

uses
  Windows,
  SysUtils,
  Messages,
  eventButton in 'eventButton.pas',
  ProcSubClassing in 'ProcSubClassing.pas',
  About in 'About.pas',
  uFMOD in 'FMoD\uFMOD.pas',
  ReleaseObject in 'ReleaseObject.pas',
  mrVic in 'mrVic.pas',
  VarConst in 'VarConst.pas';

{$R vic\main_rgn.res}
{$R vic\bmp_data.res}
{$R vic\cur_data.res}
{$R vic\vic_icon.res}
{$R vic\about.res}

{$I 'FMoD\Music.pas'}

Function WndProc(hWd: HWND; uiMsg: UInt; wPr: WParam; lPr: LParam): LRESULT; stdcall;
var
  ret: LRESULT;
  ps: TPaintStruct;
  dis: TDrawItemStruct;
  rct: TRect;
begin
  ret:= 0;
  case uiMsg of
    {$REGION 'WM_CREATE'}
    WM_CREATE:
    begin
      SetCursor(hCurNormal);

      //AnimateWindow(hWd,1000,AW_SLIDE or AW_CENTER);

      hEditName:= CreateWindowA(
        TEdit.pClassName,
        'Shim Ji Young',
        WS_CHILD or WS_VISIBLE or ES_CENTER or ES_AUTOHSCROLL,
        TEdit.iX,
        TEdit.iY,
        TEdit.iWidth,
        TEdit.iHeight,
        hWd,
        IDE_NAME,
        h_Inst,
        NIL);

      hEditSerial:= CreateWindowA(
        TEdit.pClassName,
        '',
        WS_CHILD or WS_VISIBLE or ES_CENTER or ES_AUTOHSCROLL,
        TEdit.iX,
        TEdit.iY + 46,
        TEdit.iWidth,
        TEdit.iHeight,
        hWd,
        IDE_SERIAL,
        h_Inst,
        NIL);

      hBtnGen:= CreateWindowA(
        TBtn.pClassName,
        '',
        WS_CHILD or WS_VISIBLE or BS_OWNERDRAW,
        TBtn.iX,
        TBtn.iY,
        TBtn.iWidth,
        TBtn.iHeight,
        hWd,
        IDB_GEN,
        h_Inst,
        NIL);

      hBtnAbout:= CreateWindowA(
        TBtn.pClassName,
        '',
        WS_CHILD or WS_VISIBLE or BS_OWNERDRAW,
        TBtn.iX + 1*(TBtn.iWidth + 2),
        TBtn.iY,
        TBtn.iWidth,
        TBtn.iHeight,
        hWd,
        IDB_ABOUT,
        h_Inst,
        NIL);

      hBtnExit:= CreateWindowA(
        TBtn.pClassName,
        '',
        WS_CHILD or WS_VISIBLE or BS_OWNERDRAW,
        TBtn.iX + 2*(TBtn.iWidth + 2),
        TBtn.iY,
        TBtn.iWidth,
        TBtn.iHeight,
        hWd,
        IDB_EXIT,
        h_Inst,
        NIL);

      hBtnMusic:= CreateWindowA(
        TBtn.pClassName,
        '',
        WS_CHILD or WS_VISIBLE or BS_BITMAP or BS_FLAT,
        TBtn.iX - 58,
        TBtn.iY + 1,
        TBtn.iWidth - 16,
        TBtn.iHeight -2,
        hWd,
        IDB_MUSIC,
        h_Inst,
        NIL);

      h_Font:= CreateFontA(
        17, // nHeight
        0,  // nWidth
        GM_COMPATIBLE,
        0,
        FW_DONTCARE,
        Integer(False), // fdwItalic
        Integer(False), // fdwUnderline
        Integer(False), // fdwStrikeOut
        DEFAULT_CHARSET,
        OUT_DEFAULT_PRECIS,
        CLIP_DEFAULT_PRECIS,
        DEFAULT_QUALITY,
        DEFAULT_PITCH,
        'Courier');

      SendMessageA(hWd,WM_SETFONT,h_Font,LParam(True));
      SendMessageA(hEditName,WM_SETFONT,h_Font,LParam(True));
      SendMessageA(hEditSerial,WM_SETFONT,h_Font,LParam(True));
      SendMessageA(hEditName,WM_SETFONT,h_Font,LParam(True));
      SendMessageA(hBtnGen,WM_SETFONT,h_Font,LParam(True));
      SendMessageA(hBtnAbout,WM_SETFONT,h_Font,LParam(True));
      SendMessageA(hBtnExit,WM_SETFONT,h_Font,LParam(True));

      SetRegion(h_Inst,hWd,'MAIN_RGN',RT_RCDATA);

      SetLayered(hWd,20);

      SetFocus(hEditName);

      SetTimer(hWd,IDT_ONE,10,NIL);

      SendMessageA(hBtnMusic,BM_SETIMAGE,IMAGE_BITMAP,LParam(hBmpMusicEna));

      SendMessageA(hEditSerial, EM_SETREADONLY, 1, 0);

      uFMOD_PlaySong(@TrackFile,Length(TrackFile),XM_MEMORY);

      pBtnGenProc:= Pointer(SetWindowLongA(hBtnGen,GWL_WNDPROC,Integer(@BtnGenProc)));
      pBtnAboutProc:= Pointer(SetWindowLongA(hBtnAbout,GWL_WNDPROC,Integer(@BtnAboutProc)));
      pBtnExitProc:= Pointer(SetWindowLongA(hBtnExit,GWL_WNDPROC,Integer(@BtnExitProc)));
      pBtnMusicProc:= Pointer(SetWindowLongA(hBtnMusic,GWL_WNDPROC,Integer(@BtnMusicProc)));
      pEditNameProc:= Pointer(SetWindowLongA(hEditName,GWL_WNDPROC,Integer(@EditNameProc)));
      pEditSerialProc:= Pointer(SetWindowLongA(hEditSerial,GWL_WNDPROC,Integer(@EditSerialProc)));
    end;
    {$ENDREGION}

    {$REGION 'WM_DRAWITEM'}
    WM_DRAWITEM:
    begin
      dis:= TDrawItemStruct(Pointer(lPr)^);
      hMemCtl:= CreateCompatibleDC(dis.hDC);
      case dis.CtlID of
        IDB_GEN:
        begin
          if ((dis.itemID and ODS_SELECTED) <> ODS_SELECTED) then
            SelectObject(hMemCtl,hBmpGenUp)
          else
            SelectObject(hMemCtl,hBmpGenDown);
        end;
        IDB_ABOUT:
        begin
          if ((dis.itemID and ODS_SELECTED) <> ODS_SELECTED) then
            SelectObject(hMemCtl,hBmpAboutUp)
          else
            SelectObject(hMemCtl,hBmpAboutDown);
        end;
        IDB_EXIT:
        begin
          if ((dis.itemID and ODS_SELECTED) <> ODS_SELECTED) then
            SelectObject(hMemCtl,hBmpExitUp)
          else
            SelectObject(hMemCtl,hBmpExitDown);
        end;
      end;

      BitBlt(
        dis.hDC,
        dis.rcItem.Left,
        dis.rcItem.Top,
        dis.rcItem.Right - dis.rcItem.Left,
        dis.rcItem.Bottom - dis.rcItem.Top,
        hMemCtl,
        0,
        0,
        SRCCOPY);
      DeleteDC(hMemCtl);
    end;
    {$ENDREGION}

    {$REGION 'WM_CTLCOLORSTATIC'}
    WM_CTLCOLORSTATIC: // MSDN say: Edit controls that are not read-only or disabled do not send the WM_CTLCOLORSTATIC message; instead, they send the WM_CTLCOLOREDIT message.
    begin
      if (HWND(lPr) = hEditSerial) then
      begin
        SetBkMode(HDC(wPr),TRANSPARENT);
        ret:= GetStockObject(WHITE_BRUSH);
      end;
    end;
    {$ENDREGION}

    {$REGION 'WM_COMMAND'}
    WM_COMMAND:
    begin
      case LoWord(wPr) of
        IDB_GEN:
        begin
          if (HiWord(wPr) = BN_CLICKED) then
          begin
            SetFocus(hWd);
            GenOnClick(hWd);
          end;
        end;
        IDB_ABOUT:
        begin
          if (HiWord(wPr) = BN_CLICKED) then
          begin
            SetFocus(hWd);
            hMainAbout:= DialogBoxParam(h_Inst,MakeIntResource(IDD_ABOUT),hWd,@AboutDlgProc,0);
          end;
        end;
        IDB_EXIT:
        begin
          if (HiWord(wPr) = BN_CLICKED) then
          begin
            uFMOD_StopSong;
            KillTimer(hWd,IDT_ONE);
            DelObject;
            PostQuitMessage(0);
          end;
        end;
        IDB_MUSIC:
        begin
          if (HiWord(wPr) = BN_CLICKED) then
          begin
            if (MusicPlaying = True) then
            begin
              uFMOD_Pause;
              SendMessageA(hBtnMusic,BM_SETIMAGE,IMAGE_BITMAP,LParam(hBmpMusicDis));
            end
            else
            begin
              uFMOD_Resume;
              SendMessageA(hBtnMusic,BM_SETIMAGE,IMAGE_BITMAP,LParam(hBmpMusicEna));
            end;
            SetFocus(hWd);
          end;
          MusicPlaying:= not MusicPlaying;
        end;
      end;
    end;
    {$ENDREGION}

    {$REGION 'WM_PAINT'}
    WM_PAINT:
    begin
      BeginPaint(hWd,ps);
      hMemDcMain:= CreateCompatibleDC(ps.hdc);
      SelectObject(hMemDcMain,hBmpMain);
      BitBlt(ps.hdc,0,0,TMain.iWidth,TMain.iHeight,hMemDcMain,0,0,SRCCOPY);
      DeleteDC(hMemDcMain);
      ps.rcPaint.Right:= 0;
      ps.rcPaint.Bottom:= 0;
      rct:= TRect(Pointer(@ps.rcPaint)^);
      EndPaint(hWd,ps);
    end;
    {$ENDREGION}

    {$REGION 'WM_TIMER'}
    WM_TIMER:
    begin
      ChildDc:= GetDC(hWd);

      SelectObject(ChildDc,h_Font);

      GetTextExtentPoint32A(ChildDc,TEXT_SCROLL,Length(TEXT_SCROLL),size);

      Left:= Left - 1;
      if (Left = -size.cx) then Left:= TMain.iWidth;

      GetClientRect(hWd,rct);
      rct.Left:= 31;
      rct.Top:= 55;
      rct.Right:= 317;
      rct.Bottom:= 74;

      ExtTextOutA(ChildDc,Left,57,ETO_CLIPPED,@rct,TEXT_SCROLL,Length(TEXT_SCROLL),NIL);
      ReleaseDC(hMain,ChildDc);
    end;
    {$ENDREGION}

    {$REGION 'WM_MOUSEMOVE'}
    WM_MOUSEMOVE:
    begin
      hDcBtn:= GetDc(hBtnGen);
      hMemDcBtn:= CreateCompatibleDC(hDcBtn);
      SelectObject(hMemDcBtn,hBmpGenUp);
      BitBlt(hDcBtn,0,0,TBtn.iWidth,TBtn.iHeight,hMemDcBtn,0,0, SRCCOPY);
      ReleaseDC(hBtnGen,hDcBtn);
      DeleteDC(hMemDcBtn);

      hDcBtn:= GetDc(hBtnAbout);
      hMemDcBtn:= CreateCompatibleDC(hDcBtn);
      SelectObject(hMemDcBtn,hBmpAboutUp);
      BitBlt(hDcBtn,0,0,TBtn.iWidth,TBtn.iHeight,hMemDcBtn,0,0, SRCCOPY);
      ReleaseDC(hBtnAbout,hDcBtn);
      DeleteDC(hMemDcBtn);

      hDcBtn:= GetDc(hBtnExit);
      hMemDcBtn:= CreateCompatibleDC(hDcBtn);
      SelectObject(hMemDcBtn,hBmpExitUp);
      BitBlt(hDcBtn,0,0,TBtn.iWidth,TBtn.iHeight,hMemDcBtn,0,0, SRCCOPY);
      ReleaseDC(hBtnExit,hDcBtn);
      DeleteDC(hMemDcBtn);

      SetCursor(hCurNormal);

      MovingWindow(hWd,lPr);
    end;
    {$ENDREGION}

    {$REGION 'WM_DESTROY'}
    WM_DESTROY:
    begin
      uFMOD_StopSong;
      KillTimer(hWd,IDT_ONE);
      DelObject;
      PostQuitMessage(0);
    end;
    {$ENDREGION}
    else ret:= DefWindowProc(hWd,uiMsg,wPr,lPr);
  end;
  Result:= ret;
end;

begin
  h_Inst:= GetModuleHandleA(NIL);
  
  hBmpMain:= LoadBitmapA(h_Inst,MakeIntResource('MAIN_BMP'));
  hBmpAbout:= LoadBitmapA(h_Inst,MakeIntResource('ABOUT_BMP'));

  hBmpGenUp:= LoadBitmapA(h_Inst,MakeIntResource('GEN_UP'));
  hBmpGenDown:= LoadBitmapA(h_Inst,MakeIntResource('GEN_DOWN'));

  hBmpAboutUp:= LoadBitmapA(h_Inst,MakeIntResource('ABOUT_UP'));
  hBmpAboutDown:= LoadBitmapA(h_Inst,MakeIntResource('ABOUT_DOWN'));

  hBmpExitUp:= LoadBitmapA(h_Inst,MakeIntResource('EXIT_UP'));
  hBmpExitDown:= LoadBitmapA(h_Inst,MakeIntResource('EXIT_DOWN'));

  hBmpMusicEna:= LoadBitmapA(h_Inst,MakeIntResource('MUSIC_ENA'));
  hBmpMusicDis:= LoadBitmapA(h_Inst,MakeIntResource('MUSIC_DIS'));

  hBmpCloseUp:= LoadBitmapA(h_Inst,MakeIntResource('CLOSE_UP'));
  hBmpCloseDown:= LoadBitmapA(h_Inst,MakeIntResource('CLOSE_DOWN'));

  hCurNormal:= LoadCursorA(h_Inst,MakeIntResource('NORMAL_CUR'));
  hCurText:= LoadCursorA(h_Inst,MakeIntResource('TEXT_CUR'));

  h_Icon:= LoadIconA(h_Inst,MakeIntResource(3));

  wcl.style:= CS_VREDRAW or CS_HREDRAW;
  wcl.lpfnWndProc:= @WndProc;
  wcl.cbClsExtra:= 0;
  wcl.cbWndExtra:= 0;
  wcl.hInstance:= h_Inst;
  wcl.hIcon:= h_Icon;
  wcl.hCursor:= hCurNormal;
  wcl.hbrBackground:= GetStockObject(WHITE_BRUSH);
  wcl.lpszMenuName:= '';
  wcl.lpszClassName:= TMain.pClassName;

  if (RegisterClassA(wcl) = 0) then
  begin
    fmMsgA('RegisterClassA:Failure');
    Exit;
  end;

  hMain:= CreateWindowExA(
    WS_EX_TOPMOST,
    TMain.pClassName,
    WND_TITLE,
    WS_POPUP,
    (GetSystemMetrics(SM_CXSCREEN) div 2) - (TMain.iWidth div 2),
    (GetSystemMetrics(SM_CYSCREEN) div 2) - (TMain.iHeight div 2),
    TMain.iWidth,
    TMain.iHeight,
    HWND(0),
    HMENU(0),
    h_Inst,
    NIL);
  if (hMain = 0) then
  begin
    fmMsgA('CreateWindowA::Main:Failure');
    Exit;
  end;

  ShowWindow(hMain,SW_SHOWNORMAL);
  UpdateWindow(hMain);

  while GetMessageA(msg,0,0,0) do
  begin
    TranslateMessage(msg);
    DispatchMessageA(msg);
  end;
end.
