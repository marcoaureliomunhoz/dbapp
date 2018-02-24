unit DBAppProjetoBase;

interface

uses
   Winapi.Windows, System.SysUtils, System.Variants, System.Classes,
   IOUtils, XMLDoc, XMLIntf, XMLDom, DBAppBaseArq, DBAppColuna;

type
   TDBAppBaseRec = record
      Id : integer;
      Nome : string;
      Cadastro : TDateTime;
      Alteracao : TDateTime
   end;

   TDBAppProjetoBase = class(TDBAppBaseArq)
      DiretorioDeProjetos : String;
      Nome : String;
      DiretorioBase : String;
      ListaProblemas : TStringList;
      ListaBase : TArray<TDBAppBaseRec>;
      UltimoIdListaBase : integer;
      BaseArqNome : string;
      BaseArqPath : string;
      function GerarXmlBase: string;
      procedure CarregarBase;
      function AdicionarTabela(Nome: String): boolean;
      function SalvarBase: boolean;
      function SalvarTabela(Colunas: TArray<TDBAppColuna>; Tabela: String): boolean;
   public
      constructor Create(DiretorioDeProjetos, Nome: String);
      function ListarTabelas: TArray<TDBAppBaseRec>;
      function RetIndiceTabela(Nome: String): Integer;
      function TabelaExiste(Nome: String): Boolean;
      function AdicionarColuna(var Coluna: TDBAppColuna; Tabela: String): boolean;
      function AdicionarColunas(var Colunas: TArray<TDBAppColuna>; Tabela: String): boolean;
      function CarregarColunas(Tabela: String): TArray<TDBAppColuna>;
      function AlterarTipoColuna(Coluna, NovoTipo, NovoTamanho, Tabela: String): TDBAppColuna;
   end;

implementation

