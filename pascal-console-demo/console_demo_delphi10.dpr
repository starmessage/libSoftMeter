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
  dll_loaderAppTelemetry in 'dll_loaderAppTelemetry.pas',
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
	programVer = '2.0';
	programLicense = 'demo';
	programEdition = 'console';
	DLLfilename =  'libAppTelemetry.dll';

        // If the user has opted-out from sending telemetry data, this variable must be false.
        // Save the user's consent in the app's settings and then read this variable every time your program starts.
const userGaveConsent:boolean = true;

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

    writeln('DLL version: ', appTelemetryDll.latGetVersion);

  	writeln('Enabling the log file. Check the log file for the duration of the telemetry functions.');
    appTelemetryDll.latEnableLogfile(programName, 'com.company.' + programName);
    writeln('DLL log filename: ', appTelemetryDll.latGetLogFilename);

    googleAnalyticsPropertyID :=  PAnsiChar(AnsiString(ParamStr(1)));
    writeln('Will send data to the Google Property ID:' +  googleAnalyticsPropertyID);

    if not appTelemetryDll.latInit(PAnsiChar(programName), PAnsiChar(programVer), PAnsiChar(programLicense), PAnsiChar(programEdition), googleAnalyticsPropertyID, userGaveConsent) then
        writeLn('latInit() failed.');

    writeLn('Will send PageView hit');
    if not appTelemetryDll.latSendPageview('main window', 'main window') then
        writeLn('latSendPageview() 2 failed.');

    // e.g. the user opens the configuration screen of your program
    writeLn('Will send PageView hit');
    if not appTelemetryDll.latSendPageview('main window/configuration', 'configuration') then
        writeLn('latSendPageview() failed.');

    writeLn('Will send Event hit');
    if not appTelemetryDll.latSendEvent('App Events', 'Test event', 1) then
        writeLn('latSendEvent() failed.');

    writeLn('Will send ScreenView hit');
    if not appTelemetryDll.latSendScreenView('CLI window test') then
        writeLn('latSendScreenView() failed.');

    // ........  more of your code here


    // eg. the user hits the exit button
    if not appTelemetryDll.latSendPageview('exit', 'exit') then
        writeLn('latSendPageview() failed.');

    appTelemetryDll.latFree;

    // destroy the object so that the DLL is also unloaded
    if assigned(appTelemetryDll) then
        appTelemetryDll.Free;

    writeln('console_demo_delphi10 exiting.');

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;


end.
