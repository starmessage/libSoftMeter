
[Code]
(*

Title:			Installation statistics via Google Analytics Add-on for Inno Setup
Copyright: 	    (C) StarMessage software 2018
Web:			http://www.StarMessageSoftware.com/softmeter/
Script Version: 0.4
Purpose:	    Monitor via the free Google Analytics platform important information about the distribution
                and installation of your shareware/software. E.g. number of installations per month,
                countries of your user base, screen resolutions, operating systems, versions of your software, etc.
                You can even see real-time data from Google Analytics.
                With SoftMeter and this InnoSetup script you can achieve to have this information
                withing an hour or two of development effort.
E-mail:			sales -at- starmessage.info
				(For support and suggestions)
				
Information from Inno Setup about the use of DLLs in the innosetup scripts
	http://www.jrsoftware.org/ishelp/index.php?topic=scriptdll

Usage:
 - Check that you have enabled the Inno Setup Preprocessor (ISPP)
   This is a preprocessor add-on for Inno Setup that will allow Inno setup to run Pascal scripts.
   
 - Download from our GitHub space https://github.com/starmessage/libSoftMeter
	(a) installation-statistics-script.iss (this file)
	(b) inno-statistics-config.iss, 
	(c) libSoftMeter.dll
	There are two versions of the DLL available:
	 		64bit: Runs on 64-bit versions of Windows.
	 		32bit: Runs on all versions of Windows.
	There is only a non-Unicode (aka Ansi) version of the DLL. If you want a Unicode version, please let us know.

 - Copy these files to the same folder as your inno setup script

 - In the [Files] section of your main setup script, add the the DLL so that it is included in the setup package.
   Examples:
    Install the DLL to {app} so we can access it at uninstall time or use "Flags: dontcopy" if you don't need uninstall time access
    e.g.
    Source: "C:\distrib\MyApp\libSoftMeter.dll"; DestDir: "{app}"
    Optionally, you can  rename the dll to match your program's name.
    but then, don't forget to change the name in the 'external' declarations.
    e.g.
    Source: c:\mySoftwareName\distrib\bin\libSoftMeter.dll; DestName: mySoftwareName-libSoftMeter.dll; DestDir: {syswow64}

 - Add a [code] section in your main script (if you do not already have a [code] section)

 - Add: #Include 'installation-statistics-script.iss'
    in your main .iss script, just above your [code] section

 - Decide which Google Analytics property you will use for the tracking.
   	In GA there are two reporting view types "Website" and "Mobile App"
	This installer script can work with any of them because it uses Event hits that are recorded by both types of views.

 - Edit the file "inno-statistics-config.iss" to add your PropertyID and the DLL filename name.
 
 - Decide on the variables: AppName, AppVersion, AppLicense, AppEdition.
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
    not mix these figures with your website online traffic.
	You can read more here: How to create and test a Mobile App reporting view in Google Analytics
	https://www.starmessagesoftware.com/faq-page/how-to-create-mobile-app-reporting-view-google-analytics

	You must run the setup externally (not from inside the Inno Setup GUI).
	The "Run" command of the inno setup GUI is a "sandboxed" command that will not extract the DLL and your tests will fail.
	
	Contact me in case of questions or feedback.

*)

// edit this include file to configure your installation statistics
#include "inno-statistics-config.iss"

//////////////////////////////////////////////////////////////////////////////
// Functions and DLL file available during install
// We declare and link here the functions of the SoftMeter library.
// For the tracking of installations and uninstalls we only need 3 functions from the dll:
// - iStart()
// - iSendEvent()
// - iStop()
// But we also declare the rest of the functions contained in the dll
// so you have them handy in case you want to make a more complex script.
// During the setup the files are accessed via the "files:" specification

function iGetVersion: string;
external 'getVersion@files:libSoftMeter.dll cdecl loadwithalteredsearchpath delayload setuponly';

function iGetLogFilename: string;
external 'getLogFilename@files:libSoftMeter.dll cdecl loadwithalteredsearchpath delayload setuponly';

procedure iEnableLogfile(appName, macBundleID:PAnsiChar);
external 'enableLogfile@files:libSoftMeter.dll cdecl loadwithalteredsearchpath delayload setuponly';

procedure iDisableLogfile;
external 'disableLogfile@files:libSoftMeter.dll cdecl loadwithalteredsearchpath delayload setuponly';

function iStart(appName, appVersion, appLicense, appEdition, propertyID:PAnsiChar; userGaveConsent:BOOL): BOOL ;
external 'start@files:libSoftMeter.dll cdecl loadwithalteredsearchpath delayload setuponly';

procedure iStop;
external 'stop@files:libSoftMeter.dll cdecl loadwithalteredsearchpath delayload setuponly';

function iSendPageview(pagePath, pageTitle:PAnsiChar): BOOL ;
external 'sendPageview@files:libSoftMeter.dll cdecl loadwithalteredsearchpath delayload setuponly';

function iSendEvent(eventAction, eventLabel:PAnsiChar; eventValue:integer): BOOL ;
external 'sendEvent@files:libSoftMeter.dll cdecl loadwithalteredsearchpath delayload setuponly';

function iSendScreenView(screenName:PAnsiChar): BOOL ;
external 'sendScreenView@files:libSoftMeter.dll cdecl loadwithalteredsearchpath delayload setuponly';

//////////////////////////////////////////////////////////////////////////////
// Functions and DLL file available during uninstall
// We declare and link here AGAIN the functions for the uninstall phase.
// Note the 'u' preceeding the function name, denoting Uninstall
// This is to avoid the syntax error of redeclaring the same functions twice.
// During the uninstall, the files are accessed via the folder where the dll was installed; usually {app}

function uStart(appName, appVersion, appLicense, appEdition, propertyID:PAnsiChar; userGaveConsent:BOOL): BOOL ;
external 'start@{app}\libSoftMeter.dll cdecl loadwithalteredsearchpath delayload uninstallonly';

procedure uStop;
external 'stop@{app}\libSoftMeter.dll cdecl loadwithalteredsearchpath delayload uninstallonly';

function uSendEvent(eventAction, eventLabel:PAnsiChar; eventValue:integer): BOOL ;
external 'sendEvent@{app}\libSoftMeter.dll cdecl loadwithalteredsearchpath delayload uninstallonly';




procedure trackInstallation(appName, appVersion, appLicense, appEdition, PropertyID:PAnsiChar);
var
	eventAction: string;
begin
	iStart(appName, appVersion, appLicense, appEdition, PropertyID, TRUE);
	// Here we track the installation with a Google Analytics "Event" hit.
	// Depending on the monitoring model you create for your software you can alternatively send PageViews or ScreenViews.
	// In our model we decided that "Events" should be considered as milestones in the software's usage.
	// E.g. Download, Installation, Registration, Uninstall.
	// We send PageViews and  ScreenViews hits for the daily usage of the software.
	// E.g. App launch, User went to settings screen, user created a new invoice, etc.
	// With this separation we avoid having the important actions (e.g. installation)
	// burried in the noise that the high volume of PageViews or ScreenViews create.
	eventAction :=  appName + ' Install';
	iSendEvent(PAnsiChar(eventAction), 'Install', 1);
	iStop;
end;


procedure trackUninstall(appName, appVersion, appLicense, appEdition, PropertyID:PAnsiChar);
var
	eventAction: string;
begin
	uStart(appName, appVersion, appLicense, appEdition, PropertyID, TRUE);
	eventAction :=  appName + ' Uninstall';
	uSendEvent(PAnsiChar(eventAction), 'Uninstall', -1);
	uStop;
end;




