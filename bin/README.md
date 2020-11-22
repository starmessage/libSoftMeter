# SoftMeter libraries (.dll, .dylib, .framework)

SoftMeter is a Windows, MacOS and IOS library that allows you to monitor the usage of your software program (installs, uninstalls, number of daily/monthly users, countries, OS, etc) via your Google Analytics property.  
- Go to [SoftMeter website](https://www.StarMessageSoftware.com/softmeter) for more information.  

## Description of files

|File|Description|Old versions|
|----------|-------------|-----|
|libSoftMeter.dll|Windows 32 bit DLL. Suitable for 32 and 64 bit of Windows.| |
|libSoftMeter64.dll|Windows 64 bit DLL. Suitable for 64 bit of Windows.| |
|libSoftMeter.dylib|MacOS dylib for 64 bit systems.|[v1.4.1](https://github.com/starmessage/libSoftMeter/raw/9bd232970c7a531dcdf9f916cadbdb2f5084de41/bin/libSoftMeter.dylib)|
|libSoftMeter-IOS.framework|IOS framework.| |
|cpp-demo-mac|The MacOS sample executable.  Place it in the same folder with the dylib. You might need to run the command "chmod a+x cpp-demo-mac" after you download the file.|[v1.4.1](https://github.com/starmessage/libSoftMeter/raw/9bd232970c7a531dcdf9f916cadbdb2f5084de41/bin/cpp-demo-mac)|
|cpp-demo-win.exe|The Windows sample executable. Place it in the same folder with the DLL.| |
 
## SoftMeter DLLs calling conventions for Windows
To ease the life of the Windows applications developer, the SoftMeter DLLs have both __cdecl and __stdcall calling conventions.  

The DLLs contain the SoftMeter API functions twice.  
One set is declared with the __cdecl calling convention and the other set with __stdcall.  


E.g
- start()  
- start_stdcall()  
Functions following the __stdcall calling convention, which is the default calling convention for the Win32 API.
- start_cdecl()  
The same function, following the __cdecl calling convention.  
See the example of the [dumpbin report](https://github.com/starmessage/libSoftMeter/blob/master/bin/dumpbin-of-softmeter-dll.txt) of SoftMeter.

Depending on the language of your Windows application you can call either set of functions.

Read more about the [DLL calling conventions](https://github.com/starmessage/libSoftMeter/blob/master/bin/DLL-functions-calling-conventions.md).

