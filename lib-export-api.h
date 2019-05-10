//
//  lib-export-api.h
//  SoftMeter library
//
//  Copyright © 2018 StarMessage software. All rights reserved.
//	https://www.starmessagesoftware.com/softmeter
//


/*
#define USE_STDCALL_CONVENTION
#if defined( USE_STDCALL_CONVENTION)  && defined( _WIN32 )
	#define DLL_CALLING_CONVENTION  __stdcall
#else
	// this remanins as a blank define, needed for the MAC
	#define DLL_CALLING_CONVENTION  
#endif
*/


#ifdef _WIN32
	// __declspec(dllexport) adds the export directive to the object file so you do not need to use a .def file. 
	// When exporting functions with either method, make sure to use the __stdcall calling convention. 
	// To export functions, the __declspec(dllexport) keyword must appear to the left of the calling-convention keyword, 
	// if a keyword is specified. For example:
	//   __declspec(dllexport) void __cdecl Function1(void);  
	//   or
	//   __declspec(dllexport) void __stdcall Function1(void);  
    // __declspec(dllexport) cannot be applied to a function with the __clrcall calling convention.

	#define EXPORT_DIRECTIVE	__declspec(dllexport)

    #define CALL_CONV   __stdcall

#else
    #define CALL_CONV

	#define EXPORT_DIRECTIVE	__attribute__((visibility("default")))
	// 	another way to control the export visibility of functions in Xcode 
	//  is to wrap the functions inside a block of
	//  #pragma GCC visibility push(default)
	//  .....
	//  #pragma GCC visibility pop
#endif


#ifdef __cplusplus
	// extern "C" means that the function behind the descriptor 
	// should be compiled with the C standard naming mangling.
	#define C_EXPORT extern "C" 
    // #define C_EXPORT
#else
	#define C_EXPORT 
#endif

// define the EXPORT_API that will be added as prefix in the library's function declarations
#define EXPORT_API		C_EXPORT EXPORT_DIRECTIVE
