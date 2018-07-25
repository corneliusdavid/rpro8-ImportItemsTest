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
    cbContinuous: TCheckBox;
    btnStop: TButton;
    procedure btnSaveConfigClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
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
    function  RandScale: string;
    function  RandAux1: string;
    function  RandAux2: string;
    function  RandAux3: string;
    function  RandAux4: string;
    function  RandAux5: string;
    function  RandAux6: string;
    function  RandAux7: string;
    function  RandAux8: string;
    function  RandUPC: string;
    function  RandFCType: string;
    function  RandSerialItemFlag: string;
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
  {$IFDEF UseCodeSite} CodeSiteLogging, {$ENDIF}
  Spring.Container,
  uProjectConstants;

procedure TfrmMain.btnSaveConfigClick(Sender: TObject);
begin
  // save stuff on the frame to the config object
  fraRetailPro.Save;

  // save the config object to the hard disk
  FConfigMgr.Save;
end;

procedure TfrmMain.btnStopClick(Sender: TObject);
begin
  {$IFDEF UseCodeSite}CodeSite.EnterMethod( Self, 'btnStopClick' );{$ENDIF}

  cbContinuous.Checked := False;

  {$IFDEF UseCodeSite}CodeSite.ExitMethod( Self, 'btnStopClick' );{$ENDIF}
end;

procedure TfrmMain.Button1Click(Sender: TObject);
begin
  ImportInventory;
end;

procedure TfrmMain.ConnectToRPro;
begin
  {$IFDEF UseCodeSite}CodeSite.EnterMethod( Self, 'ConnectToRPro' );{$ENDIF}

  FRProDB.DBPath := FRProSettings.DBPath;
  FRProDB.WSNum := FRProSettings.WSNum;
  FRProDB.Connect;

  {$IFDEF UseCodeSite}CodeSite.ExitMethod( Self, 'ConnectToRPro' );{$ENDIF}
end;

procedure TfrmMain.DisconnectFromRPro;
begin
  {$IFDEF UseCodeSite}CodeSite.EnterMethod( Self, 'DisconnectFromRPro' );{$ENDIF}

  FRProDB.Disconnect;

  {$IFDEF UseCodeSite}CodeSite.ExitMethod( Self, 'DisconnectFromRPro' );{$ENDIF}
end;

procedure TfrmMain.FormActivate(Sender: TObject);
begin
  {$IFDEF UseCodeSite}CodeSite.EnterMethod( Self, 'FormActivate' );{$ENDIF}

  FLogger := GlobalContainer.Resolve<TRDiSpringLogger>;
  FConfigMgr := GlobalContainer.Resolve<TRDiConfigManager>;
  FRProDB := GlobalContainer.Resolve<TRDiRProDB>;

  FConfigMgr.Read;
  fraRetailPro.Load(INIKey_RetailPro);

  FRProSettings := FConfigMgr.Items[FConfigMgr.GetIndexBySection(INIKey_RetailPro)] as TRpro8Settings;

  Randomize;

  {$IFDEF UseCodeSite}CodeSite.ExitMethod( Self, 'FormActivate' );{$ENDIF}
end;

procedure TfrmMain.ImportInventory;
var
  i: Integer;
begin
  {$IFDEF UseCodeSite}CodeSite.EnterMethod( Self, 'ImportInventory' );{$ENDIF}

  Screen.Cursor := crHourGlass;
  try
    ConnectToRPro;

    if cbContinuous.Checked then begin
      btnStop.Visible := True;
      while cbContinuous.Checked do begin
        ImportItem;

        // pause for 2 seconds (2 * 10 * 100 milliseconds), watching for the Stob button
        for i := 1 to 20 do begin
          Application.ProcessMessages;
          Sleep(100);
          if not cbContinuous.Checked then
            Break;
        end;
      end;

      btnStop.Visible := False;
    end else
      ImportItem;

    DisconnectFromRPro;
  finally
    Screen.Cursor := crDefault;
  end;

  {$IFDEF UseCodeSite}CodeSite.ExitMethod( Self, 'ImportInventory' );{$ENDIF}
end;

procedure TfrmMain.ImportItem;
var
  Added: Boolean;
begin
  {$IFDEF UseCodeSite}CodeSite.EnterMethod( Self, 'ImportItem' );{$ENDIF}

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

  if not cbContinuous.Checked then
    if Added then
      ShowMessage('Added Item ' + IntToStr(FRProItems.ItemNum))
    else
      ShowMessage('Updated Item ' + IntToStr(FRProItems.ItemNum));

  FRProItems.Close;

  {$IFDEF UseCodeSite}CodeSite.ExitMethod( Self, 'ImportItem' );{$ENDIF}
end;

function TfrmMain.RandAux1: string;
const
  MaxAuxVals = 10;
  AuxVals: array[1..MaxAuxVals] of string = ('00', '01', '02', '03', '04', '05', '06', '07', '08', '09');
begin
  Result := AuxVals[Random(MaxAuxVals) + 1];
end;

