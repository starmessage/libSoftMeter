program delphiGUIdemo;

uses
  Forms,
  mainForm in 'mainForm.pas' {Form1},
  softMeter_globalVar in 'softMeter_globalVar.pas',
  dll_loader in 'dll_loader.pas',
  dll_loaderAppTelemetry in 'dll_loaderAppTelemetry.pas';

{$R *.res}

begin
  Application.Initialize;
  // Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
