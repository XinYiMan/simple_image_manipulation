unit uImageManipulation;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, BGRABitmap, BGRABitmapTypes, FPImage, FPReadJpeg, FPReadPng, Math;


  type TImageType = (itIgnore, itJPEG, itBMP, itPNG);

  type

  { TImageManipulation }

 TImageManipulation = class

    private
          OriginalImage   : TBGRABitmap;
          EditedImage     : TBGRABitmap;
          ValidFormat     : boolean;
          CalcEncodeGamma : array of byte;
          CalcDecodeGamma : array of byte;
          function MyTruncate(value: single): byte;
          procedure CalculateGammaEncodeValue(gamma : single);
          procedure CalculateGammaDecodeValue(gamma : single);
    public
          constructor Create;
          destructor Free;
          function LoadFromFile(name_file : string; mode : TImageType = itIgnore) : boolean;
          function CutRectangle(FSelectionRect : TRect) : boolean;
          procedure SetOriginalImage;
          procedure SaveToFile(name_file : string);
          procedure SaveToStream(app_stream : TMemoryStream);
          procedure RotateLeft();
          procedure RotateRight();
          procedure VerticalFlip();
          procedure HorizontalFlip();
          procedure Brightness(value_perc: single);
          procedure Contrast(value_perc: single);
          procedure Zoom(value_perc: single);
          procedure EncodeGamma(gamma : single);
          procedure DecodeGamma(gamma : single);
  end;

implementation

{ TImageManipulation }

constructor TImageManipulation.Create;
begin
     OriginalImage    := TBGRABitmap.Create;
     EditedImage      := TBGRABitmap.Create;
     Self.ValidFormat := false;
end;

destructor TImageManipulation.Free;
begin
     EditedImage.Free;
     EditedImage := nil;
     OriginalImage.Free;
     OriginalImage := nil;
end;

function TImageManipulation.LoadFromFile(name_file: string; mode: TImageType
  ): boolean;
var
   extension : string;
   jpgReader : TFPReaderJPEG; //in unit FPReadJpeg
   pngReader : TFPReaderPNG; //in unit FPReadPng
begin

     if mode = itIgnore then
     begin
          extension := lowercase(ExtractFileExt(name_file));
          case extension of

               '.jpg'  : mode := itJPEG;
               '.jpeg' : mode := itJPEG;
               '.png'  : mode := itPNG;
               else
                   mode := itBMP;
          end;
     end;

     if FileExists(name_file) then
     begin
          case mode of
               itJPEG : begin
                             Self.ValidFormat := true;
                             jpgReader := TFPReaderJPEG.Create;
                             Self.OriginalImage.LoadFromFile(name_file, jpgReader);
                             jpgReader.Free;
                             result := true;
                        end;
               itPNG  : begin
                             Self.ValidFormat := true;
                             pngReader := TFPReaderPNG.Create;
                             Self.OriginalImage.LoadFromFile(name_file, pngReader);
                             pngReader.Free;
                             result := true;
                        end;
               itBMP  : begin
                             Self.ValidFormat := true;
                             Self.OriginalImage.LoadFromFile(name_file);
                             result := true;
                        end;
               else
                   Self.ValidFormat := false;

               end;
     end else begin
         Self.OriginalImage.Bitmap.Clear;
         Self.EditedImage.Bitmap.Clear;
         Self.ValidFormat := false;
         result := false;
     end;

     if (result) and (Self.ValidFormat) then
        SetOriginalImage;
end;

function TImageManipulation.CutRectangle(FSelectionRect : TRect): boolean;
var
  Bmp        : TBGRABitmap;
  W,H        : Integer;
begin
     if Self.ValidFormat then
     begin
          result     := false;
          Bmp        := TBGRABitmap.Create;
          try
            W := FSelectionRect.Right  - FSelectionRect.Left;
            H := FSelectionRect.Bottom - FSelectionRect.Top;
            Bmp.SetSize(W, H);
            Bmp.Canvas.CopyRect(Rect(0,0,W,H), Self.EditedImage.Bitmap.Canvas, FSelectionRect);
            Self.EditedImage.Assign(Bmp);
            result := true;
          finally
            Bmp.Free;
            Bmp        := nil;
          end;
     end else begin
              result := false;
     end;
