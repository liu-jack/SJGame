package lib.engine.resources
{
	

	/**
	 * 资源类异步加载器 
	 * @author caihua
	 * 
	 */
	public class ResourceClassLoader
	{
		/**
		 * 回调函数,函数 function(cls:class,params:object):void 
		 */
		private var _callback:Function;
		private var _classname:String;
		private var _params:Object;
		
		/**
		 *  
		 * @param classname 类名称
		 * @param callback 回调函数,函数 function(cls:class,params:object):void 
		 * @param params 回调函数中的参数
		 * 
		 */
		public function ResourceClassLoader(classname:String, callback:Function, params:Object=null)
		{
			_classname = classname;
			_callback = callback;
			_params = params;
		}
		
		public function ResourceLoadered(res:Resource):void
		{
			var cls:Class = ResourceUtils.Res2Class(res,_classname);
			_callback(cls,_params);
		}
		

		
	}
}