package SJ.Game.data.config
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.data.json.Json_upgrade_config;
	
	import engine_starling.utils.AssetManagerUtil;
	
	import flash.utils.Dictionary;
	
	import lib.engine.utils.CObjectUtils;

	/**
	 * 武将升级经验数据
	 * @author longtao
	 * 
	 */
	public class CJDataOfUpgradeProperty
	{
		private static var _o:CJDataOfUpgradeProperty;
		public static function get o():CJDataOfUpgradeProperty
		{
			if(_o == null)
				_o = new CJDataOfUpgradeProperty();
			return _o;
		}
		
		private var _dataDict:Dictionary;
		
		public function CJDataOfUpgradeProperty()
		{
			_initData();
		}
		
		private function _initData():void
		{
			var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonUpgrade) as Array;
			if(obj == null)
			{
				return;
			}
			_dataDict = new Dictionary();
			var length:int = obj.length;
			for(var i:int=0 ; i < length ; i++)
			{
				var data:Json_upgrade_config = new Json_upgrade_config();
				data.loadFromJsonObject(obj[i]);
				//此处的id是策划配置的id
				_dataDict[obj[i]['level'].toString()] = data;
			}
		}
		
		/**
		 * 获取升到下一等级需要的EXP
		 * @param level 当前等级
		 * @return 	需要的总EXP
		 * 
		 */
		public function getNeedEXP(level:String):String
		{
			var data:Json_upgrade_config = _dataDict[level] as Json_upgrade_config;
			if (data)
				return CObjectUtils.clone(data.needexp) as String;
			
			// 非法传入的level返回"0"
			return "0";
		}
		
		/**
		 * 获取指定等级升级配置数据
		 * @param level	当前等级
		 * @return Json_upgrade_config
		 * 
		 */		
		public function getUpgradeConfig(level:String):Json_upgrade_config
		{
			var data:Json_upgrade_config = _dataDict[level] as Json_upgrade_config;
			return CObjectUtils.clone(data) as Json_upgrade_config;
		}
	}
}