package SJ.Game.data.config
{
	import SJ.Common.Constants.ConstResource;
	
	import engine_starling.utils.AssetManagerUtil;
	
	import flash.utils.Dictionary;

	/**
	 * 全局配置文件
	 * @author longtao
	 * 
	 */
	public class CJDataOfGlobalConfigProperty
	{
		private var _dictData:Dictionary;
		
		private static var _o:CJDataOfGlobalConfigProperty;
		
		public static function get o():CJDataOfGlobalConfigProperty
		{
			if(_o == null)
				_o = new CJDataOfGlobalConfigProperty();
			return _o;
		}
		
		public function CJDataOfGlobalConfigProperty()
		{
			_init();
		}

		private function _init():void
		{
			var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonGlobalConfig) as Array;
			var len:int = obj.length;
			if( len > 0)
			{
				_dictData = new Dictionary;
				for(var i:int = 0; i < len; i++)
				{
					_dictData[obj[i].key] = obj[i].value;
				}
			}
		}
		
		/**
		 * 获取需要的数据
		 * @param key  键
		 * @return 	全局数据中的对应数据
		 * 
		 */
		public function getData(key:String):String
		{
			return _dictData[key]
		}
	}
}