unit DBAppColuna;

interface

uses
   Winapi.Windows, System.SysUtils, System.Variants, System.Classes;

type
   TDBAppColuna = class
   private
      FId : Integer;
      FNome : String;
      FTipo : String;
      FTamanho : Integer;
      FPK : Boolean;
      FIdentidade : Boolean;
      FNulo : Boolean;
      FListaProblemas : TStringList;
   public
      constructor Create(Id: Integer; Nome, Tipo: String; Tamanho: Integer; Nulo, PK, Identidade: Boolean);
      property Id : Integer read FId;
      property Nome : String read FNome;
      property Tipo : String read FTipo;
      property Tamanho : Integer read FTamanho;
      property PK : Boolean read FPK;
      property Identidade : Boolean read FIdentidade;
      property Nulo : Boolean read FNulo;
      property ListaProblemas : TStringList read FListaProblemas;
   end;

implementation

constructor TDBAppColuna.Create(Id: Integer; Nome, Tipo: String; Tamanho: Integer; Nulo, PK, Identidade: Boolean);
begin
   FListaProblemas := TStringList.Create;

   if (Id < 0) then FListaProblemas.Add('O id informado é inválido.');
   if (Nome = '') then FListaProblemas.Add('O nome não foi informado.');
   if (Tipo = '') then FListaProblemas.Add('O tipo não foi informado.');
   if (Tamanho < 0) or (Tamanho > 999999) then FListaProblemas.Add('O tamanho informado é inválido.');
   if ((Tipo = 'char') or (Tipo = 'varchar')) and (Tamanho = 0) then FListaProblemas.Add('O tamanho não foi informado.');

   if (FListaProblemas.Count = 0) then
   begin
      FId := Id;
      FNome := Nome;
      FTipo := Tipo;
      FTamanho := Tamanho;
      FNulo := Nulo;
      FPK := PK;
      FIdentidade := Identidade;
   end;
end;

end.
