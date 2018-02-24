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
      FTamanho : String;
      FPK : Boolean;
      FIdentidade : Boolean;
      FObrigatorio : Boolean;
      FListaProblemas : TStringList;
   public
      constructor Create(Id: Integer; Nome, Tipo: String; Tamanho: String; Obrigatorio, PK, Identidade: Boolean);
      constructor CreateFrom(Coluna: TDBAppColuna);
      procedure DefId(Id: Integer);
      function DefTipo(Tipo, Tamanho: String): boolean;
      property Id : Integer read FId;
      property Nome : String read FNome;
      property Tipo : String read FTipo;
      property Tamanho : String read FTamanho;
      property PK : Boolean read FPK;
      property Identidade : Boolean read FIdentidade;
      property Obrigatorio : Boolean read FObrigatorio;
      property ListaProblemas : TStringList read FListaProblemas;
   end;

implementation

constructor TDBAppColuna.Create(Id: Integer; Nome, Tipo: String; Tamanho: String; Obrigatorio, PK, Identidade: Boolean);
var
   TamanhoEx : Extended;
begin
   FListaProblemas := TStringList.Create;

   if (Id < 0) then FListaProblemas.Add('O id informado é inválido.');
   if (Nome = '') then FListaProblemas.Add('O nome não foi informado.');
   if (Tipo = '') then FListaProblemas.Add('O tipo não foi informado.');
   TamanhoEx := 0;
   if (Tamanho <> '') then
   begin
      TryStrToFloat(Tamanho, TamanhoEx);
      if (TamanhoEx < 0) or (TamanhoEx > 999999) then FListaProblemas.Add('O tamanho informado é inválido.');
   end;
   if ((Tipo = 'char') or (Tipo = 'varchar')) and (TamanhoEx = 0) then FListaProblemas.Add('O tamanho não foi informado.');

   if (FListaProblemas.Count = 0) then
   begin
      FId := Id;
      FNome := Nome;
      FTipo := Tipo;
      FTamanho := '';
      if (TamanhoEx > 0) then FTamanho := Tamanho;
      FObrigatorio := Obrigatorio;
      FPK := PK;
      FIdentidade := Identidade;
   end;
end;

constructor TDBAppColuna.CreateFrom(Coluna: TDBAppColuna);
begin
   self.Create(
      Coluna.Id,
      Coluna.Nome,
      Coluna.Tipo,
      Coluna.Tamanho,
      Coluna.Obrigatorio,
      Coluna.PK,
      Coluna.Identidade
   );
end;

procedure TDBAppColuna.DefId(Id: Integer);
begin
   FId := Id;
end;

function TDBAppColuna.DefTipo(Tipo, Tamanho: String): boolean;
var
   TamanhoEx : Extended;
begin
   Result := false;

   if (Tipo = '') then FListaProblemas.Add('O tipo não foi informado.');
   TamanhoEx := 0;
   if (Tamanho <> '') then
   begin
      TryStrToFloat(Tamanho, TamanhoEx);
      if (TamanhoEx < 0) or (TamanhoEx > 999999) then FListaProblemas.Add('O tamanho informado é inválido.');
   end;
   if ((Tipo = 'char') or (Tipo = 'varchar')) and (TamanhoEx = 0) then FListaProblemas.Add('O tamanho não foi informado.');

   if (FListaProblemas.Count = 0) then
   begin
      FTipo := Tipo;
      FTamanho := '';
      if (TamanhoEx > 0) then FTamanho := Tamanho;
      Result := true;
   end;
end;

end.
