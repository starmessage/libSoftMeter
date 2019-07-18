# SoftMeter libraries (.dll, .dylib, .framework)

SoftMeter is a Windows, MacOS and IOS library that allows you to monitor the usage of your software program (installs, uninstalls, number of daily/monthly users, countries, OS, etc) via your Google Analytics property.  
- Go to [SoftMeter website](https://www.StarMessageSoftware.com/softmeter) for more information.  

## Description of files

|File|Description|
|----------|-------------|
|libSoftMeter.dll|Windows 32 bit DLL. Suitable for 32 and 64 bit of Windows.|
|libSoftMeter64.dll|Windows 64 bit DLL. Suitable for 64 bit of Windows.|
|libSoftMeter.dylib|MacOS dylib for 64 bit systems.|
|libSoftMeter-IOS.framework|IOS framework.|
|cpp-demo-mac|The MacOS sample executable.  Place it in the same folder with the dylib. You might need to run the command "chmod a+x cpp-demo-mac" after you download the file.|
|cpp-demo-win.exe|The Windows sample executable. Place it in the same folder with the DLL.| 
 
## SoftMeter DLLs calling conventions for Windows
To ease the life of the Windows applications developer, the SoftMeter DLLs have both __cdecl and __stdcall calling conventions.  

The DLLs contain the SoftMeter API functions twice.  
One set is declared with the __cdecl calling convention and the other set with __stdcall.  


E.g
- start()  
- start_stdcall()  
Functions following the __stdcall calling convention
- start_cdecl()  
The same function, following the __cdecl calling convention.  
See the example of the [dumpbin report](https://github.com/starmessage/libSoftMeter/blob/master/bin/dumpbin-of-softmeter-dll.txt) of SoftMeter.

Depending on the language of your Windows application you can call either set of functions.

---

## General notes about the calling conventions of DLL functions
If you are fighting with the DLL function's calling convention of a third-party or your own DLL, you can see below some notes that can help you solve the puzzle.

### How to see the calling convention of a third-party DLL (__stdcall, __cdecl, __fastcall)
#### If the DLL is compiled by Microsoft VC and there's no DEF file used (__declspec(dllexport) is used for the export),  then you can assume the following rules for the function names in the DLL.

- __cdecl
The symbols begin with a _ but have no @

- __stdcall
The symbols begin with a _ and have a @
MinGW by default doesn't add an undescore to the decorated names  
(e.g. MinGW will use foo@4 instead of _foo@4) 

- __fastcall
The symbols begin with @ and have another @

#### If the DLL is compiled by Microsoft VC and there is a DEF file
- __stdcall  
The symbols contain only the function name (no underscore prefix, no @, no number after the @)

#### If the DLL was produced by a C/C++ compiler:
- If the function name has a @ followed by number it probably uses the stdcall calling convention.  
 Otherwise, it probably uses the cdecl calling convention.  


#### If the DLL is produced by another langauge
- there could be other calling conventions as well.


### How to observe the function names of a third-party DLL
You can use Microsoft's DumpBin.exe  
Run it from inside the VS developer command prompt 
e.g. dumpbin /exports softmeter.dll  

### Known cases of __stdcall and __cdecl calling conventions
- All Win32 API functions (with  very few exceptions) are __stdcall.
- Delphi can call both __stdcall and __cdecl functions.
- Inno Setup can call both __stdcall and __cdecl functions.
- Installaware can call __stdcall functions.
- MSVC++ can build both calling conventions.

### Links:
https://social.msdn.microsoft.com/Forums/vstudio/en-US/93bb7268-fc38-4444-a795-511dd5ff0738/exporting-stdcall-and-cdecl-calling-conventions?forum=vcgeneral

---

