package lib.engine.data
{
	import flash.utils.Dictionary;
	
	import lib.engine.event.CEvent;
	import lib.engine.event.CEventSubject;
	import lib.engine.event.CEventVar;
	
	/**
	 * 数据接口虚类 
	 * @author caihua
	 * 
	 */
	public class CDataAbstract extends CEventSubject
	{
		private var _name:String;

		/**
		 * 数据集的名称 
		 */
		public function get name():String
		{
			return _name;
		}

		/**
		 * @private
		 */
		public function set name(value:String):void
		{
			_name = value;
		}

		
		private var _data:Dictionary = new Dictionary();
		public function CDataAbstract(name:String)
		{
			super();
			this.name = name;
		}
		
		/**
		 * 设置数据 
		 * @param key
		 * @param value
		 * 
		 */
		public function setData(key:String, value:*):void
		{
			this._data[key] = value;
			notifyDataChange(key);
		}
		
		/**
		 * 获得数据 
		 * @param key 数据的key
		 * @return 
		 * 
		 */
		public function getData(key:String):*
		{
			if (!this._data.hasOwnProperty(key))
			{
				return null;
			}
			return this._data[key];
		}
		
		/**
		 * 是否包含数据 
		 * @param key
		 * @return T 包含 F不包含
		 * 
		 */
		public function hasKey(key:String):Boolean
		{
			return this._data.hasOwnProperty(key);
		}
		
		public function delData(key:String):void
		{
			delete this._data[key];
		}
		
		/**
		 * 通知数据变化接口 
		 * @param key
		 * 
		 */
		protected function notifyDataChange(key:String):void
		{
			this.dispatchEvent(new CEvent(CEventVar.E_DATACHANGE,{'key':key,'value':this._data[key]}));
		}
	}
}