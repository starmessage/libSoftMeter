# [libSoftMeter version history/Changelog](https://github.com/starmessage/libSoftMeter/blob/master/ChangeLog.md)
All notable changes to this project will be documented in this file.

SoftMeter is a free or low cost application analytics library for Windows, MacOS and IOS.   
[[libSoftMeter website](https://www.starmessagesoftware.com/softmeter)] [[libSoftMeter on GitHub](https://github.com/starmessage/libSoftMeter)].


## [2.0.3] - 2023-05-09
- Internal improvements.

- to send your GA4 hits as debug hits (visible under Admin->debug view), 
  call:
    setOptions("debugHits=On");
  Must be called before calling the start() function.

- new function 
    bool setGA4UserProperty(const char* aPropertyName, const char* aPropertyValue);
  sets a GA4 user property. You can add in this way many user properties.
  Must be called before calling the start() function.
  The PropertyName must not contain spaces or other special characters because the whole hit will be rejected by Google Analytics 4.


## [2.0.2] - 2023-04-07
- Internal improvements.
- remove debug flag
- Drop API function setCustomDimension
- cpp-demo programs v110 support only GA4 properties (dropped support for Universal analytics UA-)
Usage: cpp-demo-win G-xxxxxxx YourApiSecret


## [2.0.1] - 2023-01-11
- Internal improvements.
- Screen resolution, user language, CPU model and cores, Total and free memory are sent to Google Analytics 4 as user properties.

## [2.0.0] - 2023-01-02
- Support for the new GA4 type (G-xxxxxxxx) of Google analytics properties.

## [1.4.4] - 2022-02-21 - Windows only version

### Fixed
- Windows XP compatibility 

### Changed
- start() must be called only once. And terminated with stop().
- Internal improvements


## [1.4.2] - 2020-11-20

### Added
- [MacOS silicon (ARM64) support](https://www.starmessagesoftware.com/blog/compile-macos-desktop-application-arm64-apple-silicon-m1-chip-cpu). Starting with v1.4.2, the dylib of SoftMeter will be distributed as "fat" universal file containing both architectures for intel's x86_64 and Apple's M1 processor, ARM64.
To verify use the command:
``` 
lipo -info libSoftMeter.dylib
```  
The results should show:
``` 
Architectures in the fat file: libSoftMeter.dylib are: x86_64 arm64 
```  

### Changed
- MacOS dylib: the minimum supported MacOS version had to change from OS X Lion 10.7 to OS X Mavericks 10.9.
- Internal improvements

## [1.4.1] - 2020-10-10

### Fixed
- In Windows DLL: undecorate _setCustomDimension@8 from the DLL so it can be linked with its simple function name

### Added
- AppEdition sent to the GA field of CampaignCode. It can be seen via GA reports as CampaignCode.
- In Windows DLL: In order to call the SoftMeter DLL from desktop software made by VisualNEO Win, the __cdecl version of the all-in-one sendEvent() function was added:
``` 
aio_sendEvent_cdecl()
``` 
Reminder: the event hits are only supported by the PRO editions of SoftMeter.

- MacOS: ARM64 architecture compatibility with a universal dylib.

### Changed
- In Windows DLL: Removed the xxxxxx_stdcall version of the functions as the plain function names are already using the stdcall calling convension.

- Windows: digitally signed dlls and cpp-demo-win executables.

## [1.4] - 2020-09-01

### Added

- New function to send custom dimensions to Google Analytics. 
    ```
    bool setCustomDimension(const int dimensionIndex, const TCHAR* dimensionValue);  
    ```
   The customDimension will be sent together with the next pageView, Event, or ScreenView hit.

- SoftMeter can automatically collect extra system information:  
    - CPU cores  
    - Total RAM memory  
    - Free RAM memory  
    - Free RAM memory (The numbers are rounded so that they appear in the reporting in aggregated groups)
    - CPU model, e.g. Intel(R) Core(TM) i5-3470 CPU @ 3.20GHz

    To enable the collection of this information call the function:
    ``` 
    setOptions("ExtraInfo=15");  
    ```
    before calling the start() function.
    Read more about the reporting for the hardware info at: https://www.starmessagesoftware.com/news/softmeter-v14-free-product-analytics-tool


### Changed

- Internal improvements

## [1.3] - 2020-01-22

### Changed

- Internal improvements


## [1.2.4] - 2019-08-21

### Changed

- Under MacOS, change in the installation directory parameter of libSoftMeter.dylib

## [1.2.3] - 2019-08-17

### Added

- More unit tests

### Changed

- Internal improvements


## [1.2.2] - 2019-08-08

### Changed

- Small internal improvements
- MacOS only: change of SDK from version 10.8 to 10.14 to pass the (new) notarization process of the Apple Store.

## [1.2.1] - 2019-07-19

### Changed

- Internal improvements for the SoftMeter PRO subscription and the PRO perpetual license.
- IOS analytics demo app shows the SoftMeter log file.

## [1.2.0] - 2019-07-18

### Added

- Perpetual license option, removing all limitations for SoftMeter. 

### Changed

- Internal improvements

## [1.1.0] - 2019-05-10

### API changes
- Yes, in functions: setOptions(), setSubscription(), setProxy(), and in the calling convention of the Windows DLL functions.

### Changed

- Windows edition: the DLL calling conversion changed from __cdecl to __stdcall  
The ready samples (c++, Delphi/Pascal, Inno setup, Installaware) were also changed to reflect this change.  
The __cdecl specifier will be replaced by the __stdcall specifier.  
All functions in the DLL will continue to have their __stdcall counterparts so you can still call the set you prefer. E.g.  
```
    start()     // this uses the __stdcall calling conventions (which is the WIN API default)  
    start_cdecl() // this is the __cdecl function  
    start_stdcall() // this is the __stdcall function (deprecated because the start() has the same convention)  
```

- Better compatibility with Windows 7 and Vista.

### Added

- function setOptions() to pass multiple optional developer parameters to SoftMeter.  
The parameters are passed as a string containing key=value pairs, separated with a new line character "\n".
Examples: 
To pass your SoftMeter PRO subscription details, call  
```
setOptions( "subscriptionID=Your-subsciption-ID\n"
            "subscriptionType=2\n" );
```

### Removed
- setSubscription() is removed as setOptions() can be used to pass your subscription details.
- setProxy() is removed as setOptions() can be used to pass your proxy details.

## [1.0.0] - 2019-03-26

### Changed
- Internal improvements


## [0.9.4] - 2019-03-17

### Added
- Custom endpoints for the collection of the usage analytics data.  
You can set your own server as the data collection endpoint.  
SoftMeter will send the data hits to your server instead of Google Analytics.  
Contact us for more information.


### Changed
- Improved compatibility with Windows 7


## [0.9.3] - 2019-02-24

### Added

- Multiple monitor configurations and retina displays.  
Detects and reports the number of monitors and their resolutions.  
It also detects if there is a retina (high resolution / HiDPI) display on Mac platforms.  
Until now, only the main monitor of a multi-monitor configuration was reported.  
For multi-monitor configurations, you will see under the "Screen resolution" dimension of Google Analytics values like  
```
1280x800, 1920x1080  
1280x800, 840x525 HiDPI  
```

- new function setProxy()  
    void setProxy(const TCHAR *address, const int port,  
                  const TCHAR *username , const TCHAR *password, const int authScheme);  

It will set the proxy server for Softmeter. The address is without protocol (http, https).  
The function will set both an https and http proxy server address.

proxyAuthScheme under Windows must be one of the following:  
0: no authentication, 2: NTLM, 4: Passport, 8: Digest, 16: Negotiate  
Alpha version implementation of proxy settings (Windows only)  
To test the proxy function:  
Store cpcc-demo-win and libSoftMeter.dll in the same folder.  
Run cpcc-demo-win with your PropertyID and the extra parameters   
for the proxy server and the proxy credentials.  
Syntax:  
```
cpp-demo-main <propertyID> <proxyaddress> <proxyport> <proxyUsername> <proxypassword> <proxyAuthScheme> 
```
Example:  
```
cpp-demo-main UA-1111-1    192.168.5.1      8081         smith           iamgreat     4
```


### Changed

- Internal improvements


## [0.9.2] - 2019-01-12 - MacOS and IOS release

### Changed

- Internal improvements for IOS framework

## [0.9.1] - 2019-01-07

### Fixed

- IOS linked framework (network.framework) should not have been linked as required but was optional. Problem noticed outside the simulator, in release mode.
All IOS developers must upgrade.

### Changed

- Internal improvements


## [0.9.0] - 2018-12-23

[Announcement](https://www.starmessagesoftware.com/news/softmeter-v0.9-track-your-IOS-apps-free), [IOS analytics, blog article](https://www.starmessagesoftware.com/blog/ios-app-analytics-how-to-monitor-ios-app-usage-free)

### Added

- IOS edition. Now you can track your IOS apps via SoftMeter and see their app analytics.
- Online license check (PRO vs FREE).  
  If you have a SoftMeter PRO subscription, you can activate as PRO not only your new releases but also your existing installations.  
 
### Changed

- SoftMeter version number advanced from 0.6.4 to 0.9.0 as it is a quite mature product with thousands of installations.
- Minor field mapping changes


## [0.6.4] - 2018-12-01

### Fixed

- Bug in getOSNameVersionAndBuild() for some MacOS locales, e.g Ukrainian.

### Added

- Hit rate limiter to impose the Google analytics limits.

### Changed

- Internal improvements


## [0.6.3] - 2018-10-21

No changes in the API.  
Please upgrade: the DLL and dylib files of the previous version are directly replaceable by this version's files.

### Changed

- Internal improvements

## [0.6.2] - 2018-08-28

### Fixed

- User preferred language was not always correct under Windows.

### Changed

- Internal improvements
- __stdcall example call (Windows DLL only)  
[cpp-demo-main.cpp](https://github.com/starmessage/libSoftMeter/blob/master/cpp-console-demo/cpp-demo-main.cpp) now contains an example of calling the __stdcall version of an API function.  
Reminder: Since v0.6.1 the DLL contains both the __stdcall and the __cdecl versions of all the API functions, so you can call the most appropriate for your development tool.

### Added

-	Call-home PIN switch (Pro edition). 

## [0.6.1] - 2018-07-30

- [Announcement at the website](https://www.starmessagesoftware.com/news/softmeter-v061-released-see-application-statistcs-google-analytics)

### Added
-	__stdcall counterparts of the API functions.  
	Now, under Windows, you can chose to call the __cdecl or the __stdcall version of the functions.
	Both sets reside in the same DLL.
	The stdcall set of functions has _stdcall in the function names.
	The existing functions remain as they were (cdecl)
	See the [dumpbin report](https://github.com/starmessage/libSoftMeter/blob/master/bin/dumpbin-of-softmeter-dll.txt)
	
- All-in-one functions  
	Some tools (e.g. Installaware) allow you to load a DLL and make a single call. They do not keep the DLL loaded.  
	A new all-in-one function, aio_sendEvent() was added to support such cases.  
	It combines the parameters of start() and sendEvent() and performs the whole sequence of start(), sendEvent(), stop.  
	aio_sendEvent follows the __cdecl calling convention and 
	aio_sendEvent_stdcall follows the __stdcall calling convention (for Installaware)
	
### Changed
- Internal improvements

## [0.6.0] - 2018-07-10
### Added
- Detect invalid Google Analytics propertyIDs and mute those hits from G.A.

## [0.5.9] - 2018-07-10
### Changed
- Alignment of the code with the [SoftMeter Pro](https://www.starmessagesoftware.com/softmeter-pro) edition

## [0.5.8] - 2018-06-21
### Added
- Anonymize client's IP
- Disable/bypass the computer's internet cache
- New [example for Delphi GUI](https://github.com/starmessage/libSoftMeter/tree/master/delphi-gui-demo) applications

### Changed
- Internal improvements
- Better modelling of the Application ID and the Application Installation ID

## [0.5.7] - 2018-03-08
### Changed
- The library name was changed to SoftMeter from libAppTelemetry 
- [Function names and dll,dylib filename changed](https://www.starmessagesoftware.com/news/libapptelemetry-v0.5.6-is-softmeter)

## [0.5.6] - 2018-02-03
### Added
- New function: sendException(char *exceptionDescription, bool isFatal)  
  Use it to [remotely log and monitor exceptions](https://www.starmessagesoftware.com/blog/how-to-track-software-exceptions-via-google-analytics).  
  You can see the exceptions of your distributed installations in real-time from Google Analytics

## [0.5.5] 
### Changed
- Internal improvements
- Better compatibility with Windows XP

## [0.5.3] 
### Added
- ScreenView hits of the Google measurement protocol.  
Until now the library had only PageView and Event hits.

## [0.5.2] 
### Changed
- start() now takes two more string parameters,  
license (e.g. free, trial, pro, limited, etc) and  
edition (e.g. AppleStore, Mac, Win, Promo, etc)  

