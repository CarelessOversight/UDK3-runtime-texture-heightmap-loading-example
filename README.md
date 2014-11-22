UDK3-runtime-texture-heightmap-loading-example
==============================================

These code snippets demonstrate how to load texture & heightmap into UDK 3 at runtime:
- Delphi Example-Picture to DDS : example code (in Delphi) for converting image file into DirectDraw Surface (DDS) file
- MFCImageLoad : these make MFCImageLoad.dll used by UDK to load external files into memory. Contains all Visual Studio files - all actual code is in MFCImageLoad.h
- UDK : example files for loading external files into UDK.

I was asked for more detailed presentation of runtime texture loading used in WIP thread : https://forums.epicgames.com/threads/988957-Tabletop-gaming-tech-test-of-dynamic-texture-loading-amp-UDK-remote-control .
I've re-used parts of the code presented by Ehamloptiran on thread : https://forums.epicgames.com/threads/967633-Dynamic-player-driven-customizations-textures-for-players?p=31565123&viewfull=1#post31565123 .
I've tried to expand on few topics not touched in that thread.

Prerequisites:
* UDK version that contains Texture2DDynamic.UpdateMip - function. For example 2014-02 version has that.
* 32-bit version of UDK. This method uses external .dll and to my knowledge only 32-bit version supports that. The .dll needs to be saved in UDK\Binaries\Win32\UserCode - folder.
* For heightmaps, this method uses DX11, so DX11 compatible graphics card and run UDK in DX11 mode. If you're not interested in the heightmap, DX11 is not needed. 

Way it works:
* external program is used to convert a/any bitmap to a DirectDraw surface - format (DDS). This functionality could be combined into the .DLL below. I've included  Delphi example code using Vampyre Imaging Library.

* a dynamic link library (DLL) containing a short routine for loading external file into memory. This is just a short C program you can compile with Visual Studio and it will be called from UnrealScript.

* in UDK I've created an Actor that's just a square 2D mesh. It uses a dynamic material. The actual texture is a parameter for the material. The mesh could be just 2 triangle but because I want to use DX11 tesselation heightmap, It needs to have more triangles (UDK Tesselation 'resolution' depends on original mesh geometry).

Dynamic Material used: <IMG SRC="https://raw.githubusercontent.com/CarelessOversight/UDK3-runtime-texture-heightmap-loading-example/master/UDK/UDK_Material_picture.jpg">

Mesh used : <IMG SRC="https://raw.githubusercontent.com/CarelessOversight/UDK3-runtime-texture-heightmap-loading-example/master/UDK/plane_for_water-mesh_picture.jpg">

* Heightmap is just another material texture parameter. Heightmap scale is also a parameter.

A video demonstrating runtime texture loading : https://www.youtube.com/watch?v=WJJUWq_Kx7E (the code spippets are taken from that project).

Created on 22.11.2014 by Mika Veikkolainen / CarelessOversight@gmail.com
