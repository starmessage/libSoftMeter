//////////////////////////////////////////////////////////////
///
///     unit softMeter_globalVar.pas
///     Example unit to offer a global object of softMeter
///
///     Version of file: 2.6
///     URL of repo:
///     https://github.com/starmessage/libSoftMeter
///     Copyright, StarMessage software
///     https://www.starmessagesoftware.com/libSoftMeter
///
//////////////////////////////////////////////////////////////


unit softMeter_globalVar;

interface

uses dll_loaderAppTelemetry;

// this is the global variable that multiple units of the application will use
var dllSoftMeter: TDllAppTelemetry;

implementation

uses  dialogs,
      ShellApi; // for ShellExecute

var userGaveConsent:boolean;

const
  // put here your Google Analytics property ID as given to you 
  // from your Google Analytics account.
  // Or put the Matomo/Piwik tracking ID if you you are using Matomo
  GooglePropertyID =  'UA-12341111-11';
                      
  // put here your application information
  AppName = 'Demo Delphi GUI application';
  AppVersion = '1.2';
  AppLicense = 'Free';
  AppEdition = 'Free download edition';
  // if you have a SoftMeter PRO subscription
  PROsubscription = 'subscriptionID=your-subscription-id' + CHR(10) + 'subscriptionType=2';

  {$IFDEF WIN32}
      DLLfilename =  'libSoftMeter.dll';
  {$ENDIF}
  {$IFDEF WIN64}
      DLLfilename =  'libSoftMeter64.dll';
  {$ENDIF}

var startResult: boolean;
    logFilename: string;

initialization

  try
    dllSoftMeter := TDllAppTelemetry.Create(DLLfilename);
  Except
    ShowMessage('Error loading '+ DLLfilename);
  end;

  dllSoftMeter.enableLogfile('Delphi demo');
  logFilename := dllSoftMeter.getLogFilename;

  if Length(GooglePropertyID)<10 then
    begin
    ShowMessage('You are running this demo with the propertyID: ' + GooglePropertyID + CHR(10)+CHR(13) +
                'Are you sure this is YOUR Google propertyID?' + CHR(10)+CHR(13) +
                'Go to softMeter_globalVar.pas to review it.' + CHR(10)+CHR(13) +
                'Will not enable telemetry now.');
    exit;
    end;

    // set your SoftMeter PRO subscription here, before calling start()
    // dllSoftMeter.setOptions(PChar(PROsubscription));
    
    // make sure you load this variable from the user settings
    userGaveConsent:= true;
    // ToDo: make this a lazy call so that the INI file with the user settings containing the 
    // consent of the user is already loaded somewhere in the program.
    
    try
        startResult := dllSoftMeter.start(AppName, AppVersion, AppLicense, AppEdition, GooglePropertyID, userGaveConsent );
    Except
        ShowMessage('Exception while calling  dllSoftMeter.start');
    end;
    if not startResult then
        ShowMessage('start() returned false');

    if dllSoftMeter.errorsExist then
        showMessage('Errors in dllSoftMeter:' + dllSoftMeter.getErrorText);

finalization

  try
    dllSoftMeter.stop;
  Except
    ShowMessage('Error calling  dllSoftMeter.stop');
  end;

  // during the development (not for release) open the logFile
  ShellExecute( 0 , nil, PChar('notepad'), PChar(logFilename) , nil, 1{SW_SHOWNORMAL} ) ;

end.
