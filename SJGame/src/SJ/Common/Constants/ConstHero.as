package SJ.Common.Constants
{
	/**
	 * 
	 * 武将相关信息
	 * @author longtao
	 * 
	 */
	public final class ConstHero
	{
		public function ConstHero()
		{
		}
		
		/**
		 * 男性武将
		 */
		public static const ConstHeroSexMale:int = 1;
		/**
		 * 女性武将
		 */
		public static const ConstHeroSexFamale:int = 2;
		
		/** 战士 **/
		public static const constHeroJobFighter:int = 1;
		/** 法师 军师 **/
		public static const constHeroJobWizard:int = 2;
		/** 牧师 方士 **/
		public static const constHeroJobPastor:int = 4;
		/** 火枪 射手 **/
		public static const constHeroJobArcher:int = 8;
		/** 怪物 **/
		public static const constHeroJobMonster:int = 16;
		/**
		 * 武将品质名称颜色
		 * 1.白
		 * 2.绿
		 * 3.蓝
		 * 4.紫
		 * 5.橙
		 * 6.红
		 */		
		public static const ConstHeroNameColor:Array = [0x000000,0xFFFFFF,0x4EFF31,0x2E4CBC,0xC042EA,0xFF8400,0xFF0000];
		public static const ConstHeroNameColorString:Array = ["#000000","#FFFFFF","#4EFF31","#2E4CBC","#C042EA","#FF8400","#FF0000"];
		
		/**
		 * 武将职业
		 */
		public static const ConstHeroJobLang:Object = { 
			1:"HERO_UI_JOB1",
			2:"HERO_UI_JOB2",
			4:"HERO_UI_JOB4",
			8:"HERO_UI_JOB8"};
		
		/**
		 * 武将穿装备个数上限
		 */
		public static const ConstHeroWearEquipUpperLimit:int = 6;
		
		/**
		 * 武将穿戴装备位置与武将装备展示位置对照表obj[装备位置(int)：现实位置(int)]
		 */
		public static const ConstEquipAndPosObj:Object = {1:0, 2:1, 8:2, 4:3, 16:4, 32:5};
		
		/**
		*  武将装备展示位置与武将穿戴装备位置对照表obj[现实位置(int):装备位置(int)]
		*/
		public static const ConstPosAndEquipObj:Object = {0:1, 1:2, 2:8, 3:4, 4:16, 5:32};
		
		/**
		 * 武将最大星级上限
		 * */
		public static const ConstMaxHeroStarLevel:int = 5;
		
		/** 武将属性id - 生命 */
		public static const HERO_PROP_SHENGMING:int = 1;
		/** 武将属性id - 物理攻击 */
		public static const HERO_PROP_WUGONG:int = 2;
		/** 武将属性id - 物理防御 */
		public static const HERO_PROP_WUFANG:int = 3;
		/** 武将属性id - 魔法攻击 */
		public static const HERO_PROP_FAGONG:int = 4;
		/** 武将属性id - 魔法防御 */
		public static const HERO_PROP_FAFANG:int = 5;
		/** 武将属性id - 命中 */
		public static const HERO_PROP_MINGZHONG:int = 6;
		/** 武将属性id - 闪避 */
		public static const HERO_PROP_SHANBI:int = 7;
		/** 武将属性id - 暴击 */
		public static const HERO_PROP_BAOJI:int = 8;
		/** 武将属性id - 韧性 */
		public static const HERO_PROP_RENXING:int = 9;
		/** 武将属性id - 金 */
		public static const HERO_PROP_JIN:int = 10;
		/** 武将属性id - 木 */
		public static const HERO_PROP_MU:int = 11;
		/** 武将属性id - 水 */
		public static const HERO_PROP_SHUI:int = 12;
		/** 武将属性id - 火 */
		public static const HERO_PROP_HUO:int = 13;
		/** 武将属性id - 土 */
		public static const HERO_PROP_TU:int = 14;
		/** 武将属性id - 伤害加深 */
		public static const HERO_PROP_SHANGHAIJIASHEN:int = 15;
		/** 武将属性id - 减伤 */
		public static const HERO_PROP_JIANSHANG:int = 16;
		/** 武将属性id - 治疗效果 */
		public static const HERO_PROP_ZHILIAOXIAOGUO:int = 17;
		
		
		/** 武将最多拥有技能个数 **/
		public static const MAX_HERO_SKILL_COUNT:int = 5;
	}
}