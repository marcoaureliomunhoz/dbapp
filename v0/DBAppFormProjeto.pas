unit DBAppFormProjeto;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DBAppProjetoBase, Vcl.ComCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids, Datasnap.DBClient, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TFormProjeto = class(TForm)
    PageControlProjeto: TPageControl;
    TabTabelas: TTabSheet;
    TabImplantacoes: TTabSheet;
    DBGridTabelas: TDBGrid;
    DataSourceTabelas: TDataSource;
    DataSetTabelas: TClientDataSet;
    DataSetTabelasNome: TStringField;
    DataSetTabelasCadastro: TDateTimeField;
    DataSetTabelasAlteracao: TDateTimeField;
    DataSetTabelasId: TIntegerField;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    BtnNovaTabela: TButton;
  private
    ProjetoBase : TDBAppProjetoBase;
    ListaTabelas : TArray<TDBAppBaseRec>;
  public
    function CarregarProjeto(DiretorioDeProjetos, Nome : string): boolean;
  end;

var
  FormProjeto: TFormProjeto;

implementation

{$R *.dfm}

function TFormProjeto.CarregarProjeto(DiretorioDeProjetos, Nome : string): boolean;
var
   i : integer;
begin
   self.Caption := 'Projeto - ' + Nome;
   Result := false;
   ProjetoBase := TDBAppProjetoBase.Create(DiretorioDeProjetos, Nome);

   DataSetTabelas.CreateDataSet;
   DataSetTabelas.Open;

   ListaTabelas := ProjetoBase.ListarTabelas;
   for i := 0 to length(ListaTabelas)-1 do
   begin
      DataSetTabelas.Append;
      DataSetTabelas['Id'] := ListaTabelas[i].Id;
      DataSetTabelas['Nome'] := ListaTabelas[i].Nome;
      DataSetTabelas['Cadastro'] := ListaTabelas[i].Cadastro;
      DataSetTabelas['Alteracao'] := ListaTabelas[i].Alteracao;
      DataSetTabelas.Post;
   end;

   Result := true;
end;

end.
