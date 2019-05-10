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
begin
  dllSoftMeter.sendEvent('Important events', 'Button 1 clicked', 1);
  ShowMessage('Button clicked. An "event" hit should appear in your GA, under real-time reporting.');
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  // send a pageView hit on Form Show
  dllSoftMeter.sendPageview( 'MainForm/' , 'MainForm' );
  // or send screenView
  dllSoftMeter.sendScreenView('MainForm');

end;


end.
