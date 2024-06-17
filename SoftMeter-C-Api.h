//
//  SoftMeter-C-Api.h
//  File version: 1.4
//  Copyright StarMessage software. All rights reserved.
//	https://www.starmessagesoftware.com/softmeter
//

#pragma once

#include "lib-export-api.h"

#ifdef _WIN32
	#include <tchar.h>
#else
    #ifndef TCHAR
        #define  TCHAR char
    #endif
#endif
 
// See the API changeLog at
// https://github.com/starmessage/libSoftMeter/blob/master/ChangeLog.md

// Q: Where are the all-in-one functions?
// A: The "All-in-one" functions are defined in SoftMeter-C-Api-AIO.h


// get the version of the library.
EXPORT_API const TCHAR* CALL_CONV getVersion(void);

// Enable or disable the log file. The default is disabled.
// - Parameter macBundleId is used only in Mac OS. Under Windows you can pass NULL.
// - Parameters appName and macBundleId affect the filename and the folder of the 
//	 logfile.
//   They must contain only characters compatible with the OS path. 
//	 E.g. they cannot contain special characters such as /\~*:
//   The log file is stored in the user's temp folder. To open the folder: [Start]->Run->%TEMP% (and OK)
EXPORT_API  void CALL_CONV enableLogfile(const TCHAR *appName, const TCHAR *macBundleId);
EXPORT_API  void CALL_CONV disableLogfile(void);

// get the full path name of the log file. 
// ToDo: convert it to take the string in the parameters, getLogFilename(TCHAR* fn, int nMaxLen);
EXPORT_API  const TCHAR* CALL_CONV getLogFilename(void);



/* Use the setOptions("ParameterName", "ParameterValue") function to pass optional parameters to SoftMeter.
The parameters are passed as a string containing a name=value pair.

You must call this function before the start() function.

1. Passing the SoftMeter PRO subscription details.
    setOptions("subscriptionID=1234567");
    setOptions("subscriptionType=2");
	Where 1234567 should be replaced with the number that we will give you after you buy your license.
    Alternatively, you can pass these two parameters packed in one function call E.g.
    setOptions("subscriptionID=1234567\nsubscriptionType=2\n");
    Note the \n character (aka, line feed, chr(10)) that separates the two parameters.

2. Collection of extra system info.
   For GA4 properties (measurement_ID in the form of G-xxxxxx)
   The extra parameters are sent by default and only by SoftMeter PRO.
   (Total RAM memory, Free RAM memory, Number of CPU cores, CPU model, etc)
 
3. Passing the API secret for GA4 properties (Mandatory):
    setOptions("ApiSecret=xxxxYYYYYzzzzIIII");

4. Passing the Proxy parameters (optional)
	setOptions( "proxyAddress=192.1.127.123\n"
				"proxyPort=808\n"
				"proxyAuthScheme=2\n"
				"proxyUsername=aUserName\n"
				"proxyPassword=aPassword\n"
				);
 Currently, the proxy support is in "alpha" version and works for Windows only.
 Values for authScheme under Windows:
   0 = no authentication, 2 = NTLM, 4 = Passport, 8 = Digest, 16 = Negotiate
 If the proxy does not need authentication, do not pass the parameters authScheme, username and password
 
 5. Enable the debug hits view of Google Analytics 4 (G-xxxxx)
    setOptions("debugHits=On");
 
*/
EXPORT_API  const bool CALL_CONV setOptions(const TCHAR *developerOptions);

enum softMeterExtraInfo { eiUseScreenviews=1,  eiTotalRam=2, eiFreeRam=4, eiCPUcores=8, eiCPUmodel=16 };


// initialize the library.
// Parameters:
// - appLicense examples: free/trial/full/paid/etc
// - appEdition examples: Apple store/Special build/Standard/IOS/Mac/Win/etc
// - propertyID: your GA4 measurement ID, e.g. G-12345678
// Must be called before any of the sendXXXX() functions
// Returns true on success
EXPORT_API  bool CALL_CONV start(const TCHAR *appName, const TCHAR *appVersion,
							const TCHAR *appLicense, const TCHAR *appEdition,
							const TCHAR *propertyID, const bool  userGaveConsent);

// stop the library. 
// The function will wait for a maximum of 3 seconds for all pending async calls 
// to gracefully finish.
EXPORT_API  void CALL_CONV stop(void);

