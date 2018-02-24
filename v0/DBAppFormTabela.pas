unit DBAppFormTabela;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Datasnap.DBClient, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Grids, Vcl.DBGrids, Vcl.ComCtrls, DBAppProjetoBase, DBAppColuna;

type
  TFormTabela = class(TForm)
    PageControlTabela: TPageControl;
    TabColunas: TTabSheet;
    DBGridColunas: TDBGrid;
    Panel1: TPanel;
    BtnNovaColuna: TButton;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    TabChaves: TTabSheet;
    DataSourceColunas: TDataSource;
    DataSetColunas: TClientDataSet;
    DataSetColunasNome: TStringField;
    DataSetColunasCadastro: TDateTimeField;
    DataSetColunasAlteracao: TDateTimeField;
    DataSetColunasId: TIntegerField;
    DataSetColunasTipo: TStringField;
    DataSetColunasTamanho: TIntegerField;
    DataSetColunasValorPadrao: TStringField;
    DataSetColunasIdentidade: TStringField;
    DataSetColunasPK: TStringField;
    DataSetColunasFK: TStringField;
    DataSetColunasNulo: TStringField;
    PanelOpcoesNovaTabela: TPanel;
    BtnSalvarNovaTabela: TButton;
    procedure BtnNovaColunaClick(Sender: TObject);
    procedure BtnSalvarNovaTabelaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FProjetoBase : TDBAppProjetoBase;
    FNome : String;
  public
    procedure NovaTabela(ProjetoBase : TDBAppProjetoBase);
    procedure AdministrarTabela(ProjetoBase : TDBAppProjetoBase; Nome: String);
  end;

var
  FormTabela: TFormTabela;

implementation

{$R *.dfm}

uses DBAppFormNovaColuna;

procedure TFormTabela.BtnNovaColunaClick(Sender: TObject);
var
   NovaColuna : TDBAppColuna;
begin
   Self.Left := Self.Left - 9999;

   Application.CreateForm(TFormNovaColuna, FormNovaColuna);
   FormNovaColuna.ShowModal;
   //pega o retorno
   NovaColuna := FormNovaColuna.NovaColuna;
   FormNovaColuna.Free;

   //se o retorno for válido
   if (NovaColuna <> nil) then
   begin
      if (NovaColuna.ListaProblemas.Count = 0) then
      begin
         //verifica se a tabela é nova
         if (FNome = '') then
         begin
            //se for nova exibe o painel de opções (PanelOpcoesNovaTabela)
            PanelOpcoesNovaTabela.Visible := true;
            //insere no dataset
            DataSetColunas.Append;
            DataSetColunas['Id'] := 0;
            DataSetColunas['Nome'] := NovaColuna.Nome;
            DataSetColunas['Tipo'] := NovaColuna.Tipo;
            if (NovaColuna.Tamanho > 0) then DataSetColunas['Tamanho'] := NovaColuna.Tamanho;
            if NovaColuna.Nulo then DataSetColunas['Nulo'] := 'x';
            if NovaColuna.Identidade then DataSetColunas['Identidade'] := 'x';
            if NovaColuna.PK then DataSetColunas['PK'] := 'x';
            DataSetColunas.Post;
         end else
         begin
            //se não for nova tenta adicionar a nova coluna na base (passando a coluna e o nome da tabela)
            //se não deu certo exibe os problemas ao usuário
            //se deu certo atualiza a lista de colunas
         end;
      end;
   end;

   Self.Left := Self.Left + 9999;
end;

procedure TFormTabela.BtnSalvarNovaTabelaClick(Sender: TObject);
begin
   //verifica se já existe o objeto tabela na base
   //se não existe solicita ao usuário o nome da tabela
      //tenta adicionar a nova coluna na base (passando a coluna e o nome da tabela)
         //se não deu certo exibe os problemas ao usuário
         //se deu certo atualiza a lista de colunas
   //se já existe esconde o painel de opções (PanelOpcoesNovaTabela)
end;

procedure TFormTabela.FormCreate(Sender: TObject);
begin
   DataSetColunas.CreateDataSet;
   DataSetColunas.Open;
end;

procedure TFormTabela.NovaTabela(ProjetoBase : TDBAppProjetoBase);
begin
   FProjetoBase := ProjetoBase;
   FNome := '';
end;

procedure TFormTabela.AdministrarTabela(ProjetoBase : TDBAppProjetoBase; Nome: String);
begin
   FProjetoBase := ProjetoBase;
   FNome := Nome;
end;

end.
