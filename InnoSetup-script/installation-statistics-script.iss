

[Code]
(*

Title:		Installation statistics via Google Analytics Add-on/Extension for InnoSetup
Copyright: 	(C) StarMessage software 2018
Web:			http://www.StarMessageSoftware.com/libapptelemetry
Version: 	0.2.1
Purpose:	Monitor via the free Google Analytics platform important information about the distribution
					and installation of your shareware/software. E.g. number of installations per month,
					countries of your user base, screen resolutions, operating systems, versions of your software, etc.
					You can even see real-time data from Google Analytics.
					With libAppTelemetry and this InnoSetup script you can achieve to have this information
					withing an hour or two of development effort.

Information from Inno Setup about the use of DLLs in the innosetup scripts
	http://www.jrsoftware.org/ishelp/index.php?topic=scriptdll

Other examples of iss scripts:
	https://github.com/HeliumProject/InnoSetup/tree/master/Examples

Usage:
 - Download from our GitHub space
   https://github.com/starmessage/libAppTelemetry-sample-programs
 	 the latest version of
   installation-statistics-script.iss (this file) and
	 libapptelemetry.dll

 - Copy installation-statistics-script.iss and libapptelemetry.dll to the same folder as your inno setup script
   There are two versions of the DLL available:.
	 		64bit: Runs on 64-bit versions of Windows.
	 		32bit: Runs on all versions of Windows.
	 There is olny a non-Unicode (aka Ansi) version. If you want a Unicode version, please let us know: sales -at- starmessage.info

 - In the [Files] section below, add the path to the DLL so that it is included in the setup package.

 - Add #Include 'installation-statistics-script.iss' in your main .iss script, on a blank line outside of all sections

 - Decide which Google Analytics property you will use for the tracking.
   	In GA there are two reporting view types "Website" and "Mobile App"
	 	This installer script can work with any of them because it uses Event hits that are recorded by both types of views.

 - Decide on the variables: AppName, AppVersion, AppLicense, AppEdition, PropertyID.
   	Some of these can be automatically taken from the constants of your main .iss script.
	 	e.g. AppVersion is {AppVersion}

 - call trackInstallation() during the installation
   	e.g.
		function InitializeSetup(): Boolean;
		// Called during Setup's initialization. Return False to abort Setup, True otherwise.
		begin
			trackInstallation('StarMessage screensaver', '{AppVersion}', 'Trial', 'Windows', 'UA-111111-22');
			result := true;
		end;

 - call trackUninstall() during the uninstall
		e.g.
		function InitializeUninstall(): Boolean;
		// Return False to abort Uninstall, True otherwise.
		begin
			trackUninstall('StarMessage screensaver', '{AppVersion}', 'Trial', 'Windows', 'UA-111111-22');
			// Unload the dll, otherwise it will not be deleted by the uninstaller
			UnloadDLL(ExpandConstant('{syswow64}\libAppTelemetry.dll'));
			result := true;
		end;

Notes:
	We recommend that you create a new Google property to track your software installations and not mix it with your website traffic property.
	You can read more here: How to create and test a Mobile App reporting view in Google Analytics
	https://www.starmessagesoftware.com/faq-page/how-to-create-mobile-app-reporting-view-google-analytics

	You must compile and run the setup externally.
	The "Run" command of the inno setup GUI is a "sandboxed" command that will not extract the DLL and your tests will fail.

	If you use libAppTelemetry.dll also inside your software to monitor the usage statistics
	(e.g. which screens of your program are used the most, etc.) you can use the same dll
	version (recomended) for both purposes or distribute different versions.

	Contact me in case of questions or feedback.

*)

// Below are two blocks of function declarations and linkage.
// First block for the setup phase and another for the uninstall.
// These are all the functions contained in libAppTelemetry.dll.
// We only need 3 of them for the tracking of the setup and uninstall, but we link all of them
//   so you have them handy in case you want to make a more complex script.


//////////////////////////////////////////////////////////////////////////////
// Functions and DLL file available during install
// We declare and link here the functions for the setup phase.
// During the setup the files are accessed via the "files:" specification
// These are all the functions contained in libAppTelemetry.dll.
// We only need 3 of them for the tracking of the setup and uninstall,
//   but we link all of them in case you want to make a more complex script.
function latGetVersion: string;
external 'latGetVersion@files:libAppTelemetry.dll cdecl loadwithalteredsearchpath delayload setuponly';

function latGetLogFilename: string;
external 'latGetLogFilename@files:libAppTelemetry.dll cdecl loadwithalteredsearchpath delayload setuponly';

