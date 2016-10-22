package engine_starling.data
{
	import engine_starling.Events.DataEvent;
	
	import flash.utils.Dictionary;
	
	import lib.engine.utils.CObjectUtils;
	
	import starling.events.EventDispatcher;
	
	/**
	 * 数据虚类 
	 * @author pengzhi
	 * 
	 */
	internal class SDataAbstract extends EventDispatcher
	{
		
		/**
		 * 是否忽略设置数据的通知事件 
		 * 默认是false,不忽略
		 */
		protected var _ignoreSetDataEvent:Boolean = false;
		
		public function SDataAbstract(dataBasename:String)
		{
			super();
			_dataBasename = dataBasename;
		}
		
		private var _dataBasename:String;
		
		/**
		 *数据集名称 
		 */
		public function get dataBasename():String
		{
			return _dataBasename;
		}
		
		
		protected var _dataContains:Dictionary = new Dictionary;
		
		
		
		/**
		 * 设置数据 
		 * @param key
		 * @param value
		 * 
		 */
		[inline]
		public function setData(key:String, value:*):void
		{
			key = key.toLowerCase()
			if(!_ignoreSetDataEvent)
			{
				var oldvalue:* = _dataContains[key];
				_dataContains[key] = value;
				_notifyDataChange(key,oldvalue,value);
			}
			else
			{
				_dataContains[key] = value;
			}
		}
		
		/**
		 * 获取数据 
		 * @param key
		 * @return 
		 * 
		 */
		[inline]
		public function getData(key:String,D:* = null):*
		{
			key = key.toLowerCase();
			if(hasKey(key))
			{
				return _dataContains[key];
			}
			return D;
		}
		
		/**
		 * 是否包含数据 
		 * @param key
		 * @return 
		 * 
		 */
		[inline]
		public function hasKey(key:String):Boolean
		{
			key = key.toLowerCase();
			return _dataContains.hasOwnProperty(key);
		}
		
		/**
		 * 删除数据 
		 * @param key
		 * 
		 */
		[inline]
		public function delData(key:String):void
		{
			key = key.toLowerCase();
			delete _dataContains[key];
		}
		
		/**
		 * 删除所有数据 
		 * 
		 */
		[inline]
		public function clearAll():void
		{
			_dataContains = new Dictionary();
		}
		
		/**
		 * 通知数据变化 
		 * @param key 关键字
		 * @param oldvalue 原始值
		 * @param newvalue 新值
		 * 
		 */
		protected function _notifyDataChange(key:String,oldvalue:*,newvalue:*):void
		{
			dispatchEventWith(DataEvent.DataChange,false,{'key':key,'value':newvalue,'oldvalue':oldvalue});
		}

		/**
		 * 数据集 clone 副本,有效率问题
		 */
		public function get dataContains():Dictionary
		{
			return CObjectUtils.clone(_dataContains);
		}


	}
}