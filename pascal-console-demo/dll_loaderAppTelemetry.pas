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
    TatGetVersion = function: PAnsiChar; cdecl; // stdcall;
    TatGetLogFilename = function: PAnsiChar; cdecl;
    TatEnableLogfile = procedure(appName, macBundleID:PAnsiChar); cdecl;
    TatDisableLogfile = procedure; cdecl;
    TatInit = function(appName, appVersion, appLicense, appEdition, propertyID:PAnsiChar; userGaveConsent:BOOL): BOOL ; cdecl;
    TatFree = procedure; cdecl;
    TatAddPageview = function(pagePath, pageTitle:PAnsiChar): BOOL ; cdecl;
    TatAddEvent = function(eventAction, eventLabel:PAnsiChar; eventValue:integer): BOOL ; cdecl;

	TDllAppTelemetry = class(TDllLoader)
    private
        atGetVersionPtr: TatGetVersion;
        atGetLogFilenamePtr: TatGetLogFilename;
        atEnableLogfilePtr: TatEnableLogfile;
        atDisableLogfilePtr: TatDisableLogfile;
        atInitPtr: TatInit;
        atFreePtr: TatFree;
        atSendPageviewPtr: TatAddPageview;
        atSendEventPtr: TatAddEvent;

    public
        constructor Create(aDllFilename:PChar); override;
        // destructor  Destroy; override;
        function atGetVersion: string;
        function atGetLogFilename: string;
        procedure appTelemetryEnableLogfile(appName, macBundleID:PAnsiChar);
        procedure appTelemetryDisableLogfile;
        function atInit(appName, appVersion, appLicense, appEdition, propertyID:PAnsiChar; userGaveConsent:BOOL): BOOL ;
        procedure atFree;
        function atSendPageview(pagePath, pageTitle:PAnsiChar): BOOL ;
        function appTelemetryAddEvent(eventAction, eventLabel:PAnsiChar; eventValue:integer): BOOL ;

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

	@atGetVersionPtr := GetProcAddress(getHandle, 'atGetVersion');
    if (@atGetVersionPtr=NIL) then
         writeln('Failed to load function: appTelemetryGetVersion');

    @atGetLogFilenamePtr := GetProcAddress(getHandle, 'atGetLogFilename');
    if (@atGetLogFilenamePtr=NIL) then
         writeln('Failed to load function: atGetLogFilename');

	@atEnableLogfilePtr := GetProcAddress(getHandle, 'atEnableLogfile');
	@atDisableLogfilePtr := GetProcAddress(getHandle, 'atDisableLogfile');
	@atInitPtr := GetProcAddress(getHandle, 'atInit');
	@atFreePtr := GetProcAddress(getHandle, 'atFree');
	@atSendPageviewPtr := GetProcAddress(getHandle, 'atSendPageview');
	@atSendEventPtr := GetProcAddress(getHandle, 'atSendEvent');

end;


function TDllAppTelemetry.atGetVersion: string;
begin
    result := 'unknown';
    if @atGetVersionPtr<>nil then
        result := string(atGetVersionPtr);
end;


function TDllAppTelemetry.atInit(appName, appVersion, appLicense, appEdition, propertyID: PAnsiChar; userGaveConsent:BOOL): BOOL ;
begin
    result := false;
    if @atInitPtr <> nil then
		result := atInitPtr(appName, appVersion, appLicense, appEdition, propertyID, userGaveConsent);

end;


procedure TDllAppTelemetry.atFree;
begin
    if @atFreePtr <> nil then
			atFreePtr;
end;


function TDllAppTelemetry.atGetLogFilename:string;
begin
    result := '';
    if @atGetLogFilenamePtr <> nil then
			result := string(atGetLogFilenamePtr);
end;


function TDllAppTelemetry.appTelemetryAddEvent(eventAction, eventLabel: PAnsiChar; eventValue: integer): BOOL ;
begin
    result := false;
    if @atSendEventPtr <> nil then
        result := atSendEventPtr(eventAction, eventLabel, eventValue);
end;


function TDllAppTelemetry.atSendPageview(pagePath, pageTitle: PAnsiChar): BOOL ;
begin
    result := false;
    if @atSendPageviewPtr <> nil then
		result := atSendPageviewPtr(pagePath, pageTitle);
end;


procedure TDllAppTelemetry.appTelemetryEnableLogfile(appName, macBundleID:PAnsiChar);
begin
    if @atEnableLogfilePtr <> nil then
        atEnableLogfilePtr(appName, macBundleID);
end;


procedure TDllAppTelemetry.appTelemetryDisableLogfile;
begin
    if @atDisableLogfilePtr <> nil then
        atDisableLogfilePtr;
end;

end.
