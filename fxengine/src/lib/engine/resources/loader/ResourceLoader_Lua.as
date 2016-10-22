package lib.engine.resources.loader
{
	import flash.utils.ByteArray;
	
	import lib.engine.resources.ResourceType;
	
	
	


	public class ResourceLoader_Lua extends ResourceLoader
	{
		public function ResourceLoader_Lua()
		{
			super("lua",ResourceType.TYPE_LUA);
		}
		
		override protected function onLoading(bytes:ByteArray):*
		{
			// TODO Auto Generated method stub
		
			return bytes;
			
			
		}
		
		
	}
}