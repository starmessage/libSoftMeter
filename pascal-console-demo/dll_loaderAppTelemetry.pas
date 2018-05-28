//////////////////////////////////////////////////////////////
///
///     unit dll_loaderAppTelemetry.pas
///     utility class to load the DLL and link its functions
///
///		Version of file: 1.9
///  	URL of this file:
///     https://github.com/starmessage/libSoftMeter/blob/master/pascal-console-demo/dll_loaderAppTelemetry.pas
///		URL of repo:
///     https://github.com/starmessage/libSoftMeter
///   Copyright, StarMessage software
///     https://www.starmessagesoftware.com/softmeter
///
//////////////////////////////////////////////////////////////

unit dll_loaderAppTelemetry;

//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
interface
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////

uses Windows,
	  dll_loader;

//////////////////////////////////////////////////////////////
///
///     TDllAppTelemetry
///     a Pascal/Delphi object that loads the appTelemetry DLL,
///     and links its functions
///
//////////////////////////////////////////////////////////////

type
    // C prototype: const char*	getVersion(void);
    TgetVersion = function: PAnsiChar; cdecl; // stdcall;
    TgetLogFilename = function: PAnsiChar; cdecl;
    TenableLogfile = procedure(appName, macBundleID:PAnsiChar); cdecl;
    TdisableLogfile = procedure; cdecl;
    
	  Tstart = function(appName, appVersion, appLicense, appEdition, propertyID:PAnsiChar; userGaveConsent:BOOL): BOOL ; cdecl;
    Tstop = procedure; cdecl;
	
    TsendPageview = function(pagePath, pageTitle:PAnsiChar): BOOL ; cdecl;
    TsendEvent = function(eventAction, eventLabel:PAnsiChar; eventValue:integer): BOOL ; cdecl;
    TsendScreenview = function(screenName:PAnsiChar): BOOL ; cdecl;
    TsendException = function(screenName:PAnsiChar; isFatal:BOOL): BOOL ; cdecl;

	TDllAppTelemetry = class(TDllLoader)
    private
        getVersionPtr: TgetVersion;
        getLogFilenamePtr: TgetLogFilename;
        enableLogfilePtr: TenableLogfile;
        disableLogfilePtr: TdisableLogfile;
        
		    startPtr: Tstart;
        stopPtr: Tstop;

        sendPageviewPtr: TsendPageview;
        sendEventPtr: TsendEvent;
        sendScreenviewPtr: TsendScreenview;
        sendExceptionPtr: TsendException;

    public
        constructor Create(aDllFilename:PChar); override;
        // destructor  Destroy; override;
        function getVersion: string;
        function getLogFilename: string;
        procedure enableLogfile(appName, macBundleID:PAnsiChar);
        procedure disableLogfile;
        
		    function start(appName, appVersion, appLicense, appEdition, propertyID:PAnsiChar; userGaveConsent:BOOL): BOOL ;
        procedure stop;
		
        function sendPageview(pagePath, pageTitle:PAnsiChar): BOOL ;
        function sendEvent(eventAction, eventLabel:PAnsiChar; eventValue:integer): BOOL ;
        function sendScreenView(screenName:PAnsiChar): BOOL ;
        function sendException(exceptionDesc: PAnsiChar; isFatal:BOOL): BOOL ;
  end;


//////////////////////////////////////////////////////////////
///
                    implementation
///
//////////////////////////////////////////////////////////////


