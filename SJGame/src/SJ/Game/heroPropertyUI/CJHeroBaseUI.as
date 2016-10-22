package SJ.Game.heroPropertyUI
{
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import SJ.Common.Constants.ConstBag;
	import SJ.Common.Constants.ConstHero;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.bag.CJBagItem;
	import SJ.Game.controls.CJPanelFrame;
	import SJ.Game.controls.CJPanelTitle;
	import SJ.Game.enhanceequip.CJEnhanceLayerStar;
	import SJ.Game.heroStar.CJScoreBoard;
	import SJ.Game.lang.CJLang;
	import SJ.Game.player.CJPlayerNpc;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	import engine_starling.utils.STween;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.controls.ProgressBar;
	import feathers.display.Scale3Image;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale3Textures;
	import feathers.textures.Scale9Textures;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.filters.ColorMatrixFilter;
	import starling.textures.Texture;
	
	public class CJHeroBaseUI extends SLayer
	{
		private var _heroPropertyLayer:SLayer;
		private var _filter:ColorMatrixFilter;
		
		/**  **/
		public function get heroPropertyLayer():SLayer
		{
			return _heroPropertyLayer;
		}
		/** @private **/
		public function set heroPropertyLayer(value:SLayer):void
		{
			_heroPropertyLayer = value;
		}
		private var _labelJob:Label;
		/**  职业 **/
		public function get labelJob():Label
		{
			return _labelJob;
		}
		/** @private **/
		public function set labelJob(value:Label):void
		{
			_labelJob = value;
		}
		private var _imgZhandouli:ImageLoader;
		/**  战斗力图片 **/
		public function get imgZhandouli():ImageLoader
		{
			return _imgZhandouli;
		}
		/** @private **/
		public function set imgZhandouli(value:ImageLoader):void
		{
			_imgZhandouli = value;
		}
		private var _labelZhandouli:Label;
		/**  战斗力值 **/
		public function get labelZhandouli():Label
		{
			return _labelZhandouli;
		}
		/** @private **/
		public function set labelZhandouli(value:Label):void
		{
			_labelZhandouli = value;
		}
		private var _LabelName:Label;
		/**  玩家名称 **/
		public function get LabelName():Label
		{
			return _LabelName;
		}
		/** @private **/
		public function set LabelName(value:Label):void
		{
			_LabelName = value;
		}
		private var _labelLevel:Label;
		/**  等级 **/
		public function get labelLevel():Label
		{
			return _labelLevel;
		}
		/** @private **/
		public function set labelLevel(value:Label):void
		{
			_labelLevel = value;
		}
		private var _imgEquipment0:ImageLoader;
		/**  武器 **/
		public function get imgEquipment0():ImageLoader
		{
			return _imgEquipment0;
		}
		/** @private **/
		public function set imgEquipment0(value:ImageLoader):void
		{
			_imgEquipment0 = value;
		}
		private var _imgEquipment1:ImageLoader;
		/**  头盔 **/
		public function get imgEquipment1():ImageLoader
		{
			return _imgEquipment1;
		}
		/** @private **/
		public function set imgEquipment1(value:ImageLoader):void
		{
			_imgEquipment1 = value;
		}
		private var _imgEquipment2:ImageLoader;
		/**  铠甲 **/
		public function get imgEquipment2():ImageLoader
		{
			return _imgEquipment2;
		}
		/** @private **/
		public function set imgEquipment2(value:ImageLoader):void
		{
			_imgEquipment2 = value;
		}
		private var _imgEquipment3:ImageLoader;
		/**  披风 **/
		public function get imgEquipment3():ImageLoader
		{
			return _imgEquipment3;
		}
		/** @private **/
		public function set imgEquipment3(value:ImageLoader):void
		{
			_imgEquipment3 = value;
		}
		private var _imgEquipment4:ImageLoader;
		/**  鞋子 **/
		public function get imgEquipment4():ImageLoader
		{
			return _imgEquipment4;
		}
		/** @private **/
		public function set imgEquipment4(value:ImageLoader):void
		{
			_imgEquipment4 = value;
		}
		private var _imgEquipment5:ImageLoader;
		/**  腰带 **/
		public function get imgEquipment5():ImageLoader
		{
			return _imgEquipment5;
		}
		/** @private **/
		public function set imgEquipment5(value:ImageLoader):void
		{
			_imgEquipment5 = value;
		}
		private var _imgDipan:ImageLoader;
		/**  武将底盘 **/
		public function get imgDipan():ImageLoader
		{
			return _imgDipan;
		}
		/** @private **/
		public function set imgDipan(value:ImageLoader):void
		{
			_imgDipan = value;
		}
		private var _labelEXP:Label;
		/**  经验值 **/
		public function get labelEXP():Label
		{
			return _labelEXP;
		}
		/** @private **/
		public function set labelEXP(value:Label):void
		{
			_labelEXP = value;
		}
		private var _labelHP:Label;
		/**  生命值 **/
		public function get labelHP():Label
		{
			return _labelHP;
		}
		/** @private **/
		public function set labelHP(value:Label):void
		{
			_labelHP = value;
		}
		private var _labelHPValue:Label;
		/**  生命值 **/
		public function get labelHPValue():Label
		{
			return _labelHPValue;
		}
		/** @private **/
		public function set labelHPValue(value:Label):void
		{
			_labelHPValue = value;
		}
		private var _labelPhisicalAttack:Label;
		/**  物理攻击或魔法攻击 **/
		public function get labelPhisicalAttack():Label
		{
			return _labelPhisicalAttack;
		}
		/** @private **/
		public function set labelPhisicalAttack(value:Label):void
		{
			_labelPhisicalAttack = value;
		}
		private var _labelPhisicalAttackValue:Label;
		/**  物理攻击或魔法攻击 **/
		public function get labelPhisicalAttackValue():Label
		{
			return _labelPhisicalAttackValue;
		}
		/** @private **/
		public function set labelPhisicalAttackValue(value:Label):void
		{
			_labelPhisicalAttackValue = value;
		}
		private var _labelPhisicalDefence:Label;
		/**  物理防御 **/
		public function get labelPhisicalDefence():Label
		{
			return _labelPhisicalDefence;
		}
		/** @private **/
		public function set labelPhisicalDefence(value:Label):void
		{
			_labelPhisicalDefence = value;
		}
		private var _labelPhisicalDefenceValue:Label;
		/**  物理防御 **/
		public function get labelPhisicalDefenceValue():Label
		{
			return _labelPhisicalDefenceValue;
		}
		/** @private **/
		public function set labelPhisicalDefenceValue(value:Label):void
		{
			_labelPhisicalDefenceValue = value;
		}
		private var _labelMagicDefence:Label;
		/**  法术防御 **/
		public function get labelMagicDefence():Label
		{
			return _labelMagicDefence;
		}
		/** @private **/
		public function set labelMagicDefence(value:Label):void
		{
			_labelMagicDefence = value;
		}
		private var _labelMagicDefenceValue:Label;
		/**  法术防御 **/
		public function get labelMagicDefenceValue():Label
		{
			return _labelMagicDefenceValue;
		}
		/** @private **/
		public function set labelMagicDefenceValue(value:Label):void
		{
			_labelMagicDefenceValue = value;
		}
		private var _labelInitiativeSkill:Label;
		/**  主动技能 **/
		public function get labelInitiativeSkill():Label
		{
			return _labelInitiativeSkill;
		}
		/** @private **/
		public function set labelInitiativeSkill(value:Label):void
		{
			_labelInitiativeSkill = value;
		}
		private var _labelInitiativeSkillValue:Label;
		/**  主动技能 **/
		public function get labelInitiativeSkillValue():Label
		{
			return _labelInitiativeSkillValue;
		}
		/** @private **/
		public function set labelInitiativeSkillValue(value:Label):void
		{
			_labelInitiativeSkillValue = value;
		}
		private var _labelPassiveSkill:Label;
		/**  被动技能 **/
		public function get labelPassiveSkill():Label
		{
			return _labelPassiveSkill;
		}
		/** @private **/
		public function set labelPassiveSkill(value:Label):void
		{
			_labelPassiveSkill = value;
		}
		private var _labelPassiveSkillValue:Label;
		/**  被动技能 **/
		public function get labelPassiveSkillValue():Label
		{
			return _labelPassiveSkillValue;
		}
		/** @private **/
		public function set labelPassiveSkillValue(value:Label):void
		{
			_labelPassiveSkillValue = value;
		}
		private var _labelCommander:Label;
		/**  统帅 **/
		public function get labelCommander():Label
		{
			return _labelCommander;
		}
		/** @private **/
		public function set labelCommander(value:Label):void
		{
			_labelCommander = value;
		}
		private var _labelCommanderValue:Label;
		/**  统帅 **/
		public function get labelCommanderValue():Label
		{
			return _labelCommanderValue;
		}
		/** @private **/
		public function set labelCommanderValue(value:Label):void
		{
			_labelCommanderValue = value;
		}
		private var _labelCaptainSkill:Label;
		/**  队长技能 **/
		public function get labelCaptainSkill():Label
		{
			return _labelCaptainSkill;
		}
		/** @private **/
		public function set labelCaptainSkill(value:Label):void
		{
			_labelCaptainSkill = value;
		}
		private var _labelCaptainSkillValue:Label;
		/**  队长技能 **/
		public function get labelCaptainSkillValue():Label
		{
			return _labelCaptainSkillValue;
		}
		/** @private **/
		public function set labelCaptainSkillValue(value:Label):void
		{
			_labelCaptainSkillValue = value;
		}
		private var _heroLayer:SLayer;
		/**  武将空闲状态图层 **/
		public function get heroLayer():SLayer
		{
			return _heroLayer;
		}
		/** @private **/
		public function set heroLayer(value:SLayer):void
		{
			_heroLayer = value;
		}
		private var _heroStarPos:Label;
		/**  武将星级位置 **/
		public function get heroStarPos():Label
		{
			return _heroStarPos;
		}
		/** @private **/
		public function set heroStarPos(value:Label):void
		{
			_heroStarPos = value;
		}
		private var _btnHeroTrain:Button;
		/**  武将训练按钮 **/
		public function get btnHeroTrain():Button
		{
			return _btnHeroTrain;
		}
		/** @private **/
		public function set btnHeroTrain(value:Button):void
		{
			_btnHeroTrain = value;
		}
		private var _btnHeroStar:Button;
		/**  武将升星按钮 **/
		public function get btnHeroStar():Button
		{
			return _btnHeroStar;
		}
		/** @private **/
		public function set btnHeroStar(value:Button):void
		{
			_btnHeroStar = value;
		}
		private var _btnStageLevel:Button;
		/**  武将升阶按钮 **/
		public function get btnStageLevel():Button
		{
			return _btnStageLevel;
		}
		/** @private **/
		public function set btnStageLevel(value:Button):void
		{
			_btnStageLevel = value;
		}
		private var _detailsLayer:SLayer;
		/**  详细属性图层 **/
		public function get detailsLayer():SLayer
		{
			return _detailsLayer;
		}
		/** @private **/
		public function set detailsLayer(value:SLayer):void
		{
			_detailsLayer = value;
		}
		private var _heroIconBG:ImageLoader;
		/**  武将头像底框 **/
		public function get heroIconBG():ImageLoader
		{
			return _heroIconBG;
		}
		/** @private **/
		public function set heroIconBG(value:ImageLoader):void
		{
			_heroIconBG = value;
		}
		private var _heroIcon:ImageLoader;
		/**  武将头像 **/
		public function get heroIcon():ImageLoader
		{
			return _heroIcon;
		}
		/** @private **/
		public function set heroIcon(value:ImageLoader):void
		{
			_heroIcon = value;
		}
		private var _heroNamePr:Label;
		/**  武将名称 **/
		public function get heroNamePr():Label
		{
			return _heroNamePr;
		}
		/** @private **/
		public function set heroNamePr(value:Label):void
		{
			_heroNamePr = value;
		}
		private var _heroName:Label;
		/**  武将名称 **/
		public function get heroName():Label
		{
			return _heroName;
		}
		/** @private **/
		public function set heroName(value:Label):void
		{
			_heroName = value;
		}
		private var _heroLevelPr:Label;
		/**  等级 **/
		public function get heroLevelPr():Label
		{
			return _heroLevelPr;
		}
		/** @private **/
		public function set heroLevelPr(value:Label):void
		{
			_heroLevelPr = value;
		}
		private var _heroStage:Label;
		/**  等级 **/
		public function get heroStage():Label
		{
			return _heroStage;
		}
		/** @private **/
		public function set heroStage(value:Label):void
		{
			_heroStage = value;
		}
		private var _heroLevel:Label;
		/**  等级 **/
		public function get heroLevel():Label
		{
			return _heroLevel;
		}
		/** @private **/
		public function set heroLevel(value:Label):void
		{
			_heroLevel = value;
		}
		private var _heroJobPr:Label;
		/**  职业 **/
		public function get heroJobPr():Label
		{
			return _heroJobPr;
		}
		/** @private **/
		public function set heroJobPr(value:Label):void
		{
			_heroJobPr = value;
		}
		private var _heroJob:Label;
		/**  职业 **/
		public function get heroJob():Label
		{
			return _heroJob;
		}
		/** @private **/
		public function set heroJob(value:Label):void
		{
			_heroJob = value;
		}
		private var _heroLeaderValuePr:Label;
		/**  统帅 **/
		public function get heroLeaderValuePr():Label
		{
			return _heroLeaderValuePr;
		}
		/** @private **/
		public function set heroLeaderValuePr(value:Label):void
		{
			_heroLeaderValuePr = value;
		}
		private var _heroLeaderValue:Label;
		/**  统帅 **/
		public function get heroLeaderValue():Label
		{
			return _heroLeaderValue;
		}
		/** @private **/
		public function set heroLeaderValue(value:Label):void
		{
			_heroLeaderValue = value;
		}
		private var _btnFireHero:Button;
		/**  解雇按钮 **/
		public function get btnFireHero():Button
		{
			return _btnFireHero;
		}
		/** @private **/
		public function set btnFireHero(value:Button):void
		{
			_btnFireHero = value;
		}
		private var _heroHPPr:Label;
		/**  基础生命 **/
		public function get heroHPPr():Label
		{
			return _heroHPPr;
		}
		/** @private **/
		public function set heroHPPr(value:Label):void
		{
			_heroHPPr = value;
		}
		private var _heroHP:Label;
		/**  基础生命 **/
		public function get heroHP():Label
		{
			return _heroHP;
		}
		/** @private **/
		public function set heroHP(value:Label):void
		{
			_heroHP = value;
		}
		private var _heroPAttackPr:Label;
		/**  基础物攻 **/
		public function get heroPAttackPr():Label
		{
			return _heroPAttackPr;
		}
		/** @private **/
		public function set heroPAttackPr(value:Label):void
		{
			_heroPAttackPr = value;
		}
		private var _heroPAttack:Label;
		/**  基础物攻 **/
		public function get heroPAttack():Label
		{
			return _heroPAttack;
		}
		/** @private **/
		public function set heroPAttack(value:Label):void
		{
			_heroPAttack = value;
		}
		private var _heroPDefPr:Label;
		/**  基础物防 **/
		public function get heroPDefPr():Label
		{
			return _heroPDefPr;
		}
		/** @private **/
		public function set heroPDefPr(value:Label):void
		{
			_heroPDefPr = value;
		}
		private var _heroPDef:Label;
		/**  基础物防 **/
		public function get heroPDef():Label
		{
			return _heroPDef;
		}
		/** @private **/
		public function set heroPDef(value:Label):void
		{
			_heroPDef = value;
		}
		private var _heroMAttackPr:Label;
		/**  基础法攻 **/
		public function get heroMAttackPr():Label
		{
			return _heroMAttackPr;
		}
		/** @private **/
		public function set heroMAttackPr(value:Label):void
		{
			_heroMAttackPr = value;
		}
		private var _heroMAttack:Label;
		/**  基础法攻 **/
		public function get heroMAttack():Label
		{
			return _heroMAttack;
		}
		/** @private **/
		public function set heroMAttack(value:Label):void
		{
			_heroMAttack = value;
		}
		private var _heroMDefPr:Label;
		/**  基础法防 **/
		public function get heroMDefPr():Label
		{
			return _heroMDefPr;
		}
		/** @private **/
		public function set heroMDefPr(value:Label):void
		{
			_heroMDefPr = value;
		}
		private var _heroMDef:Label;
		/**  基础法防 **/
		public function get heroMDef():Label
		{
			return _heroMDef;
		}
		/** @private **/
		public function set heroMDef(value:Label):void
		{
			_heroMDef = value;
		}
		private var _heroCritPr:Label;
		/**  暴击 **/
		public function get heroCritPr():Label
		{
			return _heroCritPr;
		}
		/** @private **/
		public function set heroCritPr(value:Label):void
		{
			_heroCritPr = value;
		}
		private var _heroCrit:Label;
		/**  暴击 **/
		public function get heroCrit():Label
		{
			return _heroCrit;
		}
		/** @private **/
		public function set heroCrit(value:Label):void
		{
			_heroCrit = value;
		}
		private var _heroToughnessPr:Label;
		/**  韧性 **/
		public function get heroToughnessPr():Label
		{
			return _heroToughnessPr;
		}
		/** @private **/
		public function set heroToughnessPr(value:Label):void
		{
			_heroToughnessPr = value;
		}
		private var _heroToughness:Label;
		/**  韧性 **/
		public function get heroToughness():Label
		{
			return _heroToughness;
		}
		/** @private **/
		public function set heroToughness(value:Label):void
		{
			_heroToughness = value;
		}
		private var _heroDodgePr:Label;
		/**  闪避 **/
		public function get heroDodgePr():Label
		{
			return _heroDodgePr;
		}
		/** @private **/
		public function set heroDodgePr(value:Label):void
		{
			_heroDodgePr = value;
		}
		private var _heroDodge:Label;
		/**  闪避 **/
		public function get heroDodge():Label
		{
			return _heroDodge;
		}
		/** @private **/
		public function set heroDodge(value:Label):void
		{
			_heroDodge = value;
		}
		private var _heroHitPr:Label;
		/**  命中 **/
		public function get heroHitPr():Label
		{
			return _heroHitPr;
		}
		/** @private **/
		public function set heroHitPr(value:Label):void
		{
			_heroHitPr = value;
		}
		private var _heroHit:Label;
		/**  命中 **/
		public function get heroHit():Label
		{
			return _heroHit;
		}
		/** @private **/
		public function set heroHit(value:Label):void
		{
			_heroHit = value;
		}
		private var _heroWoodPr:Label;
		/**  木 **/
		public function get heroWoodPr():Label
		{
			return _heroWoodPr;
		}
		/** @private **/
		public function set heroWoodPr(value:Label):void
		{
			_heroWoodPr = value;
		}
		private var _heroWood:Label;
		/**  木 **/
		public function get heroWood():Label
		{
			return _heroWood;
		}
		/** @private **/
		public function set heroWood(value:Label):void
		{
			_heroWood = value;
		}
		private var _heroGoldPr:Label;
		/**  金 **/
		public function get heroGoldPr():Label
		{
			return _heroGoldPr;
		}
		/** @private **/
		public function set heroGoldPr(value:Label):void
		{
			_heroGoldPr = value;
		}
		private var _heroGold:Label;
		/**  金 **/
		public function get heroGold():Label
		{
			return _heroGold;
		}
		/** @private **/
		public function set heroGold(value:Label):void
		{
			_heroGold = value;
		}
		private var _heroSoilPr:Label;
		/**  土 **/
		public function get heroSoilPr():Label
		{
			return _heroSoilPr;
		}
		/** @private **/
		public function set heroSoilPr(value:Label):void
		{
			_heroSoilPr = value;
		}
		private var _heroSoil:Label;
		/**  土 **/
		public function get heroSoil():Label
		{
			return _heroSoil;
		}
		/** @private **/
		public function set heroSoil(value:Label):void
		{
			_heroSoil = value;
		}
		private var _heroFirePr:Label;
		/**  火 **/
		public function get heroFirePr():Label
		{
			return _heroFirePr;
		}
		/** @private **/
		public function set heroFirePr(value:Label):void
		{
			_heroFirePr = value;
		}
		private var _heroFire:Label;
		/**  火 **/
		public function get heroFire():Label
		{
			return _heroFire;
		}
		/** @private **/
		public function set heroFire(value:Label):void
		{
			_heroFire = value;
		}
		private var _heroWaterPr:Label;
		/**  水 **/
		public function get heroWaterPr():Label
		{
			return _heroWaterPr;
		}
		/** @private **/
		public function set heroWaterPr(value:Label):void
		{
			_heroWaterPr = value;
		}
		private var _heroWater:Label;
		/**  水 **/
		public function get heroWater():Label
		{
			return _heroWater;
		}
		/** @private **/
		public function set heroWater(value:Label):void
		{
			_heroWater = value;
		}
		private var _heroCurePr:Label;
		/**  治疗效果 **/
		public function get heroCurePr():Label
		{
			return _heroCurePr;
		}
		/** @private **/
		public function set heroCurePr(value:Label):void
		{
			_heroCurePr = value;
		}
		private var _heroCure:Label;
		/**  治疗效果 **/
		public function get heroCure():Label
		{
			return _heroCure;
		}
		/** @private **/
		public function set heroCure(value:Label):void
		{
			_heroCure = value;
		}
		private var _heroReducehurtPr:Label;
		/**  减伤 **/
		public function get heroReducehurtPr():Label
		{
			return _heroReducehurtPr;
		}
		/** @private **/
		public function set heroReducehurtPr(value:Label):void
		{
			_heroReducehurtPr = value;
		}
		private var _heroReducehurt:Label;
		/**  减伤 **/
		public function get heroReducehurt():Label
		{
			return _heroReducehurt;
		}
		/** @private **/
		public function set heroReducehurt(value:Label):void
		{
			_heroReducehurt = value;
		}
		private var _heroBloodPr:Label;
		/**  吸血 **/
		public function get heroBloodPr():Label
		{
			return _heroBloodPr;
		}
		/** @private **/
		public function set heroBloodPr(value:Label):void
		{
			_heroBloodPr = value;
		}
		private var _heroBlood:Label;
		/**  吸血 **/
		public function get heroBlood():Label
		{
			return _heroBlood;
		}
		/** @private **/
		public function set heroBlood(value:Label):void
		{
			_heroBlood = value;
		}
		private var _heroInchurtPr:Label;
		/**  伤害加深 **/
		public function get heroInchurtPr():Label
		{
			return _heroInchurtPr;
		}
		/** @private **/
		public function set heroInchurtPr(value:Label):void
		{
			_heroInchurtPr = value;
		}
		private var _heroInchurt:Label;
		/**  伤害加深 **/
		public function get heroInchurt():Label
		{
			return _heroInchurt;
		}
		/** @private **/
		public function set heroInchurt(value:Label):void
		{
			_heroInchurt = value;
		}
		private var _heroSkillPr:Label;
		/**  主动技能 **/
		public function get heroSkillPr():Label
		{
			return _heroSkillPr;
		}
		/** @private **/
		public function set heroSkillPr(value:Label):void
		{
			_heroSkillPr = value;
		}
		private var _heroSkill:Label;
		/**  主动技能名称 **/
		public function get heroSkill():Label
		{
			return _heroSkill;
		}
		/** @private **/
		public function set heroSkill(value:Label):void
		{
			_heroSkill = value;
		}
		private var _heroSkillDes:Label;
		/**  主动技能描述 **/
		public function get heroSkillDes():Label
		{
			return _heroSkillDes;
		}
		/** @private **/
		public function set heroSkillDes(value:Label):void
		{
			_heroSkillDes = value;
		}
		private var _heroSkillIcon_0:Label;
		/**  技能Icon位置 0 **/
		public function get heroSkillIcon_0():Label
		{
			return _heroSkillIcon_0;
		}
		/** @private **/
		public function set heroSkillIcon_0(value:Label):void
		{
			_heroSkillIcon_0 = value;
		}
		private var _heroSkillIcon_1:Label;
		/**  技能Icon位置 1 **/
		public function get heroSkillIcon_1():Label
		{
			return _heroSkillIcon_1;
		}
		/** @private **/
		public function set heroSkillIcon_1(value:Label):void
		{
			_heroSkillIcon_1 = value;
		}
		private var _heroSkillIcon_2:Label;
		/**  技能Icon位置 2 **/
		public function get heroSkillIcon_2():Label
		{
			return _heroSkillIcon_2;
		}
		/** @private **/
		public function set heroSkillIcon_2(value:Label):void
		{
			_heroSkillIcon_2 = value;
		}
		private var _heroSkillIcon_3:Label;
		/**  技能Icon位置 3 **/
		public function get heroSkillIcon_3():Label
		{
			return _heroSkillIcon_3;
		}
		/** @private **/
		public function set heroSkillIcon_3(value:Label):void
		{
			_heroSkillIcon_3 = value;
		}
		private var _heroSkillIcon_4:Label;
		/**  技能Icon位置 4 **/
		public function get heroSkillIcon_4():Label
		{
			return _heroSkillIcon_4;
		}
		/** @private **/
		public function set heroSkillIcon_4(value:Label):void
		{
			_heroSkillIcon_4 = value;
		}
		private var _heroPSkillPr:Label;
		/**  被动技能 **/
		public function get heroPSkillPr():Label
		{
			return _heroPSkillPr;
		}
		/** @private **/
		public function set heroPSkillPr(value:Label):void
		{
			_heroPSkillPr = value;
		}
		private var _heroPSkillName:Label;
		/**  被动技能 **/
		public function get heroPSkillName():Label
		{
			return _heroPSkillName;
		}
		/** @private **/
		public function set heroPSkillName(value:Label):void
		{
			_heroPSkillName = value;
		}
		private var _heroPSkill:Label;
		/**  被动技能 **/
		public function get heroPSkill():Label
		{
			return _heroPSkill;
		}
		/** @private **/
		public function set heroPSkill(value:Label):void
		{
			_heroPSkill = value;
		}
		private var _labelBiaoTi:Label;
		/**  标题 **/
		public function get labelBiaoTi():Label
		{
			return _labelBiaoTi;
		}
		/** @private **/
		public function set labelBiaoTi(value:Label):void
		{
			_labelBiaoTi = value;
		}
		private var _btnDetailProperty:Button;
		/**  详细属性按钮 **/
		public function get btnDetailProperty():Button
		{
			return _btnDetailProperty;
		}
		/** @private **/
		public function set btnDetailProperty(value:Button):void
		{
			_btnDetailProperty = value;
		}
		private var _btnClose:Button;
		/**  关闭按钮 **/
		public function get btnClose():Button
		{
			return _btnClose;
		}
		/** @private **/
		public function set btnClose(value:Button):void
		{
			_btnClose = value;
		}
		private var _radioLayer:SLayer;
		/**  武将选择名称按钮列表图层 **/
		public function get radioLayer():SLayer
		{
			return _radioLayer;
		}
		/** @private **/
		public function set radioLayer(value:SLayer):void
		{
			_radioLayer = value;
		}



		
		
		
		
		
		/** 装备弹出框与装备栏间隙 单位：像素 **/
		protected const ConstEquipTipLayerGap:int = 2;
		
		/**武将空闲动画*/
		protected var _animate_hero:CJPlayerNpc;
		
		/**当前操作标签索引*/
		protected var _curHerotagIndex:String;
		/**当前操作武将id*/
		protected var _curHeroid:String;
		
		/** 经验进度条*/
		protected var _progressBarExp:ProgressBar;
		/** 经验进度条上显示的文字百分比 **/
		protected var _expLabel:Label;
		
		/** 武将头像 **/
		protected var _imgHeroIcon:ImageLoader;
		/** 武将头像底框 **/
		protected var _imgHeroIconBG:ImageLoader;
		/** 武将装备obj{2：CJBagItem， 1：CJBagItem} 1武器 2头盔 8铠甲 4披风 16鞋子 32腰带 **/
		protected var _objHeroEquip:Object;
		
		/** 战斗力 **/
		protected var _fightScore:CJScoreBoard;
		/** 武将星级 **/
		protected var _heroStarPanel:CJEnhanceLayerStar;
		/** 标题栏 **/
		protected var _title:CJPanelTitle;
		/** 旋转符文 **/
		private var  _heroRuneST:STween;
		
		private var linkPanel:CJHeroQuickLink;//导航面板
		private var _heroSpeed:Label;//英雄速度tip
		protected var _heroSpeedValue:Label;//英雄速度
		
//		/** 主动技能 **/
//		protected var _vecSkillItem:Vector.<CJHeroUISkillItem> = new Vector.<CJHeroUISkillItem>;
		
		public function CJHeroBaseUI()
		{
			super();
		}
		
		override public function dispose():void
		{
			Starling.juggler.remove(_heroRuneST);
			
			linkPanel!=null && linkPanel.removeFromParent(true); 
			
			super.dispose();
			
			_filter.dispose();
		}
		
		/** 添加所有监听 **/
		public function addAllListener():void
		{
			_addAllListener();
		}
		/** 添加所有监听 **/
		protected function _addAllListener():void
		{
		}
		
		/** 移除所有监听 **/
		public function removeAllListener():void
		{
			_removeAllListener();
		}
		/** 移除所有监听 **/
		protected function _removeAllListener():void
		{
		}
		
//		/// 触摸调用
//		protected function _touchHandler(e:TouchEvent):void
//		{
//		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			this.width = 480;
			this.height = 320;
			
			_filter = new ColorMatrixFilter();
			_filter.adjustSaturation(-1);
			
			heroPropertyLayer.visible = true;
			detailsLayer.visible = false;
			
			var texture:Texture;
			var scale9Texture:Scale9Textures;
			var bg:Scale9Image;
			// 底
			texture = SApplication.assets.getTexture("common_dinew");
			scale9Texture = new Scale9Textures(texture, new Rectangle(1,1 ,2,2));
			bg = new Scale9Image(scale9Texture);
			bg.x = 96;
			bg.y = 21;
			bg.width = 330;
			bg.height = 285;
			addChildAt(bg , 0);
			
			texture = SApplication.assets.getTexture("common_dinewzhezhao");
			scale9Texture = new Scale9Textures(texture, new Rectangle(43,43,2,2));
			bg = new Scale9Image(scale9Texture);
			bg.x = 96;
			bg.y = 21;
			bg.width = 330;
			bg.height = 285;
			addChildAt(bg , 1);
			
			var frame:CJPanelFrame = new CJPanelFrame(bg.width-6, bg.height-6);
			frame.x = 96 + 3;
			frame.y = 21 + 3;
			frame.touchable = false;
			addChild(frame);
			
			texture = SApplication.assets.getTexture("common_waikuangnew");
			scale9Texture = new Scale9Textures(texture, new Rectangle(15 , 15 , 1, 1));
			bg = new Scale9Image(scale9Texture);
			bg.x = 96;
			bg.y = 21;
			bg.width = 330;
			bg.height = 285;
			bg.touchable = false;
			addChild(bg);
			
			var img:ImageLoader = new ImageLoader;
//			img.source = SApplication.assets.getTexture("wujiang_beijing");
//			img.x = bg.x+5;
//			img.y = bg.y+3;
//			heroPropertyLayer.addChildAt(img, 0);
			
			// 关闭按钮纹理
			btnClose.defaultSkin = new SImage( SApplication.assets.getTexture("common_guanbianniu01new") );
			btnClose.downSkin = new SImage( SApplication.assets.getTexture("common_guanbianniu02new") );
			btnClose.addEventListener(Event.TRIGGERED, function(e:Event):void{
				SApplication.moduleManager.exitModule("CJHeroPropertyUIModule");
			});
//			//详细属性纹理
//			var fontFormat:TextFormat = new TextFormat( "Arial", 10, 0xFFC915 );
//			// 标题
			_title = new CJPanelTitle( CJLang("HERO_UI_TITLE") );
			addChild(_title);
			_title.x = labelBiaoTi.x;
			_title.y = labelBiaoTi.y;
			addChild(detailsLayer);
			
			// 详细属性按钮
			btnDetailProperty.defaultLabelProperties.textFormat = ConstTextFormat.textformatwhite;
			btnDetailProperty.label = CJLang("HERO_UI_DETAIL");
			btnDetailProperty.defaultSkin = new SImage( SApplication.assets.getTexture("common_anniu01new") );
			btnDetailProperty.downSkin = new SImage( SApplication.assets.getTexture("common_anniu02new") );
			btnDetailProperty.addEventListener(Event.TRIGGERED, function(e:Event):void{
				heroPropertyLayer.visible = !heroPropertyLayer.visible;
				detailsLayer.visible = !heroPropertyLayer.visible;
				btnDetailProperty.label = heroPropertyLayer.visible ? CJLang("HERO_UI_DETAIL") : CJLang("HERO_UI_COMMON");
			});
			addChild(btnDetailProperty);
			addChild(btnClose);
			
			// 物品栏底框设置
			var i:int = 0;
			// 物品框
			var bagItem:CJBagItem;
			_objHeroEquip = new Object;
			for (i=0; i<ConstHero.ConstHeroWearEquipUpperLimit; ++i)
			{
				var tem:ImageLoader = this["imgEquipment"+i] as ImageLoader;
				tem.filter = _filter;
				
				
				bagItem = new CJBagItem(ConstBag.FrameCreateStateUnlock);
				bagItem.name = "HERO_INDICATE_" + i;
				bagItem.x = tem.x+2;
				bagItem.y = tem.y+1;
				bagItem.width = ConstBag.BAG_ITEM_WIDTH;
				bagItem.height = ConstBag.BAG_ITEM_HEIGHT;
				bagItem.visible = false;
				_objHeroEquip[ConstHero.ConstPosAndEquipObj[i]] = bagItem;
				heroPropertyLayer.addChild(bagItem);
			}
			
			// Lable字体颜色
//			fontFormat = new TextFormat( "Arial", 10, 0xFCE2A3 );
			labelJob.textRendererProperties.textFormat = ConstTextFormat.textformatyellow;
			// 武将等级
//			fontFormat = new TextFormat( "Arial", 10, 0xF4DA47 );
			labelLevel.textRendererProperties.textFormat = ConstTextFormat.textformatyellow;
			
			// 经验文字
			labelEXP.textRendererProperties.textFormat = ConstTextFormat.textformatyellow;
			labelEXP.text = CJLang("HERO_UI_EXP");
			//经验条
			//经验条底图
			var progressImg:ImageLoader = new ImageLoader;
			progressImg.source = SApplication.assets.getTexture("wujiang_jindutiaodi");
			progressImg.x = 160;
			progressImg.y = 230;
			heroPropertyLayer.addChild(progressImg);
//			var scale3texture:Scale3Textures = new Scale3Textures(SApplication.assets.getTexture("wujiang_jindutiaodi"), 8, 8);
//			var progressImg:Scale3Image = new Scale3Image(scale3texture);
//			progressImg.width = 243;
//			progressImg.x = 160;
//			progressImg.y = 230;
//			heroPropertyLayer.addChild(progressImg);
			// 经验条伸缩部分
			var scale3texture:Scale3Textures = new Scale3Textures(SApplication.assets.getTexture("wujiang_jingyantiao1"),2,1);
			var fillSkin:Scale3Image = new Scale3Image(scale3texture);
			_progressBarExp = new ProgressBar;
			_progressBarExp.fillSkin = fillSkin;
			_progressBarExp.x = 162;
			_progressBarExp.y = 235;
			_progressBarExp.width = 238;
			_progressBarExp.height = 6;
			heroPropertyLayer.addChild(_progressBarExp);
			_progressBarExp.validate();
			// 经验条上的显示百分比文字
			_expLabel = new Label;
//			fontFormat = new TextFormat( "Arial", 8, 0xEDFCD8,null,null,null,null,null, TextFormatAlign.CENTER );
			_expLabel.textRendererProperties.textFormat = ConstTextFormat.textformatwhitecenter;
			_expLabel.x = progressImg.x;
			_expLabel.y = progressImg.y;
			_expLabel.width = _progressBarExp.width;
			heroPropertyLayer.addChild(_expLabel);
			
			
			//			fontFormat = new TextFormat( "Arial", 8, 0xFFFFFF,null,null,null,null,null, TextFormatAlign.RIGHT );
//			fontFormat = new TextFormat( "Arial", 8, 0xEDFCD8 );
			labelPhisicalAttack.textRendererProperties.textFormat = ConstTextFormat.textformatwhite;
			labelPhisicalDefence.textRendererProperties.textFormat = ConstTextFormat.textformatwhite;
			labelHP.textRendererProperties.textFormat = ConstTextFormat.textformatwhite;
			labelMagicDefence.textRendererProperties.textFormat = ConstTextFormat.textformatwhite;
			labelCommander.textRendererProperties.textFormat = ConstTextFormat.textformatwhite;
			labelInitiativeSkill.textRendererProperties.textFormat = ConstTextFormat.textformatwhite;
			labelPassiveSkill.textRendererProperties.textFormat = ConstTextFormat.textformatwhite;
			labelCaptainSkill.textRendererProperties.textFormat = ConstTextFormat.textformatwhite;
			labelZhandouli.textRendererProperties.textFormat = ConstTextFormat.textformatwhite;
			
			labelPhisicalAttack.text = CJLang("HERO_UI_PATTACK");
			labelPhisicalDefence.text = CJLang("HERO_UI_PDEFENCE");
			labelHP.text = CJLang("HERO_UI_HP");
			labelMagicDefence.text = CJLang("HERO_UI_MDEFENCE");
			labelCommander.text = CJLang("HERO_UI_LEADERVALUE");
			labelInitiativeSkill.text = CJLang("HERO_UI_SKILL");
			labelPassiveSkill.text = CJLang("HERO_UI_PSKILL");
			labelCaptainSkill.text = CJLang("HERO_UI_LSKILL");
			
			// 统帅值与队长技能不显示
			labelCommander.visible = false;
			labelCommanderValue.visible = false;
			labelCaptainSkill.visible = false;
			labelCaptainSkillValue.visible = false;
			
//			fontFormat = new TextFormat( "Arial", 8, 0xE5FF79 );
			labelPhisicalAttackValue.textRendererProperties.textFormat = ConstTextFormat.textformatyellow;
			labelPhisicalDefenceValue.textRendererProperties.textFormat = ConstTextFormat.textformatyellow;
			labelHPValue.textRendererProperties.textFormat = ConstTextFormat.textformatyellow;
			labelMagicDefenceValue.textRendererProperties.textFormat = ConstTextFormat.textformatyellow;
			labelCommanderValue.textRendererProperties.textFormat = ConstTextFormat.textformatyellow;
			labelInitiativeSkillValue.textRendererProperties.textFormat = ConstTextFormat.textformatyellow;
			labelPassiveSkillValue.textRendererProperties.textFormat = ConstTextFormat.textformatyellow;
			labelCaptainSkillValue.textRendererProperties.textFormat = ConstTextFormat.textformatyellow;
			
			// 武将头像底框
			_imgHeroIconBG = new ImageLoader();
			_imgHeroIconBG.source = SApplication.assets.getTexture("common_wujiangkuang");
			_imgHeroIconBG.pivotX = 67/2;
			_imgHeroIconBG.pivotY = 69;
			_imgHeroIconBG.x = heroIconBG.x;
			_imgHeroIconBG.y = heroIconBG.y;
			detailsLayer.addChild(_imgHeroIconBG);
			// 武将头像
			_imgHeroIcon = new ImageLoader();
			_imgHeroIcon.pivotX = 75/2;
			_imgHeroIcon.pivotY = 75;
			_imgHeroIcon.x = heroIcon.x;
			_imgHeroIcon.y = heroIcon.y;
			detailsLayer.addChild(_imgHeroIcon);
			
			//  信息
//			fontFormat = new TextFormat( "Arial", 10, 0xFFFFFF );
			heroNamePr.textRendererProperties.textFormat = ConstTextFormat.textformatwhite;
			heroLevelPr.textRendererProperties.textFormat = ConstTextFormat.textformatwhite;
			heroJobPr.textRendererProperties.textFormat = ConstTextFormat.textformatwhite;
			heroLeaderValuePr.textRendererProperties.textFormat = ConstTextFormat.textformatwhite;
			heroStage.textRendererProperties.textFormat = ConstTextFormat.textformatwhite;
			
			heroNamePr.text = CJLang("HERO_UI_NAME");
			heroLevelPr.text = CJLang("HERO_UI_LEVEL");
			heroJobPr.text = CJLang("HERO_UI_JOB");
			heroLeaderValuePr.text = CJLang("HERO_UI_LEADERVALUE");
			
			// 统帅力目前不显示  2013/7/26
			heroLeaderValuePr.visible = false;
			heroLeaderValue.visible = false;
			
			_heroStarPanel = new CJEnhanceLayerStar;
			_heroStarPanel.count = ConstHero.ConstMaxHeroStarLevel;
			_heroStarPanel.initLayer();
			_heroStarPanel.x = heroStarPos.x;
			_heroStarPanel.y = heroStarPos.y;
			_heroStarPanel.width = 80;
			_heroStarPanel.height = 17;
			_heroStarPanel.visible = false;
			heroPropertyLayer.addChild(_heroStarPanel);
			
			// 武将战斗力计分板
			_fightScore = new CJScoreBoard(7, CJScoreBoard.ALIGN_LEFT); // 最大支持8位数的战斗力
			_fightScore.x = labelZhandouli.x;
			_fightScore.y = labelZhandouli.y;
			heroPropertyLayer.addChild(_fightScore);
			
			// 武将底座
			imgDipan.source = SApplication.assets.getTexture("common_dizuo");
			
			// 武将符文背景框
			var _heroRuneBG:ImageLoader = new ImageLoader;
			_heroRuneBG.source = SApplication.assets.getTexture("zuoqi_dibuyuanquan");
			_heroRuneBG.x = imgDipan.x + 70;
			_heroRuneBG.y = imgDipan.y - 40;
			_heroRuneBG.width = 130;
			_heroRuneBG.pivotX = 64;
			_heroRuneBG.pivotY = 63;
			heroPropertyLayer.addChildAt(_heroRuneBG, 0);
			// 旋转
			_heroRuneST = new STween( _heroRuneBG, 20);
			_heroRuneST.animate("rotation", 2*Math.PI);
			_heroRuneST.loop = 1;
			// 开始
			Starling.juggler.add(_heroRuneST);
			
			// 详细数据
//			heroName.textRendererFactory = textRender.standardTextRender;
			// 五项属性
			heroHPPr.textRendererProperties.textFormat = ConstTextFormat.textformatwhite;
			heroPAttackPr.textRendererProperties.textFormat = ConstTextFormat.textformatwhite;
			heroPDefPr.textRendererProperties.textFormat = ConstTextFormat.textformatwhite;
			heroMAttackPr.textRendererProperties.textFormat = ConstTextFormat.textformatwhite;
			heroMDefPr.textRendererProperties.textFormat = ConstTextFormat.textformatwhite;
			// 特殊属性
			heroCritPr.textRendererProperties.textFormat = ConstTextFormat.textformatwhite;
			heroToughnessPr.textRendererProperties.textFormat = ConstTextFormat.textformatwhite;
			heroDodgePr.textRendererProperties.textFormat = ConstTextFormat.textformatwhite;
			heroHitPr.textRendererProperties.textFormat = ConstTextFormat.textformatwhite;
			
			heroCurePr.textRendererProperties.textFormat = ConstTextFormat.textformatwhite;
			heroReducehurtPr.textRendererProperties.textFormat = ConstTextFormat.textformatwhite;
			heroBloodPr.textRendererProperties.textFormat = ConstTextFormat.textformatwhite;
			heroInchurtPr.textRendererProperties.textFormat = ConstTextFormat.textformatwhite;
			
			heroHPPr.text = CJLang("HERO_UI_BASE_HP");
			heroPAttackPr.text = CJLang("HERO_UI_BASE_PATTACK");
			heroPDefPr.text = CJLang("HERO_UI_BASE_PDEF");
			heroMAttackPr.text = CJLang("HERO_UI_BASE_MATTACK");
			heroMDefPr.text = CJLang("HERO_UI_BASE_MDEF");
			// 特殊属性
			heroCritPr.text = CJLang("HERO_UI_CRIT");
			heroToughnessPr.text = CJLang("HERO_UI_TOUGHNESS");
			heroDodgePr.text = CJLang("HERO_UI_DODGE");
			heroHitPr.text = CJLang("HERO_UI_HIT");
			heroCurePr.text = CJLang("HERO_UI_CURE");
			heroReducehurtPr.text = CJLang("HERO_UI_REDUCEHURT");
			heroBloodPr.text = CJLang("HERO_UI_BLOOD");
			heroInchurtPr.text = CJLang("HERO_UI_INCHURT");
			
			heroLevel.textRendererProperties.textFormat = ConstTextFormat.textformatwhite;
			heroJob.textRendererProperties.textFormat = ConstTextFormat.textformatwhite;
			heroLeaderValue.textRendererProperties.textFormat = ConstTextFormat.textformatwhite;
			
			// 金木水火土
			var fontFormat:TextFormat = new TextFormat( ConstTextFormat.FONT_FAMILY_HEITI, ConstTextFormat.FONT_SIZE_10, ConstTextFormat.TEXT_COLOR_WUXING_MU );
			heroWoodPr.textRendererProperties.textFormat = fontFormat;
			heroWoodPr.text = CJLang("HERO_UI_WOOD");
			fontFormat = new TextFormat( ConstTextFormat.FONT_FAMILY_HEITI, 10, ConstTextFormat.TEXT_COLOR_WUXING_JIN );
			heroGoldPr.textRendererProperties.textFormat = fontFormat;
			heroGoldPr.text = CJLang("HERO_UI_GOLD");
			fontFormat = new TextFormat( ConstTextFormat.FONT_FAMILY_HEITI, 10, ConstTextFormat.TEXT_COLOR_WUXING_TU );
			heroSoilPr.textRendererProperties.textFormat = fontFormat;
			heroSoilPr.text = CJLang("HERO_UI_SOIL");
			fontFormat = new TextFormat( ConstTextFormat.FONT_FAMILY_HEITI, 10, ConstTextFormat.TEXT_COLOR_WUXING_HUO );
			heroFirePr.textRendererProperties.textFormat = fontFormat;
			heroFirePr.text = CJLang("HERO_UI_FIRE");
			fontFormat = new TextFormat( ConstTextFormat.FONT_FAMILY_HEITI, 10, ConstTextFormat.TEXT_COLOR_WUXING_SHUI );
			heroWaterPr.textRendererProperties.textFormat = fontFormat;
			heroWaterPr.text = CJLang("HERO_UI_WATER");
			
			/// 技能文字
			fontFormat = ConstTextFormat.textformatblue
			heroSkill.textRendererProperties.textFormat = fontFormat;
			heroSkillPr.textRendererProperties.textFormat = fontFormat;
			heroPSkillPr.textRendererProperties.textFormat = fontFormat;
			// 技能名称
			heroPSkillName.textRendererProperties.textFormat = fontFormat;
			
			heroSkillPr.text = CJLang("HERO_UI_SKILL");
			heroPSkillPr.text = CJLang("HERO_UI_PSKILL");
			
			fontFormat = ConstTextFormat.textformatcyan;
			// 基础生命等信息
			heroHP.textRendererProperties.textFormat = fontFormat;
			heroPAttack.textRendererProperties.textFormat = fontFormat;
			heroPDef.textRendererProperties.textFormat = fontFormat;
			heroMAttack.textRendererProperties.textFormat = fontFormat;
			heroMDef.textRendererProperties.textFormat = fontFormat;
			// 金木水火土
			heroWood.textRendererProperties.textFormat = fontFormat;
			heroGold.textRendererProperties.textFormat = fontFormat;
			heroSoil.textRendererProperties.textFormat = fontFormat;
			heroFire.textRendererProperties.textFormat = fontFormat;
			heroWater.textRendererProperties.textFormat = fontFormat;
			// 特殊属性
			heroCrit.textRendererProperties.textFormat = fontFormat;
			heroToughness.textRendererProperties.textFormat = fontFormat;
			heroDodge.textRendererProperties.textFormat = fontFormat;
			heroHit.textRendererProperties.textFormat = fontFormat;
			heroCure.textRendererProperties.textFormat = fontFormat;
			heroReducehurt.textRendererProperties.textFormat = fontFormat;
			heroBlood.textRendererProperties.textFormat = fontFormat;
			heroInchurt.textRendererProperties.textFormat = fontFormat;
			
			fontFormat = ConstTextFormat.textformatyellow;
			// 技能说明
			heroSkillDes.textRendererProperties.textFormat = fontFormat;
			heroPSkill.textRendererProperties.textFormat = fontFormat;
			
			// 
			texture = SApplication.assets.getTexture("common_dinewzhezhao");
			scale9Texture = new Scale9Textures(texture, new Rectangle(43,43,2,2));
			bg = new Scale9Image(scale9Texture);
			bg.x = 106;
			bg.y = 40;
			bg.width = 310;
			bg.height = 266;
			bg.touchable = false;
			detailsLayer.addChildAt(bg, 0);
			
			_heroSpeed = new Label();
			_heroSpeed.width = 100;
			_heroSpeed.height = 25;
			_heroSpeed.x = labelPassiveSkill.x;
			_heroSpeed.y = labelPassiveSkill.y + 14;
			_heroSpeed.text = CJLang("HERO_UI_HEROSPEED");
			_heroSpeed.textRendererProperties.textFormat = ConstTextFormat.textformatwhite;
			heroPropertyLayer.addChild(_heroSpeed);
			
			_heroSpeedValue = new Label();
			_heroSpeedValue.width = 100;
			_heroSpeedValue.height = 25;
			_heroSpeedValue.x = labelPassiveSkill.x + 46;
			_heroSpeedValue.y = labelPassiveSkill.y + 14;
			_heroSpeedValue.text = "0";
			_heroSpeedValue.textRendererProperties.textFormat = ConstTextFormat.textformatcyan;
			heroPropertyLayer.addChild(_heroSpeedValue);
			
//			// 详细界面5个技能
//			for(i=0; i<5; i++)
//			{
//				var item:CJHeroUISkillItem = new CJHeroUISkillItem;
//				_vecSkillItem.push(item);
//				detailsLayer.addChild(item);
//			}
			
			
		}
		
		protected function setLinkPanel(_heroid:String):void
		{
			//集合功能连接
			if(linkPanel==null)
			{
				linkPanel = new CJHeroQuickLink();
				linkPanel.x = 425;
				linkPanel.y = 115;
				addChild(linkPanel);
			}
			
			linkPanel.resflushBt(_heroid);
		}
		
		/**
		 * 计算属性值
		 * @param value1  生命 物攻 物防 魔攻 魔防
		 * @param value2  金 木 水 火 土
		 * @return 
		 * 
		 */
		protected function countValue( value1:*, value2:* ):String
		{
			value1 = Number(value1);
			value2 = Number(value2);
			
			return String(uint(value1 * (1+value2/100)));
		}
		
	}
}