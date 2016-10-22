package SJ.Game.moneytree
{
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import SJ.Common.Constants.ConstMoneyTree;
	import SJ.Common.Constants.ConstNPCDialog;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstResource;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.SocketServer.SocketCommand_moneytree;
	import SJ.Game.SocketServer.SocketCommand_role;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.activity.CJActivityEventKey;
	import SJ.Game.controls.CJPanelFrame;
	import SJ.Game.controls.CJPanelTitle;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfMoneyTreeFriend;
	import SJ.Game.data.CJDataOfMoneyTreeMine;
	import SJ.Game.data.CJDataOfMoneyTreeSingleFriend;
	import SJ.Game.data.CJDataOfRole;
	import SJ.Game.data.config.CJDataOfGlobalConfigProperty;
	import SJ.Game.data.config.CJDataOfMoneyTreeProperty;
	import SJ.Game.data.config.CJDataOfVipFuncSetting;
	import SJ.Game.data.json.Json_money_tree_setting;
	import SJ.Game.data.json.Json_vip_function_setting;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJConfirmMessageBox;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJMessageBox;
	import SJ.Game.richtext.CJRTElementImage;
	import SJ.Game.richtext.CJRTElementLabel;
	import SJ.Game.richtext.CJRichText;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.Events.DataEvent;
	import engine_starling.display.SAnimate;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.STween;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.controls.ProgressBar;
	import feathers.display.Scale3Image;
	import feathers.display.Scale9Image;
	import feathers.display.TiledImage;
	import feathers.textures.Scale3Textures;
	import feathers.textures.Scale9Textures;
	
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.Shape;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;

	/**
	 * 装备强化layer
	 * @author sangxu
	 * 
	 */	
	public class CJMoneyTreeLayer extends SLayer
	{
		public function CJMoneyTreeLayer()
		{
			super();
		}
		
		/** datas */
		/** 数据 - 我的摇钱树 */
		private var _dataMTMine:CJDataOfMoneyTreeMine;
		/** 数据 - 好友的摇钱树 */
		private var _dataMTFriend:CJDataOfMoneyTreeFriend;
		/** 数据 - 玩家数据 */
		private var _dataRole:CJDataOfRole;
		
		/** 数据 - 摇钱树配置数据 */
		private var _moneyTreeConfig:CJDataOfMoneyTreeProperty;
		/** 数据 - 全局配置 */
		private var _globalConfig:CJDataOfGlobalConfigProperty;
		
		/** 是否有数据标志位 */
		private var _dataInitMTMine:Boolean = false;
		private var _dataInitMTFriend:Boolean = false;
		
		/** 是否为我的摇钱树 */
		private var _isMyTree:Boolean = true;
		/** 当前选中好友数据 */
		private var _dataFriend:CJDataOfMoneyTreeSingleFriend;
		private var _mtfSelect:CJMoneyTreeFriendLayer;
		
		/** 好友显示层数组 */
//		private var _vecFriend:Vector.<CJMoneyTreeFriendLayer>;
		private var _arrayFriend:Array;
		/** 好友列表当前页数 */
		private var _curPageNum:int = 1;
		/** 好友列表总页数 */
		private var _pageCount:int = 1;
		
		/** 摇钱功能是否可用 */
		private var _funcYaoCanUse:Boolean = true;
		/** 施肥功能是否可用 */
		private var _funcShifeiCanUse:Boolean = true;
		
		/** 是否动画正在播放 - 摇钱 */
		private var _isAnimRunningYao:Boolean = false;
		/** 是否动画正在播放 - 施肥 */
		private var _isAnimRunningShifei:Boolean = false;
		
		/** 施肥冷却时间, 单位:秒 */		
		private const COOL_TIME_SHIFEI:int = 300;
		
		private const _operatLayerWidth:int = 444;
		private const _operatLayerHeight:int = 276;
		
		private const _operatLayerX:int = 17;
		private const _operatLayerY:int = 30;
		
		/** vip不cd：true-不cd；false-cd */
		private var _isVipNotCd:Boolean = false;
		
		override protected function initialize():void
		{
			super.initialize();
			
			this._initData();
			
			this._initControls();
			
			this._addDataLiteners();
			
			this._initDraw();
		}
		
		/**
		 * 添加事件监听
		 * 
		 */		
		private function _addDataLiteners():void
		{
			// 监听RPC结果
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _onRpcReturn);
		}
		
		/**
		 * 移除监听
		 * 
		 */		
		public function removeAllEventListener():void
		{
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData, _onRpcReturn);
			
			this.btnClose.removeEventListener(starling.events.Event.TRIGGERED, _onBtnClickClose);
			this.btnFriendLeft.removeEventListener(Event.TRIGGERED, _onClickBtnFriendLeft);
			this.btnFriendRight.removeEventListener(Event.TRIGGERED, _onClickBtnFriendRight);
			this.btnYao.removeEventListener(Event.TRIGGERED, _onClickBtnYao);
			this.btnYaoPiliang.removeEventListener(Event.TRIGGERED, _onClickBtnYaoPiliang);
			this.btnChengzhang.removeEventListener(Event.TRIGGERED, _onClickBtnChengzhang);
			this.btnReturnMine.removeEventListener(Event.TRIGGERED, _onClickBtnReturnMine);
			this.btnShifeiAll.removeEventListener(Event.TRIGGERED, _onClickBtnShifeiAll);
			this.btnShifei.removeEventListener(Event.TRIGGERED, _onClickBtnShifei);
			this.btnShouhuo.removeEventListener(Event.TRIGGERED, _onClickBtnShouhuo);
			this.removeEventListener(TouchEvent.TOUCH, _onTouchFriendLayer);
			
			this._dataMTMine.removeEventListener(DataEvent.DataLoadedFromRemote , this._onDataLoadedMoneyTreeMine);
			this._dataMTFriend.removeEventListener(DataEvent.DataLoadedFromRemote , this._onDataLoadedMoneyTreeFriend);
			this._dataRole.removeEventListener(DataEvent.DataChange , this._onDataLoadedRole);

		}
		
		/**
		 * 初始化控件
		 * 
		 */		
		private function _initControls():void
		{
			this.width = SApplicationConfig.o.stageWidth;
			this.height = SApplicationConfig.o.stageHeight;
			
			var texture:Texture;
			
			// 背景
			texture = SApplication.assets.getTexture("common_quanbingdise");
			var imgBg:Scale9Image = new Scale9Image(new Scale9Textures(texture, new Rectangle(1 ,1 , 1, 1)));
			imgBg.width = width;
			imgBg.height = height;
			this.addChildAt(imgBg, 0);
			
			// 背景遮罩图
//			var imgBg:Scale9Image;
//			texture = SApplication.assets.getTexture("common_dinew");
//			var bgScaleRange:Rectangle = new Rectangle(44, 44, 1, 1);
//			var bgTexture:Scale9Textures = new Scale9Textures(texture, bgScaleRange);
//			imgBg = new Scale9Image(bgTexture);
//			imgBg.width = SApplicationConfig.o.stageWidth;
//			imgBg.height = SApplicationConfig.o.stageHeight;
//			imgBg.alpha = 0.7;
//			this.addChildAt(imgBg, 0);
			
			// 字体 - 按钮
			var fontFormatBtn:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 10, 0xD5CDA1, null, null, null, null, null, TextFormatAlign.CENTER);
			// 字体 - 描述
			var fontFormatDesc:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 10, 0x89C542, null, null, null, null, null, TextFormatAlign.CENTER);
			// 字体 - 货币显示
			var fontFormatCost:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 10, 0xEBFFB4);
			// 字体 - 好友标题
			var fontFormatFriendTitle:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 10, 0xFFEE5E, true, null, null, null, null, TextFormatAlign.CENTER);
			// 字体 - 摇钱树等级
			var fontFormatLv:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 10, 0xE1CA3F, null, null, null, null, null, TextFormatAlign.CENTER);
			// 字体 - 摇钱树等级
			var fontFormatPage:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 10, 0xB7B5A4, null, null, null, null, null, TextFormatAlign.CENTER);
			// 字体 - 倒计时
			var fontFormatTime:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 7, 0x89C542);
			// 字体 - 施肥次数
			var fontFormatCishu:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 7, 0xE1CA3F);
			// 字体 - 文字经验
			var fontExpLab:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 10, 0xFDFF70);
			// 字体 - 经验
			var fontExp:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 8, 0xFFFFFF, null, null, null, null, null, TextFormatAlign.CENTER);
			
			var img:TiledImage = new TiledImage(SApplication.assets.getTexture("common_quanpingtoubudi"));
			img.width = SApplicationConfig.o.stageWidth;
			img.x = 0;
			img.y = 0;
			img.height = 20;
			img.scaleY = 0.9;
			this.addChildAt(img, this.getChildIndex(moneyLayer));
			
			// 标题
			var title:CJPanelTitle = new CJPanelTitle(CJLang("MONEYTREE_TITLE"));
			this.addChildAt(title, this.getChildIndex(moneyLayer));
			title.x = SApplicationConfig.o.stageWidth - title.width >> 1 ;
			title.scaleY = 0.9;
			
			// 边角
			var imgBgcorner:Scale9Image;
			var textureCorner:Texture = SApplication.assets.getTexture("common_quanpingzhuangshi");
			var corScaleRange:Rectangle = new Rectangle(14, 14, 1, 1);
			var corTexture:Scale9Textures = new Scale9Textures(textureCorner, corScaleRange);
			imgBgcorner = new Scale9Image(corTexture);
			imgBgcorner.x = 0;
			imgBgcorner.y = 0;
			imgBgcorner.width = 480;
			imgBgcorner.height = 320;
			this.addChildAt(imgBgcorner, 0);
			
			// 货币层
			var stBgMoneyLayer:Scale9Textures = new Scale9Textures(SApplication.assets.getTexture("common_tankuangwenzidi"), new Rectangle(11, 11, 1, 1));
			var siBgMoneyLayer:Scale9Image = new Scale9Image(stBgMoneyLayer);
			siBgMoneyLayer.x = 0;
			siBgMoneyLayer.y = 0;
			siBgMoneyLayer.width = moneyLayer.width;
			siBgMoneyLayer.height = moneyLayer.height;
			moneyLayer.addChildAt(siBgMoneyLayer, 0);
			
			labHasCount.textRendererProperties.textFormat = fontFormatCost;
			labHasCount.text = CJLang("MONEYTREE_MONEY");
			
			// 我的元宝数量
			labGoldCount.textRendererProperties.textFormat = fontFormatCost;
			labGoldCount.text = String(_dataRole.gold);
			// 我的银两数量
			labSilverCount.textRendererProperties.textFormat = fontFormatCost;
			labSilverCount.text = String(_dataRole.silver);
			
			moneyLayer.y += 2;
			
			// 边框底图
