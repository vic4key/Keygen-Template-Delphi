{ *** uFMOD (WINMM) unit for Delphi *** }

unit uFMOD;

interface

{  function uFMOD_PlaySong(
      lpXM: Pointer;
      param, fdwSong: LongWord
   ): PHWAVEOUT;
   ---
   Description:
   ---
      Loads the given XM song and starts playing it immediately,
      unless XM_SUSPENDED is specified. It will stop any currently
      playing song before loading the new one.
   ---
   Parameters:
   ---
     lpXM
        Specifies the song to play. If this parameter is 0, any
        currently playing song is stopped. In such a case, function
        does not return a meaningful value. fdwSong parameter
        determines whether this value is interpreted as a filename,
        as a resource identifier or a pointer to an image of the song
        in memory.
     param
        If XM_RESOURCE is specified, this parameter should be the
        handle to the executable file that contains the resource to
        be loaded. A 0 value refers to the executable module itself.
        If XM_MEMORY is specified, this parameter should be the size
        of the image of the song in memory.
        If XM_FILE is specified, this parameter is ignored.
     fdwSong
        Flags for playing the song. The following values are defined:
        XM_FILE      lpXM points to filename. param is ignored.
        XM_MEMORY    lpXM points to an image of a song in memory.
                     param is the image size. Once, uFMOD_PlaySong
                     returns, it's safe to free/discard the memory
                     buffer.
        XM_RESOURCE  lpXM specifies the name of the resource.
                     param identifies the module whose executable file
                     contains the resource.
                     The resource type must be RT_RCDATA.
        XM_NOLOOP    An XM track plays repeatedly by default. Specify
                     this flag to play it only once.
        XM_SUSPENDED The XM track is loaded in a suspended state,
                     and will not play until the uFMOD_Resume function
                     is called. This is useful for preloading a song
                     or testing an XM track for validity.
  ---
  Return Values:
  ---
     On success, returns a pointer to an open WINMM output device handle.
     Returns nil on failure. If you are familiar with WINMM, you'll know
     what this handle might be useful for :)
  ---
  Remarks:
  ---
     If no valid song is specified and there is one currently being
     played, uFMOD_PlaySong just stops playback.
}
function uFMOD_PlaySong(lpXM:Pointer;param,fdwSong:LongWord):Pointer; stdcall; external;
procedure uFMOD_StopSong;

{  procedure uFMOD_Jump2Pattern(
      pat: LongWord
   );
   ---
   Description:
   ---
      Jumps to the specified pattern index.
   ---
   Parameters:
   ---
      pat
         Next zero based pattern index.
   ---
   Remarks:
   ---
      uFMOD doesn't automatically perform Note Off effects before jumping
      to the target pattern. In other words, the original pattern will
      remain in the mixer until it fades out. You can use this feature to
      your advantage. If you don't like it, just insert leading Note Off
      commands in all patterns intended to be used as uFMOD_Jump2Pattern
      targets.
      if the pattern index lays outside of the bounds of the pattern order
      table, calling this function jumps to pattern 0, effectively
      rewinding playback. }
procedure uFMOD_Jump2Pattern(pat:LongWord); stdcall; external;
procedure uFMOD_Rewind;

{  procedure uFMOD_Pause;
   ---
   Description:
   ---
      Pauses the currently playing song, if any.
   ---
   Remarks:
   ---
      While paused you can still control the volume (uFMOD_SetVolume) and
      the pattern order (uFMOD_Jump2Pattern). The RMS volume coefficients
      (uFMOD_GetStats) will go down to 0 and the progress tracker
      (uFMOD_GetTime) will "freeze" while the song is paused.
      uFMOD_Pause doesn't perform the request immediately. Instead, it
      signals to pause when playback reaches next chunk of data, which may
      take up to about 40ms. This way, uFMOD_Pause performs asynchronously
      and returns very fast. It is not cumulative. So, calling
      uFMOD_Pause many times in a row has the same effect as calling it
      once.
      If you need synchronous pause/resuming, you can use WINMM
      waveOutPause/waveOutRestart functions. }
