package SJ.Common.Constants
{
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfHorse;
	import SJ.Game.data.json.Json_horsebaseinfo;
	
	import engine_starling.utils.AssetManagerUtil;
	
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import lib.engine.utils.functions.Assert;
	
	/**
	 @author	Weichao
	 2013-5-7
	 */
	
	public class ConstHorse
	{
		public function ConstHorse()
		{
		}
		
		public static const UpgradeType_normal:int = 0;
		public static const UpgradeType_gold:int = 0;
		
		public static const TextFormat_Orange:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 12, 0xFFEFBD, null, null, null, null, null, TextFormatAlign.CENTER);
		
		static public function getRank(rideSkillLevel:int):int
		{
			return (rideSkillLevel - 1) / 11;
		}
		
		static public function getStarCount(rideSkillLevel:int):int
		{
			return (rideSkillLevel - 1) % 11;
		}
		
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
			for (var i:int = 0; i < obj.length; i++)
			{
				var rideSkillInfo:Object = obj[i];
				if (level_current == int(rideSkillInfo["rideskilllevel"]))
				{
					exp_need = int(rideSkillInfo["upgradeexp"]);
					break;
				}
			}
			if (exp_left < exp_need)
			{
				result = true;
			}
			return result;
		}
		
		static public function canUpgradeRank(data:CJDataOfHorse):Boolean
		{
			var result:Boolean = false;
			var level_current:int = int(data.dic_baseInfo["rideskilllevel"]);
			var starCount:int = ConstHorse.getStarCount(level_current);
			var exp_left:int = int(data.dic_baseInfo["leftexp"]);
			if (10 != starCount)
			{
				return false;
			}
			var exp_nextLevel:int = -1;
			var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonHorseRideSkill) as Array;
			if(obj == null)
			{
				return false;
			}
			for (var i:int = 0; i < obj.length; i++)
			{
				var rideSkillInfo:Object = obj[i];
				if (level_current == int(rideSkillInfo["rideskilllevel"]))
				{
					exp_nextLevel = int(rideSkillInfo["upgradeexp"]);
					break;
				}
			}
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
	
		//取得某一坐骑的基本信息
		static public function getHorseBaseInfoWithHorseID(horseid:int):Json_horsebaseinfo
		{
			var result:Json_horsebaseinfo = new Json_horsebaseinfo();
			var arr_horseListJson:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonHorseBaseInfo) as Array;
			if (null == arr_horseListJson)
			{
				return null;
			}
			for (var i:int = 0; i < arr_horseListJson.length; i++)
			{
				var horseInfoTemp:Object = arr_horseListJson[i];
				if (horseid == parseInt(horseInfoTemp["horseid"]))
				{
					result.loadFromJsonObject(horseInfoTemp);
					return result;
					break;
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
			var horseBonus:Json_horsebaseinfo = ConstHorse.getHorseBaseInfoWithHorseID(horseid);
			Assert(null != horseBonus);
			var baseBonus:Object = ConstHorse.getRideSkillBaseInfoWithRideSkillLevel(level);
			Assert(null != baseBonus);
			RetValue["goldbonus"] = int(parseInt(baseBonus["goldbonus"]) * (1 + 1.0 * int(horseBonus.metalbonusrate) / 10000));
			RetValue["woodbonus"] = int(parseInt(baseBonus["woodbonus"]) * (1 + 1.0 * int(horseBonus.woodbonusrate) / 10000));
			RetValue["waterbonus"] = int(parseInt(baseBonus["waterbonus"]) * (1 + 1.0 * int(horseBonus.waterbonusrate) / 10000));
			RetValue["firebonus"] = int(parseInt(baseBonus["firebonus"]) * (1 + 1.0 * int(horseBonus.firebonusrate) / 10000));
			RetValue["eartchbonus"] = int(parseInt(baseBonus["eartchbonus"]) * (1 + 1.0 * int(horseBonus.earthbonusrate) / 10000));
			return RetValue;
		}
		
		//某一坐骑是否已经开通
		static public function isHorseEnabled(horseid:int):Boolean
		{
			var result:Boolean = false;
			var data:CJDataOfHorse = CJDataManager.o.getData("CJDataOfHorse") as CJDataOfHorse;
			Assert(null != data);
			var data_horseList:Array = data.arr_horseList;
			Assert(null != data_horseList);
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
			Assert(null != result && 0 != result.length);
			return result;
		}
	}
}