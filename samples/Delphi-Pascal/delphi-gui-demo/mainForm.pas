unit mainForm;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);

  private
    { Private declarations }

  public
    { Public declarations }

  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


uses softMeter_globalVar;


procedure TForm1.Button1Click(Sender: TObject);
var success: BOOL;
begin
  // The free edition has a limit also on the number of hits (2) that can be sent per program run.
  // So the call to sendPageview() might be successful the first time but return false on the next times.

  // events are sent only by the PRO edition
  // success := dllSoftMeter.sendEvent('Important events', 'Button 1 clicked', 1);
  // So we send here a pageView that is ok for the Free edition
  success := dllSoftMeter.sendPageview( 'MainForm/Btn1' , 'Button clicked' );
  if (not(success)) then
    ShowMessage('sendPageview() returned false. Examine the error log.');
    
  ShowMessage('Button clicked. A hit should appear in your GA. You can see it immediately under real-time reporting.');
end;


procedure TForm1.FormShow(Sender: TObject);
var success: BOOL;
begin
  // send a pageView hit on Form Show
  success := dllSoftMeter.sendPageview( 'MainForm/' , 'MainForm' );
  if (not(success)) then
    ShowMessage('sendPageview() returned false');

  // or send screenView
  // success := dllSoftMeter.sendScreenView('MainForm');
  // if (not(success)) then
  //  ShowMessage('sendScreenView() returned false');
end;


end.
