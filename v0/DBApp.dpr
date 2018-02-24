program DBApp;

uses
  System.SysUtils,
  Vcl.Forms,
  DBAppPrincipal in 'DBAppPrincipal.pas' {FormPrincipal},
  DBAppConfig in 'DBAppConfig.pas' {FormConfig},
  DBAppConfigArq in 'DBAppConfigArq.pas',
  DBAppBaseArq in 'DBAppBaseArq.pas',
  DBAppProblemas in 'DBAppProblemas.pas' {FormProblemas},
  DBAppProjetosArq in 'DBAppProjetosArq.pas',
  DBAppFormProjeto in 'DBAppFormProjeto.pas' {FormProjeto},
  DBAppProjetoBase in 'DBAppProjetoBase.pas',
  DBAppFormTabela in 'DBAppFormTabela.pas' {FormTabela},
  DBAppFormNovaColuna in 'DBAppFormNovaColuna.pas' {FormNovaColuna},
  DBAppTiposDeDados in 'DBAppTiposDeDados.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.Run;
end.
