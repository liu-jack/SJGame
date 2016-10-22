package SJ.Game.data.config
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.data.json.Json_item_jewel_config;
	
	import engine_starling.data.SDataBase;
	import engine_starling.utils.AssetManagerUtil;
	
	import flash.utils.Dictionary;
	
	import lib.engine.utils.CObjectUtils;

	/**
	 +------------------------------------------------------------------------------
	 * 道具宝石配置数据
	 +------------------------------------------------------------------------------
	 * @author    sangxu
	 +------------------------------------------------------------------------------
	 */
	public class CJDataOfItemJewelProperty extends SDataBase
	{
		private static var _o:CJDataOfItemJewelProperty;
		
		public function CJDataOfItemJewelProperty()
		{
			super("CJDataOfItemJewelProperty");
			_initData();
		}
		
		public static function get o():CJDataOfItemJewelProperty
		{
			if(_o == null)
				_o = new CJDataOfItemJewelProperty();
			return _o;
		}
		
		/**
		 * 组织形式  itemTemplateId =>  Json_item_jewel_config
		 */		
		private function _initData():void
		{
			var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonItemJewelConfig) as Array;
			var length:int = obj.length;
			for(var i:int = 0 ; i < length ; i++)
			{
				var jewelConfig:Json_item_jewel_config = new Json_item_jewel_config();
				jewelConfig.loadFromJsonObject(obj[i]);
				this.setData(jewelConfig.id , jewelConfig);
			}
		}
		
		/**
		 * 获取所有的配置列表
		 */		
		public function getAllItemJewelConfig():Dictionary
		{
			return this._dataContains;
		}
		
		/**
		 * 根据指定id获取道具宝石配置 
		 * @param itemTemplateId	道具模板id
		 */		
		public function getItemJewelConfigById(itemTemplateId:int):Json_item_jewel_config
		{
			return CObjectUtils.clone(this.getData(String(itemTemplateId)));
		}
	}
}