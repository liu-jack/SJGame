package SJ.Game.duobao
{
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Common.global.textRender;
	import SJ.Game.SocketServer.SocketCommand_duobao;
	import SJ.Game.SocketServer.SocketCommand_role;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.controls.CJTextFormatUtil;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfDuoBao;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.formation.CJTurnPage;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJMessageBox;
	import SJ.Game.task.CJTaskFlowString;
	
	import engine_starling.SApplication;
	import engine_starling.display.SAnimate;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.FeatherControlUtils.SFeatherControlUtils;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.textures.Texture;

	public class CJSubDuoBaoLayer extends SLayer
	{
		private var _composeBtn:Button;
		private var _collectBtn:Button;
		private var _addBaoHuCount:Button;
		private var _guYongBtn:Button;
		
		private var _duoBaoCount:Label;
		private var _lianShengCount:Label;
		private var _shangJin:Label;
		private var _headItem:CJDuoBaoEmployHead;
		private var _composeLastTime:Label;
		
		//左上角名称
		private var _baoWuName:Label;
		//左上角描述
		private var _baoWuDesc:Label;
		//宝物右下角等级
		private var _baoWuLevel:Label;
		
		//中间宝物,和5个碎片
		private var _baoWuIcon:Button;
		private var _suiPianIcon_1:Button;
		private var _suiPianIcon_2:Button;
		private var _suiPianIcon_3:Button;
		private var _suiPianIcon_4:Button;
		private var _suiPianIcon_5:Button;
		private var _vecSuiPian:Vector.<Button>;
		//左边宝物列表
		private var _scrollView:CJTurnPage;
		
		private var _selectTargetLayer:CJDuoBaoSelectTargetLayer;
		private var _itemInfoLayer:CJDuoBaoItemInfoLayer;
		
		//数据相关
		private var _data:CJDataOfDuoBao;
		private var _XunBaoLevel:int = 0;
		private var _curSelectBaoId:int = 1;
		private var _curSelectSuiPianId: int = 1;
		private var _treasureData:Object;
		private var _treasurePartData:Object;
		
		private var _timer:Timer;
		
		private var _select:SImage = null;//选中框
		
		public static var _tooltipPartId:int = 0;
		
		public function CJSubDuoBaoLayer()
		{
			super();
			
			_data = CJDataOfDuoBao.o;
			
			var bg1:SImage = new SImage(SApplication.assets.getTexture("baoshi_youcedi"));
			bg1.x = 128;
			bg1.y = 39;
			bg1.scaleX = 2.6;
			bg1.scaleY = 2.6;
			this.addChild(bg1);
			
			var leftLine:SImage = new SImage(SApplication.assets.getTexture("zhuzhanhaoyou_fengexian"));
			leftLine.x = 125;
			leftLine.y = 39;
			leftLine.scaleY = 5.5;
			this.addChild(leftLine);
			
			var rightLine:SImage = new SImage(SApplication.assets.getTexture("zhuzhanhaoyou_fengexian"));
			rightLine.x = 336;
			rightLine.y = 39;
			rightLine.scaleY = 5.5;
			this.addChild(rightLine);
			
			_composeBtn = new Button();
			_composeBtn.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniuda01new"));
			_composeBtn.downSkin = new SImage(SApplication.assets.getTexture("common_anniuda02new"));
			_composeBtn.disabledSkin = new SImage(SApplication.assets.getTexture("common_anniuda03new")); 	
			_composeBtn.defaultLabelProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 14, 0xFFFFFF);
			_composeBtn.addEventListener(starling.events.Event.TRIGGERED, _onCompose);
			_composeBtn.x = 138;
			_composeBtn.y = 263;
			_composeBtn.scaleX = 0.7;
			_composeBtn.scaleY = 0.7;
			_composeBtn.label = CJLang("DUOBAO_MERGE");
			this.addChild(_composeBtn);
			
			_collectBtn = new Button();
			_collectBtn.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniuda01new"));
			_collectBtn.downSkin = new SImage(SApplication.assets.getTexture("common_anniuda02new"));
			_collectBtn.disabledSkin = new SImage(SApplication.assets.getTexture("common_anniuda03new")); 	
			_collectBtn.defaultLabelProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 14, 0xFFFFFF);
			_collectBtn.addEventListener(starling.events.Event.TRIGGERED, _onCollect);
			_collectBtn.x = 249;
			_collectBtn.y = 263;
			_collectBtn.scaleX = 0.7;
			_collectBtn.scaleY = 0.7;
			_collectBtn.label = CJLang("DUOBAO_COLLECT");
			this.addChild(_collectBtn);
			
			var texture:Texture;
			texture = SApplication.assets.getTexture("zhuce_zuijindengludi");
			var bg2:Scale9Image = new Scale9Image(new Scale9Textures(texture, new Rectangle(5, 5, 2, 2)));
			bg2.x = 342;
			bg2.y = 45;
			bg2.width = 127;
			bg2.height = 120;
			bg2.color = 0x444444;
			this.addChild(bg2);
			
			var bg3:Scale9Image = new Scale9Image(new Scale9Textures(texture, new Rectangle(5, 5, 2, 2)));
			bg3.x = 342;
			bg3.y = 170;
			bg3.width = 127;
			bg3.height = 120;
			bg3.color = 0x444444;
			this.addChild(bg3);
			
			var Label1:Label = new Label();
			Label1.text = CJLang("DUOBAO_LABEL_COUNT");
			Label1.x = 350;
			Label1.y = 60;
			Label1.textRendererFactory = textRender.glowTextRender;
			Label1.textRendererProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 10, 0x8FFD28);
			this.addChild(Label1);
			
			_duoBaoCount = new Label();
			_duoBaoCount.text = "3/7";
			_duoBaoCount.x = 400;
			_duoBaoCount.y = 60;
			_duoBaoCount.textRendererFactory = textRender.glowTextRender;
			_duoBaoCount.textRendererProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 10, 0xFF8000);
			this.addChild(_duoBaoCount);
			
			var Label2:Label = new Label();
			Label2.text = CJLang("DUOBAO_LABEL_WINNUM");
			Label2.x = 350;
			Label2.y = 100;
			Label2.textRendererFactory = textRender.glowTextRender;
			Label2.textRendererProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 10, 0x8FFD28);
			this.addChild(Label2);
			
			_lianShengCount = new Label();
			_lianShengCount.text = "";
			_lianShengCount.x = 400;
			_lianShengCount.y = 100;
			_lianShengCount.textRendererFactory = textRender.glowTextRender;
			_lianShengCount.textRendererProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 10, 0xEE2222);
			this.addChild(_lianShengCount);
			
			var Label3:Label = new Label();
			Label3.text = CJLang("DUOBAO_LABEL_MYREWARD");
			Label3.x = 350;
			Label3.y = 142;
			Label3.textRendererFactory = textRender.glowTextRender;
			Label3.textRendererProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 10, 0x8FFD28);
			this.addChild(Label3);
			
			_shangJin = new Label();
			_shangJin.text = "";
			_shangJin.x = 400;
			_shangJin.y = 142;
			_shangJin.textRendererFactory = textRender.glowTextRender;
			_shangJin.textRendererProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 10, 0xFFFF00);
			this.addChild(_shangJin);
			
			var title:SImage = new SImage(SApplication.assets.getTexture("zuoqi_shuxingbiaotoudi"));
			title.x = 354;
			title.y = 175;
			title.scaleX = 1.3;
			this.addChild(title);
			
			var Label4:Label = new Label();
			Label4.text = CJLang("DUOBAO_LABEL_EMPLOY");
			Label4.x = 367;
			Label4.y = 176;
			Label4.textRendererFactory = textRender.glowTextRender;
			Label4.textRendererProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 12, 0x00FFFF);
			this.addChild(Label4);
			
