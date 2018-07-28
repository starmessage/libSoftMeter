## SoftMeter libraries

SoftMeter is a Windows and MacOS library that allows you to monitor the usage of your software program (installs, uninstalls, number of daily/monthly users, countries, OS, etc) via your Google Analytics property.  
- [SoftMeter website](https://www.StarMessageSoftware.com/softmeter)

### Function calling convention (__cdecl, __stdcall) for the Windows's libraries (DLLs)
The SoftMeter DLLs contain the SoftMeter API functions twice.  
One set is declared with the __cdecl calling convention and the other set with __stdcall.  
The functions of the second set have '_stdcall' in their names.  

E.g
- start()  
Function following the __cdecl calling convention
- start_stdcall()  
The same function, following the __stdcall calling convention

Depending on the language of your Windows application you can call either set of functions.

### How to see the calling convention of a DLL (__stdcall, __cdecl, __fastcall)
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


### How to observe the function names of a DLL
You can use Microsoft's DumpBin.exe  
Run it from inside the VS developer command prompt 
e.g. dumpbin /exports softmeter.dll  
See the example of the [dumpbin report](https://github.com/starmessage/libSoftMeter/blob/stdcall-test-02/bin/dumpbin-of-softmeter-dll.txt) of SoftMeter.

### Known cases of __stdcall and __cdecl calling conventions
- All Win32 API functions (with  very few exceptions) are __stdcall.
- Inno Setup can call both __stdcall and __cdecl functions
- Installaware can call __stdcall functions
- MSVC++ can build both calling conventions

### Links:
https://social.msdn.microsoft.com/Forums/vstudio/en-US/93bb7268-fc38-4444-a795-511dd5ff0738/exporting-stdcall-and-cdecl-calling-conventions?forum=vcgeneral



