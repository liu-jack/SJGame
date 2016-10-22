package SJ.Game.data.config
{
	import flash.utils.Dictionary;
	
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.data.json.Json_item_make;
	
	import engine_starling.data.SDataBase;
	import engine_starling.utils.AssetManagerUtil;
	
	import lib.engine.utils.CObjectUtils;
	
	/**
	 * @author zhengzheng
	 * 创建时间：Apr 22, 2013 7:47:07 PM
	 * 装备铸造配置数据
	 */
	public class CJDataOfItemMakeProperty extends SDataBase
	{
		public function CJDataOfItemMakeProperty()
		{
			super("CJDataOfItemMake");
		}
		
		private static var _o:CJDataOfItemMakeProperty;
		public static function get o():CJDataOfItemMakeProperty
		{
			if(_o == null)
			{
				_o = new CJDataOfItemMakeProperty();
				_o._initData();
			}
			return _o;
		}
		
		private var _dataDict:Dictionary;
		private function _initData():void
		{
			var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResItemMake) as Array;
			var length:int = obj.length;
			var itemMake:Json_item_make = new Json_item_make();
			_dataDict = new Dictionary();
			for(var i:int=0;i<length;i++)
			{
				itemMake.loadFromJsonObject(obj[i]);
				_dataDict[parseInt(obj[i]['id'])] = obj[i];
			}
		}
		
		/**
		 * 获取全部可铸造装备模板
		 * @return 
		 * 
		 */		
		public function getAllItemMakeTemplates():Dictionary
		{
			return CObjectUtils.clone(_dataDict);
		}
		/**
		 * 获得单条装备铸造的信息
		 * @param id
		 * 
		 */		
		public function getItemMakeInfo(id:int):Json_item_make
		{
			var itemMake:Json_item_make = new Json_item_make();
			if (_dataDict.hasOwnProperty(id))
			{
				itemMake.loadFromJsonObject(_dataDict[id]);
				return itemMake;
			}
			else
			{
				return null;
			}
		}
		
	}
}