object FormProblemas: TFormProblemas
  Left = 0
  Top = 0
  Caption = 'Problemas'
  ClientHeight = 500
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
  object DBGridProblemas: TDBGrid
    Left = 0
    Top = 0
    Width = 800
    Height = 500
    Align = alClient
    BorderStyle = bsNone
    DataSource = DataSourceProblemas
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
        FieldName = 'Problema'
        Width = 750
        Visible = True
      end>
  end
  object DataSourceProblemas: TDataSource
    DataSet = DataSetProblemas
    Left = 368
    Top = 224
  end
  object DataSetProblemas: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 488
    Top = 224
    object DataSetProblemasProblema: TStringField
      FieldName = 'Problema'
      Size = 9999
    end
  end
end
