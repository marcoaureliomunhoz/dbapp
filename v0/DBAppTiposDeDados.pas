unit DBAppTiposDeDados;

interface

uses
   Winapi.Windows, System.SysUtils, System.Variants, System.Classes;

type
   TDBAppTipoDadoRec = record
      Tipo : String;
      PermiteIdentidade : Boolean;
      PermiteDefinirTamanho : Boolean;
   end;

   TDBAppTiposDeDados = class
   private
      class procedure AdicionarTipo(Tipo: String; PermiteIdentidade, PermiteDefinirTamanho: Boolean; var Lista: TArray<TDBAppTipoDadoRec>);
   public
      class function RetLista: TArray<TDBAppTipoDadoRec>;
   end;

implementation

class procedure TDBAppTiposDeDados.AdicionarTipo(Tipo: String; PermiteIdentidade, PermiteDefinirTamanho: Boolean; var Lista: TArray<TDBAppTipoDadoRec>);
var
   TamLista : Integer;
begin
   TamLista := Length(Lista);
   SetLength(Lista, TamLista+1);
   Lista[TamLista].Tipo := Tipo;
   Lista[TamLista].PermiteIdentidade := PermiteIdentidade;
   Lista[TamLista].PermiteDefinirTamanho := PermiteDefinirTamanho;
end;

class function TDBAppTiposDeDados.RetLista: TArray<TDBAppTipoDadoRec>;
begin
   //                            Ident    Tam
   AdicionarTipo('varchar'    ,  false ,  true  ,  result);
   AdicionarTipo('char'       ,  false ,  true  ,  result);
   AdicionarTipo('int'        ,  true  ,  false ,  result);
   AdicionarTipo('decimal'    ,  true  ,  false ,  result);
   AdicionarTipo('numeric'    ,  true  ,  false ,  result);
   AdicionarTipo('datetime'   ,  false ,  false ,  result);
   AdicionarTipo('date'       ,  false ,  false ,  result);
end;

end.
