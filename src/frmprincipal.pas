unit frmprincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  frmConfiguracion, ZConnection, IniFiles, frmEmisor, frmRecibos;

type

  { TformPrincipal }

  TformPrincipal = class(TForm)
    MainMenu1: TMainMenu;
    menuArchivo: TMenuItem;
    menuRecibosRecibos: TMenuItem;
    menuRecibosEmisores: TMenuItem;
    menuRecibosConfiguracion: TMenuItem;
    menuArchivoAyuda: TMenuItem;
    MenuItem3: TMenuItem;
    menuArchivoImpresora: TMenuItem;
    MenuItem5: TMenuItem;
    menuArchivoAcercade: TMenuItem;
    MenuItem7: TMenuItem;
    menuArchivoSalir: TMenuItem;
    menuRecibos: TMenuItem;
    ZConnection1: TZConnection;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure menuArchivoSalirClick(Sender: TObject);
    procedure menuRecibosConfiguracionClick(Sender: TObject);
    procedure menuRecibosEmisoresClick(Sender: TObject);
    procedure menuRecibosRecibosClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  formPrincipal: TformPrincipal;

implementation

{$R *.lfm}

{ TformPrincipal }

procedure TformPrincipal.FormCreate(Sender: TObject);
var
  ficheroini: TIniFile;
begin
  if not FileExists(ExtractFilePath(ParamStr(0))+'recibos.ini') then begin
     try
       formConfiguracion:=TformConfiguracion.Create(Self);
       formConfiguracion.ShowModal;
     finally
       formConfiguracion.Free;
     end;
  end;
  ficheroini:=TIniFile.Create('recibos.ini');
   ZConnection1.Protocol := ficheroini.ReadString('CONEXION','Protocol','');
   ZConnection1.Hostname := ficheroini.ReadString('CONEXION','Hostname','');
   ZConnection1.Database := ficheroini.ReadString('CONEXION','Database','');
   ZConnection1.User     := ficheroini.ReadString('CONEXION','Username','');
   ZConnection1.Password := ficheroini.ReadString('CONEXION','Password','');
   ZConnection1.LibraryLocation := ficheroini.ReadString('CONEXION','LibraryLocation','');
  ficheroini.Free;
  ZConnection1.Connect;
end;

procedure TformPrincipal.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  ZConnection1.Connected:=False;
end;

procedure TformPrincipal.menuArchivoSalirClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TformPrincipal.menuRecibosConfiguracionClick(Sender: TObject);
begin
  try
    formConfiguracion:=TformConfiguracion.Create(Self);
    formConfiguracion.ShowModal;
  finally
    formConfiguracion.Free;
  end;
end;

procedure TformPrincipal.menuRecibosEmisoresClick(Sender: TObject);
begin
  formEmisores.ShowModal;
end;

procedure TformPrincipal.menuRecibosRecibosClick(Sender: TObject);
begin
  formRecibos.ShowModal;
end;

end.

