unit udmSettings;
(*
 * $Workfile: udmSettings.pas $
 * $Author: rgrove $
 * By: Retail Dimensions, Inc.
 * $Date: 2015-11-16 17:06:04-08:00 $
 * in: Delphi 2010
 * to: provide a GUI configuration dialog window
 *
 * Copyright 2015 Retail Dimensions, Inc.  All rights reserved.
 *)

interface

uses
  SysUtils, Classes, Dialogs,
  //RDi units
  uRDiConfigMgr, uRDiSpringLogger, uRDiLogSettings, uRDiRPro8Settings,
  uRDiSpringRProDB;

type
  TdmSettings = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
  strict private
    FConfigMgr: TRDIConfigManager;
    FLogSettings: TLogSettings;
    FSpringLogger: TRDISpringLogger;
    FRProSettings: TRpro8Settings;
    FRProDB: TRDiRProDB;

    procedure RegisterSections;
    procedure ConfigureSpringLogger;
  end;

var
  dmSettings: TdmSettings;

implementation


uses
  //Spring units
  Spring.Container
  {$IFDEF UseCodeSite}, CodeSiteLogging {$ENDIF}
  //RDi Units
  , uProjectConstants
  , uRDIDatabaseSettings
  , uRDIImportSettings
  , uRDIExportSettings
  , uRDIItemFilterSettings
  , uRDiCustomerImportSettings
  ;


{$R *.dfm}

procedure TdmSettings.ConfigureSpringLogger;
var
  idx: Integer;
  LLogBy: string;
begin
  LLogBy := EmptyStr;

  idx := FConfigMgr.GetIndexBySection(INIKey_Logging);
  FLogSettings := FConfigMgr[idx] as TLogSettings;

  {$IFDEF UseCodeSite} CodeSite.Send('TLogSettings', FLogSettings); {$ENDIF}

  if FLogSettings.Detailed then
    FSpringLogger.Detailed := True;

  LLogBy := UpperCase(Trim(FLogSettings.LogBy));
  if LLogBy = 'MONTH' then
    FSpringLogger.LogByMonth := True
  else if LLogBy = 'DAY' then
    FSpringLogger.LogByDay := True
  else
    FSpringLogger.LogByMonth := True;

  FSpringLogger.Overwrite := FLogSettings.Overwrite;
  FSpringLogger.TimeStamp := FLogSettings.TimeStamp;
  FSpringLogger.CustomLogFolder := FLogSettings.CustomLogFolder;
end;

procedure TdmSettings.DataModuleCreate(Sender: TObject);
begin
  {$IFDEF UseCodeSite}CodeSite.EnterMethod( Self, 'DataModuleCreate' );{$ENDIF}

  {$IFDEF UseFastMM} System.ReportMemoryLeaksOnShutdown := True; {$ENDIF}

  GlobalContainer.RegisterType<TRDiSpringLogger>.AsSingleton;
  GlobalContainer.RegisterType<TRDIConfigManager>.AsSingleton;

  //Build our Spring GlobalContainer
  GlobalContainer.Build;

  FConfigMgr := GlobalContainer.Resolve<TRDIConfigManager>;
  FSpringLogger := GlobalContainer.Resolve<TRDISpringLogger>;
  //FRProDB := GlobalContainer.Resolve<TRDiRProDB>;

  //Register the sections for this project
  RegisterSections;

  //Read in the ini file to fill our config objects
  FConfigMgr.Read;

  //Set whether we're in detailed logging or not
  ConfigureSpringLogger;

  {$IFDEF UseCodeSite}CodeSite.ExitMethod( Self, 'DataModuleCreate' );{$ENDIF}
end;

procedure TdmSettings.RegisterSections;
begin
  {$IFDEF UseCodeSite}CodeSite.EnterMethod( Self, 'RegisterSections' );{$ENDIF}

  // General Settings
  FConfigMgr.Add(TRpro8Settings.Create(INIKey_RetailPro));
  FConfigMgr.Add(TLogSettings.Create(INIKey_Logging));

  // inventory import settings
  //FConfigMgr.Add(TImportSettings.Create(INIKey_ItemImportSettings));

  // customer import settings
  //FConfigMgr.Add(TRDiCustomerImportSettings.Create(INIKey_CustomerImportSettings));
  //FConfigMgr.Add(TImportSettings.Create(INIKey_CustImportFileSettings));

  // receipt export settings
  //FConfigMgr.Add(TExportSettings.Create(INIKey_ReceiptExportFile));

  {$IFDEF UseCodeSite}CodeSite.ExitMethod( Self, 'RegisterSections' );{$ENDIF}
end;

end.

