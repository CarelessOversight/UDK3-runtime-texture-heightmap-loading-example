class BattleMapDynamicPicture extends Actor placeable;

// 12.04.2014 Created by Mika Veikkolainen, careless.oversight@gmail.com
// 25.04.2014 added dx11 heightmap
// 10.11.2014 added viewport project/deproject
// 22.11.2014 some clean-up and commenting
//
// Basic idea : this is an actor that you place inside the game in UDK
// the actor is just a tile that it covered in dynamic material.
// the dynamic material has following parameters:
//  * 'TextureParam' : texture displayed
//  * 'HeightParam': Heightmap texture used
//  * 'HeightScalar' : max height for displaying heightmap
//  * 'MinHeightScalar' : min height for displaying heightmap
// for dynamic texture loading a simple square mesh would be enough
// but for heightmap we need a square with a lot of subgeometry for tesselation
// otherwise the heihtmap resolution will not be enough. This also requires DX11 version of UDK and 
// display card supporting DX11. Without heightmap we could use DX9.
//
// This was written for a top-down tabletopgame with only one dynamic picture tile in the middle
// of the map, facing up.
//


var MaterialInstanceConstant ConsoleMaterial;
var Texture2DDynamic CanvasTexture;
var() editinline const StaticMeshComponent Mesh;
var Texture2DDynamic HeightTexture;
var int imageSize; // loaded image size (it's a square of imageSize*imageSize)
var vector2D screenTopLeft; // display screen top-left position in texture coordinates
var vector2D screenSize; // display width & height in texture coordinates
var vector ScreenTopLeft_wc; // display top-left in world coordinates


function PostBeginPlay()
{

	super.PostBeginPlay();

   ConsoleMaterial = Mesh.CreateAndSetMaterialInstanceConstant(0);

      if(ConsoleMaterial != none) {
	 ConsoleMaterial.SetParent(Material'DynamicMaterial.DynamicMaterialMaster'); 
         ConsoleMaterial.SetTextureParameterValue('TextureParam', CanvasTexture);
         ConsoleMaterial.SetTextureParameterValue('HeightParam', HeightTexture);
   }
}

function loadTexture(int size, string aName)
{
	local Array<byte> TextureData;	
	local BattleMapImageLoader ImageLoader; 
	
	ImageLoader = new class'BattleMapImageLoader';
// a lot of possible formats (most with compression), see : http://wiki.beyondunreal.com/UE3:Texture_enums_%28UDK%29#EPixelFormat. You must use same format for saving the texture and loading it
	CanvasTexture = class'Texture2DDynamic'.static.Create( size, size,PF_A8R8G8B8 ); // );PF_DXT5
	imageSize = size;
	ImageLoader.SetName( aName );
	ImageLoader.GetData( TextureData );
	CanvasTexture.UpdateMip( 0, TextureData );
       if(ConsoleMaterial != none) ConsoleMaterial.SetTextureParameterValue('TextureParam', CanvasTexture);
}

function loadHeightMap(int size, string aName)
{
	local Array<byte> TextureData;	
	local BattleMapImageLoader ImageLoader; 
	
	ImageLoader = new class'BattleMapImageLoader';
	HeightTexture = class'Texture2DDynamic'.static.Create( size, size,PF_A8R8G8B8 ); // );PF_DXT5
	ImageLoader.SetName( aName );
	ImageLoader.GetData( TextureData );
	HeightTexture.UpdateMip( 0, TextureData );

       if(ConsoleMaterial != none) ConsoleMaterial.SetTextureParameterValue('HeightParam', HeightTexture);
}

// set heightmap height. usually in 0-100 range. (0=flat).
function setHeight(float fHeight)
{
if(ConsoleMaterial != none) {  
  if (fHeight < 0.0 ) {
     ConsoleMaterial.SetScalarParameterValue('HeightScalar', 0.0 );
     ConsoleMaterial.SetScalarParameterValue('MinHeightScalar', -fHeight);
     }
   else {
     ConsoleMaterial.SetScalarParameterValue('HeightScalar', fHeight);
     ConsoleMaterial.SetScalarParameterValue('MinHeightScalar', 0.0);
	}
  }
}


DefaultProperties
{
// Plane_for_water is a square (2D) mesh with subdivisions for DX11 tesselation for heightmap.
// DynamicMaterialMaster is a dynamic material with parameters for actual texture, heightmap & heightmap scaling
   Begin Object class=StaticMeshComponent Name=StaticMeshComp1
      StaticMesh=StaticMesh'BattleMapPackage.Meshes.Plane_for_water'
      Materials(0)=Material'DynamicMaterial.DynamicMaterialMaster'
            bAllowCullDistanceVolume=False
            bAllowApproximateOcclusion=True
            CastShadow=False
            bForceDirectLightMap=True
            bCastDynamicShadow=False
            bCastStaticShadow=False
            LightingChannels=(bInitialized=False,Dynamic=False)
   End Object
   
   Mesh = StaticMeshComp1
   Components.Add(StaticMeshComp1)
         CollisionType=COLLIDE_NoCollision
         bCanStepUpOn=True
         BlockRigidBody=True
         bCollideActors=True
         bBlockActors=True

}

