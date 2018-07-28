//
//  SoftMeter-C-Api-AIO.h
//	All-in-one functions
//  Copyright © 2018 StarMessage software. All rights reserved.
//	https://www.starmessagesoftware.com/softmeter
//

#pragma once

#include "SoftMeter-C-Api.h"

typedef bool (*aio_sendEvent_t) (const smChar_t *, const smChar_t *, const smChar_t *, const smChar_t *, const smChar_t *, const bool, const smChar_t *, const smChar_t *, const int );

/* 	About the all-in-one functions:
 	Some tools (e.g. Installaware) allow you to load a DLL, make a single call and unload the DLL.
	This breaks the default calling sequence of SoftMeter, where start() initializes the library, 
	sendXXX functions send hits to Google Analytics and finally, stop() gracefully shuts down the 
	library, giving time also for any unfinished asynchronous calls to complete.
  
  	To ease the implementation of SoftMeter in such tools, new all-in-one function will be added.  	
*/
  	  
//	The function, aio_sendEvent() combines the parameters of start() and sendEvent() and performs the whole 
//	sequence of start(), sendEvent(), stop.
EXPORT_API bool aio_sendEvent(const smChar_t *appName, const smChar_t *appVersion,
                                                const smChar_t *appLicense, const smChar_t *appEdition,
                                                const smChar_t *propertyID, const bool  userGaveConsent,
                                                const smChar_t *eventAction, const smChar_t *eventLabel, const int eventValue
                                                );


#ifdef _WIN32		// __stdcall version of the functions 

// typedef bool (*start_stdcall_t) __stdcall  (const char *, const char *, const char *, const char *, const char *, const bool, const smChar_t *, const smChar_t *, const int );

/*
 exported by DEF
// appears in the DLL as  _aio_sendEvent_stdcall@36
EXPORT_API bool __stdcall aio_sendEvent_stdcall(const smChar_t *appName, const smChar_t *appVersion,
	const smChar_t *appLicense, const smChar_t *appEdition,
	const smChar_t *propertyID, const bool  userGaveConsent,
	const smChar_t *eventAction, const smChar_t *eventLabel, const int eventValue
	);
	*/

#endif
