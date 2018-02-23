unit DBAppConfig;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, DBAppConfigArq;

type
  TFormConfig = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label1: TLabel;
    EditDiretorio: TEdit;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    ConfigArq : TDBAppConfigArq;
  end;

var
  FormConfig: TFormConfig;

implementation

{$R *.dfm}

procedure TFormConfig.FormCreate(Sender: TObject);
begin
   ConfigArq := TDBAppConfigArq.Create;
   EditDiretorio.Text := ConfigArq.DiretorioDeProjetos;
end;

end.