//			var imgBgBiankuang:Scale9Image;
//			var ttBgBiangkuang:Texture = SApplication.assets.getTexture("common_dinew");
//			var rtBgBiankuang:Rectangle = new Rectangle(44, 44, 1, 1);
//			var stBgBiankuang:Scale9Textures = new Scale9Textures(ttBgBiangkuang, rtBgBiankuang);
//			imgBgBiankuang = new Scale9Image(stBgBiankuang);
//			imgBgBiankuang.x = 17;
//			imgBgBiankuang.y = 30;
//			imgBgBiankuang.width = 444;
//			imgBgBiankuang.height = 276;
//			this.addChildAt(imgBgBiankuang, 0);
			var optIdx:int = 0;
			
			var imgOptBgKuang:Scale9Image;
			texture = SApplication.assets.getTexture("common_dinew");
			imgOptBgKuang = new Scale9Image(new Scale9Textures(texture, new Rectangle(1 ,1 , 1, 1)));
//			imgOptBgKuang.x = _operatLayerX;
//			imgOptBgKuang.y = _operatLayerY;
			imgOptBgKuang.width = _operatLayerWidth;
			imgOptBgKuang.height = _operatLayerHeight;
			this.operateLayer.addChildAt(imgOptBgKuang, optIdx++);
			
			texture = SApplication.assets.getTexture("common_dinewzhezhao");
			imgOptBgKuang = new Scale9Image(new Scale9Textures(texture, new Rectangle(44, 44, 1, 1)));
//			imgOptBgKuang.x = _operatLayerX;
//			imgOptBgKuang.y = _operatLayerY;
			imgOptBgKuang.width = _operatLayerWidth;
			imgOptBgKuang.height = _operatLayerHeight;
			this.operateLayer.addChildAt(imgOptBgKuang, optIdx++);
			
			// 花框
//			var imgHuabian:SImage = new SImage(SApplication.assets.getTexture("yaoqianshu_huabian"));
//			imgHuabian.x = 15;
//			imgHuabian.y = 30;
//			this.addChildAt(imgHuabian, 2);
//			var imgOutFrameDecorate:Scale9Image = ConstNPCDialog.genS9ImageWithTextureNameAndRect("common_zhuangshinew", 15, 15,7,3);
//			imgOutFrameDecorate.x = imgBgBiankuang.x + 3;
//			imgOutFrameDecorate.y = imgBgBiankuang.y + 3;
//			imgOutFrameDecorate.width = imgBgBiankuang.width - 6;
//			imgOutFrameDecorate.height = imgBgBiankuang.height - 6;
//			this.addChildAt(imgOutFrameDecorate, 2);
			var panelFrame:CJPanelFrame = new CJPanelFrame(_operatLayerWidth - 6, _operatLayerHeight - 6);
			panelFrame.x = 3;
			panelFrame.y = 3;
			this.operateLayer.addChildAt(panelFrame, optIdx++);
			
			// 边框
			var imgBiankuang:Scale9Image;
			texture = SApplication.assets.getTexture("common_waikuangnew");
			var bkScaleRange:Rectangle = new Rectangle(15 , 15 , 1, 1);
			var bkTexture:Scale9Textures = new Scale9Textures(texture, bkScaleRange);
			imgBiankuang = new Scale9Image(bkTexture);
//			imgBiankuang.x = 17;
//			imgBiankuang.y = 30;
			imgBiankuang.width = 444;
			imgBiankuang.height = 276;
			this.operateLayer.addChildAt(imgBiankuang, optIdx++);
			
			var ttKuang:Texture = SApplication.assets.getTexture("yaoqianshu_shuwaikuang"); //common_tiptankuang
			var rtKuang:Rectangle = new Rectangle(6, 6, 1, 1);
			var stKuang:Scale9Textures = new Scale9Textures(ttKuang, rtKuang);
			// 框 - 摇钱树
			var imgKuangTree:Scale9Image = new Scale9Image(stKuang);
			imgKuangTree.x = 15;
			imgKuangTree.y = 17;
			imgKuangTree.width = 202;
			imgKuangTree.height = 177;
			this.operateLayer.addChildAt(imgKuangTree, optIdx++);
			
			// 框 - 好友
			var imgKuangFriend:Shape = new Shape();
			imgKuangFriend.graphics.beginFill(0x000000, 0.1);
			imgKuangFriend.graphics.drawRect(226, 9, 210, 258);
			imgKuangFriend.graphics.endFill();
//			var imgKuangFriend:Scale9Image = new Scale9Image(stKuang);
//			imgKuangFriend.x = 226;
//			imgKuangFriend.y = 9;
//			imgKuangFriend.width = 210;
//			imgKuangFriend.height = 258;
			this.operateLayer.addChildAt(imgKuangFriend, optIdx++);
			
			var imgLineFriendShu:Shape = new Shape();
			imgLineFriendShu.graphics.lineStyle(0.5, 0x67746c, 1);
			imgLineFriendShu.graphics.moveTo(226, 9);
			imgLineFriendShu.graphics.lineTo(226, 267);
			this.operateLayer.addChildAt(imgLineFriendShu, 2);
			
			// 分割线
			var imgLineFenge:ImageLoader = new ImageLoader();
			imgLineFenge.source = SApplication.assets.getTexture("common_fengexian");
			imgLineFenge.x = 228;
			imgLineFenge.y = 235;
			imgLineFenge.width = 208;
			imgLineFenge.height = 2;
			this.operateLayer.addChild(imgLineFenge);
			
			
			// 关闭按钮
			this.btnClose = new Button();
			btnClose.defaultSkin = new SImage(SApplication.assets.getTexture("common_quanpingguanbianniu01"));
			btnClose.downSkin = new SImage(SApplication.assets.getTexture("common_quanpingguanbianniu02"));
			btnClose.width = 42;
			btnClose.height = 43;
			btnClose.x = 438;
			btnClose.y = 0;
			//为关闭按钮添加监听
			btnClose.addEventListener(starling.events.Event.TRIGGERED, _onBtnClickClose);
			this.addChild(btnClose);
			
			
			
			// 按钮 - 好友左
			this.btnFriendLeft.scaleX = -1;
//			this.btnFriendLeft.x += this.btnFriendLeft.width + 36;
			this.btnFriendLeft.x += 18;
			this.btnFriendLeft.addEventListener(Event.TRIGGERED, _onClickBtnFriendLeft);
			
			this.btnFriendRight.addEventListener(Event.TRIGGERED, _onClickBtnFriendRight);
			
			
			
			
			
//			var imgPageDi:SImage = new SImage(SApplication.assets.getTexture("common_ditiao1"));
//			imgPageDi.x = 265;
//			imgPageDi.y = 244;
//			imgPageDi.width = 62;
//			imgPageDi.height = 19;
//			this.operateLayer.addChild(imgPageDi);
//			
//			this.labPage = new Label();
//			labPage.x = 265;
//			labPage.y = 244;
//			labPage.width = 62;
//			labPage.height = 19;
//			this.operateLayer.addChild(labPage);
			
			// 页码显示框
			texture = SApplication.assets.getTexture("common_tiptankuang");
			var scale3texture:Scale3Textures = new Scale3Textures(texture, texture.width/2-1,1);
			this.btnYemaditiao.defaultSkin= new Scale3Image(scale3texture);
			this.btnYemaditiao.defaultLabelProperties.textFormat = fontFormatPage;