procedure latEnableLogfile(appName, macBundleID:PAnsiChar);
external 'latEnableLogfile@files:libAppTelemetry.dll cdecl loadwithalteredsearchpath delayload setuponly';

procedure latDisableLogfile;
external 'latDisableLogfile@files:libAppTelemetry.dll cdecl loadwithalteredsearchpath delayload setuponly';

function latInit(appName, appVersion, appLicense, appEdition, propertyID:PAnsiChar; userGaveConsent:BOOL): BOOL ;
external 'latInit@files:libAppTelemetry.dll cdecl loadwithalteredsearchpath delayload setuponly';

procedure latFree;
external 'latFree@files:libAppTelemetry.dll cdecl loadwithalteredsearchpath delayload setuponly';

function latSendPageview(pagePath, pageTitle:PAnsiChar): BOOL ;
external 'latSendPageview@files:libAppTelemetry.dll cdecl loadwithalteredsearchpath delayload setuponly';

function latSendEvent(eventAction, eventLabel:PAnsiChar; eventValue:integer): BOOL ;
external 'latSendEvent@files:libAppTelemetry.dll cdecl loadwithalteredsearchpath delayload setuponly';

function latSendScreenView(screenName:PAnsiChar): BOOL ;
external 'latSendScreenView@files:libAppTelemetry.dll cdecl loadwithalteredsearchpath delayload setuponly';

//////////////////////////////////////////////////////////////////////////////
// Functions and DLL file available during uninstall
// We declare and link here AGAIN the functions for the uninstall phase.
// During the setup the files are accessed via the folder where the dll was installed; usually {app}
// Note the 'u' preceeding the function name. This is to avoid the error of redeclaration of the same function.
function ulatGetVersion: string;
external 'latGetVersion@{app}\libAppTelemetry.dll cdecl loadwithalteredsearchpath delayload uninstallonly';

function ulatGetLogFilename: string;
external 'latGetLogFilename@{app}\libAppTelemetry.dll cdecl loadwithalteredsearchpath delayload uninstallonly';

procedure ulatEnableLogfile(appName, macBundleID:PAnsiChar);
external 'latEnableLogfile@{app}\libAppTelemetry.dll cdecl loadwithalteredsearchpath delayload uninstallonly';

procedure ulatDisableLogfile;
external 'latDisableLogfile@{app}\libAppTelemetry.dll cdecl loadwithalteredsearchpath delayload uninstallonly';

function ulatInit(appName, appVersion, appLicense, appEdition, propertyID:PAnsiChar; userGaveConsent:BOOL): BOOL ;
external 'latInit@{app}\libAppTelemetry.dll cdecl loadwithalteredsearchpath delayload uninstallonly';

procedure ulatFree;
external 'latFree@{app}\libAppTelemetry.dll cdecl loadwithalteredsearchpath delayload uninstallonly';

function ulatSendPageview(pagePath, pageTitle:PAnsiChar): BOOL ;
external 'latSendPageview@{app}\libAppTelemetry.dll cdecl loadwithalteredsearchpath delayload uninstallonly';

function ulatSendEvent(eventAction, eventLabel:PAnsiChar; eventValue:integer): BOOL ;
external 'latSendEvent@{app}\libAppTelemetry.dll cdecl loadwithalteredsearchpath delayload uninstallonly';

function ulatSendScreenView(screenName:PAnsiChar): BOOL ;
external 'latSendScreenView@{app}\libAppTelemetry.dll cdecl loadwithalteredsearchpath delayload uninstallonly';



procedure trackInstallation(appName, appVersion, appLicense, appEdition, PropertyID:PAnsiChar);
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
	latSendEvent('StarMessage Install', 'Install', 1);
	latFree;
end;


procedure trackUninstall(appName, appVersion, appLicense, appEdition, PropertyID:PAnsiChar);
begin
	ulatInit(appName, appVersion, appLicense, appEdition, PropertyID, TRUE);
	ulatSendEvent('StarMessage Uninstall', 'Uninstall', -1);
	ulatFree;
end;


[Files]
; Install our libAppTelemetry DLL to {app} so we can access it at uninstall time
; Use "Flags: dontcopy" if you don't need uninstall time access
; e.g. Source: "C:\distrib\MyApp\libAppTelemetry.dll"; DestDir: "{app}"
; If needed you can also rename the dll to match your program's name.
; but then, don't forget to change the name in the 'external' declarations, above.
Source: c:\mySoftwareName\distrib\bin\libAppTelemetry.dll; DestName: mySoftwareName-libAppTelemetry.dll; DestDir: {syswow64}

