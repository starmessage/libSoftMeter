//
//  apiAppTelemetry.h
//  appTelemetry
//
//  Copyright © 2018 StarMessage software. All rights reserved.
//	https://www.starmessagesoftware.com/libapptelemetry
//

#include "lib-export-api.h"

// todo: move it where it is needed
#ifndef _T	// define the _T() macro that is a MS VC macro
	#ifdef __APPLE__
		#ifdef UNICODE
			#define _T(s) L ## s
		#else
			#define _T(s) s
		#endif
	#else
		#include <tchar.h>
	#endif
#endif


#ifdef UNICODE
	typedef		wchar_t				latChar_t;
#else
	typedef		char				latChar_t;
#endif

// get the version string of the library. You can call this anytime.
EXPORT_API const latChar_t*	latGetVersion(void);

// get the full path name of the log file. You can call this anytime.
EXPORT_API const latChar_t*	latGetLogFilename(void);

// enable or disable the writing to the log file. You can call this anytime. 
// The default state is Disabled.
// Parameter macBundleId is used only in Mac OS. Under Windows you can pass NULL.
// Parameters appName and macBundleId affect the filename and the folder of the logfile.
// They must contain only characters compatible with the OS. E.g. they cannot contain characters such as /\:
EXPORT_API void latEnableLogfile(const latChar_t *appName, const latChar_t *macBundleId);
EXPORT_API void latDisableLogfile(void);

// initialize the library.
// Parameters:
//		appLicense examples: free, trial, full, paid, etc
//		appEdition examples: Apple store, Special build, Standard, IOS, Mac, Win, etc
// Must be called before: AddPageview(), AddEvent(), latSendScreenview(), latSendException(), Free()
EXPORT_API bool latInit(const latChar_t *appName, const latChar_t *appVersion,
							const latChar_t *appLicense, const latChar_t *appEdition,
							const latChar_t *propertyID, const bool  userGaveConsent);

// free the library. 
// The function will wait for a maximum of 3 seconds for all pending async calls to gracefully finish.
// After freeing the library, you can call again latInit() if you need to reuse it.
EXPORT_API void latFree(void);

// Use latSendPageview() if you are monitoring your app via a Google Analytics "Website" reporting view.
// call this function after program launch, on program exit and on every important form, window, screen 
// that you want to track. E.g. Main Window, Configuration settings, Main Window, Exiting
// It will process your request asynchronoulsly
EXPORT_API bool latSendPageview(const latChar_t *pagePath, const latChar_t *pageTitle=0);

// Use latSendScreenview() if you are monitoring your app via a Google Analytics "Mobile App" reporting view.
// It will process your request asynchronoulsly
EXPORT_API bool latSendScreenview(const latChar_t *screenName);

// optionally call latSendEvent() to log events in Google Analytics.
// With the events you have an alternative way of tracking your program.
// You can use events to mark some important milestones in the use of your program,
// e.g. the user enters a registration code to convert the free trial to a full version.
// It will process your request asynchronoulsly
EXPORT_API bool latSendEvent(const latChar_t *eventAction, const latChar_t *eventLabel, const int eventValue );

// If you catch exceptions in your program, you can send them to Google Analutics.
// if isFatal = false, the incident will be logged in Google analtytics as Exception
// if isFatal = true, the incident will be logged in Google analtytics as Crash
EXPORT_API bool latSendException(const latChar_t *exceptionDescription, const bool isFatal);



