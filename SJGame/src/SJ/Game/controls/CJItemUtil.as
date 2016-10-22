package SJ.Game.controls
{
	
	import SJ.Common.Constants.ConstBag;
	import SJ.Common.Constants.ConstItem;
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.bag.CJBagItemTooltip;
	import SJ.Game.bag.CJItemTooltip;
	import SJ.Game.data.CJDataOfBag;
	import SJ.Game.data.CJDataOfItem;
	import SJ.Game.data.config.CJDataOfItemPackageProperty;
	import SJ.Game.data.config.CJDataOfItemProperty;
	import SJ.Game.data.json.Json_item_package_config;
	import SJ.Game.data.json.Json_item_setting;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.task.util.CJTaskHtmlUtil;
	
	import engine_starling.utils.AssetManagerUtil;
	
	import lib.engine.utils.CObjectUtils;
	import lib.engine.utils.functions.Assert;

	/**
	 * 道具背包工具类
	 * @author sangxu
	 * 
	 */	
	public class CJItemUtil
	{
		public function CJItemUtil()
		{
		}
		
		/**
		 * 是否可将道具装入背包，单个道具与数量
		 * @param bagData	背包数据, CJDataOfBag
		 * @param itemId	道具模板id
		 * @param count		道具数量
		 * @return 
		 * 
		 */		
		public static function canPutItemInBag(bagData:CJDataOfBag, tmplTempId:int, count:int):Boolean
		{
			// 背包中道具
			var containerItems:Array = bagData.itemsArray;
			// 背包已开启格数
			var bagOpenCount:int = bagData.bagCount;
			var emptyGridCount:int = bagOpenCount - containerItems.length;
			Assert(emptyGridCount >= 0, "emptyGridCount < 0");
			
			var templateSetting:CJDataOfItemProperty = CJDataOfItemProperty.o;
			var itemTemplate:Json_item_setting = templateSetting.getTemplate(tmplTempId);
			if (itemTemplate == null)
			{
				Assert(itemTemplate != null, "itemTemplate is not exist, id is " + tmplTempId);
				return false;
			}
			var maxCount:int = parseInt(itemTemplate.maxcount);
			var needGridCount:int =  Math.ceil(parseFloat(String(count)) / maxCount);
			if (emptyGridCount >= needGridCount)
			{
				return true;
			}
			if (maxCount == 1)
			{
				return false;
			}
			var curCount:int;
			for each(var item:CJDataOfItem in containerItems)
			{
				if (item.templateid == tmplTempId)
				{
					curCount = item.count
					if (curCount >= maxCount)
					{
						continue;
					}
					else
					{
						count -= (maxCount - curCount);
						if (count <= 0)
						{
							return true;
						}
					}
				}
			}
			
			if (count <= emptyGridCount * maxCount)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		/**
		 * 是否可以将道具装入背包，多个道具与数量
		 * @param bagData		背包数据, CJDataOfBag
		 * @param addItemData	将增加的道具数组，数组中为Object，["id"]道具模板id，["count"]道具数量
		 * @return 
		 * 
		 */		
		public static function canPutItemsInBag(bagData:CJDataOfBag, addItemData:Array):Boolean
		{
			// 背包中道具
			var itemsArray:Array = bagData.itemsArray;
			// 背包已开启格数
			var bagOpenCount:int = bagData.bagCount;
//			CJDataOfItem
			// 空格数量
			var emptyGridCount:int = bagOpenCount - itemsArray.length;
			Assert(emptyGridCount >= 0, "emptyGridCount < 0");
			
			var sumCount:int = 0;
			for each(var addItemTemp:Object in addItemData)
			{
				sumCount += addItemTemp["count"];
			}
			if (emptyGridCount >= sumCount)
			{
				// 空格数大于等于待装入总数量, 返回true
				return true;
			}
			
			// 拷贝道具
			var tempItems:Array = CObjectUtils.clone(itemsArray);
			var tmplTempId:int;
			var countTemp:int;
			var maxCountTemp:int
			var tmplTemp:Json_item_setting;
			var itemTempCount:int;
			var sumTemp:int;
			var needEmptyGrid:int;
			var leaveEmptyGrid:int;
			var templateSetting : CJDataOfItemProperty = CJDataOfItemProperty.o;
			for each(var addItem:Object in addItemData)
			{
				tmplTempId = addItem["id"];
				countTemp = addItem["count"];
				tmplTemp = templateSetting.getTemplate(tmplTempId);
				if (tmplTemp == null)
				{
					Assert(tmplTemp != null, "itemTemplate is not exist, id is " + tmplTempId);
					return false;
				}
				maxCountTemp = parseInt(tmplTemp.maxcount);
				for each(var itemTemp:Object in tempItems)
				{
					if (itemTemp.templateID == tmplTempId)
					{
						itemTempCount = itemTemp.count;
						if (itemTempCount < maxCountTemp)
						{
							sumTemp = itemTempCount + countTemp;
							if (sumTemp <= maxCountTemp)
							{
								itemTemp.count = sumTemp;
								countTemp = 0;
							}
						}
						else
						{
							itemTemp.count = maxCountTemp;
							countTemp = countTemp - (maxCountTemp - itemTempCount);
						}
						if (countTemp <= 0)
						{
							break;
						}
					}
				}
				if (countTemp > 0)
				{
					needEmptyGrid = Math.ceil(parseFloat(String(countTemp)) / maxCountTemp);
					leaveEmptyGrid = emptyGridCount - needEmptyGrid;
					if (leaveEmptyGrid < 0)
					{
						return false;
					}
					else
					{
						emptyGridCount = leaveEmptyGrid;
					}
				}
			}
			return true;
		}
		
		/**
		 * 获取礼包配置数据
		 * @param packageItemId	礼包道具id
		 * @return 
		 * 
		 */		
		public static function getPackageConfig(packageItemId:int):Array
		{
			var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonItemPackageConfig) as Array;
			if(obj == null)
			{
				return null;
			}
			var length:int = obj.length;
			var itemArray:Array = new Array();
			for(var i:int=0 ; i < length ; i++)
			{
				if (parseInt(obj[i]["packageitemid"]) == packageItemId)
				{
					var data:Json_item_package_config = new Json_item_package_config();
					data.loadFromJsonObject(obj[i]);
					itemArray.push(data);
				}
			}
			return itemArray;
		}
		
		/**
		 * 获取礼包道具中的配置道具信息
		 * @return 
		 * 
		 */		
		public static function getPackageData(itemTemplateId:int):Array
		{
			var pkgCfgArray:Array = CJItemUtil.getPackageConfig(itemTemplateId);
			var addItemArray:Array = new Array();
			var addData:Object;
			for each (var cfg:Json_item_package_config in pkgCfgArray)
			{
				addData = new Object();
				addData["id"] = parseInt(cfg.itemid);
				addData["count"] = parseInt(cfg.itemcount);
				addItemArray.push(addData);
			}
			return addItemArray;
		}
		
		/**
		 * 设置数字的单位
		 * @return 
		 * 
		 */		
		public static function getMoneyFormat(num:Number):String
		{
			var resultStr:String;
			if (num >= 100000)
			{
				num = int(num / 10000);
				resultStr = num + CJLang("MAIN_UI_MONEY_UINT_MYRIAD");
			}
			else
			{
				resultStr = String(int(num));
			}
			return resultStr;
		}
		
		/**
		 * 获取背包中道具描述 - html格式
		 * @param itemTemplateId
		 * @param count
		 * @return 
		 * 
		 */		
		public static function getPackageItemsDescHtml(itemTemplateId:String, count:int = 1, character:String = ", "):String
		{
			var _packageTemplateProperty:CJDataOfItemPackageProperty = CJDataOfItemPackageProperty.o;
			var _itemTemplateSetting:CJDataOfItemProperty = CJDataOfItemProperty.o;
			var showWord:String = "";
			var arrayPkgCfg:Array = _packageTemplateProperty.getPackageConfig(itemTemplateId);
			var getItemId:String = "";
			var getItemCount:int = 0;
			var itemTmplCfg:Json_item_setting;
			var index:int = 0;
			for each (var packageCfg:Json_item_package_config in arrayPkgCfg)
			{
				index++;
				getItemId = String(packageCfg.itemid);
				getItemCount = int(packageCfg.itemcount);
				
				itemTmplCfg = _itemTemplateSetting.getTemplate(int(getItemId));
				var tempText:String = CJTaskHtmlUtil.colorText(CJLang(itemTmplCfg.itemname) , CJTextFormatUtil.getQualityColorString(int(itemTmplCfg.quality))) 
					+ CJTaskHtmlUtil.colorText(" * " , "#FFFFFF")
					+ CJTaskHtmlUtil.colorText(String(getItemCount * count) , "#FFFFFF");
				showWord += tempText;
				
				if (index == arrayPkgCfg.length)
				{
					continue;
				}
				if (character == CJTaskHtmlUtil.br)
				{
					showWord += character;
				}
				else
				{
					showWord += CJTaskHtmlUtil.colorText(character , "#FFFFFF");
				}
				//CJTaskHtmlUtil.br
			}
			return showWord;
		}
		
		/**
		 * 显示背包中道具tooltips(CJItemTooltip) - 道具唯一id
		 * @param itemId	道具唯一id
		 * 
		 */
		public static function showBagItemTooltips(itemId:String):CJItemTooltip
		{
			var tooltipLayer:CJItemTooltip = new CJItemTooltip();
			tooltipLayer.setItemIdAndRefresh(ConstBag.CONTAINER_TYPE_BAG, itemId);
//			CJLayerManager.o.addModuleLayer(tooltipLayer);
			CJLayerManager.o.addToModalLayerFadein(tooltipLayer);
			return tooltipLayer;
		}
		
		/**
		 * 显示道具tooltips(CJItemTooltip) - 根据道具所在容器与道具id
		 * @param containerType	道具所在容器，目前仅为ConstBag.CONTAINER_TYPE_BAG
		 * @param itemId		道具唯一id
		 * 
		 */		
		public static function showItemTooltipsWithItemId(containerType:int, itemId:String):CJItemTooltip
		{
			var tooltipLayer:CJItemTooltip = new CJItemTooltip();
			tooltipLayer.setItemIdAndRefresh(containerType, itemId);
//			CJLayerManager.o.addModuleLayer(tooltipLayer);
			CJLayerManager.o.addToModalLayerFadein(tooltipLayer);
			return tooltipLayer;
		}
		
		/**
		 * 显示道具tooltips(CJItemTooltip) - 根据道具模板id
		 * @param itemTemplateId	道具模板id
		 * 
		 */		
		public static function showItemTooltipsWithTemplateId(itemTemplateId:int):CJItemTooltip
		{
			var tooltipLayer:CJItemTooltip = new CJItemTooltip();
			tooltipLayer.setItemTemplateIdAndRefresh(itemTemplateId);
//			CJLayerManager.o.addModuleLayer(tooltipLayer);
			CJLayerManager.o.addToModalLayerFadein(tooltipLayer);
			return tooltipLayer;
		}
		
		/**
		 * 显示背包用道具tooltips(CJBagItemTooltip) - 道具唯一id
		 * @param itemId	道具唯一id
		 * 
		 */		
		public static function showItemInBagTooltips(itemId:String):void
		{
			var tooltipLayer:CJBagItemTooltip = new CJBagItemTooltip();
			tooltipLayer.setItemIdAndRefresh(ConstBag.CONTAINER_TYPE_BAG, itemId);
			CJLayerManager.o.addModuleLayer(tooltipLayer);
		}
		
		/**
		 * 道具是否为礼包，包括普通礼包和等级礼包
		 * @param itemTemplate	道具模板数据，Json_item_setting
		 * @return 
		 * 
		 */		
		public static function isPackageItem(itemTemplate:Json_item_setting):Boolean
		{
			
			var subType:int = parseInt(itemTemplate.subtype)
			if (parseInt(itemTemplate.type) == ConstItem.SCONST_ITEM_TYPE_USE
				&& (subType == ConstItem.SCONST_ITEM_SUBTYPE_USE_PACKAGE
					|| subType == ConstItem.SCONST_ITEM_SUBTYPE_USE_LVPACKAGE))
			{
				return true;
			}
			return false;
		}
		
		/**
		 * 获取道具描述信息，礼包道具返回礼包内道具信息，其他道具返回道具模板道具名的中文内容
		 * @param tmplTempId
		 * @return 
		 * 
		 */		
		public static function getItemDescription(tmplTempId:String):String
		{
			var templateSetting:CJDataOfItemProperty = CJDataOfItemProperty.o;
			var itemTemplate:Json_item_setting = templateSetting.getTemplate(int(tmplTempId));
			if (isPackageItem(itemTemplate))
			{
				return getPackageItemsDescHtml(tmplTempId);
			}
			return CJLang(itemTemplate.itemname);
		}
	}
}