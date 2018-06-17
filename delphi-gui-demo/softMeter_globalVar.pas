//////////////////////////////////////////////////////////////
///
///     unit softMeter_globalVar.pas
///     Example unit to offer a global object of softMeter
///
///		Version of file: 2.0
///  	URL of repo:
///     https://github.com/starmessage/libSoftMeter
///   Copyright, StarMessage software
///   https://www.starmessagesoftware.com/libSoftMeter
///
//////////////////////////////////////////////////////////////


unit softMeter_globalVar;

interface

uses dll_loaderAppTelemetry;

// this is the global variable that multiple units of the application will use
var dllSoftMeter: TDllAppTelemetry;

implementation

uses dialogs;

var userGaveConsent:boolean;

const
  // put here your Google Analytics property ID.
  GooglePropertyID =  'UA-123-12';
  AppName = 'Demo Delphi GUI application';
  AppVersion = '1.0';
  AppLicense = 'Free';
  AppEdition = 'Windows';

  {$IFDEF WIN32}
      DLLfilename =  'libSoftMeter.dll';
  {$ENDIF}
  {$IFDEF WIN64}
      DLLfilename =  'libSoftMeter64bit.dll';
  {$ENDIF}



initialization

  // make sure you load this variable from the user settings
  userGaveConsent:= true;
  try
    dllSoftMeter := TDllAppTelemetry.Create(DLLfilename);
  Except
    ShowMessage('Error loading '+ DLLfilename);
  end;

  try
    dllSoftMeter.start(AppName, AppVersion, AppLicense, AppEdition, GooglePropertyID, userGaveConsent );
  Except
    ShowMessage('Error calling  dllSoftMeter.start');
  end;

  if dllSoftMeter.errorsExist then
    showMessage('Errors in dllSoftMeter:' + dllSoftMeter.getErrorText);

finalization

  try
    dllSoftMeter.stop;
  Except
    ShowMessage('Error calling  dllSoftMeter.stop');
  end;



end.
