object FormConfig: TFormConfig
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Configura'#231#227'o'
  ClientHeight = 360
  ClientWidth = 594
  Color = clBtnFace
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
  object PageControl1: TPageControl
    Left = 24
    Top = 24
    Width = 545
    Height = 273
    ActivePage = TabSheet1
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'TabGeral'
      object Label1: TLabel
        Left = 15
        Top = 15
        Width = 132
        Height = 18
        Caption = 'Diret'#243'rio de Projetos'
      end
      object EditDiretorio: TEdit
        Left = 15
        Top = 39
        Width = 505
        Height = 26
        TabOrder = 0
        OnKeyUp = EditDiretorioKeyUp
      end
    end
  end
  object PanelStatus: TPanel
    Left = 24
    Top = 309
    Width = 541
    Height = 35
    BevelOuter = bvNone
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 1
    OnClick = PanelStatusClick
  end
end
