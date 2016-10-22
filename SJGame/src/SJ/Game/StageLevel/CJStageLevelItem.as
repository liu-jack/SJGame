package SJ.Game.StageLevel
{
	import flash.filters.ConvolutionFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstStageLevel;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.SocketServer.SocketCommand_stageLevel;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfStageLevel;
	import SJ.Game.data.config.CJDataOfStageLevelProperty;
	import SJ.Game.data.json.Json_role_stage_level;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJMessageBox;
	
	import engine_starling.SApplication;
	import engine_starling.display.SAnimate;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.STween;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.display.Scale3Image;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale3Textures;
	import feathers.textures.Scale9Textures;
	
	import lib.engine.math.Vector2D;
	import lib.engine.utils.functions.Assert;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.extensions.pixelmask.PixelMaskDisplayObject;
	import starling.text.TextField;
	
	
	public class CJStageLevelItem extends SLayer implements IListItemRenderer
	{
		/** 宽度 **/
		private static const ITEM_WIDTH:uint = 361;
		/** 高度 **/
		private static const ITEM_HEIGHT:uint = 261;
		
		/** 缩放倍数 **/
		private static const ITEM_SCALE:Number = 1.2;
		
		
		//是否被选中
		private var _isSelected:Boolean;
		/*实际数据*/
		private var _data:Object;
		/*默认属性*/
		private var _index:int;
		private var _owner:List;
		
		// 未激活圣兽的背景图
		private var _imgBG:ImageLoader;
		// 激活圣兽的背景图
		private var _imgActivateBG:ImageLoader;
		// 十颗武星
		private var _vecForceStar:Vector.<Button> = new Vector.<Button>();
		// 九条武星连线
		private var _vecLien:Vector.<Scale3Image> = new Vector.<Scale3Image>;
		/** 名称 **/
		private var _stageName:TextField;
		
		
		/** 是否正在播放动画 **/
		private var _isPlaying:Boolean = false;
		
		/** 开启武星时间 秒 **/
		private const _CONST_OPEN_TIME_:Number = 1;
		/** 开启武星时间 秒 **/
		private const _CONST_OPEN_DELAY_TIME_:Number = 0.5;
		/** 特效放大倍数 **/
		private const _CONST_SCALE_MUL_:Number = 4;
		/** 特效位置 **/
		private const _CONST_OPEN_POS_X:uint = 170;
		private const _CONST_OPEN_POS_Y:uint = 120;
		
		/** 开启武星特效名称 **/
		private var _openAnimName:String;
		/** 开启武星特效 **/
		private var _openAnimate:SAnimate;
		/** 开启武星特效补间动画 **/
		private var _openTween:STween;
		/** 开启武星，进入武星补间动画 **/
		private var _goinTween:STween;
		
		/** 完成连线使用时间 秒 **/
		private const _CONST_LINE_TIME_:Number = 1;
		/** 连线补间动画 **/
		private var _lineSTween:STween;
		/** 连线 **/
		private var _lineScale3Image:Scale3Image;
		private var _curBtn:Button;
		private var _nextBtn:Button;
		
		/** 待开启武星  跑马灯特效 **/
		private var _waitAnimate:SAnimate;
		/** 待开启武星 光晕特效 **/
		private var _haloAnimate:SAnimate;
		
		/** 武星激活成功特效  播放完成直接消失，等待下次激活时再开启 **/
		private var _forceStarBlink:SAnimate;
		
		
		/** 渐变遮罩高度 **/
		private static const _SHADE_HEIGHT_:int = 20;
		/// 遮罩层
		private var _maskPanel:PixelMaskDisplayObject;
		// 遮罩
		private var _maskLayer:SLayer;
		// 遮罩
		private var _quad:Quad;
		// 渐变层
		private var _shade:SImage;
		
		/** 高亮圣兽补间动画时间(秒) **/
		private var _CONST_HIGHLIGHT_FADEIN_TIME_:Number = 2.0;
		/** 放大圣兽补间动画时间(秒) **/
		private var _CONST_HIGHLIGHT_SCALEBIG_TIME_:Number = 1.0;

		
		public function CJStageLevelItem()
		{
			super();
		}
		
		override public function dispose():void
		{
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData, _onStageItemComplete);
			if (_waitAnimate)
				Starling.juggler.remove(_waitAnimate);
			if (_haloAnimate)
				Starling.juggler.remove(_haloAnimate);
			
			super.dispose();
		}
		
		override protected function initialize():void
		{
			width = ITEM_WIDTH;
			height = ITEM_HEIGHT;
			
			// 背景图
			_imgBG = new ImageLoader;
			addChild(_imgBG);
			// 遮罩
			_maskPanel = new PixelMaskDisplayObject();
			// mask
			_quad = new Quad(width, ITEM_HEIGHT);
			_shade = new SImage(SApplication.assets.getTexture("zhujueshengjie_zhezhao"));
			_maskLayer = new SLayer;
			_maskLayer.addChild(_quad);
			_maskLayer.addChild(_shade);
			_maskLayer.width = ITEM_WIDTH;
			_maskLayer.height = ITEM_HEIGHT;
			_maskPanel.mask = _maskLayer;
			addChild(_maskPanel);
			_UpdateMaskPos(0);
			// 激活背景图
			_imgActivateBG = new ImageLoader;
			_maskPanel.addChild(_imgActivateBG);
			
			// 纹理
			var scale3Texture:Scale3Textures = new Scale3Textures(SApplication.assets.getTexture("zhujueshengjie_di"),2,2);
			// 九条武星连线
			var scale3line:Scale3Image;
			for(var i:int=0; i<ConstStageLevel.ConstMaxStar-1; i++)
			{
				scale3line = new Scale3Image(scale3Texture);
				scale3line.touchable = false; // 不可触及
				addChild(scale3line);
				_vecLien.push(scale3line);
			}
			// 连线动画中的连线元素
			_lineScale3Image = new Scale3Image(scale3Texture);
			_lineScale3Image.visible = false;
			_lineScale3Image.touchable = false;
			addChild(_lineScale3Image);
			// 十颗武星
			for(i=0; i<ConstStageLevel.ConstMaxStar; i++)
			{
				var btn:Button = new Button;
				btn.pivotX = 7;
				btn.pivotY = 7;
				btn.width = 15;
				btn.height = 15;
				btn.name = "CJStageLevelStar_" + (i+1);
				btn.scaleX = ITEM_SCALE;
				btn.scaleY = ITEM_SCALE;
				addChild(btn);
				_vecForceStar.push(btn);
			}
			
			var img:ImageLoader = new ImageLoader;
			img.source = SApplication.assets.getTexture("zhujueshengjie_wenzidi");
			img.x = 320;
			img.y = 130;
			addChild(img);
			// 升阶名称
			// 武将名称
			_stageName = new TextField(20, 60, "");
			_stageName.x = img.x+8;
			_stageName.y = img.y+10;
			_textStroke(_stageName);
			_stageName.fontName = "隶书";
			_stageName.bold = true;
			_stageName.fontSize = 15;
			addChild(_stageName);
			
			
			var animObject:Object = AssetManagerUtil.o.getObject("anim_stagelevel_weijihuo");
			if (animObject != null)
			{
				_waitAnimate = SAnimate.SAnimateFromAnimJsonObject(animObject);
				addChild(_waitAnimate);
				_waitAnimate.visible = false;
				_waitAnimate.touchable = false;
				_waitAnimate.scaleX = ITEM_SCALE;
				_waitAnimate.scaleY = ITEM_SCALE;
				Starling.juggler.add(_waitAnimate); // 开始播放
			}
			
			_haloAnimate = new SAnimate(SApplication.assets.getTextures("zuoqihuanhua_jihuotexiao"));
			if (_haloAnimate != null)
			{
				addChild(_haloAnimate);
				_haloAnimate.visible = false;
				_haloAnimate.touchable = false;
				_haloAnimate.pivotX = 37.5;
				_haloAnimate.pivotY = 37.5;
				_haloAnimate.scaleX = 0.65;
				_haloAnimate.scaleY = 0.65;
				Starling.juggler.add(_haloAnimate); // 开始播放
			}
			
			// 点击事件
			addEventListener(TouchEvent.TOUCH, _touchHandler);
			// 监听武星激活事件
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _onStageItemComplete);
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
		
		override protected function draw():void
		{
			super.draw();
			
			if(data == null)
			{
				return;
			}
			const isAllInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			if(isAllInvalid)
			{
				/// 主角升阶信息
				var stageLevelInfo:CJDataOfStageLevel = CJDataManager.o.DataOfStageLevel;
				// 当前激活的武星索引
				stageLevelInfo.forceStar;
				
				// 等级
				var stageLevel:int = data.stageLevel;
				// 背景资源替换
				_imgBG.source = SApplication.assets.getTexture(ConstStageLevel.ConstStageUnBGObj[stageLevel]);
				_imgBG.scaleX = _imgBG.scaleY = 2;
				_imgActivateBG.source = SApplication.assets.getTexture(ConstStageLevel.ConstStageBGObj[stageLevel]);
				_imgActivateBG.scaleX = _imgActivateBG.scaleY = 2;
				// 储存的武星摆放位置
				var obj:Object = ConstStageLevel.ConstForceStarObj;
				// 十颗武星位置
				for(var i:int=0; i<ConstStageLevel.ConstMaxStar; i++)
				{
					var btnForceStar:Button = _vecForceStar[i];
					btnForceStar.x = obj[stageLevel][i+1].x - 110;
					btnForceStar.y = obj[stageLevel][i+1].y - 35;
					// 是否被激活
					var forceStarIndex:int = ((stageLevel-1)*10 + (i+1));
					var isActivate:Boolean = stageLevelInfo.forceStar >= forceStarIndex;
					// 类型
					var jsStageLevel:Json_role_stage_level = CJDataOfStageLevelProperty.o.getData(forceStarIndex.toString());
					btnForceStar.defaultSkin = _getTexture( isActivate, stageLevel, jsStageLevel.type);
					// 判断是否要添加文字
					if (!isActivate )
					{
						if (jsStageLevel.type == ConstStageLevel.ConstStageTypeSkill)
						{
							btnForceStar.defaultLabelProperties.textFormat = ConstTextFormat.textformatwhite;
							btnForceStar.label = CJLang("STAGE_SKILL_TXT");
						}
						else if (jsStageLevel.type == ConstStageLevel.ConstStageTypeImage)
						{
							btnForceStar.defaultLabelProperties.textFormat = ConstTextFormat.textformatwhite;
							btnForceStar.label = CJLang("STAGE_XING_TXT");
						}
					}
					
					// 判断是否应该加入旋转带选中特效
					if (forceStarIndex-1 == stageLevelInfo.forceStar)
					{
						_waitAnimate.x = btnForceStar.x;
						_waitAnimate.y = btnForceStar.y;
						_haloAnimate.x = btnForceStar.x;
						_haloAnimate.y = btnForceStar.y;
					}
				}
				// 武星与武星之间连线
				_ligatureStarLine();
				
				// 字体颜色
				_stageName.color = ConstStageLevel.ConstFontColor[stageLevel];
				_stageName.text = CJLang("STAGE_NAME_"+stageLevel);
				
				
				// 特效
				if (_openAnimName != ConstStageLevel.ConstUpgradeAnim[stageLevel])
				{
					_openAnimName = ConstStageLevel.ConstUpgradeAnim[stageLevel];
					var animObject:Object = AssetManagerUtil.o.getObject(_openAnimName);
					if (animObject!=null)
					{
						if (_openAnimate != null)
						{
							removeChild(_openAnimate);
						}
							
						_openAnimate = SAnimate.SAnimateFromAnimJsonObject(animObject);
						_openAnimate.x = _CONST_OPEN_POS_X;
						_openAnimate.y = _CONST_OPEN_POS_Y;
						_openAnimate.scaleX = _CONST_SCALE_MUL_;
						_openAnimate.scaleY = _CONST_SCALE_MUL_;
						addChild(_openAnimate);
						_openAnimate.visible = false;
					}
				}
				// 更新未激活的武星
				_pendingForceStar();
				// 更新遮罩位置
				_updateMask();
			}
		}
		
		/// 获取纹理
		private function _getTexture(isActivate:Boolean, stageLevel:int, type:int):SImage
		{
			var str:String;
			var img:SImage;
			// 未激活的点
			if (!isActivate)
			{
				str = "zhujueshengjie_dianhui";
			}
			else
			{
				// 已激活
				// 普通点
				if (type == ConstStageLevel.ConstStageTypeCommon)
				{
					str = ConstStageLevel.ConstActivatePointResName[stageLevel];
				}
				else if (type == ConstStageLevel.ConstStageTypeSkill) // 技能点
				{
					str = "zhujueshengjie_dianji";
				}
				else // 形象点
				{
					str = "zhujueshengjie_dianxing";
				}
			}
			
			img = new SImage(SApplication.assets.getTexture(str));
			return img;
		}
		
		/// 连线武星
		private function _ligatureStarLine():void
		{
			/// 主角升阶信息
			var stageLevelInfo:CJDataOfStageLevel = CJDataManager.o.DataOfStageLevel;
			// 等级
			var stageLevel:int = data.stageLevel;
			/// 
			var currentLinePos:Vector2D = new Vector2D();
			var nextLinePos:Vector2D = new Vector2D();
			/// 灰质的纹理
			var noEnabledTexture:Scale3Textures = new Scale3Textures(SApplication.assets.getTexture("zhujueshengjie_di"),2,2);
			/// 可用的纹理
			var enabledTexture:Scale3Textures = new Scale3Textures(SApplication.assets.getTexture(ConstStageLevel.ConstUpgradeLine[stageLevel]),2,2);
			var scale3line:Scale3Image;// = new Scale3Image(scale3Texture);
			// 默认
			_curBtn = _vecForceStar[0];
			_nextBtn = _vecForceStar[1];
			
			// 十颗武星位置
			for(var i:int=0; i<ConstStageLevel.ConstMaxStar-1; i++)
			{
				var curBtn:Button = _vecForceStar[i];
				var nextBtn:Button = _vecForceStar[i+1];
				
				currentLinePos.x = curBtn.x;
				currentLinePos.y = curBtn.y;
				nextLinePos.x = nextBtn.x;
				nextLinePos.y = nextBtn.y;
//				scale3line = new Scale3Image(scale3Texture);
				scale3line = _vecLien[i];
				scale3line.pivotY = scale3line.height / 2;
				scale3line.x = currentLinePos.x;
				scale3line.y = currentLinePos.y;
				var diffvector2d:Vector2D = currentLinePos.subtract(nextLinePos);
				scale3line.width = diffvector2d.length;
				scale3line.rotation =Math.PI + diffvector2d.angle;
				// 判断 两点均为激活
				// 是否被激活
				var curIndex:int = ((stageLevel-1)*10 + (i+1));
				var nextIndex:int = ((stageLevel-1)*10 + (i+2));
				// 当前的武星是否激活
				var isCurActivate:Boolean = stageLevelInfo.forceStar >= curIndex;
				var isNextActivate:Boolean = stageLevelInfo.forceStar >= nextIndex;
				if ( isCurActivate && isNextActivate )
					scale3line.textures = enabledTexture;
				else if (isCurActivate && !isNextActivate)
					scale3line.textures = enabledTexture;
				else
					scale3line.textures = noEnabledTexture;
				// 记录当前按钮，下一个按钮
				if ( isCurActivate && !isNextActivate)
				{
					_curBtn = nextBtn;
					_nextBtn = (i+2<_vecForceStar.length) ? _vecForceStar[i+2] : null;
				}
			}
		}
		
		/// 触摸调用
		private function _touchHandler(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this);
			if(touch == null || touch.phase != TouchPhase.ENDED)
				return;
			
			if (!(touch.target is Button))
				return;
			if (_isPlaying)
				return;
			
			//处理指引
			if(CJDataManager.o.DataOfFuncList.isIndicating)
			{
				CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_INDICATE_NEXT_STEP);
			}
			
			// 当前点中的按钮
			var btn:Button = touch.target as Button;
			// 当前页的升阶等级
			var stageLevel:int = data.stageLevel;
			
			// 当前点中星索引
			var _curforceStar:int = ((stageLevel-1)*10 + int(btn.name.split("_")[1]));
			// 是否被激活
			var isActivate:Boolean = false;
			// 当前星级
			var forceStarIndex:uint = CJDataManager.o.DataOfStageLevel.forceStar;
			// 判断索引
			if (_curforceStar <= forceStarIndex) // 已激活的
				isActivate = false;
			else if (_curforceStar > forceStarIndex+1) // 不可被激活的
				isActivate = false;
			else
				isActivate = true;
			
			// 判断条件是否充足
			var jsStageLevel:Json_role_stage_level = CJDataOfStageLevelProperty.o.getData(String(_curforceStar));
			var isCondition:Boolean = true;
			
			// 判断主角武魂是否足够
			if (CJDataManager.o.DataOfStageLevel.forceSoul < int(jsStageLevel.forcesoul))
				isCondition = false;
			// 判断主角等级是否足够
			if (uint(CJDataManager.o.DataOfHeroList.getMainHero().level) < int(jsStageLevel.level))
				isCondition = false;
			
			if (isActivate && isCondition) // 直接升
				// 请求激活
				SocketCommand_stageLevel.activate_force_star();
			else
				// 进入展示武星模块
				SApplication.moduleManager.enterModule("CJStageShowModule", {"forceStarIndex":_curforceStar});
		}
		
		// 武星激活
		private function _onStageItemComplete(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() != ConstNetCommand.CS_STAGELEVEL_ACTIVATE_FORCE_STAR)
				return;
			
			switch(message.retcode)
			{
				case 0:
					//重新获取角色技能
					CJDataManager.o.DataOfUserSkillList.loadFromRemote();
					break;
				case 2:
					CJMessageBox(CJLang("ERROR_STAGE_LEVEL"));
					return;
				case 3:
					CJMessageBox(CJLang("ERROR_STAGE_FORCE_SOUL"));
					return;
				default:
					CJMessageBox(CJLang("ERROR_UNKNOWN")+ "CJStageLevelItem._onStageItemComplete retcode="+message.retcode );
					return;
			}
			
			if (data == null)
				return;
			
			// 当前武星索引
			var forceStar:uint = uint(message.retparams[1]);
			
			// 等级
			var stageLevel:int = data.stageLevel;
			var newstageLevel:uint = ConstStageLevel.getStageLevel(forceStar);
			
			// 是统一阶
			if (newstageLevel != stageLevel)
				return;
				
			var curBtn:Button;
			// 将未激活的星星激活
			var curIndex:uint = getCurStageLevelStarIndex(forceStar);
			curBtn = _vecForceStar[curIndex] as Button;
			Assert( curBtn != null , "curBtn == null");
			
			// 激活特效
			_openAnimate.visible = true;
			Starling.juggler.add(_openAnimate);
			_openAnimate.gotoAndPlay();
			// 
			_isPlaying = true; // 播放中
			owner.touchable = false;
			_openTween = new STween(_openAnimate, _CONST_OPEN_TIME_); // 补间动画
			_openTween.delay = _CONST_OPEN_DELAY_TIME_; // 延迟时间
			_openTween.moveTo( curBtn.x, curBtn.y ); // 移动到的位置
			_openTween.animate("scaleX", 0);
			_openTween.animate("scaleY", 0);
			Starling.juggler.add(_openTween); // 开始播放
			// 完成
			_openTween.onComplete = _onOpenShowComplete;
		}
		
		// 仅仅是刚出现的大特效播放完毕
		private function _onOpenShowComplete():void
		{
			Starling.juggler.remove(_openTween);
			_openAnimate.x = _CONST_OPEN_POS_X;
			_openAnimate.y = _CONST_OPEN_POS_Y;
			// 切换为原来的 放大倍数
			_openAnimate.scaleX = _CONST_SCALE_MUL_;
			_openAnimate.scaleY = _CONST_SCALE_MUL_;
			_openAnimate.visible = false;
			
			
			_lightenForceStar(); // 点亮武星
			// 点亮武星特效
			var resName:String = ConstStageLevel.ConstActivateBlink[int(data.stageLevel)];
			var animObject:Object = AssetManagerUtil.o.getObject(resName);
			if (animObject != null)
			{
				_forceStarBlink = SAnimate.SAnimateFromAnimJsonObject(animObject);
				if (_curBtn)
				{
					_forceStarBlink.x = _curBtn.x;
					_forceStarBlink.y = _curBtn.y;
				}
				_forceStarBlink.touchable = false; // 不可触摸
				_forceStarBlink.loop = false; // 非循环
				addChild(_forceStarBlink);
				Starling.juggler.add(_forceStarBlink); // 开始播放
				_forceStarBlink.addEventListener(Event.COMPLETE, __onForceStarBlinkComplete);
			}
			
			// 动画播放完成调用函数
			function __onForceStarBlinkComplete(e:Event):void
			{
				Starling.juggler.remove(_forceStarBlink); //
				_forceStarBlink.removeFromParent(); // 移除显示
				_linkTween();
			}
		}
		
		// 连线补间
		private function _linkTween():void
		{
			// 连线补间动画
			if(null!=_curBtn && null!=_nextBtn)
			{
				var currentLinePos:Vector2D = new Vector2D();
				var nextLinePos:Vector2D = new Vector2D();
				currentLinePos.x = _curBtn.x;
				currentLinePos.y = _curBtn.y;
				nextLinePos.x = _nextBtn.x;
				nextLinePos.y = _nextBtn.y;
				_lineScale3Image.x = currentLinePos.x;
				_lineScale3Image.y = currentLinePos.y;
				_lineScale3Image.pivotY = _lineScale3Image.height / 2;
				var diffvector2d:Vector2D = currentLinePos.subtract(nextLinePos);
				_lineScale3Image.rotation =Math.PI + diffvector2d.angle;
				_lineScale3Image.visible = true;
				_lineScale3Image.textures = new Scale3Textures(SApplication.assets.getTexture(ConstStageLevel.ConstUpgradeLine[int(data.stageLevel)]),2,2);
				
				_lineSTween = new STween(_lineScale3Image, _CONST_LINE_TIME_);
				_lineSTween.animate("width", diffvector2d.length);
				_lineSTween.onComplete = _onLineComplete;
				Starling.juggler.add(_lineSTween);
				
				// 遮罩动画
				_maskAnimation();
			}
			else
			{
				/// 主角升阶信息
				var stageLevelInfo:CJDataOfStageLevel = CJDataManager.o.DataOfStageLevel;
				// 当前激活的武星索引
				var isSend:Boolean = (stageLevelInfo.forceStar % ConstStageLevel.ConstMaxStar) == 0;
				if (isSend)
					_highlightMonsterAnimation();
				
				_onLineComplete();
			}
		}
		
		private function _onLineComplete():void
		{
			Starling.juggler.remove(_lineSTween);
			_lineScale3Image.visible = false;
			_lineScale3Image.width = 0;
			
			_ligatureStarLine();// 更新武星连线
			_lightenForceStar();// 点亮
			_pendingForceStar();// 更新未激活的武星
		}
		
		/** 点亮武星 **/
		private function _lightenForceStar():void
		{
			// 等级
			var stageLevel:int = data.stageLevel;
			// 武星索引
			var forceStar:int = CJDataManager.o.DataOfStageLevel.forceStar;
			var curBtn:Button;
			// 将未激活的星星激活
			var curIndex:uint = getCurStageLevelStarIndex(forceStar);
			curBtn = _vecForceStar[curIndex] as Button;
			Assert( curBtn != null , "curBtn == null");
			
			// 类型
			var jsStageLevel:Json_role_stage_level = CJDataOfStageLevelProperty.o.getData(forceStar.toString());
			curBtn.defaultSkin = _getTexture( true, stageLevel, jsStageLevel.type);
			curBtn.label = "";
		}
		/** 更新未激活的武星 **/
		private function _pendingForceStar():void
		{
			_waitAnimate.visible = false;
			_haloAnimate.visible = false;
			// 当前升级等级
			var stageLevel:uint = uint(data.stageLevel);
			// 武星索引
			var forceStar:int = CJDataManager.o.DataOfStageLevel.forceStar;
			// 需要添加跑马灯效果的按钮引用
			var nextBtn:Button = null;
			
			var pageNum:uint = forceStar/ConstStageLevel.ConstMaxStar + 1;
			pageNum = pageNum > ConstStageLevel.ConstMaxStage ? ConstStageLevel.ConstMaxStage : pageNum
			if (pageNum-1 == index)
			{
				// 将未激活的星星激活
				var curIndex:uint = getCurStageLevelStarIndex(forceStar);
				// 更改要激活按钮的特效位置
				if (curIndex+1 < _vecForceStar.length)
					nextBtn = _vecForceStar[curIndex+1] as Button;
			}
			
//			// 将未激活的星星激活
//			var curIndex:uint = getCurStageLevelStarIndex(forceStar);
//			// 更改要激活按钮的特效位置
//			if (curIndex+1 < _vecForceStar.length)
//				nextBtn = _vecForceStar[curIndex+1] as Button;
			
			// 第一颗星
			if (forceStar % ConstStageLevel.ConstMaxStar == 0 && 
				(forceStar / ConstStageLevel.ConstMaxStar)+1 == stageLevel &&
				forceStar != 0)
					nextBtn = _vecForceStar[0] as Button;
			
			// 未激活任何武星, 特殊处理
			if (forceStar == 0)
				nextBtn = _vecForceStar[0] as Button;
			
			if (nextBtn != null)
			{
				_waitAnimate.visible = true;
				_waitAnimate.x = nextBtn.x;
				_waitAnimate.y = nextBtn.y;
				
				_haloAnimate.visible = true;
				_haloAnimate.x = nextBtn.x;
				_haloAnimate.y = nextBtn.y;
			}
		}
		
		// 通过武星索引获取当前阶的武星 
		// 如 武星25 通过此方法得到的为 5-1
		// 如 武星 30 通过此方法得到的为 10-1 (‘武星30’ 为 21--30 的武星 )
		private function getCurStageLevelStarIndex(forceStar:int):int
		{
			if (forceStar % ConstStageLevel.ConstMaxStar == 0)
			{
				return ConstStageLevel.ConstMaxStar-1;
			}
			
			return (forceStar % ConstStageLevel.ConstMaxStar)-1;
		}
		
		/**
		 * 怪兽高亮动画
		 */
		private function _highlightMonsterAnimation():void
		{
			// 等级
			var stageLevel:int = data.stageLevel;
			// 背景资源替换
			var img:Image = new Image(SApplication.assets.getTexture(ConstStageLevel.ConstStageHighlightMonsterObj[stageLevel]));
			img.alpha = 0;
			img.x = 181;
			img.y = 137;
			img.pivotX = 181/2;
			img.pivotY = 137/2;
			img.scaleX = 2;
			img.scaleY = 2;
			addChild(img);
			
			// 淡出
			var fadeoutTween:STween = new STween( img, _CONST_HIGHLIGHT_FADEIN_TIME_ );
			fadeoutTween.animate("alpha", 0.0);
			fadeoutTween.animate("scaleX", 2.0);
			fadeoutTween.animate("scaleY", 2.0);
			fadeoutTween.onComplete = __onComplete;
			
//			// 从放大到正常
//			var scaleNormalTween:STween = new STween(img, _CONST_HIGHLIGHT_SCALEBIG_TIME_);
//			
//			scaleNormalTween.nextTween = fadeoutTween;
			
//			// 从正常到放大
//			var scaleBigTween:STween = new STween(img, _CONST_HIGHLIGHT_SCALEBIG_TIME_);
//			scaleBigTween.nextTween = scaleNormalTween;
			
			// 淡入
			var fadeinTween:STween = new STween( img, _CONST_HIGHLIGHT_FADEIN_TIME_ );
			fadeinTween.animate("alpha", 1.0);
			fadeinTween.animate("scaleX", 2.10);
			fadeinTween.animate("scaleY", 2.10);
			fadeinTween.nextTween = fadeoutTween;
			Starling.juggler.add(fadeinTween); // 开始播放
			
			function __onComplete():void
			{
				Starling.juggler.remove(fadeinTween);
//				Starling.juggler.remove(scaleBigTween);
//				Starling.juggler.remove(scaleNormalTween);
				Starling.juggler.remove(fadeoutTween);
				fadeinTween = null;
//				scaleBigTween = null;
//				scaleNormalTween = null;
				fadeoutTween = null;
				
				CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_STAGE_LEVEL_UPDATE_PANEL);
			}

		}
		
		/**
		 * 遮罩动画
		 */
		private function _maskAnimation():void
		{
			// 武星索引
			var forceStar:int = CJDataManager.o.DataOfStageLevel.forceStar;
			var curIndex:int = 0;
			// 当前界面武星索引
			if (forceStar%ConstStageLevel.ConstMaxStar !=0 )
				curIndex = getCurStageLevelStarIndex(forceStar);
			
			var perBlockHeight:int = 0;
			var posY:int = 0;
			
			perBlockHeight = ITEM_HEIGHT / ConstStageLevel.ConstMaxStar;
			posY = _maskLayer.y + perBlockHeight;
			// 补间动画
			var tween:STween = new STween( _maskLayer, _CONST_LINE_TIME_ );
			tween.animate("y", posY);
			Starling.juggler.add(tween); // 开始播放
			tween.onComplete = __onComplete;
			
			function __onComplete():void
			{
				Starling.juggler.remove(tween);
				tween = null;
				
				_isPlaying = false; // 播放结束
				owner.touchable = true;
			}
		}
		
		/**
		 * 更新遮罩
		 */
		private function _updateMask():void
		{
			// 武星索引
			var forceStar:int = CJDataManager.o.DataOfStageLevel.forceStar;
			
			var pageNum:uint = forceStar/ConstStageLevel.ConstMaxStar + 1;
			pageNum = pageNum > ConstStageLevel.ConstMaxStage ? ConstStageLevel.ConstMaxStage : pageNum;
			
			if (pageNum-1 == index)
			{
				var curIndex:int = 0;
				// 当前界面武星索引
				if (forceStar%ConstStageLevel.ConstMaxStar !=0 )
					curIndex = getCurStageLevelStarIndex(forceStar);
				
				var perBlockHeight:int = 0;
				var posY:int = 0;
				
				if (curIndex != 0)
					perBlockHeight = ITEM_HEIGHT / ConstStageLevel.ConstMaxStar;

				posY = perBlockHeight * curIndex;
				
				if (forceStar == ConstStageLevel.ConstMaxStar*ConstStageLevel.ConstMaxStage)
					_UpdateMaskPos(ITEM_HEIGHT);
				else
					_UpdateMaskPos(posY);
			}
			else
				_UpdateMaskPos(ITEM_HEIGHT);
		}
		
		/**
		 * 更新遮罩位置
		 * @param y	整个遮罩最下端位置
		 * 
		 */
		private function _UpdateMaskPos(posY:int):void
		{
			_shade.y = posY - _SHADE_HEIGHT_ - 2;
			_quad.y = posY - _SHADE_HEIGHT_ - ITEM_HEIGHT;
		}
		
		public function get data():Object
		{
			return this._data;
		}
		
		public function set data(value:Object):void
		{
			this._data = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		public function get index():int
		{
			return this._index;
		}
		
		public function set index(value:int):void
		{
			this._index = value;
		}
		
		public function get owner():List
		{
			return this._owner;
		}
		
		public function set owner(value:List):void
		{
			this._owner = value;
		}
		public function get isSelected():Boolean
		{
			return _isSelected;
		}
		
		public function set isSelected(value:Boolean):void
		{
			_isSelected = value;
		}
	}
}