end;

procedure TImageManipulation.SetOriginalImage;
begin

  try
     try

        Self.EditedImage.Assign(Self.OriginalImage);

     finally
    end;
  except
        on E: Exception do
        begin


        end;
  end;
end;

procedure TImageManipulation.SaveToFile(name_file: string);
begin
     if Self.ValidFormat then
     begin
          Self.EditedImage.SaveToFile(name_file);
     end;
end;

procedure TImageManipulation.SaveToStream(app_stream: TMemoryStream);
begin
  try
     try


        app_stream.Position:=0;
        Self.EditedImage.Bitmap.SaveToStream(app_stream);
        app_stream.Position:=0;

     finally

     end;
  except
        on E: Exception do
        begin


        end;
  end;
end;

procedure TImageManipulation.RotateLeft();
begin
     try
        try
           Self.EditedImage:=Self.EditedImage.RotateCCW as TBGRABitmap;
        finally
       end;
     except
           on E: Exception do
           begin

           end;
     end;
end;

procedure TImageManipulation.RotateRight();
begin
     try
        try

           Self.EditedImage:=Self.EditedImage.RotateCW as TBGRABitmap;

        finally

       end;
     except
           on E: Exception do
           begin

           end;
     end;
end;

procedure TImageManipulation.VerticalFlip();
begin
     try
        try
           Self.EditedImage.VerticalFlip(Self.EditedImage.ClipRect);
        finally
       end;
     except
           on E: Exception do
           begin


           end;
     end;
end;

procedure TImageManipulation.HorizontalFlip();
begin
     try
        try
           Self.EditedImage.HorizontalFlip(Self.EditedImage.ClipRect);
        finally
       end;
     except
           on E: Exception do
           begin

           end;
     end;
end;

procedure TImageManipulation.Brightness(value_perc: single);
var
   valore: integer;
   x, y: integer;
   p: PBGRAPixel;
   app: TBGRABitmap;
begin

     try
        app:=TBGRABitmap.create;
        try
           app.Assign(Self.EditedImage.Bitmap);
           valore := Round(Value_Perc / 100 * High(p^.red));
           for y := 0 to app.Height - 1 do
             begin
               p := app.Scanline[y];
               for x := 0 to app.Width - 1 do
               begin
                 p^.red := Min(p^.red + valore, 255);
                 p^.green := Min(p^.green + valore, 255);
                 p^.blue := Min(p^.blue + valore, 255);
                 Inc(p);
               end;
             end;
             app.InvalidateBitmap;
             Self.EditedImage.Bitmap.Assign(app);
        finally
               app.Free;
       end;
     except
           on E: Exception do
           begin


           end;
     end;
end;

procedure TImageManipulation.Contrast(value_perc: single);
var
   valore: single;
   x, y: integer;
   p: PBGRAPixel;
   app: TBGRABitmap;
   factor: single;
begin

     try
        app:=TBGRABitmap.create;
        try
           app.Assign(Self.EditedImage.Bitmap);
           valore := (Value_Perc / 100 * 255);
           factor := (259 * (valore + 255)) / (255 * (259 - valore));
           for y := 0 to app.Height - 1 do
             begin
               p := app.Scanline[y];
               for x := 0 to app.Width - 1 do
               begin
                 p^.red := MyTruncate( factor * (p^.red -255) + 255 );
                 p^.green := MyTruncate( factor * (p^.green -255) + 255 );
                 p^.blue := MyTruncate( factor * (p^.blue -255) + 255 );
                 Inc(p);
               end;
             end;
             app.InvalidateBitmap;
             Self.EditedImage.Bitmap.Assign(app);
        finally
               app.Free;
       end;
     except
           on E: Exception do
           begin


           end;
     end;
