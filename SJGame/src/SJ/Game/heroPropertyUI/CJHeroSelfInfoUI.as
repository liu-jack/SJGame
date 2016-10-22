package SJ.Game.heroPropertyUI
{
	import SJ.Common.Constants.ConstHero;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstStageLevel;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.SocketServer.SocketCommand_hero;
	import SJ.Game.SocketServer.SocketCommand_herotag;
	import SJ.Game.SocketServer.SocketCommand_item;
	import SJ.Game.SocketServer.SocketCommand_role;
	import SJ.Game.SocketServer.SocketCommand_winebar;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.bag.CJBagItem;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfHero;
	import SJ.Game.data.CJDataOfHeroEquip;
	import SJ.Game.data.CJDataOfItem;
	import SJ.Game.data.CJDataOfScene;
	import SJ.Game.data.CJDataOfUserSkill;
	import SJ.Game.data.CJDataOfWinebar;
	import SJ.Game.data.config.CJDataOfHeroTagProperty;
	import SJ.Game.data.config.CJDataOfItemProperty;
	import SJ.Game.data.config.CJDataOfPSkillProperty;
	import SJ.Game.data.config.CJDataOfSkillPropertyList;
	import SJ.Game.data.config.CJDataOfUpgradeProperty;
	import SJ.Game.data.json.Json_hero_upper_limit_config;
	import SJ.Game.data.json.Json_item_setting;
	import SJ.Game.data.json.Json_pskill_setting;
	import SJ.Game.data.json.Json_skill_setting;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.formation.CJFormationSkillTip;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJConfirmMessageBox;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJMessageBox;
	import SJ.Game.player.CJPlayerData;
	import SJ.Game.player.CJPlayerNpc;
	import SJ.Game.player.CJPlayerTitleLayer;
	import SJ.Game.task.CJTaskEventHandler;
	
	import engine_starling.Events.DataEvent;
	import engine_starling.SApplication;
	import engine_starling.data.SDataBaseRemoteData;
	import engine_starling.display.SImage;
	import engine_starling.utils.SStringUtils;
	
	import feathers.controls.Button;
	
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Dictionary;
	
	import lib.engine.utils.functions.Assert;
	
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * 自己的武将列表信息
	 * @author longtao
	 */
	public class CJHeroSelfInfoUI extends CJHeroBaseUI
	{
		// 背包道具数据标示位
		private const _ConstMarkBagData:int = 1;
		// 装备格子数据
		private const _ConstMarkEquipbarData:int = 2;
		// 武将装备中的道具对应
		private const _ConstMarkHeroEquipData:int = 4;
		// 单个武将显示数据返回
		private const _ConstMarkHeroPropData:int = 8;
		/** 需要通过 1更新背包数据   2装备格子道具数据   4武将当前装备对应数据 **/
		private var _rpcMark:uint = 0;
		
		/** 武将装备弹出框 **/
		private var _heroEquipTipLayer:CJHeroEquipTipLayer;// = new CJHeroEquipTipLayer;
		/**武将名称列表 其中仅放置radiobtn*/
		private var _heroNameLayer:CJHeroNameLayer;
		/** 数据 **/
		private var _vecData:Vector.<SDataBaseRemoteData> = new Vector.<SDataBaseRemoteData>;
		
		/** 武将战斗力列表 {heroid:obj, heroid:obj} **/
		private var _heroFightValue:Object;
		
		/** 首次开启武将界面申请开启标签数量 **/
		private var _heroTagCount:uint;
		
		/** 武将技能图标列表 **/
		private var _vecSkillIcon:Vector.<CJHeroUISkillItem> = new Vector.<CJHeroUISkillItem>;
		
		private var jgBt:Button;//解雇按钮
		
		public function CJHeroSelfInfoUI()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
//			// 解雇按钮
//			btnFireHero.defaultSkin = new SImage( SApplication.assets.getTexture("common_anniuda01new") );
//			btnFireHero.downSkin = new SImage( SApplication.assets.getTexture("common_anniuda02new") );
//			btnFireHero.defaultLabelProperties.textFormat = ConstTextFormat.textformatwhite;
//			btnFireHero.label = CJLang("HERO_UI_FIRE_HERO");
//			btnFireHero.addEventListener(Event.TRIGGERED, function(e:Event):void{
//				CJConfirmMessageBox(CJLang("HERO_UI_FIRE_PROMPT"), _fireHero);
//			});
			
			// 解雇按钮
			jgBt = new Button();
			jgBt.defaultSkin = new SImage( SApplication.assets.getTexture("common_anniuda01new") );
			jgBt.downSkin = new SImage( SApplication.assets.getTexture("common_anniuda02new") );
			jgBt.defaultLabelProperties.textFormat = ConstTextFormat.textformatwhite;
			jgBt.label = CJLang("HERO_UI_FIRE_HERO");
			jgBt.addEventListener(Event.TRIGGERED, function(e:Event):void{
				CJConfirmMessageBox(CJLang("HERO_UI_FIRE_PROMPT"), _fireHero);
			});
			jgBt.x = 111;
			jgBt.y = 251;
			jgBt.width= 55;
			jgBt.height= 17;			
			heroPropertyLayer.addChild(jgBt);
			
			// 技能显示框
			for(var i:int=0; i<ConstHero.MAX_HERO_SKILL_COUNT; i++)
			{
				var item:CJHeroUISkillItem = new CJHeroUISkillItem;
				item.x = this["heroSkillIcon_"+i].x;
				item.y = this["heroSkillIcon_"+i].y;
				detailsLayer.addChild(item);
				_vecSkillIcon.push(item);
			}
			
			
			// 添加数据加载操作
			_vecData.push(CJDataManager.o.DataOfHeroList);
			_vecData.push(CJDataManager.o.DataOfHeroTag);
			_vecData.push(CJDataManager.o.DataOfBag);
			_vecData.push(CJDataManager.o.DataOfHeroEquip);
			_vecData.push(CJDataManager.o.DataOfEquipmentbar);
			_vecData.push(CJDataManager.o.DataOfEnhanceEquip);
			_vecData.push(CJDataManager.o.DataOfInlayJewel);
			_vecData.push(CJDataManager.o.DataOfStageLevel);
			_vecData.push(CJDataManager.o.DataOfUserSkillList);
			for (i=0; i<_vecData.length; i++)
			{
				var data:SDataBaseRemoteData = _vecData[i];
				if (data.dataIsEmpty) // 添加监听
				{
					data.addEventListener(DataEvent.DataLoadedFromRemote, _doInit);
					data.loadFromRemote();
				}
			}
			// 加载武将战斗力
			SocketCommand_hero.getHeroListProp();
			// 初始化数据
			_doInit();
			
		}
		
		/**
		 * 检测限制等级的标签是否应该开启
		 */
		private function _checkLevelTag():void
		{
			// 主角等级
			var level:uint = uint(CJDataManager.o.DataOfHeroList.getMainHero().level);
			var taglist:Array = CJDataManager.o.DataOfHeroTag.herotaglist;
			
			// 
			var b:Boolean = false;
			// 添加监听
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _openHeroTag);
			// 所有的tag
			var heroTagArr:Array = CJDataOfHeroTagProperty.o.heroTagArr;
			for (var i:int=0; i<heroTagArr.length; ++i)
			{
				var js:Json_hero_upper_limit_config = CJDataOfHeroTagProperty.o.getHeroUpperJS(i);
				if ( int(js.level)!=0 && int(js.gold)==0 )
				{
					SocketCommand_herotag.add_herotag(js.id);
					b = true;
					_heroTagCount++;
				}
			}
			// 
			if (!b)
				SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData, _openHeroTag);
		}
		
		private function _openHeroTag(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() != ConstNetCommand.CS_HERO_TAG_ADD)
				return;
			
			//
			_heroTagCount--;
			
			if(message.retcode == 0)
				CJDataManager.o.DataOfHeroTag.herotaglist = message.retparams[0];
			
			if(_heroTagCount == 0)
			{
				// 移除监听
				e.target.removeEventListener(e.type, _openHeroTag);
				// 继续接下来的初始化
				_initNext();
			}
			
		}
		
		/**
		 * 获取所有武将显示信息
		 * @param e
		 */
		private function _onHeroListPropComplete(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() != ConstNetCommand.CS_HERO_GET_HERO_LIST_PROP)
				return;
			if(message.retcode != 0)
				return;
			
			var rtnObject:Object = message.retparams;
			_heroFightValue = rtnObject[0];
			
			_doInit();
		}
		
		/**
		 * 获取单个武将显示
		 * @param e
		 */
		private function _onHeroPropComplete(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() != ConstNetCommand.CS_HERO_GET_HERO_PROP)
				return;
			
			if(message.retcode == 0)
			{
				// 更新单个武将信息
				if (message.retparams && message.retparams.prop)
				{
					if (message.retparams.prop.hasOwnProperty("heroid"))
					{
						var heroid:String = message.retparams.prop.heroid;
						if (heroid)
							_heroFightValue[heroid] = message.retparams;
					}
				}
			}
			else
			{
				SocketCommand_hero.get_heros_and_callback(function (message:SocketMessage):void
				{
					// 更新列表后刷新界面
					_initNext();
				});
			}
			
			CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_CHANGE_EQUIP_COMPLETE, false, {command:ConstNetCommand.CS_HERO_GET_HERO_PROP});
		}
		
		// 数据加载完成
		private function _doInit():void
		{
			for (var i:int=0; i<_vecData.length; i++)
			{
				var data:SDataBaseRemoteData = _vecData[i];
				if (data.dataIsEmpty) // 加载不成功直接返回
					return;
				else	// 加载成功删除监听
				{
					data.removeEventListener(DataEvent.DataLoadedFromRemote , _doInit);
					continue;
				}
			}
			if (_heroFightValue == null)
				return;
			
			// 检测限制等级的标签是否应该开启
			_checkLevelTag();
		}
		
		/**
		 * 初始化
		 */
		private function _initNext():void
		{
			// 设置名称显示Layer属性
			if (_heroNameLayer != null && _heroNameLayer.parent == this)
				removeChild(_heroNameLayer);
			_heroNameLayer = new CJHeroNameLayer(_heroFightValue);
			_heroNameLayer.x = radioLayer.x;
			_heroNameLayer.y = radioLayer.y;
			_heroNameLayer.width = radioLayer.width;
			_heroNameLayer.height = radioLayer.height;
			addChild(_heroNameLayer);
			
			var mainHeroid:String = CJDataManager.o.DataOfHeroList.getRoleId();
			var heroInfo:CJDataOfHero = CJDataManager.o.DataOfHeroList.getHero(mainHeroid);
			_updataHeroLayer(heroInfo);
			
//			var obj:Object = _heroNameLayer.turnPanel.dataProvider.data["0"];
//			obj.isSelected = true;
//			_heroNameLayer.turnPanel.updateItem(obj , obj.index);
			
			// 判断是否应该显示训练
			var isOpen:Boolean = CJDataManager.o.DataOfFuncList.isFunctionOpen("CJHeroTrainModule");
			if (isOpen)
			{
				// 武将训练
				btnHeroTrain.defaultSkin = new SImage( SApplication.assets.getTexture("wujiang_anniu01") );
				btnHeroTrain.downSkin = new SImage( SApplication.assets.getTexture("wujiang_anniu02") );
				btnHeroTrain.defaultLabelProperties.textFormat = ConstTextFormat.textformatwhite;
				btnHeroTrain.label = CJLang("HERO_UI_BTN_TRAIN");
				btnHeroTrain.addEventListener(Event.TRIGGERED, function(e:Event):void{
					/// 关闭武将界面
					SApplication.moduleManager.exitModule("CJHeroPropertyUIModule");
					/// 进入武将训练
					SApplication.moduleManager.enterModule("CJHeroTrainModule");
				});
				heroPropertyLayer.addChild(btnHeroTrain);
			}
			
			// 判断是否应该显示武星按钮
			isOpen = CJDataManager.o.DataOfFuncList.isFunctionOpen("CJHeroStarModule");
			if (isOpen)
			{
				// 武将升星
				btnHeroStar.defaultSkin = new SImage( SApplication.assets.getTexture("wujiang_anniu01") );
				btnHeroStar.downSkin = new SImage( SApplication.assets.getTexture("wujiang_anniu02") );
				btnHeroStar.defaultLabelProperties.textFormat = ConstTextFormat.textformatwhite;
				btnHeroStar.label = CJLang("HERO_UI_BTN_START");
				btnHeroStar.addEventListener(Event.TRIGGERED, function(e:Event):void{
					/// 关闭武将界面
					SApplication.moduleManager.exitModule("CJHeroPropertyUIModule");
					/// 进入武将升星
					SApplication.moduleManager.enterModule("CJHeroStarModule", _curHeroid);
				});
				heroPropertyLayer.addChild(btnHeroStar);
			}
			
			// 判断是否应该显示升阶按钮
			isOpen = CJDataManager.o.DataOfFuncList.isFunctionOpen("CJStageLevelModule");
			if (isOpen)
			{
				// 武将升星
				btnStageLevel.defaultSkin = new SImage( SApplication.assets.getTexture("wujiang_anniu01") );
				btnStageLevel.downSkin = new SImage( SApplication.assets.getTexture("wujiang_anniu02") );
				btnStageLevel.defaultLabelProperties.textFormat = ConstTextFormat.textformatwhite;
				btnStageLevel.label = CJLang("HERO_UI_BTN_STAGE");
				btnStageLevel.addEventListener(Event.TRIGGERED, function(e:Event):void{
					/// 关闭武将界面
					SApplication.moduleManager.exitModule("CJHeroPropertyUIModule");
					/// 进入升阶
					SApplication.moduleManager.enterModule("CJStageLevelModule");
				});
				heroPropertyLayer.addChild(btnStageLevel);
			}
			
		}
		
		
		override protected function _addAllListener():void
		{
			// 添加触摸事件
			addEventListener(TouchEvent.TOUCH, _touchHandler);
			// 监听数据返回
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _onPutonOrTakeOff);
			CJEventDispatcher.o.addEventListener(CJEvent.EVENT_CHANGE_EQUIP_COMPLETE, _onPutonOrTakeOffRefreshLayer);
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _onHeroListPropComplete);
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _onHeroPropComplete);
		}
		override protected function _removeAllListener():void
		{
			removeEventListener(TouchEvent.TOUCH, _touchHandler);
			// 移除监听
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData, _onPutonOrTakeOff);
			CJEventDispatcher.o.removeEventListener(CJEvent.EVENT_CHANGE_EQUIP_COMPLETE, _onPutonOrTakeOffRefreshLayer);
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData, _onHeroListPropComplete);
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData, _onHeroPropComplete);
			
			if (_heroNameLayer)
				_heroNameLayer.removeAllEL();
		}
		
		private function _touchHandler(e:TouchEvent):void
		{
			_touchHeroTag(e);
			_touchEquipment(e);
//			_touchHeroStarPanel(e);
			_touchSkillIcon(e);
		}
		
