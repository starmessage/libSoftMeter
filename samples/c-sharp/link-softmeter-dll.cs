/////////////////////////////////////////////////////////////////
//
// SoftMeter in-app analytics library for Google Analytics
// Loading the SoftMeter.dll from a C# application
//
// Thanks to danielsavi for the initial version of this code 
// https://github.com/starmessage/libSoftMeter/issues/10#issuecomment-549504416
//
/////////////////////////////////////////////////////////////////

// ToDo: load the DLL in runtime, without complaining if the DLL file is absent


using System;
using System.Runtime.InteropServices;

// a class to encapsulate the SoftMeter DLL functions
public static class SoftMeterDLL
{

    public const string DLL_FILE_NAME = 
        "libSoftMeter64.dll"; // for 64bit  software
        // "libSoftMeter.dll"; // for 32bit software


    [DllImport(DLL_FILE_NAME)]
    internal static extern IntPtr getVersion(); // If a C++ DLL function returns char*, C# code will treat it as IntPtr and Marshal.PtrToStringAnsi() will convert it into C# string.

    [DllImport(DLL_FILE_NAME)]
    internal static extern IntPtr getLogFilename();

    [DllImport(DLL_FILE_NAME)]
    internal static extern void enableLogfile([MarshalAs(UnmanagedType.LPStr)]string appName, [MarshalAs(UnmanagedType.LPStr)]string macBundleId);

    [DllImport(DLL_FILE_NAME)]
    internal static extern void disableLogfile();

    [DllImport(DLL_FILE_NAME)]
    internal static extern bool start([MarshalAs(UnmanagedType.LPStr)]string appName, [MarshalAs(UnmanagedType.LPStr)]string appVersion,
                                        [MarshalAs(UnmanagedType.LPStr)]string appLicense, [MarshalAs(UnmanagedType.LPStr)]string appEdition,
                                        [MarshalAs(UnmanagedType.LPStr)]string propertyID, bool userGaveConsent);

    [DllImport(DLL_FILE_NAME)]
    internal static extern void stop();

    [DllImport(DLL_FILE_NAME)]
    internal static extern bool sendPageview([MarshalAs(UnmanagedType.LPStr)]string pagePath, [MarshalAs(UnmanagedType.LPStr)]string pageTitle);

    [DllImport(DLL_FILE_NAME)]
    internal static extern bool sendScreenview([MarshalAs(UnmanagedType.LPStr)]string screenName);

    [DllImport(DLL_FILE_NAME)]
    internal static extern bool sendEvent([MarshalAs(UnmanagedType.LPStr)]string eventAction, [MarshalAs(UnmanagedType.LPStr)]string eventLabel, int eventValue);

    [DllImport(DLL_FILE_NAME)]
    internal static extern bool sendException([MarshalAs(UnmanagedType.LPStr)]string exceptionDescription, bool isFatal);
 
}