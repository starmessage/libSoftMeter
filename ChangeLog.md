# [libSoftMeter version history/Changelog](https://github.com/starmessage/libSoftMeter/blob/master/ChangeLog.md)
All notable changes to this project will be documented in this file.

SoftMeter is a free or low cost application analytics library for Windows, MacOS and IOS.   
[[libSoftMeter website](https://www.starmessagesoftware.com/softmeter)] [[libSoftMeter on GitHub](https://github.com/starmessage/libSoftMeter)].

## [2.1.0]    

### Added
- new function sendEventEx(const TCHAR *eventName, const TCHAR *eventAction, const TCHAR *eventLabel, const int eventValue )  
Provides addtional parameter, eventName. 
The other function, sendEvent() uses "page_view" as the eventName.


## [2.0.5]  - MacOS only release

### Fixed: 
- MacOS version does not properly send the sendGA4Event() hit


## [2.0.3] 
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


## [2.0.2] 
- Internal improvements.
- remove debug flag
- Drop API function setCustomDimension
- cpp-demo programs v110 support only GA4 properties (dropped support for Universal analytics UA-)
Usage: cpp-demo-win G-xxxxxxx YourApiSecret


## [2.0.1] 
- Internal improvements.
- Screen resolution, user language, CPU model and cores, Total and free memory are sent to Google Analytics 4 as user properties.

## [2.0.0] 
- Support for the new GA4 type (G-xxxxxxxx) of Google analytics properties.

## [1.4.4] - Windows only version

### Fixed
- Windows XP compatibility 

### Changed
- start() must be called only once. And terminated with stop().
- Internal improvements


## [1.4.2] 

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

## [1.4.1] 

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

## [1.4] 

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

## [1.3] 

### Changed

- Internal improvements


## [1.2.4] 

### Changed

- Under MacOS, change in the installation directory parameter of libSoftMeter.dylib

## [1.2.3] 

### Added

- More unit tests

### Changed

- Internal improvements


## [1.2.2] 

### Changed

- Small internal improvements
- MacOS only: change of SDK from version 10.8 to 10.14 to pass the (new) notarization process of the Apple Store.

## [1.2.1] 

### Changed

- Internal improvements for the SoftMeter PRO subscription and the PRO perpetual license.
- IOS analytics demo app shows the SoftMeter log file.

## [1.2.0] 

### Added

- Perpetual license option, removing all limitations for SoftMeter. 

### Changed

- Internal improvements

## [1.1.0] 

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

## [1.0.0] 

### Changed
- Internal improvements

