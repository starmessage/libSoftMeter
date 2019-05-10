/*  ****************************************************
 *  File:			core.cpccLinkLibrary.h
 *	File version: 	1.1
 *  Dependencies: 	None
 *	Purpose:		Portable (cross-platform), light-weight class 
 *					to help with the dynamic library loading (.DLL, .dylib) 
 *					and linking of functions 
 *	****************************************************
 *  Library:		Cross Platform C++ Classes (cpcc)
 *  Copyright: 		2017 StarMessage software.
 *  License: 		Free for opensource projects.
 *  				Commercial license for closed source projects.
 *	Web:			http://www.starmessagesoftware.com/cpcclibrary/
 *					https://github.com/starmessage/cpcc
 *	email:			sales -at- starmessage.info
 *	****************************************************
 */

#pragma once

//	https://en.wikipedia.org/wiki/Dynamic_loading


#include <string>
#include <cstdio>
#include <iostream>


#ifdef _WIN32
	#include <windows.h>
	#pragma comment(lib, "Kernel32.lib")
	
#elif defined(__APPLE__)
    #include <dlfcn.h>
	
#endif

#ifdef _WIN32
	class cpccLinkedLibraryPortable_Win
	{
	public:
		typedef HMODULE 	tLibHandle;

		static 	tLibHandle	loadLibrary(const TCHAR *aFilename)
		{
			/*
			 http://msdn.microsoft.com/en-us/library/ms684175.aspx
			 If the string specifies a full path, the function searches only that path for the module.
			 If the string specifies a relative path or a module name without a path, the function uses 
			 a standard search strategy to find the module.
			 If the string specifies a module name without a path and the 
			 file name extension is omitted, the function appends the default 
			 library extension .dll to the module name. To prevent the function 
			 from appending .dll to the module name, include a trailing point 
			 character (.) in the module name string.
			 When specifying a path, be sure to use backslashes (\), 
			 not forward slashes (/).
		 
			 If the function fails, the return value is NULL. 
			 To get extended error information, call GetLastError.
			 */
			tLibHandle result = LoadLibrary(aFilename);
			if (!result)
			{
				std::cerr << "LoadLibrary(" << aFilename << ") failed. GetLastError=" << GetLastError() << std::endl;
			}
			return result;
		}

		static void unloadLibrary(const tLibHandle	aHandle) 	
		{	
			if (aHandle)
				FreeLibrary(aHandle);	
		}

		static void *getFunctionAddress(const tLibHandle	aHandle, const char * aFunctionName) 
		{ 	
			if (!aHandle) return NULL;
			return  (void *)GetProcAddress(aHandle, aFunctionName); 
		}

	};

	typedef cpccLinkedLibraryPortable_Win cpccLinkedLibradyImpl;
#endif


#ifdef __APPLE__
	class cpccLinkedLibraryPortable_OSX 
	{
	public:
		typedef	void *		tLibHandle;

		static 	tLibHandle	loadLibrary(const char *aFilename)
		{
            // https://linux.die.net/man/3/dlerror
            // The function dlerror() returns a human readable string describing the most recent error
            // that occurred from dlopen(), dlsym() or dlclose() since the last call to dlerror().
			tLibHandle result = dlopen(aFilename, RTLD_LAZY);
            if (!result)
                std::cerr << "#9312a Error during dlopen(" << aFilename <<"): " << dlerror() << std::endl;
            return result;
			
		}

		static void unloadLibrary(const tLibHandle	aHandle)
        {
            // The function dlclose() decrements the reference count on the dynamic library handle handle.
            // If the reference count drops to zero and no other loaded libraries use symbols in it,
            // then the dynamic library is unloaded.
            // The function dlclose() returns 0 on success, and nonzero on error.
            int ret = dlclose(aHandle);
            if (ret!=0)
                std::cerr << "#9312c Error during dlclose(): " << dlerror() << std::endl;
        }

		static void *getFunctionAddress(const tLibHandle	aHandle, const char * aFunctionName)
        {
            // Since the value of the symbol could actually be NULL (so that a NULL return from dlsym()
            // need not indicate an error), the correct way to test for an error is to
            // call dlerror() to clear any old error conditions, then
            // call dlsym(), and then
            // call dlerror() again, saving its return value into a variable, and check whether this saved value is not NULL.
            dlerror();
            void *result = dlsym(aHandle, aFunctionName);
            if (!result)
                std::cerr << "#9312b Error: " << dlerror() << std::endl;
            return result;
            
        }
	};

	typedef cpccLinkedLibraryPortable_OSX cpccLinkedLibradyImpl;
#endif

#ifndef _WIN32
    #ifndef TCHAR // for non Windows systems
        #define  TCHAR char
    #endif
#endif

class cpccLinkedLibrary 
{

private:
	cpccLinkedLibradyImpl::tLibHandle 			m_libHandle;
	
protected:
	// cpccLinkedLibradyImpl::tLibHandle			getLibHandle(void) const { return m_libHandle;  }

public: // ctor, dtor

	explicit cpccLinkedLibrary(const TCHAR *aLibraryfilename)
	{
		m_libHandle = cpccLinkedLibradyImpl::loadLibrary(aLibraryfilename);
		if (!m_libHandle)
			std::cerr << "#7524: failed to load dynamic library: " << aLibraryfilename << std::endl;
        else
            std::cout << "Library loaded: " << aLibraryfilename << std::endl;
    }


	virtual ~cpccLinkedLibrary()
	{
		if (m_libHandle)
			cpccLinkedLibradyImpl::unloadLibrary(m_libHandle);
		m_libHandle = NULL;
	};
	

public:	// members

	void *	getFunction(const char * aFunctionName)
	{
        if (!isLoaded())
		{ 
			std::cerr << "#9771e: Cannot load function: [" << aFunctionName << ("] because the dynamic library was not loaded\n");
			return NULL;
		}

		void *ptr = cpccLinkedLibradyImpl::getFunctionAddress(m_libHandle, aFunctionName);
		if (!ptr)
			std::cerr << "#9771a: did not find a function [" << aFunctionName << "] in the dynamically loaded library\n";
		return  ptr;
	}
	
	bool	isLoaded(void) const { return (m_libHandle != NULL); };

};
