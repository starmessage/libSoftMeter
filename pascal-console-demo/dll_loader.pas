//////////////////////////////////////////////////////////////
///
///     unit dll_loader.pas
///     utility class to load the DLL and link its functions
///     Copyright, StarMessage software
///     https://www.starmessagesoftware.com/libapptelemetry
///
//////////////////////////////////////////////////////////////

unit dll_loader;

//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
interface
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////

uses Windows;

//////////////////////////////////////////////////////////////
///
///     TDllLoader
///     a Pascal/Delphi object that loads a DLL on creation and
///     frees it on destruction
///
//////////////////////////////////////////////////////////////

type
	TDllLoader = class(TObject)
    private
        theDLL: THandle;

    public
        constructor Create(aDllFilename:PChar); virtual;
        destructor  Destroy; override;
        function isLoaded: boolean;
        function getHandle: THandle;

  end;

//////////////////////////////////////////////////////////////
///
///     TDllAppTelemetry
///     a Pascal/Delphi object that loads the appTelemetry DLL,
///     and links its functions
///
//////////////////////////////////////////////////////////////

type
    // C prototype: const char*	appTelemetryGetVersion(void);
    TappTelemetryGetVersion = function: PAnsiChar; cdecl; // stdcall; //
    TappTelemetryGetLogFilename = function: PAnsiChar; cdecl; 
    TappTelemetryEnableLogfile = procedure(appName, macBundleID:PAnsiChar); cdecl;
    TappTelemetryDisableLogfile = procedure; cdecl;
    TappTelemetryInit = function(appName, appVersion, propertyID:PAnsiChar): BOOL ; cdecl;
    TappTelemetryFree = procedure; cdecl;
    TappTelemetryAddPageview = function(pagePath, pageTitle:PAnsiChar): BOOL ; cdecl;
    TappTelemetryAddEvent = function(eventAction, eventLabel:PAnsiChar; eventValue:integer): BOOL ; cdecl;

	TDllAppTelemetry = class(TDllLoader)
    private
        appTelemetryGetVersionPtr: TappTelemetryGetVersion;
        appTelemetryGetLogFilenamePtr: TappTelemetryGetLogFilename;
        appTelemetryEnableLogfilePtr: TappTelemetryEnableLogfile;
		appTelemetryDisableLogfilePtr: TappTelemetryDisableLogfile;
        appTelemetryInitPtr: TappTelemetryInit;
        appTelemetryFreePtr: TappTelemetryFree;
        appTelemetryAddPageviewPtr: TappTelemetryAddPageview;
        appTelemetryAddEventPtr: TappTelemetryAddEvent;

    public
        constructor Create(aDllFilename:PChar); override;
        // destructor  Destroy; override;
        function appTelemetryGetVersion: string;
        function appTelemetryGetLogFilename: string;
        procedure appTelemetryEnableLogfile(appName, macBundleID:PAnsiChar);
		procedure appTelemetryDisableLogfile;
        function appTelemetryInit(appName, appVersion, propertyID:PAnsiChar): BOOL ;
        procedure appTelemetryFree;
        function appTelemetryAddPageview(pagePath, pageTitle:PAnsiChar): BOOL ;
        function appTelemetryAddEvent(eventAction, eventLabel:PAnsiChar; eventValue:integer): BOOL ;

  end;

//////////////////////////////////////////////////////////////
///
                    implementation
///
//////////////////////////////////////////////////////////////

uses SysUtils;

constructor TDllLoader.Create(aDllFilename:PChar);
begin
    theDLL := LoadLibrary(aDllFilename );
    // if theDLL >= 32 then { success }
end;


destructor  TDllLoader.Destroy;
begin
    if isLoaded then
        FreeLibrary(theDLL);
end;


function TDllLoader.getHandle: THandle;
begin
    getHandle := theDLL;
end;


function TDllLoader.isLoaded;
begin
    isLoaded := (theDLL>32);
end;

/////////////////////////////////////////////////////

constructor TDllAppTelemetry.Create(aDllFilename:PChar);
begin
    inherited Create(aDllFilename);
    // link the functions
    // Same true if using GetProcAddress, the correct call is GetProcAddress(hDLL, '_DoMath'); otherwise nil is returned.
    // https://stackoverflow.com/questions/10405991/calling-functions-from-a-c-dll-in-delphi
    @appTelemetryGetVersionPtr := GetProcAddress(theDLL, 'appTelemetryGetVersion');
    @appTelemetryGetLogFilenamePtr := GetProcAddress(theDLL, 'appTelemetryGetLogFilename');
    @appTelemetryEnableLogfilePtr := GetProcAddress(theDLL, 'appTelemetryEnableLogfile');
    @appTelemetryDisableLogfilePtr := GetProcAddress(theDLL, 'appTelemetryDisableLogfile');
	@appTelemetryInitPtr := GetProcAddress(theDLL, 'appTelemetryInit');
	@appTelemetryFreePtr := GetProcAddress(theDLL, 'appTelemetryFree');
    @appTelemetryAddPageviewPtr := GetProcAddress(theDLL, 'appTelemetryAddPageview');
    @appTelemetryAddEventPtr := GetProcAddress(theDLL, 'appTelemetryAddEvent');
end;


function TDllAppTelemetry.appTelemetryGetVersion: string;
begin
    result := '';
    if @appTelemetryGetVersionPtr <> nil then
		result := string(appTelemetryGetVersionPtr);
end;


procedure TDllAppTelemetry.appTelemetryFree;
begin
    if @appTelemetryFreePtr <> nil then
		appTelemetryFreePtr;
end;


function TDllAppTelemetry.appTelemetryInit(appName, appVersion, propertyID: PAnsiChar): BOOL ;
begin
    result := false;
    if @appTelemetryInitPtr <> nil then
		result := appTelemetryInitPtr(appName, appVersion, propertyID);
end;


function TDllAppTelemetry.appTelemetryGetLogFilename:string;
begin
    result := '';
    if @appTelemetryGetLogFilenamePtr <> nil then
		result := string(appTelemetryGetLogFilenamePtr);
end;


function TDllAppTelemetry.appTelemetryAddEvent(eventAction, eventLabel: PAnsiChar; eventValue: integer): BOOL ;
begin
    result := false;
    if @appTelemetryAddEventPtr <> nil then
		result := appTelemetryAddEventPtr(eventAction, eventLabel, eventValue);
end;


function TDllAppTelemetry.appTelemetryAddPageview(pagePath, pageTitle: PAnsiChar): BOOL ;
begin
    result := false;
    if @appTelemetryAddPageviewPtr <> nil then
		result := appTelemetryAddPageviewPtr(pagePath, pageTitle);
end;


procedure TDllAppTelemetry.appTelemetryEnableLogfile(appName, macBundleID:PAnsiChar);
begin
    if @appTelemetryEnableLogfilePtr <> nil then
        appTelemetryEnableLogfilePtr(appName, macBundleID);
end;

procedure TDllAppTelemetry.appTelemetryDisableLogfile;
begin
    if @appTelemetryDisableLogfilePtr <> nil then
        appTelemetryDisableLogfilePtr;
end;

end.
