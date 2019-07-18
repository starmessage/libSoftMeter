//
//  SoftMeter-C-Api-AIO.h
//	All-in-one functions
//  Copyright © 2018 StarMessage software. All rights reserved.
//	https://www.starmessagesoftware.com/softmeter
//

#pragma once

#include "SoftMeter-C-Api.h"

typedef bool (CALL_CONV *aio_sendEvent_t) (const TCHAR *, const TCHAR*, const TCHAR*, const TCHAR*, const TCHAR*, const bool, const TCHAR*, const TCHAR*, const int );

/* 	About the all-in-one functions:
 	Some tools (e.g. Installaware) allow you to load a DLL, make a single call and unload the DLL.
	This breaks the default calling sequence of SoftMeter, where start() initializes the library, 
	sendXXX functions send hits to Google Analytics and finally, stop() gracefully shuts down the 
	library, giving time also for any unfinished asynchronous calls to complete.
  
  	To ease the implementation of SoftMeter in such tools, new all-in-one function will be added.  	
*/
  	  
//	The function, aio_sendEvent() performs the whole sequence of start(), sendEvent(), stop.
//  This allows you to send with a single function call, an event to Google Analytics.
//  It was created for tools like Installaware where you can only call one function from the DLL 
//  before the DLL gets unloaded. In such cases, you cannot keep the DLL loaded in memory and do
//  successive function calls, preserving the internal state of the DLL. 
//  For its parameters, aio_sendEvent() combines the parameters of start() and sendEvent() 
//  In the DLLs there also its counterpart, aio_sendEvent_stdcall()
EXPORT_API bool CALL_CONV aio_sendEvent(const TCHAR*appName, const TCHAR*appVersion,
                                                const TCHAR*appLicense, const TCHAR*appEdition,
                                                const TCHAR*propertyID, const bool  userGaveConsent,
                                                const TCHAR*eventAction, const TCHAR*eventLabel, const int eventValue
                                                );


#ifdef _WIN32		// __stdcall version of the functions 

// typedef bool (*start_stdcall_t) __stdcall  (const char *, const char *, const char *, const char *, const char *, const bool, const TCHAR *, const TCHAR *, const int );

/*
 exported by DEF
// appears in the DLL as  _aio_sendEvent_stdcall@36
EXPORT_API bool __stdcall aio_sendEvent_stdcall(const TCHAR *appName, const TCHAR *appVersion,
	const TCHAR *appLicense, const TCHAR *appEdition,
	const TCHAR *propertyID, const bool  userGaveConsent,
	const TCHAR *eventAction, const TCHAR *eventLabel, const int eventValue
	);
	*/

#endif
