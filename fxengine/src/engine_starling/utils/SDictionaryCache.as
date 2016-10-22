package engine_starling.utils
{
	import flash.utils.Dictionary;

	public class SDictionaryCache implements SICache
	{
		private var _memdictionay:Dictionary = new Dictionary();
		public function SDictionaryCache()
		{
		}
		
		public function addObject(key:String, value:*):*
		{
			_memdictionay[key] = value;
			return value;
		}
		
		public function delAllObject():void
		{
			_memdictionay = new Dictionary();
			
		}
		
		public function delObject(key:String):*
		{
			delete _memdictionay[key];
		}
		
		public function delUnusedObjects():void
		{
			
			
		}
		
		public function getObject(key:String, D:*=null):*
		{
			return _memdictionay[key] == null?D:_memdictionay[key];
		}
		
		
	}
}