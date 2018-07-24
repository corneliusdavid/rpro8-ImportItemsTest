object fraRetailPro: TfraRetailPro
  Left = 0
  Top = 0
  Width = 499
  Height = 215
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  object Label1: TLabel
    Left = 0
    Top = 95
    Width = 499
    Height = 16
    Align = alTop
    ExplicitWidth = 4
  end
  object grpRProPath: TGroupBox
    Left = 0
    Top = 0
    Width = 499
    Height = 95
    Margins.Left = 18
    Margins.Top = 9
    Margins.Right = 18
    Margins.Bottom = 9
    Align = alTop
    Caption = 'Location'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    DesignSize = (
      499
      95)
    object lblRProPath: TLabel
      Left = 9
      Top = 31
      Width = 97
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = '&Retail Pro Path:'
    end
    object lblRProPathInstructions: TLabel
      Left = 3
      Top = 56
      Width = 486
      Height = 17
      Alignment = taCenter
      Anchors = [akTop]
      AutoSize = False
      Caption = 
        'This must be the "rpro" sub-folder of your Retail Pro installati' +
        'on.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGrayText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object btnPRroPath: TSpeedButton
      Left = 460
      Top = 27
      Width = 23
      Height = 26
      Action = actBrowseRProPath
      Anchors = [akTop, akRight]
      Glyph.Data = {
        36040000424D3604000000000000360000002800000010000000100000000100
        2000000000000004000000000000000000000000000000000000FF00FF00008C
        BD00008CBD00008CBD00008CBD00008CBD00008CBD00008CBD00008CBD00008C
        BD00008CBD00008CBD00008CBD00008CBD00FF00FF00FF00FF00008CBD00189C
        AD005AC6EF0084E7FF0063CEF70063CEF70063CEF70063CEF70063CEF70063CE
        F70063CEF70063CEF70042BDD600008CBD00FF00FF00FF00FF00008CBD004ABD
        DE0042BDD6009CF7FF0073D6FF0073D6FF006BD6F70073D6FF0073D6FF0073D6
        FF0073D6FF006BD6F7004ABDDE0084DEFF00008CBD00FF00FF00008CBD0073D6
        FF00008CBD00ADF7FF007BDEFF007BDEFF007BDEFF007BDEFF007BDEFF007BDE
        FF007BDEFF007BDEFF004ABDDE00ADF7FF00008CBD00FF00FF00008CBD007BDE
        FF001094B5009CF7FF0094EFFF0084E7FF0084E7FF0084E7FF0084E7FF0084E7
        FF0084E7FF0084E7FF004ABDDE00B5F7FF00008CBD00FF00FF00008CBD0084E7
        FF004ABDDE005AC6E700ADF7FF008CEFFF008CEFFF008CEFFF008CEFFF008CEF
        FF008CEFFF00088418004ABDDE00B5F7FF0063CEF700008CBD00008CBD008CE7
        FF0073DEFF00189CAD00DEF7FF00CEF7FF00CEF7FF00CEF7FF00CEF7FF00CEF7
        FF000884180031BD730008841800DEF7FF00D6F7FF00008CBD00008CBD0094EF
        FF0094EFFF001094B500008CBD00008CBD00008CBD00008CBD00008CBD000884
        180042CE84004ACE9C0039C6730008841800008CBD00008CBD00008CBD009CF7
        FF009CF7FF009CF7FF009CF7FF009CF7FF009CF7FF009CF7FF000884180042CE
        84004ACE8C004ACE8C004ACE9C0039C6730008841800FF00FF00008CBD00DEF7
        FF00A5F7FF00A5F7FF00A5F7FF00A5F7FF00A5F7FF0008841800088418000884
        1800088418004ACE8C0042CE8400088418000884180008841800FF00FF00008C
        BD00DEF7FF00A5F7FF00A5F7FF00A5F7FF00008CBD004ABDDE004ABDDE004ABD
        DE000884180042CE840031BD730008841800FF00FF00FF00FF00FF00FF00FF00
        FF00008CBD00008CBD00008CBD00008CBD00FF00FF00FF00FF00FF00FF00FF00
        FF000884180039C67B0008841800FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF000884
        180031BD730031BD730008841800FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF000884
        180031BD730008841800FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0008841800088418000884
        180008841800FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF0008841800088418000884180008841800FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
    end
    object edtRProPath: TEdit
      Left = 112
      Top = 28
      Width = 348
      Height = 24
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
    end
  end
  object grpRProLicensing: TGroupBox
    Left = 0
    Top = 111
    Width = 499
    Height = 94
    Align = alTop
    Caption = 'Licensing'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    DesignSize = (
      499
      94)
    object lblWSNum: TLabel
      Left = 19
      Top = 32
      Width = 128
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = '&WorkStation Number:'
      FocusControl = edtWSNum
    end
    object lblLicensingInstructions: TLabel
      Left = 3
      Top = 59
      Width = 486
      Height = 17
      Alignment = taCenter
      Anchors = [akTop]
      AutoSize = False
      Caption = 
        'This must map to a licensed workstation number for your Retail P' +
        'ro installation.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGrayText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object edtWSNum: TEdit
      Left = 151
      Top = 29
      Width = 29
      Height = 24
      TabOrder = 0
      Text = '1'
      OnExit = edtWSNumExit
    end
    object udWSNum: TUpDown
      Left = 180
      Top = 29
      Width = 16
      Height = 24
      Associate = edtWSNum
      Min = 1
      Max = 999
      Position = 1
      TabOrder = 1
    end
  end
  object ActionList: TActionList
    Left = 432
    Top = 96
    object actBrowseRProPath: TBrowseForFolder
      Category = 'File'
      DialogCaption = 'Select Retail Pro'#39's RPRO path'
      BrowseOptions = [bifBrowseForComputer, bifEditBox, bifNewDialogStyle]
      ImageIndex = 4
      BeforeExecute = actBrowseRProPathBeforeExecute
      OnAccept = actBrowseRProPathAccept
    end
  end
end
