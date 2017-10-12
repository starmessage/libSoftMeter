program console_demo_delphi10;

{$APPTYPE CONSOLE}

//////////////////////////////////////////////////////////////
///
///     console_demo_delphi10.dpr
///
///     demo delphi/pascal program for the libAppTelemetry
///     Copyright, StarMessage software
///     https://www.starmessagesoftware.com/libapptelemetry
///
//////////////////////////////////////////////////////////////


uses
  SysUtils,
  strUtils,
  dll_loader in 'dll_loader.pas';

function checkCommandLineParam:boolean;
// do some simple checking
begin
    if (ParamCount<>1) then
    begin
        result:=false;
        exit;
    end;
    result:=AnsiStartsStr('UA-', ParamStr(1));
end;


const   programName = 'console_demo_delphi10';
    		programVer = '1.5';
        DLLfilename =  'libAppTelemetry.dll';

        // If the user has opted-out from sending telemetry data, this variable must be true.
        // Save the user's consent in the app's settings and then read this variable every time your program starts.
const disabledByTheUser:boolean = false;

var     appTelemetryDll:TDllAppTelemetry;
        googleAnalyticsPropertyID:PAnsiChar;

begin

  try
    writeln(programName + ' v'+ programVer +' started.');

    if checkCommandLineParam=false then
    begin
        writeln('Call this program with a one parameter, the Google Property ID, e.g.' + CHR(13) + CHR(10) +
                'console_demo_delphi10 UA-123456-01');
        exit;
    end;

    appTelemetryDll := TDllAppTelemetry.Create(DLLfilename);
    if (appTelemetryDll.isLoaded)
        then
            writeln('DLL loaded.')
        else
            writeln('DLL NOT loaded. The DLL "' + DLLfilename + '" must be in the same folder as the executable.');

    writeln('DLL version: ', appTelemetryDll.appTelemetryGetVersion);

  	writeln('Enabling the log file. Check the log file for the duration of the telemetry functions.');
    appTelemetryDll.appTelemetryEnableLogfile(programName, 'com.company.' + programName);
    writeln('DLL log filename: ', appTelemetryDll.appTelemetryGetLogFilename);

    googleAnalyticsPropertyID :=  PAnsiChar(AnsiString(ParamStr(1)));
    writeln('Will send data to the Google Property ID:' +  googleAnalyticsPropertyID);

    if not appTelemetryDll.appTelemetryInit(PAnsiChar(programName), PAnsiChar(programVer), googleAnalyticsPropertyID, disabledByTheUser) then
        writeLn('appTelemetryInit() failed.');

    if not appTelemetryDll.appTelemetryAddOsVersion then
        writeLn('appTelemetryAddOsVersion() failed.');

	// you can see the user's OS version under the "browser" field in G.A.
	// you can see the user's screen resolution under the "screen resolution" field in G.A.
	// But for your convenience you can add a pageview that contains the OS version like this:
	//if not appTelemetryDll.appTelemetryAddPageview(PAnsiChar('launch under ' + GetWinVersion), PAnsiChar('launch under ' + GetWinVersion)) then
    //    writeLn('appTelemetryAddPageview() 1 failed.');

    if not appTelemetryDll.appTelemetryAddPageview('main window', 'main window') then
        writeLn('appTelemetryAddPageview() 2 failed.');

    // e.g. the user opens the configuration screen of your program
    if not appTelemetryDll.appTelemetryAddPageview('main window/configuration', 'configuration') then
        writeLn('appTelemetryAddPageview() failed.');

    // ........  more of your code here


    // eg. the user hits the exit button
    if not appTelemetryDll.appTelemetryAddPageview('exit', 'exit') then
        writeLn('appTelemetryAddPageview() failed.');

    appTelemetryDll.appTelemetryFree;

    // destroy the object so that the DLL is also unloaded
    if assigned(appTelemetryDll) then
        appTelemetryDll.Free;

    writeln('console_demo_delphi10 exiting.');

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;




end.
