unit mainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

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
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  // send a pageView hit on Form Show
  dllSoftMeter.sendPageview( 'MainForm/' , 'MainForm' );
  // or send screenView
  dllSoftMeter.sendScreenView('MainForm');

end;


end.
