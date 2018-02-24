object FormTabela: TFormTabela
  Left = 0
  Top = 0
  Caption = 'Tabela'
  ClientHeight = 600
  ClientWidth = 800
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 18
  object PageControlTabela: TPageControl
    Left = 0
    Top = 55
    Width = 800
    Height = 545
    ActivePage = TabColunas
    Align = alClient
    MultiLine = True
    TabOrder = 0
    object TabColunas: TTabSheet
      Caption = 'Colunas'
      object DBGridColunas: TDBGrid
        Left = 10
        Top = 55
        Width = 772
        Height = 447
        Align = alClient
        DataSource = DataSourceColunas
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
        PopupMenu = PopupMenuColunas
        ReadOnly = True
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -15
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        OnCellClick = DBGridColunasCellClick
        Columns = <
          item
            Expanded = False
            FieldName = 'Nome'
            Width = 350
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'Tipo'
            Title.Alignment = taCenter
            Width = 150
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'Tamanho'
            Title.Alignment = taCenter
            Width = 75
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'Obrigatorio'
            Title.Alignment = taCenter
            Title.Caption = 'Obrigat'#243'ria'
            Width = 80
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'Identidade'
            Title.Alignment = taCenter
            Title.Caption = 'ID'
            Width = 35
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'PK'
            Title.Alignment = taCenter
            Width = 35
            Visible = True
          end>
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 792
        Height = 55
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        object BtnNovaColuna: TButton
          Left = 10
          Top = 10
          Width = 100
          Height = 35
          Caption = '&Nova'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          OnClick = BtnNovaColunaClick
        end
      end
      object Panel2: TPanel
        Left = 0
        Top = 502
        Width = 792
        Height = 10
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 2
      end
      object Panel3: TPanel
        Left = 0
        Top = 55
        Width = 10
        Height = 447
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 3
      end
      object Panel4: TPanel
        Left = 782
        Top = 55
        Width = 10
        Height = 447
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 4
      end
    end
    object TabChaves: TTabSheet
      Caption = 'Chaves'
      ImageIndex = 1
    end
  end
  object PanelOpcoesNovaTabela: TPanel
    Left = 0
    Top = 0
    Width = 800
    Height = 55
    Align = alTop
    BevelOuter = bvNone
    Color = clSilver
    ParentBackground = False
    TabOrder = 1
    Visible = False
    object BtnSalvarNovaTabela: TButton
      Left = 14
      Top = 10
      Width = 100
      Height = 35
      Caption = '&Salvar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = BtnSalvarNovaTabelaClick
    end
  end
  object DataSourceColunas: TDataSource
    DataSet = DataSetColunas
    Left = 408
    Top = 296
  end
  object DataSetColunas: TClientDataSet
    Aggregates = <>
    Params = <>
    AfterScroll = DataSetColunasAfterScroll
    Left = 408
    Top = 352
    object DataSetColunasNome: TStringField
      FieldName = 'Nome'
      Size = 500
    end
    object DataSetColunasCadastro: TDateTimeField
      FieldName = 'Cadastro'
      DisplayFormat = 'dd/mm/yyyy hh:mm'
    end
    object DataSetColunasAlteracao: TDateTimeField
      FieldName = 'Alteracao'
      DisplayFormat = 'dd/mm/yyyy hh:mm'
    end
    object DataSetColunasId: TIntegerField
      FieldName = 'Id'
    end
    object DataSetColunasTipo: TStringField
      FieldName = 'Tipo'
      Size = 100
    end
    object DataSetColunasValorPadrao: TStringField
      FieldName = 'ValorPadrao'
      Size = 100
    end
    object DataSetColunasIdentidade: TStringField
      FieldName = 'Identidade'
      Size = 5
    end
    object DataSetColunasPK: TStringField
      FieldName = 'PK'
      Size = 5
    end
    object DataSetColunasFK: TStringField
      FieldName = 'FK'
      Size = 5
    end
    object DataSetColunasObrigatorio: TStringField
      FieldName = 'Obrigatorio'
      Size = 5
    end
    object DataSetColunasTamanho: TStringField
      FieldName = 'Tamanho'
    end
  end
  object PopupMenuColunas: TPopupMenu
    Left = 404
    Top = 412
    object MenuAlterarTipoColuna: TMenuItem
      Caption = 'Alterar Tipo'
      ShortCut = 16449
      OnClick = MenuAlterarTipoColunaClick
    end
    object MenuTornarColunaObrigatoria: TMenuItem
      Caption = 'Tornar Obrigat'#243'ria'
      ShortCut = 16463
    end
    object MenuTirarObrigatoriedade: TMenuItem
      Caption = 'Tirar Obrigatoriedade'
      ShortCut = 16462
    end
    object MenuTornarCampoIdentidade: TMenuItem
      Caption = 'Tornar Identidade'
      ShortCut = 16457
    end
  end
end
