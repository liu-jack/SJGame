package SJ.Game.data.config
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.data.json.Json_recharge_setting;
	
	import engine_starling.data.SDataBase;
	import engine_starling.utils.AssetManagerUtil;
	
	import flash.utils.Dictionary;

	/**
	 * 充值配置数据
	 * @author zhengzheng
	 * 
	 */	
	public class CJDataOfRechargeProperty extends SDataBase
	{
		private static var _o:CJDataOfRechargeProperty;
		private var _dataDict:Dictionary;
		public function CJDataOfRechargeProperty()
		{
			super("CJDataOfRechargeProperty");
			_initData();
		}
		/**
		 * 获取CJDataOfRechargeProperty单例
		 * 
		 */		
		public static function get o():CJDataOfRechargeProperty
		{
			if(_o == null)
				_o = new CJDataOfRechargeProperty();
			return _o;
		}
		
		private function _initData():void
		{
			var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonRecharge) as Array;
			_dataDict = new Dictionary();
			var length:int = obj.length;
			var funcConfig:Json_recharge_setting = new Json_recharge_setting();
			for(var i:int=0;i<length;i++)
			{
				funcConfig.loadFromJsonObject(obj[i]);
				_dataDict[parseInt(obj[i]['id'])] = obj[i];
			}
		}
		/**
		 * 获取单条充值配置数据
		 * @param 充值配置id
		 * 
		 */		
		public function getProperty(id:String):Json_recharge_setting
		{
			var funcConfig:Json_recharge_setting = new Json_recharge_setting();
			if (_dataDict.hasOwnProperty(id))
			{
				funcConfig.loadFromJsonObject(_dataDict[id]);
				return funcConfig;
			}
			else
			{
				return null;
			}
		}
		/**
		 * 获取全部配置数据
		 * 
		 */		
		public function getPropertys():Array
		{
			var arrayResult:Array = new Array();
			for (var id:String in this._dataDict) 
			{
				var funcConfig:Json_recharge_setting = new Json_recharge_setting();
				funcConfig.loadFromJsonObject(_dataDict[id]);
				arrayResult.push(funcConfig);
			}
			return arrayResult;
		}
		
		/**
		 * 根据渠道id获取全部配置数据
		 * @param channelId	渠道id
		 * @return 
		 * 
		 */		
		public function getPropertysByChannel(channelId:String):Array
		{
			var arrayResult:Array = new Array();
			for (var id:String in this._dataDict) 
			{
				var config:Json_recharge_setting = new Json_recharge_setting();
				config.loadFromJsonObject(_dataDict[id]);
				if (String(config.channelid) != channelId)
				{
					continue;
				}
				
				arrayResult.push(config);
			}
			return arrayResult;
		}
	}
}