//			var Label5:Label = new Label();
//			Label5.text = CJLang("DUOBAO_LABEL_LASTTIME");
//			Label5.x = 357;
//			Label5.y = 270;
//			Label5.textRendererFactory = textRender.glowTextRender;
//			Label5.textRendererProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 10, 0x8FFD28);
//			this.addChild(Label5);
			
			_composeLastTime = new Label();
			_composeLastTime.text = "00:00:00";
			_composeLastTime.x = 206;
			_composeLastTime.y = 182;
			_composeLastTime.width = 53;
			_composeLastTime.textRendererFactory = textRender.glowTextRender;
			_composeLastTime.textRendererProperties.textFormat = 
				new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 12, 0xEEFF22, null, null, null, null, null, TextFormatAlign.CENTER);
			this.addChild(_composeLastTime);
			
			_guYongBtn = new Button();
			_guYongBtn.defaultSkin = new SImage(SApplication.assets.getTexture("zhujiemian_caidanchangtai"));
			_guYongBtn.downSkin = new SImage(SApplication.assets.getTexture("zhujiemian_caidananxia"));	
			_guYongBtn.defaultLabelProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 12, 0xFFFF00);
			_guYongBtn.labelFactory = textRender.glowTextRender;
			_guYongBtn.addEventListener(starling.events.Event.TRIGGERED, _onGuYong);
			_guYongBtn.x = 368;
			_guYongBtn.y = 200;
			_guYongBtn.scaleX = 1.4;
			_guYongBtn.scaleY = 1.4;
			_guYongBtn.label = CJLang("DUOBAO_BUTTON_EMPLOY");
			this.addChild(_guYongBtn);
			
			_addBaoHuCount = new Button();
			_addBaoHuCount.defaultSkin = new SImage(SApplication.assets.getTexture("common_jiaanniu01"));
			_addBaoHuCount.downSkin = new SImage(SApplication.assets.getTexture("common_jiaanniu02"));
			_addBaoHuCount.disabledSkin = new SImage(SApplication.assets.getTexture("common_jiaanniu03"));
			_addBaoHuCount.addEventListener(starling.events.Event.TRIGGERED, _onAddBaoHuCount);
			_addBaoHuCount.x = 430;
			_addBaoHuCount.y = 55;
			_addBaoHuCount.scaleX = 1.3;
			_addBaoHuCount.scaleY = 1.3;
			this.addChild(_addBaoHuCount);
			
			_baoWuIcon = new Button();
			_baoWuIcon.defaultSkin = new SImage(SApplication.assets.getTexture("common_baoshidi"));	
			_baoWuIcon.defaultLabelProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 14, 0xFFFFFF);
			_baoWuIcon.addEventListener(starling.events.Event.TRIGGERED, _onClickBaoWu);
			_baoWuIcon.x = 203;
			_baoWuIcon.y = 114;
			this.addChild(_baoWuIcon);
			
			function _addCountLabel(btn:Button):void
			{
				var label:Label = new Label();
				label.text = "0";
				label.width = 50
				label.x = btn.x - 2;
				label.y = btn.y + 38;
				label.touchable = false;
				label.name = btn.name + "count";
				label.textRendererFactory = textRender.glowTextRender;
				label.textRendererProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 10, 0xDDDDDD, 
					null, null, null, null, null, TextFormatAlign.RIGHT);
				btn.parent.addChild(label);
			}
			
			function _addNameLabel(btn:Button):void
			{
				var label:Label = new Label();
				label.text = "";
				label.width = 100
				label.x = btn.x - 19;
				label.y = btn.y + 53;
				label.name = btn.name + "name";
				label.textRendererFactory = textRender.glowTextRender;
				label.textRendererProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 7, 0xDDDDDD, 
					null, null, null, null, null, TextFormatAlign.CENTER);
				btn.parent.addChild(label);
			}
				
			_suiPianIcon_1 = new Button();
			_suiPianIcon_1.defaultSkin = new SImage(SApplication.assets.getTexture("common_baoshidi"));	
			_suiPianIcon_1.labelFactory = textRender.glowTextRender;
			_suiPianIcon_1.defaultLabelProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 12, 0xDDDDDD);
			_suiPianIcon_1.addEventListener(starling.events.Event.TRIGGERED, _onClickSuiPian);
			_suiPianIcon_1.name = "1";
			_suiPianIcon_1.x = 127;
			_suiPianIcon_1.y = 105;
			_suiPianIcon_1.label = "";
			this.addChild(_suiPianIcon_1);
			_addCountLabel(_suiPianIcon_1);
			_addNameLabel(_suiPianIcon_1);

			
			
			_suiPianIcon_2 = new Button();
			_suiPianIcon_2.defaultSkin = new SImage(SApplication.assets.getTexture("common_baoshidi"));	
			_suiPianIcon_2.labelFactory = textRender.glowTextRender;
			_suiPianIcon_2.defaultLabelProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 12, 0xDDDDDD);
			_suiPianIcon_2.addEventListener(starling.events.Event.TRIGGERED, _onClickSuiPian);
			_suiPianIcon_2.name = "2";
			_suiPianIcon_2.x = 152;
			_suiPianIcon_2.y = 191;
			_suiPianIcon_2.label = "";
			this.addChild(_suiPianIcon_2);
			_addCountLabel(_suiPianIcon_2);
			_addNameLabel(_suiPianIcon_2);
			
			_suiPianIcon_3 = new Button();
			_suiPianIcon_3.defaultSkin = new SImage(SApplication.assets.getTexture("common_baoshidi"));	
			_suiPianIcon_3.labelFactory = textRender.glowTextRender;
			_suiPianIcon_3.defaultLabelProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 12, 0xDDDDDD);
			_suiPianIcon_3.addEventListener(starling.events.Event.TRIGGERED, _onClickSuiPian);
			_suiPianIcon_3.name = "3";
			_suiPianIcon_3.x = 256;
			_suiPianIcon_3.y = 191;
			_suiPianIcon_3.label = "";
			this.addChild(_suiPianIcon_3);
			_addCountLabel(_suiPianIcon_3);
			_addNameLabel(_suiPianIcon_3);
			
			_suiPianIcon_4 = new Button();
			_suiPianIcon_4.defaultSkin = new SImage(SApplication.assets.getTexture("common_baoshidi"));	
			_suiPianIcon_4.labelFactory = textRender.glowTextRender;
			_suiPianIcon_4.defaultLabelProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 12, 0xDDDDDD);
			_suiPianIcon_4.addEventListener(starling.events.Event.TRIGGERED, _onClickSuiPian);
			_suiPianIcon_4.name = "4";
			_suiPianIcon_4.x = 279;
			_suiPianIcon_4.y = 105;
			_suiPianIcon_4.label = "";
			this.addChild(_suiPianIcon_4);
			_addCountLabel(_suiPianIcon_4);
			_addNameLabel(_suiPianIcon_4);
			
			_suiPianIcon_5 = new Button();
			_suiPianIcon_5.defaultSkin = new SImage(SApplication.assets.getTexture("common_baoshidi"));	
			_suiPianIcon_5.labelFactory = textRender.glowTextRender;
			_suiPianIcon_5.defaultLabelProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 12, 0xDDDDDD);
			_suiPianIcon_5.addEventListener(starling.events.Event.TRIGGERED, _onClickSuiPian);
			_suiPianIcon_5.name = "5";
			_suiPianIcon_5.x = 203;
			_suiPianIcon_5.y = 37;
			_suiPianIcon_5.label = "";
			this.addChild(_suiPianIcon_5);
			_addCountLabel(_suiPianIcon_5);
			_addNameLabel(_suiPianIcon_5);
			
			_vecSuiPian = new Vector.<Button>();
			_vecSuiPian.push(_suiPianIcon_1, _suiPianIcon_2, _suiPianIcon_3, _suiPianIcon_4, _suiPianIcon_5);
			
			_baoWuName = new Label();
			_baoWuName.text = "";
			_baoWuName.x = 131;
			_baoWuName.y = 41;
			_baoWuName.textRendererFactory = textRender.glowTextRender;
			_baoWuName.textRendererProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 9, 0x00FFFF);
			this.addChild(_baoWuName);
			
			_baoWuDesc = new Label();
			_baoWuDesc.text = "";
			_baoWuDesc.width = 70;
			_baoWuDesc.x = 131;
			_baoWuDesc.y = 55;
			_baoWuDesc.textRendererFactory = textRender.glowTextRender;
			_baoWuDesc.textRendererProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 7, 0xFF8800);
			_baoWuDesc.textRendererProperties.wordWrap = true;
			this.addChild(_baoWuDesc);
			
			_baoWuLevel = new Label();
			_baoWuLevel.text = "";
			_baoWuLevel.width = 50;
			_baoWuLevel.touchable = false;
			_baoWuLevel.x = _baoWuIcon.x - 2;
			_baoWuLevel.y = _baoWuIcon.y + 38;
			_baoWuLevel.textRendererFactory = textRender.glowTextRender;
			_baoWuLevel.textRendererProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 10, 0xDDDDDD, 
				null, null, null, null, null, TextFormatAlign.RIGHT);
			this.addChild(_baoWuLevel);		
			
			_scrollView = new CJTurnPage(4);
			_scrollView.x = 75;
			_scrollView.y = 65;
			_scrollView.setRect(51, 204);
			this.addChild(_scrollView);	
			
			this._scrollView.preButton.defaultSkin = new SImage(SApplication.assets.getTexture("common_fanyeup01"));
			this._scrollView.preButton.downSkin = new SImage(SApplication.assets.getTexture("common_fanyeup03"));
			this._scrollView.preButton.disabledSkin = new SImage(SApplication.assets.getTexture("common_fanyeup02"));
			this._scrollView.preButton.width = 41;
			this._scrollView.preButton.height = 26;
			this._scrollView.preButton.x = 5;
			this._scrollView.preButton.y = -27;
			
			this._scrollView.nextButton.defaultSkin = new SImage(SApplication.assets.getTexture("common_fanyeup01"));
			this._scrollView.nextButton.downSkin = new SImage(SApplication.assets.getTexture("common_fanyeup03"));
			this._scrollView.nextButton.disabledSkin = new SImage(SApplication.assets.getTexture("common_fanyeup02"));
			this._scrollView.nextButton.width = 41;
			this._scrollView.nextButton.height = 26;
			this._scrollView.nextButton.x = 5;
			this._scrollView.nextButton.y = 231;
			this._scrollView.nextButton.scaleY = -1;	// 上下翻转按钮
		
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,_rewardFlushHandle);
		}
		
		override protected function initialize():void
		{
			super.initialize();
			_timer = new Timer(300);
			_timer.addEventListener(TimerEvent.TIMER, _onTimer);
			
			if(_tooltipPartId != 0)
			{
				var tooltip:CJDuoBaoTooltip = new CJDuoBaoTooltip();
				tooltip.setTreasurePartId(_tooltipPartId);
				CJLayerManager.o.addModuleLayer(tooltip);
				_tooltipPartId = 0;
			}
			
			_headItem = new CJDuoBaoEmployHead();
			_headItem.x = 368;
			_headItem.y = 200;
			_headItem.visible = false;
			this.addChild(_headItem);
			
			this._initEmployPanel();
			
			CJDataManager.o.DataOfDuoBaoEmploy.addEventListener(CJEvent.EVENT_DUOBAO_APPLY_AGREED , this._onApplyAgreed);
		}
		
		private function _onApplyAgreed(e:Event):void
		{
			if(e.type == CJEvent.EVENT_DUOBAO_APPLY_AGREED)
			{
				_initEmployPanel();
			}
		}
		
		private function _initEmployPanel():void
		{
			var employData:Object = CJDataManager.o.DataOfDuoBaoEmploy.employData;
			if(employData.hasOwnProperty('frienduid'))
			{
				_guYongBtn.visible = false;
				_headItem.visible = true;
				_headItem.data = employData;
			}
			else
			{
				_headItem.visible = false;
				_guYongBtn.visible = true;
			}
		}
		
		override public function dispose():void
		{
			if(_timer)
			{
				_timer.removeEventListener(TimerEvent.TIMER, _onTimer);
				_timer = null;
			}
			for each(var btn:Button in _vecSuiPian)
			{
				var anim:SAnimate = SAnimate(btn.getChildByName("anim"));
				if(anim)
				{
					anim.stop();
					btn.removeChild(anim);
					Starling.juggler.remove(anim);
					anim = null;
				}
			}
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_onRemoteCallBack);
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_rewardFlushHandle);
			if(_selectTargetLayer)
			{
				_selectTargetLayer.removeFromParent(true);
			}
			CJDataManager.o.DataOfDuoBaoEmploy.removeEventListener(CJEvent.EVENT_DUOBAO_APPLY_AGREED , this._onApplyAgreed);
			super.dispose();
		}
		
		internal function _rpcGetTreasureForMerge():void
		{
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,_onRemoteCallBack);
			SocketCommand_duobao.gettreasureformerge();
		}
		
		private function _rpcMerge(treasureId:int):void
		{
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,_onRemoteCallBack);
			SocketCommand_duobao.merge("" + treasureId);
		}
		
		private function _rpcCollect(treasureId:int):void
		{
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,_onRemoteCallBack);
			SocketCommand_duobao.collect("" + treasureId);
		}
		
		private function _rpcGetLootList(treasurePartId:int):void
		{
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,_onRemoteCallBack);
			SocketCommand_duobao.getLootList("" + treasurePartId);		
		}
			
		/**
		 * @private
		 * 接受协议
		 */
		private function _onRemoteCallBack(e:Event):void
		{
			//收协议
			var message:SocketMessage = e.data as SocketMessage;
			var retParams:Object = message.retparams;
			switch (message.getCommand())
			{
				
				case ConstNetCommand.CS_DUOBAO_GET_TREASURE_FOR_MERGE:
				{
					//初始信息
					if (message.retcode == 0)
					{
						_XunBaoLevel = parseInt(retParams["findlevel"]);	
						
						_lianShengCount.text = retParams["winnum"] + CJLang("DUOBAO_WINNUM");
						_treasureData = retParams["treasure"];
						_treasurePartData = retParams["treasurePart"];
						
						//在treasure的data里面填入收到协议的时间, 以便倒计时用
						for each(var treasure:Object in _treasureData)
						{
							treasure["recvtime"] = "" + int(getTimer() / 1000);
						}
						_duoBaoCount.text = retParams["duonum"];
						_shangJin.text = retParams["reward"];
						
						_reFlashUI();
						
					}
					SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_onRemoteCallBack);
					break;
				}
				case ConstNetCommand.CS_DUOBAO_MERGE:
				{
					//合成
					switch (message.retcode)
					{
						case 0:
						{
							//成功
							_treasureData[_curSelectBaoId]["state"] = "1";
							_treasureData[_curSelectBaoId]["lasttime"] = retParams["lasttime"];
							_treasureData[_curSelectBaoId]["recvtime"] = "" + int(getTimer() / 1000);
							
							_reFlashUIBaoWu();
							_reFlashUIListTip();
							break;
						}
						case 1:
						{
							//正在合成  非法
							CJMessageBox(CJLang("DUOBAO_TIP_MERGEING"));
							break;
						}
						case 2:
						{
							//ID越界
							CJMessageBox(CJLang("DUOBAO_TIP_OVER_ID"));
							break;
						}
						case 3:
						{
							//等级已达最高
							CJMessageBox(CJLang("DUOBAO_TIP_MAXLEVEL"));
							break;
						}
						case 4:
						{
							//碎片不足
							CJMessageBox(CJLang("DUOBAO_TIP_NOT_ENOUGH_PART"));
							break;
						}
					}
					_treasurePartData = retParams["treasurePart"];
					_reFlashUISuiPian();
					SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_onRemoteCallBack);
					break;
				}
				case ConstNetCommand.CS_DUOBAO_COLLECT:
				{
					//收取
					switch (message.retcode)
					{
						case 0:
						{
							//成功
							var oldLevel:int = parseInt(_treasureData[_curSelectBaoId]["level"]);
							var oldExp:int = parseInt(_treasureData[_curSelectBaoId]["exp"]);
							_treasureData[_curSelectBaoId]["level"] = retParams["level"];
							_treasureData[_curSelectBaoId]["exp"] = retParams["exp"];
							_treasureData[_curSelectBaoId]["state"] = "0";
							_treasureData[_curSelectBaoId]["lasttime"] = "0";
							
							_reFlashUIBaoWu();
							_reFlashUIListTip();
							
							if(!_itemInfoLayer)
							{
								_itemInfoLayer = new CJDuoBaoItemInfoLayer();
								_itemInfoLayer.width = 277;
								_itemInfoLayer.height = 256;	
							}
							var data: Object = new Object();
							data["treasureId"] = _curSelectBaoId;
							data["level"] = parseInt(_treasureData[_curSelectBaoId]["level"]);
							data["exp"] = parseInt(_treasureData[_curSelectBaoId]["exp"]);
							data["addExp"] = true;
							data["oldLevel"] = oldLevel;
							data["oldExp"] = oldExp;
							CJLayerManager.o.addModuleLayer(_itemInfoLayer);
							_itemInfoLayer.setData(data);
							break;
						}
						case 1:
						{
							//ID越界
							CJMessageBox(CJLang("DUOBAO_TIP_OVER_ID"));
							break;
						}
						case 2:
						{
							//碎片不足 或者 没有开始合成
							CJMessageBox(CJLang("DUOBAO_TIP_NOT_ENOUGH_PART"));
							_treasureData[_curSelectBaoId]["state"] = "0";
							_treasureData[_curSelectBaoId]["lasttime"] = "0";
							
							_reFlashUIBaoWu();
							break;
						}
						case 3:
						{
							//时间未到
							CJMessageBox(CJLang("DUOBAO_TIP_TIME_NOT_OVER"));
							break;
						}
						case 4:
						{
							//碎片不足 或者 没有开始合成
							CJMessageBox(CJLang("DUOBAO_TIP_NO_TIME"));
							_treasureData[_curSelectBaoId]["state"] = "0";
							_treasureData[_curSelectBaoId]["lasttime"] = "0";
							
							_reFlashUIBaoWu();
							break;
						}
					}
					_treasurePartData = retParams["treasurePart"];
					_reFlashUISuiPian();
					SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_onRemoteCallBack);
					break;
				}
				case ConstNetCommand.CS_DUOBAO_GET_LOOT_LIST:
				{
					//获取抢夺列表
					switch (message.retcode)
					{	
						case 0:
						{
							if(retParams["list"].length == 0)
							{
								CJMessageBox(CJLang("DUOBAO_TIP_NO_ONE_HAS"));
								break;
							}
							if(!_selectTargetLayer)
							{
								_selectTargetLayer = new CJDuoBaoSelectTargetLayer();
								_selectTargetLayer.width = 392;
								_selectTargetLayer.height = 274;	
							}
							retParams["treasurePartId"] = _curSelectSuiPianId;				
							CJLayerManager.o.addModuleLayer(_selectTargetLayer);
							_selectTargetLayer.setData(retParams);
							break;
						}
						case 1:
						{
							//夺宝次数不足
							CJMessageBox(CJLang("DUOBAO_TIP_DUOBAOCOUNT_NOT_ENOUGH"));
							break;
						}
						case 2:
						{
							//未开放该宝物
							CJMessageBox(CJLang("DUOBAO_TIP_NOT_OPEN"));
							break;
						}
						default:
						{
							CJMessageBox(CJLang("DUOBAO_TIP_NO_ONE_HAS"));
							break;
						}
					}
					SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_onRemoteCallBack);
					break;
				}
			}
		}
		
		
		/**
		 * @private
		 * 进界面调用
		 */
		public function initUI():void
		{
			_curSelectBaoId = 1;
			_rpcGetTreasureForMerge();
		}
		
		/**
		 * @private
		 * 选中左边列表中的宝物
		 */
		public function onSelectItem(item:CJDuoBaoListItem):void
		{
			//选中列表
			if(!item.isOpen)
				return;
			if(item.id == _curSelectBaoId)
				return;
			_timer.reset();
			_curSelectBaoId = item.id;
			_reFlashUIBaoWu();
			_reFlashUISuiPian();
			
			var count:int = _data.getTreasureCount();
			for(var i:int = 1; i <= count; i++)
			{
				var openLevel:String = "";
				var picture:String = _data.getTreasure(i).picture;
				var level:int = parseInt(_data.getTreasure(i).openlevel);
				if(_XunBaoLevel < level)
				{
					openLevel = CJLang("DUOBAO_XUNBAO_OPEN_LEVEL_1") + level + CJLang("DUOBAO_XUNBAO_OPEN_LEVEL_2");
					picture = "";
				}
				var data:Object = {
					"imageName": picture,
					"text": openLevel,
					"id": i,
					"isOpen": picture != "",
					"select": _curSelectBaoId == i
				};
				_scrollView.updateItem(data, i - 1);
			}
			_reFlashUIListTip();
		}
		
		/**
		 * @private
		 * 刷新所有UI
		 */
		private function _reFlashUI():void
		{
			_reFlashUIList();
			_reFlashUIBaoWu();
			_reFlashUISuiPian();
			_reFlashUIListTip();
		}
		
		/**
		 * @private
		 * 刷新左边列表
		 */
		private function _reFlashUIList():void
		{
			//刷新左边列表
			var data:Array = new Array();
			var count:int = _data.getTreasureCount();
			for(var i:int = 1; i <= count; i++)
			{
				var openLevel:String = "";
				var picture:String = _data.getTreasure(i).picture;
				var level:int = parseInt(_data.getTreasure(i).openlevel);
				if(_XunBaoLevel < level)
				{
					openLevel = CJLang("DUOBAO_XUNBAO_OPEN_LEVEL_1") + level + CJLang("DUOBAO_XUNBAO_OPEN_LEVEL_2");
					picture = "";
				}
				data.push({
					"imageName": picture,
					"text": openLevel,
					"id": i,
					"isOpen": picture != "",
					"select": _curSelectBaoId == i
				});
			}
			
			var groceryList:ListCollection = new ListCollection(data);
			_scrollView.dataProvider = groceryList;
			_scrollView.itemRendererFactory = function():IListItemRenderer
			{
				const render:CJDuoBaoListItem = new CJDuoBaoListItem();
				return render;
			};
		}
		

		
		/**
		 * @private
		 * 刷新中间宝物
		 */
		private function _reFlashUIBaoWu():void
		{
			//刷新中间宝物
			_baoWuIcon.removeChildren(1);
			var _icon:SImage = new SImage(SApplication.assets.getTexture(_data.getTreasure(_curSelectBaoId).picture));
			_icon.x = 7.5;
			_icon.y = 7.5;
			_baoWuIcon.addChild(_icon);
			
			_baoWuName.text = CJLang(_data.getTreasure(_curSelectBaoId).treasurename);
			_baoWuDesc.text = _data.getTreasureSingleDescByID(_curSelectBaoId, int(_treasureData[_curSelectBaoId]["level"]));
			_baoWuLevel.text = "LV" + _treasureData[_curSelectBaoId]["level"];
			
			//刷新当前合成状态
			switch (_treasureData[_curSelectBaoId]["state"])
			{
				case "0":
				{
					//未合成
					_composeBtn.isEnabled = true;
					_collectBtn.isEnabled = false;
					_composeLastTime.text = ""
					break;
				}
				case "1":
				{
					var deltatime:int = int(getTimer()/1000) - parseInt(_treasureData[_curSelectBaoId]["recvtime"]);
					var lasttime:int = parseInt(_treasureData[_curSelectBaoId]["lasttime"]) - deltatime;
					if(lasttime > 0)
					{
						//创建计时器
						_composeLastTime.text = getTimeStr(lasttime);

						_timer.reset();
						_timer.start();
						
						//正在合成
						_composeBtn.isEnabled = false;
						_collectBtn.isEnabled = false;
					}
					else 
					{
						//合成完毕
						_composeBtn.isEnabled = false;
						_collectBtn.isEnabled = true;
						_composeLastTime.text = CJLang("DUOBAO_MERGE_COMPLETE");
					}
					
					break;
				}
			}
		}
		/**
		 * @private
		 * 刷新列表提示状态
		 */
		private function _reFlashUIListTip():void
		{
			var count:int = _data.getTreasureCount();
			for(var i:int = 1; i <= count; i++)
			{
				var openLevel:String = "";
				var picture:String = _data.getTreasure(i).picture;
				var level:int = parseInt(_data.getTreasure(i).openlevel);
				if(_XunBaoLevel < level)
				{
					openLevel = CJLang("DUOBAO_XUNBAO_OPEN_LEVEL_1") + level + CJLang("DUOBAO_XUNBAO_OPEN_LEVEL_2");
					picture = "";
				}
				var tip:Boolean = false;
				//检查是否是可收取状态
				if(_treasureData[i]["state"] == "0")
				{
					//未合成
					//如果碎片可以合成
					tip = true;
					var suipiandataArr:Array = _data.getTreasurePartsByTreasureID(i);
					for(var k:int = 0; k < suipiandataArr.length; k++)
					{
						if(_treasurePartData[suipiandataArr[k].id]["num"] <= 0)
						{
							tip = false;
							break;
						}
					}
				}
				else if(_treasureData[i]["state"] == "1")
				{
					var deltatime:int = int(getTimer()/1000) - parseInt(_treasureData[i]["recvtime"]);
					var lasttime:int = parseInt(_treasureData[i]["lasttime"]) - deltatime;
					if(lasttime <= 0)
					{
						//可收取状态
						tip = true;
					}
				}
				var data:Object = {
					"imageName": picture,
					"text": openLevel,
					"id": i,
					"isOpen": picture != "",
					"select": _curSelectBaoId == i,
					"tip": tip
				};
				_scrollView.updateItem(data, i - 1);
			}
		}
		
		/**
		 * @private
		 * 合成宝物倒计时
		 */
		private function _onTimer(e:TimerEvent):void
		{
			var deltatime:int = int(getTimer()/1000) - parseInt(_treasureData[_curSelectBaoId]["recvtime"]);
			var lasttime:int = parseInt(_treasureData[_curSelectBaoId]["lasttime"]) - deltatime;
			if(lasttime <= 0)
			{
				//如果结束
				_timer.reset();	
				_reFlashUIListTip();
				//合成完毕
				_composeBtn.isEnabled = false;
				_collectBtn.isEnabled = true;
				_composeLastTime.text = CJLang("DUOBAO_MERGE_COMPLETE");
			}
			else 
			{
				_composeLastTime.text = getTimeStr(lasttime);			
			}

		}
		
		private function getTimeStr(sec: int):String
		{
			return String("00"+Math.floor(sec/3600)).substr(-2) 	
				+ ":" + String("00"+ (Math.floor(sec/60) % 60)).substr(-2) 
				+ ":" + String("00"+ Math.floor(sec%60) ).substr(-2);
		}
		
		/**
		 * @private
		 * 刷新碎片
		 */
		private function _reFlashUISuiPian():void
		{
			//刷新碎片们
			var suipiandataArr:Array = _data.getTreasurePartsByTreasureID(_curSelectBaoId);
			for each(var btn:Button in _vecSuiPian)
			{
				var _gicon:DisplayObject = btn.getChildByName("icon");
				if(_gicon)
				{
					btn.removeChild(_gicon);
				}
				var index:int = parseInt(btn.name) - 1;
				var id:int = suipiandataArr[index].id;
				var count:int = _treasurePartData[id]["num"];
				var name:String = CJLang(suipiandataArr[index].treasurepartname);
					
				var label:DisplayObject = this.getChildByName(btn.name + "count");
				if(label)
				{
					(label as Label).text = "" + count;
				}
				label = this.getChildByName(btn.name + "name");
				if(label)
				{
					(label as Label).text = name;
					(label as Label).textRendererProperties.textFormat.color 
						= CJTextFormatUtil._getTextColor(parseInt(suipiandataArr[index].color));
				}
					
				if(count == 0)//碎片个数为0
				{
					btn.label = CJLang("DUOBAO_GOTO_DUOBAO");
				}
				else 
				{
					var _sicon:SImage = new SImage(SApplication.assets.getTexture(suipiandataArr[index].picture));
					_sicon.x = 7.5;
					_sicon.y = 7.5;
					_sicon.name = "icon";
					btn.addChild(_sicon);
					btn.label = "";
				}
				
				
				var anim:SAnimate = SAnimate(btn.getChildByName("anim"));
				if(anim)
				{
					anim.stop();
					btn.removeChild(anim);
					Starling.juggler.remove(anim);
					anim = null;
				}
				//添加碎片动画
				if(count > 0)
				{
					var framesTextureVec:Vector.<Texture> = new Vector.<Texture>();
					var key1:String = String("00" + _curSelectBaoId).substr(-2);
					for(var i:int = 0; i < 6; i++)
					{
						var key2:String = String("00" + i).substr(-2);
						var filaname:String = "duobao_" + key1 + "_" + key2;
						framesTextureVec.push(SApplication.assets.getTexture(filaname));
					}
					anim = new SAnimate(framesTextureVec, 8);
					anim.name = "anim";
					anim.x = 3.5;
					anim.y = 3.5;
					anim.scaleX = 1.3;
					anim.scaleY = 1.3;
					Starling.juggler.add(anim);
					btn.addChild(anim);
					anim.gotoAndPlay();
				}
				
			}
		}
		
		/**
		 * @private
		 * 开始合成
		 */
		private function _onCompose(event:Event):void
		{
			_rpcMerge(_curSelectBaoId);
		}
		
		/**
		 * @private
		 * 收取宝物
		 */
		private function _onCollect(event:Event):void
		{
			_rpcCollect(_curSelectBaoId);
		}
		
		/**
		 * @private
		 * 雇佣
		 */
		private function _onGuYong(event:Event):void
		{
			SocketManager.o.callwithRtn(ConstNetCommand.CS_FRIEND_GET_ALL_FRIEND_INFO , _openEmploy);
		}
		
		private function _openEmploy(message:SocketMessage):void
		{
			var sxml:XML = AssetManagerUtil.o.getObject("duobaoemploy.sxml") as XML;
			var employLayer:CJDuoBaoEmployLayer = SFeatherControlUtils.o.genLayoutFromXML(sxml , CJDuoBaoEmployLayer) as CJDuoBaoEmployLayer;
			CJLayerManager.o.addModuleLayer(employLayer);
		}
		
		/**
		 * 增加夺宝次数
		 * @param event
		 * 
		 */		
		private function _onAddBaoHuCount(event:Event):void
		{
			SocketManager.o.callwithRtn(ConstNetCommand.CS_DUOBAO_GETCURBUYNUM, _getBuyNum);
		}
		
		//
		private function _getBuyNum(message:SocketMessage):void
		{
			var obj:Object = message.retparams;
			//obj.buyfindnum
			//obj.lvipnum
			if(int(obj.buylootnum) >= int(obj.lvipnum))
			{
				CJMessageBox(CJLang("DUOBAO_TIP_NO_COUNT_BUY"));//"已经没有购买次数了"
			}
			else
			{
				var tipPanel:CJBuyNumTipPanel = new  CJBuyNumTipPanel();
				tipPanel.buyNum = int(obj.buylootnum);
				tipPanel.vipBuyNum = int(obj.lvipnum);
				tipPanel.funcHandle = _addDuoBaoNum;
				tipPanel.buyType = 2;
				tipPanel.x = 144;
				tipPanel.y = 75;
				addChild(tipPanel);
			}
		}
		
		//增加夺宝次数返回
		private function _addDuoBaoNum(message:SocketMessage):void
		{
			var retCode:uint = message.params(0);
			
			if(retCode==1)
			{
				CJMessageBox(CJLang("DUOBAO_TIP_NO_COUNT_BUY"));
			}
			else if(retCode==2)
			{
				CJMessageBox(CJLang("DUOBAO_TIP_NOT_ENOUGH_GOLD"));
			}
			else if(retCode==0)
			{
				//飘字，获得银两
				new CJTaskFlowString(CJLang("DUOBAO_DUOBAOCOUNT_ADD") +CJBuyNumTipPanel.buynumtip, 1.6, 46).addToLayer();
				
				var obj:Object = message.retparams;//{"duonum":5,"duomaxnum":10}
				_duoBaoCount.text = obj.duonum;
				
				SocketCommand_role.get_role_info();//刷新银两界面显示
			}
		}
		
		/**
		 * @internal 寻宝界面点击宝物信息显示，也会调用
		 * 点击宝物
		 */
		internal function _onClickBaoWu(event:Event):void
		{
			if(!_itemInfoLayer)
			{
				_itemInfoLayer = new CJDuoBaoItemInfoLayer();
				_itemInfoLayer.width = 277;
				_itemInfoLayer.height = 256;	
			}
			var data: Object = new Object();
			data["treasureId"] = _curSelectBaoId;
			data["level"] = parseInt(_treasureData[_curSelectBaoId]["level"]);
			data["exp"] = parseInt(_treasureData[_curSelectBaoId]["exp"]);
			data["addExp"] = false;	
			CJLayerManager.o.addModuleLayer(_itemInfoLayer);
			_itemInfoLayer.setData(data);
		}
		
		/**
		 * @private
		 * 点击碎片
		 */
		private function _onClickSuiPian(event:Event):void
		{	
			_curSelectSuiPianId = (_curSelectBaoId - 1) * 5 + parseInt((event.target as Button).name);
			_rpcGetLootList(_curSelectSuiPianId);
		}
		
		override protected function draw():void
		{
			super.draw();
			
		}
		
		/**
		 * 寻宝模块点击宝物显示信息用
		 * @return Object
		 */		
		public function getTreasureData():Object
		{
			return _treasureData;
		}
		
		//同步赏金值
		private function _rewardFlushHandle(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() != ConstNetCommand.SC_SYNC_DUOBAOED)return;
			
			var params:Array = message.retparams;
			var reward:String = params[0];
			var uid:String = params[1];
			_shangJin.text = reward;
			
			//自己被夺宝，同步赏金值  飘字
			var tiptxt:String = CJLang("DUOBAO_DUOBAOED_TIP");
			if(tiptxt != "" && tiptxt != null){
				tiptxt = tiptxt.replace("{value}", reward+"");
				new CJTaskFlowString(tiptxt, 1.6, 46).addToLayer();
			}
			
		}
	}
}