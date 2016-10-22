package SJ.Game.winebar
{
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.getTimer;
	
	import SJ.Common.Constants.ConstMainUI;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Common.Constants.ConstWinebar;
	import SJ.Common.global.textRender;
	import SJ.Game.SocketServer.SocketCommand_herotag;
	import SJ.Game.SocketServer.SocketCommand_role;
	import SJ.Game.SocketServer.SocketCommand_winebar;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.controls.CJItemUtil;
	import SJ.Game.controls.CJPanelTitle;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfWinebar;
	import SJ.Game.data.config.CJDataOfFuncPropertyList;
	import SJ.Game.data.config.CJDataOfHeroTagProperty;
	import SJ.Game.data.config.CJDataOfWinebarProperty;
	import SJ.Game.data.config.CJDataOfWinebarRefreshProperty;
	import SJ.Game.data.json.Json_function_open_setting;
	import SJ.Game.data.json.Json_hero_upper_limit_config;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJMessageBox;
	import SJ.Game.layer.CJMsgBoxSilverNotEnough;
	import SJ.Game.task.CJTaskFlowString;
	import SJ.Game.task.util.CJTaskLabel;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.Events.DataEvent;
	import engine_starling.data.SDataBase;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.display.Scale9Image;
	import feathers.display.TiledImage;
	import feathers.textures.Scale9Textures;
	
	import starling.animation.IAnimatable;
	import starling.events.Event;
	
	/**
	 * 酒馆主界面
	 * @author longtao
	 * 
	 */
	public class CJWinebarLayer extends SLayer implements IAnimatable
	{
		private var _labelTitle:Label;
		/** 标题文字 */
		public function get labelTitle():Label
		{
			return _labelTitle;
		}
		/** @private */
		public function set labelTitle(value:Label):void
		{
			_labelTitle = value;
		}
		
		private var _layerBG:SLayer;
		/**
		 * 背景框
		 */
		public function get layerBG():SLayer
		{
			return _layerBG;
		}
		
		/**
		 * @private
		 */
		public function set layerBG(value:SLayer):void
		{
			_layerBG = value;
		}
		
		private var _btnStartPick:Button;

		/**
		 * 开始抽取
		 */
		public function get btnStartPick():Button
		{
			return _btnStartPick;
		}

		/**
		 * @private
		 */
		public function set btnStartPick(value:Button):void
		{
			_btnStartPick = value;
		}

		
		private var _btnRefresh:Button;

		/**
		 * 立即刷新
		 */
		public function get btnRefresh():Button
		{
			return _btnRefresh;
		}

		/**
		 * @private
		 */
		public function set btnRefresh(value:Button):void
		{
			_btnRefresh = value;
		}
		
		private var _btnGemBook:Button;

		/**
		 * 宝典按钮
		 */
		public function get btnGemBook():Button
		{
			return _btnGemBook;
		}

		/**
		 * @private
		 */
		public function set btnGemBook(value:Button):void
		{
			_btnGemBook = value;
		}

		
		private var _labelCost:Label;

		/**
		 * 花费
		 */
		public function get labelCost():Label
		{
			return _labelCost;
		}

		/**
		 * @private
		 */
		public function set labelCost(value:Label):void
		{
			_labelCost = value;
		}

		
		private var _labelRefresh:Label;

		/**
		 * 酒馆时间更新
		 */
		public function get labelRefresh():Label
		{
			return _labelRefresh;
		}

		/**
		 * @private
		 */
		public function set labelRefresh(value:Label):void
		{
			_labelRefresh = value;
		}

		
		private var _labelVipExplain:Label;

		/**
		 * Vip 抽牌次数说明
		 */
		public function get labelVipExplain():Label
		{
			return _labelVipExplain;
		}

		/**
		 * @private
		 */
		public function set labelVipExplain(value:Label):void
		{
			_labelVipExplain = value;
		}

		
		private var _labelWinebarExplain:Label;

		/**
		 * 酒馆说明
		 */
		public function get labelWinebarExplain():Label
		{
			return _labelWinebarExplain;
		}

		/**
		 * @private
		 */
		public function set labelWinebarExplain(value:Label):void
		{
			_labelWinebarExplain = value;
		}

		
		private var _btnClose:Button;

		/**
		 * 关闭按钮
		 */
		public function get btnClose():Button
		{
			return _btnClose;
		}

		/**
		 * @private
		 */
		public function set btnClose(value:Button):void
		{
			_btnClose = value;
		}
		
		
		private var _layerCardPanel:SLayer;
		/**
		 * 翻牌面板
		 */
		public function get layerCardPanel():SLayer
		{
			return _layerCardPanel;
		}

		/**
		 * @private
		 */
		public function set layerCardPanel(value:SLayer):void
		{
			_layerCardPanel = value;
		}
		
		// 当前操作的酒馆id
		private var _winebarid:String;
		/** 当前操作的酒馆id **/
		public function get winebarid():String
		{
			return _winebarid;
		}
		public function set winebarid(value:String):void
		{
			_winebarid = value;
		}
		
		// 刷新时间
		private var _newTime:Number = 0;
		private var _oldTime:Number = 0;
		private var _time:int = 0xFFFFFF;
		private const ConstTimeGap:Number = 1;
		private const RefreshTime:int = 2*60*60;
		
		// 酒馆刷新显示时间
		private var _lbRefresh:Label;
		

		/** 标题 **/
		private var _title:CJPanelTitle;
		
		/** 首次开启武将界面申请开启标签数量 **/
		private var _heroTagCount:uint;
		
		/** 酒馆说明 **/
		private var _richlabelWinebarExplain:CJTaskLabel;
		/** 武将卡牌界面 **/
		private var _heroCardLayer:CJHeroCardPanel;
		/** 该酒馆的花费 **/
		private var _cost:String;
		
		public function CJWinebarLayer()
		{
			super();
		}
		
		
		
		override protected function initialize():void
		{
			super.initialize();
			
			width = ConstMainUI.MAPUNIT_WIDTH;
			height = ConstMainUI.MAPUNIT_HEIGHT;
			
			// 背景
			var _bg:Scale9Image;
			_bg = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_quanpingzhuangshi") , new Rectangle(14,13 ,2,2)));
			_bg.width = layerBG.width;
			_bg.height = layerBG.height;
			layerBG.addChild(_bg);
			// 背景上层的深色图层
			_bg = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_dinew") , new Rectangle(1,1 ,2,2)));
			_bg.width = layerBG.width;
			_bg.height = layerBG.height;
			_bg.alpha = 0.5;
			layerBG.addChild(_bg);
			// 标题底纹
			var top :TiledImage = new TiledImage(SApplication.assets.getTexture("common_quanpingtoubudi"));
			top.width = SApplicationConfig.o.stageWidth;
			layerBG.addChild(top);
			// 底纹
			_bg = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_quanpingzhuangshi") , new Rectangle(14,13 ,2,2)));
			_bg.width = layerBG.width;
			_bg.height = layerBG.height;
			layerBG.addChild(_bg);
			
			/// 武将面板
			_heroCardLayer = new CJHeroCardPanel();
			_heroCardLayer.x = layerCardPanel.x;
			_heroCardLayer.y = layerCardPanel.y;
			_heroCardLayer.width = layerCardPanel.width;
			_heroCardLayer.height = layerCardPanel.height;
			addChild(_heroCardLayer);
			
			// 关闭按钮
			btnClose.defaultSkin = new SImage(SApplication.assets.getTexture("common_quanpingguanbianniu01"));
			btnClose.downSkin = new SImage(SApplication.assets.getTexture("common_quanpingguanbianniu02"));
			btnClose.addEventListener(Event.TRIGGERED, function (e:Event):void{
				SApplication.moduleManager.exitModule("CJWinebarModule");
			});
			
			//获取服务器时间
			SocketManager.o.callwithRtn(ConstNetCommand.CS_WINEBAR_SERVERTIME, serverTimeBack);
			
			// 检测
			_checkLevelTag();
		}
		
		//记录服务器时间，单位是秒
		private var curServerTime:uint=0;
		private var curTimeFlag:uint=0;
		private function serverTimeBack(message:SocketMessage):void
		{
			curServerTime = message.retparams[0];
			curTimeFlag = int(getTimer()/1000);
		}
		
		//获得当前时间，如果无法获得服务器时间，取本地时间， 单位是秒
		private function getCurTime():int
		{
			if(curServerTime!=0)
			{
				return curServerTime + (int(getTimer()/1000) - curTimeFlag);
			}
			else
			{
				var date:Date = new Date();
				return int(date.time/1000);
			}
		}
		
		/**
		 * 检测限制等级的标签是否应该开启
		 */
		private function _checkLevelTag():void
		{
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
				// 酒馆数据
				var winebar:CJDataOfWinebar = CJDataManager.o.DataOfWinebar;
				if (winebar.dataIsEmpty)
				{
					winebar.addEventListener(DataEvent.DataLoadedFromRemote , _doinit);
					winebar.loadFromRemote(winebarid);
				}
				else
					_doinit();
			}
			
		}

		
		// 初始化数据
		private function _doinit():void
		{
			// 移除监听
			CJDataManager.o.DataOfWinebar.removeEventListener(DataEvent.DataLoadedFromRemote , _doinit);
			
			// 查看酒馆状态决定是否有开始抽取按钮
			var winebar:CJDataOfWinebar = CJDataManager.o.DataOfWinebar;
			var fontFormat:TextFormat = new TextFormat( "Arial", 10, 0xFFC915 );
//			labelTitle.textRendererProperties.textFormat = fontFormat;
//			labelTitle.text = CJLang("WINEBAR_TITLE");
			// 标题
			_title = new CJPanelTitle(CJLang("WINEBAR_TITLE"));
			addChild(_title);
			_title.x = labelTitle.x;
			_title.y = labelTitle.y;
			fontFormat = new TextFormat( "Arial", 12, 0xFFFFFF );
			// 开始抽取
			btnStartPick.name = "CJWinebar_0";
			btnStartPick.defaultLabelProperties.textFormat = fontFormat;
			btnStartPick.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniuda01new"));
			btnStartPick.downSkin = new SImage(SApplication.assets.getTexture("common_anniuda02new"));
			btnStartPick.label = CJLang("WINEBAR_LABEL_STARTPICK");
			btnStartPick.addEventListener(Event.TRIGGERED, function (e:Event):void{
				if (!__judge())
					return;
				
				SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _onStartpickComplete);
				SocketCommand_winebar.startpick();
				//处理指引
				if(CJDataManager.o.DataOfFuncList.isIndicating)
				{
					CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_INDICATE_NEXT_STEP);
				}
			});
			
			// 立即刷新
			btnRefresh.defaultLabelProperties.textFormat = fontFormat;
			btnRefresh.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniuda01new"));
			btnRefresh.downSkin = new SImage(SApplication.assets.getTexture("common_anniuda02new"));
			btnRefresh.label = CJLang("WINEBAR_LABEL_REFRESH");
			btnRefresh.name = "CJWinebar_1";
			btnRefresh.addEventListener(Event.TRIGGERED, function (e:Event):void{
				if (!__judge())
					return;
				
				if (_heroCardLayer.isplaying)
					return;
				
				SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _onRefreshComplete);
				SocketCommand_winebar.refresh(winebarid);
			});
			
			// 判断是否还有武将位置
			// return true继续运行，false跳出
			function __judge():Boolean
			{
				var heroCount:uint = CJDataManager.o.DataOfHeroList.heroCount;
				var tagCount:uint = CJDataManager.o.DataOfHeroTag.herotaglist.length;
				if (tagCount > heroCount)
					return true;
				
				// 飘字
				new CJTaskFlowString(CJLang("WINEBAR_HAVE_NO_TAG"), 1, 20).addToLayer();
				
				return false;
			}
			
			// 宝典按钮
			btnGemBook.defaultSkin = new SImage(SApplication.assets.getTexture("jiuguan_baodiantubiao"));
			btnGemBook.addEventListener(Event.TRIGGERED, function (e:Event):void{
				SApplication.moduleManager.enterModule("CJWinebarDictModule");
			});
			
			// 酒馆说明
			var describe:String = CJDataOfWinebarProperty.o.getData(winebarid).describe;
