object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'RPro Tester'
  ClientHeight = 414
  ClientWidth = 720
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 8
    Top = 266
    Width = 106
    Height = 41
    Caption = 'Import Items'
    TabOrder = 0
    OnClick = Button1Click
  end
  inline fraRetailPro: TfraRetailPro
    Left = 8
    Top = 8
    Width = 499
    Height = 215
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    ExplicitLeft = 8
    ExplicitTop = 8
  end
  object btnSaveConfig: TButton
    Left = 8
    Top = 219
    Width = 121
    Height = 41
    Caption = 'Save Configuration'
    TabOrder = 2
    OnClick = btnSaveConfigClick
  end
end
