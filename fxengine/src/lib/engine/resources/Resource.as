package lib.engine.resources
{
	import flash.utils.ByteArray;

	/**
	 * 资源类 
	 * @author caihua
	 * 
	 */
	public class Resource
	{
		
		
		public function Resource(mkey:String)
		{
			type = ResourceType.TYPE_NONE;
			LoadState = ResourceLoadState.LOADSTATE_NOLOAD;
			bytes = new ByteArray();
			key = mkey;
		}
		
		/**
		 * 资源实例 
		 */
		public var value:*;
		/**
		 * 资源类型 
		 */
		public var type:String;
		/**
		 * 资源的Key 
		 */
		public var key:String;
		/**
		 * 资源完整路径 
		 */
		public var fullpath:String;
		
		/**
		 * 相对路径 
		 */
		public var Relativepath:String;
		
		/**
		 * 原始字节流 
		 */
		public var bytes:ByteArray;
		
		
		/**
		 * 加载状态 ResourceLoadState
		 */
		public var LoadState:String;
		
		/**
		 * 资源加载完成回调函数 
		 */		
		public var callbacks:Vector.<Function> = new Vector.<Function>();
	}
}