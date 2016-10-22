package SJ.Game.data.config
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.data.json.Json_function_indicate_setting;
	
	import engine_starling.utils.AssetManagerUtil;
	
	import flash.utils.Dictionary;
	
	/**
	 +------------------------------------------------------------------------------
	 * 功能点指引列表配置数据
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-6-26 上午12:24:42  
	 +------------------------------------------------------------------------------
	 */
	public class CJDataOfFuncIndicatePropertyList
	{
		private var _dataDict:Dictionary;
		private static var _o:CJDataOfFuncIndicatePropertyList;
		private var _length:int = 0;
		
		public function CJDataOfFuncIndicatePropertyList()
		{
			_initData();
		}
		
		public static function get o():CJDataOfFuncIndicatePropertyList
		{
			if(_o == null)
				_o = new CJDataOfFuncIndicatePropertyList();
			return _o;
		}
		
		private function _initData():void
		{
			var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResFuncListIndicateSetting) as Array;
			if (obj == null)
			{
				return;
			}
			_dataDict = new Dictionary();
			var length:int = obj.length;
			this._length = length;
			for(var i:int=0;i<length;i++)
			{
				var funcConfig:Json_function_indicate_setting = new Json_function_indicate_setting();
				funcConfig.loadFromJsonObject(obj[i]);
				_dataDict[parseInt(obj[i]['id'])] = funcConfig;
			}
		}
		
		/**
		 * 获取单个指引配置
		 * @param id ：指引配置id
		 * @return Json_function_indicate_setting
		 */		
		public function getProperty(id:int):Json_function_indicate_setting
		{
			return _dataDict[id];
		}
	}
}