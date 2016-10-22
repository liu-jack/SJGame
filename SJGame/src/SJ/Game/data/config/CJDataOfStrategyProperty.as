package SJ.Game.data.config
{
	import flash.utils.Dictionary;
	
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.data.json.Json_strategy_setting;
	
	import engine_starling.data.SDataBase;
	import engine_starling.utils.AssetManagerUtil;
	
	/**
	 * 攻略配置数据
	 * @author zhengzheng
	 */
	public class CJDataOfStrategyProperty extends SDataBase
	{
		public function CJDataOfStrategyProperty()
		{
			super("CJDataOfStrategyProperty");
		}
		
		private static var _o:CJDataOfStrategyProperty;
		public static function get o():CJDataOfStrategyProperty
		{
			if(_o == null)
			{
				_o = new CJDataOfStrategyProperty();
				_o._initData();
			}
			return _o;
		}
		
		private var _dataDict:Dictionary;
		private function _initData():void
		{
			var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonStrategy) as Array;
			var length:int = obj.length;
			var strategySetting:Json_strategy_setting = new Json_strategy_setting();
			_dataDict = new Dictionary();
			for(var i:int=0;i<length;i++)
			{
				strategySetting.loadFromJsonObject(obj[i]);
				_dataDict[parseInt(obj[i]['id'])] = obj[i];
			}
		}
		
		/**
		 * 通过攻略类型获取攻略配置模板
		 * @return 
		 * 
		 */		
		public function getStrategySettingTemplatesByType(type:int):Array
		{
			var strategySettingArray:Array = new Array();
			for (var i:String in _dataDict) 
			{
				var strategySetting:Json_strategy_setting = new Json_strategy_setting();
				strategySetting.loadFromJsonObject(_dataDict[i]);
				if (int(strategySetting.type) == type)
				{
					strategySettingArray.push(strategySetting);
				}
			}
			return strategySettingArray;
		}
		
	}
}