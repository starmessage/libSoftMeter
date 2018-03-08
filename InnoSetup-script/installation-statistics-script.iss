[Code]
(*

Title:          Add-on/extension for InnoSetup to monitor installation statistics via Google Analytics 
Copyright:      (C) StarMessage software 2018
Web:			      http://www.StarMessageSoftware.com/softmeter
File Version: 	0.3
File URL:       https://github.com/starmessage/libSoftMeter/blob/master/InnoSetup-script/installation-statistics-script.iss

Purpose:	Monitor via the free Google Analytics platform important information about the distribution
					and installation of your shareware/software. E.g. number of installations per month,
					countries of your user base, screen resolutions, operating systems, versions of your software, etc.
					You can even see real-time data from Google Analytics.


Information from Inno Setup about the use of DLLs in the innosetup scripts
	http://www.jrsoftware.org/ishelp/index.php?topic=scriptdll

Usage:
 - Check that you have enabled the Inno Setup Preprocessor (ISPP) 
   This is a preprocessor add-on for Inno Setup that will allow Inno setup to run these pascal scripts.

 - Download from our GitHub space:
   https://github.com/starmessage/libSoftMeter

 	 the latest version of
   - installation-statistics-script.iss (this file) and
	 - libSoftMeter.dll

 - Copy installation-statistics-script.iss and libSoftMeter.dll to the same folder as your inno setup script
   There are two versions of the DLL available:.
	 		64bit: Runs on 64-bit versions of Windows.
	 		32bit: Runs on all versions of Windows.
	 There is only a non-Unicode (aka Ansi) version. If you want a Unicode version, please let us know: sales -at- starmessage.info

 - In the [Files] section of your main setup script, add the path to the DLL so that it is included in the setup package.
   Examples for the [Files] section:
    Install the DLL to {app} so we can access it at uninstall time
    Use "Flags: dontcopy" if you don't need uninstall time access
    e.g. 
    Source: "C:\distrib\MyApp\libSoftMeter.dll"; DestDir: "{app}"
    If needed, you can also rename the dll to match your program's name.
    but then, don't forget to change the name in the 'external' declarations.
    e.g. 
    Source: c:\mySoftwareName\distrib\bin\libSoftMeter.dll; DestName: mySoftwareName-libSoftMeter.dll; DestDir: {syswow64}

 - Add a [code] section in your main script (if you do not already have a [code] section

 - Add: #Include 'installation-statistics-script.iss' 
    in your main .iss script, just above your [code] section

 - Decide which Google Analytics property you will use for the tracking.
   	In GA there are two reporting view types "Website" and "Mobile App"
	 	This installer script can work with any of them because it uses Event hits that are recorded by both types of views.

 - Decide on the variables: AppName, AppVersion, AppLicense, AppEdition, PropertyID.
   	Some of these can be automatically taken from the constants of your main .iss script.
	 	e.g. AppVersion is {AppVersion}

 - In your [code] section of your main script, call trackInstallation() during the installation
   	e.g.
		function InitializeSetup(): Boolean;
		// Called during Setup's initialization. Return False to abort Setup, True otherwise.
		begin
			trackInstallation('StarMessage screensaver', '1.1', 'Trial', 'Windows', 'UA-111111-22');
			result := true;
		end;

 - call trackUninstall() during the uninstall
		e.g.
		function InitializeUninstall(): Boolean;
		// Return False to abort Uninstall, True otherwise.
		begin
			trackUninstall('StarMessage screensaver', '1.1', 'Trial', 'Windows', 'UA-111111-22');
			// Unload the dll, otherwise it will not be deleted by the uninstaller
			UnloadDLL(ExpandConstant('{syswow64}\libSoftMeter.dll'));
			result := true;
		end;

Notes:
	We recommend that you create a new Google property to track your software installations and 
  not mix it with your website traffic property.
	You can read more here: How to create and test a Mobile App reporting view in Google Analytics
	https://www.starmessagesoftware.com/faq-page/how-to-create-mobile-app-reporting-view-google-analytics

	You must compile and run the setup externally.
	The "Run" command of the inno setup GUI is a "sandboxed" command that will not extract the DLL and your tests will fail.

	If you the dll also inside your software to monitor the usage statistics
	(e.g. which screens of your program are used the most, etc.) you can re-use the same dll
	file (recomended) for both purposes.

  For the tracking of installations and uninstalls we only need 3 functions from the dll:
  - latInit()
  - latSendEvent()
  - latFree()
  But we also declare the rest of the functions contained in the dll
  so you have them handy in case you want to make a more complex script.

	Contact me in case of questions or feedback.
*)



//////////////////////////////////////////////////////////////////////////////
// Functions and DLL file available during install
// We declare and link here the functions for the setup phase.
// During the setup the files are accessed via the "files:" specification

function latGetVersion: string;
external 'getVersion@files:libSoftMeter.dll cdecl loadwithalteredsearchpath delayload setuponly';

function latGetLogFilename: string;
external 'getLogFilename@files:libSoftMeter.dll cdecl loadwithalteredsearchpath delayload setuponly';

procedure latEnableLogfile(appName, macBundleID:PAnsiChar);
external 'enableLogfile@files:libSoftMeter.dll cdecl loadwithalteredsearchpath delayload setuponly';

procedure latDisableLogfile;
external 'disableLogfile@files:libSoftMeter.dll cdecl loadwithalteredsearchpath delayload setuponly';

function latInit(appName, appVersion, appLicense, appEdition, propertyID:PAnsiChar; userGaveConsent:BOOL): BOOL ;
external 'start@files:libSoftMeter.dll cdecl loadwithalteredsearchpath delayload setuponly';

procedure latFree;
external 'stop@files:libSoftMeter.dll cdecl loadwithalteredsearchpath delayload setuponly';

function latSendPageview(pagePath, pageTitle:PAnsiChar): BOOL ;
external 'sendPageview@files:libSoftMeter.dll cdecl loadwithalteredsearchpath delayload setuponly';

function latSendEvent(eventAction, eventLabel:PAnsiChar; eventValue:integer): BOOL ;
external 'sendEvent@files:libSoftMeter.dll cdecl loadwithalteredsearchpath delayload setuponly';

function latSendScreenView(screenName:PAnsiChar): BOOL ;
external 'sendScreenView@files:libSoftMeter.dll cdecl loadwithalteredsearchpath delayload setuponly';

//////////////////////////////////////////////////////////////////////////////
// Functions and DLL file available during uninstall
// We declare and link here AGAIN the functions for the uninstall phase.
// Note the 'u' preceeding the function name. 
// This is to avoid the syntax error of redeclaring the same functions twice.
// During the setup the files are accessed via the folder where the dll was installed; usually {app}

function ulatGetVersion: string;
external 'getVersion@{app}\libSoftMeter.dll cdecl loadwithalteredsearchpath delayload uninstallonly';

function ulatGetLogFilename: string;
external 'getLogFilename@{app}\libSoftMeter.dll cdecl loadwithalteredsearchpath delayload uninstallonly';

procedure ulatEnableLogfile(appName, macBundleID:PAnsiChar);
external 'enableLogfile@{app}\libSoftMeter.dll cdecl loadwithalteredsearchpath delayload uninstallonly';

procedure ulatDisableLogfile;
external 'disableLogfile@{app}\libSoftMeter.dll cdecl loadwithalteredsearchpath delayload uninstallonly';

function ulatInit(appName, appVersion, appLicense, appEdition, propertyID:PAnsiChar; userGaveConsent:BOOL): BOOL ;
external 'start@{app}\libSoftMeter.dll cdecl loadwithalteredsearchpath delayload uninstallonly';

procedure ulatFree;
external 'stop@{app}\libSoftMeter.dll cdecl loadwithalteredsearchpath delayload uninstallonly';

function ulatSendPageview(pagePath, pageTitle:PAnsiChar): BOOL ;
external 'sendPageview@{app}\libSoftMeter.dll cdecl loadwithalteredsearchpath delayload uninstallonly';

function ulatSendEvent(eventAction, eventLabel:PAnsiChar; eventValue:integer): BOOL ;
external 'sendEvent@{app}\libSoftMeter.dll cdecl loadwithalteredsearchpath delayload uninstallonly';

function ulatSendScreenView(screenName:PAnsiChar): BOOL ;
external 'sendScreenView@{app}\libSoftMeter.dll cdecl loadwithalteredsearchpath delayload uninstallonly';



procedure trackInstallation(appName, appVersion, appLicense, appEdition, PropertyID:PAnsiChar);
var
  eventAction: string;
begin
	latInit(appName, appVersion, appLicense, appEdition, PropertyID, TRUE);
  // Here we track the installation with a Google Analytics "Event" hit.
	// Depending on the monitoring model you create for your software you can alternatively send PageViews or ScreenViews.
	// In our model we decided that "Events" should be considered as milestones in the software's usage.
	// E.g. Download, Installation, Registration, Uninstall.
	// We send PageViews and  ScreenViews hits for the daily usage of the software.
	// E.g. App launch, User went to settings screen, user created a new invoice, etc.
	// With this separation we avoid having the important actions (e.g. installation)
	// burried in the noise that the high volume of PageViews or ScreenViews create.
  eventAction :=  appName + ' Install';
	latSendEvent(PAnsiChar(eventAction), 'Install', 1);
	latFree;
end;


procedure trackUninstall(appName, appVersion, appLicense, appEdition, PropertyID:PAnsiChar);
var
  eventAction: string;
begin
	ulatInit(appName, appVersion, appLicense, appEdition, PropertyID, TRUE);
  eventAction :=  appName + ' Uninstall';
	ulatSendEvent(PAnsiChar(eventAction), 'Uninstall', -1);
	ulatFree;
end;