end;

procedure TImageManipulation.Zoom(value_perc: single);
var
  app: TBGRABitmap;
begin

     try
        app:=TBGRABitmap.create;
        try
           value_perc:=value_perc/100;
           app.Assign(Self.EditedImage.Bitmap);
           Self.EditedImage.Assign(app.Resample( trunc(app.Width*value_perc), Trunc(app.Height*value_perc)));
        finally
               app.Free;
       end;
     except
           on E: Exception do
           begin


           end;
     end;

end;

procedure TImageManipulation.EncodeGamma(gamma: single);
var
  p     : PBGRAPixel;
  i     : integer;
begin

  try
     try

        if gamma>3 then
           gamma := 3;

        if gamma<0.1 then
           gamma := 0.1;

        CalculateGammaEncodeValue(gamma);

        p := Self.EditedImage.Data;

        for i := Self.EditedImage.NBPixels-1 downto 0 do
        begin
          {p^.red := round( power(p^.red / 255, 1 / gamma) * 255);
          p^.green := round( power(p^.green / 255, 1 / gamma) * 255);
          p^.blue := round( power(p^.blue / 255, 1 / gamma) * 255);
          p^.alpha := round( power(p^.alpha / 255, 1 / gamma) * 255);  }

          p^.red := Self.CalcEncodeGamma[p^.red];
          p^.green := Self.CalcEncodeGamma[p^.green];
          p^.blue := Self.CalcEncodeGamma[p^.blue];
          p^.alpha := Self.CalcEncodeGamma[p^.alpha];

          Inc(p);
        end;

     finally

    end;
  except
        on E: Exception do
        begin


        end;
  end;

end;

procedure TImageManipulation.DecodeGamma(gamma: single);
var
  p     : PBGRAPixel;
  i     : integer;
begin

  try
     try

        if gamma>3 then
           gamma := 3;

        if gamma<0.1 then
           gamma := 0.1;

        CalculateGammaDecodeValue(gamma);


        p := Self.EditedImage.Data;


        for i := Self.EditedImage.NBPixels-1 downto 0 do
        begin
          {p^.red := round( power(p^.red / 255, gamma) * 255);
          p^.green := round( power(p^.green / 255, gamma) * 255);
          p^.blue := round( power(p^.blue / 255, gamma) * 255);
          p^.alpha := round( power(p^.alpha / 255, gamma) * 255);  }
          p^.red := Self.CalcDecodeGamma[p^.red];
          p^.green := Self.CalcDecodeGamma[p^.green];
          p^.blue := Self.CalcDecodeGamma[p^.blue];
          p^.alpha := Self.CalcDecodeGamma[p^.alpha];
          Inc(p);
        end;

     finally

    end;
  except
        on E: Exception do
        begin


        end;
  end;

end;

function TImageManipulation.MyTruncate(value: single): byte;
var
  ret: byte;
begin
     try
        try

           ret := Round(value);

           If (value < 0) Then
              ret := 0;

           If (value > 255) Then
              ret := 255;

        finally

       end;
     except
           on E: Exception do
           begin


           end;
     end;
     result:= ret;
end;

procedure TImageManipulation.CalculateGammaEncodeValue(gamma: single);
var
   i : integer;
begin
     SetLength(CalcEncodeGamma,0);
     for i := 0 to 255 do
     begin
       SetLength(CalcEncodeGamma, Length(CalcEncodeGamma)+1);
       CalcEncodeGamma[Length(CalcEncodeGamma)-1] := round( power(i / 255, 1 / gamma) * 255);
     end;
end;

procedure TImageManipulation.CalculateGammaDecodeValue(gamma: single);
var
   i : integer;
begin
     SetLength(CalcDecodeGamma,0);
     for i := 0 to 255 do
     begin
       SetLength(CalcDecodeGamma, Length(CalcDecodeGamma)+1);
       CalcDecodeGamma[Length(CalcDecodeGamma)-1] := round( power(i / 255, gamma) * 255);
     end;
end;

end.

