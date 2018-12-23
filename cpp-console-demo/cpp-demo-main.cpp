//////////////////////////////////////////////////////////////////
//
//  main.cpp
//  SoftMeter test in C++
//
//	file version: 58
//  Copyright © 2018 StarMessage software. All rights reserved.
//  Web: http://www.StarMessageSoftware.com/softmeter
//

#include <string>
#include <stdio.h>
#include <string.h>
#include <iostream>
#ifdef _WIN32
    #include <tchar.h>
#endif
#include "SoftMeter-CPP-Api.h"
#include "../SoftMeter-C-Api-AIO.h" // for testing the all-in-one functions

#ifndef _WIN32
    #ifndef _T  // for non Windows systems
        #define _T(s) s
    #endif
#endif

const smChar_t 	*appVer = _T("63"),
                *appLicense = _T("demo"), // e.g. free, trial, full, paid, etc.
			    *appEdition = _T("console");

// If the user has opted-out from sending telemetry data, this variable must be false.
// Save the user's consent in the app's settings and then read this variable every time your program starts.
const bool userGaveConsent = true;


/* building the program without dependency on the runtime DLLs:
	To avoid "MSVCP140.dll is missing" you can statically link the program.
	In visual studio, go to Project tab -> properties - > configuration properties -> C/C++ -> Code Generation
	on runtime library choose /MTd for debug mode and /MT for release mode.
	This will cause the compiler to embed the runtime into the app.
	The executable will be significantly bigger, but it will run without any need of runtime DLLs.
	
   For Windows XP compatibility use the toolset version v140_xp (visual studio 2015)
   This is the toolset that the libAppTelemetry.dll is compiled with.
   When using the newer toolset v141_xp (visual studio 2017) the LoadLibrary() win32 api function 
   failed to load the DLL under WinXP SP3.
   
*/


// you can rename the dll if you want it to match your application's filename
#ifdef _WIN32
	#ifdef _M_AMD64
		const TCHAR * AppTelemetryDllFilename = _T("libSoftMeter64bit.dll");
	#else
		const TCHAR * AppTelemetryDllFilename = _T("libSoftMeter.dll");
	#endif
#else
    const char * AppTelemetryDllFilename = "libSoftMeter.dylib";
#endif


bool checkCommandLineParams(int argc, const char * argv[])
{
	if (argc!=2)
		return false;

	return (strncmp(argv[1], "UA-", 3) == 0); // chech if the parameter starts with UA-
}


bool testTheAllInOneFunctions(const smChar_t *appName, const smChar_t *aPropertyID)
{
	// load the dll
	cpccLinkedLibrary theDLL(AppTelemetryDllFilename);

	// get the address of the function
    aio_sendEvent_t functionPtr = (aio_sendEvent_t) theDLL.getFunction("aio_sendEvent");
    if (!functionPtr)
    {
        std::cerr << "function aio_sendEvent not found.\n";
        return false;
    }
    
	// call the one-in-all function
    return functionPtr(appName, appVer, appLicense, appEdition, aPropertyID, userGaveConsent, _T("Testing AIO function"), _T("aio_sendEvent() test"), 0);
	

}


