unit DBAppFormAlterarTipoColuna;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, DBAppTiposDeDados;

type
  TFormAlterarTipoColuna = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    EditNome: TEdit;
    EditTamanhoAtual: TEdit;
    PanelOpcoes: TPanel;
    BtnSalvar: TButton;
    Label4: TLabel;
    Label5: TLabel;
    ComboBoxNovoTipo: TComboBox;
    EditNovoTamanho: TEdit;
    EditTipoAtual: TEdit;
    procedure ComboBoxNovoTipoChange(Sender: TObject);
    procedure EditNovoTamanhoKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure BtnSalvarClick(Sender: TObject);
  private
    TiposDeDados : TArray<TDBAppTipoDadoRec>;
  public
    procedure Preparar(Nome, TipoAtual, TamanhoAtual: String);
  end;

var
  FormAlterarTipoColuna: TFormAlterarTipoColuna;

implementation

{$R *.dfm}

procedure TFormAlterarTipoColuna.BtnSalvarClick(Sender: TObject);
begin
   Close;
end;

procedure TFormAlterarTipoColuna.ComboBoxNovoTipoChange(Sender: TObject);
begin
   EditNovoTamanho.Text := '';
   EditNovoTamanho.Enabled := false;
   if (ComboBoxNovoTipo.ItemIndex >= 0) then
   begin
      EditNovoTamanho.Enabled := TiposDeDados[ComboBoxNovoTipo.ItemIndex].PermiteDefinirTamanho;
      if (EditNovoTamanho.Enabled) and (EditTamanhoAtual.Text<>'') then
         EditNovoTamanho.Text := EditTamanhoAtual.Text;
   end;
   PanelOpcoes.Visible := (ComboBoxNovoTipo.ItemIndex >= 0) and
                          ((ComboBoxNovoTipo.Text <> EditTipoAtual.Text) or (EditTamanhoAtual.Text <> EditNovoTamanho.Text));
end;

procedure TFormAlterarTipoColuna.EditNovoTamanhoKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   PanelOpcoes.Visible := (ComboBoxNovoTipo.ItemIndex >= 0) and
                          ((ComboBoxNovoTipo.Text <> EditTipoAtual.Text) or (EditTamanhoAtual.Text <> EditNovoTamanho.Text));
end;

procedure TFormAlterarTipoColuna.Preparar(Nome, TipoAtual, TamanhoAtual: String);
var
   i : Integer;
begin
   EditNome.Text := Nome;
   EditTipoAtual.Text := TipoAtual;
   if (TamanhoAtual<>'') then EditTamanhoAtual.Text := TamanhoAtual;

   ComboBoxNovoTipo.Clear;
   ComboBoxNovoTipo.ItemIndex := -1;
   TiposDeDados := TDBAppTiposDeDados.RetLista;
   for i := 0 to Length(TiposDeDados)-1 do
   begin
      ComboBoxNovoTipo.Items.Add(TiposDeDados[i].Tipo);
      if (TiposDeDados[i].Tipo = TipoAtual)
      then ComboBoxNovoTipo.ItemIndex := i;
   end;

   EditNovoTamanho.Text := EditTamanhoAtual.Text;
   EditNovoTamanho.Enabled := EditNovoTamanho.Text <> '';
end;

end.
