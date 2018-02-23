unit DBAppBaseArq;

interface

uses
   Winapi.Windows, System.SysUtils, System.Variants, System.Classes,
   IOUtils, XMLDoc, XMLIntf;

type
   TDBAppBaseArq = class
   public
      function ExtrairDiretorio(Arquivo: string): string;
      function CompletarDiretorio(Diretorio: string): string;
   end;

implementation

function TDBAppBaseArq.ExtrairDiretorio(Arquivo: string): string;
var
   Diretorio : string;
begin
   Result := Arquivo;
   Diretorio := ExtractFileDir(Arquivo);
   if (Diretorio<>'') then
   begin
      Result := CompletarDiretorio(Diretorio);
   end;
end;

function TDBAppBaseArq.CompletarDiretorio(Diretorio: string): string;
begin
   Result := Diretorio;
   if (Diretorio<>'') then
   begin
      if (Diretorio[Diretorio.Length]<>'\') then Result := Result + '\';
   end;
end;

end.
