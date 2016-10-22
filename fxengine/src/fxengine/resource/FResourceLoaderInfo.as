package fxengine.resource
{
	public class FResourceLoaderInfo
	{
		/**
		 * 资源加载类 
		 * 
		 */
		public function FResourceLoaderInfo()
		{
		}
		
		private var _fullPath:String = "";

		/**
		 * 资源完整路径 
		 */
		public function get fullPath():String
		{
			return _fullPath;
		}

		/**
		 * @private
		 */
		public function set fullPath(value:String):void
		{
			_fullPath = value;
		}

		
		private var _callBack:Function = null;

		/**
		 * 资源完成回调函数 
		 */
		public function get callBack():Function
		{
			return _callBack;
		}

		/**
		 * @private
		 */
		public function set callBack(value:Function):void
		{
			_callBack = value;
		}

		
		private var _data:* = null;

		/**
		 * 资源数据 
		 */
		public function get data():*
		{
			return _data;
		}

		/**
		 * @private
		 */
		public function set data(value:*):void
		{
			_data = value;
		}

		
	}
}