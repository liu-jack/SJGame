package engine_starling.utils.asset
{
	import starling.events.EventDispatcher;
	

	/**
	 * 引用计数 
	 * @author caihua
	 * 
	 */
	internal class AssetObjectRefCount extends EventDispatcher
	{
		public function AssetObjectRefCount()
		{
			
			
		}
		
		private var _refCount:int = 0;
		
		public function get refCount():int
		{
			return _refCount;
		}

		public function inc_ref():void
		{
			_refCount ++;	
		}
		
		public function dec_ref():void
		{
			_refCount --;
			_refCount = Math.max(0,_refCount);
		}
		
		public function zero_ref():Boolean
		{
			return _refCount == 0;
		}
		
	}
}