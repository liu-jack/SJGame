package lib.engine.resources.loader
{
	import flash.utils.ByteArray;
	
	import lib.engine.resources.Resource;

	/**
	 * 资源加载器基类 
	 * @author caihua
	 * 
	 */
	public class ResourceLoader
	{
		protected var _resourceType:String;
		protected var _resource_ext:String;
		protected var _allowRandomName:Boolean = false;

		/**
		 * 资源后缀 
		 */
		public function get resource_ext():String
		{
			return _resource_ext;
		}


		
		/**
		 * 加载完成回调函数 
		 */
		private var _callback:Function;
		/**
		 * 资源类型,资源后缀,不区分大小写,不包含.
		 */
		
		public function get resourceType():String
		{
			return _resourceType;
		}

		/**
		 * 当前加载资源 
		 */
		protected var _res:Resource;
		/**
		 *  
		 * @param ResourceType 资源后缀,不区分大小写,不包含.
		 * 
		 */
		public function ResourceLoader(Resource_ext:String,ResourceType:String)
		{
			_resourceType = ResourceType;
			_resource_ext = Resource_ext;
		}
		
		public final function loader(Res:Resource,callback:Function):void
		{
			_res = Res;
			_callback = callback;
			var value:* = onLoading(_res.bytes);
			//返回 null 则异步加载
			if(value != null)
				loadComplete(value);
		}
		
		/**加载函数 
		 * 子类重写
		 * @param bytes 原始字节流
		 * 
		 */
		protected function onLoading(bytes:ByteArray):*
		{
			
		}
		/**
		 *  
		 * @param value 资源实例
		 * @param bytes 资源原始字节流
		 * 
		 */
		protected final function loadComplete(value:*):void
		{
			_res.type = _resourceType;
			_callback(_res,value);
		}

		/**
		 * 支持随机文件名 
		 */
		public function get allowRandomName():Boolean
		{
			return _allowRandomName;
		}

		/**
		 * @private
		 */
		public function set allowRandomName(value:Boolean):void
		{
			_allowRandomName = value;
		}
		
		
		
	}
}