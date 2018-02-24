unit DBAppFormTabela;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Datasnap.DBClient, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Grids, Vcl.DBGrids, Vcl.ComCtrls, DBAppProjetoBase, DBAppColuna, Vcl.Menus,
  DBAppTiposDeDados;

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
    DataSetColunasValorPadrao: TStringField;
    DataSetColunasIdentidade: TStringField;
    DataSetColunasPK: TStringField;
    DataSetColunasFK: TStringField;
    DataSetColunasObrigatorio: TStringField;
    PanelOpcoesNovaTabela: TPanel;
    BtnSalvarNovaTabela: TButton;
    PopupMenuColunas: TPopupMenu;
    MenuTornarColunaObrigatoria: TMenuItem;
    MenuTornarCampoIdentidade: TMenuItem;
    MenuTirarObrigatoriedade: TMenuItem;
    DataSetColunasTamanho: TStringField;
    MenuAlterarTipoColuna: TMenuItem;
    procedure BtnNovaColunaClick(Sender: TObject);
    procedure BtnSalvarNovaTabelaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MenuAlterarTipoColunaClick(Sender: TObject);
    procedure DataSetColunasAfterScroll(DataSet: TDataSet);
    procedure DBGridColunasCellClick(Column: TColumn);
  private
    ProjetoBase : TDBAppProjetoBase;
    Nome : String;
    CarregandoColunas : Boolean;
    TiposDeDados : TArray<TDBAppTipoDadoRec>;
    function RetArrayColunas(): TArray<TDBAppColuna>;
    procedure ExibirProblemasEmProjetoBase;
    procedure AdicionarColunaEmDataSet(Coluna: TDBAppColuna);
    procedure AlterarColunaEmDataSet(Coluna: TDBAppColuna);
    procedure TratarPopupMenu;
  public
    procedure NovaTabela(ProjetoBase : TDBAppProjetoBase);
    procedure AdministrarTabela(ProjetoBase : TDBAppProjetoBase; Nome: String);
  end;

var
  FormTabela: TFormTabela;

implementation

{$R *.dfm}

uses DBAppFormNovaColuna, DBAppProblemas, DBAppFormAlterarTipoColuna;

procedure TFormTabela.ExibirProblemasEmProjetoBase;
begin
   if (ProjetoBase.ListaProblemas.Count > 0) then
   begin
      if (ProjetoBase.ListaProblemas.Count > 1) then
      begin
         Application.CreateForm(TFormProblemas, FormProblemas);
         FormProblemas.DefProblemas(ProjetoBase.ListaProblemas);
         FormProblemas.ShowModal;
         FormProblemas.Free;
      end else
      begin
         Application.MessageBox(PWideChar(ProjetoBase.ListaProblemas[0]),'Atenção',MB_OK+MB_ICONWARNING);
      end;
   end;
end;

procedure TFormTabela.AdicionarColunaEmDataSet(Coluna: TDBAppColuna);
begin
   DataSetColunas.Append;
   DataSetColunas['Id'] := Coluna.Id;
   DataSetColunas['Nome'] := Coluna.Nome;
   DataSetColunas['Tipo'] := Coluna.Tipo;
   DataSetColunas['Tamanho'] := Coluna.Tamanho;
   if Coluna.Obrigatorio then DataSetColunas['Obrigatorio'] := 'x';
   if Coluna.Identidade then DataSetColunas['Identidade'] := 'x';
   if Coluna.PK then DataSetColunas['PK'] := 'x';
   DataSetColunas.Post;
end;

procedure TFormTabela.AlterarColunaEmDataSet(Coluna: TDBAppColuna);
begin
   DataSetColunas.Edit;
   DataSetColunas['Id'] := Coluna.Id;
   DataSetColunas['Nome'] := Coluna.Nome;
   DataSetColunas['Tipo'] := Coluna.Tipo;
   DataSetColunas['Tamanho'] := Coluna.Tamanho;
   if Coluna.Obrigatorio then DataSetColunas['Obrigatorio'] := 'x';
   if Coluna.Identidade then DataSetColunas['Identidade'] := 'x';
   if Coluna.PK then DataSetColunas['PK'] := 'x';
   DataSetColunas.Post;
end;

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
         if (Nome = '') then
         begin
            PanelOpcoesNovaTabela.Visible := true;
            AdicionarColunaEmDataSet(NovaColuna);
         end else
         begin
            //se não for nova tenta adicionar a nova coluna na base (passando a coluna e o nome da tabela)
            if ProjetoBase.AdicionarColuna(NovaColuna, Nome) then
            begin
               AdicionarColunaEmDataSet(NovaColuna);
            end else
            begin
               ExibirProblemasEmProjetoBase();
            end;
         end;
      end;
   end;

   Self.Left := Self.Left + 9999;

   DBGridColunas.SetFocus;