constructor TDllAppTelemetry.Create(aDllFilename:PChar);
begin
	inherited Create(aDllFilename);
	// link the functions
	// In some DLLs (depending on how they are compiled), the correct call is GetProcAddress(hDLL, '_FunctioName');
	// otherwise nil is returned.
    if (isLoaded)
        then
            writeln('Loaded ok:' + aDllFilename)
        else
            writeln('Failed to load dll:' + aDllFilename);

    // @getVersionPtr := GetProcAddress(getHandle, 'latGetVersion');
    // This is OK with Delphi syntax, but not ok with Free pascal.
    // Lazarus/Free pascal gives the error
    // Can't assign values to an address
    // Solution: https://forum.lazarus.freepascal.org/index.php?topic=37217.0

    @getVersionPtr := GetProcAddress(getHandle, 'getVersion');
    if (@getVersionPtr=NIL) then
         writeln('Failed to load function: getVersion');

    @getLogFilenamePtr := GetProcAddress(getHandle, 'getLogFilename');
    if (@getLogFilenamePtr=NIL) then
         writeln('Failed to load function: getLogFilename');

	  @enableLogfilePtr := GetProcAddress(getHandle, 'enableLogfile');
    if (@enableLogfilePtr=NIL) then
         writeln('Failed to load function: enableLogfile');

	  @disableLogfilePtr := GetProcAddress(getHandle, 'disableLogfile');
    if (@disableLogfilePtr=NIL) then
         writeln('Failed to load function: disableLogfile');

	  @startPtr := GetProcAddress(getHandle, 'start');
    if (@startPtr=NIL) then
         writeln('Failed to load function: start');

	  @stopPtr := GetProcAddress(getHandle, 'stop');
    if (@stopPtr=NIL) then
         writeln('Failed to load function: stop');

	  @sendPageviewPtr := GetProcAddress(getHandle, 'sendPageview');
    if (@sendPageviewPtr=NIL) then
         writeln('Failed to load function: sendPageview');

	  @sendEventPtr := GetProcAddress(getHandle, 'sendEvent');
    if (@sendEventPtr=NIL) then
         writeln('Failed to load function: sendEvent');

    @sendScreenviewPtr := GetProcAddress(getHandle, 'sendScreenview');
    if (@sendScreenviewPtr=NIL) then
         writeln('Failed to load function: sendScreenview');

    @sendExceptionPtr := GetProcAddress(getHandle, 'sendException');
    if (@sendExceptionPtr=NIL) then
         writeln('Failed to load function: sendException');

end;


function TDllAppTelemetry.getVersion: string;
begin
    result := 'unknown';
    if @getVersionPtr<>nil then
        result := string(getVersionPtr);
end;


function TDllAppTelemetry.start(appName, appVersion, appLicense, appEdition, propertyID: PAnsiChar; userGaveConsent:BOOL): BOOL ;
begin
    result := false;
    if @startPtr <> nil then
		  result := startPtr(appName, appVersion, appLicense, appEdition, propertyID, userGaveConsent);

end;


procedure TDllAppTelemetry.stop;
begin
    if @stopPtr <> nil then
		  stopPtr;
end;


function TDllAppTelemetry.getLogFilename:string;
begin
    result := '';
    if @getLogFilenamePtr <> nil then
		  result := string(getLogFilenamePtr);
end;


function TDllAppTelemetry.sendEvent(eventAction, eventLabel: PAnsiChar; eventValue: integer): BOOL ;
begin
    result := false;
    if @sendEventPtr <> nil then
        result := sendEventPtr(eventAction, eventLabel, eventValue);
end;


function TDllAppTelemetry.sendPageview(pagePath, pageTitle: PAnsiChar): BOOL ;
begin
    result := false;
    if @sendPageviewPtr <> nil then
		  result := sendPageviewPtr(pagePath, pageTitle);
end;

function TDllAppTelemetry.sendScreenView(screenName: PAnsiChar): BOOL ;
begin
    result := false;
    if @sendScreenviewPtr <> nil then
		  result := sendScreenviewPtr(screenName);
end;


function TDllAppTelemetry.sendException(exceptionDesc: PAnsiChar; isFatal:BOOL): BOOL ;
begin
    result := false;
    if @sendExceptionPtr <> nil then
		  result := sendExceptionPtr(exceptionDesc, isFatal);
end;


procedure TDllAppTelemetry.enableLogfile(appName, macBundleID:PAnsiChar);
begin
    if @enableLogfilePtr <> nil then
        enableLogfilePtr(appName, macBundleID);
end;


procedure TDllAppTelemetry.disableLogfile;
begin
    if @disableLogfilePtr <> nil then
        disableLogfilePtr;
end;

end.
