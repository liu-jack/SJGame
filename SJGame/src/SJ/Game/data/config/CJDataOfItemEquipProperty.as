package SJ.Game.data.config
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.data.json.Json_item_equip_config;
	
	import engine_starling.data.SDataBase;
	import engine_starling.utils.AssetManagerUtil;
	
	import flash.utils.Dictionary;
	
	import lib.engine.utils.CObjectUtils;

	/**
	 +------------------------------------------------------------------------------
	 * 道具装备配置数据
	 +------------------------------------------------------------------------------
	 * @author    sangxu
	 +------------------------------------------------------------------------------
	 */
	public class CJDataOfItemEquipProperty extends SDataBase
	{
		private static var _o:CJDataOfItemEquipProperty;
		
		public function CJDataOfItemEquipProperty()
		{
			super("CJDataOfItemEquipProperty");
			_initData();
		}
		
		public static function get o():CJDataOfItemEquipProperty
		{
			if(_o == null)
				_o = new CJDataOfItemEquipProperty();
			return _o;
		}
		
		/**
		 * 组织形式  itemTemplateId =>  Json_item_equip_config
		 */		
		private function _initData():void
		{
			var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonItemEquipConfig) as Array;
			var length:int = obj.length;
			for(var i:int = 0 ; i < length ; i++)
			{
				var equipConfig:Json_item_equip_config = new Json_item_equip_config();
				equipConfig.loadFromJsonObject(obj[i]);
				this.setData(equipConfig.id , equipConfig);
			}
		}
		
		/**
		 * 获取所有的配置列表
		 */		
		public function getAllItemEquipConfig():Dictionary
		{
			return this._dataContains;
		}
		
		/**
		 * 根据指定id获取道具装备配置 
		 * @param itemTemplateId	道具模板id
		 */		
		public function getItemEquipConfigById(itemTemplateId:int):Json_item_equip_config
		{
			return CObjectUtils.clone(this.getData(String(itemTemplateId)));
		}
	}
}