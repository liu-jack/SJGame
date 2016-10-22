package engine_starling.utils
{
	/**
	 * 缓存接口 
	 * @author zhipeng
	 * 
	 */
	public interface SICache
	{
		 function getObject(key:String,D:* = null):*;
		 function addObject(key:String,value:*):*;
		 function delObject(key:String):*;
		 function delAllObject():void;
		 function delUnusedObjects():void;
	}
}