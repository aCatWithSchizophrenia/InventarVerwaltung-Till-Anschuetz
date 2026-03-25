unit UnitMain;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes,
  Vcl.Forms, Vcl.StdCtrls, Vcl.Controls, Vcl.Grids,
  Data.DB, FireDAC.Comp.Client;

type
  TFormMain = class(TForm)
    Grid: TStringGrid;
    BtnLoad: TButton;
    BtnAdd: TButton;
    BtnExport: TButton;
    ComboStatus: TComboBox;
    FDConnection1: TFDConnection;
    FDQuery1: TFDQuery;
    procedure FormCreate(Sender: TObject);
    procedure BtnLoadClick(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnExportClick(Sender: TObject);
    procedure ComboStatusChange(Sender: TObject);
  private
    procedure ConnectDB;
    procedure LoadInventory(filter: string = '');
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

procedure TFormMain.ConnectDB;
begin
  FDConnection1.Params.DriverID := 'SQLite';
  FDConnection1.Params.Database := 'inventar.db';
  FDConnection1.Connected := True;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  ConnectDB;

  ComboStatus.Items.Add('');
  ComboStatus.Items.Add('Projektiert');
  ComboStatus.Items.Add('Bestellt');
  ComboStatus.Items.Add('Geliefert');
  ComboStatus.Items.Add('Eingesetzt');
  ComboStatus.Items.Add('Ausgeliehen');
  ComboStatus.Items.Add('Reparatur');
  ComboStatus.Items.Add('Ausgemustert');

  Grid.ColCount := 3;
  Grid.Cells[0,0] := 'ID';
  Grid.Cells[1,0] := 'Name';
  Grid.Cells[2,0] := 'Status';
end;

procedure TFormMain.LoadInventory(filter: string);
var
  row: Integer;
begin
  FDQuery1.Close;
  FDQuery1.SQL.Text := 'SELECT * FROM inventory WHERE 1=1 ' + filter;
  FDQuery1.Open;

  Grid.RowCount := FDQuery1.RecordCount + 1;
  row := 1;

  while not FDQuery1.Eof do
  begin
    Grid.Cells[0,row] := FDQuery1.FieldByName('id').AsString;
    Grid.Cells[1,row] := FDQuery1.FieldByName('name').AsString;
    Grid.Cells[2,row] := FDQuery1.FieldByName('status').AsString;
    Inc(row);
    FDQuery1.Next;
  end;
end;

procedure TFormMain.BtnLoadClick(Sender: TObject);
begin
  LoadInventory;
end;

procedure TFormMain.ComboStatusChange(Sender: TObject);
begin
  if ComboStatus.Text = '' then
    LoadInventory
  else
    LoadInventory(' AND status = ''' + ComboStatus.Text + '''');
end;

procedure TFormMain.BtnAddClick(Sender: TObject);
begin
  FDQuery1.SQL.Text :=
    'INSERT INTO inventory (name, status) VALUES (''Neues Gerät'', ''Projektiert'')';
  FDQuery1.ExecSQL;
  LoadInventory;
end;

procedure TFormMain.BtnExportClick(Sender: TObject);
var
  sl: TStringList;
  i: Integer;
  line: string;
begin
  sl := TStringList.Create;
  try
    for i := 1 to Grid.RowCount - 1 do
    begin
      line := Grid.Cells[0,i] + ';' +
              Grid.Cells[1,i] + ';' +
              Grid.Cells[2,i];
      sl.Add(line);
    end;
    sl.SaveToFile('export.csv');
    ShowMessage('Export fertig!');
  finally
    sl.Free;
  end;
end;

end.
