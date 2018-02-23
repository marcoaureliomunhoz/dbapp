program DBApp;

uses
  System.SysUtils,
  Vcl.Forms,
  DBAppPrincipal in 'DBAppPrincipal.pas' {FormPrincipal},
  DBAppConfig in 'DBAppConfig.pas' {FormConfig},
  DBAppConfigArq in 'DBAppConfigArq.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.Run;
end.
