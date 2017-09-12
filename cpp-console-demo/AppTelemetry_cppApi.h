
/*  *****************************************
 *  File:		AppTelemetry_cppApi.h
 *	Purpose:	Load the DLL or the DYLIB and expose all their functions via an object
 *	*****************************************
 *  Library:	
 *  Copyright: 	2017 StarMessage software.
 *  License: 	Free for opensource projects.
 *  			Commercial license exists for closed source projects.
 *	Web:		http://www.StarMessageSoftware.com/libapptelemetry
  *	email:		sales (at) starmessage.info
 *	*****************************************
 */

#pragma once

// get this file from
// https://github.com/starmessage/cpcc/blob/master/core.cpccLinkLibrary.h
#include "core.cpccLinkLibrary.h"



#if defined(__APPLE__)
	// Mac OS X Specific header stuff here
	#include <TargetConditionals.h>
	// #define WINAPI
#endif


#ifdef __cplusplus
extern "C" {
#endif

	typedef const char* (*appTelemetryGetVersion_t)(void);
	typedef const char* (*appTelemetryGetLogFilename_t)(void);
	typedef void (*appTelemetryEnableLogfile_t)(const char *, const char *);
	typedef void (*appTelemetryDisableLogfile_t)(void);
	typedef bool (*appTelemetryInit_t)(const char *, const char *, const char *);
	typedef void (*appTelemetryFree_t)(void);
	typedef bool (*appTelemetryAddPageview_t)(const char *, const char *);
	typedef bool (*appTelemetryAddEvent_t)(const char *, const char *, const int);

#ifdef __cplusplus
}
#endif



// loads/unloads the .dylib or the .dll and create linked functions to the library functions
class AppTelemetry_cppApi : public cpccLinkedLibrary
{
private:

	appTelemetryGetVersion_t		appTelemetryGetVersion_ptr = NULL;
	appTelemetryGetLogFilename_t	appTelemetryGetLogFilename_ptr = NULL;
	appTelemetryEnableLogfile_t		appTelemetryEnableLogfile_ptr = NULL;
	appTelemetryDisableLogfile_t	appTelemetryDisableLogfile_ptr = NULL;
	appTelemetryInit_t				appTelemetryInit_ptr = NULL;
	appTelemetryFree_t				appTelemetryFree_ptr = NULL;
	appTelemetryAddPageview_t		appTelemetryAddPageview_ptr = NULL;
	appTelemetryAddEvent_t			appTelemetryAddEvent_ptr = NULL;

	bool							m_errorsExist = false;


public:

	explicit AppTelemetry_cppApi(const char *aLibraryfilename) : cpccLinkedLibrary(aLibraryfilename)
	{
		appTelemetryGetVersion_ptr = (appTelemetryGetVersion_t)getFunction("appTelemetryGetVersion");
		if (!appTelemetryGetVersion_ptr)
			m_errorsExist = true;

		appTelemetryGetLogFilename_ptr = (appTelemetryGetLogFilename_t)getFunction("appTelemetryGetLogFilename");
		if (!appTelemetryGetLogFilename_ptr)
			m_errorsExist = true;

		appTelemetryEnableLogfile_ptr = (appTelemetryEnableLogfile_t)getFunction("appTelemetryEnableLogfile");
		if (!appTelemetryEnableLogfile_ptr)
			m_errorsExist = true;

		appTelemetryInit_ptr = (appTelemetryInit_t)getFunction("appTelemetryInit");
		if (!appTelemetryInit_ptr)
			m_errorsExist = true;

		appTelemetryFree_ptr = (appTelemetryFree_t)getFunction("appTelemetryFree");
		if (!appTelemetryFree_ptr)
			m_errorsExist = true;

		appTelemetryAddPageview_ptr = (appTelemetryAddPageview_t)getFunction("appTelemetryAddPageview");
		if (!appTelemetryAddPageview_ptr)
			m_errorsExist = true;

		appTelemetryAddEvent_ptr = (appTelemetryAddEvent_t)getFunction("appTelemetryAddEvent");
		if (!appTelemetryAddEvent_ptr)
			m_errorsExist = true;
	}


public:
	const bool errorsExist(void) { return m_errorsExist;  }

	const char*	appTelemetryGetVersion(void)
	{
        if (!appTelemetryGetVersion_ptr)
			return "appTelemetryGetVersion() Errors exist";
		return appTelemetryGetVersion_ptr();
	}

	const char*	appTelemetryGetLogFilename(void)
	{
        if (!appTelemetryGetLogFilename_ptr)
			return "appTelemetryGetLogFilename() Errors exist";
		return appTelemetryGetLogFilename_ptr();
	}

	void		appTelemetryEnableLogfile(const char *appName, const char *macBundleId)
	{
		if (appTelemetryEnableLogfile_ptr)
			appTelemetryEnableLogfile_ptr(appName, macBundleId);
	}

	void		appTelemetryDisableLogfile(void)
	{
		if (appTelemetryEnableLogfile_ptr)
			appTelemetryDisableLogfile_ptr();
	}

	bool		appTelemetryInit(const char *appName, const char *appVersion, const char *propertyID)
	{
		if (appTelemetryInit_ptr)
			return appTelemetryInit_ptr(appName, appVersion, propertyID);
		return false;
	}

	void		appTelemetryFree(void)
	{
		if (appTelemetryFree_ptr)
			appTelemetryFree_ptr();
	}

	bool		appTelemetryAddPageview(const char *pagePath, const char *pageTitle = NULL)
	{
		if (appTelemetryAddPageview_ptr)
			return appTelemetryAddPageview_ptr(pagePath, pageTitle);
		return false;
	}

	bool		appTelemetryAddEvent(const char *eventAction, const char *eventLabel, const int eventValue)
	{
		if (appTelemetryAddEvent_ptr)
			return appTelemetryAddEvent_ptr(eventAction, eventLabel, eventValue);
		return false;
	}

};

// If you want a global object of the appTelemetry, so you can use it from different parts of your program,
// implement (define) somewhere in your source code (.cpp file) this function
// extern AppTelemetry_cppApi &appTelem(void);
/* e.g. as singleton:

	#include "AppTelemetry_cppApi..h"
	.....
	AppTelemetry_cppApi &appTelem(void)
	{
		static AppTelemetry_cppApi _instance("StarMessage-libAppTelemetry"); // this is the filename of the .dylib or the .dll
		return _instance;
	}

*/