function TfrmMain.RandAux2: string;
const
  MaxAuxVals = 10;
  AuxVals: array[1..MaxAuxVals] of string = ('00', '01', '02', '03', '04', '05', '06', '07', '08', '09');
begin
  Result := AuxVals[Random(MaxAuxVals) + 1];
end;

function TfrmMain.RandAux3: string;
const
  MaxAuxVals = 10;
  AuxVals: array[1..MaxAuxVals] of string = ('00', '01', '02', '03', '04', '05', '06', '07', '08', '09');
begin
  Result := AuxVals[Random(MaxAuxVals) + 1];
end;

function TfrmMain.RandAux4: string;
const
  MaxAuxVals = 9;
  AuxVals: array[1..MaxAuxVals] of string = ('0000', '0002', '0010', '0011', '0013', '0020', '0027', '0030', '0040');
begin
  Result := AuxVals[Random(MaxAuxVals) + 1];
end;

function TfrmMain.RandAux5: string;
const
  MaxAuxVals = 9;
  AuxVals: array[1..MaxAuxVals] of string = ('BEA1084', 'BEA1085', 'BEA178', 'BEA179', 'BEA180', 'BEA181', 'BEA182', 'BEC101', 'BEC1010');
begin
  Result := AuxVals[Random(MaxAuxVals) + 1];
end;

function TfrmMain.RandAux6: string;
const
  MaxAuxVals = 10;
  AuxVals: array[1..MaxAuxVals] of string = ('01', '02', '03', '04', '05', '06', '07', '08', '09', '10');
begin
  Result := AuxVals[Random(MaxAuxVals) + 1];
end;

function TfrmMain.RandAux7: string;
const
  MaxAuxVals = 9;
  AuxVals: array[1..MaxAuxVals] of string = ('AMERICADE 2012', 'AMERICADE 2013', 'AMERICADE 2014', 'ARIZONA 2013', 'BIKETOBERFEST 2012', 'BIKETOBERFEST 2013', 'BIKETOBERFEST 2014', 'BLUE RIDGE 2012', 'BLUE RIDGE 2013');
begin
  Result := AuxVals[Random(MaxAuxVals) + 1];
end;

function TfrmMain.RandAux8: string;
const
  MaxAuxVals = 6;
  AuxVals: array[1..MaxAuxVals] of string = ('BOTH', 'REMOVED', 'RETAIL', 'SOLD', 'WHOLESALE', 'YES');
begin
  Result := AuxVals[Random(MaxAuxVals) + 1];
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

function TfrmMain.RandFCType: string;
const
  MaxFCTypes = 3;
  FCTypes: array[1..MaxFCTypes] of string = ('DOLLARS', 'Pesos', 'Euros');
begin
  Result := FCTypes[Random(MaxFCTypes) + 1];
end;

function TfrmMain.RandPrice: Currency;
begin
  Result := Random * 1000.0;
end;

function TfrmMain.RandScale: string;
const
  MaxScales = 2;
  Scales: array[1..MaxScales] of string = ('Main', 'Secondary');
begin
  Result := Scales[Random(MaxScales) + 1];
end;

function TfrmMain.RandSerialItemFlag: string;
const
  MaxFlags = 3;
  SNFlags: array[1..MaxFlags] of string = ('', 'Partial', 'Full');
begin
  Result := SNFlags[Random(MaxFlags) + 1];
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

function TfrmMain.RandUPC: string;
var
  i: Integer;
begin
  Result := EmptyStr;
  for i := 1 to 12 do
    Result := Result + Chr(Ord(Random(10) + 48));
end;

