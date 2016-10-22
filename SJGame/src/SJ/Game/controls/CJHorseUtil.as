package SJ.Game.controls
{
	import SJ.Common.Constants.ConstCurrency;
	import SJ.Common.Constants.ConstResource;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfHorse;
	import SJ.Game.data.json.Json_horsebaseinfo;
	
	import engine_starling.utils.AssetManagerUtil;
	
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import lib.engine.utils.functions.Assert;
	
	/**
	 * @author	Weichao
	 * 2013-5-7
	 * @modified caihua 
	 */
	
	public class CJHorseUtil
	{
		//		坐骑未激活
		public static const HORSE_UNACTIVATED:int = 0 ;
		//		已激活未骑乘
		public static const HORSE_REST:int = 1;
		//		正在骑乘的
		public static const HORSE_RIDING:int = 2;
		
		public function CJHorseUtil()
		{
		}
		
		public static const UpgradeType_normal:int = 0;
		public static const UpgradeType_gold:int = 0;
		
		public static const TextFormat_Orange:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 12, 0xFFEFBD, null, null, null, null, null, TextFormatAlign.CENTER);
		
		/**
		 * 计算坐骑的状态
		 */		
		public static function calcHorseStatus(horseid:int):int
		{
			var data:CJDataOfHorse = CJDataManager.o.DataOfHorse;
			var dic_baseInfo:Object = data.dic_baseInfo;
			var userHorseList:Array = data.arr_horseList;
			var horseid_current:int = int(dic_baseInfo["currenthorseid"]);
			
			if(horseid_current ==  horseid && int(dic_baseInfo["isriding"]) == 1)
			{
				return HORSE_RIDING;
			}
			var len:int = userHorseList.length;
			for(var i:int = 0 ; i < len ; i++)
			{
				if(int(userHorseList[i]["horseid"]) == horseid)
				{
					return HORSE_REST;
				}
			}
			return HORSE_UNACTIVATED;
		}
		
		/**
		 * 计算当前阶数
		 */		
		static public function getRank(rideSkillLevel:int):int
		{
			if(rideSkillLevel <= 0)
			{
				return 0 ;
			}
			else if(rideSkillLevel % 10 == 0)
			{
				return rideSkillLevel / 10 - 1;
			}
			else
			{
				return rideSkillLevel / 10;
			}
		}
		
		/**
		 * 得到星数
		 */	
		static public function getStarCount(rideSkillLevel:int):int
		{
			if(rideSkillLevel > 0  && rideSkillLevel % 10 == 0)
			{
				return 10;
			}
			else
			{
				return rideSkillLevel % 10;
			}
		}
		
		/**
		 * 是否可以培养
		 */		
		static public function canUpgrade(data:CJDataOfHorse):Boolean
		{
			var result:Boolean = false;
			var exp_left:int = int(data.dic_baseInfo["leftexp"]);
			var level_current:int = int(data.dic_baseInfo["rideskilllevel"]);
			var exp_need:int = -1;
				
			var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonHorseRideSkill) as Array;
			if(obj == null)
			{
				return false;
			}
			
			exp_need = obj[level_current]['upgradeexp'];
			
			if (exp_left < exp_need)
			{
				result = true;
			}
			return result;
		}
		
		/**
		 * 是否可以升阶
		 */	
		static public function canUpgradeRank(data:CJDataOfHorse):Boolean
		{
			var result:Boolean = false;
			var level_current:int = int(data.dic_baseInfo["rideskilllevel"]);
			var starCount:int = CJHorseUtil.getStarCount(level_current);
			var exp_left:int = int(data.dic_baseInfo["leftexp"]);
			if (10 != starCount)
			{
				return false;
			}
			var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonHorseRideSkill) as Array;
			if(obj == null)
			{
				return false;
			}
			var exp_nextLevel:int = obj[level_current]['upgradeexp'];
			
			if (-1 == exp_nextLevel)
			{
				return false;
			}
			if (exp_left >= exp_nextLevel)
			{
				result = true;
			}
			return result;
		}
		
		/**
		 * 是否可以下马
		 */	
		static public function canDismount(data:CJDataOfHorse):Boolean
		{
			var result:Boolean = false;
			var ridingState:int = int(data.dic_baseInfo["isriding"]);
			if (1 == ridingState)
			{
				result = true;
			}
			return result;
		}
	
		/**
		 * 得到坐骑的配置信息
		 */	
		static public function getHorseBaseInfoWithHorseID(horseid:int):Json_horsebaseinfo
		{
			var result:Json_horsebaseinfo = new Json_horsebaseinfo();
			var arr_horseListJson:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonHorseBaseInfo) as Array;
			for (var i:int = 0; i < arr_horseListJson.length; i++)
			{
				var horseInfoTemp:Object = arr_horseListJson[i];
				if (horseid == parseInt(horseInfoTemp["horseid"]))
				{
					result.loadFromJsonObject(horseInfoTemp);
					return result;
				}
			}
			return null;
		}
		
		//取暖得某一等级的骑术信息
		static public function getRideSkillBaseInfoWithRideSkillLevel(level:int):Object
		{
			var result:Object = null;
			var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonHorseRideSkill) as Array;
			if(obj == null)
			{
				return null;
			}
			var rate:Number = 0;
			for (var j:int; j < obj.length; j++)
			{
				var rideSkillJson:Object = obj[j];
				if (int(rideSkillJson["rideskilllevel"]) == level)
				{
					result = rideSkillJson;
					break;
				}
			}
			return result;
		}
		
		//得到某一等级某一坐骑的最终属性加成
		static public function getAttributeBonusWithHorseParams(horseid:int, level:int):Object
		{
			var RetValue:Object = new Object();
			var horseBonus:Json_horsebaseinfo = CJHorseUtil.getHorseBaseInfoWithHorseID(horseid);
			var baseBonus:Object = CJHorseUtil.getRideSkillBaseInfoWithRideSkillLevel(level);
			RetValue["goldbonus"] = Number(baseBonus["goldbonus"]) * Number(horseBonus.metalbonusrate);
			RetValue["woodbonus"] = Number(baseBonus["woodbonus"]) * Number(horseBonus.woodbonusrate);
			RetValue["waterbonus"] = Number(baseBonus["waterbonus"]) * Number(horseBonus.waterbonusrate);
			RetValue["firebonus"] = Number(baseBonus["firebonus"]) * Number(horseBonus.firebonusrate);
			RetValue["eartchbonus"] = Number(baseBonus["eartchbonus"]) * Number(horseBonus.earthbonusrate);
			return RetValue;
		}
		
		/**
		 * 计算武将骑乘状态下附加属性值
		 */		
		public static function calcHeroAppendPropertyAfterRide():Object
		{
			var currentHorseid:int = CJDataManager.o.DataOfHorse.getCurrentHorse();
			var skillLevel:int = CJDataManager.o.DataOfHorse.getCurrentRideSkillLevel();
			return calcHeroAppendPropertyAfterRideByData(currentHorseid, skillLevel);
		}
		
		/**
		 * 计算武将骑乘状态下附加属性值
		 * @param currentHorseid	当前坐骑模板id
		 * @param skillLevel		当前的骑术等级
		 * @return 
		 * 
		 */		
		public static function calcHeroAppendPropertyAfterRideByData(currentHorseid:int, skillLevel:int):Object
		{
			if(currentHorseid == 0)
			{
				return {"goldbonus":0 , "woodbonus":0 ,"waterbonus":0 ,"firebonus":0 ,"eartchbonus":0 }
			}
			else
			{
				return getAttributeBonusWithHorseParams(currentHorseid , skillLevel);
			}
		}
		
		/**
		 * 得到当前坐骑的配置信息
		 */		
		public static function getCurrentHorseConfig():Json_horsebaseinfo
		{
			var currentHorseid:int = CJDataManager.o.DataOfHorse.getCurrentHorse();
			return getHorseBaseInfoWithHorseID(currentHorseid);
		}
		
		/**
		 * 得到当前坐骑加速的比例
		 */		
		public static function getAccelarateRatio(horseId:int):Number
		{
			if(horseId == -1)
			{
				return 0;
			}
			var config:Json_horsebaseinfo = getHorseBaseInfoWithHorseID(horseId);
			if(config == null)
			{
				return 0;
			}
			return Number(config.speed) / 10000;
		}
		
		//某一坐骑是否已经开通
		static public function isHorseEnabled(horseid:int):Boolean
		{
			var result:Boolean = false;
			var data:CJDataOfHorse = CJDataManager.o.getData("CJDataOfHorse") as CJDataOfHorse;
			var data_horseList:Array = data.arr_horseList;
			for (var i:int = 0; i < data_horseList.length; i++)
			{
				var dic_horseInfo:Object = data_horseList[i];
				var horseid_temp:int = int(dic_horseInfo["horseid"]);
				if (horseid == horseid_temp)
				{
					result = true;
					break;
				}
			}
			return result;
		}
		
		//得到所有配置表里面的坐骑基础信息
		static public function getJsonAllHorseInfo():Array
		{
			var result:Array = new Array();
			result = AssetManagerUtil.o.getObject(ConstResource.sResJsonHorseBaseInfo) as Array;
			return result;
		}
		
		/**
		 * 获得升阶消耗的元宝数量
		 */		
		public static function getUpRankCost(rank:int):int
		{
			var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonHorseUpgradeRIdeSkillRank) as Array;
			if(obj == null)
			{
				return 999999;
			}
			for (var j:int; j < obj.length; j++)
			{
				var costJson:Object = obj[j];
				if (int(costJson["riderank"]) == rank)
				{
					return int(costJson["costgold"]);
				}
			}
			return 999999;
		}
		
		/**
		 * 根据阶数获得配置
		 */		
		public static function getBaseConfigByRank(rank:int):Object
		{
			var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonHorseBaseInfo) as Array;
			for (var j:int; j < obj.length; j++)
			{
				var baseConfig:Object = obj[j];
				if (int(baseConfig["rank"]) == rank)
				{
					return baseConfig;
				}
			}
			return null;
		}
		
		/**
		 * 根据今日的点击培养的次数,计算该次培养的配置 
		 */
		public static function getUpgradeConfigByUpgradeType(type:int):Object
		{
			var data:CJDataOfHorse = CJDataManager.o.getData("CJDataOfHorse") as CJDataOfHorse;
			var dic_baseInfo:Object = data.dic_baseInfo;
			var count:int = 0 ;
			if (type == ConstCurrency.CURRENCY_TYPE_SILVER)
			{
				count = dic_baseInfo['silverupgradecount'];
			}
			else
			{
				count = dic_baseInfo['goldupgradecount'];
			}
			
			var upgradeConfigList:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonHorseUpgradeRideSkill) as Array;
			var maybeCount:int = 0;
			for (var j:int; j < upgradeConfigList.length; j++)
			{
				var config:Object = upgradeConfigList[j];
				if(count > int(config['count']))
				{
					if (maybeCount <= int(config['count']))
					{
						maybeCount = int(config['count']);
					}
				}
				else if (count == int(config['count']))
				{
					return config;
				}
			}
			return upgradeConfigList[maybeCount];
		}
	}
}