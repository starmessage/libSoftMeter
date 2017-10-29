//
//  apiAppTelemetry.h
//  appTelemetry
//
//  Copyright © 2017 StarMessage software. All rights reserved.
//	https://www.starmessagesoftware.com/libapptelemetry
//


#ifdef __APPLE__DELETED
 #pragma GCC visibility push(default)
#endif



#ifdef _WIN32
	// __declspec(dllexport) adds the export directive to the object file so you do not need to use a .def file. 
	// When exporting functions with either method, make sure to use the __stdcall calling convention. 
	#define EXPORT_DIRECTIVE	__declspec(dllexport) 
#else
	#define EXPORT_DIRECTIVE	__attribute__((visibility("default")))
#endif


#ifdef __cplusplus
	// extern "C": the function behind the descriptor should be compliled with the C standard naming mangling.
	#define C_EXPORT extern "C" 
#else
	#define C_EXPORT 
#endif

#define EXPORT_API		C_EXPORT EXPORT_DIRECTIVE


		

// get the version string of the library. You can call this anytime.
EXPORT_API const char*	atGetVersion(void);

// get the full path name of the log file. You can call this anytime.
EXPORT_API const char*	atGetLogFilename(void);

// enable or disable the writing to the log file. You can call this anytime. 
// If you do not call the Enable function, the default state is Disabled.
EXPORT_API void atEnableLogfile(const char *appName, const char *macBundleId);
EXPORT_API void atDisableLogfile(void);

// initialize the library.
// Parameters:
//		appLicense examples: free, trial, full, paid, etc
//		appEdition examples: Apple store, Special build, Standard, IOS, Mac, Win, etc
// Must be called before: AddPageview(), AddEvent(), Free()
EXPORT_API bool atInit(const char *appName, const char *appVersion,
							const char *appLicense, const char *appEdition, 
							const char *propertyID, const bool  userGaveConsent);

// free the library. 
// The function will wait for a maximum of 3 seconds for all pending async calls to gracefully finish.
// After freeing the library, you can call again atInit() if you need to reuse it.
EXPORT_API void atFree(void);


	
// call this function after program launch, on program exit and on every important form, window, screen 
// that you want to track. E.g. Main Window, Configuration settings, Main Window, Exiting
// It will process your request asynchronoulsly
EXPORT_API bool atSendPageview(const char *pagePath, const char *pageTitle=0);

// optionally call this function to log events in Google Analytics.
// With the events you have an alternative way of tracking your program.
// Depending on the things you want to track, maybe the Events will allow you to create 
//		a better model for understanding the usage of your program.
// It will process your request asynchronoulsly
EXPORT_API bool atSendEvent(const char *eventAction, const char *eventLabel, const int eventValue );



#ifdef __APPLE__DELETED
 #pragma GCC visibility pop
#endif


