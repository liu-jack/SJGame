package SJ.Game.controls
{
	
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfBag;
	import SJ.Game.data.CJDataOfHero;
	import SJ.Game.data.CJDataOfHeroList;
	import SJ.Game.data.CJDataOfItem;
	import SJ.Game.data.CJDataOfRole;
	import SJ.Game.data.CJDataOfUserSkillList;
	import SJ.Game.data.config.CJDataHeroJobProperty;
	import SJ.Game.data.config.CJDataHeroProperty;
	import SJ.Game.data.config.CJDataOfGlobalConfigProperty;
	import SJ.Game.data.config.CJDataOfHeroPropertyList;
	import SJ.Game.data.config.CJDataOfItemProperty;
	import SJ.Game.data.config.CJDataOfPSkillProperty;
	import SJ.Game.data.config.CJDataOfStageLevelProperty;
	import SJ.Game.data.config.CJDataOfUpgradeProperty;
	import SJ.Game.data.json.Json_hero_job_setting;
	import SJ.Game.data.json.Json_hero_propertys;
	import SJ.Game.data.json.Json_item_package_config;
	import SJ.Game.data.json.Json_item_setting;
	import SJ.Game.data.json.Json_pskill_setting;
	import SJ.Game.data.json.Json_role_stage_force_star;
	import SJ.Game.data.json.Json_upgrade_config;
	
	import engine_starling.utils.AssetManagerUtil;
	
	import lib.engine.utils.CObjectUtils;
	import lib.engine.utils.functions.Assert;
	
	import mx.core.mx_internal;

	/**
	 * 武将属性计算器类
	 * @author sangxu
	 * 此类调用前:
	 * 1.需加载武将装备数据，SocketCommand_hero.get_puton_equip()
	 * 2.需加载装备栏数据,SocketCommand_item.get_equipmentbar()
	 * 3.需加载武将数据,SocketCommand_hero.get_heros()
	 * 4.需加载道具装备配置文件,ConstResource.sResJsonItemEquipConfig
	 * 5.需加载道具宝石配置文件,ConstResource.sResJsonItemJewelConfig
	 * 6.需加载道具武将模板配置文件,ConstResource.sResHeroPropertys
	 * 7.需加载坐骑模板配置文件 ,ConstResource.sResJsonHorseBaseInfo ConstResource.sResJsonHorseUpgradeRideSkill
	 *   被动技能配置文件:ConstResource.sResPSkillSetting
	 * 8.需要加载坐骑的数据 CJDataManager.o.DataOfHorse.loadFromRemote()
	 * 否则返回Json_hero_propertys值均为空
	 * @param heroId 武将id
	 */	
	public class CJHeroPropsCalculator
	{
		/** 所有武将数据 */
		private var _heroList:CJDataOfHeroList;
		/** 当前武将数据 */
		private var _heroData:CJDataOfHero;
		/** 武将模板 */
		private var _heroTmpl:CJDataHeroProperty;
		private var _roleData:CJDataOfRole;
		/** 武将装备属性 */
		private var _equipProps:Json_hero_propertys;
		/** 武将全部属性 */
		private var _heroProps:Json_hero_propertys;
		/** 被动技能属性 */
		private var _pskillSetting:Json_pskill_setting;
		/** 升级配置数据 */
		private var _upgradeConfig:Json_upgrade_config;
		/** 武将职业配置 */
		private var _heroJobSetting:Json_hero_job_setting;
		
		private var _quanlityWeight:Json_role_stage_force_star;
		/** 坐骑属性加成 */
		private var _horsePropObj:Object;
		
		/** 主将id */
		private var _mainHeroId:String;
		
		/**
		 * 
		 * @param heroId	武将id
		 * @param isMine	是否是我的数据，默认为是
		 * @param data		好友数据，由服务器端传过来
		 * 
		 */		
		public function CJHeroPropsCalculator(heroId:String, isMine:Boolean = true, data:Object = null)
		{
			if (isMine)
			{
				// 我的武将
				
				
				this._roleData = CJDataManager.o.DataOfRole;
				// 所有武将数据
				this._heroList = CJDataManager.o.DataOfHeroList;
				// 当前武将数据
				this._heroData = this._heroList.getHero(heroId);
				// 武将模板id
				var heroTmplId:int = this._heroData.templateid;
				// 武将模板
				this._heroTmpl = CJDataOfHeroPropertyList.o.getProperty(heroTmplId);
				// 武将装备属性
				this._equipProps = CJHeroUtil.getHeroEquipValueAll(heroId);
				
				// 武将职业配置
				this._heroJobSetting = CJDataHeroJobProperty.o.getHeroJob(this._heroTmpl.job);
				// 主将id
				this._mainHeroId = this._heroList.getMainHero().heroid;
				
				// 武将等级
				var heroLevel:int = parseInt(this._heroData.level);
				// 武将当前等级升级配置
				this._upgradeConfig = CJDataOfUpgradeProperty.o.getUpgradeConfig(String(heroLevel));
				
//				trace("  ====== heroTmplId          :[" + heroTmplId + "]");
//				trace("  ====== job                 :[" + this._heroTmpl.job + "]");
				
				if (this._heroData.isRole)
				{
					// 武星
					var forceStar:String = CJDataManager.o.DataOfStageLevel.forceStar.toString();
					// 武星信息
					this._quanlityWeight = CJDataOfStageLevelProperty.o.getForceStarData(forceStar, String(this._roleData.job), String(this._roleData.sex));
				}
				else
				{
					var key:String = "HERO_QUALITY_WEIGHT_" + this._heroTmpl.quality;
					this._quanlityWeight = new Json_role_stage_force_star();
					this._quanlityWeight.hpgrow 
						= this._quanlityWeight.pattackgrow
						= this._quanlityWeight.pdefgrow
						= this._quanlityWeight.mattackgrow
						= this._quanlityWeight.mdefgrow
						= CJDataOfGlobalConfigProperty.o.getData(key);
				}
				
				this._quanlityWeight.hpgrow = Number(this._quanlityWeight.hpgrow) / 10000;
				this._quanlityWeight.pattackgrow = Number(this._quanlityWeight.pattackgrow) / 10000;
				this._quanlityWeight.pdefgrow = Number(this._quanlityWeight.pdefgrow) / 10000;
				this._quanlityWeight.mattackgrow = Number(this._quanlityWeight.mattackgrow) / 10000;
				this._quanlityWeight.mdefgrow = Number(this._quanlityWeight.mdefgrow) / 10000;
				
				
				
				if (this._heroData.currenttalent != null && 
					this._heroData.currenttalent != "0" && 
					this._heroData.currenttalent !="")
				{
					this._pskillSetting = CJDataOfPSkillProperty.o.getPSkill(this._heroData.currenttalent);
				}
				else
				{
					this._pskillSetting = null;
				}
				
				// 坐骑属性加成
				this._horsePropObj = CJHorseUtil.calcHeroAppendPropertyAfterRide();
				
				this._heroProps = new Json_hero_propertys();
				this._heroProps.id = heroId;
				this._heroProps.level = heroLevel;
				this._heroProps.id = this._heroData.templateid;
				
			}
			else
			{
				// 好友的武将
				
				
				// 好友武将数据
				var friendData:Object = data.heroListInfo[heroId];
				// 好友坐骑数据
				var horseData:Object = data.horseInfo;
				
				
				// 武将武星
				var heroForceStar:String = String(data.forcestar);
				
				// 玩家唯一id
				var userId:String = String(friendData.userid);
				// 武将唯一id
				var heroId:String = String(friendData.heroid);
				// 武将模板id
				var heroTemplateId:int = int(friendData.templateid);
				// 武将等级
				var heroLevelFriend:String = String(friendData.level);
				// 当前
				var heroCurTalent:String = String(friendData.currenttalent);
				
				// 坐骑id
				var curHorseid:int = int(horseData.currenthorseid);
				// 当前的骑术等级
				var rideSkillLv:int = int(horseData.rideskilllevel);
				
				// 主将id
				this._mainHeroId = userId;
				
				// 武将模板
				this._heroTmpl = CJDataOfHeroPropertyList.o.getProperty(heroTemplateId);
				// 武将职业id
				var heroJob:String = String(_heroTmpl.job);
				// 武将性别
				var heroSex:String = String(_heroTmpl.sex);
				
				
				// 当前武将数据
				this._heroData = new CJDataOfHero();
				this._heroData.heroid = heroId;
				this._heroData.templateid = heroTemplateId;
				this._heroData.level = heroLevelFriend;
				this._heroData.currenttalent = heroCurTalent;
				
				// 武将装备属性
				this._equipProps = CJHeroUtil.getFriendHeroEquipValueAll(data, heroId);
				
				
				
				// 武将职业配置
				this._heroJobSetting = CJDataHeroJobProperty.o.getHeroJob(int(heroJob));
				// 武将当前等级升级配置
				this._upgradeConfig = CJDataOfUpgradeProperty.o.getUpgradeConfig(heroLevelFriend);
				if (userId == heroId)
				{
					// 主将
					// 武星信息
					this._quanlityWeight = CJDataOfStageLevelProperty.o.getForceStarData(heroForceStar, heroJob, heroSex);
				}
				else
				{
					var globalKey:String = "HERO_QUALITY_WEIGHT_" + this._heroTmpl.quality;
					this._quanlityWeight = new Json_role_stage_force_star();
					this._quanlityWeight.hpgrow 
						= this._quanlityWeight.pattackgrow
						= this._quanlityWeight.pdefgrow
						= this._quanlityWeight.mattackgrow
						= this._quanlityWeight.mdefgrow
						= CJDataOfGlobalConfigProperty.o.getData(globalKey);
				}
			
				this._quanlityWeight.hpgrow = Number(this._quanlityWeight.hpgrow) / 10000;
				this._quanlityWeight.pattackgrow = Number(this._quanlityWeight.pattackgrow) / 10000;
				this._quanlityWeight.pdefgrow = Number(this._quanlityWeight.pdefgrow) / 10000;
				this._quanlityWeight.mattackgrow = Number(this._quanlityWeight.mattackgrow) / 10000;
				this._quanlityWeight.mdefgrow = Number(this._quanlityWeight.mdefgrow) / 10000;
				
				if (this._heroData.currenttalent != null && 
					this._heroData.currenttalent != "0" && 
					this._heroData.currenttalent !="")
				{
					this._pskillSetting = CJDataOfPSkillProperty.o.getPSkill(this._heroData.currenttalent);
				}
				else
				{
					this._pskillSetting = null;
				}
				
				// 坐骑属性加成
				this._horsePropObj = CJHorseUtil.calcHeroAppendPropertyAfterRideByData(curHorseid, rideSkillLv);
				
				this._heroProps = new Json_hero_propertys();
				this._heroProps.id = heroId;
				this._heroProps.level = heroLevelFriend;
				this._heroProps.id = this._heroData.templateid;
			}
			
//			trace("  ====== weight hp      :[" + this._quanlityWeight.hpgrow + "]");
//			trace("  ====== weight pattack :[" + this._quanlityWeight.pattackgrow + "]");
//			trace("  ====== weight pdef    :[" + this._quanlityWeight.pdefgrow + "]");
//			trace("  ====== weight mattack :[" + this._quanlityWeight.mattackgrow + "]");
//			trace("  ====== weight mdef    :[" + this._quanlityWeight.mdefgrow + "]");
		}
		
		public function getHeroPropertys():Json_hero_propertys
		{
			return this._heroProps;
		}
		
		/**
		 * 计算武将属性
		 * @return 
		 * 
		 */		
		public function calculateProps():void
		{
//			this._computerBaseProps();
			
			this._heroProps.strength = 0;
			this._heroProps.physique = 0;
			this._heroProps.spirit = 0;
			this._heroProps.intelligence = 0;
			this._heroProps.agility = 0;
				
			this._computeAttr_Hp();
			this._computeAttr_pAttack();
			this._computeAttr_mAttack();
			this._computeAttr_pDef();
			this._computeAttr_mDef();
			this._computeAttr_normal("speed");
			this._computeAttr_normal("crit");
			this._computeAttr_normal("toughness");
			this._computeAttr_normal("dodge");
			this._computeAttr_normal("hit");
			this._computeAttr_normal("mimmuno");
			this._computeAttr_normal("mpassthrough");
			this._computeAttr_normal("blood");
			this._computeAttr_normal("mcrit");
			this._computeAttr_normal("mtoughness");
			this._computeAttr_normal("cure");
			this._computeAttr_normal("reducehurt");
			this._computeAttr_normal("inchurt");
			
			this._computeTemplateAttr();
			
//			this._heroProps.updateRuntimeAttr();
//			this._updateRuntimeAttr();
		}
		
		/**
		 * 计算普通属性
		 * @return 
		 * 
		 */		
		private function _computeTemplateAttr():void
		{
			this._heroProps.genius_0 = this._heroTmpl.genius_0;
			
			this._heroProps.skill1 = this._heroTmpl.skill1;
//			this._heroProps.skill1startround = this._heroTmpl.skill1startround;
			
			// 主将数据
//			var mainHeroData:CJDataOfHero = this._heroList.getMainHero();
			
			// 计算技能
//			if (mainHeroData.heroid == String(this._heroProps.id))
			if (this._mainHeroId == this._heroData.heroid)
			{
				var skillListData:CJDataOfUserSkillList = CJDataManager.o.DataOfUserSkillList;
				
				this._heroProps.skill1 = skillListData.getCurrentSkill();
//				this._heroProps.skill1startround = this._heroTmpl.skill1startround;
			}
		}
		
		/**
		 * 更新运行时数据
		 * @return 
		 * 
		 */		
//		private function _updateRuntimeAttr():void
//		{
//			var upgradeProperty:CJDataOfUpgradeProperty = CJDataOfUpgradeProperty.o;
//			var upgradeCfg:Json_upgrade_config = upgradeProperty.getUpgradeConfig(String(this._heroProps.level));
//			
//			self.pdefpercent = float(self.pdef) / float(self.pdef + int(levelconf._defweight))
//			self.mdefpercent =  float(self.mdef) / float(self.mdef + int(levelconf._defweight))
//		}
		
		/**
		 * 计算基础属性：金木水火土
		 * 
		 */		
		private function _computerBaseProps():void
		{
			
			this._heroProps.strength = int(this._equipProps.strength) + int(this._heroTmpl.strength) + int(this._horsePropObj["goldbonus"]);
			this._heroProps.physique = int(this._equipProps.physique) + int(this._heroTmpl.physique) + int(this._horsePropObj["woodbonus"]);
			this._heroProps.spirit = int(this._equipProps.spirit) + int(this._heroTmpl.spirit) + int(this._horsePropObj["waterbonus"]);
			this._heroProps.intelligence = int(this._equipProps.intelligence) + int(this._heroTmpl.intelligence) + int(this._horsePropObj["firebonus"]);
			this._heroProps.agility = int(this._equipProps.agility) + int(this._heroTmpl.agility) + int(this._horsePropObj["eartchbonus"]);
			
		}
		
		/**
		 * 计算生命
		 * 生命对应木(体质physique)
		 * @return 
		 * 
		 */		
		private function _computeAttr_Hp():void
		{
			// 武将基础生命 = (武将基础生命 + 武将生命成长) * 职业系数 * 品质系数
			var hp_herobase:int = int(this._heroTmpl.hp) + int(_upgradeConfig.hp);
			hp_herobase = hp_herobase * (Number(this._heroJobSetting.hp) / 10000) * this._quanlityWeight.hpgrow;
			// 装备基础生命
			var hp_heroequipmentbase:int = int(this._equipProps.hp);
			// 五行属性加成
			var weight:Number = Number(this._heroProps.physique) + Number(this._equipProps.physique) + Number(this._horsePropObj["woodbonus"]);
			this._heroProps.physique = int(weight);
			// 被动技能加成
			var pSkillValue:Number = 0;
			if (this._pskillSetting != null)
			{
				pSkillValue = Number(this._pskillSetting.hp);
			}
			
			// 生命    = 基础生命    *    体力/100    *    天赋加成
			this._heroProps.hp = this._computefinalAttr(hp_herobase, hp_heroequipmentbase, weight, pSkillValue);
			
//			trace("  ====== template_hp         :[" + this._heroTmpl.hp + "]");
//			trace("  ====== levelconf_hp        :[" + _upgradeConfig.hp + "]");
//			trace("  ====== jobweight_hp        :[" + this._heroJobSetting.hp + "]");
//			trace("  ====== quanlityweight_hp   :[" + this._quanlityWeight.hpgrow + "]");
//			trace("  ====== hp_heroequipmentbase:[" + hp_heroequipmentbase + "]");
//			trace("  ====== heroTmplMu          :[" + this._heroProps.physique + "]");
//			trace("  ====== equipMu             :[" + this._equipProps.physique + "]");
//			trace("  ====== heroMu              :[" + this._horsePropObj["woodbonus"] + "]");
//			trace("  ====== weight              :[" + weight + "]");
//			trace("  ====== pSkillValue         :[" + pSkillValue + "]");
//			trace("  ====== hero _hp            :[" + this._heroProps.hp + "]");
		}
		
		/**
		 * 计算物理攻击
		 * 物攻对应金(力量strength)
		 * @return 
		 * 
		 */		
		private function _computeAttr_pAttack():void
		{
			// 武将基础生命    =    武将生命成长    *    武将等级
			var herobase:int = int(this._heroTmpl.pattack) + int(_upgradeConfig.pattack);
			herobase = herobase * (Number(this._heroJobSetting.pattack) / 10000) * this._quanlityWeight.pattackgrow;
			// 装备基础生命
			var heroequipmentbase:int = int(this._equipProps.pattack);
			// 五行属性加成
			var weight:Number = Number(this._heroProps.strength) + Number(this._equipProps.strength) + Number(this._horsePropObj["goldbonus"]);
			this._heroProps.strength = int(weight);
			
			var pSkillValue:Number = 0;
			if (this._pskillSetting != null)
			{
				pSkillValue = Number(this._pskillSetting.pattack);
			}
			this._heroProps.pattack = this._computefinalAttr(herobase, heroequipmentbase, weight, pSkillValue);
		}
		
		/**
		 * 计算魔法攻击
		 * 法攻对应火(智力intelligence)
		 * @return 
		 * 
		 */		
		private function _computeAttr_mAttack():void
		{
			// 武将基础生命    =    武将生命成长    *    武将等级
			var herobase:int = int(this._heroTmpl.mattack) + int(_upgradeConfig.mattack);
			herobase = herobase * (Number(this._heroJobSetting.mattack) / 10000) * this._quanlityWeight.mattackgrow;
			// 装备基础生命
			var heroequipmentbase:int = int(this._equipProps.mattack);
			// 五行属性加成
			var weight:Number = Number(this._heroProps.intelligence) + Number(this._equipProps.intelligence) + Number(this._horsePropObj["firebonus"]);
			this._heroProps.intelligence = int(weight);
			
			var pSkillValue:Number = 0;
			if (this._pskillSetting != null)
			{
				pSkillValue = Number(this._pskillSetting.mattack);
			}
			this._heroProps.mattack = this._computefinalAttr(herobase, heroequipmentbase, weight, pSkillValue);
		}
		
		/**
		 * 计算物理防御
		 * 物防对应土(敏捷agility)
		 * @return 
		 * 
		 */		
		private function _computeAttr_pDef():void
		{
			// 武将基础生命    =    武将生命成长    *    武将等级
			var herobase:int = int(this._heroTmpl.pdef) + int(_upgradeConfig.pdef);
			herobase = herobase * (Number(this._heroJobSetting.pdef) / 10000) * this._quanlityWeight.pdefgrow;
			// 装备基础物防
			var heroequipmentbase:int = int(this._equipProps.pdef);
			// 五行属性加成
			var weight:Number = Number(this._heroProps.agility) + Number(this._equipProps.agility) + Number(this._horsePropObj["eartchbonus"]);
			this._heroProps.agility = int(weight);
			
			var pSkillValue:Number = 0;
			if (this._pskillSetting != null)
			{
				pSkillValue = Number(this._pskillSetting.def);
			}
			
			this._heroProps.pdef = this._computefinalAttr(herobase, heroequipmentbase, weight, pSkillValue);
			
		}
		/**
		 * 计算魔法防御
		 * 法防对应水(精神spirit)
		 * @return 
		 * 
		 */		
		private function _computeAttr_mDef():void
		{
			// 武将基础生命    =    武将生命成长    *    武将等级
			var herobase:int = int(this._heroTmpl.mdef) + int(_upgradeConfig.mdef);
			herobase = herobase * (Number(this._heroJobSetting.mdef) / 10000) * this._quanlityWeight.mdefgrow;
			// 装备基础生命
			var heroequipmentbase:int = int(this._equipProps.mdef);
			// 五行属性加成
			var weight:Number = Number(this._heroProps.spirit) + Number(this._equipProps.spirit) + Number(this._horsePropObj["waterbonus"]);
			this._heroProps.spirit = int(weight);
			
			var pSkillValue:Number = 0;
			if (this._pskillSetting != null)
			{
				pSkillValue = Number(this._pskillSetting.mdef);
			}
			
			this._heroProps.mdef = this._computefinalAttr(herobase, heroequipmentbase, weight, pSkillValue);
		}
		
		/**
		 * 计算最终属性
		 * @param herobaseattr		英雄基础属性
		 * @param equipbaseattr		装备基础属性
		 * @param weigth			力量 .体质 等权重(金木水火土)
		 * @param geniusweigth		被动技能加成(技能配置-被动表中值)天赋加成 百分比 1 + 40% 这里填写 40
		 * @return 
		 * 
		 */		
		private function _computefinalAttr(herobaseattr:int, equipbaseattr:int, weigth:Number, geniusweigth:Number):int
		{
			return int((herobaseattr + equipbaseattr) * (1 + (weigth/100)) *  (1 + geniusweigth))
		}
		
		private function _computeAttr_normal(attr_name:String):void
		{
			
//			var herobase:int = int(getattr(this._heroTmpl, "_%s" % attr_name));
			var herobase:int = this._heroTmpl[attr_name];
			var heroequipmentbase:int = 0;
//			if getattr(this._equipProps, "_%s" % attr_name)
			if (this._equipProps[attr_name] != null)
			{
//				heroequipmentbase = int(getattr(this._equipProps, "_%s" % attr_name));
				heroequipmentbase = int(this._equipProps[attr_name]);
			}
			var finalvalue:int = herobase + heroequipmentbase;
				
//			setattr(this._heroProps, attr_name, finalvalue)
			this._heroProps[attr_name] = finalvalue;
		}
	}
}