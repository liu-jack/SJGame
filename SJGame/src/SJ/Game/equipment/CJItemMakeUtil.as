package SJ.Game.equipment
{
	import SJ.Common.Constants.ConstItem;
	import SJ.Common.Constants.ConstItemMake;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfBag;
	import SJ.Game.data.CJDataOfHero;
	import SJ.Game.data.CJDataOfHeroList;
	import SJ.Game.data.CJDataOfRole;
	import SJ.Game.data.config.CJDataOfItemMakeProperty;
	import SJ.Game.data.config.CJDataOfItemProperty;
	import SJ.Game.data.json.Json_item_make;
	import SJ.Game.data.json.Json_item_setting;
	
	import feathers.controls.Label;
	
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Dictionary;
	
	import lib.engine.utils.functions.Assert;

	/**
	 * @author zhengzheng
	 * 创建时间：May 3, 2013 10:29:24 AM
	 * 装备铸造工具类
	 */
	public class CJItemMakeUtil
	{
		/**主角数据*/
		private var _roleData:CJDataOfRole;
		/**背包数据*/
		private var _bagData:CJDataOfBag;
		public function CJItemMakeUtil()
		{
		}
		private static var _o:CJItemMakeUtil = null;
		/**
		 * 获得装备铸造工具类的单例
		 * @return CJItemMakeUtil实例
		 */		
		public static function get o():CJItemMakeUtil
		{
			if(null == _o)
			{
				_o = new CJItemMakeUtil();
				_o._initData();
			}
			return _o;
		}
		
		private function _initData():void
		{
			_roleData = CJDataManager.o.DataOfRole;
			_bagData = CJDataManager.o.getData("CJDataOfBag");
		}
		/**
		 * 品质设置
		 * @param quality 品质
		 * @param label 文本
		 */		
		public function setItemQuality(quality:int, label:Label):void
		{
			var colorArray:Array = ConstItem.SCONST_ITEM_QUALITY_COLOR;
			var textFormat:TextFormat;
			if (quality > 6 || quality < 1)
			{
				Assert(false,"品质类型设置错误！");
				return;
			}
			textFormat = new TextFormat( "Arial", 10, colorArray[quality],null,null,null,null,null,TextFormatAlign.CENTER);
			label.textRendererProperties.textFormat = textFormat;
		}
		/**
		 * 获得主角可铸造的装备
		 * 
		 */		
		public function getItemsByItemType(subType:int = 0):Array
		{
			var templates:Dictionary = CJDataOfItemMakeProperty.o.getAllItemMakeTemplates();
			var retArray : Array = new Array();
			var heroList:CJDataOfHeroList = CJDataManager.o.DataOfHeroList;
			var mainHeroInfo:CJDataOfHero = heroList.getMainHero();
			var roleLevel:int = parseInt(mainHeroInfo.level);
			for each (var itemTemplate:Object in templates)
			{
				var itemSetting:Json_item_setting = CJDataOfItemProperty.o.getTemplate(itemTemplate.id);
				var itemLevel:int = itemSetting.level;
				var itemSubType:int = itemSetting.subtype;
				//获得全部可铸造的装备
				if (subType == ConstItem.SCONST_ITEM_SUBTYPE_ALL)
				{
					if (itemLevel <= roleLevel)
					{
						retArray.push(itemSetting);
					}
				}
				//获得某个装备位可铸造的装备
				if (itemLevel <= roleLevel && itemSubType == subType)
				{
					retArray.push(itemSetting);
				}
			}
			retArray.sort(_itemsShowSort,Array.DESCENDING);
			return retArray;
		}
		/**
		 *  装备显示排序
		 * 
		 */		
		private function _itemsShowSort(itemTemplate0:Json_item_setting, itemTemplate1:Json_item_setting):Number
		{
			var num0:Number = int(itemTemplate0.level) * 10000000 + int(itemTemplate0.quality) * 10000 + ConstItemMake.Const_ITEM_MAKE_SUBTYPE[itemTemplate0.subtype];
			var num1:Number = int(itemTemplate1.level) * 10000000 + int(itemTemplate1.quality) * 10000 + ConstItemMake.Const_ITEM_MAKE_SUBTYPE[itemTemplate1.subtype];
			if (num0 > num1)
			{
				return 1;
			}
			else if (num0 < num1)
			{
				return -1;
			}
			else
			{
				return 0;
			}
		}
		/**
		 * 得到可铸造装备的个数
		 * @param itemTmplId 装备模板id
		 * @return 可铸造装备的个数
		 * 
		 */		
		public function getItemCanDoCount(itemTmplId:int):int
		{
			var materialInfo:Array = CJItemMakeUtil.o.getMaterialInfo(itemTmplId);
			//得到几种计算结果的最小值
			var dataResult:Array = new Array();
			for (var i:int = 0; i < materialInfo.length; i++)
			{
				if (materialInfo[i].itemId != 0)
				{
					var data:CJItemCanDoUtil = materialInfo[i] as CJItemCanDoUtil;
					dataResult.push(data.getItemCanDoNum());
				}
			}
			dataResult.sort(Array.NUMERIC);
			return dataResult[0];
		}
		/**
		 * 得到可铸造装备材料信息
		 * @param itemTmplId 装备模板id
		 * @return 可铸造装备材料信息
		 * 
		 */
		public function getMaterialInfo(itemTmplId:int):Array
		{
			var makeItem:Json_item_make = CJDataOfItemMakeProperty.o.getItemMakeInfo(itemTmplId);
			var ownMaterialCount0:int;
			var ownMaterialCount1:int;
			var ownMaterialCount2:int;
			if (null == makeItem)
			{
				Assert(false, "没有获得要铸造装备的信息！");
				return null;
			}	
			//得到拥有的每种材料数
			ownMaterialCount0 = _bagData.getItemCountByTmplId(makeItem.materialid0);
			ownMaterialCount1 = _bagData.getItemCountByTmplId(makeItem.materialid1);
			ownMaterialCount2 = _bagData.getItemCountByTmplId(makeItem.materialid2);
			//把铸造装备个数工具类实例存入数组
			var dataMaterial:Array = new Array();
			var needMaterial:Array = [makeItem.materialnum0, makeItem.materialnum1,makeItem.materialnum2];
			var ownMaterial:Array = [ownMaterialCount0, ownMaterialCount1,ownMaterialCount2];
			var needMaterialId:Array = [makeItem.materialid0, makeItem.materialid1,makeItem.materialid2];
			for (var i:int = 0; i < needMaterial.length; i++)
			{
				if (needMaterial[i] != 0)
				{
					var itemCanDo:CJItemCanDoUtil = new CJItemCanDoUtil();
					itemCanDo.itemNeed = needMaterial[i];
					itemCanDo.itemOwn = ownMaterial[i];
					itemCanDo.itemId = needMaterialId[i];
					dataMaterial.push(itemCanDo);
				}
			}
			return dataMaterial;
		}
	}
}