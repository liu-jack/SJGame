package SJ.Game.winebar
{
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import SJ.Common.Constants.ConstHero;
	import SJ.Common.Constants.ConstMainUI;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Common.Constants.ConstWinebar;
	import SJ.Game.SocketServer.SocketCommand_hero;
	import SJ.Game.SocketServer.SocketCommand_item;
	import SJ.Game.SocketServer.SocketCommand_winebar;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.controls.CJHeroUtil;
	import SJ.Game.controls.CJPanelFrame;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfEnhanceEquip;
	import SJ.Game.data.CJDataOfHeroEquip;
	import SJ.Game.data.CJDataOfHeroList;
	import SJ.Game.data.CJDataOfInlayJewel;
	import SJ.Game.data.CJDataOfWinebar;
	import SJ.Game.data.config.CJDataHeroProperty;
	import SJ.Game.data.config.CJDataOfHeroPropertyList;
	import SJ.Game.data.config.CJDataOfPSkillProperty;
	import SJ.Game.data.config.CJDataOfSkillPropertyList;
	import SJ.Game.data.json.Json_hero_propertys;
	import SJ.Game.data.json.Json_pskill_setting;
	import SJ.Game.data.json.Json_skill_setting;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJConfirmMessageBox;
	import SJ.Game.layer.CJMessageBox;
	import SJ.Game.player.CJPlayerData;
	import SJ.Game.player.CJPlayerNpc;
	
	import engine_starling.SApplication;
	import engine_starling.Events.DataEvent;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	import engine_starling.utils.STween;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import starling.core.Starling;
	import starling.events.Event;
	
	/**
	 * 
	 * @author longtao
	 * 
	 */
	public class CJWinebarHeroLayer extends SLayer
	{
		private var _labelTitle:Label;
		/**  标题 **/
		public function get labelTitle():Label
		{
			return _labelTitle;
		}
		/** @private **/
		public function set labelTitle(value:Label):void
		{
			_labelTitle = value;
		}
		private var _layerPanel:SLayer;
		/**  拉伸底框 **/
		public function get layerPanel():SLayer
		{
			return _layerPanel;
		}
		/** @private **/
		public function set layerPanel(value:SLayer):void
		{
			_layerPanel = value;
		}
		private var _runePos:Label;
		/** 武将转动符文位置 **/
		public function get runePos():Label
		{
			return _runePos;
		}
		/** @private **/
		public function set runePos(value:Label):void
		{
			_runePos = value;
		}

		private var _heroPos:Label;
		/**  武将技能表现脚步位置 **/
		public function get heroPos():Label
		{
			return _heroPos;
		}
		/** @private **/
		public function set heroPos(value:Label):void
		{
			_heroPos = value;
		}
		private var _labelHeroName:Label;
		/**  武将名称 **/
		public function get labelHeroName():Label
		{
			return _labelHeroName;
		}
		/** @private **/
		public function set labelHeroName(value:Label):void
		{
			_labelHeroName = value;
		}
		private var _heroSkillNamePr:Label;
		/**  技能名称 **/
		public function get heroSkillNamePr():Label
		{
			return _heroSkillNamePr;
		}
		/** @private **/
		public function set heroSkillNamePr(value:Label):void
		{
			_heroSkillNamePr = value;
		}
		private var _heroSkillName:Label;
		/**  技能名称 **/
		public function get heroSkillName():Label
		{
			return _heroSkillName;
		}
		/** @private **/
		public function set heroSkillName(value:Label):void
		{
			_heroSkillName = value;
		}
		private var _heroSkillDes:Label;
		/**  技能描述 **/
		public function get heroSkillDes():Label
		{
			return _heroSkillDes;
		}
		/** @private **/
		public function set heroSkillDes(value:Label):void
		{
			_heroSkillDes = value;
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
		private var _leadervaluePr:Label;
		/**  统帅 **/
		public function get leadervaluePr():Label
		{
			return _leadervaluePr;
		}
		/** @private **/
		public function set leadervaluePr(value:Label):void
		{
			_leadervaluePr = value;
		}
		private var _leadervalue:Label;
		/**  统帅 **/
		public function get leadervalue():Label
		{
			return _leadervalue;
		}
		/** @private **/
		public function set leadervalue(value:Label):void
		{
			_leadervalue = value;
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
		private var _heroPAttackPr:Label;
		/**  物理攻击 **/
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
		/**  物理攻击 **/
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
		/**  物理防御 **/
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
		/**  物理防御 **/
		public function get heroPDef():Label
		{
			return _heroPDef;
		}
		/** @private **/
		public function set heroPDef(value:Label):void
		{
			_heroPDef = value;
		}
		private var _heroHPPr:Label;
		/**  生命值 **/
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
		/**  生命值 **/
		public function get heroHP():Label
		{
			return _heroHP;
		}
		/** @private **/
		public function set heroHP(value:Label):void
		{
			_heroHP = value;
		}
		private var _heroMDefPr:Label;
		/**  法术防御 **/
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
		/**  法术防御 **/
		public function get heroMDef():Label
		{
			return _heroMDef;
		}
		/** @private **/
		public function set heroMDef(value:Label):void
		{
			_heroMDef = value;
		}
		private var _heroPassivePr:Label;
		/**  被动技能名称 **/
		public function get heroPassivePr():Label
		{
			return _heroPassivePr;
		}
		/** @private **/
		public function set heroPassivePr(value:Label):void
		{
			_heroPassivePr = value;
		}
		private var _heroPassive:Label;
		/**  被动技能名称 **/
		public function get heroPassive():Label
		{
			return _heroPassive;
		}
		/** @private **/
		public function set heroPassive(value:Label):void
		{
			_heroPassive = value;
		}
		private var _heroPassiveDesPr:Label;
		/**  被动技能描述 **/
		public function get heroPassiveDesPr():Label
		{
			return _heroPassiveDesPr;
		}
		/** @private **/
		public function set heroPassiveDesPr(value:Label):void
		{
			_heroPassiveDesPr = value;
		}
		private var _heroPassiveDes:Label;
		/**  被动技能描述 **/
		public function get heroPassiveDes():Label
		{
			return _heroPassiveDes;
		}
		/** @private **/
		public function set heroPassiveDes(value:Label):void
		{
			_heroPassiveDes = value;
		}
		private var _btnEmploy:Button;
		/**  招募按钮 **/
		public function get btnEmploy():Button
		{
			return _btnEmploy;
		}
		/** @private **/
		public function set btnEmploy(value:Button):void
		{
			_btnEmploy = value;
		}
		private var _btnClose:Button;
		/**  关闭界面 **/
		public function get btnClose():Button
		{
			return _btnClose;
		}
		/** @private **/
		public function set btnClose(value:Button):void
		{
			_btnClose = value;
		}
		// 关闭按钮
		private var _btnShowClose:Button;

		/** 旋转时间  单位秒 **/
		private const _CONST_ROTATION_TIME_:Number = 20;
		
		/// 英雄状态
		private var _heroState:String;
		/// 
		private var _index:String;
		private var _templateid:String;
		
		/**
		 * 武将技能动画
		 */
		private var _animate_hero:CJPlayerNpc;
		
		/** 武将背后符文 **/
		private var _heroRune:ImageLoader;
		/** 补间动画 **/
		private var _heroRuneST:STween;
		
		public function CJWinebarHeroLayer()
		{
			super();
		}
		
		/** 创建用于武将计算的信息, 该武将的heroid为之前设置的templateid **/
		private function _createHeroInfo():Object
		{
			var data:Object = new Object;
			data.equipmentbar = new Object;
			data.inlayData = new Object;
			data.heroEquipment = new Object;
			data.forcestar = "0";
			data.heroInlay = [];
			data.isOnline = true;
			data.rolename = "";
			
			// 装备强化信息
			var enhance:Object = new Object;
			enhance[templateid] = new Object;
			enhance[templateid].armour = "0";
			enhance[templateid].belt = "0";
			enhance[templateid].cloak = "0";
			enhance[templateid].helmet = "0";
			enhance[templateid].shoes = "0";
			enhance[templateid].weapon = "0";
			enhance[templateid].heroid = templateid;
			enhance[templateid].userid = templateid;
			data.playerEnhanceEquip = enhance;
			// 马信息
			var horse:Object = new Object;
			horse.activehorseid = "0";
			horse.currenthorseid = "0";
			horse.isriding = "0";
			horse.leftexp = "0";
			horse.rideskilllevel = "0";
			horse.userid = templateid;
			data.horseInfo = horse;
			// 武将基础信息
			var heroProperty:CJDataHeroProperty = CJDataOfHeroPropertyList.o.getProperty(uint(templateid));
			// 武将列表信息
			data.heroListInfo = new Object;
			var heroInfo:Object = new Object;
			heroInfo.battleeffect = "0";
			heroInfo.battleeffectsum = "0";
			heroInfo.currentexp = "0";
			heroInfo.currentskill = "0";
			heroInfo.currenttalent = "0";
			heroInfo.formationindex = -1;
			heroInfo.heroid = templateid;
			heroInfo.level = "1";
			heroInfo.stagelevel = "0";
			heroInfo.starlevel = "0";
			heroInfo.templateid = templateid;
			heroInfo.userid = "0";
			data.heroListInfo[templateid] = heroInfo;
			
			return data;
		}
		
		override public function dispose():void
		{
			Starling.juggler.remove(_heroRuneST);
			
			super.dispose();
		}
		
		
		override protected function initialize():void
		{
			super.initialize();
			
			this.width = ConstMainUI.MAPUNIT_WIDTH;
			this.height = ConstMainUI.MAPUNIT_HEIGHT;
			
			var tIndex:int = 0;
			// 背景
			var _bg:Scale9Image;
//			_bg = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_dinew") , new Rectangle(40,40 ,8,8)));
//			_bg.width = width;
//			_bg.height = height;
//			_bg.alpha = 0.6;
//			addChildAt(_bg, tIndex++);
//			// 装饰框
//			_bg = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_zhuangshinew") , new Rectangle(15,15,7,3)));
//			_bg.x = _bg+3;
//			_bg.y = _bg+3;
//			_bg.width = _bg.width-6;
//			_bg.height = _bg.width-6;
//			addChildAt(_bg, tIndex++);
			
//			// 显示武将信息面板背景框
//			_bg = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_waibiankuang1") , new Rectangle(18,18 ,3,3)));
//			_bg.x = 270;
//			_bg.y = 45;
//			_bg.width = 152;
//			_bg.height = 244;
//			layerPanel.addChild(_bg);
			

			
			
			var img:ImageLoader;
			img = new ImageLoader;
			img.source = SApplication.assets.getTexture("wujiangzhanshi_di");
			img.x = 54;
			img.y = 30;
			img.scaleX = img.scaleY = 4;
			layerPanel.addChild(img);
			
			// 装饰框
			_bg = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("wujiangzhanshi_wenzidi") , new Rectangle(8,8,2,2)));
			_bg.x = 270;
			_bg.y = 45;
			_bg.width = 154;
			_bg.height = 247;
			layerPanel.addChild(_bg);
			
			var frame:CJPanelFrame = new CJPanelFrame(390-4, 280-4);
			frame.x = 48 + 2;
			frame.y = 26 + 2;
			frame.touchable = false;
			addChild(frame);
			// 外框装饰
			_bg = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_waikuangnew") , new Rectangle(15 , 15 , 1, 1)));
			_bg.x = 48;
			_bg.y = 26;
			_bg.width = 390;
			_bg.height = 280;
			addChild(_bg);
			
//			// 关闭按钮
//			btnClose.defaultSkin = new SImage(SApplication.assets.getTexture("common_guanbianniu01new"));
//			btnClose.downSkin = new SImage(SApplication.assets.getTexture("common_guanbianniu02new"));
//			btnClose.addEventListener(Event.TRIGGERED, function (e:Event):void{
//				SApplication.moduleManager.exitModule("CJWinebarHeroModule");
//			});
//			addChild(btnClose);
			
			// 计算后武将信息
			var heroUtilInfo:Json_hero_propertys = CJHeroUtil.getOthersHeroPropValueAll(templateid, _createHeroInfo());
			// 武将基础信息
			var heroProperty:CJDataHeroProperty = CJDataOfHeroPropertyList.o.getProperty(uint(templateid));
			// 符文
			_heroRune = new ImageLoader;
			_heroRune.source = SApplication.assets.getTexture("zuoqi_dibuyuanquan");
			_heroRune.x = runePos.x;
			_heroRune.y = runePos.y;
			_heroRune.width = 130;
			_heroRune.pivotX = 64;
			_heroRune.pivotY = 63;
			addChild(_heroRune);
			// 符文
			_heroRuneST = new STween(_heroRune, _CONST_ROTATION_TIME_);
			_heroRuneST.animate("rotation", 2*Math.PI);
			_heroRuneST.loop = 1;
			Starling.juggler.add(_heroRuneST);
			
			// 底座
			img = new ImageLoader;
			img.source = SApplication.assets.getTexture("common_dizuo");
			img.x = heroPos.x;
			img.y = heroPos.y;
			img.pivotX = 71;
			img.pivotY = 13;
			addChild(img);
			
			
			// 武将展示
			var playerData:CJPlayerData = new CJPlayerData();
			playerData.templateId = int(templateid);
			_animate_hero = new CJPlayerNpc(playerData , null);
			_animate_hero.lodlevel = CJPlayerNpc.LEVEL_LOD_1;
			_animate_hero.x = heroPos.x;
			_animate_hero.y = heroPos.y;
			_animate_hero.touchable = false; // 使该控件不可触控
			_animate_hero.hidebattleInfo();
			_animate_hero.hideAllTitle();
			addChild(_animate_hero);
			
			/// 武将技能设置字体样式
			fontFormat = new TextFormat("Arial", 12, 0xAEFFFF);
			heroSkillNamePr.textRendererProperties.textFormat = fontFormat;
			heroSkillNamePr.text = CJLang("WINEBAR_ITEM_LABEL_SKILL");
			heroSkillName.textRendererProperties.textFormat = fontFormat;
			
			fontFormat = new TextFormat("Arial", 12, 0xFFFFBD);
			var fontObj:Object = heroSkillNamePr.textRendererProperties; 
			fontObj = heroSkillDes.textRendererProperties; 
			fontObj.textFormat = fontFormat;
			fontObj.multiline = true;
			fontObj.wordWrap = true;
			heroSkillDes.textRendererProperties = fontObj;
			heroSkillDes.textRendererProperties.multiline = true;// 可显示多行
			heroSkillDes.textRendererProperties.wordWrap = true;// 可自动换行
			heroSkillDes.text = CJLang("WINEBAR_ITEM_LABEL_DES");
			// 获取技能名称
			if (null != heroProperty.skill1)
			{
				var skillObj:Json_skill_setting = CJDataOfSkillPropertyList.o.getProperty(heroProperty.skill1) as Json_skill_setting;
				// 技能名称
				heroSkillName.text = CJLang(skillObj.skillname);
//				heroSkillDes.text = CJLang(skillObj.skilldes);
				heroSkillDes.text = skillObj.skilldes;
			}
			else
			{
				// 技能名称
				heroSkillName.text = CJLang("WINEBAR_ITEM_NULL");
				heroSkillDes.text = CJLang("WINEBAR_ITEM_NULL");
			}
			
			// 武将右侧展示信息
			var fontFormat:TextFormat = new TextFormat( "Arial", 12, 0xF0EAAC );
			// 武将名称
			heroNamePr.textRendererProperties.textFormat = fontFormat;
			heroName.textRendererProperties.textFormat = new TextFormat("Arial", 12, ConstHero.ConstHeroNameColor[int(heroProperty.quality)]);
			heroNamePr.text = CJLang("WINEBAR_ITEM_NAME");
			heroName.text = CJLang(heroProperty.name);
//			// 统帅值
//			leadervaluePr.textRendererProperties.textFormat = fontFormat;
//			leadervalue.textRendererProperties.textFormat = fontFormat;
//			leadervaluePr.text = CJLang("WINEBAR_ITEM_LEADERVALUE");
//			leadervalue.text = heroProperty.leadervalue;
			// 武将职业
			heroJobPr.textRendererProperties.textFormat = fontFormat;
			heroJob.textRendererProperties.textFormat = fontFormat;
			heroJobPr.text = CJLang("WINEBAR_ITEM_JOB");
			heroJob.text = CJLang( ConstHero.ConstHeroJobLang[int(heroProperty.job)] );
			
			function countValue( value1:*, value2:* ):String
			{
				value1 = Number(value1);
				value2 = Number(value2);
				
				return String(uint(value1 * (1+value2/100)));
			}
			
			// 物理攻击 / 魔法攻击
			heroPAttackPr.textRendererProperties.textFormat = fontFormat;
//			heroPAttackPr.text  = CJLang("WINEBAR_ITEM_PATTACK");
//			heroPAttack.text = countValue(heroUtilInfo.pattack, heroUtilInfo.strength);
			var job:int = int(heroProperty.job);
			// 战士火枪手  显示物理攻击
			if ( job == ConstHero.constHeroJobFighter || job == ConstHero.constHeroJobArcher)
			{
				// 显示物理攻击
				heroPAttackPr.text = CJLang("HERO_UI_PATTACK");
				heroPAttack.text =  countValue(heroUtilInfo.pattack, heroUtilInfo.strength);
			}
			else
			{
				// 显示魔法攻击
				heroPAttackPr.text = CJLang("HERO_UI_MATTACK");
				heroPAttack.text =  countValue(heroUtilInfo.mattack, heroUtilInfo.intelligence);
			}
			// 物理防御
			heroPDefPr.textRendererProperties.textFormat = fontFormat;
			heroPDefPr.text = CJLang("WINEBAR_ITEM_PDEF");
			heroPDef.text = countValue(heroUtilInfo.pdef, heroUtilInfo.agility);
			// 生命值
			heroHPPr.textRendererProperties.textFormat = fontFormat;
			heroHPPr.text = CJLang("WINEBAR_ITEM_HP");
			heroHP.text = countValue(heroUtilInfo.hp, heroUtilInfo.physique);
			// 法术防御
			heroMDefPr.textRendererProperties.textFormat = fontFormat;
			heroMDefPr.text = CJLang("WINEBAR_ITEM_MDEF");
			heroMDef.text = countValue(heroUtilInfo.mdef, heroUtilInfo.spirit);
			
			fontFormat = new TextFormat("Arial", 12, 0xF1EB71);
			heroPAttack.textRendererProperties.textFormat = fontFormat;
			heroPDef.textRendererProperties.textFormat = fontFormat;
			heroHP.textRendererProperties.textFormat = fontFormat;
			heroMDef.textRendererProperties.textFormat = fontFormat;
			
			/// 被动技能
			fontFormat = new TextFormat("Arial", 10, 0xAEFFFF);
			heroPassivePr.textRendererProperties.textFormat = fontFormat
			heroPassivePr.text = CJLang("WINEBAR_ITEM_LABEL_PSKILL");
			heroPassive.textRendererProperties.textFormat = ConstTextFormat.textformatyellow;
			fontObj = heroPassiveDes.textRendererProperties; 
			fontObj.textFormat = new TextFormat("Arial", 10, 0xFFFFBD);
			fontObj.multiline = true;
			fontObj.wordWrap = true;
			heroPassiveDes.textRendererProperties = fontObj;
//			// 被动技能描述前缀
//			heroPassiveDesPr.textRendererProperties.textFormat = fontFormat;
//			heroPassiveDesPr.text = CJLang("WINEBAR_ITEM_LABEL_DES");
			// 获取技能名称
			var pskillObj:Json_pskill_setting = CJDataOfPSkillProperty.o.getPSkill(heroProperty.genius_0);
			if (null != pskillObj)
			{
				heroPassive.text = CJLang(pskillObj.skillname);
//				heroPassiveDes.text = CJLang(pskillObj.skilldes);
				heroPassiveDes.text = pskillObj.skilldes;
			}
			else
			{
				heroPassive.text = CJLang("WINEBAR_ITEM_NULL");
				heroPassiveDes.text = "";
			}

			
			/// 招募按钮与招募提示信息
			btnEmploy.visible = false;
			// 判断显示状态
			if (heroState == ConstWinebar.ConstWinebarHeroStateNoSelected)	// 未选择
			{
//				labelEmployPosPr.visible = true;
//				labelEmployPos.visible = true;
//				labelEmployConditionPr.visible = true;
//				labelEmployCondition.visible = true;
//				
//				labelEmployPosPr.text = CJLang("WINEBAR_ITEM_EMPLOYPOS");
//				labelEmployConditionPr.text = CJLang("WINEBAR_ITEM_EMPLOYCONDITION");
//				labelEmployPos.text = CJLang("WINEBAR_ITEM_NULL");
//				labelEmployCondition.text = CJLang("WINEBAR_ITEM_NULL");
			}
			else if (heroState == ConstWinebar.ConstWinebarHeroStateSelected)	// 已选择
			{
				btnEmploy.width = 112;
				btnEmploy.height = 30;
				btnEmploy.visible = true;
				fontFormat = new TextFormat( "Arial", 12, 0xF0EAAC );
				btnEmploy.defaultLabelProperties.textFormat = fontFormat;
				btnEmploy.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniuda01new"));
				btnEmploy.downSkin = new SImage(SApplication.assets.getTexture("common_anniuda02new"));
				btnEmploy.label = CJLang("WINEBAR_ITEM_EMPLOY");
				btnEmploy.name = "CLICK_BUTTON_ZHAOMU";
				btnEmploy.addEventListener(Event.TRIGGERED, function (e:Event):void{
					//处理指引
					if(CJDataManager.o.DataOfFuncList.isIndicating)
					{
						CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_INDICATE_NEXT_STEP);
					}
					SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _onPickingComplete);
					SocketCommand_winebar.employ_hero(index);
				});
			}
			else if ( heroState == ConstWinebar.ConstWinebarHeroStateEmployed )	/// 已雇佣
			{
				btnEmploy.width = 25;
				btnEmploy.height = 55;
				btnEmploy.visible = true;
				btnEmploy.defaultSkin = new SImage(SApplication.assets.getTexture("jiuguan_zhaomubiao"));
				btnEmploy.downSkin = new SImage(SApplication.assets.getTexture("jiuguan_zhaomubiao"));
				btnEmploy.label = "";
			}
			else
				btnEmploy.visible = false;
			addChild(btnEmploy);
			
			
			// 关闭
			var close:Button = new Button;
			close.x = 0;
			close.y = 0;
			close.width = width;
			close.height = height;
			addChildAt(close, 0);
			close.addEventListener(Event.TRIGGERED, function (e:Event):void{
				SApplication.moduleManager.exitModule("CJWinebarHeroModule");
			});
			
			// 关闭按钮
			if (null==_btnShowClose)
			{
				_btnShowClose = new Button();
			}
			_btnShowClose.defaultSkin  = new SImage(SApplication.assets.getTexture("common_guanbianniu01new"));
			_btnShowClose.downSkin = new SImage(SApplication.assets.getTexture("common_guanbianniu02new"));
			// 为关闭按钮添加监听
			_btnShowClose.addEventListener(starling.events.Event.TRIGGERED, this._touchBtnClose);
			_btnShowClose.x = _bg.x + _bg.width - 23;
			_btnShowClose.y = _bg.y - 18;
			_btnShowClose.width = 46;
			_btnShowClose.height = 45;
			addChild(_btnShowClose);
			
			
			//处理指引
			if(CJDataManager.o.DataOfFuncList.isIndicating)
			{
				CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_INDICATE_NEXT_STEP);
			}
		}
		
		private function _touchBtnClose(e:Event):void
		{
			SApplication.moduleManager.exitModule("CJWinebarHeroModule");
		}
		
		private function _onPickingComplete(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() != ConstNetCommand.CS_WINEBAR_EMPLOY_HERO)
				return;
			
			switch(message.retcode)
			{
				case 0:
					break;
				case 1:
					CJMessageBox(CJLang("ERROR_WINEBAR_HERO_FRONT"));
					return;
				case 2:
					CJMessageBox(CJLang("ERROR_WINEBAR_HERO_INDEX"));
					return;
				case 3:
					CJMessageBox(CJLang("ERROR_WINEBAR_HERO_SELECT"));
					return;
				case 4:
					CJMessageBox(CJLang("ERROR_WINEBAR_HERO_REPEAT"));
					return;
				case 5:
					CJMessageBox(CJLang("ERROR_WINEBAR_HERO_FULL"));
					return;
				default:
					CJMessageBox(CJLang("ERROR_UNKNOWN")+ "CJWinebarHeroLayer._onPickingComplete retcode="+message.retcode );
					return;
			}
			
			e.target.removeEventListener(e.type, _onPickingComplete);
			
			var rtnObject:Object = message.retparams;
			var heroid:String = rtnObject[0];
			var templateid:int = int(rtnObject[1]);
			
			var heroList:CJDataOfHeroList = CJDataManager.o.DataOfHeroList;
			if (heroList.dataIsEmpty)
			{
				CJDataManager.o.DataOfHeroList.addEventListener(DataEvent.DataLoadedFromRemote , _AddHero);
				CJDataManager.o.DataOfHeroList.loadFromRemote();
			}
			else
			{
				_AddHero();
			}
			
			//刷新道具(新武将默认装备)
			SocketCommand_item.get_equipmentbar();
			SocketCommand_hero.get_puton_equip();
			
			// 提示招募成功
			CJConfirmMessageBox(CJLang("WINEBAR_EMPLOY_SCUUEED"),
			function():void
			{
				SApplication.moduleManager.enterModule('CJFormationModule');
			},null,CJLang("WINEBAR_OPENRANK_TIP"), CJLang("WINEBAR_CLOSETIP")
			);
			
			function _AddHero():void
			{
				var heroList:CJDataOfHeroList = CJDataManager.o.DataOfHeroList;
				heroList.addHero(heroid, templateid);
				
				// 生成新招募武将的装备位数据
				var dataEquip:CJDataOfHeroEquip = CJDataManager.o.DataOfHeroEquip;
				if (!dataEquip.dataIsEmpty)
				{
					dataEquip.addNewHeroEquipData(heroid);
				}
				// 生成新招募武将的装备强化数据
				var dataEnhance:CJDataOfEnhanceEquip = CJDataManager.o.DataOfEnhanceEquip;
				if (!dataEnhance.dataIsEmpty)
				{
					dataEnhance.addNewHeroEnhance(heroid);
				}
				// 生成新招募武将的宝石镶嵌数据
				var dataInlay:CJDataOfInlayJewel = CJDataManager.o.DataOfInlayJewel;
				if (!dataInlay.dataIsEmpty)
				{
					dataInlay.addNewHeroInlayData(heroid);
				}
				
				var winebar:CJDataOfWinebar = CJDataManager.o.DataOfWinebar;
				winebar.setData("herostate"+index, ConstWinebar.ConstWinebarHeroStateEmployed);
			}
			
			SApplication.moduleManager.exitModule("CJWinebarHeroModule");
		}
		
		/**
		 * 英雄状态
		 */
		public function get heroState():String
		{
			return _heroState;
		}
		
		/**
		 * @private
		 */
		public function set heroState(value:String):void
		{
			_heroState = value;
		}

		public function get index():String
		{
			return _index;
		}

		public function set index(value:String):void
		{
			_index = value;
		}

		public function get templateid():String
		{
			return _templateid;
		}

		public function set templateid(value:String):void
		{
			_templateid = value;
		}

		
	}
}