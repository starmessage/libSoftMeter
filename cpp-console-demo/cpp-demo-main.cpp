//////////////////////////////////////////////////////////////////
//
//  main.cpp
//  appTelemetry test in C++
//
//	file version: 0.4.4
//  Copyright © 2017 StarMessage software. All rights reserved.
//  Web: http://www.StarMessageSoftware.com/libapptelemetry
// 

#include <string>
#include <stdio.h>
#include <string.h>
#include <iostream>

#include "AppTelemetry_cppApi.h"



/* building the program without dependency on the runtime DLLs:
	To avoid "MSVCP140.dll is missing" you can statically link the program.
	In visual studio, go to Project tab -> properties - > configuration properties -> C/C++ -> Code Generation 
	on runtime library choose /MTd for debug mode and /MT for release mode.
	This will cause the compiler to embed the runtime into the app. 
	The executable will be significantly bigger, but it will run without any need of runtime DLLs.
*/


// you can rename the dll if you want it to match your application's filename
#ifdef _WIN32
	#ifdef _M_AMD64
		const TCHAR * AppTelemetryDllFilename = "libAppTelemetry64bit.dll";
	#else
		const TCHAR * AppTelemetryDllFilename = "libAppTelemetry.dll";
	#endif
#else
    const char * AppTelemetryDllFilename = "libAppTelemetry.dylib";
#endif


bool checkCommandLineParams(int argc, const char * argv[])
{
	if (argc!=2)
		return false;
		
	return (strncmp(argv[1], "UA-", 3) == 0); // chech if the parameter starts with UA-
}


int main(int argc, const char * argv[])
{
	// The filename of this program will be used as the program name submitted to G.A.
	// You can rename this test file so that you see the correct program name in the G.A. reports.
	std::string executableName(argv[0]);
	// contains something like: c:\folder1\cpp-demo-win
	// The path must be removed.
	size_t positionOfSlash = executableName.rfind('/');
	if (positionOfSlash != std::string::npos)
		executableName.erase(0, positionOfSlash+1);
	positionOfSlash = executableName.rfind('\\');
	if (positionOfSlash != std::string::npos)
		executableName.erase(0, positionOfSlash+1);
	// std::cout << "EXE:" << executableName << std::endl;


	if (!checkCommandLineParams(argc, argv))
	{
		std::cerr << "Error: the program must be called with a parameter specifying the google analytics property\nE.g.\n";
        
        // std::cerr << argv[0] << " UA-123456-12\n";
        #ifdef _WIN32
            std::cerr << "cpp-demo-win UA-123456-12\n";
        #else
            std::cerr << "./cpp-demo-mac UA-123456-12\n";
        #endif
		return 10;
	}

	if (!argv[1])
		return 11;


    std::string gaPropertyID(argv[1]);

	// create an object that contains all the needed telemetry functionality, plus the loading and linking of the .DLL or the .dylib
	AppTelemetry_cppApi telemetryDll(AppTelemetryDllFilename);
	if (!telemetryDll.isLoaded())
	{
		std::cerr << "Exiting because the DLL was not loaded\n";
		return 100;
	}

	if (telemetryDll.errorsExist())
	{
		std::cerr << "Errors exist during the dynamic loading of telemetryDll\n";
		return 101;
	}
	std::cout << "libAppTelemetry version:" << telemetryDll.appTelemetryGetVersion() << std::endl;

	// fictional appName and appVersion for your testing
	const char *appName = executableName.c_str();
	const char *appVer = "0.6";

	// initialize the library with your program's name, version and google propertyID
    if (!telemetryDll.appTelemetryInit(appName, appVer, gaPropertyID.c_str()))
	{
		std::cerr << "Error calling appTelemetryInit_ptr\n";
		return 201;
	}
	std::cout << "appTelemetryInit() called with Google property:" << gaPropertyID << std::endl;
	
    // the log filename is available after the call to appTelemetryInit() because it depends on the applicationName
    telemetryDll.appTelemetryEnableLogfile(appName, "com.company.appname");
	std::cout << "libAppTelemetry log filename:" << telemetryDll.appTelemetryGetLogFilename() << std::endl;

    
	std::cout << "Will call appTelemetryAddPageview()" << std::endl;
	if (!telemetryDll.appTelemetryAddPageview("main window", "main window"))
	{
		std::cerr << "Error calling appTelemetryAddPageview_ptr\n";
		return 202;
	}

	std::cout << "Will call appTelemetryAddEvent()" << std::endl;
	if (!telemetryDll.appTelemetryAddEvent("AppLaunch", appName, 1))
	{
		std::cerr << "Error calling appTelemetryAddEvent_ptr\n";
		return 203;
	}

	telemetryDll.appTelemetryFree();
    std::cout << "Program exiting now." << std::endl;
    return 0;
}