//			this.btnYemaditiao.x = 265;
//			this.btnYemaditiao.y = 244;
//			this.btnYemaditiao.width = 62;
//			this.btnYemaditiao.height = 19;
//			this.operateLayer.addChild(this.btnYemaditiao);
			
			// 按钮 - 摇一摇
			this.btnYao.defaultLabelProperties.textFormat = fontFormatBtn;
			this.btnYao.label = CJLang("MONEYTREE_BTN_YAO");
			this.btnYao.addEventListener(Event.TRIGGERED, _onClickBtnYao);
			
			// 按钮 - 批量摇钱
			this.btnYaoPiliang.defaultLabelProperties.textFormat = fontFormatBtn;
			this.btnYaoPiliang.label = CJLang("MONEYTREE_BTN_YAOPI");
			this.btnYaoPiliang.addEventListener(Event.TRIGGERED, _onClickBtnYaoPiliang);
			btnYaoPiliang.visible = false;
			// VIP判定是否可批量摇钱
			var vipLv:int = CJDataManager.o.DataOfRole.vipLevel;
			var vipCfg:Json_vip_function_setting = CJDataOfVipFuncSetting.o.getData(String(vipLv));
			if (vipCfg)
			{
				if (int(vipCfg.mt_batharvest) >= 1)
				{
					btnYaoPiliang.visible = true;
				}
			}
			
			// 按钮 - 成长记录
			this.btnChengzhang.defaultLabelProperties.textFormat = fontFormatBtn;
			this.btnChengzhang.label = CJLang("MONEYTREE_BTN_CHENGZHANGJILU");
			this.btnChengzhang.addEventListener(Event.TRIGGERED, _onClickBtnChengzhang);
			
			// 按钮 - 返回我的摇钱树
			this.btnReturnMine.label = CJLang("MONEYTREE_BTN_FANHUI");
			this.btnReturnMine.defaultLabelProperties.textFormat = fontFormatBtn;
			texture = SApplication.assets.getTexture("common_anniu01new");
			var ttBtnReturn:Scale3Textures = new Scale3Textures(texture, 16, 17);
			this.btnReturnMine.defaultSkin = new Scale3Image(ttBtnReturn);
			texture = SApplication.assets.getTexture("common_anniu02new");
			ttBtnReturn = new Scale3Textures(texture, 16, 17);
			this.btnReturnMine.downSkin = new Scale3Image(ttBtnReturn);
			this.btnReturnMine.addEventListener(Event.TRIGGERED, _onClickBtnReturnMine);
			this.btnReturnMine.visible = false;
			
			// 按钮 - 一键施肥
			this.btnShifeiAll.defaultLabelProperties.textFormat = fontFormatBtn;
			this.btnShifeiAll.label = CJLang("MONEYTREE_BTN_YIJIANSHIFEI");
			this.btnShifeiAll.addEventListener(Event.TRIGGERED, _onClickBtnShifeiAll);
			// 文字 - 一键施肥
			this.tfFeedAllDesc = new TextField(68, 28, CJLang("MONEYTREE_DESC_YIJIAN"), ConstTextFormat.FONT_FAMILY_HEITI, 9, 0x73FF42);
			this.tfFeedAllDesc.x = 365;
			this.tfFeedAllDesc.y = 238;
			this.operateLayer.addChild(this.tfFeedAllDesc);
			
			// 文字 - 施肥次数
			this._labShifeici.textRendererProperties.textFormat = fontFormatCishu;
			// 文字 - 倒计时
			this._labTime.textRendererProperties.textFormat = fontFormatTime;
			
			// 按钮 - 左上角施肥
			this.btnShifei.addEventListener(Event.TRIGGERED, _onClickBtnShifei);
			// 按钮 - 左上角收获
			this.btnShouhuo.addEventListener(Event.TRIGGERED, _onClickBtnShouhuo);
//			this._setBtnShouhuoVisible();
			
			// 文字 - 等级
			this.labLevel.textRendererProperties.textFormat = fontFormatLv;
			
			// 文字 - 玩家
			this.labWanjia.text = CJLang("MONEYTREE_FRIEND_WANJIA");
			this.labWanjia.textRendererProperties.textFormat = fontFormatFriendTitle;
			
			// 文字 - 阵营
			this.labZhenying.text = CJLang("MONEYTREE_FRIEND_ZHENYING");
			this.labZhenying.textRendererProperties.textFormat = fontFormatFriendTitle;
			
			// 文字 - 等级
			this.labDengji.textRendererProperties.textFormat = fontFormatFriendTitle;
			this.labDengji.text = CJLang("MONEYTREE_FRIEND_DENGJI");
			
			// 文字 - 状态
			this.labZhuangtai.text = CJLang("MONEYTREE_FRIEND_ZHUANGTAI");
			this.labZhuangtai.textRendererProperties.textFormat = fontFormatFriendTitle;
			
			// 文字 - 摇钱树提示
			this.labTishiYao.textRendererProperties.textFormat = fontFormatDesc;
			this.labTishiYao.text = CJLang("MONEYTREE_DESC");
			
			
			// 花费与奖励
			this._initRichText();
			
			// 初始化好友列表控件
			this._initControlFriend();
			
			this._initRichText();
//			this.setChildIndex(btnClose, this.numChildren - 1);
			
			var moveeffectObject:Object = AssetManagerUtil.o.getObject("anim_yaoqianshu");
			this.animTree = SAnimate.SAnimateFromAnimJsonObject(moveeffectObject);
//			this.animTree.addEventListener(Event.COMPLETE, _onQianghuaTexiaoComplete);
			this.animTree.x = 15;
			this.animTree.y = 17;
//								this._completeAnimation.width = btn.width;
//								this._completeAnimation.height = btn.height;
			this.operateLayer.addChildAt(this.animTree, this.operateLayer.getChildIndex(this.imgTreeLvBg));
			this.animTree.gotoAndPlay();
			Starling.juggler.add(this.animTree);
			
			this.timeLayer = new CJMoneyTreeTimeLayer();
			this.timeLayer.x = 50;
			this.timeLayer.y= 34;
			this.timeLayer.width = 360;
			this.timeLayer.height = 100;
			this.timeLayer.textFormat = fontFormatTime;
			this.operateLayer.addChild(this.timeLayer);
			
			this._setShiFei();
			
			// 经验
			this.labJingyan = new Label();
			this.labJingyan.x = 24;
			this.labJingyan.y = 178;
			this.labJingyan.width = 24;
			this.labJingyan.height = 12;
			this.labJingyan.text = CJLang("MONEYTREE_EXP");
			this.labJingyan.textRendererProperties.textFormat = fontExpLab;
			this.operateLayer.addChild(this.labJingyan);
			
			// 经验条底图
			var stExpDi:Scale3Textures = new Scale3Textures(SApplication.assets.getTexture("yaoqianshu_jindutiaodi"), 5, 1);
			this.imgExpDi = new Scale3Image(stExpDi);
			this.imgExpDi.x = 50;
			this.imgExpDi.y = 181;
			this.imgExpDi.width = 158;
			this.imgExpDi.height = 9;
			this.operateLayer.addChild(this.imgExpDi);
			
			// 经验条
			var stExp:Scale3Textures = new Scale3Textures(SApplication.assets.getTexture("yaoqianshu_jindutiao"), 5, 1);
			var simgExp:Scale3Image = new Scale3Image(stExp);
			this.pbExp = new ProgressBar();
			this.pbExp.fillSkin = simgExp;
			this.pbExp.x = this.imgExpDi.x + 1;
			this.pbExp.y = this.imgExpDi.y + 1;
			this.pbExp.width = this.imgExpDi.width - 2;
			this.pbExp.height = this.imgExpDi.height - 2;
			this.operateLayer.addChild(this.pbExp);
			pbExp.validate();
			
