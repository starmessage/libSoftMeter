/////////////////////////////////////////////////////////////////
//
// SoftMeter in-app analytics library for Google Analytics
// Loading the SoftMeter.dll from a C# application
//
// Thanks to danielsavi for this code https://github.com/starmessage/libSoftMeter/issues/10#issuecomment-549504416
//
/////////////////////////////////////////////////////////////////

using System.Runtime.InteropServices;

namespace libSoftMeter
{
    public class FunctionList
    {
        [DllImport("libSoftMeter.dll", CharSet = CharSet.Ansi)]
        private static extern string GetVersion();

        [DllImport("libSoftMeter.dll", CharSet = CharSet.Ansi)]
        private static extern string GetLogFilename();

        [DllImport("libSoftMeter.dll", CharSet = CharSet.Ansi)]
        private static extern void EnableLogfile([MarshalAs(UnmanagedType.LPStr)]string appName, [MarshalAs(UnmanagedType.LPStr)]string macBundleId);

        [DllImport("libSoftMeter.dll", CharSet = CharSet.Ansi)]
        private static extern void DisableLogfile();

        [DllImport("libSoftMeter.dll", CharSet = CharSet.Ansi)]
        private static extern bool Start([MarshalAs(UnmanagedType.LPStr)]string appName, [MarshalAs(UnmanagedType.LPStr)]string appVersion,
                                         [MarshalAs(UnmanagedType.LPStr)]string appLicense, [MarshalAs(UnmanagedType.LPStr)]string appEdition,
                                         [MarshalAs(UnmanagedType.LPStr)]string propertyID, bool userGaveConsent);

        [DllImport("libSoftMeter.dll", CharSet = CharSet.Ansi)]
        private static extern void Stop();

        [DllImport("libSoftMeter.dll", CharSet = CharSet.Ansi)]
        private static extern bool SendPageview([MarshalAs(UnmanagedType.LPStr)]string pagePath, [MarshalAs(UnmanagedType.LPStr)]string pageTitle);

        [DllImport("libSoftMeter.dll", CharSet = CharSet.Ansi)]
        private static extern bool SendScreenview([MarshalAs(UnmanagedType.LPStr)]string screenName);

        [DllImport("libSoftMeter.dll", CharSet = CharSet.Ansi)]
        private static extern bool SendEvent([MarshalAs(UnmanagedType.LPStr)]string eventAction, [MarshalAs(UnmanagedType.LPStr)]string eventLabel, int eventValue);

        [DllImport("libSoftMeter.dll", CharSet = CharSet.Ansi)]
        private static extern bool SendException([MarshalAs(UnmanagedType.LPStr)]string exceptionDescription, bool isFatal);
    }
}