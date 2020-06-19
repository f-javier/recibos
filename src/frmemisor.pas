unit frmEmisor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, Forms, Controls, Graphics, Dialogs, DbCtrls,
  StdCtrls, ZDataset;

type

  { TformEmisores }

  TformEmisores = class(TForm)
    dbeCodigo: TDBEdit;
    dbeNombre: TDBEdit;
    dbeNifCif: TDBEdit;
    dbeDireccion: TDBEdit;
    dbeCodigoPostal: TDBEdit;
    dbePoblacion: TDBEdit;
    dbeProvincia: TDBEdit;
    dbeTelefono1: TDBEdit;
    dbeTelefono2: TDBEdit;
    dbeLogotipo: TDBEdit;
    dsEmisor: TDataSource;
    DBNavigator1: TDBNavigator;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    ZQEmisor: TZQuery;
    ZQEmisorcodigo: TLongintField;
    ZQEmisorcodigopostal: TStringField;
    ZQEmisordireccion: TStringField;
    ZQEmisorlogotipo: TStringField;
    ZQEmisornifcif: TStringField;
    ZQEmisornombre: TStringField;
    ZQEmisorpoblacion: TStringField;
    ZQEmisorprovincia: TStringField;
    ZQEmisortelefono1: TStringField;
    ZQEmisortelefono2: TStringField;
    ZQTablaRecibos: TZQuery;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure ZQEmisorAfterPost(DataSet: TDataSet);
    procedure ZQEmisorBeforePost(DataSet: TDataSet);
  private
    { private declarations }
    esinsercion: boolean;
  public
    { public declarations }
  end;

var
  formEmisores: TformEmisores;

implementation

{$R *.lfm}

{ TformEmisores }

procedure TformEmisores.FormCreate(Sender: TObject);
begin
  ZQEmisor.Open;
  esinsercion:=false;
end;

procedure TformEmisores.ZQEmisorAfterPost(DataSet: TDataSet);
begin
  if esinsercion=true then begin
    if ZQTablaRecibos.Active then ZQTablaRecibos.Close;
    ZQTablaRecibos.SQL.Clear;
    ZQTablaRecibos.SQL.Add('CREATE TABLE `recibos'+ZQEmisorCODIGO.AsString+'` (');
    ZQTablaRecibos.SQL.Add('      `nrorecibo` INT(10) NOT NULL AUTO_INCREMENT,');
    ZQTablaRecibos.SQL.Add('      `fecha` DATE NULL DEFAULT NULL,');
    ZQTablaRecibos.SQL.Add('      `nombre` VARCHAR(50) NULL DEFAULT NULL COLLATE `utf8_spanish_ci`,');
    ZQTablaRecibos.SQL.Add('      `importe` DECIMAL(10,2) NULL DEFAULT NULL,');
    ZQTablaRecibos.SQL.Add('      `detalle` BLOB NULL,');
    ZQTablaRecibos.SQL.Add('      PRIMARY KEY (`nrorecibo`)');
    ZQTablaRecibos.SQL.Add(')');
    ZQTablaRecibos.SQL.Add('COLLATE=`utf8_spanish_ci`');
    ZQTablaRecibos.SQL.Add('ENGINE=InnoDB;');
    ZQTablaRecibos.ExecSQL;
  end;
end;

procedure TformEmisores.ZQEmisorBeforePost(DataSet: TDataSet);
begin
  if dsEmisor.State = dsInsert then
     esinsercion:=true
  else
     esinsercion:=false;
end;

procedure TformEmisores.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
  ZQEmisor.Close;
end;

end.