//			var fillSkin:Scale3Image = new Scale3Image(scale3texture);
//			_progressBar = new ProgressBar();
//			_progressBar = new ProgressBar;
//			_progressBar.fillSkin = fillSkin;
//			_progressBar.x = imgBlessingBG.x+32;
//			_progressBar.y = imgBlessingBG.y+9;
//			_progressBar.width = imgBlessingBG.width-32*2;
//			_progressBar.height = imgBlessingBG.height-17;
//			addChild(_progressBar);
//			_progressBar.validate();
			
			// 文字 - 经验值
			this.labExp = new Label();
			this.labExp.x = this.imgExpDi.x;
			this.labExp.y = this.imgExpDi.y - 1;
			this.labExp.width = this.imgExpDi.width;
			this.labExp.height = this.imgExpDi.height;
			this.labExp.textRendererProperties.textFormat = fontExp;
			this.operateLayer.addChild(this.labExp);
		}
		
		
		
		/**
		 * 初始化摇钱树摇钱货币消耗：花费xx元宝摇钱，可收获xxx银两
		 * 
		 */		
		private function _initRichText():void
		{
			if (this.rtCost == null)
			{
				this.rtCost = new CJRichText(190);
				this.rtCost.x = 38;
				this.rtCost.y = 199;
				this.operateLayer.addChild(this.rtCost);
			}
		}
		
		/**
		 * 初始化好友列表控件
		 * 
		 */		
		private function _initControlFriend():void
		{
			var mtFriend:CJMoneyTreeFriendLayer;
			var mtFriendInitX:int = 228;
			var mtFriendInitY:int = 33;
			var mtFriendHeight:int = 20;
			this._arrayFriend = new Array();
			for (var i:int = 0; i < ConstMoneyTree.MONEYTREE_FRIEND_COUNT_PERPAGE; i++)
			{
				mtFriend = new CJMoneyTreeFriendLayer();
				mtFriend.x = mtFriendInitX;
				mtFriend.y = mtFriendInitY + (i * mtFriendHeight);
				this.operateLayer.addChild(mtFriend);
//				this._vecFriend.push(mtFriend);
//				mtFriend.addEventListener(TouchEvent.TOUCH, _onTouchFriendLayer);
				
				this._arrayFriend.push(mtFriend);
			}
			this.addEventListener(TouchEvent.TOUCH, _onTouchFriendLayer);
		}
		
		/**
		 * 好友点击选中事件响应
		 * @param event
		 * 
		 */		
		private function _onTouchFriendLayer(event:TouchEvent):void
		{
//			var friendLayer:CJMoneyTreeFriendLayer = event.target as CJMoneyTreeFriendLayer;
			var touch:Touch = event.getTouch(this);
			
			if (!touch)
			{
				return;
			}
			if (touch.phase != TouchPhase.ENDED)
			{
				return;
			}
			for each (var layerTemp:CJMoneyTreeFriendLayer in this._arrayFriend)
			{
				if (layerTemp.hitTest(touch.getLocation(layerTemp)))
				{
					this._onSelectFriend(layerTemp);
				}
			}
			
			
		}
		
		/**
		 * 选择好友
		 * @param index
		 * @param int
		 * 
		 */			
		private function _onSelectFriend(friendLayer:CJMoneyTreeFriendLayer):void
		{
			if (friendLayer.select == true)
			{
				// 已选中，返回
				return;
			}
			if (friendLayer.friendData == null)
			{
				// 选择好友数据为空，返回
				return;
			}
			
			for each (var layerTemp:CJMoneyTreeFriendLayer in this._arrayFriend)
			{
				layerTemp.select = false;
			}
			friendLayer.select = true;
			this._dataFriend = friendLayer.friendData;
			this._mtfSelect = friendLayer;
			this._redrawTreeInfoWithFriendData(friendLayer.friendData);
		}
		
		/**
		 * 根据好友摇钱树数据刷新摇钱树信息
		 * @param data
		 * 
		 */		
		private function _redrawTreeInfoWithFriendData(data:CJDataOfMoneyTreeSingleFriend):void
		{
			this._isMyTree = false;
			this._setShiFei();
			
			this.btnYao.visible = false;
//			this.btnYaoPiliang.visible = false;
			this.btnChengzhang.visible = false;
//			this.btnShouhuo.visible = false;
			
			this.btnReturnMine.visible = true;
			
			// 施肥按钮
			if (data.canfeed == true)
			{
				this.btnShifei.isEnabled = true;
				this.btnShifei.visible = true;
			}
			else
			{
//				this.btnShifei.isEnabled = false;
				this.btnShifei.visible = false;
			}
			
			var myLv:String = CJLang("MONEYTREE_FRIEND_LV");
			myLv = myLv.replace("{name}", data.name);
			myLv = myLv.replace("{level}", data.treelevel);
			this.labLevel.text = myLv;
			
			// 收获按钮是否显示
			this._setBtnShouhuoVisible();
			
			// 重新绘制施肥次数
			this._redrawShifeicishu();
			
			// 重绘经验条
			this._redrawExp();
		}
		
		/**
		 * 根据我的摇钱树数据刷新摇钱树信息
		 * 
		 */		
		private function _redrawTreeInfoWithMyData():void
		{
			this._isMyTree = true;
			
			this.btnYao.visible = true;
//			this.btnYaoPiliang.visible = true;
			this.btnChengzhang.visible = true;
			this.btnShouhuo.visible = true;
			
			this.btnReturnMine.visible = false;
			
			// 设置批量摇钱按钮
//			this._redrawYaoPiliang();	摇10次一直显示
			
			// 摇钱树等级
			var myLv:String = CJLang("MONEYTREE_MY_LV");
			myLv = myLv.replace("{level}", this._dataMTMine.treeLevel);
			this.labLevel.text = myLv;
			
			// 收获按钮是否显示
			this._setBtnShouhuoVisible();
			
			this._setShiFei();
			
			// 重新绘制施肥次数
			this._redrawShifeicishu();
			
			// 重绘经验条
			this._redrawExp();
		}
		
		/**
		 * 设置收获按钮可见与否
		 * 
		 */		
		private function _setBtnShouhuoVisible():void
		{
			if (this._isMyTree == true)
			{
				if (this._dataMTMine.treeLevel - this._dataMTMine.harvestLevel > 0)
				{
					this.btnShouhuo.visible = true;
				}
				else
				{
					this.btnShouhuo.visible = false;
				}
			}
			else
			{
				this.btnShouhuo.visible = false;
			}
		}
		
		/**
		 * 重新绘制好友列表
		 * @param pageNum 当前页数
		 * 
		 */		
		private function _redrawFriendList(pageNum:int):void
		{
			if (this._arrayFriend == null || this._arrayFriend.length != ConstMoneyTree.MONEYTREE_FRIEND_COUNT_PERPAGE)
			{
				this._initControlFriend();
			}
			this._curPageNum = pageNum;
			var friendData:Array = this._dataMTFriend.friendDataArray;
			var friendDataLen:int = friendData.length;
			var friendDataIndex:int = 0;
			var singleData:CJDataOfMoneyTreeSingleFriend;
			
			var friendLayer:CJMoneyTreeFriendLayer;
			for (var i:int = 0; i < ConstMoneyTree.MONEYTREE_FRIEND_COUNT_PERPAGE; i++)
			{
				friendLayer = this._arrayFriend[i] as CJMoneyTreeFriendLayer;
				friendDataIndex = i + ((pageNum - 1) * ConstMoneyTree.MONEYTREE_FRIEND_COUNT_PERPAGE);
				if (friendDataIndex < friendDataLen)
				{
					singleData = friendData[friendDataIndex];
					friendLayer.updateFrameWithData(singleData);
					
					if (this._dataFriend != null)
					{
						if (friendLayer.friendData.uid == this._dataFriend.uid)
						{
							friendLayer.select = true;
						}
					}
				}
				else
				{
					friendLayer.updateFrameWithData(null);
				}
			}
			
			this._pageCount = friendDataLen % ConstMoneyTree.MONEYTREE_FRIEND_COUNT_PERPAGE > 0 ? 
				(friendDataLen / ConstMoneyTree.MONEYTREE_FRIEND_COUNT_PERPAGE + 1) :
				friendDataLen / ConstMoneyTree.MONEYTREE_FRIEND_COUNT_PERPAGE;
			if (this._pageCount == 0)
			{
				this._pageCount = 1;
			}
			this.btnYemaditiao.label = this._curPageNum + "/" + this._pageCount;
			
			this._refreshBtnTurnPage();
		}
		
		/**
		 * 按钮点击 - 关闭
		 * @param event
		 * 
		 */		
		private function _onBtnClickClose(event:Event):void
		{
			//退出模块
			SApplication.moduleManager.exitModule("CJMoneyTreeModule");
		}
		
		private function _refreshBtnTurnPage():void
		{
			if (this._curPageNum <= 1)
			{
				this.btnFriendLeft.isEnabled = false;
			}
			else
			{
				this.btnFriendLeft.isEnabled = true;
			}
			if (this._curPageNum >= this._pageCount)
			{
				this.btnFriendRight.isEnabled = false;
			}
			else
			{
				this.btnFriendRight.isEnabled = true;
			}
		}
		
		/**
		 * 按钮点击 - 好友左
		 * @param event
		 * 
		 */		
		private function _onClickBtnFriendLeft(event:Event):void
		{
			if(this._curPageNum <= 1) 
			{
				return;
			}
			this._curPageNum --;
			this._refreshBtnTurnPage();
			this._redrawFriendList(this._curPageNum);
		}
		
		/**
		 * 按钮点击 - 好友右
		 * @param event
		 * 
		 */		
		private function _onClickBtnFriendRight(event:Event):void
		{
			if(this._curPageNum >= this._pageCount)
			{
				return;
			}
			this._curPageNum++;
			this._refreshBtnTurnPage();
			this._redrawFriendList(this._curPageNum);
		}
		
		/**
		 * 按钮点击 - 摇一摇
		 * @param event
		 * 
		 */		
		private function _onClickBtnYao(event:Event):void
		{
			if (false == this._funcYaoCanUse)
			{
				return;
			}
			// 设置摇钱功能不可用
			this._funcYaoCanUse = false;
			SocketCommand_moneytree.harverstMoneyTreeSliver();
		}
		
		/**
		 * 按钮点击 - 批量摇钱
		 * @param event
		 * 
		 */		
		private function _onClickBtnYaoPiliang(event:Event):void
		{
			if (false == this._funcYaoCanUse)
			{
				return;
			}
			// 设置摇钱功能不可用
			this._funcYaoCanUse = false;
			SocketCommand_moneytree.harverstMoneyTreeSliverPiliang();
		}
		
		/**
		 * 按钮点击 - 成长记录
		 * @param event
		 * 
		 */		
		private function _onClickBtnChengzhang(event:Event):void
		{
			var chengzhangLayer:CJMoneyTreeChengZhangLayer = new CJMoneyTreeChengZhangLayer();
			CJLayerManager.o.addModuleLayer(chengzhangLayer);
		}
		/**
		 * 点击返回我的摇钱树
		 * @param event
		 * 
		 */		
		private function _onClickBtnReturnMine(event:Event):void
		{
			this._mtfSelect.select = false;
			
			this._dataFriend = null;
			this._mtfSelect = null;
			this._redrawTreeInfoWithMyData();
			
		}
		
		/**
		 * 按钮点击 - 一键施肥
		 * @param event
		 * 
		 */		
		private function _onClickBtnShifeiAll(event:Event):void
		{
			SocketCommand_moneytree.feedAllFriendMoneyTree();
		}
		
		/**
		 * 按钮点击 - 左上角施肥
		 * @param event
		 * 
		 */		
		private function _onClickBtnShifei(event:Event):void
		{
			if (this._isMyTree)
			{
				//处理指引
				if(CJDataManager.o.DataOfFuncList.isIndicating)
				{
					CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_INDICATE_NEXT_STEP);
				}
				
				// 我的摇钱树
				if (!_isVipNotCd)
				{
					this.btnShifei.isEnabled = false;
					this._funcShifeiCanUse = false;
				}
				
				SocketCommand_moneytree.feedSelfMoneyTree();
			}
			else
			{
				// 好友的摇钱树
				if (this._dataMTMine.friendFeedTimes >= int(_globalConfig.getData("MONEY_TREE_FRIENDFEEDMAX")))
				{
					CJConfirmMessageBox(CJLang("MONEYTREE_SHIFEI_NOMONEYCHECK"), this._feedFriend);
				}
				else
				{
					this._funcShifeiCanUse = false;
					
					this._feedFriend();
				}
			}
		}
		
		/**
		 * 给好友施肥
		 * 
		 */		
		private function _feedFriend():void
		{
			if (this._dataFriend == null)
			{
				return;
			}
			SocketCommand_moneytree.feedFriendMoneyTree(this._dataFriend.uid);
		}
		
		/**
		 * 播放施肥动画
		 * 
		 */		
		private function _onAnimShowShifei():void
		{
			// TODO，动画文件名，坐标
//			return;
			
			if (true == this._isAnimRunningShifei)
			{
				return;
			}
			
			
			
			this._isAnimRunningShifei = true;
			var animObject:Object = AssetManagerUtil.o.getObject("anim_yaoqianshushifei");
			this.animShifei = SAnimate.SAnimateFromAnimJsonObject(animObject);
			this.animShifei.addEventListener(Event.COMPLETE, _onAimCompleteShifei);
			this.animShifei.x = 70;
			this.animShifei.y = 17;
			this.operateLayer.addChild(this.animShifei);
			
			Starling.juggler.add(animShifei);
			animShifei.gotoAndPlay();
			
//			this.stShifei = new STween(this.animShifei, 2, Transitions.LINEAR);
//			stShifei.moveTo(this.animShifei.x + 80, this.animShifei.y);
//			stShifei.onComplete = function():void
//			{
//				Starling.juggler.remove(this.stShifei);
//				this.stShifei = null;
//				
//				
//			}
//			Starling.juggler.add(stShifei);
			
			
		}
		
		/**
		 * 施肥动画播放完毕
		 * @param event
		 * 
		 */		
		private function _onAimCompleteShifei(event:Event):void
		{
			this.animShifei.removeFromParent(true);
			this.animShifei.removeFromJuggler();
			this.animShifei.removeEventListener(Event.COMPLETE, _onAimCompleteShifei);
			this.animShifei = null;
			
			
			// 设置摇钱功能可用
			this._funcShifeiCanUse = true;
			this._isAnimRunningShifei = false;
		}
		
		/**
		 * 显示树摇动画
		 * 
		 */		
		private function _onAnimShowYao():void
		{
			if (true == this._isAnimRunningYao)
			{
				return;
			}
			this._isAnimRunningYao = true;
			
			var animObject:Object = AssetManagerUtil.o.getObject("anim_yaoqianshuyao");
			this.animTreeYao = SAnimate.SAnimateFromAnimJsonObject(animObject);
			this.animTreeYao.addEventListener(Event.COMPLETE, _onAimCompleteYao);
			this.animTreeYao.x = 15;
			this.animTreeYao.y = 17;
			this.animTreeYao.width = 201;
			this.animTreeYao.height = 175;
			this.operateLayer.addChild(this.animTreeYao);
			this.animTreeYao.gotoAndPlay();
			Starling.juggler.add(this.animTreeYao);
		}
		/**
		 * 摇钱动画播放完毕
		 * @param event
		 * 
		 */		
		private function _onAimCompleteYao(event:Event):void
		{
			this.animTreeYao.removeFromParent(true);
			this.animTreeYao.removeFromJuggler();
			this.animTreeYao.removeEventListener(Event.COMPLETE, _onAimCompleteYao);
			this.animTreeYao = null;
			
			// 设置摇钱功能可用
			this._funcYaoCanUse = true;
			this._isAnimRunningYao = false;
		}
		
		/**
		 * 按钮点击 - 左上角收获
		 * @param event
		 * 
		 */		
		private function _onClickBtnShouhuo(event:Event):void
		{
			//处理指引
			if(CJDataManager.o.DataOfFuncList.isIndicating)
			{
				CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_INDICATE_NEXT_STEP);
			}
			
			var harvestLayer:CJMoneyTreeHarvestLayer = new CJMoneyTreeHarvestLayer();
			CJLayerManager.o.addModuleLayer(harvestLayer);
		}
		
		/**
		 * 初始化数据
		 * 
		 */		
		private function _initData():void
		{
			// 配置数据
			this._moneyTreeConfig = CJDataOfMoneyTreeProperty.o;
			this._globalConfig = CJDataOfGlobalConfigProperty.o;
			
			
			// 服务器数据
			this._dataMTMine = CJDataManager.o.getData("CJDataOfMoneyTreeMine") as CJDataOfMoneyTreeMine;
			this._dataMTFriend = CJDataManager.o.getData("CJDataOfMoneyTreeFriend") as CJDataOfMoneyTreeFriend;
			this._dataRole = CJDataManager.o.getData("CJDataOfRole") as CJDataOfRole;
			
			this._dataMTMine.addEventListener(DataEvent.DataLoadedFromRemote , this._onDataLoadedMoneyTreeMine);
			this._dataMTFriend.addEventListener(DataEvent.DataLoadedFromRemote , this._onDataLoadedMoneyTreeFriend);
			this._dataRole.addEventListener(DataEvent.DataChange , this._onDataLoadedRole);
			
			// 我的摇钱树数据
//			if (this._dataMTMine.dataIsEmpty)
//			{
//				this._dataMTMine.loadFromRemote();
//			}
//			else
//			{
//				this._onDataLoadedMoneyTreeMine();
//			}
			this._dataMTMine.loadFromRemote();
			
			// 好友的摇钱树数据
//			if (this._dataMTFriend.dataIsEmpty)
//			{
//				this._dataMTFriend.loadFromRemote();
//			}
//			else
//			{
//				this._onDataLoadedMoneyTreeFriend();
//			}
			this._dataMTFriend.loadFromRemote();
			
//			this._vecFriend = new Vector.<CJMoneyTreeFriendLayer>;
			
			var vipLv:int = CJDataManager.o.DataOfRole.vipLevel;
			var vipCfg:Json_vip_function_setting = CJDataOfVipFuncSetting.o.getData(String(vipLv));
			if (int(vipCfg.mt_nowatercd))
			{
				_isVipNotCd = true;
			}
			
		}
		
		/**
		 * 接收到我的摇钱树数据
		 * 
		 */		
		private function _onDataLoadedMoneyTreeMine():void
		{
			this._dataInitMTMine = true;
			
			// TODO 当我的摇钱树等级为0时，赋值为1，目前为临时解决
			if (this._dataMTMine.treeLevel == 0)
			{
				this._dataMTMine.treeLevel = 1;
			}
			
			// 设置收获按钮显示状态
			this._setBtnShouhuoVisible();
			
			// 重新绘制摇钱树花费富文本
			this._redrawCost();
			
			// 重新绘制施肥次数
			this._redrawShifeicishu();
			
			// 设置施肥按钮与冷却时间
			this._setShiFei();
			
			// 重绘经验条
			this._redrawExp();
		}
		
		/**
		 * 重绘一键施肥
		 * 
		 */		
		private function _redrawFeedAll():void
		{
//			var feedAllLv:int = int(_globalConfig.getData("MONEY_TREE_VIPLEVELFEEDALL"));
//			if (this._dataRole.vipLevel >= feedAllLv)
			// VIP	// 成功率
			var vipLv:int = CJDataManager.o.DataOfRole.vipLevel;
			var vipConf:Json_vip_function_setting = CJDataOfVipFuncSetting.o.getData(String(vipLv));
			if(int(vipConf.mt_quickwater))
			{
				this.btnShifeiAll.visible = true;
				this.tfFeedAllDesc.visible = false;
			}
			else
			{
				this.btnShifeiAll.visible = false;
				this.tfFeedAllDesc.visible = true;
			}
		}
		
		/**
		 * 重绘批量摇钱按钮
		 * 
		 */		
