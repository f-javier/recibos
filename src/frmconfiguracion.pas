unit frmconfiguracion;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, INIFiles;

type

  { TformConfiguracion }

  TformConfiguracion = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    cbProtocolo: TComboBox;
    eUsuario: TEdit;
    eServidor: TEdit;
    eBaseDatos: TEdit;
    eContrasena: TEdit;
    eLibreria: TEdit;
    gbConfiguracion: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  formConfiguracion: TformConfiguracion;

implementation

{$R *.lfm}

{ TformConfiguracion }

procedure TformConfiguracion.FormCreate(Sender: TObject);
var
  ficheroini: TIniFile;
begin
  if FileExists(ExtractFilePath(ParamStr(0))+'recibos.ini') then begin
     ficheroini:=TIniFile.Create('recibos.ini');
     cbProtocolo.Text := ficheroini.ReadString('CONEXION','Protocol','');
     eServidor.Text := ficheroini.ReadString('CONEXION','Hostname','');
     eBaseDatos.Text := ficheroini.ReadString('CONEXION','Database','');
     eUsuario.Text := ficheroini.ReadString('CONEXION','Username','');
     eContrasena.Text := ficheroini.ReadString('CONEXION','Password','');
     eLibreria.Text := ficheroini.ReadString('CONEXION','LibraryLocation','');
     ficheroini.Free;
  end;
end;

procedure TformConfiguracion.BitBtn1Click(Sender: TObject);
var
  ficheroini: TIniFile;
begin
  ficheroini:=TIniFile.Create('recibos.ini');
  ficheroini.WriteString('CONEXION','Protocol',cbProtocolo.Text);
  ficheroini.WriteString('CONEXION','Hostname',eServidor.Text);
  ficheroini.WriteString('CONEXION','Database',eBaseDatos.Text);
  ficheroini.WriteString('CONEXION','Username',eUsuario.Text);
  ficheroini.WriteString('CONEXION','Password',eContrasena.Text);
  ficheroini.WriteString('CONEXION','LibraryLocation',eLibreria.Text);
  ficheroini.Free;
end;

end.

