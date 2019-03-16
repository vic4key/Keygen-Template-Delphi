unit About;

interface

uses Windows, Messages;

Function AboutDlgProc(hWdAbout: HWND; uiMsgAbout: UInt; wPrAbout: WParam; lPrAbout: LParam): LRESULT; stdcall;

implementation

uses VarConst, mrVic, ProcSubClassing;

Function AboutDlgProc(hWdAbout: HWND; uiMsgAbout: UInt; wPrAbout: WParam; lPrAbout: LParam): LRESULT; stdcall;
var
  ret: LRESULT;
  ps: TPaintStruct;
  dis: TDrawItemStruct;
  rc: TRect;
  i: Integer;
begin
  ret:= 0;
  case uiMsgAbout of
    {$REGION 'WM_INITDIALOG'}
    WM_INITDIALOG:
    begin
      //AnimateWindow(hWdAbout,1000,AW_SLIDE or AW_ACTIVATE);

      hBtnClose:= CreateWindowA(
        TBtn.pClassName,
        '',
        WS_CHILD or WS_VISIBLE or BS_OWNERDRAW,
        TBtn.iX + 50,
        TBtn.iY + 29,
        61,
        15,
        hWdAbout,
        IDB_CLOSE,
        h_Inst,
        NIL);

      SetRegion(h_Inst,hWdAbout,'ABOUT_RGN',RT_RCDATA);
      SetLayered(hWdAbout,20);

      pBtnCloseProc:= Pointer(SetWindowLongA(hBtnClose,GWL_WNDPROC,Integer(@BtnCloseProc)));

      SetTimer(hWdAbout,IDT_TWO,20,NIL);
    end;
    {$ENDREGION}

    {$REGION 'WM_TIMER'}
    WM_TIMER:
    begin
      ChildDc:= GetDC(hWdAbout);

      SelectObject(ChildDc,h_Font);

      GetClientRect(hWdAbout,rc);

      GetTextExtentPoint32A(ChildDc,PAnsiChar(ARR_TXTINFO[1]),Length(ARR_TXTINFO[1]),size);

      Top:= Top - 1;
      if (Top = -(High(ARR_TXTINFO)*size.cy)) then Top:= 200;

      rc.Left:= 44;
      rc.Top:= 43;
      rc.Right:= 322;
      rc.Bottom:= 201;
      SelectObject(ChildDc,WHITE_BRUSH);
      FillRect(ChildDc,rc,WHITE_BRUSH);

      for i:= 1 to High(ARR_TXTINFO) do
      begin
        GetTextExtentPoint32A(ChildDc,PAnsiChar(ARR_TXTINFO[i]),Length(ARR_TXTINFO[i]),size);
        ExtTextOutA(
          ChildDc,
          (rc.Right div 2) - (size.cx div 2) + 15,
          Top + i*size.cy,
          ETO_CLIPPED,
          @rc,
          PAnsiChar(ARR_TXTINFO[i]),
          Length(ARR_TXTINFO[i]),
          NIL);
      end;

      ReleaseDC(hWdAbout,ChildDc);
    end;
    {$ENDREGION}

    {$REGION 'WM_DRAWITEM'}
    WM_DRAWITEM:
    begin
      dis:= TDrawItemStruct(Pointer(lPrAbout)^);
      hMemAboutCtl:= CreateCompatibleDC(dis.hDC);
      case dis.CtlID of
        IDB_CLOSE:
        begin
          if ((dis.itemID and ODS_SELECTED) <> ODS_SELECTED) then
            SelectObject(hMemAboutCtl,hBmpCloseUp)
          else
            SelectObject(hMemAboutCtl,hBmpCloseDown);
        end;
      end;
      BitBlt(
        dis.hDC,
        dis.rcItem.Left,
        dis.rcItem.Top,
        61,
        16,
        hMemAboutCtl,
        0,
        0,
        SRCCOPY);
      DeleteDC(hMemAboutCtl);
    end;
    {$ENDREGION}

    {$REGION 'WM_PAINT'}
    WM_PAINT:
    begin
      BeginPaint(hWdAbout,ps);
      hMemDcAbout:= CreateCompatibleDC(ps.hdc);
      SelectObject(hMemDcAbout,hBmpAbout);
      BitBlt(ps.hdc,0,0,371,245,hMemDcAbout,0,0,SRCCOPY);
      DeleteDC(hMemDcAbout);
      EndPaint(hWdAbout,ps);
    end;
    {$ENDREGION}

    {$REGION 'WM_COMMAND'}
    WM_COMMAND:
    begin
      case LoWord(wPrAbout) of
        IDB_CLOSE:
        begin
          if (HiWord(wPrAbout) = BN_CLICKED) then
          begin
            KillTimer(hWdAbout,IDT_TWO);
            EndDialog(hWdAbout,1);
          end;
        end;
      end;
    end;
    {$ENDREGION}

    {$REGION 'WM_MOUSEMOVE'}
    WM_MOUSEMOVE:
    begin
      hDcBtn:= GetDc(hBtnClose);
      hMemDcBtn:= CreateCompatibleDC(hDcBtn);
      SelectObject(hMemDcBtn,hBmpCloseUp);
      BitBlt(hDcBtn,0,0,61,16,hMemDcBtn,0,0, SRCCOPY);
      ReleaseDC(hBtnGen,hDcBtn);
      DeleteDC(hMemDcBtn);

      SetCursor(hCurNormal);

      MovingWindow(hWdAbout,lPrAbout);
    end;
    {$ENDREGION}

    WM_DESTROY:
    begin
      KillTimer(hWdAbout,IDT_TWO);
      EndDialog(hWdAbout,1);
    end;
  end;
  Result:= ret;
end;

end.
