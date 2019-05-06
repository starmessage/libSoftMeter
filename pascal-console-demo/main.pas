unit main;

interface

uses dll_loader, dll_loaderAppTelemetry;

procedure run_console_demo;

implementation


uses
  SysUtils,
  strUtils,
  windows;




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





procedure run_console_demo;

const   programName = 'console_demo_pascal';
	programVer = '2.4';
	programLicense = 'demo';
	programEdition = 'console';
  {$IFDEF WIN32}
    DLLfilename =  'libSoftMeter.dll';
  {$ENDIF}
  {$IFDEF WIN64}
    DLLfilename =  'libSoftMeter64bit.dll';
  {$ENDIF}


        // If the user has opted-out from sending telemetry data, this variable must be false.
        // Save the user's consent in the app's settings and then read this variable every time your program starts.
const   userGaveConsent:boolean = true;

var     appTelemetryDll:TDllAppTelemetry;
        googleAnalyticsPropertyID:PAnsiChar;

begin

  try
    writeln(programName + ' v'+ programVer +' started.');

    if checkCommandLineParam=false then
    begin
        writeln('Call this program with a one parameter, the Google Property ID, e.g.' + CHR(13) + CHR(10) +
                'console_demo_delphi10 UA-1234-01');
        exit;
    end;

    appTelemetryDll := TDllAppTelemetry.Create(DLLfilename);
    if (appTelemetryDll.isLoaded)
        then
            writeln('DLL loaded.')
        else
            writeln('DLL NOT loaded. The DLL "' + DLLfilename + '" must be in the same folder as the executable.');


    writeln('DLL version: ', appTelemetryDll.getVersion);

  	writeln('Enabling the log file. Check the log file for the duration of the telemetry functions.');
    appTelemetryDll.enableLogfile(programName);
    writeln('DLL log filename: ', appTelemetryDll.getLogFilename);

    googleAnalyticsPropertyID :=  PAnsiChar(AnsiString(ParamStr(1)));
    writeln('Will send data to the Google Property ID:' +  googleAnalyticsPropertyID);

    appTelemetryDll.setSubscription('your-subscription-id', 2);

    if not appTelemetryDll.start(PAnsiChar(programName), PAnsiChar(programVer), PAnsiChar(programLicense), PAnsiChar(programEdition), googleAnalyticsPropertyID, userGaveConsent) then
        writeLn('start() failed.');

    writeLn('Will send PageView hit');
    if not appTelemetryDll.sendPageview('main window', 'main window') then
        writeLn('sendPageview() 2 failed.');

    // e.g. the user opens the configuration screen of your program
    writeLn('Will send PageView hit');
    if not appTelemetryDll.sendPageview('main window/configuration', 'configuration') then
        writeLn('sendPageview() failed.');

    writeLn('Will send Event hit');
    if not appTelemetryDll.sendEvent('App Events', 'Test event', 1) then
        writeLn('sendEvent() failed.');

    writeLn('Will send ScreenView hit');
    if not appTelemetryDll.sendScreenView('CLI window test') then
        writeLn('sendScreenView() failed.');


    // ........  more of your code here

    // .....
    try
        // throw an exception here, just for test
        raise Exception.Create('Test of ugly error in line 96');
    except
        on E: Exception do
        begin
            writeLn('Will send Exception:', E.ClassName, ': ', E.Message);
            if not appTelemetryDll.sendException(PAnsiChar( AnsiString(E.ClassName+ ': ' +E.Message)), FALSE) then
                writeLn('sendException() failed.');
        end;
    end;



    // eg. the user hits the exit button
    if not appTelemetryDll.sendPageview('exit', 'exit') then
        writeLn('sendPageview() failed.');

    appTelemetryDll.stop;

    // destroy the object so that the DLL is also unloaded
    if assigned(appTelemetryDll) then
        appTelemetryDll.Free;

    writeln('console_demo_delphi10 exiting.');

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end;


end.
