package SJ.Game.pilerecharge
{
	import SJ.Common.Constants.ConstPlatformId;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Common.global.textRender;
	import SJ.Game.SocketServer.SocketCommand_pileRecharge;
	import SJ.Game.SocketServer.SocketCommand_singleRecharge;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.controls.CJMapUtil;
	import SJ.Game.controls.CJPanelTitle;
	import SJ.Game.controls.CJRechargeUtil;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.config.CJDataOfPileRechargeSetting;
	import SJ.Game.data.config.CJDataOfSingleRechargeSetting;
	import SJ.Game.data.json.Json_pile_recharge_gift_setting;
	import SJ.Game.data.json.Json_pile_recharge_setting;
	import SJ.Game.data.json.Json_single_recharge_gift_setting;
	import SJ.Game.data.json.Json_single_recharge_setting;
	import SJ.Game.formation.CJTurnPage;
	import SJ.Game.lang.CJLang;
	import SJ.Game.task.util.CJTaskLabel;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.Events.DataEvent;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.display.Scale3Image;
	import feathers.layout.VerticalLayout;
	import feathers.textures.Scale3Textures;
	
	import starling.events.Event;
	
	public class CJPileRechargeLayer extends SLayer
	{
		
		private var _imgGirl:ImageLoader;
		/**  美女图 **/
		public function get imgGirl():ImageLoader
		{
			return _imgGirl;
		}
		/** @private **/
		public function set imgGirl(value:ImageLoader):void
		{
			_imgGirl = value;
		}
//		private var _tagLabel:Label;
		/**  累计充值标签页 **/
//		public function get tagLabel():Label
//		{
//			return _tagLabel;
//		}
//		/** @private **/
//		public function set tagLabel(value:Label):void
//		{
//			_tagLabel = value;
//		}
		/**  累计充值标签页 **/
		private var _btnTagPile:Button;
		public function get btnTagPile():Button
		{
			return _btnTagPile;
		}
		public function set btnTagPile(value:Button):void
		{
			_btnTagPile = value;
		}
		
		/**  单笔充值标签页 **/
		private var _btnTagSingle:Button;
		public function get btnTagSingle():Button
		{
			return _btnTagSingle;
		}
		public function set btnTagSingle(value:Button):void
		{
			_btnTagSingle = value;
		}
		
		private var _timeLabelPre:Label;
		/**  活动时间 **/
		public function get timeLabelPre():Label
		{
			return _timeLabelPre;
		}
		/** @private **/
		public function set timeLabelPre(value:Label):void
		{
			_timeLabelPre = value;
		}
		private var _timeLabel1:Label;
		/**  活动时间 **/
		public function get timeLabel1():Label
		{
			return _timeLabel1;
		}
		/** @private **/
		public function set timeLabel1(value:Label):void
		{
			_timeLabel1 = value;
		}
		private var _timeLabel2:Label;
		/**  活动时间 **/
		public function get timeLabel2():Label
		{
			return _timeLabel2;
		}
		/** @private **/
		public function set timeLabel2(value:Label):void
		{
			_timeLabel2 = value;
		}
		private var _timeLabel3:Label;
		/**  活动时间 **/
		public function get timeLabel3():Label
		{
			return _timeLabel3;
		}
		/** @private **/
		public function set timeLabel3(value:Label):void
		{
			_timeLabel3 = value;
		}
		private var _descLabelPre:Label;
		/**  活动描述 **/
		public function get descLabelPre():Label
		{
			return _descLabelPre;
		}
		/** @private **/
		public function set descLabelPre(value:Label):void
		{
			_descLabelPre = value;
		}
		private var _descLabel:Label;
		/**  活动描述 **/
		public function get descLabel():Label
		{
			return _descLabel;
		}
		/** @private **/
		public function set descLabel(value:Label):void
		{
			_descLabel = value;
		}
		private var _lastLabel:Label;
		/**  还差xxx元宝 **/
		public function get lastLabel():Label
		{
			return _lastLabel;
		}
		/** @private **/
		public function set lastLabel(value:Label):void
		{
			_lastLabel = value;
		}
		private var _meetLabel:Label;
		/**  满足条件后 ... **/
		public function get meetLabel():Label
		{
			return _meetLabel;
		}
		/** @private **/
		public function set meetLabel(value:Label):void
		{
			_meetLabel = value;
		}
		private var _btnRecharge:Button;
		/**  快速充值 **/
		public function get btnRecharge():Button
		{
			return _btnRecharge;
		}
		/** @private **/
		public function set btnRecharge(value:Button):void
		{
			_btnRecharge = value;
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
		/** 满足条件后描述 */
		private var _tlMeet:CJTaskLabel;

		/** 当前累积充值类型 **/
		private var _curPRType:String = "0";
		
		private var _lastTaskLabel:CJTaskLabel = new CJTaskLabel;
		
		/** 标题 **/
		private var _title:CJPanelTitle;
		
		/** 翻页面板 **/
		private var _turnPage:CJTurnPage = new CJTurnPage(3);

		/** 服务器开服时间 **/
		private var _serverOpenTime:int = 0;
		/** 累积充值数据 {activityType:{activityType:xxx, activityIndex:xxx, pilegold:xxx}} **/
		private var _data:Object;
		
		/** 初始化显示类型 */
		/** 初始化显示类型 - 累计充值 */
		private const INIT_SHOW_TYPE_PILE:int = 1;
		/** 初始化显示类型 - 单笔充值 */
		private const INIT_SHOW_TYPE_SINGLE:int = 2;
		/** 初始化显示类型 - 单笔充值 */
		private const INIT_SHOW_TYPE_BOTH:int = 3;
		/** 初始化显示类型 - 没有活动 */
		private const INIT_SHOW_TYPE_NONE:int = 0;
		
		/** 数据初始化状态 */
		private var _dataPileInit:Boolean = false;
		private var _dataSingleInit:Boolean = false;
		
		public function CJPileRechargeLayer()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			width = SApplicationConfig.o.stageWidth;
			height = SApplicationConfig.o.stageHeight;
			
			btnClose.addEventListener(Event.TRIGGERED, function(e:Event):void{
				SApplication.moduleManager.exitModule("CJPileRechargeModule");
			});
			
			btnRecharge.addEventListener(Event.TRIGGERED, function(e:Event):void{
				SApplication.moduleManager.exitModule("CJPileRechargeModule");
				if(ConstPlatformId.isWebChargeChannel())
				{
					CJMapUtil.enterCharge();
					return;
				}
				// 进入充值模块
				SApplication.moduleManager.enterModule("CJRechargeModule");
			});
			btnRecharge.defaultLabelProperties.textFormat = ConstTextFormat.textformatyellowcenter;
			btnRecharge.label = CJLang("pile_recharge_btn_recharge");//"快速充值";
			
			// 累计充值小表头
//			tagLabel.textRendererProperties.textFormat = ConstTextFormat.pileTextformat12;
//			tagLabel.text = CJLang("pile_recharge_name_0");//"累积充值";
//			tagLabel.textRendererFactory = textRender.glowTextRender;
			
			var simgPile:Scale3Image = new Scale3Image(new Scale3Textures(SApplication.assets.getTexture("chongzhi_anniu01"), 13, 2));
			simgPile.width = 103;
			simgPile.height = 19;
			var simgDisPile:Scale3Image = new Scale3Image(new Scale3Textures(SApplication.assets.getTexture("chongzhi_anniu02"), 13, 2));
			simgDisPile.width = 103;
			simgDisPile.height = 19;
			var simgSingle:Scale3Image = new Scale3Image(new Scale3Textures(SApplication.assets.getTexture("chongzhi_anniu01"), 13, 2));
			simgSingle.width = 103;
			simgSingle.height = 19;
			var simgDisSingle:Scale3Image = new Scale3Image(new Scale3Textures(SApplication.assets.getTexture("chongzhi_anniu02"), 13, 2));
			simgDisSingle.width = 103;
			simgDisSingle.height = 19;
			
			// 标签 - 累计充值
			btnTagPile.defaultLabelProperties.textFormat = ConstTextFormat.pileTextformat12;
			btnTagPile.label = CJLang("pile_recharge_name_0");//"累积充值";
			btnTagPile.labelFactory = textRender.glowTextRender;
			btnTagPile.defaultSkin = simgDisPile;
			btnTagPile.defaultSelectedSkin = simgPile;
			btnTagPile.height = 19;
			btnTagPile.addEventListener(Event.TRIGGERED, _onBtnClickPile);
			btnTagPile.isSelected = true;
			
			// 标签 - 单笔充值
			btnTagSingle.defaultLabelProperties.textFormat = ConstTextFormat.pileTextformat12;
			btnTagSingle.label = CJLang("single_recharge_name_0");//"单笔充值";
			btnTagSingle.labelFactory = textRender.glowTextRender;
			btnTagSingle.defaultSkin = simgDisSingle;
			btnTagSingle.defaultSelectedSkin = simgSingle;
			btnTagSingle.height = 19;
			btnTagSingle.addEventListener(Event.TRIGGERED, _onBtnClickSingle);
			btnTagSingle.isSelected = false;
			
			// 活动时间
			timeLabelPre.textRendererProperties.textFormat = ConstTextFormat.textformatwhite;
			timeLabelPre.text = CJLang("pile_recharge_time_label_pre");//"活动时间：";
			timeLabel1.textRendererProperties.textFormat = ConstTextFormat.textformatyellow;
//			timeLabel1.text = "2012-12-12 00:00:00";
			timeLabel2.textRendererProperties.textFormat = ConstTextFormat.textformatwhite;
			timeLabel2.text = CJLang("pile_recharge_time_label_2");//"至";
			timeLabel3.textRendererProperties.textFormat = ConstTextFormat.textformatyellow;
//			timeLabel3.text = "2012-12-12 00:00:00";
			
			// 活动描述
			descLabelPre.textRendererProperties.textFormat = ConstTextFormat.textformatwhite;
			descLabelPre.text = CJLang("pile_recharge_desc_label_pre");//"活动描述：";
			descLabel.textRendererProperties.textFormat = ConstTextFormat.textformatwhite;
			descLabel.textRendererProperties.multiline = true; // 可显示多行
			descLabel.textRendererProperties.wordWrap = true; // 可自动换行
			descLabel.text = CJLang("pile_recharge_desc_0");
			
			// 还差xxx元宝
			addChild(_lastTaskLabel);
			_lastTaskLabel.x = lastLabel.x;
			_lastTaskLabel.y = lastLabel.y;
			_lastTaskLabel.width = lastLabel.width;
			_lastTaskLabel.height = lastLabel.height;
			_lastTaskLabel.fontSize = 10;
			// 满足条件后 ...
			_tlMeet = new CJTaskLabel;
			addChild(_tlMeet);
			_tlMeet.x = meetLabel.x;
			_tlMeet.y = meetLabel.y;
			_tlMeet.width = 310;
			_tlMeet.height = meetLabel.height;
			_tlMeet.fontSize = 10;
			_tlMeet.text = CJLang("pile_recharge_meet_label");
//			meetLabel.textRendererProperties.textFormat = ConstTextFormat.textformatwhite;
//			meetLabel.text = CJLang("pile_recharge_meet_label");//"满足条件后，请到动态中领取相应奖励。";
			
			
			// 获取单笔充值信息
//			SocketCommand_singleRecharge.getSingleRechargeInfo();
			
			// title
			// 标题
			_title = new CJPanelTitle(CJLang("pile_recharge_title"));
			addChildAt(_title, 4);
			_title.x = 90;
			_title.y = 5;
			
			
			// 添加数据监听
			var listLayout:VerticalLayout = new VerticalLayout();
			listLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
			listLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_RIGHT;
			listLayout.gap = 0;
			_turnPage.type = CJTurnPage.SCROLL_V;
			_turnPage.layout = listLayout;
			_turnPage.itemRendererFactory =  function _getRenderFatory():IListItemRenderer
			{
				const render:CJPileRechargeItem = new CJPileRechargeItem();
				render.owner = _turnPage;
				return render;
			};
			_turnPage.x = 35;
			_turnPage.y = 130;
			_turnPage.setRect(300, 162);
			addChild(_turnPage);
			
			// 增加监听事件
			_addDataLiteners()
			// 向服务器申请数据
			_dataRequest();
		}
		/**
		 * 增加监听事件
		 * 
		 */		
		private function _addDataLiteners():void
		{
			// 监听累计充值数据变化
			CJDataManager.o.DataOfPileRecharge.addEventListener(DataEvent.DataChange, _onDataChangePile);
			// 监听单笔充值数据变化
			CJDataManager.o.DataOfSingleRecharge.addEventListener(DataEvent.DataChange, _onDataChangeSingle);
		}
		
		/**
		 * 移除所有数据监听
		 * 
		 */		
		private function _removeDataListeners():void
		{
			// 移除监听累计充值数据变化
			CJDataManager.o.DataOfPileRecharge.removeEventListener(DataEvent.DataChange, _onDataChangePile);
			// 移除监听单笔充值数据变化
			CJDataManager.o.DataOfSingleRecharge.removeEventListener(DataEvent.DataChange, _onDataChangeSingle);
		}
		
		/**
		 * 数据变化处理 - 累计充值
		 * 
		 */		
		private function _onDataChangePile():void
		{
			_dataPileInit = true;
			_onDataChange();
		}
		
		/**
		 * 数据变化处理 - 单笔充值
		 * 
		 */	
		private function _onDataChangeSingle():void
		{
			_dataSingleInit = true;
			_onDataChange();
		}
		
		/**
		 * 数据发生变化处理 - 累计充值与单笔充值数据全部收到后初始化显示
		 * 
		 */		
		private function _onDataChange():void
		{
			if (_dataPileInit && _dataSingleInit)
			{
				_gotoInitShow();
			}
		}
		
		/**
		 * 向服务器申请数据：累计充值与单笔充值数据
		 * 
		 */		
		private function _dataRequest():void
		{
			_dataPileInit = false;
			_dataSingleInit = false;
			// 申请累计充值
			SocketCommand_pileRecharge.getInfo(null);
			// 申请单笔充值
			SocketCommand_singleRecharge.getSingleRechargeInfo();
		}
		
		
		/**
		 * 初始化显示
		 * 
		 */		
		private function _gotoInitShow():void
		{
			var initShowType:int = INIT_SHOW_TYPE_NONE;
			// 累计充值是否活动中
			var isShowPileRecharge:Boolean = CJRechargeUtil.isPileRechargeActivity();
			// 单笔充值是否活动中
			var isShowSingleRecharge:Boolean = CJRechargeUtil.isSingleRechargeActivity();
			
//			isShowPileRecharge = true;
//			isShowSingleRecharge = false;
			
			if (isShowPileRecharge && isShowSingleRecharge)
			{
				initShowType = INIT_SHOW_TYPE_BOTH;
			}
			else if (isShowPileRecharge)
			{
				// 只显示累计充值
				initShowType = INIT_SHOW_TYPE_PILE;
			}
			else if (isShowSingleRecharge)
			{
				// 只显示单笔充值
				initShowType = INIT_SHOW_TYPE_SINGLE;
			}
			_initShow(initShowType);
		}
		
		/**
		 * 界面按开启活动初始化显示信息
		 * @param initShowType:	INIT_SHOW_TYPE_PILE - 只显示累计充值;
		 * 						INIT_SHOW_TYPE_SINGLE - 只显示单笔充值;
		 * 						INIT_SHOW_TYPE_BOTH - 累计、单笔充值都显示.
		 * 
		 */		
		private function _initShow(initShowType:int):void
		{
			if (initShowType == INIT_SHOW_TYPE_PILE)
			{
				// 累计充值
				btnTagSingle.visible = false;
				
				// 获取累积充值信息
//				SocketCommand_pileRecharge.getInfo(_callback); 
				
				_showPileInfo();
			}
			else if (initShowType == INIT_SHOW_TYPE_SINGLE)
			{
				// 单笔充值
				var firstBtnX:int = btnTagPile.x;
				btnTagPile.visible = false;
				btnTagSingle.x = firstBtnX;
				btnTagSingle.isSelected = true;
				
				_showSingleInfo();
			}
			else if (initShowType == INIT_SHOW_TYPE_BOTH)
			{
				// 都显示
				_showPileInfo();
			}
			else
			{
				// 没有活动中的充值
				btnTagPile.visible = false;
				btnTagSingle.visible = false;
			}
		}
		/**
		 * 显示累计充值信息
		 * 
		 */		
		private function _showPileInfo():void
		{
			if (btnTagPile.visible)
			{
				btnTagPile.isSelected = true;
			}
			if (btnTagSingle.visible)
			{
				btnTagSingle.isSelected = false;
			}
			// 设置显示数据List - 累计充值
			_setShowDataPile();
			// 显示说明文字
			_setTextPile();
			// 设置活动时间
			_setTimePile();
		}
		/**
		 * 显示单笔充值信息
		 * 
		 */		
		private function _showSingleInfo():void
		{
			if (btnTagPile.visible)
			{
				btnTagSingle.isSelected = true;
			}
			if (btnTagSingle.visible)
			{
				btnTagPile.isSelected = false;
			}
			// 设置显示数据List - 单笔充值
			_setShowDataSingle();
			// 显示说明文字
			_setTextSingle();
			// 设置活动时间
			_setTimeSingle();
		}
		
		/**
		 * 按钮点击响应 - 累计充值
		 * @param e
		 * 
		 */		
		private function _onBtnClickPile(e:Event):void
		{
			_showPileInfo();
		}
		/**
		 * 按钮点击响应 - 单笔充值
		 * @param e
		 * 
		 */	
		private function _onBtnClickSingle(e:Event):void
		{
			_showSingleInfo();
		}
		private function _setTimePile():void
		{
			var startTime:uint = 0;// 活动开启时间
			var endTime:uint = 0;// 活动结束时间
			_curPRType = CJDataManager.o.DataOfPileRecharge.curType;
			var js:Json_pile_recharge_setting = CJDataOfPileRechargeSetting.o.getPileRechargeSetting(_curPRType);
			if (null != js.startday)
			{
				startTime = int(js.startday)*3600*24 + CJDataManager.o.DataOfPileRecharge.serverOpenTime;
			}
			else if(null != js.startdate)
			{
				// 切分日期
				var date:Array = String(js.startdate).split("/");
				if (date.length == 1)
					date = String(js.startdate).split("-");
				// 切分时间
				var atime:Array = String(js.starttime).split(":");
				
				var aDate:Date = new Date(date[0],date[1],date[2], atime[0],atime[1],atime[2]);
				
				startTime = int(aDate.time / 1000);
			}
			endTime = startTime + int(js.effectivetime)*60;
			
			var sDate:Date = new Date(startTime*1000);
			var eDate:Date = new Date(endTime*1000);
			
			// 更新活动时间
			timeLabel1.text = sDate.fullYear+"-"+(sDate.month + 1)+"-"+sDate.date+"  "
				+String("00"+Math.floor(sDate.hours)).substr(-2) +":"+String("00"+Math.floor(sDate.minutes)).substr(-2);
			timeLabel3.text = eDate.fullYear+"-"+(eDate.month + 1)+"-"+eDate.date+"  "
				+String("00"+Math.floor(eDate.hours)).substr(-2)+":"+String("00"+Math.floor(eDate.minutes)).substr(-2);
		}
		private function _setTimeSingle():void
		{
			var startTime:uint = 0;// 活动开启时间
			var endTime:uint = 0;// 活动结束时间
			var curSRType:String = CJDataManager.o.DataOfSingleRecharge.curType;
			var js:Json_single_recharge_setting = CJDataOfSingleRechargeSetting.o.getSingleRechargeSetting(curSRType);
			if (null != js.startday)
			{
				startTime = int(js.startday) * 3600 * 24 + CJDataManager.o.DataOfSingleRecharge.serverOpenTime;
			}
			else if(null != js.startdate)
			{
				// 切分日期
				var date:Array = String(js.startdate).split("/");
				if (date.length == 1)
					date = String(js.startdate).split("-");
				// 切分时间
				var atime:Array = String(js.starttime).split(":");
				
				var aDate:Date = new Date(date[0],date[1],date[2], atime[0],atime[1],atime[2]);
				
				startTime = int(aDate.time / 1000);
			}
			endTime = startTime + int(js.effectivetime) * 60;
			
			var sDate:Date = new Date(startTime * 1000);
			var eDate:Date = new Date(endTime * 1000);
			
			// 更新活动时间
			timeLabel1.text = sDate.fullYear + "-" + (sDate.month + 1) + "-" + sDate.date + "  "
				+ String("00" + Math.floor(sDate.hours)).substr(-2) + ":" + String("00" + Math.floor(sDate.minutes)).substr(-2);
			timeLabel3.text = eDate.fullYear + "-" + (eDate.month + 1) + "-" + eDate.date + "  "
				+ String("00" + Math.floor(eDate.hours)).substr(-2) + ":" + String("00" + Math.floor(eDate.minutes)).substr(-2);
		}
		/**
		 * 设置显示文字 - 累计充值
		 * 
		 */		
		private function _setTextPile():void
		{
			//活动描述内容
			descLabel.text = CJLang("pile_recharge_desc_0");
			_tlMeet.text = CJLang("pile_recharge_meet_label");
			_lastTaskLabel.visible = true;
			
			var pileRechargeData:Object = CJDataManager.o.DataOfPileRecharge.pileRechargeData; 
			var gold:int = pileRechargeData[CJDataManager.o.DataOfPileRecharge.curType] == null ? 0 : pileRechargeData[CJDataManager.o.DataOfPileRecharge.curType];
			_lastTaskLabel.text = CJLang("pile_recharge_last_gold", {"gold":gold});
		}
		/**
		 * 设置显示文字 - 单笔充值
		 * 
		 */		
		private function _setTextSingle():void
		{
			descLabel.text = CJLang("single_recharge_desc_0");
			_tlMeet.text = CJLang("single_recharge_meet_label");
			_lastTaskLabel.visible = false;
		}
		/**
		 * 设置显示数据List - 累计充值
		 * 
		 */	
		private function _setShowDataPile():void
		{
			// 赋值
			var listData:Array = _getDataArr();
			//设置渲染属性
			var groceryList:ListCollection = new ListCollection(listData);
			_turnPage.dataProvider = groceryList;
		}
		/**
		 * 设置显示数据List - 单笔充值
		 * 
		 */		
		private function _setShowDataSingle():void
		{
			// 赋值
			var listData:Array = _getSingleDataArr();
			//设置渲染属性
			var groceryList:ListCollection = new ListCollection(listData);
			_turnPage.dataProvider = groceryList;
		}
		
		private function _callback(e:SocketMessage):void
		{
			_serverOpenTime = e.retparams[0];
			_data = e.retparams[1];
			_curPRType = e.retparams[2];
			
			if(_curPRType == "-1")
			{
				return;
			}
			var gold:int = _data[_curPRType] == null ? 0 : _data[_curPRType];
			_lastTaskLabel.text = CJLang("pile_recharge_last_gold", {"gold":gold});//"活动期间您已充值 999 元宝"
			
			var startTime:uint = 0;// 活动开启时间
			var endTime:uint = 0;// 活动结束时间
			var js:Json_pile_recharge_setting = CJDataOfPileRechargeSetting.o.getPileRechargeSetting(_curPRType);
			if (null != js.startday)
			{
				startTime = int(js.startday)*3600*24 + _serverOpenTime;
			}
			else if(null != js.startdate)
			{
				// 切分日期
				var date:Array = String(js.startdate).split("/");
				if (date.length == 1)
					date = String(js.startdate).split("-");
				// 切分时间
				var atime:Array = String(js.starttime).split(":");
				
				var aDate:Date = new Date(date[0],date[1],date[2], atime[0],atime[1],atime[2]);
				
				startTime = int(aDate.time / 1000);
			}
			endTime = startTime + int(js.effectivetime)*60;
			
			var sDate:Date = new Date(startTime*1000);
			var eDate:Date = new Date(endTime*1000);
			
			// 更新活动时间
			timeLabel1.text = sDate.fullYear+"-"+(sDate.month + 1)+"-"+sDate.date+"  "
				+String("00"+Math.floor(sDate.hours)).substr(-2) +":"+String("00"+Math.floor(sDate.minutes)).substr(-2);
			timeLabel3.text = eDate.fullYear+"-"+(eDate.month + 1)+"-"+eDate.date+"  "
				+String("00"+Math.floor(eDate.hours)).substr(-2)+":"+String("00"+Math.floor(eDate.minutes)).substr(-2);
			
			// 赋值
			var listData:Array = _getDataArr();
			//设置渲染属性
			var groceryList:ListCollection = new ListCollection(listData);
			_turnPage.dataProvider = groceryList;
		}
		
		
		/**
		 * 获取单笔充值显示数据
		 * @return 
		 * 
		 */		
		private function _getSingleDataArr():Array
		{
			// 返回信息
			var listData:Array = new Array();
			// 数据信息
			var data:Object;
			// {singleType:Json_single_recharge_setting}
			var singleRechargeSetting:Object = CJDataOfSingleRechargeSetting.o.singleRechargeSetting;
			// {singleType:{singleid:Json_single_recharge_gift_setting}}
			var singleRechargeGiftSetting:Object = CJDataOfSingleRechargeSetting.o.singleRechargeGiftSetting;
			
			var curSRType:String = CJDataManager.o.DataOfSingleRecharge.curType;
			var srData:Object = CJDataManager.o.DataOfSingleRecharge.singleRechargeData;
			for( var singleType:String in singleRechargeSetting)
			{
				if (singleType != curSRType)
				{
					continue;
				}
				var temp:Object = singleRechargeGiftSetting[singleType]
				if (temp)
				{
					for (var singleIndex:String in temp)
					{
						var jsSingleRecharge:Json_single_recharge_gift_setting = CJDataOfSingleRechargeSetting.o.getSingleRechargeGiftSetting(singleType, singleIndex);
						if (jsSingleRecharge)
						{
							data = new Object;
							data.weight = int(singleType) * 100000000 + jsSingleRecharge.gold*10;
							// 下一条配置，用于显示充值金额区间
							var jsSingleRechargeNext:Json_single_recharge_gift_setting = CJDataOfSingleRechargeSetting.o.getSingleRechargeGiftSetting(singleType, String(int(singleIndex) + 1));
							if (jsSingleRechargeNext)
							{
								// 有下一条
								data.desc = CJLang("single_recharge_item_desc0",{"gold0":jsSingleRecharge.gold, "gold1":(int(jsSingleRechargeNext.gold) - 1)});
							}
							else
							{
								// 没有下一条
								data.desc = CJLang("single_recharge_item_desc1",{"gold":jsSingleRecharge.gold});
							}
							
							data.gifts = new Array; // 礼包
							for (var i:int=0; i<5; ++i)
							{
								var itemtid:int = int(jsSingleRecharge["itemtid"+i]);
								var itemcount:int = int(jsSingleRecharge["itemcount"+i]);
								if (itemtid == 0)
									break;
								data.gifts.push( {itemtid:itemtid, itemcount:itemcount});
							}
							// 是否显示已领取
							data.isGet = !(srData[singleIndex] == null);
							listData.push(data);
						}
					}
				}
			}
			
			// 排序
			listData.sortOn("weight", Array.NUMERIC);
			return listData;
		}
		
		// 获取数据 - 累计充值
		private function _getDataArr():Array
		{
			// 返回信息
			var listData:Array = new Array();
			// 数据信息
			var data:Object;
			// {pileType:Json_pile_recharge_setting}
			var pileRechargeSetting:Object = CJDataOfPileRechargeSetting.o.pileRechargeSetting;
			// {pileType:{pileid:Json_pile_recharge_gift_setting}}
			var PileRechargeGiftSetting:Object = CJDataOfPileRechargeSetting.o.PileRechargeGiftSetting;
			
			var curSRType:String = CJDataManager.o.DataOfPileRecharge.curType;
			_data = CJDataManager.o.DataOfPileRecharge.pileRechargeData;
			
			for( var pileType:String in pileRechargeSetting)
			{
				if (pileType != curSRType)
				{
					continue;
				}
				var temp:Object = PileRechargeGiftSetting[pileType]
				if (temp)
				{
					for (var pileIndex:String in temp)
					{
						var jsPileRecharge:Json_pile_recharge_gift_setting = CJDataOfPileRechargeSetting.o.getPileRechargeGiftSetting(pileType, pileIndex);
						if (jsPileRecharge)
						{
							data = new Object;
							data.weight = int(pileType) * 100000000 + jsPileRecharge.gold * 10;
							data.desc = CJLang("pile_recharge_item_desc",{"gold":jsPileRecharge.gold});
							
							data.gifts = new Array; // 礼包
							for (var i:int=0; i<5; ++i)
							{
								var itemtid:int = int(jsPileRecharge["itemtid"+i]);
								var itemcount:int = int(jsPileRecharge["itemcount"+i]);
								if (itemtid == 0)
									break;
								data.gifts.push( {itemtid:itemtid, itemcount:itemcount});
							}
							var gold:int = _data[curSRType] == null ? 0 : _data[curSRType];
							data.isGet = (gold >= int(jsPileRecharge.gold)) ? 1 : 0;
							listData.push(data);
						}
					}
				}
			}
			
			// 排序
			listData.sortOn("weight", Array.NUMERIC);
			return listData;
		}
		override public function dispose():void
		{
			_removeDataListeners();
		}
	}
}