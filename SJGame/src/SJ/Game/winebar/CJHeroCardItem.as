package SJ.Game.winebar
{
	import flash.filters.ConvolutionFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextFormat;
	
	import SJ.Common.Constants.ConstFilter;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Common.Constants.ConstWinebar;
	import SJ.Common.global.textRender;
	import SJ.Game.SocketServer.SocketCommand_winebar;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.activity.CJActivityEventKey;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfWinebar;
	import SJ.Game.data.config.CJDataHeroProperty;
	import SJ.Game.data.config.CJDataOfHeroPropertyList;
	import SJ.Game.data.config.CJDataOfSkillPropertyList;
	import SJ.Game.data.json.Json_skill_setting;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJMessageBox;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	import engine_starling.utils.STween;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.display.Scale3Image;
	import feathers.textures.Scale3Textures;
	
	import starling.animation.Juggler;
	import starling.core.Starling;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	/**
	 * 武将卡牌单个实例
	 * @author longtao
	 * 
	 */
	public class CJHeroCardItem extends SLayer
	{
		public static const _CONST_WIDTH_:uint = 95;
		public static const _CONST_HEIGHT_:uint = 180;
		private static const _CONST_TURN_TIME_:Number = 0.2;
		private static const _CONST_MOVE_TIME_:Number = 0.2;
		private static const _CONST_PAUSE_TIME_:Number = 0.3;
		private static const _CONST_LABEL_WIDTH_:uint = 45;
		private static const _CONST_LABEL_HEIGHT_:uint = 15;
		
		/**
		 * 武将品质名称底框资源名称
		 * 1.白
		 * 2.绿
		 * 3.蓝
		 * 4.紫
		 * 5.橙
		 * 6.红
		 */		
		private static const _CONST_ARR_NAME_BG_:Array = [
			"jiuguan_pinzhi03", // 0 无效
			"jiuguan_pinzhi03", // 1 白
			"jiuguan_pinzhi03", // 2 绿
			"jiuguan_pinzhi05", // 3 蓝
			"jiuguan_pinzhi02", // 4 紫
			"jiuguan_pinzhi04", // 5 橙
			"jiuguan_pinzhi01", // 6 红
			];
		
		// 索引
		private var _index:String
//		// 武将模板ID
//		private var _herotemplateid:String;
//		// 武将当前状态
//		private var _herostate:String;
		
		// 正面
		private var _frontLayer:SLayer;
		// 反面
		private var _backLayer:SLayer;
		
		// 武将半身像
		private var _heroBust:ImageLoader;
		
		
		// 实际文字填写
		private var _labelName:TextField;
		private var _labelSkill:Label;
		
		// 提示玩家是否可招募该武将
		private var _btnEmploy:Button;
		
		// 要移动到的位置(x, y)
		private var _moveToPos:Point;
		// 原位置(x, y)
		private var _homePos:Point;
		
		// 是否是正面
		private var _isFront:Boolean = true;
		// 是否正在播放动画
		private var _isplaying:Boolean = false;
		// 正反面的旋转
		private var _turnTween:STween;
		// 闭合动画
		private var _firstBackTween:STween;
		// 展开动画
		private var _secondBackTween:STween;
		
		private var _imgColorFrame:Scale3Image;
		
		// 职业小图标
		private var _imgJob:ImageLoader;
		
		
		// 自身juggler
		private var _juggler:Juggler;
		// "点击抽取" 渐隐渐现
		private var _blinkTween:STween;
		
		public function CJHeroCardItem()
		{
			super();
			_init();
			_addAllEvents();
		}
		
		override public function dispose():void
		{
			// 添加点击事件
			removeEventListener(TouchEvent.TOUCH, _touchHandler);
			// 监听每一帧
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			super.dispose();
		}
		
		/**
		 * 更新界面
		 */
		public function updateLayer():void
		{
			if(!isplaying)
				_updateLayer();
		}
		
		private function _updateLayer():void
		{
			var vipLevel:uint = uint(CJDataManager.o.DataOfRole.vipLevel);
			var tPickcount:int = ConstWinebar.WINEBAR_PICK_COUNT_LIMIT[vipLevel] as int;
			
			var winebar:CJDataOfWinebar = CJDataManager.o.DataOfWinebar;
			var winebarstate:String = winebar.state;
			var herotemplateid:String = winebar.getData("herotemplateid"+_index);
			var herostate:String = winebar.getData("herostate"+_index);
			
			var heroProperty:CJDataHeroProperty = CJDataOfHeroPropertyList.o.getProperty(uint(herotemplateid));
			
			// 名称底框变颜色
			_imgColorFrame.textures = new Scale3Textures(SApplication.assets.getTexture(_CONST_ARR_NAME_BG_[heroProperty.quality]) , 30 , 4 , Scale3Textures.DIRECTION_VERTICAL);
			_labelName.text = CJLang(heroProperty.name);
			// 获取技能名称
			if (null != heroProperty.skill1)
			{
				var skillObj:Json_skill_setting = CJDataOfSkillPropertyList.o.getProperty(heroProperty.skill1) as Json_skill_setting;
				_labelSkill.text = CJLang(skillObj.skillname);
			}
			else
				_labelSkill.text == "";

			
			// 获取武将信息
			/// 武将半身像
			var strBust:String = heroProperty.card;
			var texture:Texture = SApplication.assets.getTexture(strBust);
			_heroBust.source = texture;
			// 判断该是否需要显示
			_btnEmploy.visible = herostate == ConstWinebar.ConstWinebarHeroStateNoSelected ? false : true;
			if(_btnEmploy.visible)
			{
				this.name = "CLICK_CARD_ZHAOMU";
			}
				
			_btnEmploy.label = "";
			_btnEmploy.touchable = false;
			
			if (herostate == ConstWinebar.ConstWinebarHeroStateSelected)
			{
				_btnEmploy.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniu01new"));
				_btnEmploy.label = CJLang("WINEBAR_ITEM_EMPLOY");
				_btnEmploy.x = 25;
				_btnEmploy.y = 130;
				_btnEmploy.width = this.width/2 - 5;
				_btnEmploy.height = _CONST_LABEL_HEIGHT_;
				
				if(_heroBust.filter != null)
				{
					_heroBust.filter.dispose();
				}
				_heroBust.filter = null;
			}
			else if (herostate == ConstWinebar.ConstWinebarHeroStateEmployed)
			{
				_btnEmploy.defaultSkin = new SImage(SApplication.assets.getTexture("jiuguan_zhaomubiao"));
				_btnEmploy.x = width/2 + 15;
				_btnEmploy.y = height/2 + 13;
				_btnEmploy.width = 21;
				_btnEmploy.height = 48;
				
				
				if(_heroBust.filter != null)
				{
					_heroBust.filter.dispose();
				}
				_heroBust.filter = null;
			}
			else
			{
				if(_heroBust.filter == null)
				{
					_heroBust.filter = ConstFilter.genBlackFilter();
				}
			}
			
			// 武将职业小图标
			_imgJob.source = SApplication.assets.getTexture("haoyou_zhiye"+heroProperty.job);
			
			// 判断武将牌的显示
			_judgeCardFace();
		}
		
		/// 判断武将牌的显示
		private function _judgeCardFace():void
		{
			var winebar:CJDataOfWinebar = CJDataManager.o.DataOfWinebar;
			var winebarstate:String = winebar.state;
			var tHerostate:String = winebar.getData("herostate"+_index);
			
			// 判断酒馆当前状态
			if( winebarstate == ConstWinebar.ConstWinebarStateFront ) // 酒馆明牌
			{
				_markCardFace(true);
			}
			else if (winebarstate == ConstWinebar.ConstWinebarStateBack && // 酒馆暗牌且可抽牌
				int(winebar.pickcount) > 0  )
			{
				if (tHerostate == ConstWinebar.ConstWinebarHeroStateNoSelected)
				{
					_markCardFace(false);
				}
				else
				{
					_markCardFace(true);
				}
			}
			else
			{
				_markCardFace(true);
			}
		}
		
		// 表示卡牌正反面， true为正面
		private function _markCardFace( b:Boolean = true ):void
		{
			_isFront = b;
			_frontLayer.visible = b;
			_backLayer.visible = !b;
		}
		
		
		/**
		 * 从正面切换到背面并且旋转
		 * 
		 */
		public function cardBackAndTurn():void
		{
			_isplaying = true;
			_markCardFace( false );
			
			_firstBackTween = new STween(this, _CONST_MOVE_TIME_);
			_firstBackTween.moveTo( moveToPos.x, moveToPos.y );
			_firstBackTween.onComplete = _onFirstBackTweenComplete;
			Starling.juggler.add(_firstBackTween);
			
			_secondBackTween = new STween( this, _CONST_MOVE_TIME_ );
			_secondBackTween.moveTo( homePos.x, homePos.y );
			_secondBackTween.delay = _CONST_PAUSE_TIME_;	// 延迟
			_secondBackTween.onComplete = _onSecondBackTweenComplete;
			
			function _onFirstBackTweenComplete ():void
			{
				Starling.juggler.remove(_firstBackTween);
				_firstBackTween = null;
				
				Starling.juggler.add(_secondBackTween);
			}
			
			function _onSecondBackTweenComplete ():void
			{
				Starling.juggler.remove(_secondBackTween);
				_secondBackTween = null;
				
				_isplaying = false;
				// 会出现点击开始抽取武将后立即点击刷新情况
				updateLayer();
			}
		}
		
		/**
		 * 从背面切换至正面 
		 */
		public function cardBackToFront():void
		{
			_isplaying = true;
			
			_turnTween = new STween( _backLayer, _CONST_TURN_TIME_ );
			_turnTween.animate("skewY", Math.PI);
			_turnTween.onComplete = _onCurTurnTweenComplete;
			Starling.juggler.add(_turnTween);
		}
		
		private function _onCurTurnTweenComplete():void
		{
			Starling.juggler.remove(_turnTween);
			_turnTween = null;
			
			_isplaying = false;
			_backLayer.skewY = 0;
			
			var winebar:CJDataOfWinebar = CJDataManager.o.DataOfWinebar;
			if(0 == int(winebar.pickcount))
				(this.parent as CJHeroCardPanel).updateLayer();				
			else
				_updateLayer();
			
			//处理指引
			if(CJDataManager.o.DataOfFuncList.isIndicating)
			{
				CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_INDICATE_NEXT_STEP);
			}
		}
		
		private function _init():void
		{
			this.width = _CONST_WIDTH_;
			this.height = _CONST_HEIGHT_;
			
			this.pivotX = width/2;
			this.pivotY = height/2;
			
			_frontLayer = new SLayer();
			_frontLayer.x = 0;
			_frontLayer.y = 0;
			_frontLayer.width = this.width;
			_frontLayer.height = this.height;
			addChild(_frontLayer);
			
//			imgFrontBG.scaleX = imgFrontBG.scaleY = 2;
			
			/// 武将半身像
			_heroBust = new ImageLoader;
			_heroBust.x = 4;
			_heroBust.y = -10;
			_heroBust.width = _frontLayer.width-8;
			_heroBust.height = _frontLayer.height;
			_frontLayer.addChild(_heroBust);
			/// 名称底图
			_imgColorFrame = new Scale3Image(new Scale3Textures(SApplication.assets.getTexture(_CONST_ARR_NAME_BG_[0]) , 30 , 4 , Scale3Textures.DIRECTION_VERTICAL));
			_imgColorFrame.x = 6;
			_imgColorFrame.y = 8;
			_imgColorFrame.width = 80;
			_imgColorFrame.height = 148;
			_frontLayer.addChild(_imgColorFrame);
			/// 夹层
			var imgFrontBG:Scale3Image = new Scale3Image(new Scale3Textures(SApplication.assets.getTexture("jiuguan_kapaiwaikuang") , 18 , 1 , Scale3Textures.DIRECTION_VERTICAL));
			imgFrontBG.x = 0;
			imgFrontBG.y = 0;
			imgFrontBG.width = _frontLayer.width;
			imgFrontBG.height = _frontLayer.height;
			_frontLayer.addChild(imgFrontBG);
			
			var fontFormat:TextFormat = new TextFormat( "Arial", 12, 0xF0EAAC );
			/// 是否可以招募
			_btnEmploy = new Button;
			_btnEmploy.x = this.width/2;
			_btnEmploy.y = 10;
//			_btnEmploy.width = this.width/2 - 5;
//			_btnEmploy.height = _CONST_LABEL_HEIGHT_;
			_btnEmploy.label = CJLang("WINEBAR_ITEM_EMPLOY");
			_btnEmploy.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniu01new"));
			_btnEmploy.defaultLabelProperties.textFormat = ConstTextFormat.textformatwhite;
			_frontLayer.addChild(_btnEmploy);
			// 武将名称
			_labelName = new TextField(20, 70, "");
			_labelName.x = 10;
			_labelName.y = 5;
			_labelName.color = 0xFFFE73;
			_labelName.fontSize = ConstTextFormat.FONT_SIZE_10;
			_labelName.fontName = ConstTextFormat.FONT_FAMILY_HEITI;
			_textStroke(_labelName);
			_frontLayer.addChild(_labelName);
			// 技能名称
			_labelSkill = new Label;
			_labelSkill.x = 32;
			_labelSkill.y = 152;
			_labelSkill.width = width*3/4;
			_labelSkill.height = _CONST_LABEL_HEIGHT_;
			_labelSkill.textRendererProperties.textFormat = ConstTextFormat.textformatwhite;
			_labelSkill.textRendererFactory = textRender.standardTextRender;
			_frontLayer.addChild(_labelSkill);
//			/// 添加正面外边框
//			var frameFront:Scale9Image;
//			frameFront = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_bianzhuangshi") , new Rectangle(18,18 ,3,3)));
//			frameFront.width = this.width;
//			frameFront.height = this.height;
//			_frontLayer.addChild(frameFront);
//			/// 展现技能贴图
//			var imgSkill:ImageLoader = new ImageLoader;
//			imgSkill.source = SApplication.assets.getTexture("jiuguan_jinengtubiao");
//			imgSkill.x = 0;
//			imgSkill.y = 150;
//			_frontLayer.addChild(imgSkill);
			
			/// 卡牌背面
			_backLayer = new SLayer();
			_backLayer.x = this.width/2;
			_backLayer.y = this.height/2;
			_backLayer.width = this.width;
			_backLayer.height = this.height;
			_backLayer.pivotX = _backLayer.width/2;
			_backLayer.pivotY = _backLayer.height/2;
			addChild(_backLayer);
			/// 添加背面底图
			var imgBackBG:ImageLoader = new ImageLoader();
			imgBackBG.source = SApplication.assets.getTexture("jiuguan_kapaibeimian");
			imgBackBG.x = 0;
			imgBackBG.y = 0;
			imgBackBG.width = this.width;
			imgBackBG.height = this.height;
//			imgBackBG.scaleX = imgBackBG.scaleY = 2;
			_backLayer.addChild(imgBackBG);
			// 点击抽取  图片
			imgBackBG = new ImageLoader();
			imgBackBG.source = SApplication.assets.getTexture("jiuguan_dianjichouqu");
			imgBackBG.x = 35;
			imgBackBG.y = 35;
			_backLayer.addChild(imgBackBG);
			
			_juggler = new Juggler;
			var __fadeOut:STween = new STween(imgBackBG, 1);
			__fadeOut.fadeTo(0.3);
			__fadeOut.onComplete = __onFadeOut;
			__fadeOut.loop = 2;
			_juggler.add(__fadeOut);
			
			var __fadeIn:STween = new STween(imgBackBG, 1);
			__fadeIn.fadeTo(1.0);
			__fadeIn.onComplete = __onFadeIn;
			__fadeIn.loop = 2;
			
			
			function __onFadeOut():void
			{
				_juggler.remove(__fadeOut);
				_juggler.add(__fadeIn);
			}
				
			function __onFadeIn():void
			{
				_juggler.remove(__fadeIn);
				_juggler.add(__fadeOut);
			}
			
			
			
			// 职业小图标
			_imgJob = new ImageLoader;
			_imgJob.x = 60;
			_imgJob.y = 10;
			_frontLayer.addChild(_imgJob);
		}
		
		private function _addAllEvents():void
		{
			// 添加点击事件
			addEventListener(TouchEvent.TOUCH, _touchHandler);
			
			// 监听每一帧
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function _touchHandler(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this);
			if(touch != null && touch.phase == TouchPhase.ENDED)
			{
//				var vipLevel:uint = uint(CJDataManager.o.DataOfRole.vipLevel);
//				var tPickcount:int = ConstWinebar.WINEBAR_PICK_COUNT_LIMIT[vipLevel] as int;
				// 判断当前酒馆状态
				var winebar:CJDataOfWinebar = CJDataManager.o.DataOfWinebar;
				var curPickcount:int = int(winebar.pickcount);
				if (winebar.state == ConstWinebar.ConstWinebarStateBack &&	// 酒馆状态
					winebar.getData("herostate"+index).toString() == ConstWinebar.ConstWinebarHeroStateNoSelected &&// 该武将状态
					curPickcount > 0 && !_isFront && !isplaying)	// 数量够  是反面 无动画进行
				{
					// 翻牌
					SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _onPickingComplete);
					SocketCommand_winebar.picking(index);
				}
				else
				{
					var herotemplateid:String = winebar.getData("herotemplateid"+index);
					var herostate:String = winebar.getData("herostate"+index);
					// 打开武将界面
					if (index && herotemplateid && herostate)
					{
						SApplication.moduleManager.enterModule("CJWinebarHeroModule", [index, herotemplateid, herostate]);
					}
						
				}
			}
		}
		
		private function _onPickingComplete(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() != ConstNetCommand.CS_WINEBAR_PICKING)
				return;
			
			switch(message.retcode)
			{
				case 0:
					break;
				case 1:
					CJMessageBox(CJLang("ERROR_WINEBAR_CARD_FRONT"));
					return;
				case 2:
					CJMessageBox(CJLang("ERROR_WINEBAR_PICKCOUNT"));
					return;
				case 3:
					CJMessageBox(CJLang("ERROR_WINEBAR_PICKCOUNT_UNUSUAL"));
					return;
				case 4:
					CJMessageBox(CJLang("ERROR_WINEBAR_UNUSUAL_CARD"));
					return;
				default:
					CJMessageBox(CJLang("ERROR_UNKNOWN")+ "CJHeroCardItem._onPickingComplete retcode="+message.retcode );
					return;
			}
				e.target.removeEventListener(e.type, _onPickingComplete);
				
				var rtnObject:Object = message.retparams;
				// 点击的目标位置
				var index:String = message.retparams[0];
				var herotemplateid0:String = message.retparams[1];
				var herotemplateid1:String = message.retparams[2];
				var herotemplateid2:String = message.retparams[3];
				var herotemplateid3:String = message.retparams[4];
				var herotemplateid4:String = message.retparams[5];
				var pickcount:String = message.retparams[6];
				
				var winebar:CJDataOfWinebar = CJDataManager.o.DataOfWinebar;
				winebar.setData("herostate"+index, ConstWinebar.ConstWinebarHeroStateSelected);
				winebar.herotemplateid0 = herotemplateid0;
				winebar.herotemplateid1 = herotemplateid1;
				winebar.herotemplateid2 = herotemplateid2;
				winebar.herotemplateid3 = herotemplateid3;
				winebar.herotemplateid4 = herotemplateid4;
				winebar.pickcount = pickcount;
				
				// 活跃度
				CJDataManager.o.activityManager.dispatchEventWith(CJEvent.EVENT_ACTIVITY_HAPPEN , false, {"key":CJActivityEventKey.ACTIVITY_HERORECRUT});
				
				// 播放动画
				cardBackToFront();
		}
		
		// 每一帧调用
		private function onEnterFrame(event:EnterFrameEvent):void
		{
			if (null == _juggler)
				_juggler = new Juggler;
			
			_juggler.advanceTime(event.passedTime);
		}
		
		/**
		 * 获取该控件动画是否在运行中
		 * @return 
		 * 
		 */
		public function get isplaying():Boolean
		{
			return _isplaying;
		}
		
		/**
		 * 控件索引
		 * @param value
		 * 
		 */
		public function set index( value:String ):void
		{
			_index = value;
		}
		public function get index():String
		{
			return _index;
		}
		
		
		// 文字描边
		private function _textStroke(tf:TextField):void
		{
			var matrix:Array = [0,1,0,
				1,1,1,
				0,1,0];
			tf.nativeFilters = [new ConvolutionFilter(3,3,matrix,3),
				new GlowFilter(0x000000,1.0,2.0,2.0,5,2)];
		}
		
//		/**
//		 * 武将模板id
//		 * @param value
//		 * 
//		 */
//		public function set herotemplateid( value:String ):void
//		{
//			_herotemplateid = value;
//		}
//		public function get herotemplateid():String
//		{
//			return _herotemplateid;
//		}
//		
//		/**
//		 * 武将当前状态
//		 * @param value
//		 * 
//		 */
//		public function set herostate( value:String ):void
//		{
//			_herostate = value;
//		}
//		public function get herostate():String
//		{
//			return _herostate;
//		}
		
		/**
		 * 初始位置
		 * @return 
		 * 
		 */
		public function get homePos():Point
		{
			return _homePos;
		}
		
		public function set homePos(value:Point):void
		{
			_homePos = value;
			this.x = _homePos.x;
			this.y = _homePos.y;
		}
		
		/**
		 * 需要移动的目的位置
		 * @return 
		 * 
		 */
		public function get moveToPos():Point
		{
			return _moveToPos;
		}
		
		public function set moveToPos(value:Point):void
		{
			_moveToPos = value;
		}
	}
}