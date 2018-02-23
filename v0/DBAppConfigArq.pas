unit DBAppConfigArq;

interface

uses
   Winapi.Windows, System.SysUtils, System.Variants, System.Classes,
   IOUtils, XMLDoc, XMLIntf, DBAppBaseArq;

type
   TDBAppConfigArq = class(TDBAppBaseArq)
   private
      ConfigArqPath : String;
      ConfigArqNome : String;
      FDiretorioDeProjetos : string;
      FListaProblemas : TStringList;
      procedure CarregarConfigArq;
      function GerarXml: string;
      procedure DefDiretorio(const Value: string);
   public
      constructor Create;
      function Salvar: boolean;
      property DiretorioDeProjetos : string read FDiretorioDeProjetos write DefDiretorio;
      property ListaProblemas : TStringList read FListaProblemas;
   end;

implementation

constructor TDBAppConfigArq.Create;
begin
   inherited Create();
   FListaProblemas := TStringList.Create;
   CarregarConfigArq;
end;

function TDBAppConfigArq.GerarXml: string;
begin
   result :=
      '<dbapp_config>'+
        '<projetos>'+FDiretorioDeProjetos+'</projetos>'+
      '</dbapp_config>';
end;

function TDBAppConfigArq.Salvar: boolean;
begin
   Result := false;

   FListaProblemas.Clear;

   if (FDiretorioDeProjetos = '') then
   begin
      FListaProblemas.Add('O diretório de projetos não foi informado.');
   end;

   if (FListaProblemas.Count = 0) then
   begin
      try
         TFile.WriteAllText(ConfigArqPath,GerarXml());
         Result := true;
      except
         FListaProblemas.Add('Não foi possível salvar o arquivo de configuração.');
      end;
   end;
end;

procedure TDBAppConfigArq.CarregarConfigArq;
var
   ConfigStr : String;
   ConfigDoc : IXMLDocument;
   NodeProjetos : IXMLNode;
begin
   ConfigStr := GerarXml();

   ConfigArqNome := 'config.dbapp';
   ConfigArqPath := TPath.Combine(ExtrairDiretorio(ParamStr(0)),ConfigArqNome);
   if (FileExists(ConfigArqPath)) then
   begin
      try
         ConfigStr := TFile.ReadAllText(ConfigArqPath);
      except
      end;
   end;

   ConfigDoc := TXMLDocument.Create(nil);
   ConfigDoc.LoadFromXML(ConfigStr);

   NodeProjetos := ConfigDoc.DocumentElement.ChildNodes.FindNode('projetos');
   if (NodeProjetos <> nil) then
   begin
      FDiretorioDeProjetos := NodeProjetos.Text;
   end;
end;

procedure TDBAppConfigArq.DefDiretorio(const Value: string);
begin
   FDiretorioDeProjetos := Value;
end;

end.
