package lib.engine.iface
{
	import flash.utils.ByteArray;
	
	import lib.engine.resources.Resource;

	public interface IResource extends IResourceEx
	{
		/**
		 * 通过完整路径获取资源 ,返回空则加载
		 * @param path 资源完成路径
		 * @param callback 如果返回为空，回调加载 function(res:Resource):void
		 * @param sourcebytes 从Bytes中加载,应该是绝对异步的,主要为了处理资源包中包含其它资源包的加载
		 * @return 
		 * 
		 */
//		function getResbyfullPath(AbsolutePath:String,callback:Function = null,sourcebytes:ByteArray = null):Resource;
		
		/**
		 * 获取资源 返回空则加载
		 * @param RelativePath 资源RelativePath,也就是资源路径,
		 * 相对于资源的根目录,根目录的结构为 swf/fish 
		 * 例如访问 swf/fish/data/InitLoaderList.Group
		 * 输入 data/InitLoaderList.Group 即可
		 * @param callback 如果返回为空，回调加载 function(res:Resource):void
		 * @param sourcebytes 从Bytes中加载,应该是绝对异步的,主要为了处理资源包中包含其它资源包的加载
		 * @return 
		 * 
		 */
		function getResByPath(RelativePath:String,callback:Function = null,sourcebytes:ByteArray = null):Resource;
		
		/**
		 * 资源是否加载完成
		 * @param RelativePath
		 * @return 
		 * 
		 */
		function ResIsLoadedByPath(RelativePath:String):Boolean;
		/**
		 * 获取资源通过ID 
		 * @param key 如果资源根目录为 swf/fish 
		 * 例如访问 swf/fish/data/InitLoaderList.Group
		 * key 为 data.InitLoaderList
		 * 注意无后缀.无修饰
		 * 
		 * @return 如果返回null 不进行加载
		 * 
		 */
//		function getResbyKey(key:String):Resource;
		/**
		 * 获取类注册,
		 * 异步方式 
		 * @param key 类资源索引,在游戏中是相对路径
		 * @param classname 类的名称
		 * @param callback 生成回调函数 callback(cls:class,params:Object)
		 * @param params 回调参数
		 * 
		 */
		function getResourceClass(key:String,classname:String,callback:Function,params:Object = null):void;
		
		

	}
}