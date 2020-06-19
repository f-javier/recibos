unit frmrecibos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, PrintersDlgs, LR_Class, LR_DBSet, Forms,
  Controls, Graphics, Dialogs, DbCtrls, DBGrids, ExtCtrls, StdCtrls, DBExtCtrls,
  Buttons, ZDataset, dateutils;

type

  { TformRecibos }

  TformRecibos = class(TForm)
    DBDateEdit1: TDBDateEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBMemo1: TDBMemo;
    dsRecibos: TDataSource;
    DBEdit1: TDBEdit;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    dsEmisor: TDataSource;
    frRecibo: TfrReport;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    panelDatos: TPanel;
    SpeedButton1: TSpeedButton;
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
    ZQRecibos: TZQuery;
    ZQRecibosdetalle: TBlobField;
    ZQRecibosfecha: TDateField;
    ZQRecibosimporte: TFloatField;
    ZQRecibosnombre: TStringField;
    ZQRecibosnrorecibo: TLongintField;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure frReciboEnterRect(Memo: TStringList; View: TfrView);
    procedure frReciboGetValue(const ParName: String; var ParValue: Variant);
    procedure SpeedButton1Click(Sender: TObject);
    procedure ZQEmisorAfterScroll(DataSet: TDataSet);
    function NumeroToLetra( mNum:double ): String;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  formRecibos: TformRecibos;

implementation

{$R *.lfm}

{ TformRecibos }

procedure TformRecibos.ZQEmisorAfterScroll(DataSet: TDataSet);
begin
  if ZQRecibos.Active then ZQRecibos.Close;
  ZQRecibos.SQL.Clear;
  ZQRecibos.SQL.Add('SELECT * FROM recibos'+IntToStr(ZQEmisorCODIGO.AsInteger)+' ORDER BY nrorecibo');
  ZQRecibos.Open;
end;

procedure TformRecibos.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
  ZQEmisor.Close;
end;

procedure TformRecibos.frReciboEnterRect(Memo: TStringList; View: TfrView);
begin
  if ((View.Name='Logotipo1') and (ZQEmisorLOGOTIPO.AsString <> '')) then
    TFrPictureView(View).Picture.LoadFromFile(ZQEmisorLOGOTIPO.AsString);
  if ((View.Name='Logotipo2') and (ZQEmisorLOGOTIPO.AsString <> '')) then
    TFrPictureView(View).Picture.LoadFromFile(ZQEmisorLOGOTIPO.AsString);
  if ((View.Name='Logotipo3') and (ZQEmisorLOGOTIPO.AsString <> '')) then
    TFrPictureView(View).Picture.LoadFromFile(ZQEmisorLOGOTIPO.AsString);
end;

procedure TformRecibos.frReciboGetValue(const ParName: String;
  var ParValue: Variant);
var
  mes : string;
begin
  if ParName = 'NOMBRE' then ParValue := ZQEmisorNOMBRE.AsString;
  if ParName = 'DIRECCION' then ParValue := ZQEmisorDIRECCION.AsString;
  if ParName = 'CODIGOPOSTAL' then ParValue := ZQEmisorCODIGOPOSTAL.AsString;
  if ParName = 'POBLACION' then ParValue := ZQEmisorPOBLACION.AsString;
  if ParName = 'TELEFONO' then ParValue := ZQEmisorTELEFONO1.AsString;
  if ParName = 'NRORECIBO' then ParValue := ZQRecibosNRORECIBO.AsString;
  if ParName = 'DIA'  then ParValue := DayOf(ZQRecibosFECHA.AsDateTime);
  case MonthOf(ZQRecibosFECHA.AsDateTime) of
       1  : mes := 'Enero';
       2  : mes := 'Febrero';
       3  : mes := 'Marzo';
       4  : mes := 'Abril';
       5  : mes := 'Mayo';
       6  : mes := 'Junio';
       7  : mes := 'Julio';
       8  : mes := 'Agosto';
       9  : mes := 'Septiembre';
       10 : mes := 'Octubre';
       11 : mes := 'Noviembre';
       12 : mes := 'Diciembre';
  end;
  if ParName = 'MES' then ParValue := mes;
  if ParName = 'ANYO' then ParValue := YearOf(ZQRecibosFECHA.AsDateTime);
  if ParName = 'NOMBRECLIENTE' then ParValue := ZQRecibosNOMBRE.AsString;
  if ParName = 'IMPORTEENLETRAS' then ParValue := NumeroToLetra(ZQRecibosIMPORTE.AsFloat);
  if ParName = 'CONCEPTO' then ParValue := ZQRecibosDETALLE.AsString;
  if ParName = 'IMPORTEENEUROS' then ParValue := FloatToStr(ZQRecibosIMPORTE.AsFloat);
end;

procedure TformRecibos.SpeedButton1Click(Sender: TObject);
begin
  frRecibo.LoadFromFile(ExtractFilePath(ParamStr(0))+'recibo.lrf');
  // frRecibo.ShowReport;
  frRecibo.PrepareReport;
  frRecibo.PrintPreparedReport('',1);
