package lib.engine.resources.loader
{
	import flash.utils.ByteArray;
	
	import lib.engine.resources.ResourceType;

	public class ResourceLoader_JSON extends ResourceLoader
	{
		public function ResourceLoader_JSON()
		{
			super("json",ResourceType.TYPE_JSON);
		}
		
		override protected function onLoading(bytes:ByteArray):*
		{
			var obj:Object = JSON.parse(bytes.toString());
			return obj;
		}
		
	}
}