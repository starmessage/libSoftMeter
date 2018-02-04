//
//  lib-export-api.h
//  appTelemetry
//
//  Copyright © 2018 StarMessage software. All rights reserved.
//	https://www.starmessagesoftware.com/libapptelemetry
//




#ifdef _WIN32
	// __declspec(dllexport) adds the export directive to the object file so you do not need to use a .def file. 
	// When exporting functions with either method, make sure to use the __stdcall calling convention. 
	#define EXPORT_DIRECTIVE	__declspec(dllexport) 
#else
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
#else
	#define C_EXPORT 
#endif

// define the 
#define EXPORT_API		C_EXPORT EXPORT_DIRECTIVE
