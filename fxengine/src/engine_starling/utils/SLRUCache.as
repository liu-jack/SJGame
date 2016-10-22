package engine_starling.utils
{
	import flash.utils.Dictionary;
	
	import lib.engine.utils.CTimerUtils;
	
	import starling.events.EventDispatcher;

	/**
	 * LURcache 
	 * @author caihua
	 * 
	 */
	public class SLRUCache extends EventDispatcher
	{
		/**
		 * 删除对象操作 
		 */
		public static const Event_RemoveObject:String = "Event_RemoveObject";
		
		
		/**
		 * 添加对象操作 
		 */
		public static const Event_AddObject:String = "Event_AddObject";
		
		private var _maxCapacity:int; 
		private var _listStart:CacheItem = new CacheItem();
		private var _listEnd:CacheItem = new CacheItem();
		private var _map:Dictionary = new Dictionary();
		
		public function SLRUCache(maxCapacity:int = 1000)
		{
			_maxCapacity = maxCapacity;
			_listStart.next = _listEnd;
			_listEnd.previous = _listStart;
		}
		
		/**
		 * 添加对象到缓存中 
		 * @param key
		 * @param value
		 * @param validTime 过期时间 -1 永不过期 毫秒
		 * @return 
		 * 
		 */
		public function addObject(key:String,value:*,validTime:Number = -1):*
		{
			var cur:CacheItem = _map[key];
			if(cur != null)
			{
				if(validTime>0)
				{
					cur.expires = CTimerUtils.getCurrentTime() + validTime;
				}
				else
				{
					cur.expires = Number.MAX_VALUE;
				}
				_moveToHead(cur);
				
				return cur.value;
			}
			
			//满了 删除最后一个
			if(count >= _maxCapacity)
			{
				cur = _listEnd.previous;
				delObject(cur.key);
				
			}
			
			var expires:Number = 0;
			if(validTime>0)
			{
				expires = CTimerUtils.getCurrentTime() + validTime;
			}
			else
			{
				expires = Number.MAX_VALUE;
			}
			var item:CacheItem = new CacheItem(key,value,expires);
			_insertHead(item);
			_map[key] = item;
			_count ++;
			
//			dispatchEventWith(Event_AddObject,false,{"k":key,"v":value});
			
			return value;
			
		}
		/**
		 * 获取 最后一个元素,但是不维护更新,也就是不把这个元素插入头部
		 * @return 
		 * 
		 */
		public function getLastObjectKey():String
		{
			if(_listEnd.previous == _listStart)
			{
				return null;
			}
			return _listEnd.previous.key;
		}
		
		/**
		 *  获取 最后一个元素,但是不维护更新,也就是不把这个元素插入头部
		 * @return 
		 * 
		 */
		public function getLastObjectValue():*
		{
			if(_listEnd.previous == _listStart)
			{
				return null;
			}
			return _listEnd.previous.value;
		}
		/**
		 * 删除对象 
		 * @param key
		 * @return 
		 * 
		 */
		public function delObject(key:String):*
		{
			var cur:CacheItem = _map[key];
			if(cur == null)
			{
				return null;
			}
			
			var outvalue:* = cur.value;
			_count -- ;
			
			delete _map[key];
			_removeCacheItem(cur);
			
			
			return outvalue;
		}
		/**
		 * 获取对象,如果对象过期 自动删除对象 
		 * @param key
		 * @return 
		 * 
		 */
		public function getObject(key:String):*
		{
			var cur:CacheItem = _map[key];
			if(cur == null)
			{
				return null;
			}
			
			var currenttime:Number = CTimerUtils.getCurrentTime();
			
			//过期删除对象
			if(currenttime > cur.expires)
			{
				delete _map[key];
				_removeCacheItem(cur);
				return null;
			}
			if (cur != _listStart.next)
			{
				_moveToHead(cur);
			}
			return cur.value;
		}
		
		/**
		 * 获取所有对象,返回是对象的clone副本 
		 * @return 
		 * 
		 */
		public function getAllObject():Dictionary
		{
			var rtndict:Dictionary = new Dictionary();
			var cur:CacheItem = _listStart.next;
			while(cur != _listEnd)
			{
				rtndict[cur.key] = cur.value;
				cur = cur.next;
			}
			
			return rtndict;
		}
		
		/**
		 * 返回所有过期对象 
		 * @return null 没有过期对象
		 * 
		 */
		public function getAllExprieObject():Dictionary
		{
			var rtndict:Dictionary = null;
			var cur:CacheItem = _listStart.next;
			var currenttime:Number = CTimerUtils.getCurrentTime();
			while(cur != _listEnd)
			{
				
				if(currenttime > cur.expires)
				{
					if(rtndict == null)
						rtndict = new Dictionary();
					rtndict[cur.key] = cur.value;
				}
				cur = cur.next;
			}
			return rtndict;
		}
		
		public function clear():void
		{
			_listStart.next = _listEnd;
			_listEnd.previous = _listStart;
			_count = 0;
		}
		
		/**
		 * 当前对象的数量 
		 * @return 
		 * 
		 */
		private var _count:uint = 0;
		public function get count():int{
			return _count;
		}
		
		
		/**
		 * 移除缓存Item 
		 * @param item
		 * 
		 */
		private function _removeCacheItem(item:CacheItem):void
		{
			item.previous.next = item.next;
			item.next.previous = item.previous;
			item.previous = null;
			item.next = null;
			item.key = null;
			item.value = null;
		}
		
		/**
		 * 插入头部 
		 * @param item
		 * 
		 */
		private function _insertHead(item:CacheItem):void
		{
			item.previous = _listStart;
			item.next = _listStart.next;
			_listStart.next.previous = item;
			_listStart.next = item;
		}
		
		private function _moveToHead(item:CacheItem):void
		{
			item.previous.next = item.next;
			item.next.previous = item.previous;
			item.previous = _listStart;
			item.next = _listStart.next;
			_listStart.next.previous = item;
			_listStart.next = item;
		}
	}
}
/**
 * 缓存对象 
 * @author caihua
 * 
 */
class CacheItem
{
	public function CacheItem(key:String = "",value:* = null ,expires:Number = 0)
	{
		this.key = key;
		this.value = value;
		this.expires = expires;
	}
	public var key:String;        //键值
	public var value:*;          //对象
	public var expires:Number;          //有效期
	public var previous:CacheItem;
	public var next:CacheItem;
}