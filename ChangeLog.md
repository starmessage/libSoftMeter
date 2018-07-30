# [libSoftMeter version history/Changelog](https://github.com/starmessage/libSoftMeter/blob/master/ChangeLog.md)
All notable changes to this project will be documented in this file.

[libSoftMeter website](https://www.starmessagesoftware.com/softmeter).

## [0.6.1] - unreleased
### Added
-	__stdcall version of the API functions.  
	Now, under Windows, you can chose to call the __cdecl or the __stdcall version of the functions.
	Both sets reside in the same DLL.
	See the [dumpbin report](https://github.com/starmessage/libSoftMeter/blob/stdcall-test-02/bin/dumpbin-of-softmeter-dll.txt)
	
- All-in-one functions  
	Some tools (e.g. Installaware) allow you to load a DLL and make a single call. They do not keep the DLL loaded.  
	A new all-in-one function, aio_sendEvent() was added to support such cases.  
	It combines the parameters of start() and sendEvent() and performs the whole sequence of start(), sendEvent(), stop.  
	aio_sendEvent follows the __cdecl calling convention and 
	aio_sendEvent_stdcall follows the __stdcall calling convention (for Installaware)
	
	
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

