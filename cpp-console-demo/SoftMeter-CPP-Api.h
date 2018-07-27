
/*  *****************************************
 *  File:		SoftMeter-CPP-Api.h
 *	Purpose:	Load the DLL or the DYLIB and expose all their functions via an object
 *	*****************************************
 *  Library:	SoftMeter
 *  Copyright: 	2018 StarMessage software.
 *  License: 	Free for opensource projects.
 *  			Commercial license exists for closed source projects.
 *	Web:		http://www.StarMessageSoftware.com/softmeter
  *	email:		sales (at) starmessage.info
 *	*****************************************
 */

#pragma once

// get the latest version of this file from
// https://github.com/starmessage/cpcc/blob/master/core.cpccLinkLibrary.h
#include "core.cpccLinkLibrary.h"


#if defined(__APPLE__)
	// Mac OS X Specific header stuff
	#include <TargetConditionals.h>

#endif


#ifdef __cplusplus
extern "C" {
#endif

	// Under Windows, these the function pointers take the __cdecl DLL calling convention
	typedef const char* (*gtVersion_t)(void);
	typedef const char* (*getLogFilename_t)(void);
	typedef void (*enableLogfile_t)(const char *, const char *);
	typedef void (*disableLogfile_t)(void);
	typedef bool (*start_t)(const char *, const char *, const char *, const char *, const char *, const bool);
	typedef void (*stop_t)(void);
	typedef bool (*sendPageview_t)(const char *, const char *);
	typedef bool (*sendEvent_t)(const char *, const char *, const int);
	typedef bool (*sendScreenview_t)(const char *);
	typedef bool (*sendException_t)(const char *, const bool);

	// Under MacOS, the following pointers are not needed.
	#ifdef _WIN32
		// Under Windows, these the function pointers take the __stdcall DLL calling convention (currently only demonstrating start()
		// The function names are appended with _stdcall
		// Windows applications can load either set of functions
		typedef bool __stdcall (*start_stdcall_t)(const char *, const char *, const char *, const char *, const char *, const bool);
	#endif
	
#ifdef __cplusplus
}
#endif


// loads/unloads the .dylib or the .dll and create linked functions to the library functions
class AppTelemetry_cppApi : public cpccLinkedLibrary
{
private:

	gtVersion_t			getVersion_ptr = NULL;
	getLogFilename_t	getLogFilename_ptr = NULL;
	enableLogfile_t		enableLogfile_ptr = NULL;
	disableLogfile_t	disableLogfile_ptr = NULL;
	start_t				start_ptr = NULL;
	stop_t				stop_ptr = NULL;
	sendPageview_t		sendPageview_ptr = NULL;
	sendEvent_t			sendEvent_ptr = NULL;
	sendScreenview_t	sendScreenview_ptr = NULL;
	sendException_t		sendException_ptr = NULL;
	bool				m_errorsExist = false;

public:

	explicit AppTelemetry_cppApi(const char *aLibraryfilename) : cpccLinkedLibrary(aLibraryfilename)
	{
		getVersion_ptr = (gtVersion_t)getFunction("getVersion");
		if (!getVersion_ptr)
			m_errorsExist = true;

		getLogFilename_ptr = (getLogFilename_t)getFunction("getLogFilename");
		if (!getLogFilename_ptr)
			m_errorsExist = true;

		enableLogfile_ptr = (enableLogfile_t)getFunction("enableLogfile");
		if (!enableLogfile_ptr)
			m_errorsExist = true;

		start_ptr = (start_t)getFunction("start");
		if (!start_ptr)
			m_errorsExist = true;

		stop_ptr = (stop_t)getFunction("stop");
		if (!stop_ptr)
			m_errorsExist = true;

		sendPageview_ptr = (sendPageview_t)getFunction("sendPageview");
		if (!sendPageview_ptr)
			m_errorsExist = true;

		sendEvent_ptr = (sendEvent_t)getFunction("sendEvent");
		if (!sendEvent_ptr)
			m_errorsExist = true;

		sendScreenview_ptr = (sendScreenview_t)getFunction("sendScreenview");
		if (!sendScreenview_ptr)
			m_errorsExist = true;

		sendException_ptr = (sendException_t)getFunction("sendException");
		if (!sendException_ptr)
			m_errorsExist = true;
	}


public:
	const bool errorsExist(void) { return m_errorsExist;  }


