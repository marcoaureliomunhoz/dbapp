unit DBAppProjetoBase;

interface

uses
   Winapi.Windows, System.SysUtils, System.Variants, System.Classes,
   IOUtils, XMLDoc, XMLIntf, XMLDom, DBAppBaseArq;

type
   TDBAppBaseRec = record
      Id : integer;
      Nome : string;
      Cadastro : TDateTime;
      Alteracao : TDateTime
   end;
   TDBAppProjetoBase = class(TDBAppBaseArq)
      FDiretorioDeProjetos : String;
      FNome : String;
      FDiretorioBase : String;
      ListaBase : TArray<TDBAppBaseRec>;
      BaseArqNome : string;
      BaseArqPath : string;
      function GerarXmlBase: string;
      procedure CarregarBase;
   public
      constructor Create(DiretorioDeProjetos, Nome: String);
      function ListarTabelas: TArray<TDBAppBaseRec>;
   end;

implementation

constructor TDBAppProjetoBase.Create(DiretorioDeProjetos, Nome:String);
begin
   FDiretorioDeProjetos := CompletarDiretorio(DiretorioDeProjetos);
   FNome := Nome;
   FDiretorioBase := FDiretorioDeProjetos + 'db\' + Nome;
   CarregarBase;
end;

function TDBAppProjetoBase.GerarXmlBase: string;
var
   i : integer;
begin
   result :=
      '<dbapp_base>';

   for i := 0 to length(ListaBase)-1 do
   begin
      if (Trim(ListaBase[i].Nome)<>'') and (ListaBase[i].Id>0) then
      begin
         result := result +
              '<tabela id="'+IntToStr(ListaBase[i].Id)+'" nome="'+ListaBase[i].Nome+'">'+
                  '<cadastro>'+FormatDateTime('dd/mm/yyyy hh:mm:ss',ListaBase[i].Cadastro)+'</cadastro>'+
                  '<alteracao>'+FormatDateTime('dd/mm/yyyy hh:mm:ss',ListaBase[i].Alteracao)+'</alteracao>'+
              '</tabela>';
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
   BaseArqPath := TPath.Combine(FDiretorioBase,BaseArqNome);
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

function TDBAppProjetoBase.ListarTabelas: TArray<TDBAppBaseRec>;
var
   Lista : TArray<TDBAppBaseRec>;
   i : integer;
begin
   SetLength(Lista, Length(ListaBase));
   for i := 0 to length(ListaBase)-1 do
   begin
      Lista[i].Id := ListaBase[i].Id;
      Lista[i].Nome := ListaBase[i].Nome;
      Lista[i].Cadastro := ListaBase[i].Cadastro;
      Lista[i].Alteracao := ListaBase[i].Alteracao;
   end;
   Result := Lista;
end;

end.
