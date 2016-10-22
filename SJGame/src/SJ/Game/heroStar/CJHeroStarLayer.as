package SJ.Game.heroStar
{
	import flash.filters.ConvolutionFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import SJ.Common.Constants.ConstBag;
	import SJ.Common.Constants.ConstHero;
	import SJ.Common.Constants.ConstMainUI;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstResource;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.SocketServer.SocketCommand_hero;
	import SJ.Game.SocketServer.SocketCommand_herostar;
	import SJ.Game.SocketServer.SocketCommand_item;
	import SJ.Game.SocketServer.SocketCommand_role;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.activity.CJActivityEventKey;
	import SJ.Game.bag.CJBagItem;
	import SJ.Game.controls.CJHeartbeatEffectUtil;
	import SJ.Game.controls.CJPanelFrame;
	import SJ.Game.controls.CJPanelTitle;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfBag;
	import SJ.Game.data.CJDataOfHero;
	import SJ.Game.data.CJDataOfHeroList;
	import SJ.Game.data.CJDataOfHeroStar;
	import SJ.Game.data.config.CJDataOfHeroStarProperty;
	import SJ.Game.data.config.CJDataOfItemProperty;
	import SJ.Game.data.config.CJDataOfPSkillProperty;
	import SJ.Game.data.config.CJDataOfSkillPropertyList;
	import SJ.Game.data.json.Json_hero_star_config;
	import SJ.Game.data.json.Json_item_setting;
	import SJ.Game.data.json.Json_pskill_setting;
	import SJ.Game.data.json.Json_skill_setting;
	import SJ.Game.enhanceequip.CJEnhanceLayerStar;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJMessageBox;
	import SJ.Game.player.CJPlayerData;
	import SJ.Game.player.CJPlayerNpc;
	import SJ.Game.player.CJPlayerTitleLayer;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.Events.DataEvent;
	import engine_starling.display.SAnimate;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.SStringUtils;
	import engine_starling.utils.STween;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.controls.ProgressBar;
	import feathers.controls.ScrollText;
	import feathers.display.Scale3Image;
	import feathers.display.Scale9Image;
	import feathers.display.TiledImage;
	import feathers.textures.Scale3Textures;
	import feathers.textures.Scale9Textures;
	
	import lib.engine.utils.functions.Assert;
	
	import starling.animation.Juggler;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	/**
	 * 武将星级显示层
	 * @author longtao
	 * 
	 */
	public class CJHeroStarLayer extends SLayer
	{
		private var _heroHeadPos:Label;
		/**  武将头像选择面板位置 **/
		public function get heroHeadPos():Label
		{
			return _heroHeadPos;
		}
		/** @private **/
		public function set heroHeadPos(value:Label):void
		{
			_heroHeadPos = value;
		}
		private var _herostarLayer:ImageLoader;
		/**  星级显示面板 **/
		public function get herostarLayer():ImageLoader
		{
			return _herostarLayer;
		}
		/** @private **/
		public function set herostarLayer(value:ImageLoader):void
		{
			_herostarLayer = value;
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
		private var _heroLevel:Label;
		/**  武将等级 **/
		public function get heroLevel():Label
		{
			return _heroLevel;
		}
		/** @private **/
		public function set heroLevel(value:Label):void
		{
			_heroLevel = value;
		}
		private var _heroBGPos:Label;
		/**  武将背景符文位置 **/
		public function get heroBGPos():Label
		{
			return _heroBGPos;
		}
		/** @private **/
		public function set heroBGPos(value:Label):void
		{
			_heroBGPos = value;
		}
		private var _heroStarPos:Label;
		/**  武将当前星级位置 **/
		public function get heroStarPos():Label
		{
			return _heroStarPos;
		}
		/** @private **/
		public function set heroStarPos(value:Label):void
		{
			_heroStarPos = value;
		}
		private var _heroIdlePos:Label;
		/**  武将展示位置 **/
		public function get heroIdlePos():Label
		{
			return _heroIdlePos;
		}
		/** @private **/
		public function set heroIdlePos(value:Label):void
		{
			_heroIdlePos = value;
		}
		private var _imgBlessing:ImageLoader;
		/**  祝福值 **/
		public function get imgBlessing():ImageLoader
		{
			return _imgBlessing;
		}
		/** @private **/
		public function set imgBlessing(value:ImageLoader):void
		{
			_imgBlessing = value;
		}
		private var _imgBlessingBG:ImageLoader;
		/**  祝福值进度条底 **/
		public function get imgBlessingBG():ImageLoader
		{
			return _imgBlessingBG;
		}
		/** @private **/
		public function set imgBlessingBG(value:ImageLoader):void
		{
			_imgBlessingBG = value;
		}
		private var _btnPrompt:Button;
		/**  提示按钮 **/
		public function get btnPrompt():Button
		{
			return _btnPrompt;
		}
		/** @private **/
		public function set btnPrompt(value:Button):void
		{
			_btnPrompt = value;
		}
		private var _materialLayer:SLayer;
		/**  展示材料图层 **/
		public function get materialLayer():SLayer
		{
			return _materialLayer;
		}
		/** @private **/
		public function set materialLayer(value:SLayer):void
		{
			_materialLayer = value;
		}
		private var _materialBGLayer:SLayer;
		/**  展示材料背景图层 **/
		public function get materialBGLayer():SLayer
		{
			return _materialBGLayer;
		}
		/** @private **/
		public function set materialBGLayer(value:SLayer):void
		{
			_materialBGLayer = value;
		}
		private var _materialConsumeLabel:Label;
		/**  材料消耗文字说明 **/
		public function get materialConsumeLabel():Label
		{
			return _materialConsumeLabel;
		}
		/** @private **/
		public function set materialConsumeLabel(value:Label):void
		{
			_materialConsumeLabel = value;
		}
		private var _materialPos:Label;
		/**  材料Icon位置 **/
		public function get materialPos():Label
		{
			return _materialPos;
		}
		/** @private **/
		public function set materialPos(value:Label):void
		{
			_materialPos = value;
		}
		private var _materialCount:Label;
		/**  材料数量位置 **/
		public function get materialCount():Label
		{
			return _materialCount;
		}
		/** @private **/
		public function set materialCount(value:Label):void
		{
			_materialCount = value;
		}
		private var _materialName:Label;
		/**  材料名称 **/
		public function get materialName():Label
		{
			return _materialName;
		}
		/** @private **/
		public function set materialName(value:Label):void
		{
			_materialName = value;
		}
		private var _btnUpgrade:Button;
		/**  升星按钮 **/
		public function get btnUpgrade():Button
		{
			return _btnUpgrade;
		}
		/** @private **/
		public function set btnUpgrade(value:Button):void
		{
			_btnUpgrade = value;
		}
		private var _consumeLabel:Label;
		/**  消耗文字说明 **/
		public function get consumeLabel():Label
		{
			return _consumeLabel;
		}
		/** @private **/
		public function set consumeLabel(value:Label):void
		{
			_consumeLabel = value;
		}
		private var _consumeCount:Label;
		/**  消耗数量 **/
		public function get consumeCount():Label
		{
			return _consumeCount;
		}
		/** @private **/
		public function set consumeCount(value:Label):void
		{
			_consumeCount = value;
		}
		private var _btnGoldUpgrade:Button;
		/**  元宝升星按钮 **/
		public function get btnGoldUpgrade():Button
		{
			return _btnGoldUpgrade;
		}
		/** @private **/
		public function set btnGoldUpgrade(value:Button):void
		{
			_btnGoldUpgrade = value;
		}
		private var _nextHerostarLayer:ImageLoader;
		/**  下级升星效果面板 **/
		public function get nextHerostarLayer():ImageLoader
		{
			return _nextHerostarLayer;
		}
		/** @private **/
		public function set nextHerostarLayer(value:ImageLoader):void
		{
			_nextHerostarLayer = value;
		}
		private var _curStarLabel:Label;
		/**  当前星效果 **/
		public function get curStarLabel():Label
		{
			return _curStarLabel;
		}
		/** @private **/
		public function set curStarLabel(value:Label):void
		{
			_curStarLabel = value;
		}
		private var _curHeroStarPos:Label;
		/**  武将当前星级位置 **/
		public function get curHeroStarPos():Label
		{
			return _curHeroStarPos;
		}
		/** @private **/
		public function set curHeroStarPos(value:Label):void
		{
			_curHeroStarPos = value;
		}
		private var _curHeroStarDesLabel:Label;
		/**  武将当前星级描述 **/
		public function get curHeroStarDesLabel():Label
		{
			return _curHeroStarDesLabel;
		}
		/** @private **/
		public function set curHeroStarDesLabel(value:Label):void
		{
			_curHeroStarDesLabel = value;
		}
		private var _nextStarLabel:Label;
		/**  下级星效果 **/
		public function get nextStarLabel():Label
		{
			return _nextStarLabel;
		}
		/** @private **/
		public function set nextStarLabel(value:Label):void
		{
			_nextStarLabel = value;
		}
		private var _nextHeroStarPos:Label;
		/**  武将下级星级位置 **/
		public function get nextHeroStarPos():Label
		{
			return _nextHeroStarPos;
		}
		/** @private **/
		public function set nextHeroStarPos(value:Label):void
		{
			_nextHeroStarPos = value;
		}
		private var _nextHeroStarDesLabel:Label;
		/**  武将下级星级描述 **/
		public function get nextHeroStarDesLabel():Label
		{
			return _nextHeroStarDesLabel;
		}
		/** @private **/
		public function set nextHeroStarDesLabel(value:Label):void
		{
			_nextHeroStarDesLabel = value;
		}
		private var _labelTitle:Label;
		/**  标题Label **/
		public function get labelTitle():Label
		{
			return _labelTitle;
		}
		/** @private **/
		public function set labelTitle(value:Label):void
		{
			_labelTitle = value;
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
		private var _noteLayer:SLayer;
		/**  提示图层 **/
		public function get noteLayer():SLayer
		{
			return _noteLayer;
		}
		/** @private **/
		public function set noteLayer(value:SLayer):void
		{
			_noteLayer = value;
		}
		private var _noteLayerBG:ImageLoader;
		/**  提示图层底 **/
		public function get noteLayerBG():ImageLoader
		{
			return _noteLayerBG;
		}
		/** @private **/
		public function set noteLayerBG(value:ImageLoader):void
		{
			_noteLayerBG = value;
		}
		private var _noteLayerFrame:ImageLoader;
		/**  提示图层内边框 **/
		public function get noteLayerFrame():ImageLoader
		{
			return _noteLayerFrame;
		}
		/** @private **/
		public function set noteLayerFrame(value:ImageLoader):void
		{
			_noteLayerFrame = value;
		}
		private var _noteLabel:Label;
		/**  提示文字 **/
		public function get noteLabel():Label
		{
			return _noteLabel;
		}
		/** @private **/
		public function set noteLabel(value:Label):void
		{
			_noteLabel = value;
		}
		private var _btnNoteLayerClose:Button;
		/**  提示图层关闭界面 **/
		public function get btnNoteLayerClose():Button
		{
			return _btnNoteLayerClose;
		}
		/** @private **/
		public function set btnNoteLayerClose(value:Button):void
		{
			_btnNoteLayerClose = value;
		}

		
		
		/** 升星类型 --材料升星 **/
		private static const _CONST_UPGRADE_TYPE_MATERIAL_:String = "1";
		/** 升星类型 --元宝升星 **/
		private static const _CONST_UPGRADE_TYPE_GOLD_:String = "2";
		
		
		
		/** 武将头像选择面板 **/
		private var _heroStarHeadLayer:CJHeroStarHeadLayer;
		/** 武将名称 **/
		private var _heroNameTF:TextField;
		/** 武将空闲动画显示层 **/
		private var _heroIdleLayer:SLayer;
		/**武将空闲动画*/
		private var _animate_hero:CJPlayerNpc;
		/** 进度条背景框 **/
		private var _progressBarBG:Scale3Image;
		/** 祝福值进度条 **/
		private var _progressBar:ProgressBar;
		/** 材料显示 **/
		private var _bagItem:CJBagItem;
		/** 标头星级显示 **/
		private var _headStarLevel:CJEnhanceLayerStar;
		/** 当前星级显示 **/
		private var _curStarLevel:CJEnhanceLayerStar;
		/** 下一星级显示 **/
		private var _nextStarLevel:CJEnhanceLayerStar;
		/** 当前武将id **/
		private var _curheroid:String;
		/** 面板锁 **/
		private var _isLock:Boolean = false;
		/** 祝福值文字(计分板效果) **/
		private var _blessingScoreBoard:CJScoreBoard;
		private var _fireAnimate:SAnimate;
		
		/** 标题 **/
		private var _title:CJPanelTitle;
		
		
		/** 旋转时间  单位秒 **/
		private const _CONST_ROTATION_TIME_:Number = 20;
		/** 武将背后旋转符文 **/
		private var _heroRuneBG:ImageLoader;
		/** 补间动画 **/
		private var _heroRuneST:STween;
		
		/** 限制品质  该品质也为不可进行升星 **/
		private static const _CONST_LIMIT_QUALITY_:uint = 2;
		
		private var _startheroid:String;
		/** 启示武将id **/
		public function get startheroid():String
		{ return _startheroid; }
		/** @private **/
		public function set startheroid(value:String):void
		{ _startheroid = value; }
		
		/** 升级特效 **/
		private var _upgradedragon:SAnimate;
		/** 脚下发光特效 **/
		private var _footshine:SAnimate;
		/** 特效渐隐 **/
		private var _upgradeFadeOut:STween;
		
		/** 武将满星后隐藏的layer **/
		private var _hideLayer:SLayer;

		private var scroTxt:ScrollText;
		
		public function CJHeroStarLayer()
		{
			super();
		}
		
		override public function dispose():void
		{
			if (_fireAnimate)
				_fireAnimate.removeEventListener(Event.COMPLETE, _fireComplete);
			if (_upgradedragon)
				_upgradedragon.removeEventListener(Event.COMPLETE, _upgradeComplete);
			super.dispose();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			this.width = ConstMainUI.MAPUNIT_WIDTH;
			this.height = ConstMainUI.MAPUNIT_HEIGHT;
			
			_title = new CJPanelTitle(CJLang("HEROSTAR_TITEL"));
			addChild(_title);
			_title.x = labelTitle.x;
			_title.y = labelTitle.y;
			
			// 层级
			var tierIndex:int = 0;
			// 底
			var texture:Texture;
			var scale9Texture:Scale9Textures;
			var bg:Scale9Image;
			// 
			var img:ImageLoader;
			//
//			var simg:SImage;
			texture = SApplication.assets.getTexture("common_dinew");
			scale9Texture = new Scale9Textures(texture, new Rectangle(1,1 ,2,2));
			bg = new Scale9Image(scale9Texture);
			bg.x = 0;
			bg.y = 0;
			bg.width = width;
			bg.height = height;
			addChildAt(bg, tierIndex++);
			
			texture = SApplication.assets.getTexture("common_dinewzhezhao");
			scale9Texture = new Scale9Textures(texture, new Rectangle(43,43,2,2));
			bg = new Scale9Image(scale9Texture);
			bg.width = this.width;
			bg.height = this.height;
			addChildAt(bg, tierIndex++);
			
			
			var img1:TiledImage = new TiledImage(SApplication.assets.getTexture("common_quanpingtoubudi"));
			img1.width = SApplicationConfig.o.stageWidth;
			img1.x = 0;
			img1.y = 5;
			addChildAt(img1, tierIndex++);
			
			// 边框
			texture = SApplication.assets.getTexture("common_quanpingzhuangshi");
			scale9Texture = new Scale9Textures(texture, new Rectangle(14,13 ,2,2));
			bg = new Scale9Image(scale9Texture);
			bg.width = this.width;
			bg.height = this.height;
			addChildAt(bg, tierIndex++);
			
			// 关闭按钮纹理
			btnClose.defaultSkin = new SImage( SApplication.assets.getTexture("common_quanpingguanbianniu01") );
			btnClose.downSkin = new SImage( SApplication.assets.getTexture("common_quanpingguanbianniu02") );
			btnClose.addEventListener(Event.TRIGGERED, function(e:Event):void{
				SApplication.moduleManager.exitModule("CJHeroStarModule");
			});
			
			// 星级左侧显名称框
			texture = SApplication.assets.getTexture("common_wujiangxuanzedi");
			scale9Texture = new Scale9Textures(texture, new Rectangle(13,11 ,2,6));
			bg = new Scale9Image(scale9Texture);
			bg.x = heroHeadPos.x;
			bg.y = heroHeadPos.y - 20;
			bg.width = heroHeadPos.width;
			bg.height = heroHeadPos.height + 35;
			addChildAt(bg, tierIndex++);
			
			// 星级显示面板内底
			texture = SApplication.assets.getTexture("common_dinew");
			scale9Texture = new Scale9Textures(texture, new Rectangle(1,1 ,2,2));
			bg = new Scale9Image(scale9Texture);
			bg.x = herostarLayer.x + 2;
			bg.y = herostarLayer.y + 2;
			bg.width = herostarLayer.width - 4;
			bg.height = herostarLayer.height - 4;
			addChildAt(bg, tierIndex++);
			
			// 花纹框
			var frame:CJPanelFrame = new CJPanelFrame(width, height);
			frame.x = 0;
			frame.y = 0;
			frame.touchable = false;
			addChildAt(frame, tierIndex++);
			
			texture = SApplication.assets.getTexture("common_dinewzhezhao");
			scale9Texture = new Scale9Textures(texture, new Rectangle(43,43,2,2));
			bg = new Scale9Image(scale9Texture);
			bg.x = herostarLayer.x + 2;
			bg.y = herostarLayer.y + 2;
			bg.width = herostarLayer.width - 4;
			bg.height = herostarLayer.height - 4;
			addChildAt(bg, tierIndex++);
			
			// 星级显示面板
			texture = SApplication.assets.getTexture("common_waikuangnew");
			scale9Texture = new Scale9Textures(texture, new Rectangle(15 , 15 , 1, 1));
			bg = new Scale9Image(scale9Texture);
			bg.x = herostarLayer.x;
			bg.y = herostarLayer.y;
			bg.width = herostarLayer.width;
			bg.height = herostarLayer.height;
			addChildAt(bg, tierIndex++);

			// 武将名字
			_heroNameTF = new TextField(15, 60, "");
			_heroNameTF.fontName = ConstTextFormat.FONT_FAMILY_LISHU;
			_heroNameTF.x = heroName.x;
			_heroNameTF.y = heroName.y;
			_textStroke(_heroNameTF);
			addChild(_heroNameTF);
			// 名称左右修饰缝隙
			img = new ImageLoader;
			img.source = SApplication.assets.getTexture("common_fengexian02");
			img.x = _heroNameTF.x-3;
			img.y = _heroNameTF.y;
			img.height = heroName.height;
			addChild(img);
			img = new ImageLoader;
			img.source = SApplication.assets.getTexture("common_fengexian02");
			img.x = _heroNameTF.x+_heroNameTF.width;
			img.y = _heroNameTF.y;
			img.height = heroName.height;
			addChild(img);
			
			// 设置武将等级的字体
			heroLevel.textRendererProperties.textFormat = ConstTextFormat.textformatyellow;
			
			
			// 武将符文背景框
			_heroRuneBG = new ImageLoader;
			_heroRuneBG.source = SApplication.assets.getTexture("zuoqi_dibuyuanquan");
			_heroRuneBG.x = heroBGPos.x;
			_heroRuneBG.y = heroBGPos.y;
			_heroRuneBG.width = 130;
			_heroRuneBG.pivotX = 64;
			_heroRuneBG.pivotY = 63;
			addChild(_heroRuneBG);
			// 旋转
			_heroRuneST = new STween( _heroRuneBG, _CONST_ROTATION_TIME_);
			_heroRuneST.animate("rotation", 2*Math.PI);
			_heroRuneST.loop = 1;
			
			// 当前星级
			_headStarLevel = new CJEnhanceLayerStar;
			_headStarLevel.count = ConstHero.ConstMaxHeroStarLevel;
			_headStarLevel.initLayer();
			_headStarLevel.x = heroStarPos.x;
			_headStarLevel.y = heroStarPos.y;
			_headStarLevel.width = 170;
			_headStarLevel.height=17;
			addChild(_headStarLevel);
			
			/// 武将展示位置以及底盘
			img = new ImageLoader;
			img.source = SApplication.assets.getTexture("common_dizuo");
			img.pivotX = 69;
			img.pivotY = 12;
			img.x = heroIdlePos.x;
			img.y = heroIdlePos.y;
			addChild(img);
			_heroIdleLayer = new SLayer;
			addChild(_heroIdleLayer);
			
			// 需要隐藏的界面
			_hideLayer = new SLayer;
			addChild(_hideLayer);
			
			// 祝福值进度条底框
			var scale3texture:Scale3Textures = new Scale3Textures(SApplication.assets.getTexture("herostar_jindutiaokuang"), 38, 6);
			_progressBarBG = new Scale3Image(scale3texture);
			_progressBarBG.width = imgBlessingBG.width;
			_progressBarBG.x = imgBlessingBG.x;
			_progressBarBG.y = imgBlessingBG.y;
			addChild(_progressBarBG);
			// 祝福值伸缩部分
			scale3texture = new Scale3Textures(SApplication.assets.getTexture("wujiang_jingyantiao1"),2,1);
			var fillSkin:Scale3Image = new Scale3Image(scale3texture);
			_progressBar = new ProgressBar();
			_progressBar.fillSkin = fillSkin;
			_progressBar.x = imgBlessingBG.x+32;
			_progressBar.y = imgBlessingBG.y+9;
			_progressBar.width = imgBlessingBG.width-32*2;
			_progressBar.height = imgBlessingBG.height-17;
			addChild(_progressBar);
			_progressBar.validate();
			// 火焰
			var animObject:Object = AssetManagerUtil.o.getObject("anim_herostar_fire");
			if (animObject!=null)
			{
				_fireAnimate =SAnimate.SAnimateFromAnimJsonObject(animObject);
				_fireAnimate.x = imgBlessingBG.x-12;
				_fireAnimate.y = imgBlessingBG.y-50;
				_fireAnimate.loop = false;
				_fireAnimate.visible = false;
				_fireAnimate.touchable = false;
				// 添加监听
				_fireAnimate.addEventListener(Event.COMPLETE, _fireComplete);
				addChild(_fireAnimate);
			}
			// 升级特效
			_upgradedragon = new SAnimate(SApplication.assets.getTextures(ConstResource.sResUplevelAnims));
			_upgradedragon.x = heroIdlePos.x;
			_upgradedragon.y = heroIdlePos.y;
			_upgradedragon.pivotY = 110;
			_upgradedragon.pivotX = 80;
			_upgradedragon.scaleX = _upgradedragon.scaleY = 1.5;
			_upgradedragon.loop = false;
			_upgradedragon.visible = false;
			_upgradedragon.touchable = false;
			// 添加监听
			_upgradedragon.addEventListener(Event.COMPLETE, _upgradeComplete);
			addChild(_upgradedragon);
			// 脚下特效
			animObject = AssetManagerUtil.o.getObject("anim_stagelevel_change");
			if (null != animObject)
			{
				_footshine =SAnimate.SAnimateFromAnimJsonObject(animObject);
				_footshine.x = heroIdlePos.x;
				_footshine.y = heroIdlePos.y;
				_footshine.loop = false;
				_footshine.visible = false;
				_footshine.touchable = false;
				addChild(_footshine);
			}
			
			
			// 祝福值计分板数字
			_blessingScoreBoard = new CJScoreBoard(4, CJScoreBoard.ALIGN_CENTER);
			_blessingScoreBoard.x = imgBlessingBG.x+80;
			_blessingScoreBoard.y = imgBlessingBG.y;
			addChild(_blessingScoreBoard);
			
			
			// 消耗BG
//			var timg:Image = new Image(SApplication.assets.getTexture("wujiangshengxing_dibuyinying"));
//			timg.x = 30;
//			timg.y = 233;
//			timg.width = 450;
//			timg.height = 73;
//			materialBGLayer.addChild(timg);
			texture = SApplication.assets.getTexture("baoshi_hechengyoucedi");
			scale9Texture = new Scale9Textures(texture, new Rectangle(18,18 ,1,1)); // 63, 66, 2, 2
			bg = new Scale9Image(scale9Texture);
			bg.x = 90;
			bg.y = 233;
			bg.width = 385;
			bg.height = 73;
			materialBGLayer.addChild(bg);
			// 消耗文字
			materialConsumeLabel.textRendererProperties.textFormat = ConstTextFormat.textformatkhaki;
			materialConsumeLabel.text = CJLang("HEROSTAR_CONSUME");
			// 材料展示
			_bagItem = new CJBagItem(ConstBag.FrameCreateStateUnlock);
			_bagItem.x = materialPos.x;
			_bagItem.y = materialPos.y;
			_bagItem.width = ConstBag.BAG_ITEM_WIDTH;
			_bagItem.height = ConstBag.BAG_ITEM_HEIGHT;
			materialLayer.addChild(_bagItem);
			// 材料数量
			materialLayer.addChild(materialCount);
			
			// 升星按钮
			btnUpgrade.defaultSkin = new SImage( SApplication.assets.getTexture("common_anniuda01new") );
			btnUpgrade.downSkin = new SImage( SApplication.assets.getTexture("common_anniuda02new") );
			btnUpgrade.disabledSkin = new SImage( SApplication.assets.getTexture("common_anniuda03new") );
			btnUpgrade.addEventListener(Event.TRIGGERED, _touchUpgrade);
			btnUpgrade.defaultLabelProperties.textFormat = ConstTextFormat.textformat;
			btnUpgrade.label = CJLang("HEROSTAR_BTN_UPGRADE");

			// 消耗文字说明
			consumeLabel.textRendererProperties.textFormat = ConstTextFormat.textformat;
			consumeLabel.text = CJLang("HEROSTAR_CONSUME");
			// 消耗元宝数量
			consumeCount.textRendererProperties.textFormat = ConstTextFormat.textformatkhaki;
			// 元宝升星按钮
			btnGoldUpgrade.defaultSkin = new SImage( SApplication.assets.getTexture("common_anniuda01new") );
			btnGoldUpgrade.downSkin = new SImage( SApplication.assets.getTexture("common_anniuda02new") );
			btnGoldUpgrade.disabledSkin = new SImage( SApplication.assets.getTexture("common_anniuda03new") );
			btnGoldUpgrade.addEventListener(Event.TRIGGERED, _clickGoldUpgrade);
			btnGoldUpgrade.defaultLabelProperties.textFormat = ConstTextFormat.textformat;
			btnGoldUpgrade.label = CJLang("HEROSTAR_BTN_GOLD_UPGRADE");
			
			
			
			
			// 下级星级界面
			texture = SApplication.assets.getTexture("baoshi_hechengyoucedi");
			scale9Texture = new Scale9Textures(texture, new Rectangle(18,18 ,1,1)); // 63, 66, 2, 2
			bg = new Scale9Image(scale9Texture);
			bg.x = nextHerostarLayer.x;
			bg.y = nextHerostarLayer.y;
			bg.width = nextHerostarLayer.width;
			bg.height = nextHerostarLayer.height;
			addChildAt(bg, tierIndex++);
			
			// 当前星级星星
			_curStarLevel = new CJEnhanceLayerStar;
			_curStarLevel.count = ConstHero.ConstMaxHeroStarLevel;
//			_curStarLevel.isShowDarkStar = false;
			_curStarLevel.initLayer();
			_curStarLevel.x = curHeroStarPos.x;
			_curStarLevel.y = curHeroStarPos.y;
			_curStarLevel.width = 170;
			_curStarLevel.height=17;
			addChild(_curStarLevel);
			// 当前星级效果文字
			curStarLabel.textRendererProperties.textFormat = ConstTextFormat.textformatkhaki;
			curStarLabel.text = CJLang("HEROSTAR_CUR_EFFECT");
			// 当前星级描述
			curHeroStarDesLabel.textRendererProperties.textFormat = ConstTextFormat.textformatkhaki;
			curHeroStarDesLabel.textRendererProperties.multiline = true; // 可显示多行
			curHeroStarDesLabel.textRendererProperties.wordWrap = true; // 可自动换行
			
			// 下级星级星星
			_nextStarLevel = new CJEnhanceLayerStar;
			_nextStarLevel.count = ConstHero.ConstMaxHeroStarLevel;
//			_nextStarLevel.isShowDarkStar = false;
			_nextStarLevel.initLayer();
			_nextStarLevel.x = nextHeroStarPos.x;
			_nextStarLevel.y = nextHeroStarPos.y;
			_nextStarLevel.width = 170;
			_nextStarLevel.height=17;
			addChild(_nextStarLevel);
			// 下级星级效果文字
			nextStarLabel.textRendererProperties.textFormat = ConstTextFormat.textformatkhaki;
			nextStarLabel.text = CJLang("HEROSTAR_NEXT_EFFECT");
			// 下级星级描述
			nextHeroStarDesLabel.textRendererProperties.textFormat = ConstTextFormat.textformatkhaki;
			nextHeroStarDesLabel.textRendererProperties.multiline = true; // 可显示多行
			nextHeroStarDesLabel.textRendererProperties.wordWrap = true; // 可自动换行
			
			// 提示按钮
			btnPrompt.defaultSkin = new SImage( SApplication.assets.getTexture("wujiangshengxing_tishi") );
			btnPrompt.downSkin = new SImage( SApplication.assets.getTexture("wujiangshengxing_tishi") );
			btnPrompt.addEventListener(Event.TRIGGERED, function(e:Event):void{
				noteLayer.visible = true;
				scroTxt.text = CJLang("HEROSTAR_NOTE");
			});
			btnPrompt.defaultLabelProperties.textFormat = ConstTextFormat.textformat;
			btnPrompt.label = CJLang("HEROSTAR_BTN_PROMPT");
			
			
			// 祝福值提示框
			noteLayer.visible = false; // 默认不显示
			addChild(noteLayer);
//			// 关闭祝福值提示框按钮
//			btnNoteLayerClose.defaultSkin = new SImage( SApplication.assets.getTexture("common_guanbianniu01new") );
//			btnNoteLayerClose.downSkin = new SImage( SApplication.assets.getTexture("common_guanbianniu02new") );
//			btnNoteLayerClose.addEventListener(Event.TRIGGERED, function(e:Event):void{
//				noteLayer.visible = false;
//			});
			
			tierIndex = 0;
			// 祝福值提示底
			texture = SApplication.assets.getTexture("common_dinew");
			scale9Texture = new Scale9Textures(texture, new Rectangle(1,1 ,2,2));
			bg = new Scale9Image(scale9Texture);
			bg.x = noteLayerBG.x;
			bg.y = noteLayerBG.y;
			bg.width = noteLayerBG.width;
			bg.height = noteLayerBG.height;
			noteLayer.addChildAt(bg, tierIndex++);
			// 罩子
			texture = SApplication.assets.getTexture("common_dinewzhezhao");
			scale9Texture = new Scale9Textures(texture, new Rectangle(43,43,2,2));
			bg = new Scale9Image(scale9Texture);
			bg.x = noteLayerBG.x;
			bg.y = noteLayerBG.y;
			bg.width = noteLayerBG.width;
			bg.height = noteLayerBG.height;
			noteLayer.addChildAt(bg, tierIndex++);
			// 祝福值提示内框
			frame = new CJPanelFrame(noteLayerFrame.width, noteLayerFrame.height);
			frame.x = noteLayerFrame.x;
			frame.y = noteLayerFrame.y;
			frame.touchable = false;
			noteLayer.addChildAt(frame, tierIndex++);
			// 祝福值外边框
			texture = SApplication.assets.getTexture("common_waikuangnew");
			scale9Texture = new Scale9Textures(texture, new Rectangle(15 , 15 , 1, 1));
			bg = new Scale9Image(scale9Texture);
			bg.x = noteLayerBG.x;
			bg.y = noteLayerBG.y;
			bg.width = noteLayerBG.width;
			bg.height = noteLayerBG.height;
			noteLayer.addChildAt(bg, tierIndex++);
			
//			texture = SApplication.assets.getTexture("common_quanpingzhuangshidi");
//			scale9Texture = new Scale9Textures(texture, new Rectangle(15, 13, 1, 1));
//			bg = new Scale9Image(scale9Texture);
//			bg.x = noteLayerFrame.x;
//			bg.y = noteLayerFrame.y;
//			bg.width = noteLayerFrame.width;
//			bg.height = noteLayerFrame.height;
//			noteLayer.addChildAt(bg, 1);
			// 祝福值提示文字
//			noteLabel.textRendererProperties.textFormat = ConstTextFormat.textformatwhite;
//			noteLabel.textRendererProperties.multiline = true; // 可显示多行
//			noteLabel.textRendererProperties.wordWrap = true; // 自动换行
//			noteLabel.text = CJLang("HEROSTAR_NOTE");
			
			scroTxt = new ScrollText();
			scroTxt.width = noteLabel.width;
			scroTxt.height = noteLabel.height;
			scroTxt.x = noteLabel.x;
			scroTxt.y = noteLabel.y;
			scroTxt.textFormat = ConstTextFormat.textformatwhite;
			noteLayer.addChild(scroTxt);
			
			// 添加点击事件
			addEventListener(TouchEvent.TOUCH, _touchHandler);
			
			/// 武将< heroid, heroInfo >
			var heroList:CJDataOfHeroList = CJDataManager.o.DataOfHeroList;
			if(heroList.dataIsEmpty)
			{
				heroList.addEventListener(DataEvent.DataLoadedFromRemote , _doInit);
				heroList.loadFromRemote();
			}
			
			// 背包道具
			var bagData:CJDataOfBag = CJDataManager.o.DataOfBag;
			if (bagData.dataIsEmpty)
			{
				bagData.addEventListener(DataEvent.DataLoadedFromRemote , _doInit);
				bagData.loadFromRemote();
			}
			
			// 武将星级信息
			var herostar:CJDataOfHeroStar = CJDataManager.o.DataOfHeroStar;
			herostar.clearAll()
			if (herostar.dataIsEmpty)
			{
				herostar.addEventListener(DataEvent.DataLoadedFromRemote , _doInit);
				herostar.loadFromRemote();
			}
			// 初始化数据
			_doInit();
			
			//处理指引
			if(CJDataManager.o.DataOfFuncList.isIndicating)
			{
				CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_INDICATE_NEXT_STEP);
			}
			
			
			// --------------- 武将满星后 需要隐藏的元素 --------------- \\
			// 祝福值 三个字图片
			_hideLayer.addChild(imgBlessing);
			// 进度条背景框
			_hideLayer.addChild(_progressBarBG);
			/// 进度条
			_hideLayer.addChild(_progressBar);
			// 祝福值文字(计分板效果)
			_hideLayer.addChild(_blessingScoreBoard);
			// 提示按钮
			_hideLayer.addChild(btnPrompt);
			// 材料
			_hideLayer.addChild(materialLayer);
			// 升星按钮不可按
			_hideLayer.addChild(btnUpgrade);
			// 下级升星效果
			_hideLayer.addChild(nextStarLabel);
			// 下一星级显示
			_hideLayer.addChild(_nextStarLevel);
			// 武将下级星级描述
			_hideLayer.addChild(nextHeroStarDesLabel);
			// --------------- 武将满星后 需要隐藏的元素  end --------------- \\
		}
		
		private function _textStroke(tf:TextField):void
		{
			var matrix:Array = [0,1,0,
				1,1,1,
				0,1,0];
			tf.nativeFilters = [new ConvolutionFilter(3,3,matrix,3),
				new GlowFilter(0x000000,1.0,2.0,2.0,5,2)];
		}
		
		// 数据加载完成
		private function _doInit():void
		{
			// 武将列表
			var heroList:CJDataOfHeroList = CJDataManager.o.DataOfHeroList;
			// 背包道具
			var bagData:CJDataOfBag = CJDataManager.o.DataOfBag;
			// 武将星级信息
			var herostar:CJDataOfHeroStar = CJDataManager.o.DataOfHeroStar;
			if(heroList.dataIsEmpty || bagData.dataIsEmpty || herostar.dataIsEmpty)
				return;
			
			// 移除监听
			heroList.removeEventListener(DataEvent.DataLoadedFromRemote , _doInit);
			bagData.removeEventListener(DataEvent.DataLoadedFromRemote , _doInit);
			herostar.removeEventListener(DataEvent.DataLoadedFromRemote , _doInit);

			// 武将头像选择面板
			if (_heroStarHeadLayer != null && _heroStarHeadLayer.parent == this)
				removeChild(_heroStarHeadLayer);
			_heroStarHeadLayer = new CJHeroStarHeadLayer;
			_heroStarHeadLayer.x = heroHeadPos.x;
			_heroStarHeadLayer.y = heroHeadPos.y;
			_heroStarHeadLayer.width = heroHeadPos.width;
			_heroStarHeadLayer.height = heroHeadPos.height;
			addChild(_heroStarHeadLayer);
			
			/// 默认第一个武将
			var heroid:String;
			if (SStringUtils.isEmpty(startheroid))
				heroid = _heroStarHeadLayer.getFirstHeroid();
			else
				heroid = startheroid;
			
			// 武将选择状态
			var arr:Array = _heroStarHeadLayer.turnPage.getAllItemDatas();
			for (var i:int; i<arr.length; ++i)
			{
				if ( arr[i].heroid == heroid )
				{
					_heroStarHeadLayer.turnPage.selectedIndex = arr[i].index;
					arr[i].isSelected = true;
					_heroStarHeadLayer.turnPage.updateItemAt(arr[i].index);
					break
				}
				
			}
			var heroInfo:CJDataOfHero = CJDataManager.o.DataOfHeroList.getHero(heroid);
			_updataLayer(heroInfo);
		}
		
		
		private function _touchHandler(e:TouchEvent):void
		{
			_touchHeroNameLabel(e);
			
			_touchClosePrompt(e);
		}
		
		/** 触摸是否移动 **/
		private var _isTouchMove:Boolean = false;
		/** 触摸武将名称标签 **/
		private function _touchHeroNameLabel(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this);
			if (touch == null)
				return;
			if (touch.phase == TouchPhase.BEGAN)
			{
				_isTouchMove = false;
				return;
			}
			if (touch.phase == TouchPhase.MOVED)
			{
				_isTouchMove = true;
				return;
			}
			
			if (touch.phase != TouchPhase.ENDED || _isTouchMove)
				return;
			
			if( !(touch.target.parent is CJHeroStarHeadItem) )
				return;
			
			if(_isLock) // 锁住的不进行选中
				return;
			
			// 将所有的设置为非选中状态
			var arr:Array = _heroStarHeadLayer.turnPage.getAllItemDatas();
			for (var i:int; i<arr.length; ++i)
			{
				arr[i].isSelected = false;
				_heroStarHeadLayer.turnPage.updateItemAt(arr[i].index);
			}
			
			// 将点中的设置为选中
			var temp:CJHeroStarHeadItem = touch.target.parent as CJHeroStarHeadItem;
			var obj:Object = _heroStarHeadLayer.dataProvider.data[temp.index];
			obj.isSelected = true;
			_heroStarHeadLayer.turnPage.updateItemAt(obj.index);
			
			if (String(obj.heroid) != _curheroid) // 同一个武将无需进行刷新
			{
				// 武将列表信息
				var heroDict:Dictionary = CJDataManager.o.DataOfHeroList.herolist;
				// 武将信息
				var heroInfo:CJDataOfHero = heroDict[obj.heroid];
				_updataLayer(heroInfo);	
			}
		}
		
		/** 关闭提示 **/
		private function _touchClosePrompt(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this);
			if (touch == null)
				return;
			
			if (touch.phase != TouchPhase.ENDED)
				return;
			
			if (!noteLayer.visible)
				return;
			if ( touch.target is Button )
				return;
			
			var isShow:Boolean = false;
			var curDisplay:DisplayObject = touch.target.parent;
			for(;;) 
			{
				if (curDisplay == noteLayer)
				{
					isShow = true;
					break;
				}
				
				curDisplay = curDisplay.parent;
				if ( null == curDisplay )
					break;
			}
			
			noteLayer.visible = isShow;
			if(isShow)scroTxt.text = CJLang("HEROSTAR_NOTE");
			else scroTxt.text = "";
		}
		
		// 刷新面板
		private function _updataLayer( heroInfo:CJDataOfHero ):void
		{
			if (null==heroInfo)
				return;
			// 更新当前操作武将id
			_curheroid = heroInfo.heroid;
			// 武将星级信息
			var herostar:CJDataOfHeroStar = CJDataManager.o.DataOfHeroStar;
			// 武将星级模板信息
			var heroStarJS:Json_hero_star_config = CJDataOfHeroStarProperty.o.getHerostarConfig(heroInfo.starlevel, heroInfo.heroProperty.quality);
			
			// 武将名称
			_heroNameTF.text = CJLang(heroInfo.heroProperty.name);
			_heroNameTF.color = ConstHero.ConstHeroNameColor[int(heroInfo.heroProperty.quality)];
			// 武将等级
			heroLevel.text = CJLang("HEROSTAR_HERO_LEVEL")+"  "+heroInfo.level;
			// 星星
			_headStarLevel.level = int(heroInfo.starlevel);
			_headStarLevel.redrawLayer();
			// 祝福值进度条
			_progressBar.minimum = 0;
			_progressBar.maximum = null==heroStarJS ? 1000 : int(heroStarJS.maxblessing);
			_progressBar.value = int(herostar.getBlessingValue(heroInfo.heroid));
			// 祝福值文字显示
			_blessingScoreBoard.curNumber = int(herostar.getBlessingValue(heroInfo.heroid));
			
			// 是否是五星武将
			var isSuperHero:Boolean = false;
			if ( int(heroInfo.starlevel) == ConstHero.ConstMaxHeroStarLevel )
				isSuperHero = true;
			// 判断是否需要更新武将资源
			if (_animate_hero == null ||
				_animate_hero.playerData.templateId !=  heroInfo.templateid ||
				_animate_hero.playerData.super_hero != isSuperHero)
			{
				// 先将原来的武将从舞台中移除
				var playerData:CJPlayerData = new CJPlayerData();
				if ( null != _animate_hero && _heroIdleLayer.contains(_animate_hero) )
				{
					_heroIdleLayer.removeChild(_animate_hero);
				}
				playerData.heroId = heroInfo.heroid;
				playerData.templateId = heroInfo.templateid;
				playerData.super_hero = isSuperHero;
				_animate_hero = new CJPlayerNpc(playerData , null) ;
				_animate_hero.lodlevel = CJPlayerNpc.LEVEL_LOD_1;
				_animate_hero.hideTitle(CJPlayerTitleLayer.TITLETYPE_ALL);
				_animate_hero.x = heroIdlePos.x;
				_animate_hero.y = heroIdlePos.y;
				_animate_hero.hidebattleInfo();
				_animate_hero.touchable = false; // 使该控件不可触控
				_heroIdleLayer.addChild(_animate_hero);
			}
			
			// 更新显示状态
//			// 进度条
//			_progressBar.visible = false;
//			// 材料
//			materialLayer.visible = false;
//			// 升星按钮不可按
//			btnUpgrade.isEnabled = false;
//			// 下级升星效果
//			nextStarLabel.visible = false;
//			_nextStarLevel.visible = false;
//			nextHeroStarDesLabel.visible = false;
			_hideLayer.visible = false;
			
			// 如果是 白色绿色武将，则不可进行升星
			if (int(heroInfo.heroProperty.quality) <= _CONST_LIMIT_QUALITY_)
				btnUpgrade.isEnabled = false;
			else	// 其他可升星武将
			{
				// 主动技能	一个武将仅有一个技能
				var skillname:String = "skillname"
				var skillid:uint = uint(heroInfo.heroProperty.skill1);
				var skillJS:Json_skill_setting = CJDataOfSkillPropertyList.o.getProperty(skillid);
				if (skillJS)
					skillname = CJLang(skillJS.skillname);
				
				// 被动技能	武将被动技能是变化的
				var pskillname:String="pSkillname";
				var pskilldes:String = "pskilldes";
				var pskillid:String;
				var pskilljs:Json_pskill_setting;
				
				if ( null == heroStarJS )	// 武将已达到最高星级
				{
					// 仅描述"当前"部分
					// 描述
					pskillid = String(heroInfo.heroProperty.genius_5);
					pskilljs = CJDataOfPSkillProperty.o.getPSkill(pskillid);
					if (null!=pskilljs)
					{
						pskillname = CJLang(pskilljs.skillname);
//						pskilldes = CJLang(pskilljs.skilldes);
						pskilldes = pskilljs.skilldes;
					}
					// 当前武将描述为最高级描述
					curHeroStarDesLabel.text = CJLang("HEROSTAR_DESCRIBE_MAX", {"skillname":pskillname, "describe":pskilldes});
					// 当前更新武星
					_curStarLevel.level = int(heroInfo.starlevel);
					_curStarLevel.redrawLayer();
				}
				else	// 未达到最高星级
				{
//					_progressBar.visible = true;
//					materialLayer.visible = true;
//					btnUpgrade.isEnabled = true;
//					nextStarLabel.visible = true;
//					_nextStarLevel.visible = true;
//					nextHeroStarDesLabel.visible = true;
					_hideLayer.visible = true;
					
					// 装备模板数据
					var templateSetting : CJDataOfItemProperty = CJDataOfItemProperty.o;
					// 
					var itemTemplate:Json_item_setting = templateSetting.getTemplate(int(heroStarJS.materialid));
					Assert(itemTemplate!=null, "CJHeroStarLayer._updataLayer  itemTemplate==null");
					Assert(!SStringUtils.isEmpty(itemTemplate.picture), "CJHeroStarLayer._updataLayer  itemTemplate.picture==null");
					if(itemTemplate!=null && !SStringUtils.isEmpty(itemTemplate.picture))
					{
						_bagItem.setBagGoodsItem(itemTemplate.picture);
						// 获取背包中对应材料个数
						var count:uint = CJDataManager.o.DataOfBag.getItemCountByTmplId(itemTemplate.id);
						// 显示为 拥有的/需要的
						if (int(count) >= int(heroStarJS.materialcount)) // 有足够材料
							materialCount.textRendererProperties.textFormat = ConstTextFormat.textformatwhiteright;
						else
							materialCount.textRendererProperties.textFormat = ConstTextFormat.textformatredright;
						
						materialCount.text = count + "/" + heroStarJS.materialcount;
					}
					// 材料名称
					materialName.textRendererProperties.textFormat = ConstTextFormat.getFormatByQuality(itemTemplate.quality, true);
					materialName.text = CJLang(itemTemplate.itemname);
					
					// 消耗元宝数量
					consumeCount.text = heroStarJS.gold + "/" + CJDataManager.o.DataOfRole.gold;

					// "当前"与"下级"均进行描述
					var curstarlevel:int = int(heroInfo.starlevel);
					// 当前武星星级不会超过最大星级
					pskillid = String(heroInfo.heroProperty["genius_"+curstarlevel]);
					pskilljs = CJDataOfPSkillProperty.o.getPSkill(pskillid);
					if (null!=pskilljs)
					{
						pskillname = CJLang(pskilljs.skillname);
//						pskilldes = CJLang(pskilljs.skilldes);
						pskilldes = pskilljs.skilldes;
					}
					curHeroStarDesLabel.text = CJLang(heroStarJS.describe, {"skillname":pskillname, "describe":pskilldes});
					// 当前更新武星
					_curStarLevel.level = curstarlevel;
					_curStarLevel.redrawLayer();
					
					// 更新下级星级信息
					var nextstarlevel:int = curstarlevel + 1;
					if ( nextstarlevel >= ConstHero.ConstMaxHeroStarLevel ) // 最大武星的时候将学会主动技能
					{
						pskillid = String(heroInfo.heroProperty.genius_5);
						pskilljs = CJDataOfPSkillProperty.o.getPSkill(pskillid);
						if (null!=pskilljs)
						{
							pskillname = CJLang(pskilljs.skillname);
							pskilldes = CJLang(pskilljs.skilldes);
						}
						// 当前武将描述为最高级描述
						nextHeroStarDesLabel.text = CJLang("HEROSTAR_DESCRIBE_MAX", {"skillname":pskillname, "describe":pskilldes});
					}
					else
					{
						pskillid = String(heroInfo.heroProperty["genius_"+nextstarlevel]);
						pskilljs = CJDataOfPSkillProperty.o.getPSkill(pskillid);
						if (null!=pskilljs)
						{
							pskillname = CJLang(pskilljs.skillname);
//							pskilldes = CJLang(pskilljs.skilldes);
							pskilldes = pskilljs.skilldes;
						}
						// 当前武将描述为最高级描述
						nextHeroStarDesLabel.text = CJLang(heroStarJS.describe, {"skillname":pskillname, "describe":pskilldes});
					}
					// 下一级星级 星星
					_nextStarLevel.level = nextstarlevel>ConstHero.ConstMaxHeroStarLevel ? ConstHero.ConstMaxHeroStarLevel : nextstarlevel;
					_nextStarLevel.redrawLayer();
				}
			}
			
		}
		
		// 材料升星
		private function _touchUpgrade(e:Event):void
		{
			//处理指引
			if(CJDataManager.o.DataOfFuncList.isIndicating)
			{
				CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_INDICATE_NEXT_STEP);
			}
			
			_isLock = true;
			// 监听武将升星
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _onUpgradeComplete);
			SocketCommand_herostar.upgrade(_curheroid, _CONST_UPGRADE_TYPE_MATERIAL_);
		}
		
		// 元宝升星
		private function _clickGoldUpgrade(e:Event):void
		{
			_isLock = true;
			// 监听武将升星
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _onUpgradeComplete);
			SocketCommand_herostar.upgrade(_curheroid, _CONST_UPGRADE_TYPE_GOLD_);
		}
		
		// 升星服务器返回数据
		protected function _onUpgradeComplete(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() != ConstNetCommand.CS_HEROSTAR_UPGRADE)
				return;
			
			e.target.removeEventListener(e.type,_onUpgradeComplete);
			if (message.retcode != 0) // 错误信息，直接解锁
				_isLock = false;
			switch(message.retcode)
			{
				case 0:
					break;
				case 1:
					CJMessageBox(CJLang("ERROR_HEROSTAR_MAMSTARLV"));
					return;
				case 2:
					CJMessageBox(CJLang("ERROR_HEROSTAR_MONEY"));
					return;
				case 3:
					CJMessageBox(CJLang("ERROR_HEROSTAR_MATERIAL"));
					return;
				case 4:
					CJMessageBox(CJLang("ERROR_HEROSTAR_MAINHERO"));
					return;
				default:
					CJMessageBox(CJLang("ERROR_UNKNOWN")+ "CJHeroStarLyer._onUpgradeComplete retcode="+message.retcode );
					return;
			}
			
			// 活跃度
			CJDataManager.o.activityManager.dispatchEventWith(CJEvent.EVENT_ACTIVITY_HAPPEN , false, {"key":CJActivityEventKey.ACTIVITY_HEROSTAR});
			
			var bIsSucceed:Boolean 		= message.retparams[0];
			var heroid:String			= message.retparams[1];
			var blessingvalue:String	= message.retparams[2];
			var starlevel:String		= message.retparams[3];
			
			Assert( heroid==_curheroid , "CJHeroStarLayer._touchUpgrade heroid != _curheroid");
			
			// 武将信息
			var heroInfo:CJDataOfHero = CJDataManager.o.DataOfHeroList.getHero(heroid);
			// 武将星级信息
			var herostar:CJDataOfHeroStar = CJDataManager.o.DataOfHeroStar;
			if (bIsSucceed)
			{
				// 下一级描述
				var skilltemplateid:String = String(heroInfo.heroProperty["genius_"+starlevel]);
				var skillObj:Json_pskill_setting = CJDataOfPSkillProperty.o.getPSkill(skilltemplateid) as Json_pskill_setting;
				var skillname:String;
				if (null!=skillObj)
					skillname = CJLang(skillObj.skillname);
				// 更新主界面总战斗力
				SocketCommand_hero.get_heros();
//				// 升阶成功
//				CJMessageBox(CJLang("HEROSTAR_UPGRADE_SUCCEED", {"starlevel":starlevel, "skillname":skillname}));
				// 特效开始播放
				_startEffects();
			}
			else	// 升星成功播放特效，增长祝福值播放飘字
			{
				// 飘字
				var num:int = int(blessingvalue);
				num -= int(herostar.getBlessingValue(heroid));
				if ( num > 0 )
				{
					var flyPanel:CJHeroStarFlyImage = new CJHeroStarFlyImage(new CJHeroStarBlessing(String(num)));
					flyPanel.x = 170;
					flyPanel.y = 120;
					addChild(flyPanel);
					flyPanel.gotoAndPlay();
				}
			}

			
			// 更新祝福值
			herostar.setBlessingValue(heroid, blessingvalue); // 设置祝福值
			heroInfo.starlevel = starlevel; // 设置武将当前星级
			
			// 火焰燃烧
			_fireAnimate.visible = true;
			_fireAnimate.gotoAndPlay();
			
			// 获取角色信息 刷新钱币
			SocketCommand_role.get_role_info();
			
			// 监听背包数据
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _onUpdataBag);
			// 获取背包数据
			SocketCommand_item.getBag();
		}
		
		// 升星服务器返回数据
		protected function _onUpdataBag(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() != ConstNetCommand.CS_ITEM_GET_BAG)
				return;
			e.target.removeEventListener(e.type,_onUpdataBag);
			var heroInfo:CJDataOfHero = CJDataManager.o.DataOfHeroList.getHero(_curheroid);
			// 更新界面
			_updataLayer(heroInfo);
			
			// 解锁
			_isLock = false;
		}
		
		/** 开始特效 **/
		private function _startEffects():void
		{
			// 心跳动画效果
			CJHeartbeatEffectUtil("texiaozi_shengxingchenggong");
			
			// 升级特效
			_upgradedragon.visible = true;
			_upgradedragon.alpha = 1.0;
			_upgradedragon.gotoAndPlay();
			// 脚下特效
			_footshine.alpha = 1.0;
			_footshine.visible = true;
			_footshine.gotoAndPlay();
			
			// 停止淡出特效
			if (_upgradeFadeOut)
			{
				_upgradeFadeOut.onComplete = null;
				Starling.juggler.remove(_upgradeFadeOut);
				_upgradeFadeOut = null;
			}
		}
		/**
		 * 升级特效结束
		 * @param e
		 */
		private function _upgradeComplete(e:Event):void
		{
			// 渐隐特效
			_upgradeFadeOut = new STween(_footshine, 0.2);
			_upgradeFadeOut.animate("alpha", 0);
			_upgradeFadeOut.onComplete = ___onfadeoutComplete;
			Starling.juggler.add(_upgradeFadeOut);
			
			function ___onfadeoutComplete():void
			{
				_upgradeFadeOut.onComplete = null;
				Starling.juggler.remove(_upgradeFadeOut);
				_upgradeFadeOut = null;
				
				_upgradedragon.visible = false;
				_footshine.visible = false;
				_footshine.alpha = 1.0
			}
		}
		
		/**
		 * 火焰结束
		 * @param e
		 */
		private function _fireComplete(e:Event):void
		{
			_fireAnimate.visible = false;
		}
		
		/**
		 * 添加动画
		 * @param juggler
		 */
		public function addAnimate(juggler:Juggler):void
		{
			juggler.add(_fireAnimate);
			juggler.add(_heroRuneST);
			juggler.add(_upgradedragon);
			juggler.add(_footshine);
		}
		
		/**
		 * 删除动画
		 * @param juggler
		 */
		public function removeAnimate(juggler:Juggler):void
		{
			juggler.remove(_fireAnimate);
			juggler.remove(_heroRuneST);
			juggler.remove(_upgradedragon);
			juggler.remove(_footshine);
		}

	}
}