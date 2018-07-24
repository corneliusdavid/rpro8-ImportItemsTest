program RPro8ItemImport;

uses
  Vcl.Forms,
  ufrmMain in 'ufrmMain.pas' {Form1},
  ufraRetailPro in 'ufraRetailPro.pas' {fraRetailPro: TFrame},
  uProjectConstants in 'uProjectConstants.pas',
  udmSettings in 'udmSettings.pas' {dmSettings: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TdmSettings, dmSettings);
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
