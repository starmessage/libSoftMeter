//
//  SoftMeter-C-Api.v0.5.6.c
//	These are the superseded function names
//  Copyright © 2018 StarMessage software. All rights reserved.
//	https://www.starmessagesoftware.com/softmeter
//

// The prefix of the function names has changed from latXXXXX to smXXXX
#include <stdbool.h>
#include "SoftMeter-C-Api.h"
#include "SoftMeter-C-Api.v0.5.6.h"

const smChar_t*	latGetVersion(void) { return getVersion();  }
const smChar_t*	latGetLogFilename(void) { return getLogFilename(); }
void latEnableLogfile(const smChar_t *appName, const smChar_t *macBundleId) { enableLogfile(appName, macBundleId); }
void latDisableLogfile(void) { disableLogfile(); }
bool latInit(const smChar_t *appName, const smChar_t *appVersion, const smChar_t *appLicense, const smChar_t *appEdition, const smChar_t *propertyID, const bool  userGaveConsent)
		{	return start(appName, appVersion, appLicense, appEdition, propertyID, userGaveConsent); }
void latFree(void) { stop(); }
bool latSendPageview(const smChar_t *pagePath, const smChar_t *pageTitle) { return sendPageview(pagePath, pageTitle);  };
bool latSendScreenview(const smChar_t *screenName) { return sendScreenview(screenName); };
bool latSendEvent(const smChar_t *eventAction, const smChar_t *eventLabel, const int eventValue) 
		{ 	return sendEvent(eventAction, eventLabel, eventValue); };
bool latSendException(const smChar_t *exceptionDescription, const bool isFatal) { return sendException(exceptionDescription, isFatal);  }

