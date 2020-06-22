program recibos;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, printer4lazarus, frmprincipal, frmconfiguracion, zcomponent, frmEmisor,
  frmrecibos, frmacercade;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TformPrincipal, formPrincipal);
  Application.CreateForm(TformEmisores, formEmisores);
  Application.CreateForm(TformRecibos, formRecibos);
  Application.Run;
end.