end;

procedure TformRecibos.FormActivate(Sender: TObject);
begin
  ZQEmisor.Open;
end;

function TformRecibos.NumeroToLetra( mNum:double ): String;
  (**************************************)
  (* Conversión Número -> Letra         *)
  (*                                    *)
  (* Parámetros:                        *)
  (*                                    *)
  (*   mNum:    Número a convertir      *)
  (*   iIdioma: Idioma de conversión    *)
  (*            1 -> Castellano         *)
  (*            2 -> Catalán            *)
  (*   iModo:   Modo de conversión      *)
  (*            1 -> Masculino          *)
  (*            2 -> Femenino           *)
  (*                                    *)
  (* Restricciones:                     *)
  (*                                    *)
  (* - Redondeo a dos decimales         *)
  (* - Rango: 0,00 a 999.999.999.999,99 *)
  (*                                    *)
  (* Origen:                            *)
  (* http://terawiki.clubdelphi.com/    *)
  (* Delphi-Win32/Componentes/Delphi/   *)
  (* Componentes-Funciones/             *)
  (* Numero2Letras.pas.zip              *)
  (**************************************)
  const
      iIdioma : Smallint = 1;   // 1 castellano     2 catalán
      iModo : Smallint = 1;   // 1 masculino     2 femenino

    iTopFil: Smallint = 6;
    iTopCol: Smallint = 10;
    aCastellano: array[0..5, 0..9] of PChar =
    ( ('UNA ','DOS ','TRES ','CUATRO ','CINCO ',
      'SEIS ','SIETE ','OCHO ','NUEVE ','UN '),
      ('ONCE ','DOCE ','TRECE ','CATORCE ','QUINCE ',
      'DIECISEIS ','DIECISIETE ','DIECIOCHO ','DIECINUEVE ',''),
      ('DIEZ ','VEINTE ','TREINTA ','CUARENTA ','CINCUENTA ',
      'SESENTA ','SETENTA ','OCHENTA ','NOVENTA ','VEINTI'),
      ('CIEN ','DOSCIENTAS ','TRESCIENTAS ','CUATROCIENTAS ','QUINIENTAS ',
      'SEISCIENTAS ','SETECIENTAS ','OCHOCIENTAS ','NOVECIENTAS ','CIENTO '),
      ('CIEN ','DOSCIENTOS ','TRESCIENTOS ','CUATROCIENTOS ','QUINIENTOS ',
      'SEISCIENTOS ','SETECIENTOS ','OCHOCIENTOS ','NOVECIENTOS ','CIENTO '),
      ('MIL ','MILLON ','MILLONES ','CERO ','Y ',
      'UNO ','DOS ','CON ','','') );
    aCatalan: array[0..5, 0..9] of PChar =
    ( ( 'UNA ','DUES ','TRES ','QUATRE ','CINC ',
      'SIS ','SET ','VUIT ','NOU ','UN '),
      ( 'ONZE ','DOTZE ','TRETZE ','CATORZE ','QUINZE ',
      'SETZE ','DISSET ','DIVUIT ','DINOU ',''),
      ( 'DEU ','VINT ','TRENTA ','QUARANTA ','CINQUANTA ',
      'SEIXANTA ','SETANTA ','VUITANTA ','NORANTA ','VINT-I-'),
      ( 'CENT ','DOS-CENTES ','TRES-CENTES ','QUATRE-CENTES ','CINC-CENTES ',
      'SIS-CENTES ','SET-CENTES ','VUIT-CENTES ','NOU-CENTES ','CENT '),
      ( 'CENT ','DOS-CENTS ','TRES-CENTS ','QUATRE-CENTS ','CINC-CENTS ',
      'SIS-CENTS ','SET-CENTS ','VUIT-CENTS ','NOU-CENTS ','CENT '),
      ( 'MIL ','MILIO ','MILIONS ','ZERO ','-',
      'UN ','DOS ','AMB ','','') );
  var
    aTexto: array[0..5, 0..9] of PChar;
    cTexto, cNumero: String;
    iCentimos, iPos: Smallint;
    bHayCentimos, bHaySigni, negativo: Boolean;

    (*************************************)
    (* Cargar Textos según Idioma / Modo *)
    (*************************************)

    procedure NumLetra_CarTxt;
    var
      i, j: Smallint;
    begin
      (* Asignación según Idioma *)

      for i := 0 to iTopFil - 1 do
        for j := 0 to iTopCol - 1 do
          case iIdioma of
            1: aTexto[i, j] := aCastellano[i, j];
            2: aTexto[i, j] := aCatalan[i, j];
          else
            aTexto[i, j] := aCastellano[i, j];
          end;

      (* Asignación si Modo Masculino *)

      if (iModo = 1) then
      begin
        for j := 0 to 1 do
          aTexto[0, j] := aTexto[5, j + 5];

        for j := 0 to 9 do
          aTexto[3, j] := aTexto[4, j];
      end;
    end;

    (****************************)
    (* Traducir Dígito -Unidad- *)
    (****************************)

    procedure NumLetra_Unidad;
    begin
      if not( (cNumero[iPos] = '0') or (cNumero[iPos - 1] = '1')
       or ((Copy(cNumero, iPos - 2, 3) = '001') and ((iPos = 3) or (iPos = 9))) ) then
        if (cNumero[iPos] = '1') and (iPos <= 6) then
          cTexto := cTexto + aTexto[0, 9]
        else
          cTexto := cTexto + aTexto[0, StrToInt(cNumero[iPos]) - 1];

      if ((iPos = 3) or (iPos = 9)) and (Copy(cNumero, iPos - 2, 3) <> '000') then
        cTexto := cTexto + aTexto[5, 0];

      if (iPos = 6) then
        if (Copy(cNumero, 1, 6) = '000001') then
          cTexto := cTexto + aTexto[5, 1]
        else
          cTexto := cTexto + aTexto[5, 2];
    end;

    (****************************)
    (* Traducir Dígito -Decena- *)
    (****************************)

    procedure NumLetra_Decena;
    begin
      if (cNumero[iPos] = '0') then
        Exit
      else if (cNumero[iPos + 1] = '0') then
        cTexto := cTexto + aTexto[2, StrToInt(cNumero[iPos]) - 1]
      else if (cNumero[iPos] = '1') then
        cTexto := cTexto + aTexto[1, StrToInt(cNumero[iPos + 1]) - 1]
      else if (cNumero[iPos] = '2') then
        cTexto := cTexto + aTexto[2, 9]
      else
        cTexto := cTexto + aTexto[2, StrToInt(cNumero[iPos]) - 1]
          + aTexto[5, 4];
    end;

    (*****************************)
    (* Traducir Dígito -Centena- *)
    (*****************************)

    procedure NumLetra_Centena;
    var
      iPos2: Smallint;
    begin
      if (cNumero[iPos] = '0') then
        Exit;

      iPos2 := 4 - Ord(iPos > 6);

      if (cNumero[iPos] = '1') and (Copy(cNumero, iPos + 1, 2) <> '00') then
        cTexto := cTexto + aTexto[iPos2, 9]
      else
        cTexto := cTexto + aTexto[iPos2, StrToInt(cNumero[iPos]) - 1];
    end;

    (**************************************)
    (* Eliminar Blancos previos a guiones *)
    (**************************************)

    procedure NumLetra_BorBla;
    var
      i: Smallint;
    begin
      i := Pos(' -', cTexto);

      while (i > 0) do
      begin
        Delete(cTexto, i, 1);
        i := Pos(' -', cTexto);
      end;
    end;

  begin
    (* Control de Argumentos *)

    if {(mNum < 0.00) or }(mNum > 999999999999.99) or (iIdioma < 1) or (iIdioma > 2)
      or (iModo < 1) or (iModo > 2) then
    begin
      Result := 'ERROR EN ARGUMENTOS';
      Abort;
    end;

    // Por si es negativo...
    if mNum < 0.00 then begin
       negativo:=TRUE;
       mNum:=ABS(mNum);
    end
    else
       negativo:=FALSE;

    (* Cargar Textos según Idioma / Modo *)

    NumLetra_CarTxt;

    (* Bucle Exterior -Tratamiento Céntimos-     *)
    (* NOTA: Se redondea a dos dígitos decimales *)

    cNumero := Trim(Format('%12.0f', [Int(mNum)]));
    cNumero := StringOfChar('0', 12 - Length(cNumero)) + cNumero;
    iCentimos := Trunc((Frac(mNum) * 100) + 0.5);

    repeat
      (* Detectar existencia de Céntimos *)

      if (iCentimos <> 0) then
        bHayCentimos := True
      else
        bHayCentimos := False;

      (* Bucle Interior -Traducción- *)

      bHaySigni := False;

      for iPos := 1 to 12 do
      begin
        (* Control existencia Dígito significativo *)

        if not(bHaySigni) and (cNumero[iPos] = '0') then
          Continue
        else
          bHaySigni := True;

        (* Detectar Tipo de Dígito *)

        case ((iPos - 1) mod 3) of
          0: NumLetra_Centena;
          1: NumLetra_Decena;
          2: NumLetra_Unidad;
        end;
      end;

      (* Detectar caso 0 *)

      if (cTexto = '') then
        cTexto := aTexto[5, 3];

      (* Traducir Céntimos -si procede- *)

      if (iCentimos <> 0) then
      begin
        cTexto := cTexto + aTexto[5, 7];
        cNumero := Trim(Format('%.12d', [iCentimos]));
        iCentimos := 0;
      end;
    until not (bHayCentimos);

    (* Eliminar Blancos innecesarios -sólo Catalán- *)

    if (iIdioma = 2) then
      NumLetra_BorBla;

    (* ...Por si es negativo *)
    if negativo then
       cTexto:='MENOS '+cTexto;

    (* Retornar Resultado *)

    Result := Trim(cTexto);
  end;

end.

