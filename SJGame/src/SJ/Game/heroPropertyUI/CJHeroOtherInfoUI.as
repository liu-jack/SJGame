package SJ.Game.heroPropertyUI
{
	import flash.text.TextFormat;
	
	import SJ.Common.Constants.ConstHero;
	import SJ.Common.Constants.ConstPlayer;
	import SJ.Common.Constants.ConstStageLevel;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.SocketServer.SocketCommand_battle;
	import SJ.Game.SocketServer.SocketCommand_friend;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.bag.CJBagItem;
	import SJ.Game.bag.CJItemTooltip;
	import SJ.Game.controls.CJFlyWordsUtil;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.config.CJDataHeroProperty;
	import SJ.Game.data.config.CJDataOfHeroPropertyList;
	import SJ.Game.data.config.CJDataOfItemProperty;
	import SJ.Game.data.config.CJDataOfPSkillProperty;
	import SJ.Game.data.config.CJDataOfSkillPropertyList;
	import SJ.Game.data.config.CJDataOfUpgradeProperty;
	import SJ.Game.data.json.Json_item_setting;
	import SJ.Game.data.json.Json_pskill_setting;
	import SJ.Game.data.json.Json_skill_setting;
	import SJ.Game.dynamics.CJDynamicAddFriendLayer;
	import SJ.Game.formation.CJFormationSkillTip;
	import SJ.Game.friends.CJFriendUtil;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJMessageBox;
	import SJ.Game.player.CJPlayerData;
	import SJ.Game.player.CJPlayerNpc;
	import SJ.Game.player.CJPlayerTitleLayer;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.utils.SStringUtils;
	
	import feathers.controls.Button;
	
	import lib.engine.utils.functions.Assert;
	
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * 其他人的武将列表信息
	 * @author longtao
	 */
	public class CJHeroOtherInfoUI extends CJHeroBaseUI
	{
		/** 数据 **/
		private var _data:Object;
		/** 名称框 **/
		private var _heroNameLayer:CJHeroOtherNameLayer;
		
		/** 好友按钮 **/
		private var _btnFriend:Button;
		/** 私聊按钮 **/
		private var _btnChat:Button;
		/** 同意好友申请按钮 **/
		private var _btnAgreeRequest:Button;
		/** 切磋按钮 **/
		private var _btnFight:Button;
		/** 用户id **/
		private var _userid:String;
		
		/** 武将技能图标列表 **/
		private var _vecSkillIcon:Vector.<CJHeroUISkillItem> = new Vector.<CJHeroUISkillItem>;
		
		public function CJHeroOtherInfoUI()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			// 设置名称显示Layer属性
			if (_heroNameLayer != null && _heroNameLayer.parent == this)
				removeChild(_heroNameLayer);
			_heroNameLayer = new CJHeroOtherNameLayer(_data.rolename, _data.heroListInfo);
			_heroNameLayer.x = radioLayer.x;
			_heroNameLayer.y = radioLayer.y;
			_heroNameLayer.width = radioLayer.width;
			_heroNameLayer.height = radioLayer.height;
			addChild(_heroNameLayer);
			
			// 好友按钮
			_btnFriend = new Button();
			// 是否为好友皮肤不同
			if (!_data.isfriend)
			{
				_btnFriend.defaultSkin = new SImage( SApplication.assets.getTexture("common_anniu01new") );
				_btnFriend.downSkin = new SImage( SApplication.assets.getTexture("common_anniu02new") );
				_btnFriend.disabledSkin = new SImage( SApplication.assets.getTexture("common_anniu03new") );
				_btnFriend.label = CJLang("HERO_UI_ADD_FRIEND");
				_btnFriend.defaultLabelProperties.textFormat = ConstTextFormat.textformatkhaki;
			}
			_btnFriend.visible = false;
			_btnFriend.x = btnHeroTrain.x + 5;
			_btnFriend.y = btnHeroTrain.y;
			_btnFriend.width = 53;
			_btnFriend.height = 22;
			heroPropertyLayer.addChild(_btnFriend);
			_btnFriend.addEventListener(Event.TRIGGERED, function(e:Event):void{
				if (_data.isfriend)
					// 飘字
					CJFlyWordsUtil(CJLang("FRIEND_ALERADY_FRIEND"));
				else
				{
					var requestAddFriend:CJDynamicAddFriendLayer = new CJDynamicAddFriendLayer(_userid);
					CJLayerManager.o.addModuleLayer(requestAddFriend);
				}
			});
			
			// 私聊
			_btnChat = new Button();
			_btnChat.defaultSkin = new SImage( SApplication.assets.getTexture("common_anniu01new") );
			_btnChat.downSkin = new SImage( SApplication.assets.getTexture("common_anniu02new") );
			_btnChat.disabledSkin = new SImage( SApplication.assets.getTexture("common_anniu03new") );
			_btnChat.visible = false;
			_btnChat.x = btnHeroStar.x + 5;
			_btnChat.y = btnHeroStar.y + 5;
			_btnChat.width = 53;
			_btnChat.height = 22;
			heroPropertyLayer.addChild(_btnChat);
			_btnChat.addEventListener(Event.TRIGGERED, function(e:Event):void{
				if (_data.isOnline)
				{
					// 退出武将属性界面模块
					SApplication.moduleManager.exitModule("CJHeroPropertyUIModule");
					//进入聊天模块
					SApplication.moduleManager.enterModule("CJChatModule", {"rolename":_data.rolename , "fromuid":_userid});
				}
				else 
				{
					CJFlyWordsUtil(CJLang("FRIEND_CANNOT_PRIVATE_CHAT"));
				}
			});
			_btnChat.label = CJLang("HERO_UI_CHAT");
			_btnChat.defaultLabelProperties.textFormat = ConstTextFormat.textformatkhaki;
			
			// 切磋
			_btnFight = new Button();
			_btnFight.defaultSkin = new SImage( SApplication.assets.getTexture("common_anniu01new") );
			_btnFight.downSkin = new SImage( SApplication.assets.getTexture("common_anniu02new") );
			_btnFight.disabledSkin = new SImage( SApplication.assets.getTexture("common_anniu03new") );
			_btnFight.visible = false;
			_btnFight.x = btnHeroStar.x + 5;
			_btnFight.y = btnHeroStar.y + 30;
			_btnFight.width = 53;
			_btnFight.height = 22;
			heroPropertyLayer.addChild(_btnFight);
			_btnFight.addEventListener(Event.TRIGGERED, function(e:Event):void{
				var waitTime:uint = CJDataManager.o.DataOfBattlePlayer.waitTime(_userid)
				if ( waitTime == 0 )
					SocketCommand_battle.battleplayer(__battleplayer, _userid);
				else
					CJMessageBox(CJLang("HERO_UI_FIGHT_CD", {"time":waitTime}));
			});
			_btnFight.label = CJLang("HERO_UI_FIGHT");
			_btnFight.defaultLabelProperties.textFormat = ConstTextFormat.textformatkhaki;
			
			
			// 同意好友申请
			_btnAgreeRequest = new Button();
			_btnAgreeRequest.defaultSkin = new SImage( SApplication.assets.getTexture("common_anniu01new") );
			_btnAgreeRequest.downSkin = new SImage( SApplication.assets.getTexture("common_anniu02new") );
			_btnAgreeRequest.disabledSkin = new SImage( SApplication.assets.getTexture("common_anniu03new") );
			_btnAgreeRequest.visible = false;
			_btnAgreeRequest.x = btnHeroStar.x + 5;
			_btnAgreeRequest.y = btnHeroTrain.y;
			_btnAgreeRequest.width = 53;
			_btnAgreeRequest.height = 22;
			heroPropertyLayer.addChild(_btnAgreeRequest);
			_btnAgreeRequest.label = CJLang("FRIEND_AGREE");
			_btnAgreeRequest.defaultLabelProperties.textFormat = ConstTextFormat.textformatkhaki;
			_btnAgreeRequest.addEventListener(Event.TRIGGERED, function(e:Event):void{
				CJFriendUtil.o.responseRetTips();
				SocketCommand_friend.responseAddFriend(_data.requestid);
				// 关闭武将界面
				SApplication.moduleManager.exitModule("CJHeroPropertyUIModule");
			});
			
			
			// 挑战回调
			function __battleplayer(message:SocketMessage):void
			{
				// 
				var rtnObject:Array = message.retparams;
				var obj:Object;
				switch(message.retcode)
				{
					case 0:
						break;
					case 1:
						// 该用户切磋CD中
						CJDataManager.o.DataOfBattlePlayer.addBattlePlayerInfo(_userid, uint(rtnObject[0].lefttime)); 
						CJMessageBox(CJLang("HERO_UI_FIGHT_CD", {"time":rtnObject[0].lefttime}));
						return;
					default:
//						CJMessageBox(CJLang("ERROR_UNKNOWN") + "CJDataOfOLReward._onGetRrewardComplete retcode="+message.retcode );
						return;
				}
				// 战斗数据
				obj = rtnObject[0];
				// 战斗数据
				var tobj:Object = new Object;
				tobj.battleret = new Object;
				tobj.battleret[0] = obj.toString();
				// 信息
				var tempData:Object = _data.heroListInfo[_userid];
				tobj.targetinfo = new Object;
				tobj.targetinfo.templateId = tempData.templateid;
				tobj.targetinfo.battlelevel = _data.battleeffectsum;// 战斗力
				tobj.targetinfo.level = tempData.level;
				tobj.targetinfo.rolename = _data.rolename;
				tobj.targetinfo.userid = _userid;
				
//				tobj.rolename = _data.rolename;
//				tobj.level = tempData.level;
				/// 关闭武将界面
				SApplication.moduleManager.exitModule("CJHeroPropertyUIModule");
				/// 进入武将升星
				SApplication.moduleManager.enterModule("CJArenaBattleModule", tobj);
			}
			
			// 技能显示框
			for(var i:int=0; i<ConstHero.MAX_HERO_SKILL_COUNT; i++)
			{
				var item:CJHeroUISkillItem = new CJHeroUISkillItem;
				item.x = this["heroSkillIcon_"+i].x;
				item.y = this["heroSkillIcon_"+i].y;
				detailsLayer.addChild(item);
				_vecSkillIcon.push(item);
			}
			
			// 判断主将，显示主将信息
			for each ( var obj:Object in _data.heroListInfo)
			{
				var temp:CJDataHeroProperty = CJDataOfHeroPropertyList.o.getProperty(int(obj.templateid));
				if (temp.type == ConstPlayer.SConstPlayerTypePlayer)
				{
					_userid = String(obj.userid);
					_updataHeroLayer(obj);
					var tObj:Object = _heroNameLayer.turnPanel.dataProvider.data["0"];
					tObj.isSelected = true;
					_heroNameLayer.turnPanel.updateItemAt(tObj.index);
					break;
				}
			}
		}
		
		override public function dispose():void
		{
			CJFriendUtil.o.dipose();
			super.dispose();
		}
		/**
		 * 更新界面
		 * @param heroid	要展示的武将id
		 */
		private function _updataHeroLayer(dataObj:Object):void
		{
			// 数据展示
//			216175330831239425	Object (@13dd6641)	
//				battleeffect	"37048"	
//				battleeffectsum	"37048"	
//				currentexp		"0"	
//				currentskill	"0"	
//				currenttalent	"0"	
//				formationindex	-1 [0xffffffff]	
//				heroid			"216175330831239425"	
//				level			"50"	
//				stagelevel		"0"	
//				starlevel		"0"	
//				templateid		"10001"	
//				userid			"216175330831239425"	
//			// 计算后得到的属性
//			var heroPropertys:Json_hero_propertys = CJHeroUtil.getOthersHeroPropValueAll(dataObj.heroid, _data);
			// 基础数据
			var heroProperty:CJDataHeroProperty = CJDataOfHeroPropertyList.o.getProperty(int(dataObj.templateid));
			// 是否为主角
			var isRole:Boolean = false;
			if (dataObj.prop.heroid == dataObj.userid && heroProperty.type == ConstPlayer.SConstPlayerTypePlayer)
				isRole = true;
			
			// 职业
			labelJob.text = CJLang("HERO_UI_JOB")+ ":" + CJLang("HERO_UI_JOB"+heroProperty.job);
			// 等级
			labelLevel.text = "LV" + dataObj.level;
			// 武将名称
			LabelName.textRendererProperties.textFormat = new TextFormat("黑体",10,ConstHero.ConstHeroNameColor[int(heroProperty.quality)]);
			var name:String;
			var selfRoleId:String = CJDataManager.o.DataOfHeroList.getRoleId();
			if (isRole && selfRoleId != _userid)
			{
				LabelName.text = _data.rolename;
				if (!_data.isfriend)
					_btnFriend.visible = true; // 主角才显示该按钮
				_btnFight.visible = true;
				_btnChat.visible = true;
				if (_data.requestid)
				{
					_btnAgreeRequest.visible = true;
					_btnFriend.visible = false;
				}
				else
				{
					_btnAgreeRequest.visible = false;
				}
			}
			else
			{
				LabelName.text = CJLang(heroProperty.name);
				_btnFriend.visible = false;
				_btnFight.visible = false;
				_btnChat.visible = false;
				_btnAgreeRequest.visible = false;
			}
			
			// 战斗力更新
			_fightScore.curNumber = dataObj.battleeffect;
			
			// 判断是否需要更新武将资源
			if (_animate_hero == null ||
				_animate_hero.playerData.templateId !=  dataObj.templateid)
			{
				// 先将原来的武将从舞台中移除
				var playerData:CJPlayerData = new CJPlayerData();
				if ( null != _animate_hero && this.contains(_animate_hero) )
				{
					heroPropertyLayer.removeChild(_animate_hero,true);
				}
				playerData.heroId = dataObj.heroid;
				playerData.templateId = dataObj.templateid;
				_animate_hero = new CJPlayerNpc(playerData , null) ;
				_animate_hero.lodlevel = CJPlayerNpc.LEVEL_LOD_1;
				_animate_hero.hideTitle(CJPlayerTitleLayer.TITLETYPE_ALL);
				_animate_hero.x = heroLayer.x;
				_animate_hero.y = heroLayer.y;
				_animate_hero.hidebattleInfo();
				_animate_hero.touchable = false; // 使该控件不可触控
				heroPropertyLayer.addChild(_animate_hero);
			}
//			// 物攻
//			labelPhisicalAttackValue.text = String( int(heroPropertys.pattack) * int(heroPropertys.strength) );
//			// 物防
//			labelPhisicalDefenceValue.text = String( int(heroPropertys.pdef) * int(heroPropertys.agility) );
//			// hp
//			labelHPValue.text = String( int(heroPropertys.hp) * int(heroPropertys.physique) );
//			// 魔法防御
//			labelMagicDefenceValue.text = String( int(heroPropertys.mdef) * int(heroPropertys.spirit) );
			var job:int = int(heroProperty.job);
			// 战士火枪手  显示物理攻击
			if ( job == ConstHero.constHeroJobFighter || job == ConstHero.constHeroJobArcher)
			{
				// 显示物理攻击
				labelPhisicalAttack.text = CJLang("HERO_UI_PATTACK");
				labelPhisicalAttackValue.text =  dataObj.prop.pattack;//heroPropertys.pattack;
			}
			else
			{
				// 显示魔法攻击
				labelPhisicalAttack.text = CJLang("HERO_UI_MATTACK");
				labelPhisicalAttackValue.text =  dataObj.prop.mattack;
			}
			labelHPValue.text = 			 dataObj.prop.hp;
			labelPhisicalDefenceValue.text = dataObj.prop.pdef;
			labelMagicDefenceValue.text = 	 dataObj.prop.mdef;
			
			
			// 统帅力
			labelCommanderValue.text = heroProperty.leadervalue;
			// 详细说明部分 技能清空
			heroPSkillName.text = "";
			heroPSkill.text = "";
			// 非详细说明技能说明清空
			labelInitiativeSkillValue.text = "";
			labelPassiveSkillValue.text = "";
			labelCaptainSkillValue.text = "";
			// 技能信息
			if (dataObj.currentskill)
			{
				var skillObj:Json_skill_setting = CJDataOfSkillPropertyList.o.getProperty(int(dataObj.currentskill)) as Json_skill_setting;
				Assert(skillObj!=null, "heropropertyui._updataHeroLayer(), skillobj==null");
				if (skillObj!=null)
				{
					labelInitiativeSkillValue.text = CJLang(skillObj.skillname);
				}
			}
			
			// 被动技能 （天赋）
			if (dataObj.currenttalent)
			{
				var pkillJS:Json_pskill_setting = CJDataOfPSkillProperty.o.getPSkill(dataObj.currenttalent);
				if (null != pkillJS)
				{
					labelPassiveSkillValue.text = CJLang(pkillJS.skillname);
					// 详细说明界面
					heroPSkillName.text = CJLang(pkillJS.skillname);
//					heroPSkill.text = CJLang(pkillJS.skilldes);
					heroPSkill.text = pkillJS.skilldes;
				}
			}

			// 队长技能
			labelCaptainSkillValue.text = heroProperty.leaderskillid;
			
			
			// 更新经验条
			_progressBarExp.minimum = 0;
			_progressBarExp.maximum = int(CJDataOfUpgradeProperty.o.getNeedEXP(dataObj.level));
			_progressBarExp.value = int(dataObj.currentexp);
			_expLabel.text = _progressBarExp.value + "/" + _progressBarExp.maximum;
			
			// 武将星级面板
			if (!isRole)
			{
				_heroStarPanel.visible = true;
				_heroStarPanel.level = int(dataObj.starlevel);
				_heroStarPanel.redrawLayer();
			}
			else
				_heroStarPanel.visible = false;
			
			// 更新详细信息
			// 武将头像
			_imgHeroIcon.source = SApplication.assets.getTexture(heroProperty.headicon);
			// 玩家名字
			heroName.textRendererProperties.textFormat = new TextFormat("Arial",10,ConstHero.ConstHeroNameColor[int(heroProperty.quality)]);
			if (isRole)
			{
				heroName.text = _data.rolename;
				// 计算升阶等级
				var forceStar:int = int(_data.forcestar);
				var stageLevel:int = 0;
				stageLevel = forceStar/ConstStageLevel.ConstMaxStar;
				// 升阶等级
				heroStage.text = String(stageLevel) + CJLang("HERO_UI_STAGE_POS");
				// 等级
				heroLevel.text = dataObj.level + CJLang("HERO_UI_LEVEL_POS");
			}
			else
			{
				// 武将名称
				heroName.text = CJLang(heroProperty.name);
				// 武星信息
				heroStage.text = String(dataObj.starlevel) + CJLang("HERO_UI_STAR_POS");
				// 等级
				heroLevel.text = dataObj.level + CJLang("HERO_UI_LEVEL_POS");
			}
			// 职业
			heroJob.text = CJLang("HERO_UI_JOB"+heroProperty.job);
			//统帅
			heroLeaderValue.text = heroProperty.leadervalue;
			// 基础生命
			heroHP.text = dataObj.prop.basehp;
			// 基础物攻
			heroPAttack.text = dataObj.prop.basepattack;
			// 基础物防
			heroPDef.text = dataObj.prop.pdef;
			// 基础法攻
			heroMAttack.text = dataObj.prop.basemattack;
			// 基础法防
			heroMDef.text = dataObj.prop.mdef;
			// 金木水火土
			heroWood.text = dataObj.prop.physique;
			heroGold.text = dataObj.prop.strength;
			heroSoil.text = dataObj.prop.agility;
			heroFire.text = dataObj.prop.intelligence;
			heroWater.text = dataObj.prop.spirit;
			
			// 特殊属性
			heroCrit.text = dataObj.prop.crit;
			heroToughness.text = dataObj.prop.toughness;
			heroDodge.text = dataObj.prop.dodge;
			heroHit.text = dataObj.prop.hit;
			heroCure.text = dataObj.prop.cure;
			heroReducehurt.text = dataObj.prop.reducehurt;
			heroBlood.text = dataObj.prop.blood;
			heroInchurt.text = dataObj.prop.inchurt;
			_heroSpeedValue.text = dataObj.prop.speed;
//			// 技能
//			heroSkillName.text = "";
//			heroSkill.text = "";
//			heroPSkillName.text = "";
//			heroPSkill.text = "";
//			heroCSkillName.text = "";
//			heroCSkill.text = "";
//			skillObj = CJDataOfSkillPropertyList.o.getProperty(heroProperty.skill1) as Json_skill_setting;
//			if (null != skillObj)
//			{
//				heroSkillName.text = CJLang(skillObj.skillname);
//				heroSkill.text = CJLang(skillObj.skilldes);
//			}
//			skillObj = CJDataOfSkillPropertyList.o.getProperty(heroProperty.passiveskillid)  as Json_skill_setting;
//			if (null != skillObj)
//			{
//				heroPSkillName.text = CJLang(skillObj.skillname);
//				heroPSkill.text = CJLang(skillObj.skilldes);
//			}
//			skillObj = CJDataOfSkillPropertyList.o.getProperty(heroProperty.leaderskillid)  as Json_skill_setting;
//			if (null != skillObj)
//			{
//				heroCSkillName.text = CJLang(skillObj.skillname);
//				heroCSkill.text = CJLang(skillObj.skilldes);
//			}
			
			// 主将展示技能列表中的技能
			var skillConfig:Json_skill_setting;
			var icon:CJHeroUISkillItem;
			if (isRole)
			{
				heroSkill.visible = false;
				heroSkillDes.visible = false;
				var skilllist:Object = _data.skillData;
				var curSkill:uint = _data.skillData.selectskill;
				// 技能显示
				for (var i:int; i<_vecSkillIcon.length; i++)
				{
					icon = _vecSkillIcon[i] as CJHeroUISkillItem;
					icon.visible = false;
					var skillid:int = skilllist["skillid"+(i+1)];
					if (skillid == 0)
						icon.setContain("");
					else
					{
						skillConfig = CJDataOfSkillPropertyList.o.getProperty(skillid);
						icon.setContain(skillConfig.skillicon, skillid);
						icon.visible = true;
					}
					
					if ( curSkill == skillid )
						icon.isSelected = true;
				}
			}
			else
			{
				for (i; i<_vecSkillIcon.length; i++)
				{
					icon = _vecSkillIcon[i] as CJHeroUISkillItem;
					icon.visible = false;
				}
				heroSkill.visible = true;
				heroSkillDes.visible = true;
				skillConfig = CJDataOfSkillPropertyList.o.getProperty(uint(dataObj.currentskill));
				if (null==skillConfig)
					skillConfig = CJDataOfSkillPropertyList.o.getProperty(uint(heroProperty.skill1));
				heroSkill.text = null;
				heroSkillDes.text = null;
				if (skillConfig)
				{
					heroSkill.text = CJLang(skillConfig.skillname);
//					heroSkillDes.text = CJLang(skillConfig.skilldes);
					heroSkillDes.text = skillConfig.skilldes;
				}
				
			}
			
			// 刷新装备界面
			_updataEquipment(dataObj);
		}
		
		/**
		 * 刷新装备显示
		 */
		private function _updataEquipment(dataObj:Object):void
		{
			// 装备模板数据
			var templateSetting : CJDataOfItemProperty = CJDataOfItemProperty.o;
			
			// 当前武将装备
			var obj:Object = _data.heroEquipment[dataObj.prop.heroid];
			for (var key:String in _objHeroEquip)
			{
				var bagitem:CJBagItem = _objHeroEquip[key];
				if (obj == null)
				{
					__cleanBagItem(bagitem);
					continue;
				}
				var itemid:String = obj[key];
				// 装备数据
				var itemInfo:Object = _data.equipmentbar[itemid];
				if ( null == itemInfo )
				{
					__cleanBagItem(bagitem);
					continue;
				}
				// 对应模板数据
				var itemTemplate:Json_item_setting = templateSetting.getTemplate(int(itemInfo.templateid));
//				bagitem.templateId = itemInfo.templateid;
				bagitem.setBagGoodsItemByTmpl(itemTemplate, true);
				bagitem.itemId = itemid;
//				bagitem.setBagGoodsItem(itemTemplate.picture);
				bagitem.visible = true;
			}
			
			function __cleanBagItem( bagitem:CJBagItem ):void
			{
				bagitem.setBagGoodsItem("");
				bagitem.itemId = "";
				bagitem.visible = false;
			}
		}
		
		override protected function _addAllListener():void
		{
			// 添加触摸事件
			addEventListener(TouchEvent.TOUCH, _touchHandler);
		}
		override protected function _removeAllListener():void
		{
			removeEventListener(TouchEvent.TOUCH, _touchHandler);
		}
		private function _touchHandler(e:TouchEvent):void
		{
			_touchHeroTag(e);
			_touchEquipment(e);
			_touchSkillIcon(e);
		}
		/** 检测移动范围 **/
		private var _checkPosY:int = 0;
		// 触摸武将名称标签
		private function _touchHeroTag(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this);
			if(touch != null)
			{
				if (touch.phase == TouchPhase.BEGAN)
					_checkPosY = touch.globalY;
				if (touch.phase != TouchPhase.ENDED)
					return;
				if (Math.abs(_checkPosY-touch.globalY) > 5)
					return;
				if( !(touch.target.parent is CJHeroNameItem) )
					return;
				
				// 该名称item
				var item:CJHeroNameItem = touch.target.parent as CJHeroNameItem;
				var obj:Object = _heroNameLayer.turnPanel.dataProvider.data[item.data.index];
				var tempData:Object = _data.heroListInfo[obj.heroId];
				Assert( tempData != null, "CJHeroOtherInfoUI._touchHeroTag()  tempData==null");
				_updataHeroLayer(tempData);
				
				var itemDataList:Array = _heroNameLayer.turnPanel.getAllItemDatas();
				for(var i:int = 0 ; i < itemDataList.length ; i++)
				{
					itemDataList[i].isSelected = false;
					_heroNameLayer.turnPanel.updateItemAt(int(itemDataList[i].index));
				}
				obj.isSelected = true;
				_heroNameLayer.turnPanel.updateItemAt(int(obj.index));
			}
		}
		
		private function _touchEquipment(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this);
			if(touch == null || touch.phase != TouchPhase.ENDED)
				return;
			if (detailsLayer.visible)// || e.target is Button)
				return;
			if(touch.target.parent is CJHeroNameItem)
				return;
			
			var bagitem:CJBagItem;
			for (var key:String in _objHeroEquip)
			{
				bagitem = _objHeroEquip[key];
				if (bagitem.x <= touch.globalX && touch.globalX <= bagitem.x+bagitem.width &&
					bagitem.y <= touch.globalY && touch.globalY <= bagitem.y+bagitem.height)
				{
					break;
				}
				bagitem = null;
			}
			// 没有找到则退出
			if (null == bagitem)
				return;
			
			// 展示物品
			if (!SStringUtils.isEmpty(bagitem.itemId))
			{
				var tips:CJItemTooltip = new CJItemTooltip();
				tips.setOtherItemDataAndRefresh(_data, bagitem.itemId);
//				CJLayerManager.o.addModuleLayer(tips);
				CJLayerManager.o.addToModalLayerFadein(tips);
			}
