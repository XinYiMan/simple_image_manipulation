program ImageManipulationNoGui;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Classes, SysUtils, CustApp
  { you can add units after this }
  ,uImageManipulation;

type

  { TImageManipulationNoGui }

  TImageManipulationNoGui = class(TCustomApplication)
  protected
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure WriteHelp; virtual;
  end;

{ TImageManipulationNoGui }

procedure TImageManipulationNoGui.DoRun;
var
  ErrorMsg  : String;
  name_file : String;
  app       : TImageManipulation;
begin
  // quick check parameters
  ErrorMsg:=CheckOptions('h', 'help');
  if ErrorMsg<>'' then begin
    ShowException(Exception.Create(ErrorMsg));
    Terminate;
    Exit;
  end;

  // parse parameters
  if HasOption('h', 'help') then begin
    WriteHelp;
    Terminate;
    Exit;
  end;

  { add your program here }

  if ParamCount<>2 then
  begin
       WriteHelp;
  end else begin
    if not FileExists(ParamStr(1)) then
    begin
         Writeln('File not exists: ' + ParamStr(1));
    end else begin
        name_file := ParamStr(1);
        app := TImageManipulation.Create;
        app.LoadFromFile(name_file);

        case lowercase(ParamStr(2)) of
             'rl' : app.RotateLeft();
             'rr' : app.RotateRight();
             'hf' : app.HorizontalFlip();
             'vf' : app.VerticalFlip();
        end;

        if FileExists(ExtractFilePath(ParamStr(0)) + 'result.bmp') then
           DeleteFile(ExtractFilePath(ParamStr(0)) + 'result.bmp');
        app.SaveToFile(ExtractFilePath(ParamStr(0)) + 'result.bmp');

        writeln('Output: ' + ExtractFilePath(ParamStr(0)) + 'result.bmp');

        app.Free;
        app := nil;
    end;
  end;

  // stop program loop
  Terminate;
end;

constructor TImageManipulationNoGui.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=True;
end;

destructor TImageManipulationNoGui.Destroy;
begin
  inherited Destroy;
end;

procedure TImageManipulationNoGui.WriteHelp;
begin
  { add your help code here }
  writeln('Usage: ', ExeName, ' -h');
  writeln('Usage: ', ExeName, ' image_file_name parameter');
  writeln('Parameter list: ');
  writeln('rl: rotate left');
  writeln('rr: rotate right');
  writeln('hf: horizontal flip');
  writeln('vf: vertical flip');
  writeln('Example rotate left: ', ExeName, ' image_file_name rl');
end;

var
  Application: TImageManipulationNoGui;
begin
  Application:=TImageManipulationNoGui.Create(nil);
  Application.Title:='Image Manipulation No Gui';
  Application.Run;
  Application.Free;
end.

{
var
   app_stream : TMemoryStream;
begin
     app.SetOriginalImage();

     app_stream := TMemoryStream.Create;
     try

        app.SaveToStream(app_stream);
        app_stream.Position:=0;
        Self.Image1.Picture.LoadFromStream(app_stream);

     finally
       app_stream.Free;
       app_stream := nil;
     end;
}

