package SJ.Game.data.config
{
	import SJ.Common.Constants.ConstResource;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfUserSkill;
	import SJ.Game.data.CJDataOfUserSkillList;
	import SJ.Game.data.json.Json_skill_setting;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.utils.AssetManagerUtil;
	
	import flash.utils.Dictionary;

	public class CJDataOfSkillPropertyList
	{
		public function CJDataOfSkillPropertyList()
		{
			_initData();
		}
		
		private static var _o:CJDataOfSkillPropertyList;
		public static function get o():CJDataOfSkillPropertyList
		{
			if(_o == null)
				_o = new CJDataOfSkillPropertyList();
			return _o;
		}
		
		private var _dataDict:Dictionary;
		
		private function _initData():void
		{
			var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResSkillSetting) as Array;
			_dataDict = new Dictionary();
			var length:int = obj.length;
			var skillConfig:Json_skill_setting = new Json_skill_setting();
			for(var i:int=0;i<length;i++)
			{
				
				skillConfig.loadFromJsonObject(obj[i]);
				// 格式化技能描述文字
				_formatDes(skillConfig);
				_dataDict[parseInt(obj[i]['skillid'])] = obj[i];
			}
		}
		
		public function getProperty(skillId:int):Json_skill_setting
		{
			var skillConfig:Json_skill_setting = new Json_skill_setting();
			skillConfig.loadFromJsonObject(_dataDict[skillId]);
			// 格式化技能描述文字
			_formatDes(skillConfig);
			return skillConfig;
		}
		
		/**
		 * 格式化技能描述文字
		 * @param skillConfig
		 */
		private function _formatDes(skillConfig:Json_skill_setting):void
		{
			if ( null == skillConfig)
				return;
			
			// 前缀
			var strPrefix:String;
			// 中间描述
			var strMidDesc:String;
			// 后缀
			var strSuffix:String;
			
			// 判断技能类型	前缀拼接
			if (int(skillConfig.skillkinds) == 0) // 攻击技能
			{
				// 随机显示的需要再处理
				if (int(skillConfig.skilltype) == 1)
					strPrefix = CJLang("SKILL_DESC_ATTACK_PREFIX_" + skillConfig.skilltype, {"value": skillConfig.skilltargetnum});
				else
					strPrefix = CJLang("SKILL_DESC_ATTACK_PREFIX_" + skillConfig.skilltype);
			}
			else
			{
				// 随机显示的需要再处理
				if (int(skillConfig.skilltype) == 1)
					strPrefix = CJLang("SKILL_DESC_CURE_PREFIX_" + skillConfig.skilltype, {"value": skillConfig.skilltargetnum});
				else
					strPrefix = CJLang("SKILL_DESC_CURE_PREFIX_" + skillConfig.skilltype);
			}
			
			// 中间描述
			strMidDesc = CJLang("SKILL_DESC_MID_"+skillConfig.skillkinds, {"value": ((int(skillConfig.skill_ev0) / 100) + "%")});
			// 后缀
			strSuffix = CJLang("SKILL_DESC_SUFFIX_"+skillConfig.skillkinds);
			
			
//			skillConfig.skilldes = CJLang(skillConfig.skilldes, {"value": ((int(skillConfig.skill_ev0) / 100) + "%")});
			
			skillConfig.skilldes = strPrefix + strMidDesc + strSuffix;
		}
		
		/**
		 * 获得特定职业的技能的列表
		 */ 
//		public function getSkillPropertyListByType(type:int):Dictionary
//		{
//			var obj:Array = AssetManagerUtil.o.getObject(ConstResource.sResSkillSetting) as Array;
//			var length:int = obj.length;
//			var temp:Dictionary = new Dictionary();
//			for(var i:int=0;i<length;i++)
//			{
//				if(int(obj[i]['type']) == type)
//				{
//					var skillConfig:Json_skill_setting = new Json_skill_setting();
//					skillConfig.loadFromJsonObject(obj[i]);
//					temp[parseInt(obj[i]['skillid'])] = skillConfig;
//				}
//			}
//			return temp;
//		}
	}
}