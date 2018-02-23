unit DBAppConfig;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, DBAppConfigArq, Vcl.ExtCtrls;

type
  TFormConfig = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label1: TLabel;
    EditDiretorio: TEdit;
    PanelStatus: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure PanelStatusClick(Sender: TObject);
    procedure EditDiretorioKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    ConfigArq : TDBAppConfigArq;
    procedure AlertarUsuario(Alerta: string);
    procedure InstruirUsuario(Instrucao: string);
  public
    procedure Salvar;
  end;

var
  FormConfig: TFormConfig;

implementation

{$R *.dfm}

uses DBAppProblemas;

procedure TFormConfig.AlertarUsuario(Alerta: string);
begin
   PanelStatus.Font.Color := clRed;
   PanelStatus.Caption := Alerta;
   PanelStatus.Visible := true;
end;

procedure TFormConfig.InstruirUsuario(Instrucao: string);
begin
   PanelStatus.Font.Color := clBlack;
   PanelStatus.Caption := Instrucao;
   PanelStatus.Visible := true;
end;

procedure TFormConfig.Salvar;
var
   Problema : string;
begin
   ConfigArq.DiretorioDeProjetos := Trim(EditDiretorio.Text);

   InstruirUsuario('');
   if (not ConfigArq.Salvar) then
   begin
      AlertarUsuario('Não foi possível salvar o arquivo de configuração.');
   end;
end;

procedure TFormConfig.EditDiretorioKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   Salvar;
end;

procedure TFormConfig.FormCreate(Sender: TObject);
begin
   ConfigArq := TDBAppConfigArq.Create;
   EditDiretorio.Text := ConfigArq.DiretorioDeProjetos;

   InstruirUsuario('');
   if (EditDiretorio.Text = '') then InstruirUsuario('Informe o diretório de projetos.');
end;

procedure TFormConfig.PanelStatusClick(Sender: TObject);
begin
   if (ConfigArq.ListaProblemas.Count>0) then
   begin
      Application.CreateForm(TFormProblemas, FormProblemas);
      FormProblemas.DefProblemas(ConfigArq.ListaProblemas);
      FormProblemas.ShowModal;
      FormProblemas.Free;
   end;
end;


end.
