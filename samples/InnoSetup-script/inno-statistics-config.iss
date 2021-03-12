
[code]

// This is the SoftMeter configuration script for Inno setup.
// Here you need to provide the information of your application and your google account propertyID.
// Script Version: 1.3
// Get the latest version from
// https://github.com/starmessage/libSoftMeter/blob/master/samples/InnoSetup-script/inno-statistics-config.iss


// Define your google property ID that will be receiving the installation / uninstallation events
// const googlePropertyID = 'PRO-3372-UA-385839-13';
const googlePropertyID = 'UA-1111-2';

// your application details 
// see also: ExpandConstant('{srcexe}')
// https://jrsoftware.org/ishelp/index.php?topic=isxfunc_expandconstant

const trackAppName = '{#SetupSetting("AppName")}';  // this standard variable comes from the main inno script of your application  
const trackAppVer = '{#SetupSetting("AppVersion")}'; // this standard variable comes from the main inno script of your application 
const trackAppLicense = 'Trial';    // or whatever describes the installed application's license
const trackAppEdition = 'Windows';  // or whatever describes the installed application's edition


                                                                             
// If you have a SoftMeter PRO subscription, set softMeterSubscription to TRUE 
// and fill in the ID and Type as described in the email with your license.
const softMeterSubscription = FALSE;
// const softMeterSubscriptionIDparam = 'subscriptionID=199688';  
// const softMeterSubscriptionTypeparam = 'subscriptionType=5';  
const softMeterSubscriptionID = '1234';  
const softMeterSubscriptionType = '5';  

// During the debug you can enable the softMeter log file.
const softMeterDebug_EnableLog = FALSE;
// Note: if your installer runs with elevated permissions,
// the log file might be created under the temp folder of the administrator's account;
// not under the current user account.
const softMeterDebug_ShowLogFilename = FALSE;


// Define the filename of the DLL.
// You can use the default filename libSoftMeter.dll or 
// change the filename to include also your application's name.
// e.g. MyApp-libSoftMeter.dll
#define smDllName = 'libSoftMeter.dll'