//			var pos:Point;
//			// 左侧三个道具栏
//			if (bagitem.x == imgEquipment0.x)
//				pos = _getHeroEquipTipLayerPos(bagitem.x, bagitem.y);
//			else	/// 右侧三个道具栏
//				pos = _getHeroEquipTipLayerPos(bagitem.x, bagitem.y, false);
//			
//			var bIsShow:Boolean = _heroEquipTipLayer.setData(_curHeroid, key);
//			_heroEquipTipLayer.visible = bIsShow;
//			_heroEquipTipLayer.x = pos.x;
//			_heroEquipTipLayer.y = pos.y;
//			if (!bIsShow)  // 错误信息
//				CJMessageBox(CJLang("ERROR_HERO_NO_EQUIP"));
		}
		
		private function _touchSkillIcon(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this);
			if(touch == null || touch.phase != TouchPhase.ENDED)
				return;
			
			if (!detailsLayer.visible)
				return;
			
			if(touch.target.parent is CJHeroUISkillItem)
			{
				var skillicon:CJHeroUISkillItem = touch.target.parent as CJHeroUISkillItem;
				var tip:CJFormationSkillTip = new CJFormationSkillTip();
				tip.config = CJDataOfSkillPropertyList.o.getProperty(skillicon.skillid);
				tip.addToLayer();
			}
		}
		
		public function set data(value:Object):void
		{
			_data = value;
		}
	}
}