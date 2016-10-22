package SJ.Game.data.config
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.data.CJDataOfEnhanceEquipConfigSingle;
	import SJ.Game.data.json.Json_enhance_equip_config;
	
	import engine_starling.data.SDataBase;
	import engine_starling.utils.AssetManagerUtil;
	
	import lib.engine.utils.CObjectUtils;

	/**
	 * 装备强化配置数据
	 * @author sangxu
	 * 
	 */	
	public class CJDataOfEnhanceEquipProperty extends SDataBase
	{
		
		public function CJDataOfEnhanceEquipProperty()
		{
			super("CJDataOfEnhanceEquipConfig");
			
		}
		
		private static var _o:CJDataOfEnhanceEquipProperty;
		public static function get o():CJDataOfEnhanceEquipProperty
		{
			if(_o == null)
			{
				_o = new CJDataOfEnhanceEquipProperty();
				_o._initData();
			}
			return _o;
		}
		
		private function _initData():void
		{
			var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonEnhanceEquipConfig) as Array;
			var length:int = obj.length;
			for(var i:int=0; i < length; i++)
			{
				var singleData : CJDataOfEnhanceEquipConfigSingle = new CJDataOfEnhanceEquipConfigSingle();
				singleData.id          = parseInt(obj[i]['id']);
				singleData.position    = parseInt(obj[i]['position']);
				singleData.level       = parseInt(obj[i]['level']);
				singleData.addPropRate = parseInt(obj[i]['addproprate']);
				singleData.costType    = parseInt(obj[i]['costtype']);
				singleData.costPrice   = parseInt(obj[i]['costprice']);
				singleData.baseRate    = parseInt(obj[i]['baserate']);
				singleData.addCostType = parseInt(obj[i]['addcosttype']);
				singleData.addPrice    = parseInt(obj[i]['addprice']);
				
				setConfigData(singleData);
			}
			
//			var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResBagPropSetting) as Array;
//			var length:int = obj.length;
//			for(var i:int=0;i<length;i++)
//			{
//				var prop:Json_enhance_equip_config = new Json_enhance_equip_config();
//				prop.loadFromJsonObject(obj[i]);
//				//此处的id是策划配置的id
//				this.setData(obj[i]['id'], prop);
//			}
		}
		
		/**
		 * 获取装备强化配置数据
		 */
		public function getConfigDataById(id : int) : CJDataOfEnhanceEquipConfigSingle
		{
			return CObjectUtils.clone(this.getData(String(id)));
		}
		
		/**
		 * 设置装备强化配置数据
		 */
		public function setConfigData(data : CJDataOfEnhanceEquipConfigSingle) : void
		{
			this.setData(String(data.id), data);
		}
		
		/**
		 * 根据等级获取装备强化配置数据
		 * @param level 装备强化等级
		 * @return 
		 * 
		 */		
		public function getConfigDataByLevel(level : int) : CJDataOfEnhanceEquipConfigSingle
		{
			for each(var data : CJDataOfEnhanceEquipConfigSingle in this._dataContains)
			{
				if (data.level == level)
				{
					return CObjectUtils.clone(data);
				}
			}
			return null;
		}
	}
}