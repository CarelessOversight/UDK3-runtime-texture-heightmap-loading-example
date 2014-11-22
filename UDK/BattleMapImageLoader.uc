class BattleMapImageLoader extends Object DLLBind(MFCImageLoad);

// Registers external MFCImageLoad.dll and it's functions
// 18.04.2014 created by Mika Veikkolainen, careless.oversight@gmail.com
// Based on code provided by Ehamloptiran on UDK forums :
// https://forums.epicgames.com/threads/967633-Dynamic-player-driven-customizations-textures-for-players?p=31565123&viewfull=1#post31565123

var string aFileName; // name of the loaded file.

struct ImageData
{
	var array<byte> Data;
};

dllimport final function DLLGetData( out ImageData ImportData );
dllimport final function DLLSetName( string aName);

// set the external filename that we're going to load
function setName( string aName)
{
	aFileName = aName;
	DLLSetName( aFileName );
}

// read image into memory
function GetData( out array<byte> Data )
{
	local ImageData ImportData;
	DLLGetData( ImportData );
	Data = ImportData.Data;
}

