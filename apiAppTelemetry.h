//
//  apiAppTelemetry.h
//  appTelemetry
//
//  Copyright © 2018 StarMessage software. All rights reserved.
//	https://www.starmessagesoftware.com/libapptelemetry
//

#include <string>


#ifdef UNICODE
	typedef		wchar_t				latChar_t;
	typedef		std::wstring		latString_t;
    #define		latCout 			std::wcout // todo: move where it is needed

#else
	typedef		char				latChar_t;
	typedef		std::string			latString_t;
	#define		latCout 			std::cout
#endif

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

#ifdef _WIN32
	// __declspec(dllexport) adds the export directive to the object file so you do not need to use a .def file. 
	// When exporting functions with either method, make sure to use the __stdcall calling convention. 
	#define EXPORT_DIRECTIVE	__declspec(dllexport) 
#else
	#define EXPORT_DIRECTIVE	__attribute__((visibility("default")))
	// another way to control the export visibility of functions in Xcode is to wrap the functions block inside
	//  #pragma GCC visibility push(default)
	// and
	//  #pragma GCC visibility pop

#endif


#ifdef __cplusplus
	// extern "C": the function behind the descriptor should be compiled with the C standard naming mangling.
	#define C_EXPORT extern "C" 
#else
	#define C_EXPORT 
#endif

#define EXPORT_API		C_EXPORT EXPORT_DIRECTIVE
		

// get the version string of the library. You can call this anytime.
EXPORT_API const latChar_t*	latGetVersion(void);

// get the full path name of the log file. You can call this anytime.
EXPORT_API const latChar_t*	latGetLogFilename(void);

// enable or disable the writing to the log file. You can call this anytime. 
// If you do not call the Enable function, the default state is Disabled.
// Parameter macBundleId is used only in Mac OS. Under Windows you can pass an empty string ""
// Parameters appName and macBundleId affect the filename and the folder of the logfile.
// They must contain only characters compatible with the OS. E.g. they cannot contain characters such as /\:
EXPORT_API void latEnableLogfile(const latChar_t *appName, const latChar_t *macBundleId);
EXPORT_API void latDisableLogfile(void);

// initialize the library.
// Parameters:
//		appLicense examples: free, trial, full, paid, etc
//		appEdition examples: Apple store, Special build, Standard, IOS, Mac, Win, etc
// Must be called before: AddPageview(), AddEvent(), Free()
EXPORT_API bool latInit(const latChar_t *appName, const latChar_t *appVersion,
							const latChar_t *appLicense, const latChar_t *appEdition,
							const latChar_t *propertyID, const bool  userGaveConsent);

// free the library. 
// The function will wait for a maximum of 3 seconds for all pending async calls to gracefully finish.
// After freeing the library, you can call again latInit() if you need to reuse it.
EXPORT_API void latFree(void);

	
// call this function after program launch, on program exit and on every important form, window, screen 
// that you want to track. E.g. Main Window, Configuration settings, Main Window, Exiting
// It will process your request asynchronoulsly
EXPORT_API bool latSendPageview(const latChar_t *pagePath, const latChar_t *pageTitle=0);

// optionally call this function to log events in Google Analytics.
// With the events you have an alternative way of tracking your program.
// Depending on the things you want to track, maybe the Events will allow you to create 
//		a better model for understanding the usage of your program.
// It will process your request asynchronoulsly
EXPORT_API bool latSendEvent(const latChar_t *eventAction, const latChar_t *eventLabel, const int eventValue );

// optionally call this function to log screenviews in Google Analytics (Create a Mobile app view under the same GA property).
// With the screenViews you have an alternative way of tracking your program.
// It will process your request asynchronoulsly
EXPORT_API bool latSendScreenview(const latChar_t *screenName);

// if isFatal = false, the incident will be logged in Google analtytics as Exception
// if isFatal = true, the incident will be logged in Google analtytics as Crash
EXPORT_API bool latSendException(const latChar_t *exceptionDescription, const bool isFatal);

// deprecated functions: they are now called latXXXXXX()
/*
EXPORT_API const latChar_t*	atGetVersion(void);
EXPORT_API const latChar_t*	atGetLogFilename(void);
EXPORT_API void		atEnableLogfile(const char *appName, const char *macBundleId);
EXPORT_API void		atDisableLogfile(void);
EXPORT_API bool		atInit(const char *appName, const char *appVersion, const char *appLicense, const char *appEdition, const char *propertyID, const bool disabledByTheUser);
EXPORT_API void		atFree(void);
EXPORT_API bool		atSendPageview(const char *pagePath, const char *pageTitle = NULL);
EXPORT_API bool		atSendEvent(const char *eventAction, const char *eventLabel, const int eventValue);
*/