procedure uFMOD_Pause; external;

{  procedure uFMOD_Resume;
   ---
   Description:
   ---
      Resumes the currently paused song, if any.
   ---
   Remarks:
   ---
      uFMOD_Resume doesn't perform the request immediately. Instead, it
      signals to resume when an internal thread gets a time slice, which
      may take some milliseconds to happen. Usually, calling Sleep(0)
      immediately after uFMOD_Resume causes it to resume faster.
      uFMOD_Resume is not cumulative. So, calling it many times in a row
      has the same effect as calling it once.
      If you need synchronous pause/resuming, you can use WINMM
      waveOutPause/waveOutRestart functions. }
procedure uFMOD_Resume; external;

{  function uFMOD_GetStats:LongWord;
   ---
   Description:
   ---
      Returns the current RMS volume coefficients in (L)eft and (R)ight
      channels.
         low-order word: RMS volume in R channel
         hi-order word:  RMS volume in L channel
      Range from 0 (silence) to $7FFF (maximum) on each channel.
   ---
   Remarks:
   ---
      This function is useful for updating a VU meter. It's recommended
      to rescale the output to log10 (decibels or dB for short), because
      human ears track volume changes in a dB scale. You may call
      uFMOD_GetStats() as often as you like, but take in mind that uFMOD
      updates both channel RMS volumes every 20-40ms, depending on the
      output sampling rate. So, calling uFMOD_GetStats about 16 times a
      second whould be quite enough to track volume changes very closely. }
function uFMOD_GetStats:LongWord; stdcall; external;

{  function uFMOD_GetRowOrder:LongWord;
   ---
   Description:
   ---
      Returns the currently playing row and order.
         low-order word: row
         hi-order word:  order
   ---
   Remarks:
   ---
      This function is useful for synchronization. uFMOD updates both
      row and order values every 20-40ms, depending on the output sampling
      rate. So, calling uFMOD_GetRowOrder about 16 times a second whould be
      quite enough to track row and order progress very closely. }
function uFMOD_GetRowOrder:LongWord; stdcall; external;

{  function uFMOD_GetTime:LongWord;
   ---
   Description:
   ---
      Returns the time in milliseconds since the song was started.
   ---
   Remarks:
   ---
      This function is useful for synchronizing purposes. In fact, it is
      more precise than a regular timer in Win32. Multimedia applications
      can use uFMOD_GetTime to synchronize GFX to sound, for example. An
      XM player can use this function to update a progress meter. }
function uFMOD_GetTime:LongWord; stdcall; external;

{  function uFMOD_GetTitle:PChar;
   ---
   Description:
   ---
      Returns the current song's title.
   ---
   Remarks:
   ---
      Not every song has a title, so be prepared to get an empty string.
      The string format may be ANSI or Unicode debending on the UF_UFS
      settings used while recompiling the library. }
function uFMOD_GetTitle:PChar; stdcall; external;

{  procedure uFMOD_SetVolume(
      vol: LongWord
   );
   ---
   Description:
   ---
      Sets the global volume. The volume scale is linear.
   ---
   Parameters:
   ---
      vol
         New volume. Range: from uFMOD_MIN_VOL (muting) to uFMOD_MAX_VOL
         (maximum volume). Any value above uFMOD_MAX_VOL maps to maximum
         volume.
   ---
   Remarks:
   ---
      uFMOD internally converts the given values to a logarithmic scale (dB).
      Maximum volume is set by default. The volume value is preserved across
      uFMOD_PlaySong calls. You can set the desired volume level before
      actually starting to play a song.
      You can use WINMM waveOutSetVolume function to control the L and R
      channels volumes separately. It also has a wider range than
      uFMOD_SetVolume, sometimes allowing to amplify the sound volume as well,
      as opposed to uFMOD_SetVolume only being able to attenuate it. The bad
      things about waveOutSetVolume is that it may produce clicks and it's
      hardware dependent. }
procedure uFMOD_SetVolume(vol:LongWord); stdcall; external;

