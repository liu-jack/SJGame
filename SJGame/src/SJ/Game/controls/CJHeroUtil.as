package SJ.Game.controls
{
	
	import SJ.Common.Constants.ConstItem;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfEnhanceEquip;
	import SJ.Game.data.CJDataOfEnhanceEquipConfigSingle;
	import SJ.Game.data.CJDataOfEnhanceHero;
	import SJ.Game.data.CJDataOfEquipmentbar;
	import SJ.Game.data.CJDataOfHero;
	import SJ.Game.data.CJDataOfHeroEquip;
	import SJ.Game.data.CJDataOfHeroList;
	import SJ.Game.data.CJDataOfInlayHero;
	import SJ.Game.data.CJDataOfInlayJewel;
	import SJ.Game.data.CJDataOfInlayPosition;
	import SJ.Game.data.CJDataOfItem;
	import SJ.Game.data.config.CJDataHeroProperty;
	import SJ.Game.data.config.CJDataOfEnhanceEquipProperty;
	import SJ.Game.data.config.CJDataOfHeroPropertyList;
	import SJ.Game.data.config.CJDataOfItemEquipProperty;
	import SJ.Game.data.config.CJDataOfItemJewelProperty;
	import SJ.Game.data.config.CJDataOfItemProperty;
	import SJ.Game.data.json.Json_hero_propertys;
	import SJ.Game.data.json.Json_item_equip_config;
	import SJ.Game.data.json.Json_item_jewel_config;
	import SJ.Game.data.json.Json_item_setting;
	
	import flash.utils.Dictionary;
	
	import lib.engine.utils.functions.Assert;

	/**
	 * 武将工具类
	 * @author sangxu
	 * 
	 */	
	public class CJHeroUtil
	{
		public function CJHeroUtil()
		{
		}
		
		/**
		 * 获取武将装备属性值
		 * 此方法调用前:
		 * 1.需加载服务器数据：
		 *   武将装备数据:SocketCommand_hero.get_puton_equip()
		 *   装备栏数据:SocketCommand_item.get_equipmentbar()
		 *   装备强化数据:SocketCommand_enhance.getEquipEnhanceInfo()
		 *   宝石镶嵌数据:SocketCommand_jewel.getInlayInfo()
		 * 2.加载配置文件:
		 *   道具装备配置文件:ConstResource.sResJsonItemEquipConfig
		 *   道具宝石配置文件:ConstResource.sResJsonItemJewelConfig
		 *   道具配置文件:ConstResource.sResItemSetting
		 *   装备强化配置文件:ConstResource.sResJsonEnhanceEquipConfig
		 * 否则返回Json_hero_propertys值均为空
		 * @param heroId 武将id
		 * @return Json_hero_propertys
		 * 
		 */		
		public static function getHeroEquipValueAll(heroId:String):Json_hero_propertys
		{
			var props:Json_hero_propertys = createJsonHeroPros();
			
			addHeroAllEquipValue(props, heroId);
			
			return props;
		}
		
		public static function getFriendHeroEquipValueAll(objData:Object, heroId:String):Json_hero_propertys
		{
			var props:Json_hero_propertys = createJsonHeroPros();
			
			// 装备数据
			// 参与计算的装备数组
			var equipItemArray:Array = new Array();
			// 武将装备id数组
			var arrayEquipItemId:Array = new Array();
			// 获取到的数据 - 武将装备id
			var objHeroEquip:Object = objData.heroEquipment[heroId];
			// 获取到的数据 - 装备栏道具
			var objEquip:Object = objData.equipmentbar;
			if (objHeroEquip != null)
			{
				arrayEquipItemId.push(objHeroEquip[ConstItem.SCONST_ITEM_POSITION_WEAPON],
					objHeroEquip[ConstItem.SCONST_ITEM_POSITION_HEAD],
					objHeroEquip[ConstItem.SCONST_ITEM_POSITION_CLOAK],
					objHeroEquip[ConstItem.SCONST_ITEM_POSITION_ARMOR],
					objHeroEquip[ConstItem.SCONST_ITEM_POSITION_SHOE],
					objHeroEquip[ConstItem.SCONST_ITEM_POSITION_BELT]);
			}
			var equipItemData:Object;
			for each (var equipItemId:String in arrayEquipItemId)
			{
				equipItemData = objEquip[equipItemId];
				if (equipItemData != null)
				{
					equipItemArray.push(_getCJItemDataByFriendData(equipItemData));
				}
			}
			
			// 镶嵌数据
			var inlayHero:CJDataOfInlayHero = new CJDataOfInlayHero();
			var dataInlayPos:CJDataOfInlayPosition;
			for each (var objHeroInlay:Object in objData.heroInlay)
			{
				if (String(objHeroInlay.heroid) == heroId)
				{
					dataInlayPos = new CJDataOfInlayPosition();
					dataInlayPos.heroid = String(objHeroInlay.heroid);
					dataInlayPos.positiontype = int(objHeroInlay.positiontype);
					dataInlayPos.userid = String(objHeroInlay.userid);
					dataInlayPos.holeitemid0 = String(objHeroInlay.holeitemid0);
					dataInlayPos.holeitemid1 = String(objHeroInlay.holeitemid1);
					dataInlayPos.holeitemid2 = String(objHeroInlay.holeitemid2);
					dataInlayPos.holeitemid3 = String(objHeroInlay.holeitemid3);
					dataInlayPos.holeitemid4 = String(objHeroInlay.holeitemid4);
					dataInlayPos.holeitemid5 = String(objHeroInlay.holeitemid5);
					inlayHero.setInlayPosition(dataInlayPos.positiontype, dataInlayPos);
				}
			}
			
			
			// 强化数据
			var dicEnhance:Dictionary = new Dictionary();
			var objEnhance:Object = objData.playerEnhanceEquip[heroId];
			if (objEnhance != null)
			{
				dicEnhance[ConstItem.SCONST_ITEM_POSITION_WEAPON] = int(objEnhance.weapon);
				dicEnhance[ConstItem.SCONST_ITEM_POSITION_HEAD] = int(objEnhance.helmet);
				dicEnhance[ConstItem.SCONST_ITEM_POSITION_CLOAK] = int(objEnhance.cloak);
				dicEnhance[ConstItem.SCONST_ITEM_POSITION_ARMOR] = int(objEnhance.armour);
				dicEnhance[ConstItem.SCONST_ITEM_POSITION_SHOE] = int(objEnhance.shoes);
				dicEnhance[ConstItem.SCONST_ITEM_POSITION_BELT] = int(objEnhance.belt);
			}
			
			// 宝石数据
			var dicJewel:Dictionary = new Dictionary();
			var jewelItem:CJDataOfItem;
			for each (var objJewelItem:Object in objData.inlayData)
			{
				jewelItem = _getCJItemDataByFriendData(objJewelItem);
				dicJewel[jewelItem.itemid] = jewelItem;
			}
			
			
			/* 计算武将装备属性值
			 * @param equipItemArray	装备数组(CJDataOfItem)
			 * @param inlayHero		武将镶嵌信息CJDataOfInlayHero <positionType, <holeIndex, jewelItemId>>
			 * @param dicEnhance	强化等级字典<positionType, enhanceLv>
			 * @param dicJewel		镶嵌孔中宝石数据字典<道具唯一id, CJDataOfItem>  */		
			calculateHeroEquipValue(props, equipItemArray, inlayHero, dicEnhance, dicJewel);
			
			return props;
		}
		/**
		 * 根据好友装备数据生成CJDataOfItem
		 * @param obj
		 * @return 
		 * 
		 */		
		private static function _getCJItemDataByFriendData(obj:Object):CJDataOfItem
		{
			var itemData:CJDataOfItem = new CJDataOfItem();
			itemData.itemid = obj.itemid;
			itemData.templateid = int(obj.templateid);
			itemData.count = int(obj.count);
			itemData.containertype = int(obj.containertype);
			itemData.addattrjin = int(obj.addattrjin);
			itemData.addattrmu = int(obj.addattrmu);
			itemData.addattrshui = int(obj.addattrshui);
			itemData.addattrhuo = int(obj.addattrhuo);
			itemData.addattrtu = int(obj.addattrtu);
			
			return itemData;
		}
		
		private static function createJsonHeroPros():Json_hero_propertys
		{
			var props:Json_hero_propertys = new Json_hero_propertys();
			// 金 - 力量 - 攻击
			props.strength = 0;
			// 木 - 体质 - 生命
			props.physique = 0;
			// 水 - 精神 - 法防
			props.spirit = 0;
			// 火 - 智力 - 法攻
			props.intelligence = 0;
			// 土 - 敏捷 - 物防
			props.agility = 0;
			
			// 生命
			props.hp = 0;
			// 物攻
			props.pattack = 0;
			// 物防
			props.pdef = 0;
			// 法攻
			props.mattack = 0;
			// 法防
			props.mdef = 0;
			
			// 暴击
			props.crit = 0;
			// 韧性
			props.toughness = 0;
			// 闪避
			props.dodge = 0;
			// 命中
			props.hit = 0;
			// 法术免疫
			props.mimmuno = 0;
			// 法术穿透
			props.mpassthrough = 0;
			// 吸血
			props.blood = 0;
			// 法爆
			props.mcrit = 0;
			// 法韧
			props.mtoughness = 0;
			// 治疗效果
			props.cure = 0;
			// 减伤
			props.reducehurt = 0;
			// 伤害加深
			props.inchurt = 0;
			
			// others, 非装备中需计算属性, 为方便计算需赋值
			//			props.hpgrow = 0;
			//			props.pattackgrow = 0;
			//			props.mattackgrow = 0;
			//			props.pdefgrow = 0;
			//			props.mdefgrow = 0;
			//			props.speedgrow = 0;
			props.speed = 0;
			props.leadervalue = 0;
			return props;
		}
		
		/**
		 * 计算武将装备属性值
		 * 此方法调用前:
		 * 1.需加载服务器数据：
		 *   武将装备数据:SocketCommand_hero.get_puton_equip()
		 *   装备栏数据:SocketCommand_item.get_equipmentbar()
		 *   装备强化数据:SocketCommand_enhance.getEquipEnhanceInfo()
		 *   宝石镶嵌数据:SocketCommand_jewel.getInlayInfo()
		 * 2.加载配置文件:
		 *   道具装备配置文件:ConstResource.sResJsonItemEquipConfig
		 *   道具宝石配置文件:ConstResource.sResJsonItemJewelConfig
		 *   道具配置文件:ConstResource.sResItemSetting
		 *   装备强化配置文件:ConstResource.sResJsonEnhanceEquipConfig
		 * @param props		属性值载体类
		 * @param heroId	武将id
		 * 
		 */		
		public static function addHeroAllEquipValue(props:Json_hero_propertys, heroId:String):void
		{
			// 武将装备数据
			var heroequip:CJDataOfHeroEquip = CJDataManager.o.DataOfHeroEquip;
			if (heroequip.dataIsEmpty)
			{
				Assert(false, "function addHeroAllEquipValue. CJDataOfHeroEquip is empty! heroId is:" + heroId);
				return;
			}
			// 当前武将对应装备数据
			var heroEquipObj:Object = heroequip.heroEquipObj[heroId];
			if (heroEquipObj == null)
			{
				Assert(false, "function addHeroAllEquipValue. hero equip is null! heroId is:" + heroId);
				return;
			}
			
			// 装备栏数据
			var equipbar:CJDataOfEquipmentbar = CJDataManager.o.DataOfEquipmentbar;
			if (equipbar.dataIsEmpty)
			{
				Assert(false, "function addHeroAllEquipValue. CJDataOfEquipmentbar is empty! heroId is:" + heroId);
				return;
			}
			
			// 装备强化信息
			var equipEnhance:CJDataOfEnhanceEquip = CJDataManager.o.DataOfEnhanceEquip;
			if (equipEnhance.dataIsEmpty)
			{
				Assert(false, "function addHeroAllEquipValue. CJDataOfEnhanceEquip is empty! heroId is:" + heroId);
				return;
			}
			var heroEnhance:CJDataOfEnhanceHero = equipEnhance.getHeroEnhanceInfo(heroId);
			Assert(heroEnhance != null, "equip hero enhance data is null, hero id is:" + heroId);
			
			// 宝石镶嵌
			var jewelInlay:CJDataOfInlayJewel = CJDataManager.o.DataOfInlayJewel;
			if (jewelInlay.dataIsEmpty)
			{
				Assert(false, "function addHeroAllEquipValue. CJDataOfInlayJewel is empty! heroId is:" + heroId);
				return;
			}
			
			// 装备数组(CJDataOfItem)
			var equipItemArray:Array = new Array();
			var itemWeapon:CJDataOfItem = equipbar.getEquipbarItem(heroEquipObj[ConstItem.SCONST_ITEM_POSITION_WEAPON]);
			var itemHead:CJDataOfItem = equipbar.getEquipbarItem(heroEquipObj[ConstItem.SCONST_ITEM_POSITION_HEAD]);
			var itemCloak:CJDataOfItem = equipbar.getEquipbarItem(heroEquipObj[ConstItem.SCONST_ITEM_POSITION_CLOAK]);
			var itemArmor:CJDataOfItem = equipbar.getEquipbarItem(heroEquipObj[ConstItem.SCONST_ITEM_POSITION_ARMOR]);
			var itemShoe:CJDataOfItem = equipbar.getEquipbarItem(heroEquipObj[ConstItem.SCONST_ITEM_POSITION_SHOE]);
			var itemBelt:CJDataOfItem = equipbar.getEquipbarItem(heroEquipObj[ConstItem.SCONST_ITEM_POSITION_BELT]);
			equipItemArray.push(itemWeapon, itemHead, itemCloak, itemArmor, itemShoe, itemBelt);
			
			// 武将镶嵌信息<positionType, <holeIndex, jewelItemId>>
			var inlayHero:CJDataOfInlayHero = jewelInlay.getHeroInlayInfo(heroId);
			// 强化等级字典<positionType, enhanceLv>
			var dicEnhance:Dictionary = _getDictEnhance(heroEnhance);
			// 镶嵌孔中宝石数据字典<道具唯一id, CJDataOfItem>
			var dicJewel:Dictionary = equipbar.getHoleItemDic();
			
			calculateHeroEquipValue(props, equipItemArray, inlayHero, dicEnhance, dicJewel);
		}
		
		
		
		/**
		 * 计算武将装备属性值
		 * @param props		属性值载体类
		 * @param equipItemArray	装备数组(CJDataOfItem)
		 * @param inlayHero		武将镶嵌信息CJDataOfInlayHero <positionType, <holeIndex, jewelItemId>>
		 * @param dicEnhance	强化等级字典<positionType, enhanceLv>
		 * @param dicJewel		镶嵌孔中宝石数据字典<道具唯一id, CJDataOfItem>
		 * 
		 */		
		public static function calculateHeroEquipValue(props:Json_hero_propertys, 
													   equipItemArray:Array,
													   inlayHero:CJDataOfInlayHero,
													   dicEnhance:Dictionary,
													   dicJewel:Dictionary):void
		{
			var equipTmpl:Json_item_equip_config;
			var jewelTmpl:Json_item_jewel_config;
			var itemTmpl:Json_item_setting;
			var enhanceTmpl:CJDataOfEnhanceEquipConfigSingle;
			
			// 道具装备配置文件
			var equipProperty:CJDataOfItemEquipProperty = CJDataOfItemEquipProperty.o;
			// 道具宝石配置文件
			var jewelProperty:CJDataOfItemJewelProperty = CJDataOfItemJewelProperty.o;
			// 道具配置文件
			var itemProperty:CJDataOfItemProperty = CJDataOfItemProperty.o;
			// 装备强化配置文件
			var enhanceProperty:CJDataOfEnhanceEquipProperty = CJDataOfEnhanceEquipProperty.o;
			
			var jewelItemIdArray:Array;
			var holeItemData:CJDataOfItem;
			var enhanceLv:int = 0;
			var enhanceRate:Number = 0;
			var inlayPosition:CJDataOfInlayPosition;
			for each (var itemInfo:CJDataOfItem in equipItemArray)
			{
				if (itemInfo == null)
				{
					continue;
				}
				equipTmpl = equipProperty.getItemEquipConfigById(itemInfo.templateid);
				Assert(equipTmpl != null, "equip config is null, item template id is:" + itemInfo.templateid);
				itemTmpl = itemProperty.getTemplate(itemInfo.templateid);
				Assert(equipTmpl != null, "item template is null, item template id is:" + itemInfo.templateid);
				
				// 装备模板数据
				props.hp += int(equipTmpl.shengmingadd);
				props.pattack += parseInt(equipTmpl.wugongadd);
				props.pdef += parseInt(equipTmpl.wufangadd);
				props.mattack += parseInt(equipTmpl.fagongadd);
				props.mdef += parseInt(equipTmpl.fafangadd);
				
				
				// 装备强化
//				enhanceLv = _getEnhanceLv(int(itemTmpl.positiontype), heroEnhance);
				enhanceLv = int(dicEnhance[String(itemTmpl.positiontype)]);
				if (enhanceLv > 0)
				{
					enhanceTmpl = enhanceProperty.getConfigDataByLevel(enhanceLv);
					enhanceRate = Number(enhanceTmpl.addPropRate) / 10000;
					
					props.hp += props.hp * enhanceRate;
					props.pattack += props.pdef * enhanceRate;
					props.pdef += props.pdef * enhanceRate;
					props.mattack += props.mattack * enhanceRate;
					props.mdef += props.mdef * enhanceRate;
				}
				
				// 装备洗练属性
				// 金
				props.strength += itemInfo.addattrjin;
				// 木
				props.physique += itemInfo.addattrmu;
				// 水
				props.spirit += itemInfo.addattrshui;
				// 火
				props.intelligence += itemInfo.addattrhuo;
				// 土
				props.agility += itemInfo.addattrtu;
				props.crit += itemInfo.addattrbaoji;
				props.toughness += itemInfo.addattrrenxing;
				props.dodge += itemInfo.addattrshanbi;
				props.hit += itemInfo.addattrmingzhong;
				props.cure += itemInfo.addattrzhiliao;
				props.reducehurt += itemInfo.addattrjianshang;
				props.blood += itemInfo.addattrxixue;
				props.inchurt += itemInfo.addattrshanghai;
				
				
			}
			// 装备位镶嵌的宝石
			for each (var positionType:uint in ConstItem.SCONST_ITEM_POSITION_ALL)
			{
				_addInlayHeroValue(props, inlayHero, positionType, dicJewel);
			}
		}
		
		/**
		 * 生成武将强化对应的Dictionary<装备位, 该装备位强化等级>
		 * @param heroEnhance
		 * @return 
		 * 
		 */		
		private static function _getDictEnhance(heroEnhance:CJDataOfEnhanceHero):Dictionary
		{
			var dicEnhance:Dictionary = new Dictionary();
			if (heroEnhance != null)
			{
				dicEnhance[String(ConstItem.SCONST_ITEM_SUBTYPE_WEAPON)] = heroEnhance.weapon;
				dicEnhance[String(ConstItem.SCONST_ITEM_SUBTYPE_HELMET)] = heroEnhance.head;
				dicEnhance[String(ConstItem.SCONST_ITEM_SUBTYPE_ARMOUR)] = heroEnhance.armour;
				dicEnhance[String(ConstItem.SCONST_ITEM_SUBTYPE_CLOAK)] = heroEnhance.cloak;
				dicEnhance[String(ConstItem.SCONST_ITEM_SUBTYPE_SHOES)] = heroEnhance.shoe;
				dicEnhance[String(ConstItem.SCONST_ITEM_SUBTYPE_BELT)] = heroEnhance.belt;
			}
			else
			{
				dicEnhance[String(ConstItem.SCONST_ITEM_SUBTYPE_WEAPON)] = 0;
				dicEnhance[String(ConstItem.SCONST_ITEM_SUBTYPE_HELMET)] = 0;
				dicEnhance[String(ConstItem.SCONST_ITEM_SUBTYPE_ARMOUR)] = 0;
				dicEnhance[String(ConstItem.SCONST_ITEM_SUBTYPE_CLOAK)] = 0;
				dicEnhance[String(ConstItem.SCONST_ITEM_SUBTYPE_SHOES)] = 0;
				dicEnhance[String(ConstItem.SCONST_ITEM_SUBTYPE_BELT)] = 0;
			}
			return dicEnhance;
		}
		
		/**
		 * 计算并增加武将装备位镶嵌宝石属性值
		 * @param props		属性值载体类
		 * @param inlayHero	武将镶嵌数据
		 * @param positionType	装备位
		 * @param dicJewel	孔中宝石字典<宝石道具唯一id, CJDataOfItem>
		 * @return 
		 * 
		 */		
		private static function _addInlayHeroValue(props:Json_hero_propertys, 
												   inlayHero:CJDataOfInlayHero, 
												   positionType:int,
												   dicJewel:Dictionary):void
		{
			var inlayPosition:CJDataOfInlayPosition;
			// 装备位宝石镶嵌
			inlayPosition = inlayHero.getInlayPosition(positionType);
			if (null == inlayPosition)
			{
				return;
			}
			var jewelItemId:String = "";
			if (null == inlayPosition)
				return;
			
//			// 装备栏数据
//			var equipbar:CJDataOfEquipmentbar = CJDataManager.o.DataOfEquipmentbar;
//			if (equipbar.dataIsEmpty)
//			{
//				return;
//			}
			var jewelItemData:CJDataOfItem;
			
			for (var i:int = inlayPosition.holeIndexMin; i <= inlayPosition.holeIndexMax; i++)
			{
				jewelItemId = inlayPosition.getHoleItemId(String(i));
//				jewelItemData = equipbar.getHoleItem(jewelItemId);
				jewelItemData = dicJewel[String(jewelItemId)];
				if (jewelItemData != null)
				{
					_addJewelValue(props, jewelItemData);
				}
			}
			return;
		}
		
		/**
		 * 增加宝石道具属性值
		 * @param props		属性值载体类
		 * @param jewelItem	宝石道具数据
		 * 
		 */		
		private static function _addJewelValue(props:Json_hero_propertys, jewelItem:CJDataOfItem):void
		{
			if (jewelItem == null)
			{
				return;
			}
			var jewelProperty:CJDataOfItemJewelProperty = CJDataOfItemJewelProperty.o;
			var jewelTmpl:Json_item_jewel_config = jewelProperty.getItemJewelConfigById(jewelItem.templateid);
			
			// 暴击
			props.crit += int(jewelTmpl.baojiadd);
			// 韧性
			props.toughness += int(jewelTmpl.renxingadd);
			// 闪避
			props.dodge += int(jewelTmpl.shanbiadd);
			// 命中
			props.hit += int(jewelTmpl.mingzhongadd);
			
			// 金
			props.strength += int(jewelTmpl.jinadd);
			// 木
			props.physique += int(jewelTmpl.muadd);
			// 水
			props.spirit += int(jewelTmpl.shuiadd);
			// 火
			props.intelligence += int(jewelTmpl.huoadd);
			// 土
			props.agility += int(jewelTmpl.tuadd);
			
			//法术免疫
			props.mimmuno += int(jewelTmpl.famianadd);
			//法术穿透
			props.mpassthrough += int(jewelTmpl.fachuanadd);
			//吸血
			props.blood += int(jewelTmpl.xixueadd);
			//法爆
			props.mcrit += int(jewelTmpl.fabaoadd);
			//法韧
			props.mtoughness += int(jewelTmpl.farenadd);
			//治疗效果
			props.cure += int(jewelTmpl.zhiliaoxiaoguoadd);
			//减伤
			props.reducehurt += int(jewelTmpl.jianshangadd);
			//伤害加深
			props.inchurt += int(jewelTmpl.shanghaijiashenadd);
		}
		
		/**
		 * 根据装备子类型，返回武将装备位强化信息
		 * @param subType
		 * @param heroEnhance
		 * @return 
		 * 
		 */		
		private static function _getEnhanceLv(positionType:int, heroEnhance:CJDataOfEnhanceHero):int
		{
			switch(positionType)
			{
				case ConstItem.SCONST_ITEM_SUBTYPE_WEAPON:
					return heroEnhance.weapon;
				case ConstItem.SCONST_ITEM_SUBTYPE_HELMET:
					return heroEnhance.head;
				case ConstItem.SCONST_ITEM_SUBTYPE_ARMOUR:
					return heroEnhance.armour;
				case ConstItem.SCONST_ITEM_SUBTYPE_CLOAK:
					return heroEnhance.cloak;
				case ConstItem.SCONST_ITEM_SUBTYPE_SHOES:
					return heroEnhance.shoe;
				case ConstItem.SCONST_ITEM_SUBTYPE_BELT:
					return heroEnhance.belt;
			}
			return 0;
		}
		
		/**
		 * 获取单个武将属性值
		 * 此方法调用前:
		 * 1.需加载武将装备数据，SocketCommand_hero.get_puton_equip()
		 * 2.需加载装备栏数据,SocketCommand_item.get_equipmentbar()
		 * 3.需加载武将数据,SocketCommand_hero.get_heros()
		 * 4.需加载道具装备配置文件,ConstResource.sResJsonItemEquipConfig
		 * 5.需加载道具宝石配置文件,ConstResource.sResJsonItemJewelConfig
		 * 6.需加载道具武将模板配置文件,ConstResource.sResHeroPropertys
		 * 加载升级配置文件，ConstResource.sResJsonUpgrade
		 * 否则返回Json_hero_propertys值均为空
		 * @param heroId 武将id
		 * @return Json_hero_propertys
		 * 
		 */		
		public static function getHeroPropValueAll(heroId:String):Json_hero_propertys
		{
			var calculator:CJHeroPropsCalculator = new CJHeroPropsCalculator(heroId);
			calculator.calculateProps();
			var props:Json_hero_propertys = calculator.getHeroPropertys();
			return props;
		}
		
		/**
		 * 好友武将属性值
		 * @param heroId	武将id
		 * @param data		服务器传到客户端的当前好友所有数据
		 * @return Json_hero_propertys
		 * 
		 */		
		public static function getOthersHeroPropValueAll(heroId:String, data:Object):Json_hero_propertys
		{
			var calculator:CJHeroPropsCalculator = new CJHeroPropsCalculator(heroId, false, data);
			calculator.calculateProps();
			var props:Json_hero_propertys = calculator.getHeroPropertys();
			return props;
		}
		
//		/**
//		 * TODO longtao武将界面需要使用以下计算公式，
//		 * 待修改武将界面物攻、物防等显示内容后删除以下注释内容
//		 */		
//		public static function getHeroPropValueAllToShow(heroId:String):Json_hero_propertys
//		{
//			var calculator:CJHeroPropsCalculator = new CJHeroPropsCalculator(heroId);
//			calculator.calculateProps();
//			var props:Json_hero_propertys = calculator.getHeroPropertys();
//			// 生命 = 基础生命 * 木(体质)
//			props.hp = props.hp * props.physique;
//			// 物攻 = 基础物攻 * 金(力量)
//			props.pattack = props.pattack * props.strength;
//			// 法攻 = 基础法攻 * 火(智力)
//			props.mattack = props.mattack * props.intelligence;
//			// 物防 = 基础物防 * 土(敏捷)
//			props.pdef = props.pdef * props.agility;
//			// 法防 = 基础法防 * 水(精神)
//			props.mdef = props.mdef * props.spirit;
//			return props;
//		}
	}
}