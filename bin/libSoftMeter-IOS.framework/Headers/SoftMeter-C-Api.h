//
//  SoftMeter-C-Api.h
//  File version: 1.1.1
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
 


// Q: Where are the all-in-one functions?
// A: The "All-in-one" functions are defined in SoftMeter-C-Api-AIO.h

// See the API changeLog at
// https://github.com/starmessage/libSoftMeter/blob/master/ChangeLog.md

// get the version string of the library. 
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
EXPORT_API  const TCHAR* CALL_CONV getLogFilename(void);

/* Use this function to pass optional parameters to SoftMeter. 
The parameters are passed as a string containing key=value pairs, 
separated with a new line character "\n" (aka, line feed, chr(10)).

You must call this function before the start() function.
You can pack different options in one parameter string or call the function more than one time,
each one passing different options.

Passing the SoftMeter PRO subscription details.
	setOptions("subscriptionID=1234567\nsubscriptionType=2"); // note the \n, separating the parameters
	with subscriptionID = Google analytics account number, ie the xxxxx part of UA-xxxxx-y
	and with subscriptionType = 2
	Developers using the free edition of SoftMeter, you can also call this function
	Doing so will allow them to activate the PRO features also for the already existing
	installations, when ever they buy a PRO SoftMeter licence in the future.


Passing the Proxy parameters
	setOptions( "proxyAddress=192.1.127.123\n"
				"proxyPort=808\n"
				"proxyAuthScheme=2\n"
				"proxyUsername=aUserName\n"
				"proxyPassword=aPassword\n"
				);
 Currently, the proxy support in "alpha" version and works for Windows only.
 Values for authScheme under Windows:
   0 = no authentication, 2 = NTLM, 4 = Passport, 8 = Digest, 16 = Negotiate
 If the proxy does not need authentication, do not pass the parameters authScheme, username and password
 
*/
EXPORT_API  const bool CALL_CONV setOptions(const TCHAR *developerOptions);



/* deprecated by setOptions():

EXPORT_API void setSubscription(const TCHAR *subscriptionID, const int subscriptionType);
EXPORT_API void setProxy(const TCHAR *address, const int port, const TCHAR *username , const TCHAR *password, const int authScheme);
*/


// initialize the library.
// Parameters:
// - appLicense examples: free/trial/full/paid/etc
// - appEdition examples: Apple store/Special build/Standard/IOS/Mac/Win/etc
// Must be called before any of the sendXXXX() functions
EXPORT_API  bool CALL_CONV start(const TCHAR *appName, const TCHAR *appVersion,
							const TCHAR *appLicense, const TCHAR *appEdition,
							const TCHAR *propertyID, const bool  userGaveConsent);

// stop the library. 
// The function will wait for a maximum of 3 seconds for all pending async calls 
// to gracefully finish.
// After stopping the library, you can call again start() if you need to reuse it.
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

// optionally call sendEvent() to log events in Google Analytics.
// With the events, you have an alternative way of tracking your program.
// You can use events to mark some important milestones in the use of your program,
// e.g. the user enters a registration code to convert the free trial to a full version.
// It will process your request asynchronously
EXPORT_API  bool CALL_CONV sendEvent(const TCHAR *eventAction, const TCHAR *eventLabel, const int eventValue );

// If you catch exceptions in your program, you can send them to Google Analutics.
// if isFatal = false, the incident will be logged in Google analtytics as Exception
// if isFatal = true, the incident will be logged in Google analtytics as Crash
EXPORT_API  bool CALL_CONV sendException(const TCHAR *exceptionDescription, const bool isFatal);


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

    ///////////////////////////////////////////////////////////////////////
	// __stdcall version of all the functions to be exported in the DLL
    // Not needed for the MacOS platforms.
    // These are the same function names but appended with _stdcall
	// They do not need the EXPORT declaration  because they are exported by a .DEF file 
    ///////////////////////////////////////////////////////////////////////

	const TCHAR*	__stdcall getVersion_stdcall(void);
	const TCHAR*	__stdcall getLogFilename_stdcall(void);
    void __stdcall enableLogfile_stdcall(const TCHAR *appName, const TCHAR *macBundleId);
    void __stdcall disableLogfile_stdcall(void);
    bool __stdcall setOptions_stdcall(const TCHAR *developerOptions);

    bool __stdcall start_stdcall(const TCHAR *appName, const TCHAR *appVersion,
		                        const TCHAR *appLicense, const TCHAR *appEdition,
		                        const TCHAR *propertyID, const bool  userGaveConsent);
    void __stdcall stop_stdcall(void);
    bool __stdcall sendPageview_stdcall(const TCHAR *pagePath, const TCHAR *pageTitle);
    bool __stdcall sendScreenview_stdcall(const TCHAR *screenName);
    bool __stdcall sendEvent_stdcall(const TCHAR *eventAction, const TCHAR *eventLabel, const int eventValue);
    bool __stdcall sendException_stdcall(const TCHAR *exceptionDescription, const bool isFatal);
	
    /////////////////////////////////////////////////////////////////////////
    // __cdeclspec version of all the functions to be exported in the DLL
    // Not needed for the MacOS platforms.
    // These function names are appended with _cdecl
    /////////////////////////////////////////////////////////////////////////

    EXPORT_API const  TCHAR* __cdecl	getVersion_cdecl(void);
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
