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
    procedure BtnNovaTabelaClick(Sender: TObject);
    procedure DBGridTabelasCellClick(Column: TColumn);
    procedure FormShow(Sender: TObject);
  private
    ProjetoBase : TDBAppProjetoBase;
    ListaTabelas : TArray<TDBAppBaseRec>;
    procedure CarregarTabelas;
  public
    function CarregarProjeto(DiretorioDeProjetos, Nome : string): boolean;
  end;

var
  FormProjeto: TFormProjeto;

implementation

{$R *.dfm}

uses DBAppFormTabela;

procedure TFormProjeto.BtnNovaTabelaClick(Sender: TObject);
begin
   self.Left := self.Left - 9999;
   Application.CreateForm(TFormTabela, FormTabela);
   FormTabela.NovaTabela(ProjetoBase);
   FormTabela.ShowModal;
   FormTabela.Free;
   self.Left := self.Left + 9999;
   DBGridTabelas.SetFocus;
   CarregarTabelas;
end;

procedure TFormProjeto.CarregarTabelas;
var
   i : integer;
begin
   if (DataSetTabelas.Active) then
   begin
      while (DataSetTabelas.RecordCount > 0) do DataSetTabelas.Delete;
   end else
   begin
      DataSetTabelas.Open;
   end;

   SetLength(ListaTabelas,0);
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
end;

function TFormProjeto.CarregarProjeto(DiretorioDeProjetos, Nome : string): boolean;
begin
   self.Caption := 'Projeto - ' + Nome;
   Result := false;
   ProjetoBase := TDBAppProjetoBase.Create(DiretorioDeProjetos, Nome);

   DataSetTabelas.CreateDataSet;
   CarregarTabelas;
   DataSetTabelas.First;

   Result := true;
end;

procedure TFormProjeto.DBGridTabelasCellClick(Column: TColumn);
begin
   if (DataSetTabelas.Active) and (DataSetTabelas.RecordCount > 0) then
   begin
      self.Left := self.Left - 9999;
      Application.CreateForm(TFormTabela, FormTabela);
      FormTabela.AdministrarTabela(ProjetoBase, DataSetTabelas.FieldByName('Nome').AsString);
      FormTabela.ShowModal;
      FormTabela.Free;
      self.Left := self.Left + 9999;
   end;
end;

procedure TFormProjeto.FormShow(Sender: TObject);
begin
   if (DataSetTabelas.Active) and (DataSetTabelas.RecordCount > 0) then
      DBGridTabelas.SetFocus
   else
      BtnNovaTabela.SetFocus;
end;

end.
