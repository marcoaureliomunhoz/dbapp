unit DBAppConfigArq;

interface

uses
   Winapi.Windows, System.SysUtils, System.Variants, System.Classes;

type
   TDBAppConfigArq = class
      private
         function LerDiretorio: string;
         procedure SalvarDiretorio(const Value: string);
      public
         property DiretorioDeProjetos : string read LerDiretorio write SalvarDiretorio;
   end;

implementation

function TDBAppConfigArq.LerDiretorio: string;
begin
   result := ExtractFileDir(ParamStr(0));
end;

procedure TDBAppConfigArq.SalvarDiretorio(const Value: string);
begin
end;

end.