#ifdef _WIN32
bool testTheSend_aio_Event_strcall(const smChar_t *appName, const smChar_t *aPropertyID)
{
	// testing aio_sendEvent_stdcall()
	HMODULE hDLL = LoadLibrary(AppTelemetryDllFilename);
	if (!hDLL)
	{
		std::cerr << "DLL not loaded:" << AppTelemetryDllFilename << std::endl;
		return false;
	}

	// https://docs.microsoft.com/en-us/cpp/cpp/stdcall
	typedef bool  (__stdcall *aio_sendEvent_stdcall_t)  (const smChar_t *, const smChar_t *, const smChar_t *, const smChar_t *, const smChar_t *, const bool, const smChar_t *, const smChar_t *, const int);

	const aio_sendEvent_stdcall_t functionPtr = (aio_sendEvent_stdcall_t) GetProcAddress(hDLL, "aio_sendEvent_stdcall");
	
	bool result;
	if (!functionPtr)
	{
		std::cerr << "Function aio_sendEvent_stdcall() not found in the DLL" << std::endl;
		result=false;
	}
	else
		result = functionPtr(appName, appVer, appLicense, appEdition, aPropertyID, userGaveConsent, _T("Testing stdcall AIO function"), _T("aio_sendEvent_stdcall() test"), 0);

	// unload the dll
	FreeLibrary(hDLL);
	return result;
}
#endif


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

        // std::cerr << argv[0] << " UA-1234-1\n";
        #ifdef _WIN32
            std::cerr << "cpp-demo-win UA-1234-1\n";
        #else
            std::cerr << "./cpp-demo-mac UA-1234-1\n";
        #endif
		return 10;
	}

	if (!argv[1])
		return 11;

    const std::string gaPropertyID(argv[1]);

    
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
	std::cout << "libAppTelemetry version:" << telemetryDll.getVersion() << std::endl;

	// fictional appName and appVersion for your testing
	const smChar_t *appName = executableName.c_str();

	telemetryDll.enableLogfile(appName, "com.company.appname");
	std::string logFilename(telemetryDll.getLogFilename());
	std::cout << "libAppTelemetry log filename:" << logFilename << std::endl;

	// initialize the library with your program's name, version and google propertyID
    if (!telemetryDll.start(appName, appVer, appLicense, appEdition, gaPropertyID.c_str(), userGaveConsent))
	{
		std::cerr << "Error calling start_ptr\n";
		goto stop_report_and_exit;
	}
	std::cout << "start() called with Google property:" << gaPropertyID << std::endl;
	
	std::cout << "Will send a Pageview hit" << std::endl;
	if (!telemetryDll.sendPageview("main window", "main window"))
	{
		std::cerr << "sendPageview returned False\n";
		goto stop_report_and_exit;
	}

	std::cout << "Will send a Event hit" << std::endl;
	// if (!telemetryDll.sendEvent("AppLaunch", appName, 1))
    if (!telemetryDll.sendEvent("AppLaunch", appName, 1))
	{
		std::cerr << "sendEvent returned False\n";
		goto stop_report_and_exit;
	}

	std::cout << "Will send a ScreenView hit" << std::endl;
	if (!telemetryDll.sendScreenview("Test screenView"))
	{
		std::cerr << "sendScreenview returned False\n";
		goto stop_report_and_exit;
	}

	// And now, some exception handling....
	// ---------------------------------------
	try
	{
		throw std::runtime_error("TEST THROW c++ exception"); // Emulate a C++ exception
		// std::cout << "try {} block completed without exceptions thrown" << std::endl;
	}
	// Notes about the C++ try..catch statements
	// Some things are called exceptions, but they are system (or processor) errors and not C++ exceptions.
	// The following catch block only catches C++ exceptions from throw, not any other kind of exceptions (e.g. null-pointer access)
	// In any case, if you manage to catch the exception or the system error, you can then use sendException() to send it to Google Analytics
	catch (const std::exception& ex)
	{
		std::cout << "Exception caught; will send it to G.A." << std::endl;
		std::string excDesc("Error #18471a in " __FILE__ ": ");
		excDesc += ex.what();
		if (!telemetryDll.sendException(excDesc.c_str(), 0))
		{
			std::cerr << "sendException returned False\n";
			goto stop_report_and_exit;
		}
	}
	catch (...)
	{
		std::cout << "Exception caught; will send it to G.A." << std::endl;
		if (!telemetryDll.sendException("Error #18471b in " __FILE__, 0))
		{
			std::cerr << "Error calling sendException\n";
			goto stop_report_and_exit;
		}
	}

stop_report_and_exit:

	telemetryDll.stop();

	std::cout << "Will send an event hit using the All-in-one function aio_sendEvent()" << std::endl;
    // test the All-in-one function(s)
    if (!testTheAllInOneFunctions(appName, gaPropertyID.c_str()))
        std::cerr << "Error calling testTheAllInOneFunctions()\n";
                             
	#ifdef _WIN32
		// test the __stdcall function calling convention
		std::cout << "Will send an event hit using the All-in-one function aio_sendEvent_stdcall() and the __stdcall convention" << std::endl;
		if (!testTheSend_aio_Event_strcall(appName, gaPropertyID.c_str()))
			std::cerr << "Error calling testTheSend_aio_Event_strcall()\n";
	#endif


	// will open the log file in a text editor
	if (system(NULL)) // If command is a null pointer, the function only checks whether a command processor is available through this function, without invoking any command.
	{
#ifdef _WIN32
		std::string command("start " + logFilename);
#else
		std::string command("open -e " + logFilename);
#endif
		std::cout << "Will send command to open the log file." << std::endl;
		system(command.c_str());
	}

	std::cout << "Thank you for using SoftMeter.\r\nPlease send us your feedback: sales@starmessage.info" << std::endl;

    std::cout << "Program exiting now." << std::endl;
    return 0;
}
