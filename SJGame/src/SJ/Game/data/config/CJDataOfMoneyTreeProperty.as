package SJ.Game.data.config
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.data.json.Json_money_tree_setting;
	
	import engine_starling.data.SDataBase;
	import engine_starling.utils.AssetManagerUtil;
	
	import flash.utils.Dictionary;
	
	import lib.engine.utils.CObjectUtils;

	/**
	 * 摇钱树板数据
	 * @author sangxu
	 * @date 2013-06-19
	 */	
	public class CJDataOfMoneyTreeProperty extends SDataBase
	{
		
		public function CJDataOfMoneyTreeProperty()
		{
			super("CJDataOfMoneyTreeProperty");
			
		}
		
		private static var _o:CJDataOfMoneyTreeProperty;
		public static function get o():CJDataOfMoneyTreeProperty
		{
			if(_o == null)
			{
				_o = new CJDataOfMoneyTreeProperty();
				_o._initData();
			}
			return _o;
		}
		
		private function _initData():void
		{
			var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonMoneyTree) as Array;
			if(obj == null)
			{
				return;
			}
			var length:int = obj.length;
			var data:Json_money_tree_setting;
			for(var i:int=0 ; i < length ; i++)
			{
				data = new Json_money_tree_setting();
				data.loadFromJsonObject(obj[i]);
				this._setConfig(data)
			}
		}
		
		/**
		 * 获取全部摇钱树配置
		 * @return 
		 * 
		 */		
		public function getAllConfigs():Dictionary
		{
			return CObjectUtils.clone(this._dataContains);
		}
		
		/**
		 * 获取摇钱树配置
		 */
		public function getConfig(level : int) : Json_money_tree_setting
		{
			return CObjectUtils.clone(this.getData(String(level)));
		}
		
		/**
		 * 设置摇钱树配置
		 */
		private function _setConfig(template : Json_money_tree_setting) : void
		{
			this.setData(String(template.level), template);
		}
	}
}