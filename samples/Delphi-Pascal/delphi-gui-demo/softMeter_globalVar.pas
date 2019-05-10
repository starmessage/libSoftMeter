//////////////////////////////////////////////////////////////
///
///     unit softMeter_globalVar.pas
///     Example unit to offer a global object of softMeter
///
///     Version of file: 2.2
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

uses dialogs;

var userGaveConsent:boolean;

const
  // put here your Google Analytics property ID.
  GooglePropertyID =  'UA-123-1';
  AppName = 'Demo Delphi GUI application';
  AppVersion = '1.1';
  AppLicense = 'Free';
  AppEdition = 'Standard';
  // if you have a subscription
  PROsubscription = 'subscriptionID=your-subscription-id' + CHR(10) + 'subscriptionType=2';

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