	// functions
	const char*	getVersion(void)
	{
        if (!getVersion_ptr)
			return "null getVersion_ptr";
		return getVersion_ptr();
	}

	const char*	getLogFilename(void)
	{
        if (!getLogFilename_ptr)
			return "null getLogFilename_ptr";
		return getLogFilename_ptr();
	}

	void		enableLogfile(const char *appName, const char *macBundleId)
	{
		if (enableLogfile_ptr)
			enableLogfile_ptr(appName, macBundleId);
	}

	void		disableLogfile(void)
	{
		if (enableLogfile_ptr)
			disableLogfile_ptr();
	}

	bool		start(const char *appName, const char *appVersion, const char *appLicense, const char *appEdition, const char *propertyID, const bool disabledByTheUser)
	{
		if (start_ptr)
			return start_ptr(appName, appVersion, appLicense, appEdition, propertyID, disabledByTheUser);
		return false;
	}

	void		stop(void)
	{
		if (stop_ptr)
			stop_ptr();
	}

	bool		sendPageview(const char *pagePath, const char *pageTitle )
	{
		if (sendPageview_ptr)
			return sendPageview_ptr(pagePath, pageTitle);
		return false;
	}

	bool		sendEvent(const char *eventAction, const char *eventLabel, const int eventValue)
	{
		if (sendEvent_ptr)
			return sendEvent_ptr(eventAction, eventLabel, eventValue);
		return false;
	}

	bool	sendScreenview(const char *screenName)
	{
		if (sendScreenview_ptr)
			return sendScreenview_ptr(screenName);
		return false;
	}

	bool	sendException(const char *ExceptionDescription, bool isFatal)
	{
		if (sendScreenview_ptr)
			return sendException_ptr(ExceptionDescription, isFatal);
		return false;
	}

	// deprecated functions of api v5.6
	const char*	latGetVersion(void) { return getVersion(); }
	const char*	latGetLogFilename(void) { return getLogFilename(); }
	void latEnableLogfile(const char *appName, const char *macBundleId) 	{ enableLogfile(appName, macBundleId); }
	void latDisableLogfile(void) { disableLogfile(); }
	bool latInit(const char *appName, const char *appVersion, const char *appLicense, const char *appEdition, const char *propertyID, const bool disabledByTheUser)
 		{ 	return start(appName, appVersion, appLicense, appEdition, propertyID, disabledByTheUser); }
	void latFree(void) { stop(); }
	bool latSendPageview(const char *pagePath, const char *pageTitle ) 	{	return sendPageview(pagePath, pageTitle); }
	bool latSendEvent(const char *eventAction, const char *eventLabel, const int eventValue)	{ 	return sendEvent(eventAction, eventLabel, eventValue); }
	bool latSendScreenview(const char *screenName)	{	return sendScreenview(screenName);	}
	bool latSendException(const char *ExceptionDescription, bool isFatal)	{	return sendException(ExceptionDescription, isFatal);	}

};

// If you want a global object of the appTelemetry, so you can use it from different parts of your program,
// implement (define) somewhere in your source code (.cpp file) this function
// extern AppTelemetry_cppApi &appTelem(void);
/* e.g. as singleton:

	#include "AppTelemetry_cppApi..h"
	.....
	AppTelemetry_cppApi &appTelem(void)
	{
		// static might misbehave in winXP, better use a pointer and allocate the object with new()
		static AppTelemetry_cppApi _instance("StarMessage-libAppTelemetry"); // this is the filename of the .dylib or the .dll
		return _instance;
	}

*/