end;

function TFormTabela.RetArrayColunas(): TArray<TDBAppColuna>;
var
   i : integer;
begin
   if (DataSetColunas.Active) and (DataSetColunas.RecordCount > 0) then
   begin
      DataSetColunas.First;
      SetLength(result,DataSetColunas.RecordCount);
      for i := 0 to DataSetColunas.RecordCount-1 do
      begin
         result[i] := TDBAppColuna.Create(
                           DataSetColunas.FieldByName('Id').AsInteger,
                           DataSetColunas.FieldByName('Nome').AsString,
                           DataSetColunas.FieldByName('Tipo').AsString,
                           DataSetColunas.FieldByName('Tamanho').AsString,
                           DataSetColunas.FieldByName('Obrigatorio').AsString='x',
                           DataSetColunas.FieldByName('PK').AsString='x',
                           DataSetColunas.FieldByName('Identidade').AsString='x'
                        );
         DataSetColunas.Next;
      end;
   end;
end;

procedure TFormTabela.BtnSalvarNovaTabelaClick(Sender: TObject);
var
   NomeTab : String;
   Colunas : TArray<TDBAppColuna>;
   i : integer;
begin
   //se chegou aqui significa que a tabela ainda não existe
   //então solicita ao usuário o nome da tabela
   NomeTab := InputBox('DBApp','Informe o nome da tabela:','');
   if (NomeTab <> '') then
   begin
      //tenta adicionar as colunas
      Colunas := RetArrayColunas();
      if ProjetoBase.AdicionarColunas(Colunas,NomeTab) then
      begin
         PanelOpcoesNovaTabela.Visible := false;
         Nome := NomeTab;
         self.Caption := 'Tabela - ' + Nome;
         //atualiza os ids das colunas
         for i := 0 to length(Colunas)-1 do
         begin
            if DataSetColunas.Locate('Nome',Colunas[i].Nome,[]) then
            begin
               DataSetColunas.Edit;
               DataSetColunas['id'] := Colunas[i].Id;
               DataSetColunas.Post;
            end;
         end;
         DBGridColunas.SetFocus;
         TratarPopupMenu;
      end else
      begin
         ExibirProblemasEmProjetoBase();
      end;
   end;
end;

procedure TFormTabela.DataSetColunasAfterScroll(DataSet: TDataSet);
var
   i : Integer;
begin
   if (not CarregandoColunas) then
   begin
      if (DataSetColunas.FieldByName('Id').AsInteger <= 0) then
      begin
         DBGridColunas.PopupMenu := nil;
         for i := 0 to PopupMenuColunas.Items.Count-1 do
            PopupMenuColunas.Items[i].Enabled := false;
      end else
      begin
         DBGridColunas.PopupMenu := PopupMenuColunas;

         MenuAlterarTipoColuna.Enabled := true;

         if (DataSetColunas.FieldByName('PK').AsString='x') then
         begin
            MenuTornarColunaObrigatoria.Visible := false;
            MenuTornarColunaObrigatoria.Enabled := false;
            MenuTirarObrigatoriedade.Visible := false;
            MenuTirarObrigatoriedade.Enabled := false;
         end else
         begin
            if (DataSetColunas.FieldByName('Obrigatorio').AsString='x') then
            begin
               MenuTornarColunaObrigatoria.Visible := false;
               MenuTornarColunaObrigatoria.Enabled := false;
               MenuTirarObrigatoriedade.Visible := true;
               MenuTirarObrigatoriedade.Enabled := true;
            end else
            begin
               MenuTornarColunaObrigatoria.Visible := true;
               MenuTornarColunaObrigatoria.Enabled := true;
               MenuTirarObrigatoriedade.Visible := false;
               MenuTirarObrigatoriedade.Enabled := false;
            end;
         end;

         i := 0;
         while (TiposDeDados[i].Tipo <> DataSetColunas.FieldByName('Tipo').AsString) do i := i + 1;

         if (TiposDeDados[i].PermiteIdentidade) then
         begin
            if (DataSetColunas.FieldByName('Identidade').AsString='x') then
            begin
               MenuTornarCampoIdentidade.Visible := false;
               MenuTornarCampoIdentidade.Enabled := false;
            end else
            begin
               MenuTornarCampoIdentidade.Visible := true;
               MenuTornarCampoIdentidade.Enabled := true;
            end;
         end else
         begin
            MenuTornarCampoIdentidade.Visible := false;
            MenuTornarCampoIdentidade.Enabled := false;
         end;
      end;
   end;