procedure TfrmMain.AssignItemFields;
begin
  FRProItems.DCS                := 'TEST';
  FRProItems.ClassCode          := RandStr(3);
  FRProItems.DeptCode           := RandStr(3);
  FRProItems.DeptName           := RandStr(10);
  FRProItems.ClassCode          := RandStr(6);
  FRProItems.SubClassCode       := RandStr(3);
  FRProItems.VendCode           := 'CORN';
  FRProItems.Description1       := RandStr(30);
  FRProItems.Description2       := RandStr(30);
  FRProItems.Description3       := RandStr(30);
  FRProItems.Description4       := RandStr(30);
  FRProItems.Attribute          := RandStr(6);
  FRProItems.Size               := RandStr(6);
  FRProItems.UPC                := RandUPC;
  FRProItems.ALU                := CornALU;
  FRProItems.UDF1               := RandUDF1;
  FRProItems.UDF2               := RandUDF2;
  FRProItems.UDF3               := RandUDF3;
  FRProItems.UDF4               := RandUDF4;
  FRProItems.UDFName            := 'UDF Name';
  FRProItems.UDFDate            := RandDate;
  FRProItems.CommissionCode     := Random(1000);
  FRProItems.SPIF               := Random * 100.0;
  FRProItems.TaxCode            := RandTaxCode;
  FRProItems.InvnFlag           := 'UNORDERABLE';
  FRProItems.EDIStatus          := 'EDI';
  FRProItems.PlanPrice          := RandBool;
  FRProItems.LastReceivedDate  := RandDate;
  FRProItems.LastSoldDate      := RandDate;
  FRProItems.FirstReceivedDate := RandDate;
  FRProItems.LastMarkDownDate   := RandDate;
  FRProItems.DiscontinueDate    := RandDate;
  FRProItems.Price[0]           := RandPrice;
  FRProItems.Price[1]           := RandPrice;
  FRProItems.PriceWithTax[0]    := RandPrice;
  FRProItems.PriceWithTax[1]    := RandPrice;
  FRProItems.Cost               := RandPrice;
  FRProItems.MarginAmt          := Random * 10.0;
  FRProItems.MarginPct          := Random(50);
  FRProItems.Coefficient        := Random * 100.0;
  FRProItems.TaxPercent         := Random * 100.0;
  FRProItems.TaxAmount          := Random * 100.0;
  FRProItems.LastCost           := Random * 100.0;
  FRProItems.FormerPrice        := RandPrice;
  FRProItems.UnitsPerCase       := Random(20);
  FRProItems.PrintTags          := RandBool;
  FRProItems.MarkUpPercent      := Random(100);
  FRProItems.CompanyQtyOnHand   := Random * 100.0;
  FRProItems.CompanyQtyOnOrder  := Random * 100.0;
  FRProItems.CompanyQtyReceived := Random * 100.0;
  FRProItems.CompanyQtySold     := Random * 100.0;
  FRProItems.StoreQtySold[0]    := Random * 100.0;
  FRProItems.StoreQtyOnHand[0]  := Random * 100.0;
  FRProItems.StoreQtyOnOrder[0] := Random * 100.0;
  FRProItems.StoreQtyReceived[0]:= Random * 100.0;
  FRProItems.StoreMin[0]        := Random * 100.0;
  FRProItems.StoreMax[0]        := Random * 100.0;
  FRProItems.InTransIn[0]       := Random * 100.0;
  FRProItems.InTransOut[0]      := Random * 100.0;
  FRProItems.StyleImage         := 'Style Image';
  FRProItems.ItemImage          := 'Item Image';
  FRProItems.ItemScale          := RandScale;
  FRProItems.PromoPriceNo       := Random(100);
  FRProItems.CompanyMinimum     := Random * 100.0;
  FRProItems.CompanyMaximum     := Random * 100.0;
  FRProItems.Aux1               := RandAux1;
  FRProItems.Aux2               := RandAux2;
  FRProItems.Aux3               := RandAux3;
  FRProItems.Aux4               := RandAux4;
  FRProItems.Aux5               := RandAux5;
  FRProItems.Aux6               := RandAux6;
  FRProItems.Aux7               := RandAux7;
  FRProItems.Aux8               := RandAux8;
  FRProItems.SerialItemFlag     := RandSerialItemFlag;
  FRProItems.ForeignOrderCost   := Random * 100.0;
  FRProItems.MaxDiscPct1        := Random * 100.0;
  FRProItems.MaxDiscPct2        := Random * 100.0;
  FRProItems.VendorListCost     := Random * 100.0;
  FRProItems.TradeDiscPct       := Random * 100.0;
  FRProItems.CostCode           := RandStr(4);
  FRProItems.LastRcvdCode       := RandStr(4);
  FRProItems.NonInventory       := RandBool;
  FRProItems.Committed          := RandBool;
//  FRProItems.LastModified       := RandDate;
  FRProItems.SaleDiscPct        := Random * 100.0;
  FRProItems.SaleDiscAmt        := Random * 100.0;
  FRProItems.TotalTaxAmt        := Random * 100.0;
  FRProItems.Tax2Pct            := Random * 100.0;
  FRProItems.Tax2Amt            := Random * 100.0;
  FRProItems.Tax2Code           := RandStr(4);
  FRProItems.Tax1Code           := RandStr(4);
  FRProItems.LotItemFlag        := RandStr(4);
  FRProItems.SerialNumber       := RandStr(10);
//  FRProItems.LotNumCreateDate   := RandDate;
  FRProItems.LotNumExpDate      := RandDate;
//  FRProItems.LotNumModifiedDate := RandDate;
  FRProItems.LotNumber          := RandStr(4);
  FRProItems.AltUPC1            := RandUPC;
  FRProItems.AltUPC2            := RandUPC;
  FRProItems.AltUPC3            := RandUPC;
  FRProItems.AltUPC4            := RandUPC;
  FRProItems.AltUPC5            := RandUPC;
  FRProItems.AltUPC6            := RandUPC;
  FRProItems.AltALU1            := RandStr(10);
  FRProItems.AltALU2            := RandStr(10);
  FRProItems.AltALU3            := RandStr(10);
  FRProItems.AltALU4            := RandStr(10);
  FRProItems.AltALU5            := RandStr(10);
  FRProItems.AltALU6            := RandStr(10);
  FRProItems.ForeignOrderCostType := RandFCType;
  FRProItems.FirstPrice         := Random * 100.0;
  FRProItems.FirstPriceWithTax  := Random * 100.0;
end;

end.

