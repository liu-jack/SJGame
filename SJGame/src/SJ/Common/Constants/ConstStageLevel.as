package SJ.Common.Constants
{
	import SJ.Game.data.config.CJDataHeroProperty;
	import SJ.Game.data.config.CJDataOfHeroPropertyList;
	import SJ.Game.data.config.CJDataOfPSkillProperty;
	import SJ.Game.data.config.CJDataOfSkillPropertyList;
	import SJ.Game.data.json.Json_pskill_setting;
	import SJ.Game.data.json.Json_role_stage_force_star;
	import SJ.Game.data.json.Json_skill_setting;
	import SJ.Game.lang.CJLang;
	
	import lib.engine.utils.CObjectUtils;

	/**
	 * 主角升阶常量
	 * @author longtao
	 * 
	 */
	public final class ConstStageLevel
	{
		public function ConstStageLevel()
		{
		}
		
		/** 每阶最大武星数量 **/		
		public static const ConstMaxStar:uint = 10;
		
		/** 最大阶数 **/		
		public static const ConstMaxStage:uint = 4;
		
		/** 青龙 **/
		public static const ConstStageDragon:uint = 1;
		/** 白虎 **/
		public static const ConstStageTiger:uint = 2;
		/** 朱雀 **/
		public static const ConstStageBird:uint = 3;
		/** 玄武 **/
		public static const ConstStageTortoise:uint = 4;
		
		/** 武星摆放位置 {1:{1:point, 2:point, 3:point...}...4:{1:point, 2:point, 3:point...}} **/
		public static var ConstForceStarObj:Object = new Object;
		
		/** 十颗武星全部激活背景图资源名称 **/
		public static const ConstStageBGObj:Object = {1:"zhujueshengjie_qinglong", 2:"zhujueshengjie_baihu", 
			3:"zhujueshengjie_zhuque", 4:"zhujueshengjie_xuanwu"};
		
		/** 十颗武星未全部激活背景图资源名称 **/
		public static const ConstStageUnBGObj:Object = {1:"zhujueshengjie_qinglongdi", 2:"zhujueshengjie_baihudi", 
			3:"zhujueshengjie_zhuquedi", 4:"zhujueshengjie_xuanwudi"};
		
		/** 高亮圣兽 **/
		public static const ConstStageHighlightMonsterObj:Object = {1:"zhujueshengjie_qinglongguang", 2:"zhujueshengjie_baihuguang", 
			3:"zhujueshengjie_zhuqueguang", 4:"zhujueshengjie_xuanwuguang"};
		
		/** 武星显示  1普通 **/
		public static const ConstStageTypeCommon:uint = 1;
		/** 武星显示  2技能 **/
		public static const ConstStageTypeSkill:uint = 2;
		/** 武星显示  3形态 **/
		public static const ConstStageTypeImage:uint = 3;
		/** 武星点资源 **/
		public static const ConstActivatePointResName:Object = {1:"zhujueshengjie_dianlan", 2:"zhujueshengjie_dianhuang", 
			3:"zhujueshengjie_dianhong", 4:"zhujueshengjie_dianlv"};
		/** 文字颜色 **/
		public static const ConstFontColor:Object = {1:ConstTextFormat.FONT_COLOR_DRAGON, 2:ConstTextFormat.FONT_COLOR_TIGER
			, 3:ConstTextFormat.FONT_COLOR_BIRD, 4:ConstTextFormat.FONT_COLOR_TORTOISE};
		
		/**
		 * 青龙使用雷电类属性
		 * 白虎使用风类属性
		 * 朱雀使用火焰类属性
		 * 玄武使用水波类属性
		 * */
		public static const ConstUpgradeAnim:Object = {1:"anim_stagelevel_dian",2:"anim_stagelevel_feng",3:"anim_stagelevel_huo",4:"anim_stagelevel_shui"};
		/**
		 * 线条
		 * */
		public static const ConstUpgradeLine:Object = {1:"zhujueshengjie_lan",2:"zhujueshengjie_huang",3:"zhujueshengjie_hong",4:"zhujueshengjie_lv"};
		
		/**
		 * 激活武星  激活点特效资源名称
		 */
		public static const ConstActivateBlink:Object = {1:"anim_stagelevel_activate_electricity",2:"anim_stagelevel_activate_wind",3:"anim_stagelevel_activate_fire",4:"anim_stagelevel_activate_water"};
			
		/**
		 * 获取主角升阶等级  目前为1-4级
		 * @param forceStarIndex
		 * @return 升阶等级
		 * 
		 */
		public static function getStageLevel( forceStarIndex:uint ):uint
		{
			var stageLevel:uint;
			if (forceStarIndex % ConstStageLevel.ConstMaxStar == 0)
				stageLevel = forceStarIndex / ConstMaxStar;
			else
				stageLevel = forceStarIndex / ConstMaxStar + 1;
			if (stageLevel > ConstMaxStage)
				return ConstMaxStage;
			return stageLevel;
		}
		
		/**
		 * 获取普通描述
		 * @return 
		 */
		public static function getCommonDescribe(jsNextForceStar:Json_role_stage_force_star, jsCurForceStar:Json_role_stage_force_star):String
		{
			// 格式化字符串
			function __formatDesc(desc:String, NextV:int, curV:int):String
			{
				var m:int = (NextV - curV)/100;
				desc = desc + m + "%\n";
				return desc;
			}
			
			var str:String = "";
			if (int(jsNextForceStar.hpgrow) != int(jsCurForceStar.hpgrow))
				str += __formatDesc(CJLang("STAGE_BASE_HP"), int(jsNextForceStar.hpgrow), int(jsCurForceStar.hpgrow));
			if (int(jsNextForceStar.pattackgrow) != int(jsCurForceStar.pattackgrow))
				str += __formatDesc(CJLang("STAGE_BASE_PA"), int(jsNextForceStar.pattackgrow), int(jsCurForceStar.pattackgrow));
			if (int(jsNextForceStar.pdefgrow) != int(jsCurForceStar.pdefgrow))
				str += __formatDesc(CJLang("STAGE_BASE_PD"), int(jsNextForceStar.pdefgrow), int(jsCurForceStar.pdefgrow));
			if (int(jsNextForceStar.mattackgrow) != int(jsCurForceStar.mattackgrow))
				str += __formatDesc(CJLang("STAGE_BASE_MA"), int(jsNextForceStar.mattackgrow), int(jsCurForceStar.mattackgrow));
			if (int(jsNextForceStar.mdefgrow) != int(jsCurForceStar.mdefgrow))
				str += __formatDesc(CJLang("STAGE_BASE_MD"), int(jsNextForceStar.mdefgrow), int(jsCurForceStar.mdefgrow));
			return str;
		}
		
		/**
		 * 获取技能描述
		 * @return 
		 */
		public static function getSkillDescribe(jsheroProp:CJDataHeroProperty, stageLevel:String, jsNextForceStar:Json_role_stage_force_star):String
		{
			var str:String = "";
			
//			主动技能【双牙斩】进阶为第一回合释放
//			
//			获得【高级天佑技巧lv1】被动技能
//			微量+生命
//			微量+闪避
//			微量+减伤
			// 武将json信息
			var skillid:int = jsheroProp["skill"+stageLevel];
			// 主动技能信息
			var jsSkill:Json_skill_setting = CJDataOfSkillPropertyList.o.getProperty(skillid);
			// 被动技能信息
			var jsPkill:Json_pskill_setting = CJDataOfPSkillProperty.o.getPSkill(jsNextForceStar.passivityskill);
			if (jsSkill != null) // 主动技能信息填写
//				str += "主动技能【" + CJLang(jsSkill.skillname) + "】进阶为第一回合释放\n\n";
				str += CJLang("STAGE_SKILL_FIRST", {"value":CJLang(jsSkill.skillname)}) + "\n\n";
			if ( null != jsPkill ) // 被动技能填写
			{
//				str += "获得【" + CJLang(jsPkill.skillname) + "】被动技能\n";
				str += CJLang("STAGE_PSKILL_FIRST", {"value":CJLang(jsPkill.skillname)}) + "\n";
				var skilldes:String =  CObjectUtils.clone(jsPkill.skilldes);
				var rg:RegExp = /,/g;
				skilldes = skilldes.replace(rg, "\n");
				str += skilldes;
			}
			
			return str;
		}
		
		
		/**
		 * 获取切换形象描述
		 * @return 
		 */
		public static function getImageDescribe(jsheroProp:CJDataHeroProperty, stageLevel:String):String
		{
			var str:String = "";
//			获得被主动技能【XXXX】
//			获得更高级的主角形象
			// 获得主动的技能
			var newJsheroProp:CJDataHeroProperty = CJDataOfHeroPropertyList.o.getProperty(int(jsheroProp.nexttemplateid));
			newJsheroProp = newJsheroProp==null ? jsheroProp : newJsheroProp;
			if (newJsheroProp != null)
			{
				var skillid:int = jsheroProp["skill"+stageLevel];
				// 主动技能信息
				var jsSkill:Json_skill_setting = CJDataOfSkillPropertyList.o.getProperty(skillid);
				if (jsSkill)
				{
//					str += "获得被主动技能【"+ CJLang(jsSkill.skillname) +"】\n";
					str += CJLang("STAGE_GET_SKILL", {"value":CJLang(jsSkill.skillname)}) + "\n";
					str += jsSkill.skilldes + "\n\n";
//					str += "获得更高级的主角形象";
					str += CJLang("STAGE_IMAGE");
				}
			}
			return str;
		}
		
		
		
		
		
		
	}
}