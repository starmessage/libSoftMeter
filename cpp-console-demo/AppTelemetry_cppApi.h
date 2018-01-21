
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

	typedef const char* (*latGetVersion_t)(void);
	typedef const char* (*latGetLogFilename_t)(void);
	typedef void (*latEnableLogfile_t)(const char *, const char *);
	typedef void (*latDisableLogfile_t)(void);
	typedef bool (*latInit_t)(const char *, const char *, const char *, const char *, const char *, const bool);
	typedef void (*latFree_t)(void);
	typedef bool (*latSendPageview_t)(const char *, const char *);
	typedef bool (*latSendEvent_t)(const char *, const char *, const int);
	typedef bool(*latSendScreenview_t)(const char *);

#ifdef __cplusplus
}
#endif



// loads/unloads the .dylib or the .dll and create linked functions to the library functions
class AppTelemetry_cppApi : public cpccLinkedLibrary
{
private:

	latGetVersion_t			latGetVersion_ptr = NULL;
	latGetLogFilename_t		latGetLogFilename_ptr = NULL;
	latEnableLogfile_t		latEnableLogfile_ptr = NULL;
	latDisableLogfile_t		latDisableLogfile_ptr = NULL;
	latInit_t				latInit_ptr = NULL;
	latFree_t				latFree_ptr = NULL;
	latSendPageview_t		latSendPageview_ptr = NULL;
	latSendEvent_t			latSendEvent_ptr = NULL;
	latSendScreenview_t		latSendScreenview_ptr = NULL;
	bool					m_errorsExist = false;


public:

	explicit AppTelemetry_cppApi(const char *aLibraryfilename) : cpccLinkedLibrary(aLibraryfilename)
	{
		latGetVersion_ptr = (latGetVersion_t)getFunction("latGetVersion");
		if (!latGetVersion_ptr)
			m_errorsExist = true;

		latGetLogFilename_ptr = (latGetLogFilename_t)getFunction("latGetLogFilename");
		if (!latGetLogFilename_ptr)
			m_errorsExist = true;

		latEnableLogfile_ptr = (latEnableLogfile_t)getFunction("latEnableLogfile");
		if (!latEnableLogfile_ptr)
			m_errorsExist = true;

		latInit_ptr = (latInit_t)getFunction("latInit");
		if (!latInit_ptr)
			m_errorsExist = true;

		latFree_ptr = (latFree_t)getFunction("latFree");
		if (!latFree_ptr)
			m_errorsExist = true;

		latSendPageview_ptr = (latSendPageview_t)getFunction("latSendPageview");
		if (!latSendPageview_ptr)
			m_errorsExist = true;

		latSendEvent_ptr = (latSendEvent_t)getFunction("latSendEvent");
		if (!latSendEvent_ptr)
			m_errorsExist = true;

		latSendScreenview_ptr = (latSendScreenview_t)getFunction("latSendScreenview");
		if (!latSendScreenview_ptr)
			m_errorsExist = true;
	}


public:
	const bool errorsExist(void) { return m_errorsExist;  }

	// deprecated fuctions:
	const char*	atGetVersion(void) { return latGetVersion();  }
	const char*	atGetLogFilename(void) { return latGetLogFilename(); }
	void		atEnableLogfile(const char *appName, const char *macBundleId) { latEnableLogfile(appName, macBundleId); }
	void		atDisableLogfile(void) { latDisableLogfile();  }
	bool		atInit(const char *appName, const char *appVersion, const char *appLicense, const char *appEdition, const char *propertyID, const bool disabledByTheUser)
		{	return latInit(appName, appVersion, appLicense, appEdition, propertyID, disabledByTheUser); }
	void		atFree(void) { latFree(); }
	bool		atSendPageview(const char *pagePath, const char *pageTitle = NULL) 
		{	return latSendPageview(pagePath, pageTitle);  }
	bool		atSendEvent(const char *eventAction, const char *eventLabel, const int eventValue) 
		{		return latSendEvent(eventAction, eventLabel, eventValue);	}

	// new functions
	const char*	latGetVersion(void)
	{
        if (!latGetVersion_ptr)
			return  "Error in version";
		return latGetVersion_ptr();
	}

	const char*	latGetLogFilename(void)
	{
        if (!latGetLogFilename_ptr)
			return "latGetLogFilename() Errors exist";
		return latGetLogFilename_ptr();
	}

	void		latEnableLogfile(const char *appName, const char *macBundleId)
	{
		if (latEnableLogfile_ptr)
			latEnableLogfile_ptr(appName, macBundleId);
	}

	void		latDisableLogfile(void)
	{
		if (latEnableLogfile_ptr)
			latDisableLogfile_ptr();
	}

	bool		latInit(const char *appName, const char *appVersion, const char *appLicense, const char *appEdition, const char *propertyID, const bool disabledByTheUser)
	{
		if (latInit_ptr)
			return latInit_ptr(appName, appVersion, appLicense, appEdition, propertyID, disabledByTheUser);
		return false;
	}

	void		latFree(void)
	{
		if (latFree_ptr)
			latFree_ptr();
	}

	bool		latSendPageview(const char *pagePath, const char *pageTitle = NULL)
	{
		if (latSendPageview_ptr)
			return latSendPageview_ptr(pagePath, pageTitle);
		return false;
	}

	bool		latSendEvent(const char *eventAction, const char *eventLabel, const int eventValue)
	{
		if (latSendEvent_ptr)
			return latSendEvent_ptr(eventAction, eventLabel, eventValue);
		return false;
	}

	bool	latSendScreenview(const char *screenName)
	{
		if (latSendScreenview_ptr)
			return latSendScreenview_ptr(screenName);
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
