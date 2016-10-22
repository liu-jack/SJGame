package SJ.Game.data.config
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.data.json.Json_item_package_config;
	
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
	public class CJDataOfItemPackageProperty extends SDataBase
	{
		private static var _o:CJDataOfItemPackageProperty;
		
		public function CJDataOfItemPackageProperty()
		{
			super("CJDataOfItemPackageProperty");
			_initData();
		}
		
		public static function get o():CJDataOfItemPackageProperty
		{
			if(_o == null)
				_o = new CJDataOfItemPackageProperty();
			return _o;
		}
		
		/**
		 * 组织形式  itemTemplateId =>  Array[Json_item_package_config]
		 */		
		private function _initData():void
		{
			var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonItemPackageConfig) as Array;
			if (obj == null)
			{
				return;
			}
			var length:int = obj.length;
			var packageConfig:Json_item_package_config;
			var arrayPackageItems:Array;
			var packageItemId:String;
			for (var i:int = 0 ; i < length ; i++)
			{
				packageConfig = _getPackageCfg(obj[i]);
				packageItemId = String(packageConfig.packageitemid);
				arrayPackageItems = this.getPackageConfig(packageItemId);
				if (arrayPackageItems == null)
				{
					arrayPackageItems = new Array();
				}
				arrayPackageItems.push(packageConfig);
				this.setData(packageItemId , arrayPackageItems);
				
				
			}
		}
		
		/**
		 * 获取
		 * @param obj
		 * @param i
		 * @return 
		 * 
		 */		
		private function _getPackageCfg(json:Object):Json_item_package_config
		{
			var data:Json_item_package_config = new Json_item_package_config();
			data.loadFromJsonObject(json);
			return data;
		}
		
//		/**
//		 * 获取所有的配置列表
//		 */		
//		public function getAllItemPackageConfig():Dictionary
//		{
//			return CObjectUtils.clone(this._dataContains);
//		}
//		
//		/**
//		 * 根据指定id获取道具装备配置 
//		 * @param id	配置表id
//		 */		
//		public function getItemPackageConfigById(id:int):Json_item_package_config
//		{
//			return CObjectUtils.clone(this.getData(String(id)));
//		}
		
		/**
		 * 获取礼包配置数据
		 * @param packageItemId	礼包道具id
		 * @return 
		 * 
		 */		
		public function getPackageConfig(packageItemId:String):Array
		{
//			var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonItemPackageConfig) as Array;
//			if(obj == null)
//			{
//				return null;
//			}
//			var length:int = obj.length;
//			var itemArray:Array = new Array();
//			for (var i:int=0 ; i < length ; i++)
//			{
//				if (parseInt(obj[i]["packageitemid"]) == packageItemId)
//				{
//					var data:Json_item_package_config = new Json_item_package_config();
//					data.loadFromJsonObject(obj[i]);
//					itemArray.push(data);
//				}
//			}
//			return itemArray;
			return this.getData(packageItemId);
		}
		
//		/**
//		 * 获取礼包道具中的配置道具信息
//		 * @return 
//		 * 
//		 */		
//		public function getPackageData(itemTemplateId:int):Array
//		{
//			var pkgCfgArray:Array = this.getPackageConfig(itemTemplateId);
//			var addItemArray:Array = new Array();
//			var addData:Object;
//			for each (var cfg:Json_item_package_config in pkgCfgArray)
//			{
//				addData = new Object();
//				addData["id"] = parseInt(cfg.itemid);
//				addData["count"] = parseInt(cfg.itemcount);
//				addItemArray.push(addData);
//			}
//			return addItemArray;
//		}
	}
}