//		/** 触摸是否移动 **/
//		private var _isTouchMove:Boolean = false;
		/** 检测移动范围 **/
		private var _checkPosY:int = 0;
		// 触摸武将名称标签
		private function _touchHeroTag(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this);
			if(touch != null)
			{
//				if (touch.phase == TouchPhase.BEGAN)
//					_isTouchMove = false;
//				if (touch.phase == TouchPhase.MOVED)
//					_isTouchMove = true;
//				if (touch.phase != TouchPhase.ENDED || _isTouchMove)
//					return;
				
				if (touch.phase == TouchPhase.BEGAN)
					_checkPosY = touch.globalY;
				if (touch.phase != TouchPhase.ENDED)
					return;
				if (Math.abs(_checkPosY-touch.globalY) > 5)
					return;
				
				if( !(touch.target.parent is CJHeroNameItem) )
					return;
				
				var nameitem:CJHeroNameItem = touch.target.parent as CJHeroNameItem;
				
				var obj:Object = _heroNameLayer.dataProvider.data[nameitem.data.index];
				_curHerotagIndex = String(obj.tag);
				var heroDict:Dictionary = CJDataManager.o.DataOfHeroList.herolist;
				if (obj.isUsable) // 可使用标签
				{
					//处理指引
					if(CJDataManager.o.DataOfFuncList.isIndicating)
					{
						CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_INDICATE_NEXT_STEP);
					}
					var heroInfo:CJDataOfHero = heroDict[obj.heroId];
					if (heroInfo == null) // 打开酒馆界面
					{
						var sceneid:String = String(CJDataOfScene.o.sceneid);
						// 判断当前所在城镇   获取当前城镇酒馆   进入酒馆
						// add by longtao
						function enterWinebar():void
						{
							/// 关闭武将界面
							SApplication.moduleManager.exitModule("CJHeroPropertyUIModule");
							/// 进入酒馆模块
							SApplication.moduleManager.enterModule("CJWinebarModule", sceneid);
						}
						
						// 酒馆测试入口
						// 获取酒馆数据
						var _winebar:CJDataOfWinebar = CJDataManager.o.DataOfWinebar;
						if(_winebar.dataIsEmpty)
						{
							_winebar.addEventListener(DataEvent.DataLoadedFromRemote , enterWinebar);
							_winebar.loadFromRemote(sceneid);
							SocketCommand_winebar.get_winbarInfo(sceneid);
						}
						else
							enterWinebar();
					}
					else // 更新界面
					{
						_updataHeroLayer(heroInfo);
						
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
				else
				{
					// 查看该标签为需要何种条件
					var heroUpperlimit:Json_hero_upper_limit_config = CJDataOfHeroTagProperty.o.getHeroUpperJS(int(obj.tag));
					// 需要元宝
					if( int(heroUpperlimit.gold) != 0)
					{
						CJConfirmMessageBox(CJLang("HERO_UI_GOLD_PROMPT", {"gold":heroUpperlimit.gold}), _onOpenHerotag);
					}
					// 等级限制
					else if (int(heroUpperlimit.level) != 0)
					{
						_onOpenHerotag();
					}
//					else
//					{
//						CJMessageBox(CJLang("HERO_UI_LEVEL_PROMPT"));
//					}
				}
			}
		}
		
		// 点击装备
		private function _touchEquipment(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this);
			if(touch == null || touch.phase != TouchPhase.ENDED)
				return;
			if (detailsLayer.visible || e.target is Button)
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
			
			_heroEquipTipLayer = new CJHeroEquipTipLayer;
			var bIsShow:Boolean = _heroEquipTipLayer.setData(String(_curHeroid), String(key));
			if (!bIsShow)  // 错误信息
				CJMessageBox(CJLang("ERROR_HERO_NO_EQUIP"));
			else
			{
				CJLayerManager.o.addModuleLayer(_heroEquipTipLayer);
//				if(CJDataManager.o.DataOfFuncList.isIndicating)
//				{
//					CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_INDICATE_NEXT_STEP);
//				}
			}
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
				if(skillicon!=null && skillicon.skillid != 0)
				{
					var tip:CJFormationSkillTip = new CJFormationSkillTip();
					tip.config = CJDataOfSkillPropertyList.o.getProperty(skillicon.skillid);
					tip.addToLayer();
				}
			}
		}
		
		override public function dispose():void
		{
			if(isDispose)
			{
				return;
			}
			// TODO Auto Generated method stub
			if(_animate_hero != null)
				_animate_hero.removeFromParent(true);
			_animate_hero = null;
			
			if (_heroEquipTipLayer != null)
				_heroEquipTipLayer.removeFromParent(true);
			_heroEquipTipLayer = null;
			super.dispose();
		}
		
		
		
		// 刷新武将面板
		private function _updataHeroLayer( heroInfo:CJDataOfHero ):void
		{
			Assert( heroInfo!=null, "Click role does not exist!!!" );
			if (!heroInfo)
				return;
			
			// 获取计算后值
//			var heroPropertys:Json_hero_propertys = CJHeroUtil.getHeroPropValueAll(heroInfo.heroid);
			var heroPropertys:Object = _heroFightValue[heroInfo.heroid].prop;
			
			// 赋值
			_curHeroid = heroInfo.heroid;
			labelJob.text = CJLang("HERO_UI_JOB")+ ":" + CJLang("HERO_UI_JOB"+heroInfo.heroProperty.job);
			//			labelLevel.text = CJLang("HERO_UI_LEVEL")+ ":" + heroInfo.level;
			labelLevel.text = "LV" + heroInfo.level;
			// 武将名称  new TextFormat(FONT_FAMILY_LISHU, 18, 0xFFE6BC,null,null,null,null,null,TextFormatAlign.CENTER);
			LabelName.textRendererProperties.textFormat = new TextFormat("黑体",10,ConstHero.ConstHeroNameColor[int(heroInfo.heroProperty.quality)],null,null,null,null,null,TextFormatAlign.CENTER);
			var name:String;
			if (heroInfo.isRole)
				LabelName.text = CJDataManager.o.DataOfRole.name;
			else
				LabelName.text = CJLang(heroInfo.heroProperty.name);
			
			// 战斗力更新
			_fightScore.curNumber = _heroFightValue[heroInfo.heroid].battleeffect;
			
			// 判断是否需要更新武将资源
			if (_animate_hero == null ||
				_animate_hero.playerData.templateId !=  heroInfo.templateid)
			{
				// 先将原来的武将从舞台中移除
				var playerData:CJPlayerData = new CJPlayerData();
				if ( null != _animate_hero && this.contains(_animate_hero) )
				{
					heroPropertyLayer.removeChild(_animate_hero,true);
				}
				playerData.heroId = heroInfo.heroid;
				playerData.templateId = heroInfo.templateid;
				_animate_hero = new CJPlayerNpc(playerData, null) ;
				_animate_hero.lodlevel = CJPlayerNpc.LEVEL_LOD_1;
				_animate_hero.hideTitle(CJPlayerTitleLayer.TITLETYPE_ALL);
				_animate_hero.x = heroLayer.x;
				_animate_hero.y = heroLayer.y;
				_animate_hero.hidebattleInfo();
				_animate_hero.touchable = false; // 使该控件不可触控
				heroPropertyLayer.addChild(_animate_hero);
			}
			
//			labelPhisicalAttackValue.text =   String( int(Number(heroPropertys.pattack) * (1+Number(heroPropertys.strength)/100) );
//			labelPhisicalDefenceValue.text =  String( Number(heroPropertys.pdef) * (1+Number(heroPropertys.agility)/100) );
//			labelHPValue.text = 			  String( Number(heroPropertys.hp) * (1+Number(heroPropertys.physique)/100) );
//			labelMagicDefenceValue.text = 	  String( Number(heroPropertys.mdef) * (1+Number(heroPropertys.spirit)/100) );
			
			var job:int = int(heroInfo.heroProperty.job);
			// 战士火枪手  显示物理攻击
			if ( job == ConstHero.constHeroJobFighter || job == ConstHero.constHeroJobArcher)
			{
				// 显示物理攻击
				labelPhisicalAttack.text = CJLang("HERO_UI_PATTACK");
				labelPhisicalAttackValue.text =  heroPropertys.pattack;//countValue(heroPropertys.pattack, heroPropertys.strength);
			}
			else
			{
				// 显示魔法攻击
				labelPhisicalAttack.text = CJLang("HERO_UI_MATTACK");
				labelPhisicalAttackValue.text =  heroPropertys.mattack;//countValue(heroPropertys.mattack, heroPropertys.intelligence);
			}
			labelPhisicalDefenceValue.text = heroPropertys.pdef;//countValue(heroPropertys.pdef, heroPropertys.agility);
			labelHPValue.text = 			 heroPropertys.hp;//countValue(heroPropertys.hp, heroPropertys.physique);
			labelMagicDefenceValue.text = 	 heroPropertys.mdef;//countValue(heroPropertys.mdef, heroPropertys.spirit);
			
//			// 计算属性
//			function countValue( value1:*, value2:* ):String
//			{
//				value1 = Number(value1);
//				value2 = Number(value2);
//				
//				return String(value1 * (1+value2/100));
//			}
			
			// 统帅
			labelCommanderValue.text = heroInfo.heroProperty.leadervalue;
			// 详细说明部分 技能清空
			heroPSkillName.text = "";
			heroPSkill.text = "";
			// 非详细说明技能说明清空
			labelInitiativeSkillValue.text = "";
//			heroSkill.text = "";
			labelPassiveSkillValue.text = "";
			labelCaptainSkillValue.text = "";
			// 主动技能
			var skillObj:Json_skill_setting = CJDataOfSkillPropertyList.o.getProperty(int(heroInfo.currentskill)) as Json_skill_setting;
			if (skillObj==null)
				skillObj = CJDataOfSkillPropertyList.o.getProperty(uint(heroInfo.heroProperty.skill1));
			labelInitiativeSkillValue.text = CJLang(skillObj.skillname);
			
			if (heroInfo.currenttalent)
			{
				// 被动技能 （天赋）
				var pkillJS:Json_pskill_setting = CJDataOfPSkillProperty.o.getPSkill(heroInfo.currenttalent);
				if (null != pkillJS)
				{
					labelPassiveSkillValue.text = CJLang(pkillJS.skillname);
					// 详细说明界面
					heroPSkillName.text = CJLang(pkillJS.skillname);
//					heroPSkill.text = CJLang(pkillJS.skilldes);
					heroPSkill.text = pkillJS.skilldes;
				}
			}
			
//			// 队长技能
//			labelCaptainSkillValue.text = heroInfo.heroProperty.leaderskillid;
			
			// 更新经验条
			_progressBarExp.minimum = 0;
			_progressBarExp.maximum = int(CJDataOfUpgradeProperty.o.getNeedEXP(heroInfo.level));
			_progressBarExp.value = int(heroInfo.currentexp);
			_expLabel.text = _progressBarExp.value + "/" + _progressBarExp.maximum;
			
			// 武将星级面板
			if (!heroInfo.isRole)
			{
				_heroStarPanel.visible = true;
				_heroStarPanel.level = int(heroInfo.starlevel);
				_heroStarPanel.redrawLayer();
				btnHeroStar.visible = true; // 普通武将可升星 
				btnStageLevel.visible = false; // 普通武将不可升阶
			}
			else
			{
				_heroStarPanel.visible = false;
				btnHeroStar.visible = false; // 主将不可升星
				btnStageLevel.visible = true; // 主将可升阶
			}
			
			
			
			// 更新详细信息
			// 判断解雇按钮是否需要存在
			if (heroInfo.isRole){
//				btnFireHero.visible = false;
				jgBt.visible = false;
			}else{
//				btnFireHero.visible = true;
				jgBt.visible = true;
			}
			
			// 武将头像
			_imgHeroIcon.source = SApplication.assets.getTexture(heroInfo.heroProperty.headicon);
			// 玩家名字
			heroName.textRendererProperties.textFormat = new TextFormat("Arial",10,ConstHero.ConstHeroNameColor[int(heroInfo.heroProperty.quality)]);
			if (heroInfo.isRole)
				heroName.text = CJDataManager.o.DataOfRole.name;
			else
				heroName.text = CJLang(heroInfo.heroProperty.name);
			
			heroStage.text = "";
			heroLevel.text = "";
			if (heroInfo.isRole)
			{
				// 计算升阶等级
				var forceStar:int = int(CJDataManager.o.DataOfStageLevel.forceStar);
				var stageLevel:int = 0;
				stageLevel = forceStar/ConstStageLevel.ConstMaxStar;
				// 升阶等级
				heroStage.text = String(stageLevel) + CJLang("HERO_UI_STAGE_POS");
				// 等级
				heroLevel.text = heroInfo.level + CJLang("HERO_UI_LEVEL_POS");
			}
			else
			{
				// 武星信息
				heroStage.text = String(heroInfo.starlevel) + CJLang("HERO_UI_STAR_POS");
				// 等级
				heroLevel.text = heroInfo.level + CJLang("HERO_UI_LEVEL_POS");
			}

			
			// 职业
			heroJob.text = CJLang("HERO_UI_JOB"+heroInfo.heroProperty.job);
			//统帅
			heroLeaderValue.text = heroInfo.heroProperty.leadervalue;
			// 基础生命
			heroHP.text = heroPropertys.basehp;//heroInfo.heroProperty.hp;
			// 基础物攻
			heroPAttack.text = heroPropertys.basepattack;//heroInfo.heroProperty.pattack;
			// 基础物防
			heroPDef.text = heroPropertys.basepdef;//heroInfo.heroProperty.pdef;
			// 基础法攻
			heroMAttack.text = heroPropertys.basemattack;//heroInfo.heroProperty.mattack;
			// 基础法防
			heroMDef.text = heroPropertys.basemdef;//heroInfo.heroProperty.mdef;
			// 金木水火土
			heroWood.text = heroPropertys.physique;//heroInfo.heroProperty.hp;
			heroGold.text = heroPropertys.strength;//heroInfo.heroProperty.pattack;
			heroSoil.text = heroPropertys.agility;//heroInfo.heroProperty.pdef;
			heroFire.text = heroPropertys.intelligence;//heroInfo.heroProperty.mattack;
			heroWater.text = heroPropertys.spirit;//heroInfo.heroProperty.mdef;
			
			// 特殊属性
			heroCrit.text = heroPropertys.crit;
			heroToughness.text = heroPropertys.toughness;
			heroDodge.text = heroPropertys.dodge;
			heroHit.text = heroPropertys.hit;
			heroCure.text = heroPropertys.cure;
			heroReducehurt.text = heroPropertys.reducehurt;
			heroBlood.text = heroPropertys.blood;
			heroInchurt.text = heroPropertys.inchurt;
			_heroSpeedValue.text = heroPropertys.speed;
			
			// 主将展示技能列表中的技能
			var skillConfig:Json_skill_setting;
			var icon:CJHeroUISkillItem;
			if (heroInfo.isRole)
			{
				heroSkill.visible = false;
				heroSkillDes.visible = false;
				var skilllist:CJDataOfUserSkill = CJDataManager.o.DataOfUserSkillList.skillDao;
				var curSkill:uint = CJDataManager.o.DataOfUserSkillList.getCurrentSkill();
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
//				icon = _vecSkillIcon[0] as CJHeroUISkillItem;
//				icon.visible = true;
//				skillConfig = CJDataOfSkillPropertyList.o.getProperty(uint(heroInfo.currentskill));
//				icon.setContain(skillConfig.skillicon, uint(heroInfo.currentskill), true);
				heroSkill.visible = true;
				heroSkillDes.visible = true;
				skillConfig = CJDataOfSkillPropertyList.o.getProperty(uint(heroInfo.currentskill));
				if (null==skillConfig)
					skillConfig = CJDataOfSkillPropertyList.o.getProperty(uint(heroInfo.heroProperty.skill1));
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
			_updataEquipment(heroInfo);
			
			//自己显示功能连接
			this.setLinkPanel(_curHeroid);
		}
		
		/**
		 * 刷新装备显示
		 */
		private function _updataEquipment(heroInfo:CJDataOfHero):void
		{
			Assert( heroInfo!=null, "Click role does not exist!!!" );
			// 装备模板数据
			var templateSetting : CJDataOfItemProperty = CJDataOfItemProperty.o;
			
			// 武将装备数据
			var heroequip:CJDataOfHeroEquip = CJDataManager.o.DataOfHeroEquip;
			// 当前武将装备
			var obj:Object = heroequip.heroEquipObj[heroInfo.heroid];
			
			for (var key:String in _objHeroEquip)
			{
				var bagitem:CJBagItem = _objHeroEquip[key];
				if (obj == null)
				{
					bagitem.setBagGoodsItem("");
					bagitem.visible = false;
					continue;
				}
				var itemid:String = obj[key];
				// 装备数据
				var itemInfo:CJDataOfItem = CJDataManager.o.DataOfEquipmentbar.getEquipbarItem(itemid);
				if (itemInfo == null)
				{
					bagitem.setBagGoodsItem("");
					bagitem.visible = false;
					continue;
				}
				// 对应模板数据
				var itemTemplate:Json_item_setting = templateSetting.getTemplate(int(itemInfo.templateid));
				Assert(itemTemplate!=null, "CJHeroSelfInfoUI._updataEquipment  itemTemplate==null");
				Assert(!SStringUtils.isEmpty(itemTemplate.picture), "CJHeroSelfInfoUI._updataEquipment  itemTemplate.picture==null");
				if ( null!=itemTemplate && !SStringUtils.isEmpty(itemTemplate.picture) )
				{
					// 防止数据异常
					bagitem.setBagGoodsItem(itemTemplate.picture);
					bagitem.visible = true;
				}
			}
		}
		
		// 解雇武将
		private function _fireHero():void
		{
			var mainheroid:String = CJDataManager.o.DataOfHeroList.getMainHero().heroid;
			// 不可删除主将
			if ( mainheroid == _curHeroid )
				return;
			
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _onFireHero);
			SocketCommand_hero.fire_hero(_curHeroid);
		}
		private function _onFireHero(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() != ConstNetCommand.CS_HERO_FIRE_HERO)
				return;
			
			e.target.removeEventListener(e.type,_onFireHero);
			
			var retCode:uint = message.retcode;
			var fireHeroid:String = message.retparams[0];	// 注册成功
			
			switch(retCode)
			{
				case 0:
					break;
				case 1:
					CJMessageBox(CJLang("ERROR_REGISTER_USERNAME_SAME"));
					return;
				case 2:
					CJMessageBox(CJLang("ERROR_HERO_FORMATION"));
					return;
				case 3:
					CJMessageBox(CJLang("ERROR_HERO_NO_ENOUGH_BAG"));
					return;
				default:
					CJMessageBox(CJLang("ERROR_UNKNOWN")+"CJHeroSelfInfoUI._onFireHero retcode="+message.retcode );
					return;
			}
			
			CJDataManager.o.DataOfHeroList.delHero(fireHeroid);
			
			// 获取背包信息
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, __onGetBag);
			SocketCommand_item.getBag();
			
			function __onGetBag(e:Event):void
			{
				var message:SocketMessage = e.data as SocketMessage;
				if(message.getCommand() != ConstNetCommand.CS_ITEM_GET_BAG)
					return;
				
				e.target.removeEventListener(e.type, __onGetBag);
				_initNext();
			}
		}
		
		// 开启武将标签栏
		private function _onOpenHerotag():void
		{
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _onOpenHerotagComplete);
			SocketCommand_herotag.add_herotag(_curHerotagIndex);
		}
		private function _onOpenHerotagComplete(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() != ConstNetCommand.CS_HERO_TAG_ADD)
				return;
			
			e.target.removeEventListener(e.type,_onOpenHerotagComplete);
			
			var retCode:uint = message.retcode;
			var arr:Array = message.retparams[0];	// 开启的索引
			
			switch(retCode)
			{
				case 0:
					break;
				case 3:
					CJMessageBox(CJLang("ERROR_HEROTAG_LEVEL"));
					return;
				case 4:
					CJMessageBox(CJLang("ERROR_HEROTAG_GOLD"));
					return;
				default:
					CJMessageBox(CJLang("ERROR_UNKNOWN")+"CJHeroSelfInfoUI._onOpenHerotagComplete retcode="+message.retcode );
					return;
			}
			
			CJDataManager.o.DataOfHeroTag.herotaglist = arr;
			// 更新货币
			SocketCommand_role.get_role_info();
			//			_doInit();
			
			// 比对数据  查看未开启的标签
			_heroNameLayer.updateLayer();
		}
		
		/**
		 * 穿脱装备更新界面
		 */
		private function _onPutonOrTakeOffRefreshLayer(e:Event):void
		{
			switch (e.data.command)
			{
				case ConstNetCommand.CS_ITEM_GET_BAG:
					_rpcMark = _rpcMark | _ConstMarkBagData;
					break;
				case ConstNetCommand.CS_ITEM_EQUIPMENTBAR:
					_rpcMark = _rpcMark | _ConstMarkEquipbarData;
					break;
				case ConstNetCommand.CS_HERO_GET_PUTON_EQUIP:
					_rpcMark = _rpcMark | _ConstMarkHeroEquipData;
					break;
				case ConstNetCommand.CS_HERO_GET_HERO_PROP:
					_rpcMark = _rpcMark | _ConstMarkHeroPropData;
					break;
				default:
					return;
			}
			
			if( ((_rpcMark&_ConstMarkBagData) != _ConstMarkBagData) ||
				((_rpcMark&_ConstMarkEquipbarData) != _ConstMarkEquipbarData) ||
				((_rpcMark&_ConstMarkHeroEquipData) != _ConstMarkHeroEquipData) ||
				((_rpcMark&_ConstMarkHeroPropData) != _ConstMarkHeroPropData) )
			{
				return;
			}
			
			// 更新信息
			var heroDict:Dictionary = CJDataManager.o.DataOfHeroList.herolist;
			var heroInfo:CJDataOfHero = heroDict[_curHeroid];
			_updataHeroLayer(heroInfo);
			// 重置mark
			_rpcMark = 0;
			
		}
		
		private function _onPutonOrTakeOff(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() == ConstNetCommand.CS_HERO_PUTON_EQUIP ||
				message.getCommand() == ConstNetCommand.CS_HERO_TAKEOFF_EQUIP)
			{
				var retCode:uint = message.params(0);
				if (message.getCommand() == ConstNetCommand.CS_HERO_PUTON_EQUIP)
				{
					switch(retCode)
					{
						case 0:
							break;
						case 2:
							// 刷新界面
							break;
						default:
							CJMessageBox("CJHeroSelfInfoUI._onPutonOrTakeOff Command()="+message.getCommand()+"|||retcode="+message.params(0));
							return;
					}
					CJTaskEventHandler.o.dispatchEventWith(CJEvent.EVENT_TASK_ACTION_EXECUTED , false , {"itemid":itemid});
				}
				else if (message.getCommand() == ConstNetCommand.CS_HERO_TAKEOFF_EQUIP)
				{
					if (4 == retCode)
					{
						CJMessageBox(CJLang("BAG_HAS_NOT_ENOUGH_GRID"));
						return;
					}
				}
				
				// 重置mark
				_rpcMark = 0;
				// 获取背包数据
				SocketCommand_item.getBag();
				// 请求装备栏数据
				SocketCommand_item.get_equipmentbar();
				// 请求武将装备数据
				SocketCommand_hero.get_puton_equip();
				// 更新主界面战斗力
				SocketCommand_hero.get_heros()
				// 重新获取武将信息
				var rtnObject:Object = message.retparams;
				var heroid:String = rtnObject[0];
				var itemid:String = rtnObject[1];
				SocketCommand_hero.getHeroProp(heroid);
			}
		}
		
		
		
		
	}
}