unit DBAppPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Imaging.jpeg, Vcl.Buttons, Vcl.StdCtrls,
  DBAppConfig;

type
  TFormPrincipal = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    ListboxProjetos: TListBox;
    BtnNovo: TButton;
    BtnConfig: TButton;
    procedure BtnConfigClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

{$R *.dfm}

procedure TFormPrincipal.BtnConfigClick(Sender: TObject);
begin
   Application.CreateForm(TFormConfig, FormConfig);
   FormConfig.ShowModal;
   FormConfig.Free;
end;

end.
