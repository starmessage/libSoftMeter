//
//  SoftMeter-C-Api.h
//
//  Copyright © 2018 StarMessage software. All rights reserved.
//	https://www.starmessagesoftware.com/softmeter
//

#pragma once

#include "lib-export-api.h"

#ifdef _WIN32
	#include <tchar.h>
#endif


#ifdef UNICODE	// for Windows systems
	typedef		wchar_t				smChar_t;
#else
	typedef		char				smChar_t;
#endif

/*
	Note for the Window's DLLs, and the calling convention.
	
	The following functions use the __cdecl calling convention.
	Inside the DLL, they have exact counterparts that use the __stdcall calling convention.
	The function names of their counterparts have a suffix of "_stdcall", e.g. 
		start() // this is the __cdecl function
		start_stdcall() // this is the __stdcall function
	From your Windows application you can call the set you prefer.
	
	As a result, the DLL contains both calling conventions.
*/

// Where are the all-in-one functions?
// The "All-in-one" functions are defined in SoftMeter-C-Api-AIO.h

// get the version string of the library. 
EXPORT_API const smChar_t* getVersion(void);

// get the full path name of the log file. 
EXPORT_API const smChar_t* getLogFilename(void);

// Enable or disable the log file. The default is disabled.
// - Parameter macBundleId is used only in Mac OS. Under Windows you can pass NULL.
// - Parameters appName and macBundleId affect the filename and the folder of the 
//	 logfile.
//   They must contain only characters compatible with the OS. 
//	 E.g. they cannot contain characters such as /\:
EXPORT_API void enableLogfile(const smChar_t *appName, const smChar_t *macBundleId);
EXPORT_API void disableLogfile(void);

// Set the subscription ID for paid licenses.
// Parameters:
// - subscriptionID, string as devivered by the payment processor after your order
// - subscriptionType, depends on the payment processor. More info in the order page.
// Must be called before any of the start() function.
EXPORT_API void setSubscription(const smChar_t *subscriptionID, const int subscriptionType);


// initialize the library.
// Parameters:
// - appLicense examples: free/trial/full/paid/etc
// - appEdition examples: Apple store/Special build/Standard/IOS/Mac/Win/etc
// Must be called before any of the sendXXXX() functions
EXPORT_API bool start(const smChar_t *appName, const smChar_t *appVersion,
							const smChar_t *appLicense, const smChar_t *appEdition,
							const smChar_t *propertyID, const bool  userGaveConsent);

// stop the library. 
// The function will wait for a maximum of 3 seconds for all pending async calls 
// to gracefully finish.
// After stopping the library, you can call again start() if you need to reuse it.
EXPORT_API void stop(void);

// Use sendPageview() if you are monitoring your app via a Google Analytics "Website" reporting view.
// Call this function after program launch, on program exit and on every important form, window, screen 
// that you want to track. E.g. Main Window, Configuration settings, Main Window, Exiting.
// It will process your request asynchronously.
EXPORT_API bool sendPageview(const smChar_t *pagePath, const smChar_t *pageTitle);

// Similar to smSendPageView, use sendScreenview() if you are monitoring your app via a 
// Google Analytics "Mobile App" reporting view.
// It will process your request asynchronously.
EXPORT_API bool sendScreenview(const smChar_t *screenName);

// optionally call sendEvent() to log events in Google Analytics.
// With the events, you have an alternative way of tracking your program.
// You can use events to mark some important milestones in the use of your program,
// e.g. the user enters a registration code to convert the free trial to a full version.
// It will process your request asynchronously
EXPORT_API bool sendEvent(const smChar_t *eventAction, const smChar_t *eventLabel, const int eventValue );

// If you catch exceptions in your program, you can send them to Google Analutics.
// if isFatal = false, the incident will be logged in Google analtytics as Exception
// if isFatal = true, the incident will be logged in Google analtytics as Crash
EXPORT_API bool sendException(const smChar_t *exceptionDescription, const bool isFatal);


#ifdef _WIN32
	// __stdcall version of all the functions 
	// The same function names but appended with _stdcall
	
	// This section is REMed because these functions are exported by a .DEF file 
	const smChar_t*	__stdcall getVersion_stdcall(void);
	const smChar_t*	__stdcall getLogFilename_stdcall(void);
	void __stdcall enableLogfile_stdcall(const smChar_t *appName, const smChar_t *macBundleId);
	void __stdcall disableLogfile_stdcall(void);
    void __stdcall setSubscription_stdcall(const smChar_t *subscriptionID, const int subscriptionType);
	bool __stdcall start_stdcall(const smChar_t *appName, const smChar_t *appVersion,
		                        const smChar_t *appLicense, const smChar_t *appEdition,
		                        const smChar_t *propertyID, const bool  userGaveConsent);
	void __stdcall stop_stdcall(void);
	bool __stdcall sendPageview_stdcall(const smChar_t *pagePath, const smChar_t *pageTitle);
	bool __stdcall sendScreenview_stdcall(const smChar_t *screenName);
	bool __stdcall sendEvent_stdcall(const smChar_t *eventAction, const smChar_t *eventLabel, const int eventValue);
	bool __stdcall sendException_stdcall(const smChar_t *exceptionDescription, const bool isFatal);
	/* */

#endif
