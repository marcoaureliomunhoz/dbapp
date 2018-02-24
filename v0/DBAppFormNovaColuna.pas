unit DBAppFormNovaColuna;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, DBAppTiposDeDados, DBAppColuna;

type
  TFormNovaColuna = class(TForm)
    Label1: TLabel;
    EditNome: TEdit;
    Label2: TLabel;
    ComboBoxTipo: TComboBox;
    EditTamanho: TEdit;
    Label3: TLabel;
    CheckBoxObrigatorio: TCheckBox;
    CheckBoxPK: TCheckBox;
    CheckBoxID: TCheckBox;
    PanelOpcoesNovaTabela: TPanel;
    BtnSalvarNovaColuna: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ComboBoxTipoChange(Sender: TObject);
    procedure BtnSalvarNovaColunaClick(Sender: TObject);
    procedure EditNomeKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure CheckBoxPKClick(Sender: TObject);
    procedure CheckBoxIDClick(Sender: TObject);
  private
    TiposDeDados : TArray<TDBAppTipoDadoRec>;
  public
    NovaColuna : TDBAppColuna;
    procedure Alterar(Nome, Tipo, Tamanho: String; Obrigatorio, PK, Identidade: Boolean);
  end;

var
  FormNovaColuna: TFormNovaColuna;

implementation

{$R *.dfm}

uses DBAppProblemas;

procedure TFormNovaColuna.BtnSalvarNovaColunaClick(Sender: TObject);
begin
   //fabrica a nova coluna
   NovaColuna := TDBAppColuna.Create(
                     0,
                     EditNome.Text,
                     ComboBoxTipo.Text,
                     EditTamanho.Text,
                     CheckBoxObrigatorio.Checked,
                     CheckBoxPK.Checked,
                     CheckBoxID.Checked
                  );

   //se a fabrica retornar problema avisa o usuário
   if (NovaColuna.ListaProblemas.Count > 0) then
   begin
      if (NovaColuna.ListaProblemas.Count > 1) then
      begin
         Application.CreateForm(TFormProblemas, FormProblemas);
         FormProblemas.DefProblemas(NovaColuna.ListaProblemas);
         FormProblemas.ShowModal;
         FormProblemas.Free;
      end else
      begin
         Application.MessageBox(PWideChar(NovaColuna.ListaProblemas[0]),'Atenção',MB_OK);
      end;
   end else
   //se a fabrica não retornar problema fecha a tela
   begin
      Close;
   end;
end;

procedure TFormNovaColuna.CheckBoxIDClick(Sender: TObject);
begin
   CheckBoxObrigatorio.Enabled := true;
   if (CheckBoxPK.Checked or CheckBoxID.Checked) then
   begin
      CheckBoxObrigatorio.Enabled := false;
      if (CheckBoxPK.Checked) then CheckBoxObrigatorio.Checked := true;
   end;
end;

procedure TFormNovaColuna.CheckBoxPKClick(Sender: TObject);
begin
   CheckBoxObrigatorio.Enabled := true;
   if (CheckBoxPK.Checked or CheckBoxID.Checked) then
   begin
      CheckBoxObrigatorio.Enabled := false;
      if (CheckBoxPK.Checked) then CheckBoxObrigatorio.Checked := true;
   end;
end;

procedure TFormNovaColuna.ComboBoxTipoChange(Sender: TObject);
begin
   CheckBoxID.Checked := false;
   CheckBoxID.Enabled := false;
   CheckBoxPK.Checked := false;
   EditTamanho.Text := '';
   EditTamanho.Enabled := false;
   if (ComboBoxTipo.ItemIndex >= 0) then
   begin
      CheckBoxID.Enabled := TiposDeDados[ComboBoxTipo.ItemIndex].PermiteIdentidade;
      EditTamanho.Enabled := TiposDeDados[ComboBoxTipo.ItemIndex].PermiteDefinirTamanho;
   end;
   PanelOpcoesNovaTabela.Visible := (EditNome.Text <> '') and (ComboBoxTipo.ItemIndex >= 0);
end;

procedure TFormNovaColuna.EditNomeKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   PanelOpcoesNovaTabela.Visible := (EditNome.Text <> '') and (ComboBoxTipo.ItemIndex >= 0);
end;

procedure TFormNovaColuna.FormCreate(Sender: TObject);
var
   i : Integer;
begin
   ComboBoxTipo.Clear;
   TiposDeDados := TDBAppTiposDeDados.RetLista;
   for i := 0 to Length(TiposDeDados)-1 do
   begin
      ComboBoxTipo.Items.Add(TiposDeDados[i].Tipo);
   end;
   ComboBoxTipo.ItemIndex := -1;
end;

procedure TFormNovaColuna.Alterar(Nome, Tipo, Tamanho: String; Obrigatorio, PK, Identidade: Boolean);
begin
   EditNome.Text := Nome;
   ComboBoxTipo.ItemIndex := 0;
   while (TiposDeDados[ComboBoxTipo.ItemIndex].Tipo <> Tipo) do ComboBoxTipo.ItemIndex := ComboBoxTipo.ItemIndex + 1;
   EditTamanho.Text := Tamanho;
   EditTamanho.Enabled := Tamanho <> '';
   CheckBoxObrigatorio.Checked := Obrigatorio;
   CheckBoxID.Checked := Identidade;
   CheckBoxID.Enabled := TiposDeDados[ComboBoxTipo.ItemIndex].PermiteIdentidade;
   CheckBoxPK.Checked := PK;
   CheckBoxObrigatorio.Enabled := not PK;
end;

end.
