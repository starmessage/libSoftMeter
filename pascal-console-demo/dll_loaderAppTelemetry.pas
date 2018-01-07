//////////////////////////////////////////////////////////////
///
///     unit dll_loaderAppTelemetry.pas
///     utility class to load the DLL and link its functions
///
///		Version of file: 1.8
///  	URL of file: https://github.com/starmessage/libAppTelemetry-sample-programs/blob/master/pascal-console-demo/dll_loaderAppTelemetry.pas
///		URL of repo: https://github.com/starmessage/libAppTelemetry-sample-programs
///     Copyright, StarMessage software
///     https://www.starmessagesoftware.com/libapptelemetry
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
    // C prototype: const char*	appTelemetryGetVersion(void);
    TlatGetVersion = function: PAnsiChar; cdecl; // stdcall;
    TlatGetLogFilename = function: PAnsiChar; cdecl;
    TlatEnableLogfile = procedure(appName, macBundleID:PAnsiChar); cdecl;
    TlatDisableLogfile = procedure; cdecl;
    TlatInit = function(appName, appVersion, appLicense, appEdition, propertyID:PAnsiChar; userGaveConsent:BOOL): BOOL ; cdecl;
    TlatFree = procedure; cdecl;
    TlatSendPageview = function(pagePath, pageTitle:PAnsiChar): BOOL ; cdecl;
    TlatSendEvent = function(eventAction, eventLabel:PAnsiChar; eventValue:integer): BOOL ; cdecl;
    TlatSendScreenview = function(screenName:PAnsiChar): BOOL ; cdecl;

	TDllAppTelemetry = class(TDllLoader)
    private
        latGetVersionPtr: TlatGetVersion;
        latGetLogFilenamePtr: TlatGetLogFilename;
        latEnableLogfilePtr: TlatEnableLogfile;
        latDisableLogfilePtr: TlatDisableLogfile;
        latInitPtr: TlatInit;
        latFreePtr: TlatFree;
        latSendPageviewPtr: TlatSendPageview;
        latSendEventPtr: TlatSendEvent;
        latSendScreenviewPtr: TlatSendScreenview;

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

	@latGetVersionPtr := GetProcAddress(getHandle, 'latGetVersion');
    if (@latGetVersionPtr=NIL) then
         writeln('Failed to load function: latGetVersion');

    @latGetLogFilenamePtr := GetProcAddress(getHandle, 'latGetLogFilename');
    if (@latGetLogFilenamePtr=NIL) then
         writeln('Failed to load function: latGetLogFilename');

	@latEnableLogfilePtr := GetProcAddress(getHandle, 'latEnableLogfile');
    if (@latEnableLogfilePtr=NIL) then
         writeln('Failed to load function: latEnableLogfile');

	@latDisableLogfilePtr := GetProcAddress(getHandle, 'latDisableLogfile');
    if (@latDisableLogfilePtr=NIL) then
         writeln('Failed to load function: latDisableLogfile');

	@latInitPtr := GetProcAddress(getHandle, 'latInit');
    if (@latInitPtr=NIL) then
         writeln('Failed to load function: latInit');

	@latFreePtr := GetProcAddress(getHandle, 'latFree');
    if (@latFreePtr=NIL) then
         writeln('Failed to load function: latFree');

	@latSendPageviewPtr := GetProcAddress(getHandle, 'latSendPageview');
    if (@latSendPageviewPtr=NIL) then
         writeln('Failed to load function: latSendPageview');

	@latSendEventPtr := GetProcAddress(getHandle, 'latSendEvent');
    if (@latSendEventPtr=NIL) then
         writeln('Failed to load function: latSendEvent');

    @latSendScreenviewPtr := GetProcAddress(getHandle, 'latSendScreenview');
    if (@latSendScreenviewPtr=NIL) then
         writeln('Failed to load function: latSendScreenview');
end;


function TDllAppTelemetry.latGetVersion: string;
begin
    result := 'unknown';
    if @latGetVersionPtr<>nil then
        result := string(latGetVersionPtr);
end;


function TDllAppTelemetry.latInit(appName, appVersion, appLicense, appEdition, propertyID: PAnsiChar; userGaveConsent:BOOL): BOOL ;
begin
    result := false;
    if @latInitPtr <> nil then
		result := latInitPtr(appName, appVersion, appLicense, appEdition, propertyID, userGaveConsent);

end;


procedure TDllAppTelemetry.latFree;
begin
    if @latFreePtr <> nil then
			latFreePtr;
end;


function TDllAppTelemetry.latGetLogFilename:string;
begin
    result := '';
    if @latGetLogFilenamePtr <> nil then
			result := string(latGetLogFilenamePtr);
end;


function TDllAppTelemetry.latSendEvent(eventAction, eventLabel: PAnsiChar; eventValue: integer): BOOL ;
begin
    result := false;
    if @latSendEventPtr <> nil then
        result := latSendEventPtr(eventAction, eventLabel, eventValue);
end;


function TDllAppTelemetry.latSendPageview(pagePath, pageTitle: PAnsiChar): BOOL ;
begin
    result := false;
    if @latSendPageviewPtr <> nil then
		result := latSendPageviewPtr(pagePath, pageTitle);
end;

function TDllAppTelemetry.latSendScreenview(screenName: PAnsiChar): BOOL ;
begin
    result := false;
    if @latSendScreenviewPtr <> nil then
		result := latSendScreenviewPtr(screenName);
end;

procedure TDllAppTelemetry.latEnableLogfile(appName, macBundleID:PAnsiChar);
begin
    if @latEnableLogfilePtr <> nil then
        latEnableLogfilePtr(appName, macBundleID);
end;


procedure TDllAppTelemetry.latDisableLogfile;
begin
    if @latDisableLogfilePtr <> nil then
        latDisableLogfilePtr;
end;

end.
