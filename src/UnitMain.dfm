object FormMain: TFormMain
  Caption = 'Inventarverwaltung V2'
  Width = 700
  Height = 500
  object BtnLoad: TButton
    Left = 16
    Top = 16
    Caption = 'Laden'
    OnClick = BtnLoadClick
  end
  object BtnAdd: TButton
    Left = 120
    Top = 16
    Caption = 'Neu'
    OnClick = BtnAddClick
  end
  object BtnExport: TButton
    Left = 224
    Top = 16
    Caption = 'Export'
    OnClick = BtnExportClick
  end
  object ComboStatus: TComboBox
    Left = 350
    Top = 16
    Width = 150
    OnChange = ComboStatusChange
  end
  object Grid: TStringGrid
    Left = 16
    Top = 60
    Width = 650
    Height = 380
  end
end
