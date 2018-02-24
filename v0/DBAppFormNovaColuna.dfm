object FormNovaColuna: TFormNovaColuna
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Nova Coluna'
  ClientHeight = 282
  ClientWidth = 510
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
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
    Width = 28
    Height = 18
    Caption = 'Tipo'
  end
  object Label3: TLabel
    Left = 393
    Top = 74
    Width = 63
    Height = 18
    Caption = 'Tamanho'
  end
  object EditNome: TEdit
    Left = 15
    Top = 36
    Width = 478
    Height = 26
    TabOrder = 0
    OnKeyUp = EditNomeKeyUp
  end
  object ComboBoxTipo: TComboBox
    Left = 15
    Top = 95
    Width = 369
    Height = 26
    Style = csDropDownList
    TabOrder = 1
    OnChange = ComboBoxTipoChange
  end
  object EditTamanho: TEdit
    Left = 393
    Top = 95
    Width = 100
    Height = 26
    Enabled = False
    NumbersOnly = True
    TabOrder = 2
  end
  object CheckBoxPodeNulo: TCheckBox
    Left = 15
    Top = 136
    Width = 150
    Height = 17
    Caption = 'Pode Nulo'
    TabOrder = 3
  end
  object CheckBoxPK: TCheckBox
    Left = 15
    Top = 164
    Width = 150
    Height = 17
    Caption = 'Chave Prim'#225'ria'
    TabOrder = 4
  end
  object CheckBoxID: TCheckBox
    Left = 15
    Top = 191
    Width = 150
    Height = 17
    Caption = 'Identidade'
    TabOrder = 5
  end
  object PanelOpcoesNovaTabela: TPanel
    Left = 0
    Top = 227
    Width = 510
    Height = 55
    Align = alBottom
    BevelOuter = bvNone
    Color = clSilver
    ParentBackground = False
    TabOrder = 6
    Visible = False
    object BtnSalvarNovaColuna: TButton
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
      OnClick = BtnSalvarNovaColunaClick
    end
  end
end
