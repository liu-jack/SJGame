package SJ.Game.mainUI
{
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import SJ.Common.Constants.ConstDynamic;
	import SJ.Common.Constants.ConstGlobal;
	import SJ.Common.Constants.ConstMainUI;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstPlatformId;
	import SJ.Common.Constants.ConstTask;
	import SJ.Game.SocketServer.SocketCommand_hero;
	import SJ.Game.SocketServer.SocketCommand_role;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.controls.CJMapUtil;
	import SJ.Game.core.TalkingDataService;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfEnterGuanqia;
	import SJ.Game.data.CJDataOfHero;
	import SJ.Game.data.CJDataOfHeroList;
	import SJ.Game.data.CJDataOfNews;
	import SJ.Game.data.CJDataOfRole;
	import SJ.Game.data.CJDataOfTask;
	import SJ.Game.data.CJDataOfTaskList;
	import SJ.Game.data.config.CJDataHeroProperty;
	import SJ.Game.data.config.CJDataOfFuncPropertyList;
	import SJ.Game.data.config.CJDataOfGlobalConfigProperty;
	import SJ.Game.data.config.CJDataOfHeroPropertyList;
	import SJ.Game.data.config.CJDataOfNoticeProperty;
	import SJ.Game.data.config.CJDataOfUpgradeProperty;
	import SJ.Game.data.json.Json_function_open_setting;
	import SJ.Game.data.json.Json_news_notice;
	import SJ.Game.dynamics.CJDynamicAddFriendLayer;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.friends.CJFriendClickPlayerDialog;
	import SJ.Game.funcopen.CJMaskUtil;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJLayerManagerWrapper;
	import SJ.Game.layer.CJLayerRandomBackGround;
	import SJ.Game.layer.CJMessageBox;
	import SJ.Game.onlineReward.CJOLRewardMenu;
	import SJ.Game.player.CJPlayerNpc;
	import SJ.Game.utils.SSoundEffectUtil;
	
	import engine_starling.SApplication;
	import engine_starling.Events.MouseEvent;
	import engine_starling.display.SAnimate;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.controls.ProgressBar;
	import feathers.display.Scale3Image;
	import feathers.textures.Scale3Textures;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.filters.ColorMatrixFilter;
	import starling.textures.Texture;

	/**
	 * 主界面层
	 * @author zhengzheng
	 * @modified caihua 2013/06/21 - 修改界面加载顺序，更新方式
	 */	
	public class CJMainUiLayer extends SLayer
	{
		private var _mainUiMenuLayer:CJMainUiMenu;
		//头像框按钮
		private var _btnTouxiangkuang:Button;
		//头像按钮
		private var _btnTouxiang:Button;
		//充值按钮
		private var _btnRecharge:Button;
		//玩家名称
		private var _labelHeroName:Label;
		//元宝数量
		private var _labelGold:Label;
		//银两数量
		private var _labelSilver:Label;
		//玩家体力数值
		private var _labelStrengthValue:Label;
		//玩家等级
		private var _labelHeroLevel:Label;
		//玩家经验标题
		private var _labelExp:Label;
		//玩家经验数值
		private var _labelExpValue:Label;
		//玩家战斗力数值
		private var _labBattlePower:Label;
		//引导区item
		private var _navigator:CJMainNavigator;
		/** 主角头像名称*/
		private var _headIcon:String;
		/** 经验进度条*/
		private var _progressBarExp:ProgressBar;
		/**阵营图标*/
		private var _campImage:SImage;
		/**vip背景图标*/
		private var _vipBgImage:SImage;
		/**vip按钮图标*/
		private var _btnVip:Button;
		
		private var _btnshowLog:Button;

		private var _roleData:CJDataOfRole;

		private var _heroList:CJDataOfHeroList;

		private var _mainHeroInfo:CJDataOfHero;

		private var _heroProperty:CJDataHeroProperty;
		
		private var _olRewardMenu:CJOLRewardMenu;
		//点击玩家弹出的信息框
		private var _clickPlayerDialog:CJFriendClickPlayerDialog;
		//网络状态
		private var _netStatus:ImageLoader;
		
		//指引箭头, add by sangxu
		private var _arrow:CJGuideArrow;
		private var _fireArrow:SAnimate;
		
		// NPC对话框显示
		private var _npcDlgArrowShow:Boolean = false;
		// 功能开启显示
		private var _funcOpenShow:Boolean = false;
		// 有新消息提醒动画
		private var _fire:SAnimate;
		// 有新消息提醒按钮数组
		private var _arrayBtnNotice:Array;
		//指引箭头不出现的最小等级
		private var _guideMinLv:int;
		//主角等级
		private var _roleLevel:int;
		//是否显示玩家配置
		private var _displayConfig:int;
		
		/** 数据 - 任务 */
		private var _dataTaskList:CJDataOfTaskList;
		/** 遮罩 - 初始任务 */
		private var _maskTask:SLayer;
		/** 初始任务遮罩点击计数 */
		private var _maskTaskClickCount:int = 0;
		/** 初始任务遮罩消失点击次数 */
		private var _maskTaskDspTime:int = 3;
		
		private var _filter:ColorMatrixFilter;
		
		public function CJMainUiLayer()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			this._genDownSimulateFilter();
			this._initData();
			this._drawContent();
			this._addEventListeners();
		}
		
		private function _genDownSimulateFilter():void
		{
			_filter = new ColorMatrixFilter();
			_filter.matrix = Vector.<Number>([
				1,0,0,0,0,
				0,1,0,0,0,
				0,0,1,0,0,
				0,0,0,1,0
			]);
			_filter.adjustBrightness(-0.1); //亮度
		}
		
		/**
		 * 初始化数据
		 * 
		 */		
		private function _initData():void
		{
			_roleData = CJDataManager.o.DataOfRole;
			_heroList = CJDataManager.o.DataOfHeroList;
			_mainHeroInfo = _heroList.getMainHero();
			_heroProperty = CJDataOfHeroPropertyList.o.getProperty(int(_mainHeroInfo.templateid));
			SocketCommand_role.get_role_info();
			SocketCommand_hero.get_heros();
			_arrayBtnNotice = new Array();
			_roleLevel = int(_mainHeroInfo.level);
			_guideMinLv = int(CJDataOfGlobalConfigProperty.o.getData("GUIDE_MAX_LV"));
			_displayConfig = int(CJDataOfGlobalConfigProperty.o.getData("MAIN_UI_DISPLAY_SCENE_PLAYERS"));
			
			_dataTaskList = CJDataManager.o.DataOfTaskList;
		}
		
		override protected function draw():void
		{
			super.draw();
			if(_roleData.camp != 0)
			{
				this._campImage.texture = SApplication.assets.getTexture("common_zhenyingtubiao0"+_roleData.camp);
			}
			// 关闭过场动画
			CJLayerRandomBackGround.Close();
			//是否弹出加好友弹窗
			if (ConstDynamic.isAddFriendDialogPopup && CJDataManager.o.DataOfFuncList.needOpenFunctionAfterReturnToTown != 1)
			{
				var addFriendDialog:CJDynamicAddFriendLayer = new CJDynamicAddFriendLayer(CJDataOfEnterGuanqia.o.assistantUid);
				CJLayerManagerWrapper.o.addToModalSequence(addFriendDialog);
				CJDataOfEnterGuanqia.o.clear();
				ConstDynamic.isAddFriendDialogPopup = false;
			}
				//是否弹出奖励好友体力弹窗
			else if (ConstMainUI.addVitCount != 0 && ConstDynamic.isRewardVitDialogPopup && CJDataManager.o.DataOfFuncList.needOpenFunctionAfterReturnToTown != 1)
			{
				//添加数据到达监听 
				SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,_onloadOtherRoleInfo);
				SocketCommand_role.get_other_role_info(CJDataOfEnterGuanqia.o.assistantUid);
				CJDataOfEnterGuanqia.o.clear();
				ConstDynamic.isRewardVitDialogPopup = false;
			}
		}
		
		private function _drawContent():void
		{
			//经验条
			_progressBarExp = new ProgressBar;
			var scale3texture:Scale3Textures = new Scale3Textures(SApplication.assets.getTexture("zhujiemian_jingyantiao"),0.5,1);
			var fillSkin:Scale3Image = new Scale3Image(scale3texture);
			_progressBarExp.fillSkin = fillSkin;
			_progressBarExp.x = ConstMainUI.ConstExpBarX;
			_progressBarExp.y = ConstMainUI.ConstExpBarY;
			_progressBarExp.width = ConstMainUI.ConstExpBarMaxLength;
			_progressBarExp.height = ConstMainUI.ConstExpBarHeight;
			_progressBarExp.minimum = 0;
			this.addChild(_progressBarExp);
			
			_labelExpValue = new Label();
			_labelExpValue.x = 117;
			_labelExpValue.y = 15;
			_labelExpValue.width = 81;
			_labelExpValue.height = 12;
			this.addChild(_labelExpValue);
			
			//阵营图标
			_campImage = new SImage(Texture.empty(25 , 25));
			_campImage.x = 60;
			_campImage.y = 42;
			if(CJDataManager.o.DataOfRole.camp != 0)
			{
				this._campImage.texture = SApplication.assets.getTexture("common_zhenyingtubiao0"+CJDataManager.o.DataOfRole.camp);
			}
			this.addChild(_campImage);
			
			// 头像图标
			_headIcon = _heroProperty.headicon;
			_btnTouxiang.defaultSkin  = new SImage(SApplication.assets.getTexture(_headIcon));
			
			//vip
			_vipBgImage = new SImage(SApplication.assets.getTexture("baoshi_danxuananniu01"));
			_vipBgImage.x = 6;
			_vipBgImage.y = 48;
			_vipBgImage.width = 45;
			_vipBgImage.height = 20;
			this.addChild(_vipBgImage);
			
			_btnVip = new Button();
			_btnVip.x = 8;
			_btnVip.y = 50;
			_btnVip.width = 48;
			_btnVip.height = 16;
			this.addChild(_btnVip);
			
			var fontFormat:TextFormat = new TextFormat( "Arial", 8, 0xFFFFFF,null,null,null,null,null, TextFormatAlign.CENTER);
			_labelStrengthValue.textRendererProperties.textFormat = fontFormat;
			_labelGold.textRendererProperties.textFormat = fontFormat;
			_labelSilver.textRendererProperties.textFormat = fontFormat;
			
			
			fontFormat = new TextFormat( "Arial", 8, 0xFEEB47,null,null,null,null,null, TextFormatAlign.CENTER);
			_labelHeroLevel.textRendererProperties.textFormat = fontFormat;
			
			fontFormat = new TextFormat( "黑体", 8, 0xFFFFFF,null,null,null,null,null, TextFormatAlign.CENTER);
			_labelExpValue.textRendererProperties.textFormat = fontFormat;
			_labelHeroName.textRendererProperties.textFormat = fontFormat;
			var roleName:String = _roleData.name;
			if (roleName.length > 5)
			{
				roleName = roleName.substring(0, 5) + "...";
			}
			_labelHeroName.text = roleName;
			
			fontFormat = new TextFormat( "Arial", 10, 0xFEEB47,null,null,null,null,null, TextFormatAlign.CENTER);
			_labBattlePower.textRendererProperties.textFormat = fontFormat;
			
			fontFormat = new TextFormat( "黑体", 7, 0xFFFFFF);
			_labelExp.textRendererProperties.textFormat = fontFormat;
			_labelExp.text = CJLang("MAIN_UI_EXP");
			
			_mainUiMenuLayer = new CJMainUiMenu();
			addChild(_mainUiMenuLayer);
			
			
			_netStatus = new ImageLoader();
			_netStatus.x = 467;
			_netStatus.y = 2;
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventConnect,_onSocketConnect);
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventError,_onSocketError);
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventDisConnect,_onSocketError);
			if(SocketManager.o.connected)
			{
				_netStatus.source = SApplication.assets.getTexture("zhujiemian_xinhao01");
			}
			addChild(_netStatus);
			
			
			
			_showNotice();
			
			_drawMaskTask();
			// 箭头
			_drawArrow();
