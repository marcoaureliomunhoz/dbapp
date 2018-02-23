unit DBAppProblemas;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids, Datasnap.DBClient;

type
  TFormProblemas = class(TForm)
    DBGridProblemas: TDBGrid;
    DataSourceProblemas: TDataSource;
    DataSetProblemas: TClientDataSet;
    DataSetProblemasProblema: TStringField;
  private
    { Private declarations }
  public
    procedure DefProblemas(Problemas : TStringList);
  end;

var
  FormProblemas: TFormProblemas;

implementation

{$R *.dfm}

procedure TFormProblemas.DefProblemas(Problemas : TStringList);
var
   i : Integer;
begin
   DataSetProblemas.CreateDataSet;
   DataSetProblemas.Open;

   for i := 0 to Problemas.Count-1 do
   begin
      DataSetProblemas.Append;
      DataSetProblemas['Problema'] := Problemas[i];
      DataSetProblemas.Post;
   end;
end;

end.
