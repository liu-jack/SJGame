package SJ.Game.controls
{
	
	import SJ.Common.Constants.ConstHero;
	import SJ.Common.Constants.ConstItem;
	import SJ.Game.data.CJDataOfEnhanceEquipConfigSingle;
	import SJ.Game.data.CJDataOfHero;
	import SJ.Game.data.CJDataOfHorse;
	import SJ.Game.data.CJDataOfItem;
	import SJ.Game.data.config.CJDataHeroProperty;
	import SJ.Game.data.config.CJDataOfBattleEffectProperty;
	import SJ.Game.data.config.CJDataOfEnhanceEquipProperty;
	import SJ.Game.data.config.CJDataOfGlobalConfigProperty;
	import SJ.Game.data.config.CJDataOfHeroDictConfig;
	import SJ.Game.data.config.CJDataOfHeroPropertyList;
	import SJ.Game.data.config.CJDataOfItemEquipProperty;
	import SJ.Game.data.config.CJDataOfItemJewelProperty;
	import SJ.Game.data.config.CJDataOfItemProperty;
	import SJ.Game.data.config.CJDataOfPSkillProperty;
	import SJ.Game.data.json.Json_enhance_equip_config;
	import SJ.Game.data.json.Json_hero_propertys;
	import SJ.Game.data.json.Json_horsebaseinfo;
	import SJ.Game.data.json.Json_item_equip_config;
	import SJ.Game.data.json.Json_item_jewel_config;
	import SJ.Game.data.json.Json_item_setting;
	import SJ.Game.data.json.Json_pskill_setting;
	import SJ.Game.data.json.Json_zhandouli_setting;
	
	import lib.engine.utils.functions.Assert;

	/**
	 * 战斗力工具类
	 * @author sangxu
	 * 
	 */	
	public class CJBattleEffectUtil
	{
		public function CJBattleEffectUtil()
		{
		}
		
		/**
		 * 根据道具数据获取装备战斗力
		 * @param itemData
		 * @return 
		 * 
		 */		
		public static function getEquipValue(itemData:CJDataOfItem):int
		{
			var value:Number = 0;
			value += _getEquipTemplateValueBase(itemData.templateid);
			
			value += itemData.addattrjin * _getBattleEffectValue(ConstHero.HERO_PROP_JIN);
			value += itemData.addattrmu * _getBattleEffectValue(ConstHero.HERO_PROP_MU);
			value += itemData.addattrshui * _getBattleEffectValue(ConstHero.HERO_PROP_SHUI);
			value += itemData.addattrhuo * _getBattleEffectValue(ConstHero.HERO_PROP_HUO);
			value += itemData.addattrtu * _getBattleEffectValue(ConstHero.HERO_PROP_TU);
			
			if (int(CJDataOfGlobalConfigProperty.o.getData("BATTLEEFFECT_SQRT")) == ConstItem.SCONST_BATTLE_EFFECT_SQRT)
			{
				// 战斗力数值开方
				value = Math.sqrt(value);
			}
			
			var intValue:int = int(value);
			
			return intValue;
		}
		
		/**
		 * 获取装备战斗力
		 * @param itemTemplateId
		 * @return 
		 * 
		 */		
		public static function getEquipTemplateValue(itemTemplateId:int):int
		{
			var intValue:int = _getEquipTemplateValueBase(itemTemplateId);
			
			if (int(CJDataOfGlobalConfigProperty.o.getData("BATTLEEFFECT_SQRT")) == ConstItem.SCONST_BATTLE_EFFECT_SQRT)
			{
				// 战斗力数值开方
				intValue = Math.sqrt(intValue);
			}
			
			return intValue;
		}
		
		private static function _getEquipTemplateValueBase(itemTemplateId:int):int
		{
			var value:Number = 0;
			var equipTmpl:Json_item_equip_config = _getItemEquipTemplate(itemTemplateId);
			if (equipTmpl == null)
			{
				return 0;
			}
			value += int(equipTmpl.shengmingadd) * _getBattleEffectValue(ConstHero.HERO_PROP_SHENGMING);
			value += int(equipTmpl.wugongadd) * _getBattleEffectValue(ConstHero.HERO_PROP_WUGONG);
			value += int(equipTmpl.wufangadd) * _getBattleEffectValue(ConstHero.HERO_PROP_WUFANG);
			value += int(equipTmpl.fagongadd) * _getBattleEffectValue(ConstHero.HERO_PROP_FAGONG);
			value += int(equipTmpl.fafangadd) * _getBattleEffectValue(ConstHero.HERO_PROP_FAFANG);
			
			var intValue:int = int(value);
			
			return intValue;
		}
		
//		public static function getEquipTemplateValueWithEnhance(itemTemplateId:int, enhanceLv:int):Number
//		{
//			var value:Number = 0;
//			var equipTmpl:Json_item_equip_config = _getItemEquipTemplate(itemTemplateId);
//			if (equipTmpl == null)
//			{
//				return 0;
//			}
//			var enhanceTmpl:CJDataOfEnhanceEquipConfigSingle = _getEhanceTemplate(enhanceLv);
//			var rate:Number = (enhanceTmpl.addPropRate / 10000) + 1;
//			
//			value += int(equipTmpl.shengmingadd)  * _getBattleEffectValue(ConstHero.HERO_PROP_SHENGMING);
//			value += int(equipTmpl.wugongadd) * _getBattleEffectValue(ConstHero.HERO_PROP_WUGONG);
//			value += int(equipTmpl.wufangadd) * _getBattleEffectValue(ConstHero.HERO_PROP_WUFANG);
//			value += int(equipTmpl.fagongadd) * _getBattleEffectValue(ConstHero.HERO_PROP_FAGONG);
//			value += int(equipTmpl.fafangadd) * _getBattleEffectValue(ConstHero.HERO_PROP_FAFANG);
//			
//			return value;
//		}
		
		/**
		 * 获取宝石战斗力
		 * @param itemTemplateId
		 * @return 
		 * 
		 */		
		public static function getJewelTemplateValue(itemTemplateId:int):int
		{
			var value:Number = 0;
			var jewelTmpl:Json_item_jewel_config = _getItemJewelTemplate(itemTemplateId);
			if (jewelTmpl == null)
			{
				return 0;
			}
			
			value += int(jewelTmpl.baojiadd) * _getBattleEffectValue(ConstHero.HERO_PROP_BAOJI);
			value += int(jewelTmpl.renxingadd) * _getBattleEffectValue(ConstHero.HERO_PROP_RENXING);
			value += int(jewelTmpl.shanbiadd) * _getBattleEffectValue(ConstHero.HERO_PROP_SHANBI);
			value += int(jewelTmpl.mingzhongadd) * _getBattleEffectValue(ConstHero.HERO_PROP_MINGZHONG);
			//法术免疫
			//法术穿透
			//吸血
			//法爆
			//法韧
			//治疗效果
			//减伤
			//伤害加深
			value += int(jewelTmpl.jinadd) * _getBattleEffectValue(ConstHero.HERO_PROP_JIN);
			value += int(jewelTmpl.muadd) * _getBattleEffectValue(ConstHero.HERO_PROP_MU);
			value += int(jewelTmpl.shuiadd) * _getBattleEffectValue(ConstHero.HERO_PROP_SHUI);
			value += int(jewelTmpl.huoadd) * _getBattleEffectValue(ConstHero.HERO_PROP_HUO);
			value += int(jewelTmpl.tuadd) * _getBattleEffectValue(ConstHero.HERO_PROP_TU);
			
			if (int(CJDataOfGlobalConfigProperty.o.getData("BATTLEEFFECT_SQRT")) == ConstItem.SCONST_BATTLE_EFFECT_SQRT)
			{
				// 战斗力数值开方
				value = Math.sqrt(value);
			}
			
			var intValue:int = int(value);
			return intValue;
		}
		
		/**
		 * 获取坐骑战斗力
		 * @param horseTmplId	坐骑模板id
		 * @return 
		 * 
		 */		
		public static function getHorseTemplateValue(horseTmplId:int):int
		{
			var value:Number = 0;
			var horseTmpl:Json_horsebaseinfo = _getHorseTemplate(horseTmplId);
			if (horseTmpl == null)
			{
				return 0;
			}
			value += int(horseTmpl.metalbonusrate) * _getBattleEffectValue(ConstHero.HERO_PROP_JIN);
			value += int(horseTmpl.woodbonusrate) * _getBattleEffectValue(ConstHero.HERO_PROP_MU);
			value += int(horseTmpl.waterbonusrate) * _getBattleEffectValue(ConstHero.HERO_PROP_SHUI);
			value += int(horseTmpl.firebonusrate) * _getBattleEffectValue(ConstHero.HERO_PROP_HUO);
			value += int(horseTmpl.earthbonusrate) * _getBattleEffectValue(ConstHero.HERO_PROP_TU);
			
			if (int(CJDataOfGlobalConfigProperty.o.getData("BATTLEEFFECT_SQRT")) == ConstItem.SCONST_BATTLE_EFFECT_SQRT)
			{
				// 战斗力数值开方
				value = Math.sqrt(value);
			}
			var intValue:int = int(value);
			
			return intValue;
		}
		
		/**
		 * 获取武将战斗力
		 * 此方法调用前:
		 * 1.需加载服务器数据：
		 *   武将装备数据:SocketCommand_hero.get_puton_equip()
		 *   装备栏数据:SocketCommand_item.get_equipmentbar()
		 *   装备强化数据:SocketCommand_enhance.getEquipEnhanceInfo()
		 *   宝石镶嵌数据:SocketCommand_jewel.getInlayInfo()
		 *   x坐骑数据
		 *   x武将列表
		 *   x被动技能
		 * 2.加载配置文件:
		 *   道具装备配置文件:ConstResource.sResJsonItemEquipConfig
		 *   道具宝石配置文件:ConstResource.sResJsonItemJewelConfig
		 *   道具配置文件:ConstResource.sResItemSetting
		 *   装备强化配置文件:ConstResource.sResJsonEnhanceEquipConfig
		 *   战斗力系数配置文件:ConstResource.sResBattleEffectSetting
		 *   被动技能配置文件:ConstResource.sResPSkillSetting
		 *   升级配置文件，ConstResource.sResJsonUpgrade
		 *   x坐骑
		 *   x武将配置
		 * @param heroData
		 * @return 
		 * 
		 */		
		public static function getHeroValue(heroData:CJDataOfHero):int
		{
			var heroTmplId:int = heroData.templateid;
//			var levelValue:int = int(heroData.level) - 1;
//			var pSkillId:String = heroData.currenttalent;
			
			var value:Number = 0;
			var heroTmpl:CJDataHeroProperty = _getHeroTemplate(heroTmplId);
			if (heroTmpl == null)
			{
				return 0;
			}
//			var pskillTmpl:Json_pskill_setting = _getPSkillTemplate(pSkillId);
			
			var prop:Json_hero_propertys = CJHeroUtil.getHeroPropValueAll(heroData.heroid);
			
//			CJHeroUtil.addHeroAllEquipValue(prop, heroData.heroid);
			// 受被动技能影响:生命,物攻,物防,法攻,法防
			// 装备:生命,物攻,物防,法攻,法防
			// 宝石:金木水火土, 暴击,韧性,闪避,命中
			// 坐骑：金木水火土
			
			// 生命
			value += prop.hp * _getBattleEffectValue(ConstHero.HERO_PROP_SHENGMING);
			
			var heroJob:int = int(heroTmpl.job);
			if (heroJob == ConstHero.constHeroJobFighter || heroJob == ConstHero.constHeroJobArcher)
			{
				// 物攻
				value += prop.pattack * _getBattleEffectValue(ConstHero.HERO_PROP_WUGONG);
			}
			else 
			{
				// 法攻
				value += prop.mattack * _getBattleEffectValue(ConstHero.HERO_PROP_FAGONG);
			}
			
			// 物防
			value += prop.pdef * _getBattleEffectValue(ConstHero.HERO_PROP_WUFANG);
			// 法防
			value += prop.mdef * _getBattleEffectValue(ConstHero.HERO_PROP_FAFANG);
			
			// 命中
			value += prop.hit * _getBattleEffectValue(ConstHero.HERO_PROP_MINGZHONG);
			// 闪避
			value += prop.dodge * _getBattleEffectValue(ConstHero.HERO_PROP_SHANBI);
			// 暴击
			value += prop.crit * _getBattleEffectValue(ConstHero.HERO_PROP_BAOJI);
			// 韧性
			value += prop.toughness * _getBattleEffectValue(ConstHero.HERO_PROP_RENXING);
			// 治疗效果
			value += prop.cure * _getBattleEffectValue(ConstHero.HERO_PROP_ZHILIAOXIAOGUO);
			// 减伤
			value += prop.reducehurt * _getBattleEffectValue(ConstHero.HERO_PROP_JIANSHANG);
			// 伤害加深
			value += prop.inchurt * _getBattleEffectValue(ConstHero.HERO_PROP_SHANGHAIJIASHEN);
			
			if (int(CJDataOfGlobalConfigProperty.o.getData("BATTLEEFFECT_SQRT")) == ConstItem.SCONST_BATTLE_EFFECT_SQRT)
			{
				// 战斗力数值开方
				value = Math.sqrt(value);
			}
			
			var intValue:int = int(value);
			
			return intValue;
		}
		
		/**
		 * 获取属性id对应的战斗力系数
		 * @param propId 属性id
		 * @return 
		 * 
		 */		
		private static function _getBattleEffectValue(propId:int):Number
		{
			var beTmpl:Json_zhandouli_setting = _getBattleEffectTemplate(propId);
			if (beTmpl != null)
			{
				return Number(beTmpl.value);
			}
			return 0;
		}
		
		
		
		/**
		 * 获取战斗力配置
		 * @param id	属性id
		 * @return 
		 * 
		 */		
		private static function _getBattleEffectTemplate(id:int):Json_zhandouli_setting
		{
			var templateSetting:CJDataOfBattleEffectProperty = CJDataOfBattleEffectProperty.o;
			var template:Json_zhandouli_setting = templateSetting.getBattleEffect(id);
			if (template == null)
			{
				Assert(template != null, "Battle effect template is not exist, id is " + id);
				return null;
			}
			return template;
		}
		
		/**
		 * 获取道具模板
		 * @param tmplTempId	道具模板id
		 * @return 
		 * 
		 */		
		private static function _getItemTemplate(tmplTempId:int):Json_item_setting
		{
			var templateSetting:CJDataOfItemProperty = CJDataOfItemProperty.o;
			var itemTemplate:Json_item_setting = templateSetting.getTemplate(tmplTempId);
			if (itemTemplate == null)
			{
				Assert(itemTemplate != null, "Item template is not exist, id is " + tmplTempId);
				return null;
			}
			return itemTemplate;
		}
		
		/**
		 * 获取装备道具模板
		 * @param tmplTempId	道具模板id
		 * @return 
		 * 
		 */		
		private static function _getItemEquipTemplate(tmplTempId:int):Json_item_equip_config
		{
			var templateSetting:CJDataOfItemEquipProperty = CJDataOfItemEquipProperty.o;
			var itemTemplate:Json_item_equip_config = templateSetting.getItemEquipConfigById(tmplTempId);
			if (itemTemplate == null)
			{
				Assert(itemTemplate != null, "Item equip template is not exist, id is " + tmplTempId);
				return null;
			}
			return itemTemplate;
		}
		
		/**
		 * 获取宝石道具模板
		 * @param tmplTempId	道具模板id
		 * @return 
		 * 
		 */		
		private static function _getItemJewelTemplate(tmplTempId:int):Json_item_jewel_config
		{
			var templateSetting:CJDataOfItemJewelProperty = CJDataOfItemJewelProperty.o;
			var itemTemplate:Json_item_jewel_config = templateSetting.getItemJewelConfigById(tmplTempId);
			if (itemTemplate == null)
			{
				Assert(itemTemplate != null, "Item jewel template is not exist, id is " + tmplTempId);
				return null;
			}
			return itemTemplate;
		}
		
		/**
		 * 获取坐骑模板
		 * @param tmplTempId	坐骑模板id
		 * @return 
		 * 
		 */		
		private static function _getHorseTemplate(tmplTempId:int):Json_horsebaseinfo
		{
			return CJHorseUtil.getHorseBaseInfoWithHorseID(tmplTempId);
		}
		
		/**
		 * 获取武将模板
		 * @param tmplTempId	武将模板id
		 * @return 
		 * 
		 */		
		private static function _getHeroTemplate(tmplTempId:int):CJDataHeroProperty
		{
			var templateSetting:CJDataOfHeroPropertyList = CJDataOfHeroPropertyList.o;
			var itemTemplate:CJDataHeroProperty = templateSetting.getProperty(tmplTempId);
			if (itemTemplate == null)
			{
				Assert(itemTemplate != null, "Hero template is not exist, id is " + tmplTempId);
				return null;
			}
			return itemTemplate;
		}
		
		/**
		 * 获取被动技能模板
		 * @param tmplTempId	被动技能模板id
		 * @return 
		 * 
		 */		
		private static function _getPSkillTemplate(tmplTempId:String):Json_pskill_setting
		{
			var templateSetting:CJDataOfPSkillProperty = CJDataOfPSkillProperty.o;
			var pskillTemplate:Json_pskill_setting = templateSetting.getPSkill(tmplTempId);
			if (pskillTemplate == null)
			{
				Assert(pskillTemplate != null, "Pskill template is not exist, id is " + tmplTempId);
				return null;
			}
			return pskillTemplate;
		}
		/**
		 * 获取被动技能模板
		 * @param tmplTempId	被动技能模板id
		 * @return 
		 * 
		 */		
		private static function _getEhanceTemplate(enhanceLv:int):CJDataOfEnhanceEquipConfigSingle
		{
			var templateSetting:CJDataOfEnhanceEquipProperty = CJDataOfEnhanceEquipProperty.o;
			var enhanceTemplate:CJDataOfEnhanceEquipConfigSingle = templateSetting.getConfigDataByLevel(enhanceLv);
			if (enhanceTemplate == null)
			{
				Assert(enhanceTemplate != null, "Enhance template is not exist, id is " + enhanceLv);
				return null;
			}
			return enhanceTemplate;
		}
	}
}