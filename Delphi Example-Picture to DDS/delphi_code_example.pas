// delphi example for converting images to DirectDraw Layer - format (DDL)
// resizing & conversion done using delphi & Vampyre Imaging Library
var
original_image,new_image:TsingleImage;
flt:TresizeFilter;
size,mx,my,dx,dy:integer;
begin

// original_image contains the bitmap we want to convert
Original_image:=TSingleImage.create;
try
Original_image.LoadFromFile('example.jpg');

//size = max(original_image.width,original_image.height) to nearest 2^ (512,1024,etc.)
size:=max(original_image.width,original_image.height);
if size<=256 then size:=256
else if size<=512 then size:=512
else if size<=1024 then size:=1024
else if size<=2048 then size:=2048
else begin
  // Image is lager than 2048, scaling it back to 2048 px
  size:=2048;
  end;

// create new image with size & format suitable to UDK. it should have transparent background
new_image=TSingleImage.create;
try
new_image.RecreateImageData(size,size,ifA8R8G8B8);

// calculate size & pos where original_image is drawn on new_image
flt:=rfNearest;
if original_image.width>=size then begin
  dw:=size;
  dx:=0;
  if bmp.width>size then flt:=rfBilinear;
  end
else begin
  dw:=bmp.width;
  dx:=(size-bmp.width) div 2;
  end;
if bmp.height>=size then begin
  dh:=mx;
  dy:=0;
  if bmp.height>size then flt:=rfBilinear;
  end
else begin
  dh:=bmp.height;
  dy:=(size-bmp.height) div 2;
  end;

// draw original_image to new_image
original_image.StretchTo(0,0,original_image.width,original_image.height,new_image,dx,dy,dw,dh,flt);
// save new_image
new_image.Format:=ifA8R8G8B8; // ifDXT5; This might not be needed, but setting it just in case.
new_image.SavetoFile(file_name); // save to file. it can then be loaded into UDK
finally
new_image.free;
end;
finally
original_image.free;
end;
end;
end;