//		private function _redrawYaoPiliang():void
//		{
//			if (this._dataRole.vipLevel > 0)
//			{
//				this.btnYaoPiliang.visible = true;
//			}
//			else
//			{
//				this.btnYaoPiliang.visible = false;
//			}
//		}
		
		/**
		 * 重绘施肥按钮
		 * 
		 */		
//		private function _redrawBtnShifei():void
//		{
//			if (this._isMyTree)
//			{
//				if (this._dataMTMine.leftFeedTimes > 0)
//				{
//					this.btnShifei.visible = true;
//					this.btnShifei.isEnabled = true;
//					this._timeLayer.visible = true;
//				}
//				else
//				{
//					this.btnShifei.visible = false;
//					this._timeLayer.visible = false;
//				}
//			}
//			else
//			{
//				this._labShifeici.text = "";
//			}
//		}
		/**
		 * 重新绘制施肥次数
		 * 
		 */		
		private function _redrawShifeicishu():void
		{
			if (this._isMyTree)
			{
				if (this._dataMTMine.leftFeedTimes > 0)
				{
					this._labShifeici.text = "x" + this._dataMTMine.leftFeedTimes;
				}
				else
				{
					this._labShifeici.text = "";
				}
			}
			else
			{
				this._labShifeici.text = "";
			}
		}
		
		/**
		 * 初始化绘制
		 * @return 
		 * 
		 */		
		private function _initDraw():void
		{
			this._redrawFeedAll();
//			this._redrawYaoPiliang();	// 摇10次一直显示
//			this._redrawShifeicishu();
			this._redrawExp();
		}
		
		/**
		 * 重绘经验条
		 * 
		 */		
		private function _redrawExp():void
		{
			var maxValue:int = 0;
			var curExp:int = 0;
			var cfg:Json_money_tree_setting;
			if (this._isMyTree == true)
			{
				//  我的摇钱树
				if (false == this._dataInitMTMine)
				{
					return;
				}
				cfg = this._moneyTreeConfig.getConfig(this._dataMTMine.treeLevel);
				curExp = this._dataMTMine.exp;
				maxValue = int(cfg.exp);
				this.labExp.text = curExp + "/" + cfg.exp;
			}
			else
			{
				// 好友的摇钱树
				if (false == this._dataInitMTFriend)
				{
					return;
				}
				cfg = this._moneyTreeConfig.getConfig(this._dataFriend.treelevel);
				curExp = this._dataFriend.exp;
				maxValue = int(cfg.exp);
				this.labExp.text = curExp + "/" + cfg.exp;
			}
			
			this.pbExp.minimum = 0;
			this.pbExp.maximum = maxValue;
			this.pbExp.value = curExp;
			
			if (curExp > 0)
			{
				this.pbExp.visible = true;
			}
			else
			{
				this.pbExp.visible = false;
			}
		}
		
		/**
		 * 重新绘制摇钱树花费富文本
		 * 
		 */		
		private function _redrawCost():void
		{
			// 文字 - 等级
			var myLv:String = CJLang("MONEYTREE_MY_LV");
			myLv = myLv.replace("{level}", this._dataMTMine.treeLevel);
			this.labLevel.text = myLv;
			
			var mtCfg:Json_money_tree_setting = _moneyTreeConfig.getConfig(this._dataMTMine.treeLevel);
			
			var arrayRt:Array = new Array();
			
			// 花费
			var rtLabel:CJRTElementLabel = new CJRTElementLabel();
			rtLabel.height = 11;
			rtLabel.color = 0xFFFFFF;
			rtLabel.font = ConstTextFormat.FONT_FAMILY_HEITI;
			rtLabel.size = 10;
			rtLabel.text = CJLang("MONEYTREE_COST_0");
			arrayRt.push(rtLabel);
			
			// 元宝数量
			var cost:int = (this._dataMTMine.harvestTimes);		// 摇钱需要金币0,1,2,3...20,20,20
//			var cost:int = (this._dataMTMine.harvestTimes + 1) + ((this._dataMTMine.harvestTimes + 1) % 2);	// 摇钱需要金币2,2,4,4,6,6...20,20,20
			var max:int = int(_globalConfig.getData("MONEY_TREE_GOLDMAX"));
			cost = cost > max ? max : cost;
			
			rtLabel = new CJRTElementLabel();
			rtLabel.height = 11;
			rtLabel.color = 0xFFE039;
			rtLabel.font = ConstTextFormat.FONT_FAMILY_HEITI;
			rtLabel.size = 10;
			rtLabel.text = String(cost);
			rtLabel.spacex = 4;
			arrayRt.push(rtLabel);
			
			// 元宝图片
			var rtImage:CJRTElementImage = new CJRTElementImage();
			rtImage.height = 11;
			rtImage.width = 15;
			rtImage.textture = "common_yuanbao";
			rtImage.spacex = 4;
			rtImage.spacey = 2;
			arrayRt.push(rtImage);
			
			// 文字 - 摇钱，可收获
			rtLabel = new CJRTElementLabel();
			rtLabel.height = 11;
			rtLabel.color = 0xFFFFFF;
			rtLabel.font = ConstTextFormat.FONT_FAMILY_HEITI;
			rtLabel.size = 10;
			rtLabel.text = CJLang("MONEYTREE_COST_1");
//			rtLabel.spacex = 2;
			arrayRt.push(rtLabel);
			
			// 文字 - 获得银两
			rtLabel = new CJRTElementLabel();
			rtLabel.height = 11;
			rtLabel.color = 0xFFE039;
			rtLabel.font = ConstTextFormat.FONT_FAMILY_HEITI;
			rtLabel.size = 10;
			rtLabel.text = mtCfg.basesliver;
			rtLabel.spacex = 4;
			arrayRt.push(rtLabel);
			
			// 银两图片
			rtImage = new CJRTElementImage();
			rtImage.height = 11;
			rtImage.width = 15;
			rtImage.textture = "common_yinliang";
			rtImage.spacex = 4;
			rtImage.spacey = 2;
			arrayRt.push(rtImage);
			
			this._initRichText();
			this.rtCost.draWithElementArray(arrayRt);
		}
		
		private function _onDataLoadedRole(e:Event):void
		{
			labGoldCount.text = String(_dataRole.gold);
			labSilverCount.text = String(_dataRole.silver);
		}
		/**
		 * 接收到好友的摇钱树数据
		 * 
		 */		
		private function _onDataLoadedMoneyTreeFriend():void
		{
			this._dataInitMTFriend = true;
			
			_redrawFriendList(this._curPageNum);
			
			if (false == this._isMyTree)
			{
				// 显示摇钱树为好友摇钱树
				this._dataFriend = this._mtfSelect.friendData;
				this._redrawTreeInfoWithFriendData(this._dataFriend);
			}
		}
		