//			labelWinebarExplain.textRendererProperties.textFormat = new TextFormat( "Arial", 12, 0xFFFFA0 ); 
//			labelWinebarExplain.textRendererProperties.multiline = true;
//			labelWinebarExplain.textRendererProperties.wordWrap = true;
//			labelWinebarExplain.text = CJLang(describe);
			_richlabelWinebarExplain = new CJTaskLabel;
			_richlabelWinebarExplain.fontSize = 11;
			_richlabelWinebarExplain.x = labelWinebarExplain.x;
			_richlabelWinebarExplain.y = labelWinebarExplain.y + 10;
			_richlabelWinebarExplain.width = labelWinebarExplain.width;
			_richlabelWinebarExplain.height = labelWinebarExplain.height;
			
			_richlabelWinebarExplain.text = CJLang(describe);
			_richlabelWinebarExplain.wrap = true;
			addChild(_richlabelWinebarExplain);
			
			
			fontFormat = new TextFormat( "Arial", 10, 0xF0EAAC );
			// 花费说明
			_cost = CJDataOfWinebarRefreshProperty.o.getData(CJDataManager.o.DataOfHeroList.getMainHero().level).silver;
			labelCost.textRendererProperties.textFormat = fontFormat;
			var suffix:String = CJItemUtil.getMoneyFormat(CJDataManager.o.DataOfRole.silver);
			labelCost.text = _cost + "/" + suffix;
			
			/// 时间刷新
			labelRefresh.textRendererProperties.textFormat = ConstTextFormat.textformatyellow;
			// 获取时间戳
			var t_curtime:int = getCurTime();
			_time = RefreshTime -(t_curtime - int(winebar.refreshtime));
			// 刷新时间设置
			var str:String = CJLang("WINEBAR_REFRESH_DESCRIBE");