//			var gen:SFeatherControlGenCocosX = new SFeatherControlGenCocosX();
//			CJLayerManager.o.rootLayer.addChild(gen.genLayoutFromcocosJson(AssetManagerUtil.o.getObject("convertcocosx_1.json")));
		}
		/**
		 * 绘制任务蒙版
		 * 
		 */		
		private function _drawMaskTask():void
		{
			if (_maskTask != null)
			{
//				if (_maskTask.parent == this)
//				{
//				}
				return;
			}
			if (_needShowMaskTask())
			{
				_maskTask = CJMaskUtil.createMaskWithHoleOnTarget(navigator.x, navigator.y, navigator.width, navigator.height, Starling.current.stage);
				_maskTask.alpha = 0.5;
				addChild(_maskTask);
				navigator.addEventListener(MouseEvent.Event_MouseClick , _clickNavigatorHandler);
				_maskTask.addEventListener(TouchEvent.TOUCH , _clickMaskTaskHandler);
			}
		}
		/**
		 * 是否需要显示任务蒙版
		 * @return 需要显示-true；不显示-false
		 * 
		 */		
		private function _needShowMaskTask():Boolean
		{
			if (!_inMaskTaskLevel())
			{
				return false;
			}
			var dataTask:CJDataOfTask = _dataTaskList.getCurrentMainTask();
			if (!_inMaskTaskId(dataTask.taskId))
			{
				// 大于显示任务上限 - 不显示
				return false;
			}
			if (dataTask.status == ConstTask.TASK_CAN_ACCEPT)
			{
				// 可接取 - 显示
				return true;
			}
			if (dataTask.status == ConstTask.TASK_COMPLETE)
			{
				// 完成未领奖励 - 显示
				return true;
			}
			// 其他 - 不显示
			return false;
		}
		/**
		 * 是否在任务显示蒙版id内
		 * @return 在显示id内-true；不在显示id内-false
		 * 
		 */		
		private function _inMaskTask():Boolean
		{
			var dataTask:CJDataOfTask = _dataTaskList.getCurrentMainTask();
			if (dataTask != null)
			{
				return _inMaskTaskId(dataTask.taskId);
			}
			return false;
		}
		/**
		 * 是否在任务显示蒙版id内
		 * @param taskId	任务id
		 * @return 在显示id内-true；不在显示id内-false
		 * 
		 */		
		private function _inMaskTaskId(taskId:int):Boolean
		{
			var maxTaskId:int = int(CJDataOfGlobalConfigProperty.o.getData("TASK_MASK_MAX_ID"));
			if (taskId <= maxTaskId)
			{
				return true;
			}
			return false;
		}
		/**
		 * 是否在显示蒙版等级内
		 * @return 
		 * 
		 */		
		private function _inMaskTaskLevel():Boolean
		{
			var maxTaskLevel:int = int(CJDataOfGlobalConfigProperty.o.getData("TASK_MASK_MAX_LV"));
			if (maxTaskLevel <= 0)
			{
				maxTaskLevel = 2;
			}
			var mainHeroInfo:CJDataOfHero = _heroList.getMainHero();
			var level:int = int(mainHeroInfo.level);
			if (level <= maxTaskLevel)
			{
				return true;
			}
			return false;
			
		}
		
		/**
		 * 点击引导头像
		 * @param e
		 * 
		 */		
		private function _clickNavigatorHandler(e:starling.events.Event):void
		{
			_delMaskTask();
		}
		/**
		 * 点击引导蒙版
		 * @param e
		 * 
		 */		
		private function _clickMaskTaskHandler(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this.parent);
			if (!touch || touch.phase != TouchPhase.BEGAN)
			{
				return;
			}
			_maskTaskClickCount += 1;
			if (_maskTaskClickCount >= _maskTaskDspTime)
			{
				_delMaskTask();
			}
		}
		/**
		 * 删除任务蒙版
		 * 
		 */		
		private function _delMaskTask():void
		{
			if (_maskTask == null)
			{
				return;
			}
			removeChild(_maskTask);
			_maskTask = null;
			navigator.removeEventListener(MouseEvent.Event_MouseClick , this._clickNavigatorHandler);
		}
		
		
		/**
		 * 加载服务器其他角色数据 
		 * @param e Event
		 * 
		 */		
		private function _onloadOtherRoleInfo(e:starling.events.Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if (message.getCommand() == ConstNetCommand.CS_ROLE_GET_OTHER_ROLE_INFO)
			{
				SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_onloadOtherRoleInfo);
				if (message.retcode == 0)
				{
					var playerInfo:Object = message.retparams;
					// 助战赠送奖励点数
					var zhuzhanAddVit:int = ConstMainUI.addVitCount;
					if (playerInfo.hasOwnProperty("rolename"))
					{
						CJMessageBox(CJLang("DYNAMIC_REWARD_FRIEND_VIT", {"friendname":playerInfo.rolename, "vit":zhuzhanAddVit}));
					}
					ConstMainUI.addVitCount = 0;
				}
			}
		}
		private function _onSocketConnect(e:starling.events.Event):void
		{
			_netStatus.source = SApplication.assets.getTexture("zhujiemian_xinhao01");
		}
		private function _onSocketError(e:starling.events.Event):void
		{
			_netStatus.source = SApplication.assets.getTexture("zhujiemian_xinhao02");
		}
		
		/**
		 * 无奈的选择,zhengzheng啊 zhengzheng 
		 * 
		 */
		public function removeAllEventlisteners():void
		{
			this.parent.removeEventListener(starling.events.TouchEvent.TOUCH, _onClickPlayerDialogOtherRegion);
		}
		override public function dispose():void
		{
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventConnect,_onSocketConnect);
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventError,_onSocketError);
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventDisConnect,_onSocketError);
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_updateRoleInfo);
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_updateHerosInfo);
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_onReceiveNewsNotice);
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_onloadOtherRoleInfo);
			
			
			
			
			CJEventDispatcher.o.removeEventListener("join_camp_succ" , _setCampImage);
			CJEventDispatcher.o.removeEventListener(ConstMainUI.MAIN_UI_CLICK_PLAYER, _showPlayerDialog);
			CJEventDispatcher.o.removeEventListener(CJEvent.EVENT_NPCDIALOG_GUID_SHOW , _hideArrow);
			CJEventDispatcher.o.removeEventListener(CJEvent.EVENT_NPCDIALOG_GUID_HIDE , _drawArrow);
			CJEventDispatcher.o.removeEventListener(CJEvent.EVENT_SELF_PLAYER_UPLEVEL , _checkShowArrow);
			CJEventDispatcher.o.removeEventListener(CJEvent.EVENT_INDICATE_ENTER , _hideArrow);
			CJEventDispatcher.o.removeEventListener(CJEvent.EVENT_INDICATE_EXIT , _onIndicateExit);
			if (_arrow != null)
			{
				if (true == _arrow.isAnimate)
				{
					Starling.juggler.remove(_arrow);
				}
			}
			if (_fireArrow != null)
			{
				Starling.juggler.remove(_fireArrow);
			}
			if(_fire != null)
			{
				Starling.juggler.remove(_fire);
			}
			
			
			CJEventDispatcher.o.removeEventListener(CJEvent.EVENT_NOT_DISPLAY_SCENE_PLAYERS,_notdisplay_player);
			CJEventDispatcher.o.removeEventListener(CJEvent.EVENT_DISPLAY_SCENE_PLAYERS,_displayer_player);
			
			
			CJDataManager.o.DataOfTaskList.removeEventListener(CJEvent.EVENT_TASK_DATA_CHANGE , this._onReceiveTaskData);
			super.dispose();
			
			_filter.dispose();
		}
		
		/**
		 * 绘制引导箭头
		 * 
		 */		
		private function _drawArrow():void
		{
			if (!_needShowArrow())
			{
				return;
			}
			else
			{
				_hideArrow();
			}
			
			_showArrow();
		}
		/**
		 * 
		 * 
		 */		
		private function _checkShowArrow(e:starling.events.Event):void
		{
			if (true == _npcDlgArrowShow)
			{
				return;
			}
			if (true == _funcOpenShow)
			{
				return;
			}
			var data:Object = e.data;
			var currentLevel:int = int(data.currentLevel);
			
			var guideMinLv:int = int(CJDataOfGlobalConfigProperty.o.getData("GUIDE_MAX_LV"));
			
			if (currentLevel >= guideMinLv)
			{
				_hideArrow();
			}
			else
			{
				_showArrow();
			}
		}
		
		/**
		 * 是否显示引导箭头
		 * @return 
		 * 
		 */		
		private function _needShowArrow():Boolean
		{
			if (true == _npcDlgArrowShow)
			{
				return false;
			}
			if (true == _funcOpenShow)
			{
				return false;
			}
			
			return _isGuideLv();
		}
		
		/**
		 * 是否在新手引导等级内
		 * @return 在新手引导等级内返回true，否则返回false
		 * 
		 */		
		private function _isGuideLv():Boolean
		{
			var guideMinLv:int = int(CJDataOfGlobalConfigProperty.o.getData("GUIDE_MAX_LV"));
			
			if (int(_heroList.getMainHero().level) > guideMinLv)
			{
				return false;
			}
			return true;
		}
		
		private function _showArrow():void
		{
			//火圈动画
			if (null == _fireArrow)
			{
				_fireArrow = new SAnimate(SApplication.assets.getTextures("common_kaiqi"), 6);
				_fireArrow.x = _navigator.x - 12;
				_fireArrow.y = _navigator.y - 13;
				_fireArrow.scaleX = _fireArrow.scaleY = 1.9;
				
				_fireArrow.touchable = false;
				this.addChild(_fireArrow);
				Starling.juggler.add(_fireArrow);
			}
			if (null == _arrow)
			{
				_arrow = new CJGuideArrow(CJLang("GUIDE_AUTO_PATH"));
				_arrow.width = 100;
				_arrow.height = 75;
				_arrow.x = navigator.x - _arrow.width - 10 + (_arrow.width / 2);
				_arrow.y = navigator.y + (_arrow.height / 2) - 8;
				_arrow.touchable = false;
				
				this.addChild(_arrow);
				if (true == _arrow.isAnimate)
				{
					Starling.juggler.add(_arrow);
				}
			}
			

		}
		
		private function _onNpcDlgShow():void
		{
			_npcDlgArrowShow = true;
			_hideArrow();
		}
		private function _onNpcDlgHide():void
		{
			_npcDlgArrowShow = false;
			_drawArrow();
		}
		
		private function _onIndicateEnter():void
		{
			_funcOpenShow = true;
			_hideArrow();
		}
		private function _onIndicateExit():void
		{
			_funcOpenShow = false;
			_drawArrow();
		}
		/**
		 * 引导箭头隐蔽
		 * 
		 */		
		private function _hideArrow():void
		{
			if (null != _arrow)
			{
				if (true == _arrow.isAnimate)
				{
					Starling.juggler.remove(_arrow);
				}
				this.removeChild(_arrow);
				_arrow = null;
			}
			if (null != _fireArrow)
			{
				Starling.juggler.remove(_fireArrow);
				this.removeChild(_fireArrow);
				_fireArrow = null;
			}
		}
		
		private function _addEventListeners():void
		{
			this.parent.addEventListener(starling.events.TouchEvent.TOUCH, _onClickPlayerDialogOtherRegion);
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,this._updateRoleInfo);
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,this._updateHerosInfo);
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,_onReceiveNewsNotice);
			
			NativeApplication.nativeApplication.addEventListener(
				flash.events.Event.ACTIVATE, function (e:*):void {
					SocketCommand_role.get_role_info();
			});
			//为头像按钮添加监听
			_btnTouxiang.addEventListener(starling.events.Event.TRIGGERED, function (e:*):void{
				SSoundEffectUtil.playTipSound();
				SApplication.moduleManager.enterModule("CJHeroPropertyUIModule");
			});
			_btnRecharge.addEventListener(starling.events.Event.TRIGGERED, function (e:*):void{
				SSoundEffectUtil.playTipSound();
//				var time:Number = CTimerUtils.getCurrentTime();
//				PushService.o.sendLocalNotification("土豪OL", int(time/1000) + 10, "一起来做土豪吧!!");
//				return;
				if(ConstPlatformId.isWebChargeChannel())
				{
					CJMapUtil.enterCharge();
					return;
				}
				if(ConstGlobal.CHANNELID != ConstPlatformId.ID_DEBUG)
				{
					SApplication.moduleManager.enterModule("CJRechargeModule");
				}			
			});
				
				
			var roleData:CJDataOfRole = CJDataManager.o.DataOfRole;
			if(!roleData.camp || int(roleData.camp) == 0)
			{
				CJEventDispatcher.o.addEventListener("join_camp_succ" , this._setCampImage);
			}
			
			//添加点击其他玩家弹出框
			CJEventDispatcher.o.addEventListener(ConstMainUI.MAIN_UI_CLICK_PLAYER, _showPlayerDialog);
			if (true == _isGuideLv())
			{
				CJEventDispatcher.o.addEventListener(CJEvent.EVENT_NPCDIALOG_GUID_SHOW , _onNpcDlgShow);
				CJEventDispatcher.o.addEventListener(CJEvent.EVENT_NPCDIALOG_GUID_HIDE , _onNpcDlgHide);
				// 监听升级
				CJEventDispatcher.o.addEventListener(CJEvent.EVENT_SELF_PLAYER_UPLEVEL , _checkShowArrow);
				// 监听引导模块进入、退出
				CJEventDispatcher.o.addEventListener(CJEvent.EVENT_INDICATE_ENTER , _onIndicateEnter);
				CJEventDispatcher.o.addEventListener(CJEvent.EVENT_INDICATE_EXIT , _onIndicateExit);
			}
			_btnVip.addEventListener(starling.events.Event.TRIGGERED, function (e:*):void{
				SSoundEffectUtil.playTipSound();
				SApplication.moduleManager.enterModule("CJVipModule");
			});
			
			
			if (_displayConfig == 0)
			{
				CJEventDispatcher.o.addEventListener(CJEvent.EVENT_NOT_DISPLAY_SCENE_PLAYERS,_notdisplay_player);
				CJEventDispatcher.o.addEventListener(CJEvent.EVENT_DISPLAY_SCENE_PLAYERS,_displayer_player);
			}
			
			
			_displaycount = 0;
			
			if (_inMaskTask())
			{
//				this._dataTaskList.addEventListener(DataEvent.DataLoadedFromRemote, this._onReceiveTaskData);
				CJDataManager.o.DataOfTaskList.addEventListener(CJEvent.EVENT_TASK_DATA_CHANGE , this._onReceiveTaskData);
			}
		}
		
		/**
		 * 任务数据变更
		 */
		private function _onReceiveTaskData(e:starling.events.Event):void
		{
			if(e.target is CJDataOfTaskList)
			{
				this._drawMaskTask();
			}
		}
		
		private var _displaycount:int = 0;
		private function _notdisplay_player(e:*):void
		{
			_displaycount ++;
			this.visible = false;
		}
		private function _displayer_player(e:*):void
		{
			_displaycount --;
			if(_displaycount < 0)
				_displaycount = 0;
			if(_displaycount == 0)
			{
				this.visible = true;
			}
		}
		
		/**
		 * 显示或隐藏新消息提醒
		 * 
		 */		
		private function _setNewsNoticeVisible():void
		{
			if (_clickPlayerDialog)
			{
				var i:int;
				if (_fire)
				{
					_fire.visible = false;
				}
				for (i = 0; i < _arrayBtnNotice.length; i++ ) 
				{
					(_arrayBtnNotice[i] as Button).visible = false;
				}
			}
			else
			{
				if (_fire)
				{
					_fire.visible = true;
				}
				for (i = 0; i < _arrayBtnNotice.length; i++ ) 
				{
					(_arrayBtnNotice[i] as Button).visible = true;
				}
			}
			_setOtherBtnNoticeInvisible();
		}
		
		/**
		 * 隐藏之前的新消息提醒按钮
		 * 
		 */		
		private function _setOtherBtnNoticeInvisible():void
		{
			var i:int;
			var length:int = _arrayBtnNotice.length;
			if (length >= 2)
			{
				for (i = 0; i < length - 1; i++ ) 
				{
					(_arrayBtnNotice[i] as Button).visible = false;
				}
			}
		}
		/**
		 * 当在主界面中有新消息提醒 
		 * @param e
		 * 
		 */
		private function _onReceiveNewsNotice(e:starling.events.Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() != ConstNetCommand.SC_CMD_SYNC_NOTICE)
				return;
			_showNotice();
		}
		/**
		 * 设置有新消息显示通知显示
		 * @param noticeId 通知id
		 * 
		 */		
		private function _showNotice():void
		{
			if (_roleLevel <= _guideMinLv)
			{
				return;
			}
			var dataOfNews:CJDataOfNews = CJDataManager.o.DataOfNews;
			if(dataOfNews.noticeTypeArray == null) return;
			var noticeTypeArray:Array = JSON.parse(dataOfNews.noticeTypeArray) as Array;
			
			for (var i:int = 0; i < noticeTypeArray.length; i++) 
			{
				var noticeType:int = noticeTypeArray[i];
				if (_fire == null) 
				{
					//火圈动画
					_fire = new SAnimate(SApplication.assets.getTextures("common_kaiqi"), 6);
					_fire.x = 359;
					_fire.y = 0;
					_fire.scaleX = _fire.scaleY = 1.5;
					
					_fire.touchable = false;
					this.addChild(_fire);
					Starling.juggler.add(_fire);
				}
				
				var noticeConfig:Json_news_notice = CJDataOfNoticeProperty.o.getProperty(noticeType);
				if (noticeConfig == null)
				{
					return;
				}
				var iconStr:String = String(noticeConfig.icon);	
				var tempModuleName:String = noticeConfig.modulename;
				var curModuleName:String = tempModuleName.substring(7, tempModuleName.length);
				var funcOpenSetting:Json_function_open_setting = CJDataOfFuncPropertyList.o.getPropertyByModulename(curModuleName);
				
				if (funcOpenSetting && _roleLevel >= int(funcOpenSetting.level) && !_isContain(tempModuleName))
				{
					//模块图标按钮
					var btnModule:Button = new Button();
					btnModule.width = 38;
					btnModule.height = 38;
					btnModule.x = _fire.x + 11;
					btnModule.y = _fire.y + 10;
					btnModule.name = tempModuleName;
					btnModule.defaultSkin = new SImage(SApplication.assets.getTexture(iconStr));
					var img:SImage = new SImage(SApplication.assets.getTexture(iconStr));
					img.filter = _filter;
					btnModule.downSkin = img;
					this.addChild(btnModule);
					_arrayBtnNotice.push(btnModule);
					btnModule.addEventListener(starling.events.Event.TRIGGERED , _btnNoticeTriggered);
				}
			}
			_setNewsNoticeVisible();
		}
		/**
		 * 判断该数组中是否已经有该数据
		 */		
		private function _isContain(element:String):Boolean
		{
			for (var i:int = 0; i < _arrayBtnNotice.length; i++) 
			{
				var btnNotice:Button = _arrayBtnNotice[i];
				if (element == btnNotice.name)
				{
					return true;
				}
			}
			return false;
		}
		/**
		 * 触发点击新消息提醒按钮事件
		 * 
		 */		
		private function _btnNoticeTriggered(e:starling.events.Event):void
		{
			SSoundEffectUtil.playTipSound();
			var curBtn:Button = e.target as Button;
			var dataOfNews:CJDataOfNews = CJDataManager.o.DataOfNews;
			if(dataOfNews.noticeTypeArray == null) return;
			var noticeTypeArray:Array = JSON.parse(dataOfNews.noticeTypeArray) as Array;
			var noticeList:Object = JSON.parse(dataOfNews.noticeList);
			var noticeLength:int = _arrayBtnNotice.length;
			if (_fire && noticeLength <= 1)
			{
				_fire.removeFromParent(true);
				_fire.removeFromJuggler();
				_fire = null;
			}
			var lastElement:String = String(noticeTypeArray[(noticeLength - 1)]);
			var curBtnName:String = curBtn.name;
			var curModuleName:String = curBtnName.substring(7, curBtnName.length);
			SApplication.moduleManager.enterModule(curModuleName, {"pagetype":noticeList[lastElement]});
			if (curBtn)
			{
				curBtn.removeFromParent(true);
				_arrayBtnNotice.pop();
			}
			if (noticeList.hasOwnProperty(lastElement))
			{
				delete noticeList[lastElement];
				delete dataOfNews.jsonNoticeList[lastElement];
				
				noticeTypeArray.pop();
				dataOfNews.jsonNoticeTypeArray.pop();
				dataOfNews.tempNoticeTypeArray.pop();
				dataOfNews.setData("noticeList", JSON.stringify(noticeList));
				dataOfNews.setData("noticeTypeArray",JSON.stringify(noticeTypeArray));
				dataOfNews.saveToCache(false,true);
			}
			_setNewsNoticeVisible();
		}
		/**
		 * 点击到玩家弹出框之外的地方时触发
		 * @param e
		 * @return 
		 * 
		 */		
		private function _onClickPlayerDialogOtherRegion(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this.parent);
			if (!touch || touch.phase != TouchPhase.BEGAN)
				return;
			var globalPoint:Point = new Point(touch.globalX, touch.globalY);
			if (_clickPlayerDialog && !_clickPlayerDialog.hitTest(_clickPlayerDialog.globalToLocal(globalPoint)) && !(touch.target.parent.parent is CJPlayerNpc))
			{
				_clickPlayerDialog.btnCloseTriggered(e);
				_clickPlayerDialog = null;
				_setNewsNoticeVisible();
			}
		}
		/**
		 * 显示其他玩家的弹窗
		 * @param e
		 * 
		 */		
		private function _showPlayerDialog(e:starling.events.Event):void
		{
			if(e.type != ConstMainUI.MAIN_UI_CLICK_PLAYER)
			{
				return;
			}
			if (e.data)
			{
				if (_clickPlayerDialog)
				{
					if (e.data.playerid == ConstMainUI.oldClickPlayerUid)
					{
						return;
					}
					else
					{
						_clickPlayerDialog.btnCloseTriggered(e);
						_clickPlayerDialog = null;
					}
				}
				ConstMainUI.oldClickPlayerUid = e.data.playerid;
				_clickPlayerDialog = new CJFriendClickPlayerDialog(e.data.playerid);
				_clickPlayerDialog.x = 274;
				_clickPlayerDialog.y = 0;
				this.addChild(_clickPlayerDialog);
				_setNewsNoticeVisible();
			}
		}
		private function _setCampImage(e:starling.events.Event):void
		{
			if(e.type != "join_camp_succ")
			{
				return;
			}
			var roleData:CJDataOfRole = CJDataManager.o.DataOfRole;
			if(roleData.camp != 0)
			{
				this._campImage.texture = SApplication.assets.getTexture("common_zhenyingtubiao0"+roleData.camp);
				CJEventDispatcher.o.removeEventListener("join_camp_succ" , this._setCampImage);
			}
		}
		
		/**
		 * 更新主角信息（包括钱币、体力、VIP等级）
		 * 
		 */		
		private function _updateRoleInfo(e:starling.events.Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() == ConstNetCommand.CS_ROLE_GET_ROLE_INFO)
			{
				if (message.retcode == 0)
				{
					//更新钱币
					var gold:Number = _roleData.gold;
					var silver:Number = _roleData.silver;
					
					_labelSilver.text = _setNumberUnit(silver);
					_labelGold.text = _setNumberUnit(gold);
					//更新体力条
					var strenthMaximum:Number = Number(CJDataOfGlobalConfigProperty.o.getData("VIT_MAX"));
					var strenthValue:int = _roleData.vit;
					_labelStrengthValue.text = CJLang("MAIN_UI_STRENGTH") + " " + strenthValue + "/" + strenthMaximum;
					_btnVip.defaultSkin = new SImage(SApplication.assets.getTexture("zhujiemian_daziVIP" + (_roleData.vipLevel)));
				}
			}
			else if(message.getCommand() == ConstNetCommand.SC_SYNC_DUOBAOFRISLIVER)
			{
				SocketCommand_role.get_role_info();//刷新银两界面显示
			}
		}
		/**
		 * 设置数字的单位
		 * @return 
		 * 
		 */		
		private function _setNumberUnit(num:Number):String
		{
			var resultStr:String;
			if (num >= 100000)
			{
				num = int(num / 10000);
				resultStr = num + CJLang("MAIN_UI_MONEY_UINT_MYRIAD");
			}
			else
			{
				resultStr = String(int(num));
			}
			return resultStr;
		}
		/**
		 * 更新武将信息（包括等级、经验、战斗力）
		 * 
		 */		
		private function _updateHerosInfo(e:starling.events.Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() == ConstNetCommand.CS_HERO_GET_HEROS)
			{
				if (message.retcode == 0)
				{
					var mainHeroInfo:CJDataOfHero = _heroList.getMainHero();
					var level:String = mainHeroInfo.level;
					//更新等级
					_labelHeroLevel.text = "LV " + level;
					TalkingDataService.o.levelChange(parseInt(level));

					// 更新经验条
					_progressBarExp.maximum = Number(CJDataOfUpgradeProperty.o.getNeedEXP(level));
					_progressBarExp.value = Number(mainHeroInfo.currentexp);
					if (_progressBarExp.value <= 0)
					{
						_progressBarExp.visible = false;
					}
					else
					{
						_progressBarExp.visible = true;
					}
					_labelExpValue.text = _progressBarExp.value + "/" + _progressBarExp.maximum;
					_labBattlePower.text = mainHeroInfo.battleeffectsum;
				}
			}
		}


		public function get btnTouxiangkuang():Button
		{
			return _btnTouxiangkuang;
		}
		
		public function set btnTouxiangkuang(value:Button):void
		{
			_btnTouxiangkuang = value;
		}
		
		public function get btnTouxiang():Button
		{
			return _btnTouxiang;
		}
		
		public function set btnTouxiang(value:Button):void
		{
			_btnTouxiang = value;
		}
		
		public function get labelGold():Label
		{
			return _labelGold;
		}
		
		public function set labelGold(value:Label):void
		{
			_labelGold = value;
		}
		
		public function get labelSilver():Label
		{
			return _labelSilver;
		}
		
		public function set labelSilver(value:Label):void
		{
			_labelSilver = value;
		}
		
		public function get labelHeroLevel():Label
		{
			return _labelHeroLevel;
		}
		
		public function set labelHeroLevel(value:Label):void
		{
			_labelHeroLevel = value;
		}

		public function get navigator():CJMainNavigator
		{
			return _navigator;
		}

		public function set navigator(value:CJMainNavigator):void
		{
			_navigator = value;
		}


		public function get labelStrengthValue():Label
		{
			return _labelStrengthValue;
		}

		public function set labelStrengthValue(value:Label):void
		{
			_labelStrengthValue = value;
		}

		public function get labelExp():Label
		{
			return _labelExp;
		}

		public function set labelExp(value:Label):void
		{
			_labelExp = value;
		}

		public function get labelHeroName():Label
		{
			return _labelHeroName;
		}

		public function set labelHeroName(value:Label):void
		{
			_labelHeroName = value;
		}

		public function get labBattlePower():Label
		{
			return _labBattlePower;
		}

		public function set labBattlePower(value:Label):void
		{
			_labBattlePower = value;
		}

		public function get btnRecharge():Button
		{
			return _btnRecharge;
		}

		public function set btnRecharge(value:Button):void
		{
			_btnRecharge = value;
		}

	}
}