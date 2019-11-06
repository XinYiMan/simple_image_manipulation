unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, uImageManipulation;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Edit1: TEdit;
    Txt_EncodeGamma: TEdit;
    Txt_DecodeGamma: TEdit;
    Txt_Brightness_Value: TEdit;
    Txt_Contrast_Value: TEdit;
    Txt_Zoom_Value: TEdit;
    Txt_TopRect: TEdit;
    Txt_BottomRect: TEdit;
    Txt_LeftRect: TEdit;
    Txt_RightRect: TEdit;
    Image1: TImage;
    OpenDialog1: TOpenDialog;
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
         app        : TImageManipulation;
         procedure SetEnabled(value : boolean);
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
     app := TImageManipulation.Create;
     SetEnabled(false);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
     app.Free;
     app := nil;
end;

procedure TForm1.SetEnabled(value: boolean);
begin
     Self.Button2.Enabled:=value;
     Self.Button3.Enabled:=value;
     Self.Button4.Enabled:=value;
     Self.Button5.Enabled:=value;
     Self.Button6.Enabled:=value;
     Self.Button7.Enabled:=value;
     Self.Button8.Enabled:=value;
     Self.Button9.Enabled:=value;
     Self.Button10.Enabled:=value;

     Self.Txt_TopRect.Enabled:=value;
     Self.Txt_BottomRect.Enabled:=value;
     Self.Txt_LeftRect.Enabled:=value;
     Self.Txt_RightRect.Enabled:=value;

     Self.Txt_Brightness_Value.Enabled:=value;
     Self.Txt_Contrast_Value.Enabled:=value;
     Self.Txt_Zoom_Value.Enabled:=value;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
     if Self.OpenDialog1.Execute then
     begin
          Self.Edit1.Text:=Self.OpenDialog1.FileName;

          Application.ProcessMessages;

          Self.Image1.Picture.LoadFromFile(Self.Edit1.Text);

          app.LoadFromFile(Self.Edit1.Text);
          SetEnabled(true);
     end else begin
          SetEnabled(false);
     end;
end;

procedure TForm1.Button10Click(Sender: TObject);
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
end;

procedure TForm1.Button11Click(Sender: TObject);
var
   app_stream : TMemoryStream;
begin
     Self.Image1.Picture.Clear;
     Self.Image1.Invalidate;

     app.EncodeGamma(StrToFloatDef(Self.Txt_EncodeGamma.Text,1.7));

     app_stream := TMemoryStream.Create;
     try

        app.SaveToStream(app_stream);
        app_stream.Position:=0;
        Self.Image1.Picture.LoadFromStream(app_stream);

     finally
       app_stream.Free;
       app_stream := nil;
     end;

     Self.Image1.Invalidate;
end;

procedure TForm1.Button12Click(Sender: TObject);
var
   app_stream : TMemoryStream;
begin
     Self.Image1.Picture.Clear;
     Self.Image1.Invalidate;

     app.DecodeGamma(StrToFloatDef(Self.Txt_DecodeGamma.Text,1.7));

     app_stream := TMemoryStream.Create;
     try

        app.SaveToStream(app_stream);
        app_stream.Position:=0;
        Self.Image1.Picture.LoadFromStream(app_stream);

     finally
       app_stream.Free;
       app_stream := nil;
     end;

     Self.Image1.Invalidate;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
   app_stream : TMemoryStream;

   aRect      : TRect;
begin

     aRect.Top:=StrToIntDef(Self.Txt_TopRect.Text,0);
     aRect.Bottom:=StrToIntDef(Self.Txt_BottomRect.Text,0);
     aRect.Left:=StrToIntDef(Self.Txt_LeftRect.Text,0);
     aRect.Right:=StrToIntDef(Self.Txt_RightRect.Text,0);
     app.CutRectangle(aRect);

     app_stream := TMemoryStream.Create;
     try

        app.SaveToStream(app_stream);
        app_stream.Position:=0;
        Self.Image1.Picture.LoadFromStream(app_stream);

     finally
       app_stream.Free;
       app_stream := nil;
     end;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
   app_stream : TMemoryStream;
begin
     app.RotateLeft();

     app_stream := TMemoryStream.Create;
     try

        app.SaveToStream(app_stream);
        app_stream.Position:=0;
        Self.Image1.Picture.LoadFromStream(app_stream);

     finally
       app_stream.Free;
       app_stream := nil;
     end;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
   app_stream : TMemoryStream;
begin
     app.RotateRight();

     app_stream := TMemoryStream.Create;
     try

        app.SaveToStream(app_stream);
        app_stream.Position:=0;
        Self.Image1.Picture.LoadFromStream(app_stream);

     finally
       app_stream.Free;
       app_stream := nil;
     end;
end;

procedure TForm1.Button5Click(Sender: TObject);
var
   app_stream : TMemoryStream;
begin
     app.HorizontalFlip();

     app_stream := TMemoryStream.Create;
     try

        app.SaveToStream(app_stream);
        app_stream.Position:=0;
        Self.Image1.Picture.LoadFromStream(app_stream);

     finally
       app_stream.Free;
       app_stream := nil;
     end;
end;

procedure TForm1.Button6Click(Sender: TObject);
var
   app_stream : TMemoryStream;
begin
     app.VerticalFlip();

     app_stream := TMemoryStream.Create;
     try

        app.SaveToStream(app_stream);
        app_stream.Position:=0;
        Self.Image1.Picture.LoadFromStream(app_stream);

     finally
       app_stream.Free;
       app_stream := nil;
     end;
end;

procedure TForm1.Button7Click(Sender: TObject);
var
   app_stream : TMemoryStream;
begin
     app.Brightness(StrToFloatDef(Self.Txt_Brightness_Value.Text,0));

     app_stream := TMemoryStream.Create;
     try

        app.SaveToStream(app_stream);
        app_stream.Position:=0;
        Self.Image1.Picture.LoadFromStream(app_stream);

     finally
       app_stream.Free;
       app_stream := nil;
     end;
end;

procedure TForm1.Button8Click(Sender: TObject);
var
   app_stream : TMemoryStream;
begin
     app.Contrast(StrToFloatDef(Self.Txt_Contrast_Value.Text,0));

     app_stream := TMemoryStream.Create;
     try

        app.SaveToStream(app_stream);
        app_stream.Position:=0;
        Self.Image1.Picture.LoadFromStream(app_stream);

     finally
       app_stream.Free;
       app_stream := nil;
     end;
end;

procedure TForm1.Button9Click(Sender: TObject);
var
   app_stream : TMemoryStream;
begin
     app.Zoom(StrToFloatDef(Self.Txt_Zoom_Value.Text,0));

     app_stream := TMemoryStream.Create;
     try

        app.SaveToStream(app_stream);
        app_stream.Position:=0;
        Self.Image1.Picture.LoadFromStream(app_stream);

     finally
       app_stream.Free;
       app_stream := nil;
     end;
end;

end.