//			str += "    " + getTime(_time);
			labelRefresh.text = str;
			
			_lbRefresh = new Label;
			_lbRefresh.textRendererProperties.textFormat = ConstTextFormat.textformatwhite;
			_lbRefresh.x = labelRefresh.x + 100;
			_lbRefresh.y = labelRefresh.y;
			_lbRefresh.text = getTime(_time);
			addChild(_lbRefresh);
			
			fontFormat = new TextFormat("Arial", 9, 0xFFDE5B, null, null, null, null, null, TextFormatAlign.CENTER);
			// vip说明
			labelVipExplain.textRendererProperties.textFormat = fontFormat;
			labelVipExplain.textRendererFactory = textRender.standardTextRender;
			labelVipExplain.text = CJLang("WINEBAR_VIP_DESCRIBE");
			
			// 监听数据变化
			CJDataManager.o.DataOfWinebar.addEventListener(DataEvent.DataChange, _onDataChange);
			
			_updateLayer();
			
			if(CJDataManager.o.DataOfFuncList.isIndicating)
			{
				CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_INDICATE_NEXT_STEP);
			}
			
//			检测二次指引			
			this._checkNeedSecondIndicate();
		}
		
		private function _checkNeedSecondIndicate():void
		{
			//检测是否已经开启过引导  1 = 开启过
			var directed:int = CJDataManager.o.DataOfWinebar.secondDirect;
			if(directed == 0)
			{
				var winebarDirectData:SDataBase = new SDataBase("CJDataOfWinebar");
				winebarDirectData.loadFromCache();
				//是否已经开启过
				CJDataManager.o.DataOfWinebar.secondDirect = int(winebarDirectData.getData("secondDirect"));
				
				//如果需要显示开启引导
				if(CJDataManager.o.DataOfWinebar.secondDirect == 0 && int(CJDataManager.o.DataOfHeroList.getMainHero().level) >= 15)
				{
					var json:Json_function_open_setting = CJDataOfFuncPropertyList.o.getPropertyByModulename("WinebarSecond");
					if(json)
					{
						SApplication.moduleManager.enterModule("CJFunctionOpenModule" , json.functionid);
						winebarDirectData.setData("secondDirect" , 1);
						winebarDirectData.saveToCache();
						CJDataManager.o.DataOfWinebar.secondDirect = 1;
					}
				}
			}
		}
		
		override public function dispose():void
		{
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData, _onStartpickComplete);
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData, _openHeroTag);
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData, _onRefreshComplete);
			CJDataManager.o.DataOfWinebar.removeEventListener(DataEvent.DataChange, _onDataChange);
			super.dispose();
		}
		
		
		// 数据发生变化
		private function _onDataChange( e:Event ):void
		{
			var str:String = e.data.key;
			if( str.search("herostate") == -1)
				return;
			if( e.data.value != ConstWinebar.ConstWinebarHeroStateEmployed )
				return;
			_updateLayer();
		}
		
		/**
		 *  刷新界面 
		 */
		private function _updateLayer():void
		{
			var winebar:CJDataOfWinebar = CJDataManager.o.DataOfWinebar;
			// 按钮显示状态
			btnStartPick.visible = winebar.state == ConstWinebar.ConstWinebarStateFront ? true : false;
			
//			btnRefresh.visible = int(winebar.pickcount) != 0 && winebar.state == ConstWinebar.ConstWinebarStateBack ? false : true;
//			btnRefresh.visible = true;
//			if ( (int(winebar.pickcount) != 0) && 
//				(winebar.state != ConstWinebar.ConstWinebarStateBack) )
//				btnRefresh.visible = false;
			
			_heroCardLayer.updateLayer();
		}
		
		/// 开始抽取武将
		private function _onStartpickComplete(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() != ConstNetCommand.CS_WINEBAR_STARTPICK)
				return;
			
			switch(message.retcode)
			{
				case 0:
					break;
				case 1:
					CJMessageBox(CJLang("ERROR_WINEBAR_CARD_BACK"));
					return;
				default:
					CJMessageBox(CJLang("ERROR_UNKNOWN")+ "CJWinebarLayer._onStartpickComplete retcode="+message.retcode );
					return;
			}
			
			e.target.removeEventListener(e.type, _onStartpickComplete);
			
			var rtnObject:Object = message.retparams;
			var _winebar:CJDataOfWinebar = CJDataManager.o.DataOfWinebar;
			_winebar.state = rtnObject[0];
			
			// 洗牌
			_heroCardLayer.cutCards();
			
			// 刷新界面
			_updateLayer();
		}
		
		/// 刷新酒馆
		private function _onRefreshComplete(e:Event):void
		{
			if(CJDataManager.o.DataOfFuncList.isIndicating)
			{
				CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_INDICATE_NEXT_STEP);
			}
			
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() != ConstNetCommand.CS_WINEBAR_REFRESH)
				return;
			
			switch(message.retcode)
			{
				case 0:
					break;
				case 1:
//					CJMessageBox(CJLang("ERROR_WINEBAR_SILVER"));
					// 银两不足提示框 modify by sangxu 2013-09-04
					CJMsgBoxSilverNotEnough(CJLang("ERROR_WINEBAR_SILVER"), 
											"", 
											function():void{
												SApplication.moduleManager.exitModule("CJWinebarModule");
											});
					return;
				default:
					CJMessageBox(CJLang("ERROR_UNKNOWN")+ "CJWinebarLayer._onRefreshComplete retcode="+message.retcode );
					return;
			}
			
			e.target.removeEventListener(e.type, _onRefreshComplete);
			
			var rtnObject:Object = message.retparams;
			var _winebar:CJDataOfWinebar = CJDataManager.o.DataOfWinebar;
			_winebar.state = ConstWinebar.ConstWinebarStateFront;

			for ( var i:int=0; i<ConstWinebar.ConstWinebarMaxHeroCards; ++i )
			{
				_winebar.setData("herotemplateid"+i, rtnObject[i]);
				_winebar.setData("herostate"+i, ConstWinebar.ConstWinebarHeroStateNoSelected);
			}
			_winebar.pickcount = rtnObject[5];
			if(rtnObject[6] != null)_winebar.refreshtime = rtnObject[6];
			
			// 更新货币信息
			function __updateCost(message:SocketMessage):void
			{
				
				var suffix:String = CJItemUtil.getMoneyFormat(uint(message.retparams.silver));
				labelCost.text = _cost + "/" + suffix;
			}
			
			// 请求更新货币
			SocketCommand_role.get_role_info(__updateCost);
			/// 更新时间
			_time = RefreshTime;
			// 刷新界面
			_updateLayer();
		}
		
		public function advanceTime(time:Number):void
		{
			_newTime += time;
			if ( (_newTime - _oldTime) < ConstTimeGap )
			{
				return;
			}
			_oldTime = _newTime;
			_time--;
			// 刷新时间设置
			var str:String = getTime(_time);
			if (_lbRefresh)
				_lbRefresh.text = str;
			
			if ( _time < 0 )
			{
				// 查看酒馆状态决定是否有开始抽取按钮
				var winebar:CJDataOfWinebar = CJDataManager.o.DataOfWinebar;
				SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _onEndTime);
				SocketCommand_winebar.get_winbarInfo(winebarid);
			}
		}
		
		/**
		 * 重新获取酒馆数据刷新界面
		 * @param e
		 */
		private function _onEndTime(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() != ConstNetCommand.CS_WINEBAR_GETINFO)
				return;
			if(message.retcode == 0)
			{
				// 酒馆信息
				var winebarData:CJDataOfWinebar = CJDataManager.o.DataOfWinebar;
				// 重置信息
				winebarData.resetWinebar(message.retparams);
				
				/// 更新时间
				var t_curtime:int = getCurTime();
				_time = RefreshTime -(t_curtime - int(winebarData.refreshtime));
				// 刷新界面
				_updateLayer();
			}
		}
		
		private function getTime(num:Number):String
		{
			var str:String = "";
			str += uint(num/60/60) + ":";
			str += uint((num/60))%60 + ":";
			str += uint(num%60);
			return str;
		}
	}
}