end;

procedure TFormTabela.TratarPopupMenu;
var
   NovaColuna : TDBAppColuna;
begin
   if (DataSetColunas.Active) and (DataSetColunas.RecordCount > 0) and (Nome = '') then
   begin
      Self.Left := Self.Left - 9999;

      Application.CreateForm(TFormNovaColuna, FormNovaColuna);
      FormNovaColuna.Alterar(
         DataSetColunas.FieldByName('Nome').AsString,
         DataSetColunas.FieldByName('Tipo').AsString,
         DataSetColunas.FieldByName('Tamanho').AsString,
         DataSetColunas.FieldByName('Obrigatorio').AsString='x',
         DataSetColunas.FieldByName('PK').AsString='x',
         DataSetColunas.FieldByName('Identidade').AsString='x'
      );
      FormNovaColuna.ShowModal;
      //pega o retorno
      NovaColuna := FormNovaColuna.NovaColuna;
      FormNovaColuna.Free;

      //se o retorno for válido
      if (NovaColuna <> nil) then
      begin
         if (NovaColuna.ListaProblemas.Count = 0) then
         begin
            AlterarColunaEmDataSet(NovaColuna);
         end;
      end;

      Self.Left := Self.Left + 9999;
   end;
end;

procedure TFormTabela.DBGridColunasCellClick(Column: TColumn);
begin
   TratarPopupMenu;
end;

procedure TFormTabela.FormCreate(Sender: TObject);
begin
   DataSetColunas.CreateDataSet;
   DataSetColunas.Open;
   TiposDeDados := TDBAppTiposDeDados.RetLista();
end;

procedure TFormTabela.FormShow(Sender: TObject);
begin
   if (DataSetColunas.Active) and (DataSetColunas.RecordCount > 0) then
      DBGridColunas.SetFocus
   else
      BtnNovaColuna.SetFocus;
end;

procedure TFormTabela.MenuAlterarTipoColunaClick(Sender: TObject);
var
   ColunaAlterada : TDBAppColuna;
begin
   if (DataSetColunas.Active) and (DataSetColunas.RecordCount > 0) then
   begin
      Application.CreateForm(TFormAlterarTipoColuna, FormAlterarTipoColuna);
      FormAlterarTipoColuna.Preparar(
         DataSetColunas.FieldByName('Nome').AsString,
         DataSetColunas.FieldByName('Tipo').AsString,
         DataSetColunas.FieldByName('Tamanho').AsString
      );

      FormAlterarTipoColuna.ShowModal;

      ColunaAlterada := ProjetoBase.AlterarTipoColuna(
                           DataSetColunas.FieldByName('Nome').AsString,
                           FormAlterarTipoColuna.ComboBoxNovoTipo.Text,
                           FormAlterarTipoColuna.EditNovoTamanho.Text,
                           Nome);

      if (ColunaAlterada <> nil) then
      begin
         if DataSetColunas.Locate('Nome', ColunaAlterada.Nome, []) then
         begin
            DataSetColunas.Edit;
            DataSetColunas['Tipo'] := ColunaAlterada.Tipo;
            DataSetColunas['Tamanho'] := ColunaAlterada.Tamanho;
            DataSetColunas.Post;
         end;
      end else
      begin
         ExibirProblemasEmProjetoBase();
      end;

      FormAlterarTipoColuna.Free;
   end;
end;

procedure TFormTabela.NovaTabela(ProjetoBase : TDBAppProjetoBase);
begin
   self.ProjetoBase := ProjetoBase;
   self.Nome := '';
end;

procedure TFormTabela.AdministrarTabela(ProjetoBase : TDBAppProjetoBase; Nome: String);
var
   Colunas : TArray<TDBAppColuna>;
   i : integer;
begin
   self.ProjetoBase := ProjetoBase;
   self.Nome := Nome;
   self.Caption := 'Tabela - ' + Nome;
   Colunas := ProjetoBase.CarregarColunas(Nome);
   if (ProjetoBase.ListaProblemas.Count > 0) then
   begin
      ExibirProblemasEmProjetoBase();
   end else
   begin
      CarregandoColunas := true;
      for i := 0 to length(Colunas)-1 do AdicionarColunaEmDataSet(Colunas[i]);
      CarregandoColunas := false;
      DataSetColunas.First;
   end;
end;

end.
