//
//  SoftMeter-C-Api-AIO.h
//	All-in-one functions
//  Copyright © 2018 StarMessage software. All rights reserved.
//	https://www.starmessagesoftware.com/softmeter
//

#pragma once

#include "SoftMeter-C-Api.h"

#ifdef _WIN32		// __stdcall version of the functions 

// typedef bool (*start_stdcall_t) __stdcall  (const char *, const char *, const char *, const char *, const char *, const bool, const smChar_t *, const smChar_t *, const int );

// appears in the DLL as  _aio_sendEvent_stdcall@36
EXPORT_API bool __stdcall aio_sendEvent_stdcall(const smChar_t *appName, const smChar_t *appVersion,
	const smChar_t *appLicense, const smChar_t *appEdition,
	const smChar_t *propertyID, const bool  userGaveConsent,
	const smChar_t *eventAction, const smChar_t *eventLabel, const int eventValue
	);


#endif