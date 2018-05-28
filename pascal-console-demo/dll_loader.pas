//////////////////////////////////////////////////////////////
///
///     unit dll_loader.pas
///     utility class to load the DLL and link its functions
///
///		Version of file: 1.8
///  	URL of file: https://github.com/starmessage/libAppTelemetry-sample-programs/blob/master/pascal-console-demo/dll_loader.pas
///		URL of repo: https://github.com/starmessage/libAppTelemetry-sample-programs
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
        hDLL: THandle;

    public
        constructor Create(aDllFilename:PChar); virtual;
        destructor  Destroy; override;
        function isLoaded: boolean;
        function getHandle: THandle;

  end;


//////////////////////////////////////////////////////////////
///
                    implementation
///
//////////////////////////////////////////////////////////////

uses SysUtils;

constructor TDllLoader.Create(aDllFilename:PChar);
begin
    hDLL := LoadLibrary(aDllFilename );
    // if hDLL >= 32 then { success }
end;


destructor  TDllLoader.Destroy;
begin
    if isLoaded then
        FreeLibrary(hDLL);
end;


function TDllLoader.getHandle: THandle;
begin
    getHandle := hDLL;
end;


function TDllLoader.isLoaded: boolean;
begin
    isLoaded := (hDLL>32);
end;


end.
