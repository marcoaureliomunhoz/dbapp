object FormAlterarTipoColuna: TFormAlterarTipoColuna
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Alterando Tipo da Coluna'
  ClientHeight = 263
  ClientWidth = 509
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 18
  object Label1: TLabel
    Left = 15
    Top = 15
    Width = 39
    Height = 18
    Caption = 'Nome'
  end
  object Label2: TLabel
    Left = 15
    Top = 74
    Width = 65
    Height = 18
    Caption = 'Tipo Atual'
  end
  object Label3: TLabel
    Left = 387
    Top = 74
    Width = 106
    Height = 18
    Caption = 'Tamanho Atual'
  end
  object Label4: TLabel
    Left = 15
    Top = 133
    Width = 67
    Height = 18
    Caption = 'Novo Tipo'
  end
  object Label5: TLabel
    Left = 387
    Top = 133
    Width = 108
    Height = 18
    Caption = 'Novo Tamanho'
  end
  object EditNome: TEdit
    Left = 15
    Top = 36
    Width = 478
    Height = 26
    Color = clWhite
    Enabled = False
    TabOrder = 3
  end
  object EditTamanhoAtual: TEdit
    Left = 387
    Top = 95
    Width = 106
    Height = 26
    Color = clWhite
    Enabled = False
    TabOrder = 5
  end
  object PanelOpcoes: TPanel
    Left = 0
    Top = 208
    Width = 509
    Height = 55
    Align = alBottom
    BevelOuter = bvNone
    Color = clSilver
    ParentBackground = False
    TabOrder = 2
    Visible = False
    ExplicitTop = 227
    ExplicitWidth = 510
    object BtnSalvar: TButton
      Left = 15
      Top = 10
      Width = 100
      Height = 35
      Caption = 'Salvar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = BtnSalvarClick
    end
  end
  object ComboBoxNovoTipo: TComboBox
    Left = 15
    Top = 154
    Width = 363
    Height = 26
    Style = csDropDownList
    TabOrder = 0
    OnChange = ComboBoxNovoTipoChange
  end
  object EditNovoTamanho: TEdit
    Left = 387
    Top = 154
    Width = 106
    Height = 26
    Enabled = False
    NumbersOnly = True
    TabOrder = 1
    OnKeyUp = EditNovoTamanhoKeyUp
  end
  object EditTipoAtual: TEdit
    Left = 15
    Top = 95
    Width = 363
    Height = 26
    Color = clWhite
    Enabled = False
    TabOrder = 4
  end
end
