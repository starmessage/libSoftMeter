program delphiGUIdemo;

uses
  Vcl.Forms,
  mainForm in 'mainForm.pas' {Form1},
  softMeter_globalVar in 'softMeter_globalVar.pas',
  dll_loader in '..\pascal-console-demo\dll_loader.pas',
  dll_loaderAppTelemetry in '..\pascal-console-demo\dll_loaderAppTelemetry.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
