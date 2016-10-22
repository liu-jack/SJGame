package lib.engine.resources
{
	import flash.utils.Dictionary;
	
	import lib.engine.iface.IResourceEx;
	import lib.engine.utils.functions.Assert;

	/**
	 * 资源扩展
	 * @author caihua
	 * 
	 */
	public class ResourceEx implements IResourceEx
	{
		public function ResourceEx(manager:ResourceManager)
		{
			_manager = manager;
		}
		
		private var _manager:ResourceManager;
		/**
		 * ImageSet索引 
		 */
		private var _ImageSetIdx:Dictionary = new Dictionary();
		public function BuildIdx(res:Resource):void
		{
			var key:String;
			switch(res.type)
			{
				case ResourceType.TYPE_IMAGES:
				{
					var leftidx:int = res.Relativepath.lastIndexOf("/");
					//					key = 	
					if(leftidx != -1)
					{
						key =  res.Relativepath.substr(leftidx + 1);
					}
					else
					{
						key =  res.Relativepath;
					}
					key = key.replace(".images","");
					
					Assert(_ImageSetIdx[key] == null,"Images 切割文件名称重复 名称[" + key + "]");
					_ImageSetIdx[key] = res;
					break;
				}
					
			}
		}
		
		public function getImageset(name:String):Resource
		{
			// TODO Auto Generated method stub
			return _ImageSetIdx[name];
		}
		
		public function getLayout(name:String):Resource
		{
			// TODO Auto Generated method stub
			return null;
		}
		
	}
}