//
//  SoftMeter-C-Api.v0.5.6.h
//	These are the superseded function names
//  Copyright © 2018 StarMessage software. All rights reserved.
//	https://www.starmessagesoftware.com/softmeter
//

// The prefix of the function names has changed from latXXXXX to smXXXX
#include <stdbool.h>
#include "SoftMeter-C-Api.h"



EXPORT_API const smChar_t*	latGetVersion(void);
EXPORT_API const smChar_t*	latGetLogFilename(void);
EXPORT_API void latEnableLogfile(const smChar_t *appName, const smChar_t *macBundleId);
EXPORT_API void latDisableLogfile(void);
EXPORT_API bool latInit(const smChar_t *appName, const smChar_t *appVersion, const smChar_t *appLicense, const smChar_t *appEdition, const smChar_t *propertyID, const bool  userGaveConsent);
EXPORT_API void latFree(void);
EXPORT_API bool latSendPageview(const smChar_t *pagePath, const smChar_t *pageTitle);
EXPORT_API bool latSendScreenview(const smChar_t *screenName);
EXPORT_API bool latSendEvent(const smChar_t *eventAction, const smChar_t *eventLabel, const int eventValue);
EXPORT_API bool latSendException(const smChar_t *exceptionDescription, const bool isFatal);