const
	XM_RESOURCE       = 0;
	XM_MEMORY         = 1;
	XM_FILE           = 2;
	XM_NOLOOP         = 8;
	XM_SUSPENDED      = 16;
        uFMOD_MIN_VOL     = 0;
        uFMOD_MAX_VOL     = 25;
        uFMOD_DEFAULT_VOL = 25;

implementation

{ *** Import: kernel32 *** }
function WaitForSingleObject(hObject,dwTimeout:LongInt):LongInt; stdcall; external 'kernel32.dll';
function CloseHandle(hObject:LongInt):LongInt; stdcall; external 'kernel32.dll';
function CreateThread(lpThreadAttributes:Pointer;dwStackSize:LongInt;lpStartAddress,lpParameter:Pointer;dwCreationFlags:LongInt;lpThreadId:Pointer):LongInt; stdcall; external 'kernel32.dll';
function SetThreadPriority(hThread,nPriority:LongInt):LongInt; stdcall; external 'kernel32.dll';
function HeapAlloc(hHeap,dwFlags,dwBytes:LongInt):LongInt; stdcall; external 'kernel32.dll';
function HeapCreate(flOptions,dwInitialSize,dwMaximumSize:LongInt):LongInt; stdcall; external 'kernel32.dll';
function HeapDestroy(hHeap:LongInt):LongInt; stdcall; external 'kernel32.dll';
procedure Sleep(cMillis:LongInt); stdcall; external 'kernel32.dll';
function FindResourceA(hModule:LongInt;lpName,lpType:PChar):LongInt; stdcall; external 'kernel32.dll';
function LoadResource(hModule,hrsrc:LongInt):LongInt; stdcall; external 'kernel32.dll';
function SizeofResource(hModule,hrsrc:LongInt):LongInt; stdcall; external 'kernel32.dll';
function CreateFileA(lpFileName:PChar;dwDesiredAccess,dwShareMode:LongInt;lpSecurityAttributes:Pointer;dwCreationDistribution,dwFlagsAndAttributes,hTemplateFile:LongInt):LongInt; stdcall; external 'kernel32.dll';
function CreateFileW(lpFileName:PWideChar;dwDesiredAccess,dwShareMode:LongInt;lpSecurityAttributes:Pointer;dwCreationDistribution,dwFlagsAndAttributes,hTemplateFile:LongInt):LongInt; stdcall; external 'kernel32.dll';
function ReadFile(hFile:LongInt;lpBuffer:Pointer;nNumberOfBytesToRead:LongInt;lpNumberOfBytesRead,lpOverlapped:Pointer):LongInt; stdcall; external 'kernel32.dll';
function SetFilePointer(hFile,lDistanceToMove:LongInt;lpDistanceToMoveHigh:Pointer;dwMoveMethod:LongInt):LongInt; stdcall; external 'kernel32.dll';

{ *** Import: winmm *** }
function waveOutClose(hwo:LongInt):LongInt; stdcall; external 'winmm.dll';
function waveOutGetPosition(hwo:LongInt;pmmt:Pointer;cbmmt:LongInt):LongInt; stdcall; external 'winmm.dll';
function waveOutOpen(phwo:Pointer;uDeviceID:LongWord;pwfx:Pointer;dwCallback,dwCallbackInstance,fdwOpen:LongWord):LongInt; stdcall; external 'winmm.dll';
function waveOutPrepareHeader(hwo:LongInt;pwh:Pointer;cbwh:LongWord):LongInt; stdcall; external 'winmm.dll';
function waveOutReset(hwo:LongInt):LongInt; stdcall; external 'winmm.dll';
function waveOutUnprepareHeader(hwo:LongInt;pwh:Pointer;cbwh:LongWord):LongInt; stdcall; external 'winmm.dll';
function waveOutWrite(hwo:LongInt;pwh:Pointer;cbwh:LongWord):LongInt; stdcall; external 'winmm.dll';

{$L ufmod.obj}

procedure uFMOD_StopSong;
begin
	uFMOD_PlaySong(nil,0,0)
end;

procedure uFMOD_Rewind;
begin
	uFMOD_Jump2Pattern(0)
end;

end.