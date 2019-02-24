# [libSoftMeter version history/Changelog](https://github.com/starmessage/libSoftMeter/blob/master/ChangeLog.md)
All notable changes to this project will be documented in this file.

SoftMeter is a free or low cost application analytics library for Windows, MacOS and IOS. Read more at the [libSoftMeter website](https://www.starmessagesoftware.com/softmeter).

## [0.9.3] - 2019-02-24

### Added

- Multiple monitor configurations and retina displays.  
Detects and reports the number of monitors and their resolutions.  
It also detects if there is a retina (high resolution / HiDPI) display on Mac platforms.  
Until now, only the main monitor of a multi-monitor configuration was reported.  
For multi monitor configurations you will see under the "Screen resolution" dimension of Google Analytics values like  
```
1280x800, 1920x1080  
1280x800, 840x525 HiDPI  
```

- new function setProxy()  
    void setProxy(const smChar_t *address, const int port,  
                  const smChar_t *username , const smChar_t *password, const int authScheme);  

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

