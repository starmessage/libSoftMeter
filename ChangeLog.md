# [libSoftMeter version history/Changelog](https://github.com/starmessage/libSoftMeter/blob/master/ChangeLog.md)
All notable changes to this project will be documented in this file.

[libSoftMeter website](https://www.starmessagesoftware.com/softmeter).

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

