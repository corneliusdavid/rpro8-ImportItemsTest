unit ufrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  uRDIConfigMgr, uRDIRPro8Settings, uRDISpringLogger,
  uRDISpringRProDB, uRDISpringRProInventory, ufraRetailPro;

type
  TfrmMain = class(TForm)
    Button1: TButton;
    fraRetailPro: TfraRetailPro;
    btnSaveConfig: TButton;
    procedure btnSaveConfigClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    FConfigMgr: TRDiConfigManager;
    FRProSettings: TRPro8Settings;
    FLogger: TRDiSpringLogger;
    FRProDB: TRDiRProDB;
    FRProItems: TRDiRProInvn;
    procedure ConnectToRPro;
    procedure DisconnectFromRPro;
    procedure ImportTestItems;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses
  Spring.Container,
  uProjectConstants;

procedure TfrmMain.btnSaveConfigClick(Sender: TObject);
begin
  // save stuff on the frame to the config object
  fraRetailPro.Save;

  // save the config object to the hard disk
  FConfigMgr.Save;
end;

procedure TfrmMain.Button1Click(Sender: TObject);
begin
  ImportTestItems;
end;

procedure TfrmMain.ConnectToRPro;
begin
  FRProDB.DBPath := FRProSettings.DBPath;
  FRProDB.WSNum := FRProSettings.WSNum;
  FRProDB.Connect;
end;

procedure TfrmMain.DisconnectFromRPro;
begin
  FRProDB.Disconnect;
end;

procedure TfrmMain.FormActivate(Sender: TObject);
begin
  FLogger := GlobalContainer.Resolve<TRDiSpringLogger>;
  FConfigMgr := GlobalContainer.Resolve<TRDiConfigManager>;
  FRProDB := GlobalContainer.Resolve<TRDiRProDB>;

  FConfigMgr.Read;
  fraRetailPro.Load(INIKey_RetailPro);

  FRProSettings := FConfigMgr.Items[FConfigMgr.GetIndexBySection(INIKey_RetailPro)] as TRpro8Settings;
end;

procedure TfrmMain.ImportTestItems;
begin
  Screen.Cursor := crHourGlass;
  try
    ConnectToRPro;

    DisconnectFromRPro;
  finally
    Screen.Cursor := crDefault;
  end;
end;

end.