//		/**
//		 * 选中好友
//		 * @param index
//		 * @param dataFriend
//		 * 
//		 */		
//		public function selectFriend(index:int, dataFriend:CJDataOfMoneyTreeSingleFriend):void
//		{
//			
//		}
		
		/**
		 * 接收到服务器端数据
		 * @param e
		 * 
		 */		
		private function _onDataLoaded(e:Event):void
		{
//			if (e.target is CJDataOfHeroList)
//			{
//				this._dataHeroListInit = true;
//				this._onDataLoadedHeroList();
//			}
//			this._redraw();
		}
		
		
		
		
		/**
		 * RPC返回响应
		 * @param e
		 * 
		 */		
		private function _onRpcReturn(e:Event):void
		{
			var msg:SocketMessage = e.data as SocketMessage;
			if(msg.getCommand() == ConstNetCommand.CS_MONEYTREE_FEEDFRIENDMONEYTREE)
			{
				// 给好友施肥
				this._rpcReturnHandleFeedFriend(msg);
			}
			else if (msg.getCommand() == ConstNetCommand.CS_MONEYTREE_FEEDALLFRIENDMONEYTREE)
			{
				// 给所有好友施肥
				this._rpcReturnHandleFeefAllFriend(msg);
			}
			else if (msg.getCommand() == ConstNetCommand.CS_MONEYTREE_FEEDSELFMONEYTREE)
			{
				// 给我的树施肥
				
				this._rpcReturnHandleFeefMine(msg);
			}
			else if (msg.getCommand() == ConstNetCommand.CS_MONEYTREE_HARVERSTMONEYTREESLIVER)
			{
				// 摇一摇, 批量摇
				this._rpcReturnHandleHarvestSliver(msg);
			}
			else if (msg.getCommand() == ConstNetCommand.CS_MONEYTREE_HARVERSTMONEYTREELEVEL)
			{
				// 收获
				this._rpcReturnHandlerHarvestLevel(msg);
			}
		}
		/**
		 * RPC返回结果处理 - 收获
		 * @param msg
		 * 
		 */		
		private function _rpcReturnHandlerHarvestLevel(msg:SocketMessage):void
		{
			if (msg.retcode == 0)
			{
				var retData:Object = msg.retparams;
				var isSucc:Boolean = retData[0];
				if (!isSucc)
				{
					return;
				}
//				var addSliver:int = int(retData[1]);
//				var addGold:int = int(retData[2]);
//				var str:String = "";
//				if (addSliver > 0)
//				{
//					str += CJLang("CURRENCY_NAME_SILVER") + " +" + String(addSliver);
//				}
//				if (addGold > 0)
//				{
//					str += ", " + CJLang("CURRENCY_NAME_GOLD") + " +" + String(addGold);
//				}
//				this._showPiaozi(str);
				
				// 获取我的摇钱树信息，更新我的收获信息等
				SocketCommand_moneytree.getSelfMoneyTreeInfo();
			}
		}
		/**
		 * RPC返回结果处理 - 摇一摇, 批量摇
		 * @param msg
		 * 
		 */		
		private function _rpcReturnHandleHarvestSliver(msg:SocketMessage):void
		{
			if (msg.retcode == 0)
			{
				// 摇钱树摇一摇
				var retData:Object = msg.retparams;
				var isSucc:Boolean = retData[0];
				if (!isSucc)
				{
					return;
				}
				
				// 播放树摇动动画
				this._onAnimShowYao();
				
				var costGold:int = int(retData[1]);
				var sliver:int = int(retData[2]);
				var crittime:int = int(retData[3]);
				
				// 飘字
				var str:String = "";
				var color:int = 0xFFFFFF;
				if (crittime > 0)
				{
					// 暴击
					str = CJLang("MONEYTREE_YAO_PIAOZI_BAOJI");
					color = 0xB4FF52;
				}
				else
				{
					// 普通摇钱
					str = CJLang("MONEYTREE_YAO_PIAOZI");
				}
				str = str.replace("{money}", String(sliver));
				this._showPiaozi(str, color);
				
				// 活跃度
				CJDataManager.o.activityManager.dispatchEventWith(CJEvent.EVENT_ACTIVITY_HAPPEN , false, {"key":CJActivityEventKey.ACTIVITY_MONEYTREESHAKE});
				
				// 请求服务器更新货币信息
				SocketCommand_role.get_role_info();
				
				// 获取我的摇钱树信息
				SocketCommand_moneytree.getSelfMoneyTreeInfo();
				
				// 更新摇一摇说明
//				this._redrawCost();
			}
			else if (msg.retcode == 2)
			{
				// 元宝不足
				this._showPiaozi(CJLang("MONEYTREE_YAO_NOTENOUGHMONEY"));
				this._funcYaoCanUse = true;
			}
			else if (msg.retcode == 3)
			{
				// 不具备高级功能
				this._funcYaoCanUse = true;
			}
			else
			{
				this._funcYaoCanUse = true;
			}
		}
		
		/**
		 * 修改冷却结束时间
		 * 
		 */		
		private function _modifyCoolDownTime():void
		{
			var date:Date = new Date();
			var coolDownEnd:Number = date.time + (COOL_TIME_SHIFEI*1000);
			this._dataMTMine.cooldownEnd = coolDownEnd;
		}
		
		/**
		 * 设置施肥按钮与剩余时间
		 * 
		 */		
		private function _setShiFei():void
		{
			if (this._isMyTree)
			{
				// 我的摇钱树
				var cooldownEndTime:Number = this._dataMTMine.cooldownEnd;
				var leftTime:int = 0;
				if (cooldownEndTime > 0)
				{
					leftTime = (cooldownEndTime - (new Date()).time) / 1000;
					if (leftTime > 0)
					{
						// 冷却中
						if (this._dataMTMine.leftFeedTimes > 0)
						{
							// 有剩余施肥次数
							this.timeLayer.setTimeAndRun(leftTime, this._onReachTimeShifei);
							this.btnShifei.isEnabled = false;
							this.btnShifei.visible = true;
						}
						else
						{
							// 没有剩余施肥次数
							this.timeLayer.visible = false;
							this.btnShifei.visible = false;
						}
					}
					else
					{
						// 非冷却
						this.timeLayer.visible = false;
						if (this._dataMTMine.leftFeedTimes > 0)
						{
							// 有剩余施肥次数
							this.btnShifei.isEnabled = true;
							this.btnShifei.visible = true;
						}
						else
						{
							// 没有剩余施肥次数
							this.btnShifei.visible = false;
						}
					}
				}
				else
				{
					var nextFeedTime:Number = this._dataMTMine.nextFeedTime;
					var nowTime:Number = this._getTime() + (8 * 60 * 60 * 1000);
					leftTime = nextFeedTime - (nowTime / 1000);
					if (leftTime > 0)
					{
						// 冷却中
						if (leftTime > COOL_TIME_SHIFEI)
						{
							leftTime = COOL_TIME_SHIFEI;
						}
						if (this._dataMTMine.leftFeedTimes > 0)
						{
							// 有剩余施肥次数
							this.timeLayer.setTimeAndRun(leftTime, this._onReachTimeShifei);
							this.btnShifei.isEnabled = false;
							this.btnShifei.visible = true;
						}
						else
						{
							// 没有剩余施肥次数
							this.timeLayer.visible = false;
							this.btnShifei.visible = false;
						}
					}
					else
					{
						// 非冷却中
						this.timeLayer.visible = false;
						if (this._dataMTMine.leftFeedTimes > 0)
						{
							// 有剩余施肥次数
							this.btnShifei.isEnabled = true;
							this.btnShifei.visible = true;
						}
						else
						{
							// 没有剩余施肥次数
							this.btnShifei.visible = false;
						}
					}
				}
			}
			else
			{
				// 好友的摇钱树
				this.timeLayer.visible = false;
				if (this._dataFriend != null)
				{
					if (this._dataFriend.canfeed == true)
					{
//						this.btnShifei.isEnabled = true;
						this.btnShifei.visible = true;
					}
					else
					{
//						this.btnShifei.isEnabled = false;
						this.btnShifei.visible = false;
					}
				}
			}
		}
		
		private function _getTime():Number
		{
			var date:Date = new Date()
			return date.time;
		}
		
		/**
		 * RPC返回结果处理 - 给我的树施肥
		 * @param msg
		 * @return 
		 * 
		 */		
		private function _rpcReturnHandleFeefMine(msg:SocketMessage):void
		{
			if (msg.retcode == 0)
			{
				// vip cd
				if (!_isVipNotCd)
				{
					// 记录冷却结束时间
					this._modifyCoolDownTime();
				}
				else
				{
					var date:Date = new Date();
					var coolDownEnd:Number = date.time - 1;
					this._dataMTMine.cooldownEnd = coolDownEnd;
				}
					
				
				
				// 施肥成功
				var retData:Object = msg.retparams;
				var isSucc:Boolean = retData[0];
				if (!isSucc)
				{
					return;
				}
				
				// 播放施肥动画
				this._onAnimShowShifei();
				
				var sliver:int = int(retData[1]);
				var exp:int = int(retData[2]);
				var lvUp:Boolean = Boolean(retData[3]);
				if (lvUp)
				{
					var _animate:SAnimate = new SAnimate(SApplication.assets.getTextures(ConstResource.sResUplevelAnims));
					_animate.pivotX = -9;
					_animate.pivotY = -19;
					_animate.scaleX = _animate.scaleY = 1.5;
					_animate.addEventListener(Event.COMPLETE , function(e:Event):void
					{
						if(e.target is SAnimate)
						{
							_animate.removeFromParent();
							_animate.removeFromJuggler();
							
							CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_STAGE_LEVEL_IMAGE_COMPLETE);
						}
					});
					Starling.juggler.add(_animate);
					_animate.gotoAndPlay();
					addChild(_animate);
				}
				if ((this._dataMTMine.leftFeedTimes - 1) > 0)
				{
					 // 施肥后, 还有剩余施肥次数
					if (!_isVipNotCd)
					{
						this.timeLayer.setTimeAndRun(this.COOL_TIME_SHIFEI, this._onReachTimeShifei);
						this.btnShifei.isEnabled = false;
					}
				}
				else
				{
					// 施肥后, 剩余施肥次数为0
					this.btnShifei.visible = false;
					this._timeLayer.visible = false;
					this._labShifeici.text = "";
				}
				
				// 活跃度
				CJDataManager.o.activityManager.dispatchEventWith(CJEvent.EVENT_ACTIVITY_HAPPEN , false, {"key":CJActivityEventKey.ACTIVITY_MONEYTREEMANURE});
				
				// 请求服务器更新货币信息
				SocketCommand_role.get_role_info();
				
				// 获取我的摇钱树信息，更新我的施肥次数等
				SocketCommand_moneytree.getSelfMoneyTreeInfo();
			}
			else if (msg.retcode == 1)
			{
				// 没有施肥次数
				CJMessageBox(CJLang("MONEYTREE_ALERT_CISHU"));
				this._funcShifeiCanUse = true;
			}
			else if (msg.retcode == 2)
			{
				// 冷却
				CJMessageBox(CJLang("MONEYTREE_ALERT_LENGQUE"));
				this._funcShifeiCanUse = true;
			}
			else if (msg.retcode == 3)
			{
				// 不能超过玩家等级
				CJMessageBox(CJLang("MONEYTREE_LV_NOTMORETHANPLAYER"));
				this._funcShifeiCanUse = true;
				this.btnShifei.isEnabled = true;
			}
			else
			{
				this._funcShifeiCanUse = true;
			}
		}
		
		/**
		 * 施肥冷却时间到
		 * 
		 */		
		private function _onReachTimeShifei():void
		{
			if (_isMyTree)
			{
				if (this._dataMTMine.leftFeedTimes > 0)
				{
					// 有剩余施肥次数
					this.btnShifei.isEnabled = true;
				}
			}
		}
		
		/**
		 * RPC返回结果处理 - 给所有好友施肥
		 * @param msg
		 * @return 
		 * 
		 */		
		private function _rpcReturnHandleFeefAllFriend(msg:SocketMessage):void
		{
			if (msg.retcode == 0)
			{
				// 施肥成功
				var retData:Object = msg.retparams;
				var isSucc:Boolean = retData[0];
				if (!isSucc)
				{
					return;
				}
				var sliver:int = int(retData[1]);
				var exp:int = int(retData[2]);
				
				if (sliver > 0)
				{
					var string:String = CJLang("MONEYTREE_SHIFEI_CHENGGONG");
					string = string.replace("{money}", String(sliver));
					this._showPiaozi(string);
				}
				else
				{
					var sPiaozi:String = CJLang("MONEYTREE_SHIFEI_CHENGGONGNOMONEY");
					this._showPiaozi(sPiaozi);
				}
				
				// 设置所有好友数据不可施肥
				this._dataMTFriend.setAllFriendCanNotFeed();
				// 显示页面上设置所有好友不可施肥
				for each (var layerFriend:CJMoneyTreeFriendLayer in this._arrayFriend)
				{
					layerFriend.setCanFeed(false);
				}
				// 请求服务器更新货币信息
				SocketCommand_role.get_role_info();
				
				// 获取我的摇钱树信息，更新给好友施肥次数
				SocketCommand_moneytree.getSelfMoneyTreeInfo();
			}
			this._funcShifeiCanUse = true;
		}
		/**
		 * RPC返回结果处理 - 给好友施肥
		 * @param msg
		 * @return 
		 * 
		 */		
		private function _rpcReturnHandleFeedFriend(msg:SocketMessage):void
		{
			if (msg.retcode == 0)
			{
				// 好友施肥
				var retData:Object = msg.retparams;
				var feedResult:Boolean = retData[0];
				if (!feedResult)
				{
					return;
				}
				var sliver:int = int(retData[1]);
				
				// 飘字
				var string:String = CJLang("MONEYTREE_SHIFEI_CHENGGONG");
				string = string.replace("{money}", String(sliver));
				this._showPiaozi(string);
				
				// 播放施肥动画
				this._onAnimShowShifei();
				
				if (this._isMyTree)
				{
					return;
				}
				var friendUid:String = String(retData[3]);
				
//				// 增加对好友施肥次数
//				this._dataMTMine.friendFeedTimes += 1;
				
				// 设置客户端好友可施肥数据
				this._dataMTFriend.setFriendCanFeed(friendUid, false);
				if (this._dataFriend.uid != friendUid)
				{
					// 当前选中非该好友, 遍历当页好友列表, 设置不可施肥
					for each (var layerFriend:CJMoneyTreeFriendLayer in this._arrayFriend)
					{
						if (layerFriend.friendData.uid == friendUid)
						{
							layerFriend.setCanFeed(false)
							break;
						}
					}
					return;
				}
				// 当前好友是该好友
//				this.btnShifei.isEnabled = false;
				this.btnShifei.visible = false;
				this._dataFriend.canfeed = false;
				this._mtfSelect.setCanFeed(false);
				
				// 活跃度
				CJDataManager.o.activityManager.dispatchEventWith(CJEvent.EVENT_ACTIVITY_HAPPEN , false, {"key":CJActivityEventKey.ACTIVITY_MONEY_TREE_MANURE_FRIEND});
				
				// 请求服务器更新货币信息
				SocketCommand_role.get_role_info();
				
				// 获取我的摇钱树信息，更新好友施肥次数
				SocketCommand_moneytree.getSelfMoneyTreeInfo();
				
				// 获取好友摇钱树信息，更新好友摇钱树经验、等级
				SocketCommand_moneytree.getFriendMoneyTreeInfo();
			}
		}
		
		/**
		 * 飘字
		 * @param str 飘字内容
		 * 
		 */		
		private function _showPiaozi(str:String, color:int = 0xFFFFFF):void
		{
			var seccessLabel:Label = new Label();
			seccessLabel.text = str;
			seccessLabel.textRendererProperties.textFormat = new TextFormat( ConstTextFormat.FONT_FAMILY_HEITI, 13, color, null, null, null, null, null, TextFormatAlign.CENTER);
			seccessLabel.x = 0;
			seccessLabel.y = (SApplicationConfig.o.stageHeight - seccessLabel.height) / 2 - this.y;
			seccessLabel.width = SApplicationConfig.o.stageWidth;
			var textTween:STween = new STween(seccessLabel, 2, Transitions.LINEAR);
			textTween.moveTo(seccessLabel.x, seccessLabel.y- 50);
			
			textTween.onComplete = function():void
			{
				Starling.juggler.remove(textTween);
				seccessLabel.removeFromParent(true);
			}
			this.addChild(seccessLabel);
			Starling.juggler.add(textTween);
		}
		
		override public function dispose():void
		{
			removeAllEventListener();
			Starling.juggler.remove(this.animTree);
			super.dispose();
		}
		
		/** controls */
		/** 货币层 */
		private var _moneyLayer:SLayer;
		/** 文字 - 拥有数量 */
		private var _labHasCount:Label;
		/** 文字 - 元宝数量 */
		private var _labGoldCount:Label;
		/** 文字 - 银两数量 */
		private var _labSilverCount:Label;
		
		/** 操作层 */
		private var _operateLayer:SLayer;
		/** 按钮 - 摇一摇 */
		private var _btnYao:Button;
		/** 按钮 - 批量摇钱 */
		private var _btnYaoPiliang:Button;
		/** 按钮 - 成长记录 */
		private var _btnChengzhang:Button;
		/** 按钮 - 一键施肥 */
		private var _btnShifeiAll:Button;
		/** 按钮 - 好友左 */
		private var _btnFriendLeft:Button;
		/** 按钮 - 好友右 */
		private var _btnFriendRight:Button;
		/** 按钮 - 施肥 */
		private var _btnShifei:Button;
		/** 按钮 - 收获 */
		private var _btnShouhuo:Button;
		
		/** 文字 - 等级*/
		private var _labLevel:Label;
		/** 文字 - 摇提示*/
		private var _labTishiYao:Label;
		/** 文字 - 倒计时 */
		private var _labTime:Label;
		/** 文字 - 施肥次数 */
		private var _labShifeici:Label;
		/** 文字 - 玩家*/
		private var _labWanjia:Label;
		/** 文字 - 阵营*/
		private var _labZhenying:Label;
		/** 文字 - 等级*/
		private var _labDengji:Label;
		/** 文字 - 状态*/
		private var _labZhuangtai:Label;
		/** 富文本 - 花费与奖励 */
		private var _rtCost:CJRichText;
		/** 文字 - 一键施肥 */
		private var _tfFeedAllDesc:TextField;
		/** 按钮 - 返回我的摇钱树 */
		private var _btnReturnMine:Button;
		/** 动画 - 摇钱树 */
		private var _animTree:SAnimate;
		/** 动画 - 摇钱树摇 */
		private var _animTreeYao:SAnimate;
		/** 动画 - 施肥 */
		private var _animShifei:SAnimate;
		private var _stShifei:STween;
		/** 页码 */
		private var _btnYemaditiao:Button;
		/** 等级背景图片 */
		private var _imgTreeLvBg:ImageLoader;
		/** 文字 - 页码 */
		private var _labPage:Label;
		
		private var _timeLayer:CJMoneyTreeTimeLayer;
		/** 关闭按钮 */
		private var _btnClose:Button
		/** 文字 - 经验 */
		private var _labJingyan:Label;
		/** 文字 - 摇钱树经验值 */
		private var _labExp:Label;
		/** 图片 - 经验值底图 */
		private var _imgExpDi:Scale3Image;
		/** 图片 - 经验值 */
		private var _pbExp:ProgressBar;
		
		/** setter */
		public function set moneyLayer(value:SLayer):void
		{
			this._moneyLayer = value;
		}
		public function set labHasCount(value:Label):void
		{
			this._labHasCount = value;
		}
		public function set labGoldCount(value:Label):void
		{
			this._labGoldCount = value;
		}
		public function set labSilverCount(value:Label):void
		{
			this._labSilverCount = value;
		}
		public function set operateLayer(value:SLayer):void
		{
			this._operateLayer = value;
		}
		public function set btnYao(value:Button):void
		{
			this._btnYao = value;
		}
		public function set btnYaoPiliang(value:Button):void
		{
			this._btnYaoPiliang = value;
		}
		public function set btnChengzhang(value:Button):void
		{
			this._btnChengzhang = value;
		}
		public function set btnShifeiAll(value:Button):void
		{
			this._btnShifeiAll = value;
		}
		public function set btnFriendLeft(value:Button):void
		{
			this._btnFriendLeft = value;
		}
		public function set btnFriendRight(value:Button):void
		{
			this._btnFriendRight = value;
		}
		public function set btnShifei(value:Button):void
		{
			this._btnShifei = value;
		}
		public function set btnShouhuo(value:Button):void
		{
			this._btnShouhuo = value;
		}
		public function set labLevel(value:Label):void
		{
			this._labLevel = value;
		}
		public function set labTishiYao(value:Label):void
		{
			this._labTishiYao = value;
		}
		public function set labTime(value:Label):void
		{
			this._labTime = value;
		}
		public function set labShifeici(value:Label):void
		{
			this._labShifeici = value;
		}
		public function set labWanjia(value:Label):void
		{
			this._labWanjia = value;
		}
		public function set labZhenying(value:Label):void
		{
			this._labZhenying = value;
		}
		public function set labDengji(value:Label):void
		{
			this._labDengji = value;
		}
		public function set labZhuangtai(value:Label):void
		{
			this._labZhuangtai = value;
		}
		public function set rtCost(value:CJRichText):void
		{
			this._rtCost = value;
		}
		public function set tfFeedAllDesc(value:TextField):void
		{
			this._tfFeedAllDesc = value;
		}
		public function set btnReturnMine(value:Button):void
		{
			this._btnReturnMine = value;
		}
		public function set animTree(value:SAnimate):void
		{
			this._animTree = value;
		}
		public function set animTreeYao(value:SAnimate):void
		{
			this._animTreeYao = value;
		}
		public function set animShifei(value:SAnimate):void
		{
			this._animShifei = value;
		}
		public function set stShifei(value:STween):void
		{
			this._stShifei = value;
		}
		public function set btnYemaditiao(value:Button):void
		{
			this._btnYemaditiao = value;
		}
		public function set imgTreeLvBg(value:ImageLoader):void
		{
			this._imgTreeLvBg = value;
		}
		public function set labPage(value:Label):void
		{
			this._labPage = value;
		}
		public function set timeLayer(value:CJMoneyTreeTimeLayer):void
		{
			this._timeLayer = value;
		}
		public function set btnClose(value:Button):void
		{
			this._btnClose = value;
		}
		public function set labJingyan(value:Label):void
		{
			this._labJingyan = value;
		}
		public function set labExp(value:Label):void
		{
			this._labExp = value;
		}
		public function set imgExpDi(value:Scale3Image):void
		{
			this._imgExpDi = value;
		}
		public function set pbExp(value:ProgressBar):void
		{
			this._pbExp = value;
		}
		
		/** getter */
		public function get moneyLayer():SLayer
		{
			return this._moneyLayer;
		}
		public function get labHasCount():Label
		{
			return this._labHasCount;
		}
		public function get labGoldCount():Label
		{
			return this._labGoldCount;
		}
		public function get labSilverCount():Label
		{
			return this._labSilverCount;
		}
		public function get operateLayer():SLayer
		{
			return this._operateLayer;
		}
		public function get btnYao():Button
		{
			return this._btnYao;
		}
		public function get btnYaoPiliang():Button
		{
			return this._btnYaoPiliang;
		}
		public function get btnChengzhang():Button
		{
			return this._btnChengzhang;
		}
		public function get btnShifeiAll():Button
		{
			return this._btnShifeiAll;
		}
		public function get btnFriendLeft():Button
		{
			return this._btnFriendLeft;
		}
		public function get btnFriendRight():Button
		{
			return this._btnFriendRight;
		}
		public function get btnShifei():Button
		{
			return this._btnShifei;
		}
		public function get btnShouhuo():Button
		{
			return this._btnShouhuo;
		}
		public function get labLevel():Label
		{
			return this._labLevel;
		}
		public function get labTishiYao():Label
		{
			return this._labTishiYao;
		}
		public function get labTime():Label
		{
			return this._labTime;
		}
		public function get labShifeici():Label
		{
			return this._labShifeici;
		}
		public function get labWanjia():Label
		{
			return this._labWanjia;
		}
		public function get labZhenying():Label
		{
			return this._labZhenying;
		}
		public function get labDengji():Label
		{
			return this._labDengji;
		}
		public function get labZhuangtai():Label
		{
			return this._labZhuangtai;
		}
		public function get rtCost():CJRichText
		{
			return this._rtCost;
		}
		public function get tfFeedAllDesc():TextField
		{
			return this._tfFeedAllDesc;
		}
		public function get btnReturnMine():Button
		{
			return this._btnReturnMine;
		}
		public function get animTree():SAnimate
		{
			return this._animTree;
		}
		public function get animTreeYao():SAnimate
		{
			return this._animTreeYao;
		}
		public function get animShifei():SAnimate
		{
			return this._animShifei;
		}
		public function get stShifei():STween
		{
			return this._stShifei;
		}
		public function get btnYemaditiao():Button
		{
			return this._btnYemaditiao;
		}
		public function get imgTreeLvBg():ImageLoader
		{
			return this._imgTreeLvBg;
		}
		public function get labPage():Label
		{
			return this._labPage;
		}
		public function get timeLayer():CJMoneyTreeTimeLayer
		{
			return this._timeLayer;
		}
		public function get btnClose():Button
		{
			return this._btnClose;
		}
		public function get labJingyan():Label
		{
			return this._labJingyan;
		}
		public function get labExp():Label
		{
			return this._labExp;
		}
		public function get imgExpDi():Scale3Image
		{
			return this._imgExpDi;
		}
		public function get pbExp():ProgressBar
		{
			return this._pbExp;
		}
	}
}