//
// file version: 1.1
// (c) StarMessageSoftware
//  https://www.starmessagesoftware.com/softmeter
//

using System.Runtime.InteropServices;
using System.Windows;


namespace Demo_WpfApp_win
{
    

    public partial class MainWindow : Window
    {

        public MainWindow()
        {
            InitializeComponent();
            // SoftMeter initialization
            bool UserGaveConsent = true; // load this from your user settings file
            lblLibVer.Content = Marshal.PtrToStringAnsi(SoftMeterDLL.getVersion()); // show the dll version 
            string appName = "SoftMeter C-sharp DemoApp";
            string appVersion = "1.0";
            string appLicense = "pro";
            string appEdition = "Microsoft store"; // example: the edition uploaded to the Microsoft store
            string trackingID = "UA-1234-1"; // replace this with your own Google PropertyID
            SoftMeterDLL.enableLogfile(appName, "");

            // if you has purchased a PRO subscription, add here the subscription details (instead of 1111111 and 123)
            // This must be done before you call the start() function.
            SoftMeterDLL.setOptions("subscriptionID=1111111");
            SoftMeterDLL.setOptions("subscriptionType=123");

            // call the start() function to initialize the softMeter library
            SoftMeterDLL.start(appName, appVersion, appLicense, appEdition, trackingID, UserGaveConsent);

            // depending on the FREE/PRO edition, some hits might not be sent due to the limits of the FREE edition. 
            // See more at: https://www.starmessagesoftware.com/softmeter/pro
            SoftMeterDLL.sendPageview("main","MainWindow");
            SoftMeterDLL.sendScreenview("MainWindow");
        }


        ~MainWindow()
        {
            SoftMeterDLL.stop();
        }


    }
}
