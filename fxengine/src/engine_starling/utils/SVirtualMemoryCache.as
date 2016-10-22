package engine_starling.utils
{
	import engine_starling.data.SDataBase;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	/**
	 * 虚拟内存缓存 
	 * @author caihua
	 * 
	 */
	public class SVirtualMemoryCache implements SICache
	{
		private var _rambitmaxsize:uint = 0;
		private var _rambitsize:uint = 0;
		private var _rambytes:ByteArray = new ByteArray();
		private var _ramCache:SLRUCache = new SLRUCache(int.MAX_VALUE);
		/**
		 * 内存字典,表白现在虚拟内存中有的所有对象 
		 */
		private var _ramDict:Dictionary = new Dictionary();
		
		/**
		 *  
		 * @param RambitSize 1024B * 1024K * 10 = 10M
		 * 
		 */
		public function SVirtualMemoryCache(RambitMaxSize:uint = 1)
		{
			_rambitmaxsize = RambitMaxSize;
		}
		
		/**
		 * 增加对象 
		 * @param key 关键字
		 * @param value 
		 * @return 
		 * 
		 */
		public function addObject(key:String,value:*):*
		{
			
//			_ramDict[key] = true;
//			var _cache:SDataBase = new SDataBase("cache_key" + key);
//			_cache.setData("data",value);
//			_cache.saveToCache(false,true);
//			return value;
			
			var newObject:SVirtualMemoryObject = null;
			if(value != null)
			{
				//删除已经存在的对象
				delObject(key);
			
				_rambytes.clear();
				_rambytes.writeObject(value);
				
				//添加到虚拟内存表中
				newObject = new SVirtualMemoryObject(key,value,_rambytes.length);
				_rambitsize += newObject.length;
				_ramDict[key] = newObject;
				_rambytes.clear();
				
				//缓存到lru中
				_ramCache.addObject(key,value);
				
				
				//收缩内存
//				_compressmemory();
				
				
			}
			
			return value;
		}
		
		/**
		 * 删除多余元素 
		 * @param key
		 * @return 
		 * 
		 */
		public function delObject(key:String):*
		{
			var oldObject:SVirtualMemoryObject = null;
			if(_ramDict.hasOwnProperty(key))
			{
				oldObject = _ramDict[key] as SVirtualMemoryObject;
				//移除旧的元素
				_rambitsize -= oldObject.length;
				
				delete _ramDict[key];
				
				_ramCache.delObject(key);
			}
			return null;
//			return (oldObject == null?null:oldObject.value);
		}
		
		public function delAllObject():void
		{
			_ramDict = new Dictionary();
			_ramCache.clear();
			_rambitsize = 0;
		}
		
		public function delUnusedObjects():void
		{
			_compressmemory();			
		}
		
		
		
		/**
		 * 获取对象 
		 * @param key
		 * @param D
		 * @return 
		 * 
		 */
		public function getObject(key:String,D:* = null):*
		{
//			if(_ramDict.hasOwnProperty(key))
//			{
//				var _cache:SDataBase = new SDataBase("cache_key" + key);
//				_cache.loadFromCache(true);
//				return _cache.getData("data");
//			}
//			return null;
			
			var oldObject:SVirtualMemoryObject = null;
			var value:* = _ramCache.getObject(key);
			if(value != null)
			{
				return value;
			}
			
			if(_ramDict.hasOwnProperty(key))
			{
				//存在硬盘中
				oldObject = _ramDict[key] as SVirtualMemoryObject;
				var value:* = oldObject.loadFromCache(true);
				//添加到lru中
				_ramCache.addObject(key,value);
				
				//收缩内存
				_compressmemory();
				return value;
			}
			return D;
			
		}
		
		
		/**
		 * 收缩内存 
		 * 
		 */
		private function _compressmemory():void
		{
			
			while(_rambitsize > _rambitmaxsize)
			{
				//转换LRU最后的一个元素
				var key:String = _ramCache.getLastObjectKey();
				var oldObject:SVirtualMemoryObject = null;
				var value:* = _ramCache.delObject(key);
				//写入硬盘
				oldObject = _ramDict[key] as SVirtualMemoryObject;
				oldObject.saveToCache(value);
				//重新标记内存
				_rambitsize -= oldObject.length;
				
			}
		}
	}
}
import engine_starling.data.SDataBase;

class SVirtualMemoryObject
{
	public var key:String = "";
//	public var value:* = null;
	public var length:uint = 0;
	public var storeinMemory:Boolean = true;
	
	
	public function SVirtualMemoryObject(mkey:String,mvalue:*,len:uint):void
	{
		key = mkey;
//		value = mvalue;
		length = len;
		
		
	}
	
	public function loadFromCache(tmp:Boolean=false):*
	{
		var _datacache:SDataBase = new SDataBase("SVirtualMemoryObject_" + key);
		_datacache.loadFromCache(tmp);
		storeinMemory = true;
		var value:* = _datacache.getData("value");
		return value;
	}
	
	public function saveToCache(value:*):void
	{
		var _datacache:SDataBase = new SDataBase("SVirtualMemoryObject_" +key);
		_datacache.setData("value",value);
		_datacache.saveToCache(false,true);
		
		storeinMemory = false;
		value = null;
	}
	
	
	

}