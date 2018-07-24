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
    btnSaveConfig: TButton;
    fraRetailPro: TfraRetailPro;
    procedure btnSaveConfigClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    const
      CornALU = 'CORN1234';
    var
      FConfigMgr: TRDiConfigManager;
      FRProSettings: TRPro8Settings;
      FLogger: TRDiSpringLogger;
      FRProDB: TRDiRProDB;
      FRProItems: TRDiRProInvn;
    function  RandUDF1: string;
    function  RandUDF2: string;
    function  RandUDF3: string;
    function  RandUDF4: string;
    function  RandTaxCode: string;
    function  RandBool: Boolean;
    function  RandDate: TDate;
    function  RandPrice: Currency;
    function  RandStr(const Len: Integer): string;
    procedure ConnectToRPro;
    procedure DisconnectFromRPro;
    procedure AssignItemFields;
    procedure ImportItem;
    procedure ImportInventory;
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
  ImportInventory;
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

  Randomize;
end;

procedure TfrmMain.ImportInventory;
begin
  Screen.Cursor := crHourGlass;
  try
    ConnectToRPro;

    ImportItem;

    DisconnectFromRPro;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmMain.ImportItem;
var
  Added: Boolean;
begin
  FRProItems := TRDiRProInvn.Create;
  FRProItems.IndexID := FRProItems.Index_ALU;
  FRProItems.Open;

  if FRProItems.Search(CornALU, True) then begin
    FRProItems.RProTable.Document.EditMode := True;
    Added := False;
  end else begin
    FRProItems.NewRecord;
    Added := True;
  end;

  AssignItemFields;

  FRProItems.PostRecord;

  if Added then
    ShowMessage('Added Item ' + IntToStr(FRProItems.ItemNum))
  else
    ShowMessage('Updated Item ' + IntToStr(FRProItems.ItemNum));

  FRProItems.Close;
end;

function TfrmMain.RandBool: Boolean;
begin
  Result := Random(2) = 1;
end;

function TfrmMain.RandDate: TDate;
var
  Year, Month, Day: Word;
begin
  Year  := Random(1) + 2017;
  Month := Random(12) + 1;
  Day   := Random(28) + 1;

  Result := EncodeDate(Year, Month, Day);
end;

function TfrmMain.RandPrice: Currency;
begin
  Result := Random * 1000.0;
end;

function TfrmMain.RandStr(const Len: Integer): string;
var
  i: Integer;
begin
  Result := EmptyStr;
  for i := 1 to Len do
    Result := Result + Chr(Ord(Random(26) + 65));
end;

function TfrmMain.RandTaxCode: string;
const
  MaxTaxCodes = 3;
  TaxCodes: array[1..MaxTaxCodes] of string = ('Taxable', 'Exempt', 'Luxury');
begin
  Result := TaxCodes[Random(MaxTaxCodes) + 1];
end;

function TfrmMain.RandUDF1: string;
const
  MaxUDF1Vals = 3;
  UDF1Vals: array[1..MaxUDF1Vals] of string = ('abc', 'def', 'ghi');
begin
  Result := UDF1Vals[Random(MaxUDF1Vals) + 1];
end;

function TfrmMain.RandUDF2: string;
const
  MaxUDF2Vals = 3;
  UDF2Vals: array[1..MaxUDF2Vals] of string = ('zyx', 'wvu', 'tsr');
begin
  Result := UDF2Vals[Random(MaxUDF2Vals) + 1];
end;

function TfrmMain.RandUDF3: string;
const
  MaxUDF3Vals = 3;
  UDF3Vals: array[1..MaxUDF3Vals] of string = ('111', '222', '333');
begin
  Result := UDF3Vals[Random(MaxUDF3Vals) + 1];
end;

function TfrmMain.RandUDF4: string;
const
  MaxUDF4Vals = 6;
  UDF4Vals: array[1..MaxUDF4Vals] of string = ('white', 'brown', 'blue', 'yellow', 'green', 'black');
begin
  Result := UDF4Vals[Random(MaxUDF4Vals) + 1];
end;

procedure TfrmMain.AssignItemFields;
begin
  FRProItems.DCS               := 'TEST';
  FRProItems.ClassCode         := RandStr(3);
  FRProItems.DeptCode          := RandStr(3);
  FRProItems.DeptName          := RandStr(10);
  FRProItems.SubClassCode      := RandStr(3);
  FRProItems.VendCode          := 'CORN';
  FRProItems.Description1      := 'Description1';
  FRProItems.Description2      := 'Description2';
  FRProItems.Description3      := 'Description3';
  FRProItems.Description4      := 'Description4';
  FRProItems.UDFName           := 'UDF Name';
  FRProItems.Attribute         := 'attrib';
  FRProItems.Size              := 'size';
  FRProItems.UPC               := 'upc number';
  FRProItems.ALU               := CornALU;
  FRProItems.UDF1              := RandUDF1;
  FRProItems.UDF2              := RandUDF2;
  FRProItems.UDF3              := RandUDF3;
  FRProItems.UDF4              := RandUDF4;
  FRProItems.CommissionCode    := Random(1000);
  FRProItems.SPIF              := Random * 100.0;
  FRProItems.TaxCode           := RandTaxCode;
  FRProItems.InvnFlag          := 'UNORDERABLE';
  FRProItems.EDIStatus         := 'EDI';
  FRProItems.PlanPrice         := RandBool;
//  FRProItems.LastReceivedDate  := RandDate;
//  FRProItems.LastSoldDate      := RandDate;
//  FRProItems.FirstReceivedDate := RandDate;
  FRProItems.LastMarkDownDate  := RandDate;
  FRProItems.DiscontinueDate   := RandDate;
  FRProItems.Price[0]          := RandPrice;
  FRProItems.Price[1]          := RandPrice;
  FRProItems.PriceWithTax[0]   := RandPrice;
  FRProItems.PriceWithTax[1]   := RandPrice;
  FRProItems.Cost              := RandPrice;
  FRProItems.MarginAmt         := Random * 10.0;
  FRProItems.MarginPct         := Random(50);
  FRProItems.Coefficient       := Random * 100.0;
  FRProItems.TaxPercent        := Random * 100.0;
  FRProItems.TaxAmount         := Random * 100.0;
  FRProItems.LastCost          := Random * 100.0;
  FRProItems.FormerPrice       := RandPrice;
  FRProItems.UnitsPerCase      := Random(20);
  FRProItems.PrintTags         := RandBool;
  FRProItems.MarkUpPercent     := Random * 100.0;
  FRProItems.CompanyQtyOnHand  := Random
end;

end.
