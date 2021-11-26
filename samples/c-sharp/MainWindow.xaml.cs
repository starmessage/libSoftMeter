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
            string appEdition = "ms store"; // the edition uploaded to the Microsoft store
            string trackingID = "UA-1234-1"; // replace this with your own Google PropertyID
            SoftMeterDLL.enableLogfile(appName, "");
            SoftMeterDLL.start(appName, appVersion, appLicense, appEdition, trackingID, UserGaveConsent);

            SoftMeterDLL.sendPageview("main","MainWindow");
            SoftMeterDLL.sendScreenview("MainWindow");
        }

        ~MainWindow()
        {
            SoftMeterDLL.stop();
        }


    }
}
