#NoEnv  
#Persistent
#SingleInstance

SendMode Event
SetWorkingDir %A_ScriptDir%
SetKeyDelay 500

steam_exe_path = %1%
username = %2%
password = %3%

if WinExist("ahk_class CUIEngineWin32")
{
    WinActivate
}
else {
    run, %steam_exe_path% -silent steam://open/bigpicture
	WinWait, ahk_class CUI_EngineWin32, , 5
		
	
	if WinExist("Steam Login") or WinExist("Steam-Login")
	{
		if(username = "" OR password = "") {
			msg = Steam credentials missing
			OutputDebug, %msg%
			FileAppend, %msg%, *
			;MsgBox, %msg%
			WinClose, Steam Login
			WinClose, Steam-Login
			ExitApp, 13
		}
		WinActivate, Steam-Login
		
		CoordMode, Mouse, Relative
		Click 120, 100
		Send, {BS}{BS}{BS}{BS}{BS}{BS}{BS}{BS}{BS}{BS}{BS}{BS}{BS}{BS}{BS}{BS}{BS}{BS}{BS}{BS}{BS}{BS}{BS}{BS}{BS}{BS}{BS}{BS}{BS}{BS}{BS}{BS}{BS}{BS}{BS}{BS}{BS}{BS}{BS}{BS}
		
		Send, %username%{Tab}
		Send, {Raw}%password%
		Send, {Tab}{Tab}{Enter}

		WinWait, ahk_class CUIEngineWin32, , 15
		if ErrorLevel
		{
			if WinExist(Steam Error) or WinExist(Steam - Fehler)
			{
				WinActivate, Steam Error
				WinActivate, Steam - Fehler
				Send, {Enter}
				msg = Could not login to Steam, check credentials
				OutputDebug, %msg%
				FileAppend, %msg%, *
				;MsgBox, %msg%
				ExitApp, 11
			}
			else
			{
				msg = Unknown login error
				OutputDebug, %msg%
				FileAppend, %msg%, *
				;MsgBox, %msg%
				WinClose, Steam Login
				WinClose, Steam-Login
				ExitApp, 12
			}
		}
		
		;run, %A_ProgramFiles%\Steam\Steam.exe -silent steam://open/bigpicture
	}
}
	
WinWait, ahk_class CUIEngineWin32, , 3
if ErrorLevel
{
	msg = Could not activate BPM window
	OutputDebug, %msg%
	FileAppend, %msg%, *
	;MsgBox, %msg% 
	ExitApp, 10
}	


WinWaitClose, ahk_class CUIEngineWin32
WinActivate, ahk_class XBMC
ExitApp, 0