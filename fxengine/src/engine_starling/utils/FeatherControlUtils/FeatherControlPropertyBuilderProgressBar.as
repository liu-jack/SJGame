package engine_starling.utils.FeatherControlUtils
{
	import engine_starling.utils.AssetManagerUtil;
	
	import feathers.controls.ProgressBar;
	import feathers.display.Scale3Image;
	import feathers.textures.Scale3Textures;

	public class FeatherControlPropertyBuilderProgressBar extends FeatherControlPropertyBuilderDefault
	{
		public function FeatherControlPropertyBuilderProgressBar()
		{
			super();
		}
		
		override public function get fullClassName():String
		{
			// TODO Auto Generated method stub
			return "feathers.controls.ProgressBar";
		}
		
		public function set fillimage(value:*):void
		{
			var jsonString:String = value;
			jsonString = jsonString.replace(/\'/g,"\"");
			var jsonObject:Object = JSON.parse(jsonString);
//			
//			jsonObject.name = "common_jingyantiao1";
//			jsonObject.firstRegionSize = 1;
//			jsonObject.secondRegionSize = 1;
			
		
			var scale3texture:Scale3Textures = new Scale3Textures(AssetManagerUtil.o.getTexture(jsonObject.name),jsonObject.firstRegionSize,jsonObject.secondRegionSize);
			var fillSkin:Scale3Image = new Scale3Image(scale3texture);
			(_editControl as ProgressBar).fillSkin = fillSkin;
		}
		
	}
}