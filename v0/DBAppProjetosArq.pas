unit DBAppProjetosArq;

interface

uses
   Winapi.Windows, System.SysUtils, System.Variants, System.Classes,
   IOUtils, XMLDoc, XMLIntf, XMLDom, DBAppBaseArq;

type
   TDBAppProjetoRec = record
      Nome : string;
      Cadastro : TDateTime;
      Alteracao : TDateTime
   end;
   TDBAppProjetosArq = class(TDBAppBaseArq)
   private
      FListaProblemas : TStringList;
      FDiretorioDeProjetos : String;
      FDiretorioDb : String;
      ProjetosArqPath : String;
      ProjetosArqNome : String;
      ListaProjetos : TArray<TDBAppProjetoRec>;
      procedure CarregarProjetosArq;
      function GerarXml: string;
      function Salvar: boolean;
      function ProjetoJaExiste(Nome: string): boolean;
   public
      constructor Create(DiretorioDeProjetos: string);
      destructor Destroy;
      function NovoProjeto(Nome: string): boolean;
      function AlterarProjeto(NomeAtual, NovoNome: string): boolean;
      function ExcluirProjeto(Nome: string): boolean;
      function ListarProjetos: TArray<TDBAppProjetoRec>;
      property ListaProblemas : TStringList read FListaProblemas;
   end;

implementation

constructor TDBAppProjetosArq.Create(DiretorioDeProjetos: string);
begin
   inherited Create();
   FDiretorioDeProjetos := DiretorioDeProjetos;
   FListaProblemas := TStringList.Create;
   CarregarProjetosArq;
   FDiretorioDb := TPath.Combine(DiretorioDeProjetos,'db');
   if (not DirectoryExists(FDiretorioDb)) then
   begin
      CreateDir(FDiretorioDb);
   end;
end;

destructor TDBAppProjetosArq.Destroy;
begin
   SetLength(ListaProjetos, 0);
   ListaProjetos := nil;
   FListaProblemas.Clear;
   inherited Destroy;
end;

function TDBAppProjetosArq.GerarXml: string;
var
   i : integer;
   Projeto : TDBAppProjetoRec;
begin
   result :=
      '<dbapp_projetos>';

   for i := 0 to length(ListaProjetos)-1 do
   begin
      if (Trim(ListaProjetos[i].Nome)<>'') then
      begin
         result := result +
              '<projeto>'+
                  '<nome>'+ListaProjetos[i].Nome+'</nome>'+
                  '<cadastro>'+FormatDateTime('dd/mm/yyyy hh:mm:ss',ListaProjetos[i].Cadastro)+'</cadastro>'+
                  '<alteracao>'+FormatDateTime('dd/mm/yyyy hh:mm:ss',ListaProjetos[i].Alteracao)+'</alteracao>'+
              '</projeto>';
      end;
   end;

   result := result +
      '</dbapp_projetos>';
end;

function TDBAppProjetosArq.Salvar: boolean;
begin
   Result := false;

   FListaProblemas.Clear;

   if (FListaProblemas.Count = 0) then
   begin
      try
         TFile.WriteAllText(ProjetosArqPath,GerarXml());
         Result := true;
      except
         FListaProblemas.Add('Não foi possível salvar o arquivo de projetos.');
      end;
   end;
end;

procedure TDBAppProjetosArq.CarregarProjetosArq;
var
   ProjetosStr : String;
   ProjetosDoc : IXMLDocument;
   NodeListProjetos : IXMLNodeList;
   i : integer;
   aux : string;
begin
   ProjetosStr := GerarXml();

   ProjetosArqNome := 'projetos.dbapp';
   ProjetosArqPath := TPath.Combine(FDiretorioDeProjetos,ProjetosArqNome);
   if (FileExists(ProjetosArqPath)) then
   begin
      try
         ProjetosStr := TFile.ReadAllText(ProjetosArqPath);
      except
      end;
   end;

   ProjetosDoc := TXMLDocument.Create(nil);
   ProjetosDoc.LoadFromXML(ProjetosStr);

   NodeListProjetos := ProjetosDoc.DocumentElement.ChildNodes;
   if (NodeListProjetos <> nil) then
   begin
      SetLength(ListaProjetos, NodeListProjetos.Count);
      for i := 0 to NodeListProjetos.Count-1 do
      begin
         try
            aux := NodeListProjetos[i].ChildNodes[0].Text;
            ListaProjetos[i].Nome := aux;
            aux := NodeListProjetos[i].ChildNodes[1].Text;
            ListaProjetos[i].Cadastro := StrToDateTime(aux);
            aux := NodeListProjetos[i].ChildNodes[2].Text;
            ListaProjetos[i].Alteracao := StrToDateTime(aux);
         except
         end;
      end;
   end;
