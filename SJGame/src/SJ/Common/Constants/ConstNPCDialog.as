package SJ.Common.Constants
{
	/**
	 @author	Weichao 
	 2013-5-14
	 */
	
	import engine_starling.SApplication;
	import engine_starling.utils.AssetManagerUtil;
	
	import feathers.display.Scale3Image;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale3Textures;
	import feathers.textures.Scale9Textures;
	
	import flash.geom.Rectangle;
	
	import starling.textures.Texture;
	
	public class ConstNPCDialog
	{
		public function ConstNPCDialog()
		{
		}
		
		static public const IconType_Default:int = 0;
		static public const IconType_Tanhao_SHI:int = 1;
		static public const IconType_TanHao_xu:int = 2;
		static public const IconType_Wenhao_SHI:int = 3;
		static public const IconType_Wenhao_xu:int = 4;
		
		static public function genS9ImageWithTextureNameAndRect(textureName:String, x:Number, y:Number, width:Number, height:Number):Scale9Image
		{
			var textureBg:Texture = SApplication.assets.getTexture(textureName);
			var bgScaleRange:Rectangle = new Rectangle(x, y, width, height);
			var bgTexture:Scale9Textures = new Scale9Textures(textureBg, bgScaleRange);
			var bgImage:Scale9Image = new Scale9Image(bgTexture);
			return bgImage;
		}
		static public function genS3ImageWithTextureNameAndRegion(textureName:String, firstRegionSize:Number, secondRegionSize:Number):Scale3Image
		{
			var textureBg:Texture = SApplication.assets.getTexture(textureName);
			var scale3texture:Scale3Textures = new Scale3Textures(textureBg,firstRegionSize,secondRegionSize);
			var bgImage:Scale3Image = new Scale3Image(scale3texture);
			return bgImage;
		}
	}
}