package engine_starling.utils.FeatherControlUtils
{
	import engine_starling.display.SAtlasLabel;
	
	import lib.engine.utils.functions.Assert;

	/**
	 * SAtlas属性访问器 
	 * @author caihua
	 * 
	 */
	public class FeatherControlPropertyBuilderSAtlasLabel extends FeatherControlPropertyBuilderDefault
	{
		public function FeatherControlPropertyBuilderSAtlasLabel()
		{
			super();
		}
		
		override public function get fullClassName():String
		{
			// TODO Auto Generated method stub
			return "engine_starling.display.SAtlasLabel";
		}
		
		public function set registerChars(value:*):void
		{
			var valuestring:String = value;
			valuestring = valuestring.replace(/'/g, "\"");
			var jsonObject:Object = JSON.parse(valuestring);
			
			if(jsonObject.hasOwnProperty("charTexturePrefix") && jsonObject.hasOwnProperty("charTexturePrefix"))
			{
				(_editControl as SAtlasLabel).registerChars(jsonObject["charString"],jsonObject["charTexturePrefix"]);
			}
			else
			{
				Assert(false,"SAtlasLabel registerChars property error!");
			}
			
			
		}
		
		
	}
}