//////////////////////////////////////////////////////////////
///
///     unit dll_loader.pas
///     utility class to load the DLL and link its functions
///
///		Version of file: 2.0
///  	URL of file:
///     https://github.com/starmessage/libSoftMeter/blob/master/pascal-console-demo/dll_loader.pas
///		URL of repo:
///     https://github.com/starmessage/libSoftMeter
///   Copyright, StarMessage software
///   https://www.starmessagesoftware.com/softmeter
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
        errorTextCollector: string;

    public
        constructor Create(aDllFilename:PChar); virtual;
        destructor  Destroy; override;
        function    isLoaded: boolean;
        function    getHandle: THandle;
        function    errorsExist: boolean;
        procedure   addError(aMsg:string);
        function    getErrorText:string;
  end;


//////////////////////////////////////////////////////////////
///
                    implementation
///
//////////////////////////////////////////////////////////////

uses SysUtils;

procedure TDllLoader.addError(aMsg: string);
begin
  errorTextCollector := errorTextCollector + aMsg  + chr(10) + chr(13);
end;


constructor TDllLoader.Create(aDllFilename:PChar);
begin
  hDLL := LoadLibrary(aDllFilename );
  if hDLL < 32 then
    addError('Failed to load ' + aDllFilename);
end;


destructor  TDllLoader.Destroy;
begin
  if isLoaded then
    FreeLibrary(hDLL);
end;


function TDllLoader.errorsExist: boolean;
begin
  result := length(errorTextCollector)>0;
end;


function TDllLoader.getErrorText: string;
begin
  result := errorTextCollector;
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

