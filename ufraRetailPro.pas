unit ufraRetailPro;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Buttons, ActnList, StdActns,
  //RDi units
  uRDIConfigMgr, uRDIRPro8Settings, uRDISpringLogger;

type
  TfraRetailPro = class(TFrame)
    {$REGION 'Visual Components'}
    grpRProPath: TGroupBox;
    lblRProPath: TLabel;
    lblRProPathInstructions: TLabel;
    btnPRroPath: TSpeedButton;
    edtRProPath: TEdit;
    grpRProLicensing: TGroupBox;
    lblWSNum: TLabel;
    lblLicensingInstructions: TLabel;
    edtWSNum: TEdit;
    udWSNum: TUpDown;
    ActionList: TActionList;
    actBrowseRProPath: TBrowseForFolder;
    Label1: TLabel;
    {$ENDREGION}
    procedure actBrowseRProPathAccept(Sender: TObject);
    procedure actBrowseRProPathBeforeExecute(Sender: TObject);
    procedure edtWSNumExit(Sender: TObject);
  private
    FConfigMgr: TRDIConfigManager;
    FSettings: TRpro8Settings;
    FLogger: TRDISpringLogger;
    FSection: string;

    procedure FillGUI;
  public
    procedure Load(const ASection: string);
    procedure Save;
  end;

implementation

uses
  {$IFDEF UseCodeSite} CodeSiteLogging, {$ENDIF}
  Spring.Container;

{$R *.dfm}

procedure TfraRetailPro.actBrowseRProPathAccept(Sender: TObject);
begin
  edtRProPath.Text := actBrowseRProPath.Folder;
end;

procedure TfraRetailPro.actBrowseRProPathBeforeExecute(Sender: TObject);
begin
  if Length(edtRProPath.Text) > 0 then
    actBrowseRProPath.Folder := edtRProPath.Text;
end;

procedure TfraRetailPro.edtWSNumExit(Sender: TObject);
begin
  If edtWSNum.Text = '0' then begin
    ShowMessage('Workstation Number cannot be zero.');
    edtWSNum.SetFocus;
  end;
end;

procedure TfraRetailPro.FillGUI;
begin
  edtRProPath.Text := FSettings.DBPath;
  udWSNum.Position := FSettings.WSNum;
end;

procedure TfraRetailPro.Load(const ASection: string);
begin
  {$IFDEF UseCodeSite}CodeSite.EnterMethod( Self, 'Load' );{$ENDIF}

  FSection := ASection;

  FConfigMgr := GlobalContainer.Resolve<TRDIConfigManager>;
  FLogger := GlobalContainer.Resolve<TRDISpringLogger>;

  if not Assigned(FSettings) then
    FSettings := FConfigMgr.Items[FConfigMgr.GetIndexBySection(FSection)] as TRpro8Settings;

  FillGUI;

  {$IFDEF UseCodeSite} CodeSite.Send(Format('Loading Section "%s"', [FSection]), FSettings); {$ENDIF}

  {$IFDEF UseCodeSite}CodeSite.ExitMethod( Self, 'Load' );{$ENDIF}
end;

procedure TfraRetailPro.Save;
begin
  {$IFDEF UseCodeSite}CodeSite.EnterMethod( Self, 'Save' );{$ENDIF}

  FSettings.DBPath := edtRProPath.Text;
  FSettings.WSNum := udWSNum.Position;

  {$IFDEF UseCodeSite} CodeSite.Send(Format('Saving Section "%s"', [FSection]), FSettings); {$ENDIF}

  {$IFDEF UseCodeSite}CodeSite.ExitMethod( Self, 'Save' );{$ENDIF}
end;

end.

