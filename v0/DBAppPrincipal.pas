unit DBAppPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Imaging.jpeg, Vcl.Buttons, Vcl.StdCtrls,
  DBAppConfig, DBAppConfigArq, DBAppProjetosArq, Vcl.Menus;

type
  TFormPrincipal = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    ListboxProjetos: TListBox;
    BtnNovo: TButton;
    BtnConfig: TButton;
    PopupMenuProjetos: TPopupMenu;
    PopupMenuItemAlterarProjeto: TMenuItem;
    PopupMenuItemExcluirProjeto: TMenuItem;
    procedure BtnConfigClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnNovoClick(Sender: TObject);
    procedure PopupMenuItemAlterarProjetoClick(Sender: TObject);
    procedure ListboxProjetosMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure PopupMenuItemExcluirProjetoClick(Sender: TObject);
    procedure ListboxProjetosClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    ListaProjetos : TArray<TDBAppProjetoRec>;
    ConfigArq : TDBAppConfigArq;
    ProjetosArq : TDBAppProjetosArq;
  public
    procedure CarregarProjetos;
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

{$R *.dfm}

uses DBAppFormProjeto;

procedure TFormPrincipal.BtnNovoClick(Sender: TObject);
var
   Nome : string;
begin
   if InputQuery('DBApp','Informe o nome do projeto:',Nome) and (Nome <> '') then
   begin
      if (ProjetosArq.NovoProjeto(Nome)) then
      begin
         CarregarProjetos;
      end else
      begin
         Application.MessageBox(PWideChar(ProjetosArq.ListaProblemas[0]), 'Atenção', MB_OK+MB_ICONWARNING);
      end;
   end;
end;

procedure TFormPrincipal.CarregarProjetos;
var
   i : integer;
begin
   ListboxProjetos.Clear;
   if (ConfigArq <> nil) then ConfigArq.Destroy;
   ConfigArq := TDBAppConfigArq.Create;
   if (ProjetosArq <> nil) then ProjetosArq.Destroy;
   ProjetosArq := TDBAppProjetosArq.Create(ConfigArq.DiretorioDeProjetos);
   ListaProjetos := ProjetosArq.ListarProjetos;
   for i := 0 to length(ListaProjetos)-1 do
   begin
      ListboxProjetos.AddItem(ListaProjetos[i].Nome, nil);
   end;
end;

procedure TFormPrincipal.FormCreate(Sender: TObject);
begin
   CarregarProjetos;
end;

procedure TFormPrincipal.FormShow(Sender: TObject);
begin
   if (ListboxProjetos.Count>0) then
   begin
      ListboxProjetos.ItemIndex := 0;
      ListboxProjetos.Selected[0] := true;
      ListboxProjetos.SetFocus;
   end else
   begin
      BtnNovo.SetFocus;
   end;
end;

procedure TFormPrincipal.ListboxProjetosClick(Sender: TObject);
begin
   if (ListboxProjetos.Count > 0) and (ListboxProjetos.ItemIndex >= 0) then
   begin
      Application.CreateForm(TFormProjeto, FormProjeto);
      if FormProjeto.CarregarProjeto(ConfigArq.DiretorioDeProjetos, ListaProjetos[ListboxProjetos.ItemIndex].Nome) then
      begin
         Self.Left := Self.Left - 9999;
         FormProjeto.ShowModal;
         Self.Left := Self.Left + 9999;
      end else
      begin
         ShowMessage('Ops!');
      end;
      FormProjeto.Free;
   end;
end;

procedure TFormPrincipal.ListboxProjetosMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
   posi : integer;
begin
   if (Button = mbRight) then
   begin
       posi := ListboxProjetos.ItemAtPos(TPoint.Create(x,y),true);
       if (posi >= 0) then
       begin
          ListboxProjetos.Selected[posi] := true;
       end;
   end;
end;

procedure TFormPrincipal.PopupMenuItemAlterarProjetoClick(Sender: TObject);
var
   Nome, NomeAnt : string;
begin
   if (ListboxProjetos.Count>0) and (ListboxProjetos.ItemIndex>=0) then
   begin
      Nome := ListaProjetos[ListboxProjetos.ItemIndex].Nome;
      NomeAnt := Nome;
      if InputQuery('DBApp','Informe o nome do projeto:',Nome) and (Nome <> '') and (Nome <> NomeAnt) then
      begin
         if Application.MessageBox(PWideChar('Deseja realmente alterar o nome do projeto de "'+NomeAnt+'" para "'+Nome+'"?'), 'Atenção', MB_YESNO+MB_ICONQUESTION+MB_DEFBUTTON2)=ID_YES then
         begin
            if (ProjetosArq.AlterarProjeto(NomeAnt, Nome)) then
            begin
               CarregarProjetos;
            end else
            begin
               Application.MessageBox(PWideChar(ProjetosArq.ListaProblemas[0]), 'Atenção', MB_OK+MB_ICONWARNING);
            end;
         end;
      end;
   end;
end;

procedure TFormPrincipal.PopupMenuItemExcluirProjetoClick(Sender: TObject);
var
   Nome, NomeAnt : string;
begin
   if (ListboxProjetos.Count>0) and (ListboxProjetos.ItemIndex>=0) then
   begin
      Nome := ListaProjetos[ListboxProjetos.ItemIndex].Nome;
      if Application.MessageBox(PWideChar('Deseja realmente excluir o projeto "'+Nome+'"?'), 'Atenção', MB_YESNO+MB_ICONQUESTION+MB_DEFBUTTON2)=ID_YES then
      begin
         if (ProjetosArq.ExcluirProjeto(Nome)) then
         begin
            CarregarProjetos;
         end else
         begin
            Application.MessageBox(PWideChar(ProjetosArq.ListaProblemas[0]), 'Atenção', MB_OK+MB_ICONWARNING);
         end;
      end;
   end;
end;

procedure TFormPrincipal.BtnConfigClick(Sender: TObject);
begin
   Application.CreateForm(TFormConfig, FormConfig);
   FormConfig.ShowModal;
   FormConfig.Free;
   CarregarProjetos;
end;

end.
