
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
	// Mac OS X Specific header stuff
	#include <TargetConditionals.h>

#endif


#ifdef __cplusplus
extern "C" {
#endif

	typedef const char* (*atGetVersion_t)(void);
	typedef const char* (*atGetLogFilename_t)(void);
	typedef void (*atEnableLogfile_t)(const char *, const char *);
	typedef void (*atDisableLogfile_t)(void);
	typedef bool (*atInit_t)(const char *, const char *, const char *, const char *, const char *, const bool);
	typedef void (*atFree_t)(void);
	typedef bool (*atSendPageview_t)(const char *, const char *);
	typedef bool (*atSendEvent_t)(const char *, const char *, const int);

#ifdef __cplusplus
}
#endif



// loads/unloads the .dylib or the .dll and create linked functions to the library functions
class AppTelemetry_cppApi : public cpccLinkedLibrary
{
private:

	atGetVersion_t			atGetVersion_ptr = NULL;
	atGetLogFilename_t		atGetLogFilename_ptr = NULL;
	atEnableLogfile_t		atEnableLogfile_ptr = NULL;
	atDisableLogfile_t		atDisableLogfile_ptr = NULL;
	atInit_t				atInit_ptr = NULL;
	atFree_t				atFree_ptr = NULL;
	atSendPageview_t		atSendPageview_ptr = NULL;
	atSendEvent_t			atSendEvent_ptr = NULL;

	bool					m_errorsExist = false;


public:

	explicit AppTelemetry_cppApi(const char *aLibraryfilename) : cpccLinkedLibrary(aLibraryfilename)
	{
		atGetVersion_ptr = (atGetVersion_t)getFunction("atGetVersion");
		if (!atGetVersion_ptr)
			m_errorsExist = true;

		atGetLogFilename_ptr = (atGetLogFilename_t)getFunction("atGetLogFilename");
		if (!atGetLogFilename_ptr)
			m_errorsExist = true;

		atEnableLogfile_ptr = (atEnableLogfile_t)getFunction("atEnableLogfile");
		if (!atEnableLogfile_ptr)
			m_errorsExist = true;

		atInit_ptr = (atInit_t)getFunction("atInit");
		if (!atInit_ptr)
			m_errorsExist = true;

		atFree_ptr = (atFree_t)getFunction("atFree");
		if (!atFree_ptr)
			m_errorsExist = true;

		atSendPageview_ptr = (atSendPageview_t)getFunction("atSendPageview");
		if (!atSendPageview_ptr)
			m_errorsExist = true;

		atSendEvent_ptr = (atSendEvent_t)getFunction("atSendEvent");
		if (!atSendEvent_ptr)
			m_errorsExist = true;
	}


public:
	const bool errorsExist(void) { return m_errorsExist;  }

	const char*	atGetVersion(void)
	{
        if (!atGetVersion_ptr)
			return  "Error in version";
		return atGetVersion_ptr();
	}

	const char*	atGetLogFilename(void)
	{
        if (!atGetLogFilename_ptr)
			return "atGetLogFilename() Errors exist";
		return atGetLogFilename_ptr();
	}

	void		atEnableLogfile(const char *appName, const char *macBundleId)
	{
		if (atEnableLogfile_ptr)
			atEnableLogfile_ptr(appName, macBundleId);
	}

	void		atDisableLogfile(void)
	{
		if (atEnableLogfile_ptr)
			atDisableLogfile_ptr();
	}

	bool		atInit(const char *appName, const char *appVersion, const char *appLicense, const char *appEdition, const char *propertyID, const bool disabledByTheUser)
	{
		if (atInit_ptr)
			return atInit_ptr(appName, appVersion, appLicense, appEdition, propertyID, disabledByTheUser);
		return false;
	}

	void		atFree(void)
	{
		if (atFree_ptr)
			atFree_ptr();
	}

	bool		atSendPageview(const char *pagePath, const char *pageTitle = NULL)
	{
		if (atSendPageview_ptr)
			return atSendPageview_ptr(pagePath, pageTitle);
		return false;
	}

	bool		atSendEvent(const char *eventAction, const char *eventLabel, const int eventValue)
	{
		if (atSendEvent_ptr)
			return atSendEvent_ptr(eventAction, eventLabel, eventValue);
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
