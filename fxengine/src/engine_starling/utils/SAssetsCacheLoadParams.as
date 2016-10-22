package engine_starling.utils
{
	import flash.utils.ByteArray;

	public class SAssetsCacheLoadParams
	{
		public function SAssetsCacheLoadParams()
		{
		}
		
		/**
		 * 从程序目录加载 
		 */
		public static const  LOADFROM_APP:int = 0;
		/**
		 * 从内存加载
		 */
		public static const  LOADFROM_MEM:int =1;
		/**
		 * 从缓存目标加载 
		 */
		public static const  LOADFROM_APPCACHE:int =2;
		/**
		 * 从远程目录加载 
		 */
		public static const  LOADFROM_REMOTE:int = 3;
		
		/**
		 * 原始路径 
		 */
		public var sourcepath:String;
		
		/**
		 * 加载来源 
		 */
		public var loadfrom:int = LOADFROM_APP;
		
		
		/**
		 * 加载到的内存 
		 */
		public var buffer:ByteArray;
		
		/**
		 * 是否成功 
		 */
		public var isSucc:Boolean = true;
	}
}