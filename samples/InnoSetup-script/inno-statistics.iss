
[Code]
(*

Title:          Installation statistics via Google Analytics Add-on for Inno Setup
Copyright:      (C) StarMessage software
Web:            http://www.StarMessageSoftware.com/softmeter/
Script Version: 1.3.2
Compatibility:  SoftMeter v1.1 and above
Purpose:	      Monitor via the free Google Analytics platform important information about
                the distribution and installation of your shareware/software. E.g. number
                of installations per month, countries of your user base, screen resolutions,
                operating systems, versions of your software, etc.
                You can even see real-time data from Google Analytics.
                With SoftMeter and this InnoSetup script you can achieve to have this
                information withing an hour or two of development effort.
                SoftMeter can also work with Matomo/Piwik instead of Google Analytics.
E-mail:			    sales -at- starmessage.info
                (For support and suggestions)

Information from Inno Setup about the use of DLLs in the innosetup scripts
    http://www.jrsoftware.org/ishelp/index.php?topic=scriptdll

Usage:
 -  These scripts are in pascal language and depend on the pascal processor of Inno setup.
    Check that you have enabled the Inno Setup Preprocessor (ISPP)
    This is a preprocessor add-on for Inno Setup that will allow Inno setup to run Pascal scripts.
    The "Inno setup Quick start pack" installation prompts you to include it.

 - Download from our GitHub space https://github.com/starmessage/libSoftMeter the following files:
    (a) inno-statistics.iss (this file)
    (b) inno-statistics-config.iss,
    (c) libSoftMeter.dll
    There are two versions of the DLL available:
             64bit: Runs on 64-bit versions of Windows.
             32bit: Runs on all versions of Windows.
    There is only a non-Unicode (aka Ansi) version of the DLL. If you want a Unicode version, please let us know.

 - Copy these files to the same folder as your application's Inno setup script

 - In the [Files] section of your main setup script, add the the DLL so that it is included in the setup package.
   Examples:
    Install the DLL to {app} so it can accessed also at uninstall time or use "Flags: dontcopy" if you don't need uninstall time access
    e.g.
    Source: "C:\distrib\MyApp\libSoftMeter.dll"; DestDir: "{app}"
    Optionally, you can make Inno setup to rename the dll to match your program's name.
    e.g.
    Source: c:\mySoftwareName\distrib\bin\libSoftMeter.dll; DestName: mySoftwareName-libSoftMeter.dll; DestDir: {syswow64}

 - Add a [code] section in your main script (if you do not already have a [code] section)

 - In the [code] section of your main script add the following lines (in this order): 
   Prefix each line with the hash symbol (#) before the 'include'.
    include "inno-statistics-config.iss"
    Include "inno-statistics.iss"
    
 - Edit the file "inno-statistics-config.iss" to add your Google Analytics PropertyID and the rest of 
   your software parameters. If you have a SoftMeter PRO license you should also add your SubscriptionID.

 - This script calls SoftMeter by overriding the standard Inno setup functions 
    InitializeSetup() and InitializeUninstall()
    If you were already using these functions you will need to merge the two instances.

Notes:
    You must run the setup externally (not from inside the Inno Setup GUI).
    The "Run" command of the inno setup GUI is a "sandboxed" command that will not extract the DLL and your tests will fail.

    Contact us in case of questions or feedback.

*)



//////////////////////////////////////////////////////////////////////////////
// Functions and DLL file available during install
// We declare and link here the functions of the SoftMeter library.
// We use the cdecl calling convention of the DLL. We will be also offering a stdcall edition of the DLL.
// For the tracking of installations and uninstalls we only need 3 functions from the dll:
// - iStart()
// - iSendEvent()
// - iStop()
// But we also declare the rest of the functions contained in the dll
// so you have them handy in case you want to make a more complex script.
// During the setup the files are accessed via the "files:" specification

function iGetVersion: PAnsiChar;
external 'getVersion@files:{#smDllName} stdcall loadwithalteredsearchpath delayload setuponly';

function iGetLogFilename: PAnsiChar;
external 'getLogFilename@files:{#smDllName} stdcall loadwithalteredsearchpath delayload setuponly';

procedure iEnableLogfile(appName, macBundleID:PAnsiChar);
external 'enableLogfile@files:{#smDllName} stdcall loadwithalteredsearchpath delayload setuponly';

procedure iDisableLogfile;
external 'disableLogfile@files:{#smDllName} stdcall loadwithalteredsearchpath delayload setuponly';

function iStart(appName, appVersion, appLicense, appEdition, propertyID:PAnsiChar; userGaveConsent:BOOL): BOOL ;
external 'start@files:{#smDllName} stdcall loadwithalteredsearchpath delayload setuponly';

procedure iStop;
external 'stop@files:{#smDllName} stdcall loadwithalteredsearchpath delayload setuponly';

function iSendPageview(pagePath, pageTitle:PAnsiChar): BOOL ;
external 'sendPageview@files:{#smDllName} stdcall loadwithalteredsearchpath delayload setuponly';

function iSendEvent(eventAction, eventLabel:PAnsiChar; eventValue:integer): BOOL ;
external 'sendEvent@files:{#smDllName} stdcall loadwithalteredsearchpath delayload setuponly';

function iSendScreenView(screenName:PAnsiChar): BOOL ;
external 'sendScreenView@files:{#smDllName} stdcall loadwithalteredsearchpath delayload setuponly';

function iSetOptions(developerOptions:PAnsiChar): BOOL ;
external 'setOptions@files:{#smDllName} stdcall loadwithalteredsearchpath delayload setuponly';

//////////////////////////////////////////////////////////////////////////////
// Functions and DLL file available during uninstall
// We declare and link here AGAIN the functions for the uninstall phase.
// Note the 'u' preceeding the function name, means Uninstall
// This is to avoid the syntax error of redeclaring the same functions twice.
// During the uninstall, the files are accessed via the folder where the dll was installed; usually {app}

function uStart(appName, appVersion, appLicense, appEdition, propertyID:PAnsiChar; userGaveConsent:BOOL): BOOL ;
external 'start@{app}\{#smDllName} stdcall loadwithalteredsearchpath delayload uninstallonly';

procedure uStop;
external 'stop@{app}\{#smDllName} stdcall loadwithalteredsearchpath delayload uninstallonly';

function uSendEvent(eventAction, eventLabel:PAnsiChar; eventValue:integer): BOOL ;
external 'sendEvent@{app}\{#smDllName} stdcall loadwithalteredsearchpath delayload uninstallonly';

function uSendPageview(pagePath, pageTitle:PAnsiChar): BOOL ;
external 'sendPageview@{app}\{#smDllName} stdcall loadwithalteredsearchpath delayload uninstallonly';

procedure uEnableLogfile(appName, macBundleID:PAnsiChar);
external 'enableLogfile@{app}\{#smDllName} stdcall loadwithalteredsearchpath delayload uninstallonly';

function uSetOptions(developerOptions:PAnsiChar): BOOL ;
external 'setOptions@{app}\{#smDllName} stdcall loadwithalteredsearchpath delayload uninstallonly';

function uGetLogFilename: PAnsiChar;
external 'getLogFilename@{app}\{#smDllName} stdcall loadwithalteredsearchpath delayload uninstallonly';


procedure trackInstallation(appName, appVersion, appLicense, appEdition, PropertyID:PAnsiChar);
var
    hitText: string;
    // subscriptionOptions: string;
begin
    if (softMeterDebug_EnableLog) then
        iEnableLogfile(appName + ' setup','');
    
    if (softMeterDebug_ShowLogFilename) then
        MsgBox(iGetLogFilename, mbInformation, MB_OK);

    if softMeterSubscription then
    begin
        iSetOptions('subscriptionID=' + softMeterSubscriptionID);
        iSetOptions('subscriptionType=' + softMeterSubscriptionType);
    end;

    iStart(appName, appVersion, appLicense, appEdition, PropertyID, TRUE);
    // Here we track the installation with a Google Analytics "Event" hit.
    // Depending on the monitoring model you create for your software you can alternatively send PageViews or ScreenViews.
    // In our model we decided that "Events" should be considered as milestones in the software's usage.
    // E.g. Download, Installation, Registration, Uninstall.
    // We send PageViews and  ScreenViews hits for the daily usage of the software.
    // E.g. App launch, User went to settings screen, user created a new invoice, etc.
    // With this separation we avoid having the important actions (e.g. installation)
    // burried in the noise created by the high volume of PageViews or ScreenViews.
    hitText :=  appName + ' Install';
    // event hits are available only in the SoftMeter PRO edition
    if softMeterSubscription then
        iSendEvent(PAnsiChar(hitText), 'Install', 1)
    else // So, for the free edition, you can send a pageView hit
        iSendPageview(PAnsiChar(hitText), PAnsiChar(hitText));
    iStop;
end;


procedure trackUninstall(appName, appVersion, appLicense, appEdition, PropertyID:PAnsiChar);
var
    hitText: string;
begin
    if (softMeterDebug_EnableLog) then
        uEnableLogfile(appName +' setup','');
    
    if (softMeterDebug_ShowLogFilename) then
        MsgBox(uGetLogFilename, mbInformation, MB_OK);

    if softMeterSubscription then
    begin
        uSetOptions('subscriptionID=' + softMeterSubscriptionID);
        uSetOptions('subscriptionType=' + softMeterSubscriptionType);
    end;

    uStart(appName, appVersion, appLicense, appEdition, PropertyID, TRUE);
    hitText :=  appName + ' Uninstall';
    // event hits are available only in the SoftMeter PRO edition
    if softMeterSubscription then
        uSendEvent(PAnsiChar(hitText), 'Uninstall', -1)
    else // So, for the free edition, you can send a pageView hit
        uSendPageview(PAnsiChar(hitText), PAnsiChar(hitText));
    uStop;
end;


// Overriding a standart function of Inno setup
// If you are already using this function in your script, merge these functions in one.
// Called during Setup's initialization. Return False to abort Setup, True otherwise.
function InitializeSetup(): Boolean;
begin
  trackInstallation(trackAppName, trackAppVer , trackAppLicense, trackAppEdition, googlePropertyID);
  result := true;
end;


// Overriding a standart function of Inno setup
// If you are already using this function in your script, merge these functions in one.
// Return False to abort Uninstall, True otherwise.
function InitializeUninstall(): Boolean;
begin
  trackUninstall(trackAppName, trackAppVer , trackAppLicense, trackAppEdition, googlePropertyID);

  // Unload the dll, otherwise it will not be deleted by the uninstaller
  UnloadDLL(ExpandConstant('{app}\{#smDllName}'));
  result := true;
end;