constructor TDBAppProjetoBase.Create(DiretorioDeProjetos, Nome:String);
begin
   self.DiretorioDeProjetos := CompletarDiretorio(DiretorioDeProjetos);
   self.Nome := Nome;
   self.DiretorioBase := CompletarDiretorio(self.DiretorioDeProjetos + 'db\' + Nome);
   UltimoIdListaBase := 0;
   ListaProblemas := TStringList.Create;
   CarregarBase;
end;

function TDBAppProjetoBase.GerarXmlBase: string;
var
   i : integer;
begin
   result :=
      '<dbapp_base>'+#13;

   for i := 0 to length(ListaBase)-1 do
   begin
      if (Trim(ListaBase[i].Nome)<>'') and (ListaBase[i].Id>0) then
      begin
         result := result +
              '   <tabela id="'+IntToStr(ListaBase[i].Id)+'" nome="'+ListaBase[i].Nome+'">'+#13+
              '      <cadastro>'+FormatDateTime('dd/mm/yyyy hh:mm:ss',ListaBase[i].Cadastro)+'</cadastro>'+#13+
              '      <alteracao>'+FormatDateTime('dd/mm/yyyy hh:mm:ss',ListaBase[i].Alteracao)+'</alteracao>'+#13+
              '   </tabela>'+#13;
      end;
   end;

   result := result +
      '</dbapp_base>';
end;

procedure TDBAppProjetoBase.CarregarBase;
var
   BaseStr : String;
   BaseDoc : IXMLDocument;
   NodeListTabelas : IXMLNodeList;
   i : integer;
   aux : string;
begin
   BaseStr := GerarXmlBase();

   BaseArqNome := 'base.dbapp';
   BaseArqPath := TPath.Combine(DiretorioBase,BaseArqNome);
   if (FileExists(BaseArqPath)) then
   begin
      try
         BaseStr := TFile.ReadAllText(BaseArqPath);
      except
      end;
   end;

   BaseDoc := TXMLDocument.Create(nil);
   BaseDoc.LoadFromXML(BaseStr);

   NodeListTabelas := BaseDoc.DocumentElement.ChildNodes;
   if (NodeListTabelas <> nil) then
   begin
      SetLength(ListaBase, NodeListTabelas.Count);
      for i := 0 to NodeListTabelas.Count-1 do
      begin
         try
            aux := NodeListTabelas[i].Attributes['id'];
            ListaBase[i].Id := StrToInt(aux);
            if (ListaBase[i].Id > UltimoIdListaBase) then UltimoIdListaBase := ListaBase[i].Id;

            aux := NodeListTabelas[i].Attributes['nome'];
            ListaBase[i].Nome := aux;

            aux := NodeListTabelas[i].ChildNodes[0].Text;
            ListaBase[i].Cadastro := StrToDateTime(aux);

            aux := NodeListTabelas[i].ChildNodes[1].Text;
            ListaBase[i].Alteracao := StrToDateTime(aux);
         except
         end;
      end;
   end;
end;

function TDBAppProjetoBase.CarregarColunas(Tabela: String): TArray<TDBAppColuna>;
var
   TabelaStr : String;
   TabelaDoc : IXMLDocument;
   NodeListColunas : IXMLNodeList;
   i : integer;
   aux : string;
   TabelaArqPath : string;
begin
   TabelaStr := '';

   TabelaArqPath := TPath.Combine(DiretorioBase,Tabela+'.tb');
   if (FileExists(TabelaArqPath)) then
   begin
      try
         TabelaStr := TFile.ReadAllText(TabelaArqPath);
      except
         ListaProblemas.Add('Não foi possível ler o arquivo tabela "'+TabelaArqPath+'".');
      end;
   end;

   TabelaDoc := TXMLDocument.Create(nil);
   TabelaDoc.LoadFromXML(TabelaStr);

   NodeListColunas := TabelaDoc.DocumentElement.ChildNodes;
   if (NodeListColunas <> nil) then
   begin
      SetLength(result, NodeListColunas.Count);
      for i := 0 to NodeListColunas.Count-1 do
      begin
         try
            result[i] := TDBAppColuna.Create(
               StrToInt(NodeListColunas[i].Attributes['id']),     //Id
               NodeListColunas[i].Attributes['nome'],             //Nome
               NodeListColunas[i].ChildNodes[0].Text,             //Tipo
               NodeListColunas[i].ChildNodes[1].Text,             //Tamanho
               NodeListColunas[i].ChildNodes[2].Text='x',         //Obrigatorio
               NodeListColunas[i].ChildNodes[3].Text='x',         //PK
               NodeListColunas[i].ChildNodes[4].Text='x'          //Identidade
            );
         except
            ListaProblemas.Add('Não foi possível ler a coluna ['+IntToStr(i)+'] do arquivo tabela "'+TabelaArqPath+'".');
         end;
      end;
   end;
end;

function TDBAppProjetoBase.ListarTabelas: TArray<TDBAppBaseRec>;
var
   i : integer;
begin
   SetLength(result, Length(ListaBase));
   for i := 0 to length(ListaBase)-1 do
   begin
      result[i].Id := ListaBase[i].Id;
      result[i].Nome := ListaBase[i].Nome;
      result[i].Cadastro := ListaBase[i].Cadastro;
      result[i].Alteracao := ListaBase[i].Alteracao;
   end;
end;

function TDBAppProjetoBase.RetIndiceTabela(Nome: String): Integer;
var
   i : Integer;
begin
   result := -1;
   i := 0;
   while (result = -1) and (i < length(ListaBase)) do
   begin
      if (ListaBase[i].Nome = Nome) then
         result := i
      else
         i := i + 1;
   end;
end;

function TDBAppProjetoBase.TabelaExiste(Nome: String): Boolean;
begin
   result := RetIndiceTabela(Nome) >= 0;
end;

function TDBAppProjetoBase.SalvarBase: boolean;
begin
   Result := false;

   ListaProblemas.Clear;

   if (ListaProblemas.Count = 0) then
   begin
      try
         TFile.WriteAllText(BaseArqPath,GerarXmlBase());
         Result := true;
      except
         ListaProblemas.Add('Não foi possível salvar o arquivo base.');
      end;
   end;
end;

function TDBAppProjetoBase.AdicionarTabela(Nome: String): boolean;
var
   NomeTabelaArq : string;
   TamanhoAnt : integer;
begin
   Result := false;
   ListaProblemas.Clear;
   if (TabelaExiste(Nome)) then
   begin
      ListaProblemas.Add('A tabela "'+Nome+'" já existe.');
   end else
   begin
      NomeTabelaArq := DiretorioBase + Nome + '.tb';
      if FileExists(NomeTabelaArq) then
      begin
         ListaProblemas.Add('Já existe um arquivo de tabela com o nome "'+Nome+'" em "'+DiretorioBase+'".');
      end else
      begin
         TamanhoAnt := length(ListaBase);
         SetLength(ListaBase,TamanhoAnt+1);
         UltimoIdListaBase := UltimoIdListaBase + 1;
         ListaBase[TamanhoAnt].Id := UltimoIdListaBase;
         ListaBase[TamanhoAnt].Nome := Nome;
         ListaBase[TamanhoAnt].Cadastro := Now;
         ListaBase[TamanhoAnt].Alteracao := Now;

         Result := SalvarBase();
      end;
   end;
end;

function TDBAppProjetoBase.AdicionarColuna(var Coluna: TDBAppColuna; Tabela: String): boolean;
var
   Colunas: TArray<TDBAppColuna>;
   i : integer;
   NroDeColunas : integer;
   MaiorId : integer;
   ColunaJaExiste : boolean;
begin
   result := false;
   ListaProblemas.Clear;
   Colunas := CarregarColunas(Tabela);
   if (ListaProblemas.Count = 0) then
   begin
      NroDeColunas := length(Colunas);
      //verifica se a coluna já existe e pega o maior id
      ColunaJaExiste := false;
      MaiorId := 0;
      for i := 0 to NroDeColunas-1 do
      begin
         if (Colunas[i].Nome = Coluna.Nome) then ColunaJaExiste := true;
         if (Colunas[i].Id > MaiorId) then MaiorId := Colunas[i].Id;
      end;
      if (ColunaJaExiste) then
      begin
         ListaProblemas.Add('Já existe uma coluna "'+Coluna.Nome+'" na tabela "'+Tabela+'".');
      end else
      begin
         SetLength(Colunas,NroDeColunas+1);
         Coluna.DefId(MaiorId+1);
         Colunas[NroDeColunas] := TDBAppColuna.CreateFrom(Coluna);
         result := SalvarTabela(Colunas, Tabela);
      end;
   end;
end;

function TDBAppProjetoBase.SalvarTabela(Colunas: TArray<TDBAppColuna>; Tabela: String): boolean;
var
   XmlFinal : string;
   XmlColunas : string;
   Obrigatorio : string;
   PK : string;
   Identidade : string;
   i : integer;
   NomeTabelaArq : string;
begin
   Result := false;

   XmlColunas := '';
   for i := 0 to length(Colunas)-1 do
   begin
      Obrigatorio := '';
      if (Colunas[i].Obrigatorio) then Obrigatorio := 'x';
      PK := '';
      if (Colunas[i].PK) then PK := 'x';
      Identidade := '';
      if (Colunas[i].Identidade) then Identidade := 'x';
      XmlColunas := XmlColunas +
           '      <coluna id="'+IntToStr(Colunas[i].Id)+'" nome="'+Colunas[i].Nome+'">'+#13+
           '         <tipo>'+Colunas[i].Tipo+'</tipo>'+#13+
           '         <tamanho>'+Colunas[i].Tamanho+'</tamanho>'+#13+
           '         <obrigatorio>'+Obrigatorio+'</obrigatorio>'+#13+
           '         <pk>'+PK+'</pk>'+#13+
           '         <identidade>'+Identidade+'</identidade>'+#13+
           '         <cadastro>'+FormatDateTime('dd/mm/yyyy hh:mm:ss',Now)+'</cadastro>'+#13+
           '         <alteracao>'+FormatDateTime('dd/mm/yyyy hh:mm:ss',Now)+'</alteracao>'+#13+
           '      </coluna>'+#13;
   end;

   XmlFinal :=
      '<dbapp_tb>'+#13+
         XmlColunas +
      '</dbapp_tb>';

   NomeTabelaArq := DiretorioBase + Tabela + '.tb';

   try
      TFile.WriteAllText(NomeTabelaArq,XmlFinal);
      Result := true;
   except
      ListaProblemas.Add('Não foi possível salvar o arquivo tabela.');
   end;
end;

function TDBAppProjetoBase.AdicionarColunas(var Colunas: TArray<TDBAppColuna>; Tabela: String): boolean;
var
   i : integer;
begin
   result := false;
   if AdicionarTabela(Tabela) then
   begin
      //como a tabela ainda não existe precisa definir os ids
      for i := 0 to length(Colunas)-1 do
      begin
         Colunas[i].DefId(i+1);
      end;

      result := SalvarTabela(Colunas, Tabela);
   end;
end;

function TDBAppProjetoBase.AlterarTipoColuna(Coluna, NovoTipo, NovoTamanho, Tabela: String): TDBAppColuna;
var
   Colunas: TArray<TDBAppColuna>;
   i : integer;
   PosicaoColunaAlterada : integer;
begin
   result := nil;
   ListaProblemas.Clear;
   Colunas := CarregarColunas(Tabela);
   if (ListaProblemas.Count = 0) then
   begin
      //localiza a coluna e realiza a modificação
      for i := 0 to length(Colunas)-1 do
         if (Colunas[i].Nome = Coluna) then
            if (Colunas[i].DefTipo(NovoTipo, NovoTamanho)) then
               PosicaoColunaAlterada := i
            else
               ListaProblemas.Assign(Colunas[i].ListaProblemas);

      //salva
      if (ListaProblemas.Count = 0) then
      begin
         if SalvarTabela(Colunas, Tabela) then
            result := TDBAppColuna.CreateFrom(Colunas[PosicaoColunaAlterada]);
      end;
   end;
end;

end.
