//////////////////////////////////////////////////////////////
///
///     unit dll_loaderAppTelemetry.pas
///     utility class to load the DLL and link its functions
///
///		Version of file: 1.9
///  	URL of file: https://github.com/starmessage/libAppTelemetry-sample-programs/blob/master/pascal-console-demo/dll_loaderAppTelemetry.pas
///		URL of repo: https://github.com/starmessage/libAppTelemetry-sample-programs
///     Copyright, StarMessage software
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
        function latGetVersion: string;
        function latGetLogFilename: string;
        procedure latEnableLogfile(appName, macBundleID:PAnsiChar);
        procedure latDisableLogfile;
        
		    function latInit(appName, appVersion, appLicense, appEdition, propertyID:PAnsiChar; userGaveConsent:BOOL): BOOL ;
        procedure latFree;
		
        function latSendPageview(pagePath, pageTitle:PAnsiChar): BOOL ;
        function latSendEvent(eventAction, eventLabel:PAnsiChar; eventValue:integer): BOOL ;
        function latSendScreenView(screenName:PAnsiChar): BOOL ;
        function latSendException(exceptionDesc: PAnsiChar; isFatal:BOOL): BOOL ;
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
    (* for lazarus
    getVersionPtr := TgetVersion(GetProcAddress(getHandle, 'getVersion'));
    if (getVersionPtr=NIL) then
         writeln('Failed to load function: latGetVersion');

    latGetLogFilenamePtr := TlatGetLogFilename(GetProcAddress(getHandle, 'latGetLogFilename'));
    if (latGetLogFilenamePtr = NIL) then
         writeln('Failed to load function: latGetLogFilename');

	  latEnableLogfilePtr := TlatEnableLogfile(GetProcAddress(getHandle, 'latEnableLogfile'));
    if (latEnableLogfilePtr = NIL) then
         writeln('Failed to load function: latEnableLogfile');

	  latDisableLogfilePtr := TlatDisableLogfile(GetProcAddress(getHandle, 'latDisableLogfile'));
    if (latDisableLogfilePtr=NIL) then
         writeln('Failed to load function: latDisableLogfile');

	latInitPtr := TlatInit(GetProcAddress(getHandle, 'latInit'));
    if (latInitPtr=NIL) then
         writeln('Failed to load function: latInit');

	latFreePtr := TlatFree(GetProcAddress(getHandle, 'latFree'));
    if (latFreePtr=NIL) then
         writeln('Failed to load function: latFree');

	latSendPageviewPtr := TlatSendPageview(GetProcAddress(getHandle, 'latSendPageview'));
    if (latSendPageviewPtr=NIL) then
         writeln('Failed to load function: latSendPageview');

	latSendEventPtr := TlatSendEvent(GetProcAddress(getHandle, 'latSendEvent'));
    if (latSendEventPtr=NIL) then
         writeln('Failed to load function: latSendEvent');

    latSendScreenviewPtr := TlatSendScreenview(GetProcAddress(getHandle, 'latSendScreenview'));
    if (latSendScreenviewPtr=NIL) then
         writeln('Failed to load function: latSendScreenview');

    latSendExceptionPtr := TlatSendException(GetProcAddress(getHandle, 'latSendException'));
    if (latSendExceptionPtr=NIL) then
         writeln('Failed to load function: latSendException');

    *)


    // This is OK with Delphi syntax, but not ok with Free pascal.
    // If assigned directly e.g.
    // @getVersionPtr := GetProcAddress(getHandle, 'latGetVersion');
    // Lazarus/Free pascal gives here the error
    // Can't assign values to an address
    // Solution: https://forum.lazarus.freepascal.org/index.php?topic=37217.0

    @getVersionPtr := GetProcAddress(getHandle, 'getVersion');
    if (@getVersionPtr=NIL) then
         writeln('Failed to load function: getVersion');

    @getLogFilenamePtr := GetProcAddress(getHandle, 'latGetLogFilename');
    if (@getLogFilenamePtr=NIL) then
         writeln('Failed to load function: latGetLogFilename');

	@enableLogfilePtr := GetProcAddress(getHandle, 'latEnableLogfile');
    if (@enableLogfilePtr=NIL) then
         writeln('Failed to load function: latEnableLogfile');

	@disableLogfilePtr := GetProcAddress(getHandle, 'latDisableLogfile');
    if (@disableLogfilePtr=NIL) then
         writeln('Failed to load function: latDisableLogfile');

	@startPtr := GetProcAddress(getHandle, 'latInit');
    if (@startPtr=NIL) then
         writeln('Failed to load function: latInit');

	@stopPtr := GetProcAddress(getHandle, 'latFree');
    if (@stopPtr=NIL) then
         writeln('Failed to load function: latFree');

	@sendPageviewPtr := GetProcAddress(getHandle, 'latSendPageview');
    if (@sendPageviewPtr=NIL) then
         writeln('Failed to load function: latSendPageview');

	@sendEventPtr := GetProcAddress(getHandle, 'latSendEvent');
    if (@sendEventPtr=NIL) then
         writeln('Failed to load function: latSendEvent');

    @sendScreenviewPtr := GetProcAddress(getHandle, 'latSendScreenview');
    if (@sendScreenviewPtr=NIL) then
         writeln('Failed to load function: latSendScreenview');

    @sendExceptionPtr := GetProcAddress(getHandle, 'latSendException');
    if (@sendExceptionPtr=NIL) then
         writeln('Failed to load function: latSendException');

end;


function TDllAppTelemetry.latGetVersion: string;
begin
    result := 'unknown';
    if @getVersionPtr<>nil then
        result := string(getVersionPtr);
end;


function TDllAppTelemetry.latInit(appName, appVersion, appLicense, appEdition, propertyID: PAnsiChar; userGaveConsent:BOOL): BOOL ;
begin
    result := false;
    if @startPtr <> nil then
		result := startPtr(appName, appVersion, appLicense, appEdition, propertyID, userGaveConsent);

end;


procedure TDllAppTelemetry.latFree;
begin
    if @stopPtr <> nil then
		stopPtr;
end;


function TDllAppTelemetry.latGetLogFilename:string;
begin
    result := '';
    if @getLogFilenamePtr <> nil then
		result := string(getLogFilenamePtr);
end;


function TDllAppTelemetry.latSendEvent(eventAction, eventLabel: PAnsiChar; eventValue: integer): BOOL ;
begin
    result := false;
    if @sendEventPtr <> nil then
        result := sendEventPtr(eventAction, eventLabel, eventValue);
end;


function TDllAppTelemetry.latSendPageview(pagePath, pageTitle: PAnsiChar): BOOL ;
begin
    result := false;
    if @sendPageviewPtr <> nil then
		result := sendPageviewPtr(pagePath, pageTitle);
end;

function TDllAppTelemetry.latSendScreenview(screenName: PAnsiChar): BOOL ;
begin
    result := false;
    if @sendScreenviewPtr <> nil then
		result := sendScreenviewPtr(screenName);
end;


function TDllAppTelemetry.latSendException(exceptionDesc: PAnsiChar; isFatal:BOOL): BOOL ;
begin
    result := false;
    if @sendExceptionPtr <> nil then
		result := sendExceptionPtr(exceptionDesc, isFatal);
end;


procedure TDllAppTelemetry.latEnableLogfile(appName, macBundleID:PAnsiChar);
begin
    if @enableLogfilePtr <> nil then
        enableLogfilePtr(appName, macBundleID);
end;


procedure TDllAppTelemetry.latDisableLogfile;
begin
    if @disableLogfilePtr <> nil then
        disableLogfilePtr;
end;

end.