// Use sendPageview() if you are monitoring your app via a Google Analytics "Website" reporting view.
// Call this function after program launch, on program exit and on every important form, window, screen 
// that you want to track. E.g. Main Window, Configuration settings, Main Window, Exiting.
// It will process your request asynchronously.
EXPORT_API  bool CALL_CONV sendPageview(const TCHAR *pagePath, const TCHAR *pageTitle);

// Similar to smSendPageView, use sendScreenview() if you are monitoring your app via a 
// Google Analytics "Mobile App" reporting view.
// It will process your request asynchronously.
EXPORT_API  bool CALL_CONV sendScreenview(const TCHAR *screenName);

// optionally, call sendEvent() to log events in Google Analytics.
// With the events, you have an alternative way of tracking your program.
// You can use events to mark some important milestones in the use of your program,
// e.g. the user enters a registration code to convert the free trial to a full version.
// Google Analytics suggests that before sending an event, you must send a pageView or screenView 
//   so that the event is considered that took place on that page or screen.
// It will process your request asynchronously
EXPORT_API  bool CALL_CONV sendEvent(const TCHAR *eventAction, const TCHAR *eventLabel, const int eventValue );

// If you catch exceptions in your program, you can send them to Google Analutics.
// if isFatal = false, the incident will be logged in Google analtytics as Exception
// if isFatal = true, the incident will be logged in Google analtytics as Crash
EXPORT_API  bool CALL_CONV sendException(const TCHAR *exceptionDescription, const bool isFatal);

// must be called before the call to start() as these user properties should be stable during the running of the application
// Property names should not contain spaces or other special characters
EXPORT_API  bool CALL_CONV setGA4UserProperty(const char* aPropertyName, const char* aPropertyValue);

// must be called after the call to start()
EXPORT_API  bool CALL_CONV sendGA4Event(const char* eventJsonPayload);


// must be called after the call to start()
// Deprecated since v2.0.2
EXPORT_API  bool CALL_CONV setCustomDimension(const int dimensionIndex, const TCHAR* dimensionValue);

//  get the Anonymised User ID that is generated by SoftMeter
EXPORT_API  const TCHAR* CALL_CONV  getAnonymizedUserID(void);

#ifdef _WIN32

/*
    Note about the Windows' DLL calling convention:

    The SoftMeter DLL contains both of the
    __cdecl and __stdcall calling conventions.

    E.g.
        start()     // this uses the __stdcall calling conventions (which is the WIN API default)
        start_cdecl() // this is the __cdecl function
        start_stdcall() // this is the __stdcall function (deprecated because the start() has the same convention)

    From your Windows application you can call the set you prefer.

*/


    /////////////////////////////////////////////////////////////////////////
    // __cdeclspec version of all the functions to be exported in the DLL
    // Not needed for the MacOS platforms.
    // These function names are appended with _cdecl
    /////////////////////////////////////////////////////////////////////////

    EXPORT_API const TCHAR* __cdecl	    getVersion_cdecl(void);
    EXPORT_API void         __cdecl     enableLogfile_cdecl(const TCHAR* appName, const TCHAR* macBundleId);
    EXPORT_API void         __cdecl     disableLogfile_cdecl(void);
    EXPORT_API const TCHAR* __cdecl 	getLogFilename_cdecl(void);
    EXPORT_API bool __cdecl setOptions_cdecl(const TCHAR *developerOptions);
    EXPORT_API bool __cdecl start_cdecl(const TCHAR *appName, const TCHAR *appVersion,
                                        const TCHAR *appLicense, const TCHAR *appEdition,
                                        const TCHAR *propertyID, const bool  userGaveConsent);
    EXPORT_API void __cdecl stop_cdecl(void);
    EXPORT_API bool __cdecl sendPageview_cdecl(const TCHAR *pagePath, const TCHAR *pageTitle);
    EXPORT_API bool __cdecl sendEvent_cdecl(const TCHAR *eventAction, const TCHAR *eventLabel, const int eventValue);
    EXPORT_API bool __cdecl sendScreenview_cdecl(const TCHAR *screenName);
    EXPORT_API bool __cdecl sendException_cdecl(const TCHAR *exceptionDescription, const bool isFatal);


#endif
