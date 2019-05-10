
/*  *****************************************
 *  File:		SoftMeter-CPP-Api.h
 *	Purpose:	Load the DLL or the DYLIB and expose all their functions via an object
 *	*****************************************
 *  Library:	SoftMeter
 *  Copyright: 	StarMessage software.
 *  License: 	Free for opensource projects.
 *  			Commercial license exists for closed source projects.
 *	Web:		http://www.StarMessageSoftware.com/softmeter
  *	email:		sales (at) starmessage.info
 *	*****************************************
 */

#pragma once

//	see also: SoftMeter-C-Api-AIO.h for the all-in-one functions

// get the latest version of "core.cpccLinkLibrary.h" from
// https://github.com/starmessage/cpcc/blob/master/core.cpccLinkLibrary.h
#include "core.cpccLinkLibrary.h"


#if defined(__APPLE__)
	// Mac OS X Specific header stuff
	#include <TargetConditionals.h>
    
#endif

#ifndef _WIN32
    #define WIN_CALL_CONV 
    #ifndef TCHAR // for non Windows systems
        #define  TCHAR char
    #endif
#else
    #define WIN_CALL_CONV __stdcall
#endif



#ifdef __cplusplus
extern "C" {
#endif

	// Under Windows, these function pointers use the __stdcall DLL calling convention
	typedef const char* (WIN_CALL_CONV *getVersion_t)(void);
	typedef const char* (WIN_CALL_CONV *getLogFilename_t)(void);
	typedef void (WIN_CALL_CONV *enableLogfile_t)(const char *, const char *);
	typedef void (WIN_CALL_CONV *disableLogfile_t)(void);
    typedef void(WIN_CALL_CONV *setOptions_t)(const char *);
	typedef bool (WIN_CALL_CONV *start_t)(const char *, const char *, const char *, const char *, const char *, const bool);
	typedef void (WIN_CALL_CONV *stop_t)(void);
	typedef bool (WIN_CALL_CONV *sendPageview_t)(const char *, const char *);
	typedef bool (WIN_CALL_CONV *sendEvent_t)(const char *, const char *, const int);
	typedef bool (WIN_CALL_CONV *sendScreenview_t)(const char *);
	typedef bool (WIN_CALL_CONV *sendException_t)(const char *, const bool);

	// Under MacOS, the following pointers are not needed.
	#ifdef _WIN32
		// Under Windows, if you need to use the __cdecl calling convention, 
        // these are the function pointers for the __cdecl DLL functions (currently only demonstrating start()
		// The function names are appended with _cdecl
		typedef bool (__cdecl *start_cdecl_t)(const char *, const char *, const char *, const char *, const char *, const bool);
	#endif
	
#ifdef __cplusplus
}
#endif


// loads/unloads the .dylib or the .dll and create linked functions to the library functions
class AppTelemetry_cppApi : public cpccLinkedLibrary
{
private:

	getVersion_t		getVersion_ptr = NULL;
	getLogFilename_t	getLogFilename_ptr = NULL;
	enableLogfile_t		enableLogfile_ptr = NULL;
	disableLogfile_t	disableLogfile_ptr = NULL;
    // deprecated
    //setProxy_t          setProxy_ptr = NULL;
    //setSubscription_t   setSubscription_ptr = NULL;
    setOptions_t        setOptions_ptr = NULL;
	start_t				start_ptr = NULL;
	stop_t				stop_ptr = NULL;
	sendPageview_t		sendPageview_ptr = NULL;
	sendEvent_t			sendEvent_ptr = NULL;
	sendScreenview_t	sendScreenview_ptr = NULL;
	sendException_t		sendException_ptr = NULL;
	bool				m_errorsExist = false;

public:

	explicit AppTelemetry_cppApi(const TCHAR *aLibraryfilename) : cpccLinkedLibrary(aLibraryfilename)
	{
		getVersion_ptr = (getVersion_t)getFunction("getVersion");
		if (!getVersion_ptr)
			m_errorsExist = true;

		getLogFilename_ptr = (getLogFilename_t)getFunction("getLogFilename");
		if (!getLogFilename_ptr)
			m_errorsExist = true;

		enableLogfile_ptr = (enableLogfile_t)getFunction("enableLogfile");
		if (!enableLogfile_ptr)
			m_errorsExist = true;
        
        setOptions_ptr = (setOptions_t)getFunction("setOptions");
        if (!setOptions_ptr)
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

    
    void setOptions(const char *developerOptions)
    {
        if (setOptions_ptr)
        {
            setOptions_ptr(developerOptions);
        }
        else
        {
            // std::cerr << "Error #7163: NULL setSubscription_ptr" << std::endl;
        }
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



};

// If you want a global object of the appTelemetry, so you can use it from different parts of your program,
// implement (define) somewhere in your source code (.cpp file) this function
// extern AppTelemetry_cppApi &appTelem(void);
/* e.g. as singleton:

	#include "AppTelemetry_cppApi..h"
	.....
	AppTelemetry_cppApi &appTelem(void)
	{
 
		// use a pointer and allocate the object with new() so that the object is allocated in the heap memory
		static AppTelemetry_cppApi _instance("StarMessage-libAppTelemetry"); // this is the filename of the .dylib or the .dll
		return _instance;
	}

*/