end;

function TDBAppProjetosArq.ListarProjetos: TArray<TDBAppProjetoRec>;
var
   Lista : TArray<TDBAppProjetoRec>;
   i : integer;
begin
   SetLength(Lista, Length(ListaProjetos));
   for i := 0 to length(ListaProjetos)-1 do
   begin
      Lista[i].Nome := ListaProjetos[i].Nome;
      Lista[i].Cadastro := ListaProjetos[i].Cadastro;
      Lista[i].Alteracao := ListaProjetos[i].Alteracao;
   end;
   Result := Lista;
end;

function TDBAppProjetosArq.ProjetoJaExiste(Nome: string): boolean;
var
   i : integer;
   TamLista : integer;
   achou : boolean;
begin
   TamLista := Length(ListaProjetos);
   i := 0;
   achou := false;
   while (not achou) and (i < TamLista) do
   begin
      if (ListaProjetos[i].Nome = Nome) then
      begin
         achou := true;
      end else
      begin
         i := i + 1;
      end;
   end;
   result := achou;
end;

function TDBAppProjetosArq.NovoProjeto(Nome: string): boolean;
var
   TamanhoAnt : integer;
   DiretorioProjeto : string;
begin
   Result := false;
   try
      if (ProjetoJaExiste(Nome)) then
      begin
         FListaProblemas.Add('Já existe um projeto com este nome.');
      end else
      begin
         DiretorioProjeto := TPath.Combine(FDiretorioDb, Nome);
         if (DirectoryExists(DiretorioProjeto)) then
         begin
            FListaProblemas.Add('Já existe um diretório de projeto com o nome "'+Nome+'" em "'+FDiretorioDb+'".');
         end else
         begin
            if (CreateDir(DiretorioProjeto)) then
            begin
               TamanhoAnt := length(ListaProjetos);
               SetLength(ListaProjetos,TamanhoAnt+1);
               ListaProjetos[TamanhoAnt].Nome := Nome;
               ListaProjetos[TamanhoAnt].Cadastro := Now;
               ListaProjetos[TamanhoAnt].Alteracao := Now;

               Result := Salvar();
            end else
            begin
               FListaProblemas.Add('Não foi possível criar o diretório do projeto "'+DiretorioProjeto+'".');
            end;
         end;
      end;
   except
   end;
end;

function TDBAppProjetosArq.AlterarProjeto(NomeAtual, NovoNome: string): boolean;
var
   i : integer;
   TamLista : integer;
   achou : boolean;
   DiretorioProjetoAnt : string;
   DiretorioProjetoNovo : string;
begin
   Result := false;
   TamLista := Length(ListaProjetos);
   i := 0;
   achou := false;
   while (not achou) and (i < TamLista) do
   begin
      if (ListaProjetos[i].Nome = NomeAtual) then
      begin
         achou := true;

         try
            DiretorioProjetoNovo := CompletarDiretorio(TPath.Combine(FDiretorioDb, NovoNome));
            if (DirectoryExists(DiretorioProjetoNovo)) then
            begin
               FListaProblemas.Add('Já existe um diretório de projeto com o nome "'+NovoNome+'" em "'+FDiretorioDb+'".');
            end else
            begin
               if (CreateDir(DiretorioProjetoNovo)) then
               begin
                  ListaProjetos[i].Nome := NovoNome;
                  ListaProjetos[i].Alteracao := Now;

                  DiretorioProjetoAnt := CompletarDiretorio(TPath.Combine(FDiretorioDb, NomeAtual));
                  TDirectory.Copy(DiretorioProjetoAnt, DiretorioProjetoNovo);

                  if Salvar() then
                  begin
                     Result := true;
                  end else
                  begin
                     //volta o nome anterior
                     ListaProjetos[i].Nome := NomeAtual;
                  end;
               end else
               begin
                  FListaProblemas.Add('Não foi possível criar o diretório do projeto em "'+FDiretorioDb+'".');
               end;
            end;
         except
            FListaProblemas.Add('Não foi possível alterar o nome do projeto.');
         end;
      end else
      begin
         i := i + 1;
      end;
   end;
end;

function TDBAppProjetosArq.ExcluirProjeto(Nome: string): boolean;
var
   i : integer;
   TamLista : integer;
   achou : boolean;
begin
   Result := false;
   TamLista := Length(ListaProjetos);
   i := 0;
   achou := false;
   while (not achou) and (i < TamLista) do
   begin
      if (ListaProjetos[i].Nome = Nome) then
      begin
         achou := true;
         ListaProjetos[i].Nome := '';
         Result := Salvar();
      end else
      begin
         i := i + 1;
      end;
   end;
end;

end.
