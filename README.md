**SoftMeter application analytics SDK: Compiled library files and demo programs**

> ![SoftMeter application analytics logo](https://www.starmessagesoftware.com/myfiles/softmeter-icon-128x155.png)  
> Listen to the heartbeat of your software

SoftMeter (former libAppTelemetry) is a Windows, MacOS and IOS library that allows you to send usage statistics from your program to your Google Analytics property.  
It is ideal for shareware developers as it extends the website usage data with the applications usage data.  
Shareware developers for desktop programs can now see via *one* free reporting platform (Google Analytics), 1) how people use their website, *and* 2) how they are converted to also use the software on their desktop computer or laptops.

The library can also be used in InnoSetup scripts and other installation packages, (e.g. Installaware) to track Setups and Uninstalls.

- [SoftMeter website](https://www.StarMessageSoftware.com/softmeter)
- [ChangeLog](https://github.com/starmessage/libSoftMeter/blob/master/ChangeLog.md)

**How it works with Google Analytics**
![Application analytics / usage analytics](https://www.starmessagesoftware.com/myfiles/how-it-works-softmeter-usage-analytics.png)

**Example of application analytics reporting dashboard**
![Example of reporting dashboard for application analytics](https://www.starmessagesoftware.com/myfiles/softmeter-application-analytics-dashboard.png)

This repository contains 
- Delphi/Pascal and C++ command line examples for Windows and MacOS X that show how to load the appTelemetry library and send page views from your shareware software to Google Analytics.
- the distributable library (DLL for Windows or .dylib for MacOS X) 
- Inno Setup add-on (Inno Setup extension) scripts. 
  The script allows you to track the number (and location and much more) of your software's installations, by using Inno setup and Google analytics.

**Library information:**

- [GitHub repo](https://github.com/starmessage/libSoftMeter)
- [API](https://www.starmessagesoftware.com/softmeter/sdk-api)
- [Implementation checklist](https://www.StarMessageSoftware.com/softmeter/implementation)
- [Examples reporting via Google Analytics](https://www.starmessagesoftware.com/blog/google-analytics-reports-software-applications)
- [Installation analytics](https://www.starmessagesoftware.com/blog/installation-analytics-shareware-desktop-software-applications)
- [Implementing installation statistics in Inno Setup](https://www.starmessagesoftware.com/blog/free-installation-statistics-innosetup-google-analytics)
- [NuGet package](https://www.nuget.org/packages/libSoftMeter/)
 
**Project Objectives:**

Track the usage and instalations of your shareware program (and soon your mobile IOS app) via your existing Google Analytics account. 

**Operating system compatibility:**

- Windows XP and later, 32/64 bit
- MacOS 10.8 and later, 64 bit
- IOS 8 and later

**Keywords:**
Application analytics
IOS app analytics
Windows desktop software usage analytics
MacOS desktop software usage analytics
Runtime usage statistics


