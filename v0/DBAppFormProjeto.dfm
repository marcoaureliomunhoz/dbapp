object FormProjeto: TFormProjeto
  Left = 0
  Top = 0
  Caption = 'Projeto'
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
  PixelsPerInch = 96
  TextHeight = 18
  object PageControlProjeto: TPageControl
    Left = 0
    Top = 0
    Width = 800
    Height = 600
    ActivePage = TabTabelas
    Align = alClient
    MultiLine = True
    TabOrder = 0
    object TabTabelas: TTabSheet
      Caption = 'Tabelas'
      object DBGridTabelas: TDBGrid
        Left = 10
        Top = 55
        Width = 772
        Height = 502
        Align = alClient
        DataSource = DataSourceTabelas
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
        ReadOnly = True
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -15
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'Nome'
            Width = 425
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'Cadastro'
            Title.Alignment = taCenter
            Width = 150
            Visible = True
          end
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'Alteracao'
            Title.Alignment = taCenter
            Title.Caption = #218'ltima Altera'#231#227'o'
            Width = 150
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
        object BtnNovaTabela: TButton
          Left = 10
          Top = 10
          Width = 100
          Height = 35
          Caption = 'Nova'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          OnClick = BtnNovaTabelaClick
        end
      end
      object Panel2: TPanel
        Left = 0
        Top = 557
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
        Height = 502
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 3
      end
      object Panel4: TPanel
        Left = 782
        Top = 55
        Width = 10
        Height = 502
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 4
      end
    end
    object TabImplantacoes: TTabSheet
      Caption = 'Implanta'#231#245'es'
      ImageIndex = 1
    end
  end
  object DataSourceTabelas: TDataSource
    DataSet = DataSetTabelas
    Left = 408
    Top = 296
  end
  object DataSetTabelas: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 408
    Top = 352
    object DataSetTabelasNome: TStringField
      FieldName = 'Nome'
      Size = 500
    end
    object DataSetTabelasCadastro: TDateTimeField
      FieldName = 'Cadastro'
      DisplayFormat = 'dd/mm/yyyy hh:mm'
    end
    object DataSetTabelasAlteracao: TDateTimeField
      FieldName = 'Alteracao'
      DisplayFormat = 'dd/mm/yyyy hh:mm'
    end
    object DataSetTabelasId: TIntegerField
      FieldName = 'Id'
    end
  end
end
