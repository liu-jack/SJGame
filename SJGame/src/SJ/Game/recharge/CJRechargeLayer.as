package SJ.Game.recharge
{
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import SJ.MainApplication;
	import SJ.Common.Constants.ConstGlobal;
	import SJ.Common.Constants.ConstNPCDialog;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstRecharge;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.Platform.ISPlatfrom;
	import SJ.Game.SocketServer.SocketCommand_role;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.controls.CJPanelFrame;
	import SJ.Game.controls.CJPanelTitle;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfPlatformProduct;
	import SJ.Game.data.CJDataOfPlatformProducts;
	import SJ.Game.data.CJDataOfPlatformReceipt;
	import SJ.Game.data.CJDataOfRole;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJLoadingLayer;
	import SJ.Game.utils.SSoundEffectUtil;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.Events.DataEvent;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	import engine_starling.utils.STween;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.display.Scale9Image;
	
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * 充值层
	 * @author zhengzheng
	 * 
	 */	
	public class CJRechargeLayer extends SLayer
	{
		/** 当前剩余文本*/
		private var _labCurLeft:Label;
		/** 当前拥有元宝数量*/
		private var _labGoldNum:Label;
		/** 关闭按钮*/
		private var _btnClose:Button;
		/** 充值活动按钮*/
		private var _btnPileRecharge:Button;
		/** 首充按钮*/
		private var _btnFirstRecharge:Button;
		/** 角色数据*/
		private var _roleData:CJDataOfRole;
		/** 充值显示层数组 */
		private var _arrayRecharge:Array;
		/** 上一次点击的item */
		private var _oldItem:CJRechargeItem;
		
		private var _dataPlatformProducts:CJDataOfPlatformProducts;
		
		private var iPlatform:ISPlatfrom;
		/** 是否可点击充值 */
		private var _rechargeClick:Boolean = true;
		
		public function CJRechargeLayer()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			_initData();
			_drawContent();
			_addListeners();
			_dataRequest();
		}
		
		/**
		 * 初始化数据
		 */		
		private function _initData():void
		{
			_roleData = CJDataManager.o.DataOfRole;
			this._arrayRecharge = new Array();
			_dataPlatformProducts = CJDataManager.o.DataOfPlatformProducts;
			iPlatform = (SApplication.appInstance as MainApplication).platform;
		}
		
		/**
		 * 绘制界面内容
		 */		
		private function _drawContent():void
		{
			this.width = 404;
			this.height = 249;
			
			//背景底图
			var imgBg:Scale9Image = ConstNPCDialog.genS9ImageWithTextureNameAndRect("common_dinew", 1 ,1 , 1, 1);
			imgBg.x = 0;
			imgBg.y = 18;
			imgBg.width = 384;
			imgBg.height = 231;
			this.addChild(imgBg);
			
//			//外边框装饰图
//			var imgOutFrameDecorate:Scale9Image = ConstNPCDialog.genS9ImageWithTextureNameAndRect("common_zhuangshinew", 15, 15,7,3);
//			imgOutFrameDecorate.x = 4;
//			imgOutFrameDecorate.y = 21;
//			imgOutFrameDecorate.width = 376;
//			imgOutFrameDecorate.height = 224;
//			this.addChild(imgOutFrameDecorate);
			//滚珠
			var bgBall:CJPanelFrame = new CJPanelFrame(376 , 224);
			bgBall.x = 4;
			bgBall.y = 21;
			this.addChild(bgBall);
			
			//操作层遮罩
			var imgOperateShade:Scale9Image = ConstNPCDialog.genS9ImageWithTextureNameAndRect("common_dinewzhezhao", 40, 40,1,1);
			imgOperateShade.width = 364;
			imgOperateShade.height = 211;
			imgOperateShade.x = 10;
			imgOperateShade.y = 28;
			this.addChild(imgOperateShade);
			
			//外边框图
			var imgOutFrame:Scale9Image = ConstNPCDialog.genS9ImageWithTextureNameAndRect("common_waikuangnew", 15 , 15 , 1, 1);
			imgOutFrame.x = 0;
			imgOutFrame.y = 18;
			imgOutFrame.width = 384;
			imgOutFrame.height = 231;
			this.addChild(imgOutFrame);
			
			//内边框装饰图
			var imgInFrameDecorate:Scale9Image = ConstNPCDialog.genS9ImageWithTextureNameAndRect("common_waikuangzhuangshinew", 65, 31,1,1);
			imgInFrameDecorate.x = 10;
			imgInFrameDecorate.y = 28;
			imgInFrameDecorate.width = 365;
			imgInFrameDecorate.height = 210;
			this.addChild(imgInFrameDecorate);
			
			_labCurLeft = new Label();
			_labCurLeft.x = 29;
			_labCurLeft.y = 37;
			_labCurLeft.width = 65;
			this.addChild(_labCurLeft);
			
			//标题
			var labTitle:CJPanelTitle = new CJPanelTitle(CJLang("RECHARGE_RECHARGE"));
			this.addChild(labTitle);
			labTitle.x = 45;
			
			//元宝图片
			var imgGold:SImage = new SImage(SApplication.assets.getTexture("common_yuanbao"));
			imgGold.x = 91;
			imgGold.y = 41;
			this.addChild(imgGold);
			
			_labGoldNum = new Label();
			_labGoldNum.x = 110;
			_labGoldNum.y = 37;
			this.addChild(_labGoldNum);
			
			// 分割线
			var imgLine:SImage = new SImage(SApplication.assets.getTexture("common_fengexian"));
//			imgLine.texture = SApplication.assets.getTexture("common_fengexian");
			imgLine.x = 10;
			imgLine.y = 58;
			imgLine.width = 355;
			imgLine.height = 3;
			this.addChild(imgLine);
			
			//关闭按钮
			_btnClose = new Button();
			_btnClose.defaultSkin = new SImage(SApplication.assets.getTexture("common_guanbianniu01new"));
			_btnClose.downSkin = new SImage(SApplication.assets.getTexture("common_guanbianniu02new"));
			_btnClose.width = 46;
			_btnClose.height = 45;
			_btnClose.x = 361;
			_btnClose.y = 0;
			this.addChild(_btnClose);
			
			_btnPileRecharge = new Button();
			_btnPileRecharge.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniu01new"));
			_btnPileRecharge.downSkin = new SImage(SApplication.assets.getTexture("common_anniu02new"));
			_btnPileRecharge.width = 75;
			_btnPileRecharge.height = 28;
			_btnPileRecharge.x = 90;
			_btnPileRecharge.y = 210;
			_btnPileRecharge.label = CJLang("RECHARGE_PILE_RECHARGE");
			_btnPileRecharge.defaultLabelProperties.textFormat = new TextFormat( "黑体", 12, 0xD3CA9E);
			this.addChild(_btnPileRecharge);
			
			_btnFirstRecharge = new Button();
			_btnFirstRecharge.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniu01new"));
			_btnFirstRecharge.downSkin = new SImage(SApplication.assets.getTexture("common_anniu02new"));
			_btnFirstRecharge.width = 75;
			_btnFirstRecharge.height = 28;
			_btnFirstRecharge.x = 185;
			_btnFirstRecharge.y = 210;
			_btnFirstRecharge.label = CJLang("RECHARGE_FIRST_RECHARGE");
			_btnFirstRecharge.defaultLabelProperties.textFormat = new TextFormat( "黑体", 12, 0xD3CA9E);
			_btnFirstRecharge.visible = _roleData.firstrechargecount == -1 ? false : true;
			this.addChild(_btnFirstRecharge);
			
			_setTextShow();
			_drawRechargeItem();
		}
		/**
		 * 绘制充值单元
		 */		
		private function _drawRechargeItem():void
		{
			var itemRow:int = 2;
			var itemcol:int = 3;
			var initX:int = 15;
			var initY:int = 69;
			var unitWidth:int = 121;
			var unitHeight:int = 72;
//			var arrayRechargePropertys:Array = CJDataOfRechargeProperty.o.getPropertys();
			for (var i:int = 0; i < itemRow; i++) 
			{
				for (var j:int = 0; j < itemcol; j++) 
				{
//					var rechargeProperty:Json_recharge_setting = arrayRechargePropertys[i * itemcol + j];
					var item:CJRechargeItem = new CJRechargeItem();
					item.x = initX + j * unitWidth;
					item.y = initY + i * unitHeight;
//					item.labGoldNum.text = rechargeProperty.goldnum;
//					item.labRmbNum.text = String(rechargeProperty.rmbnum / 100);
//					item.productName = ConstPlatformProduct.CURRENT_PLATFORM_PRODUCT[(i * itemcol) + j];
					this.addChild(item);
					this._arrayRecharge.push(item);
					item.addEventListener(starling.events.TouchEvent.TOUCH, _onClickItem);
				}
			}
			
		}
		/**
		 * 触发点击一个CJRankItem事件
		 * @param event
		 * 
		 */
		private function _onClickItem(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this);
			if (!touch || touch.phase != TouchPhase.ENDED)
			{
				return;
			}
			if (ConstGlobal.CHANNEL == "3" && !_rechargeClick)
			{
				// 当前渠道为AppStore时限制按钮是否可点击
				return;
			}
			_rechargeClick = false;
			
			var item:CJRechargeItem = event.currentTarget as CJRechargeItem;
			//设置选中效果
			if (_oldItem != null)
			{
				_oldItem.imgSelected.visible = false;
			}
			item.imgSelected.visible = true;
			_oldItem = item;
			
//			// TODO to delete
//			SocketCommand_receipt.verifyreceipt("test_verify_003", "3");
//			return;
			
			// 平台支付
			// TODO
			_platformPay(item.productName);
		}
		
		/**
		 * 平台支付
		 * @param productId	套餐id
		 * 
		 */
		private function _platformPay(productId:String):void
		{
			var dataReceipt:CJDataOfPlatformReceipt = CJDataManager.o.getData("CJDataOfPlatformReceipt");
			dataReceipt.pay(productId);		
		}
		
		/**
		 * 设置文本显示
		 */
		private function _setTextShow():void
		{
			var fontFormat:TextFormat = new TextFormat( "Arial", 12, 0xC3AA71);
			_labCurLeft.textRendererProperties.textFormat = fontFormat;
			_labCurLeft.text = CJLang("RECHARGE_CUR_LEFT");
			_labGoldNum.textRendererProperties.textFormat = fontFormat;
			_labGoldNum.text = String(_roleData.gold);
		}
		/**
		 * 添加监听
		 */
		private function _addListeners():void
		{
			_btnClose.addEventListener(Event.TRIGGERED, _closeTriggered);
			_btnPileRecharge.addEventListener(Event.TRIGGERED, _pileRechargeTriggered);
			_btnFirstRecharge.addEventListener(Event.TRIGGERED, _firstRechargeTriggered);
//			HelloAne.o.addEventListener(AppPurchaseEvent.PRODUCTS_RECEIVED, _onEventProductsReceived);
			// 监听数据获取成功
			_dataPlatformProducts.addEventListener(DataEvent.DataLoadedFromRemote, _onReceiveData);
			
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _onRpcReturn);
			
			SocketManager.o.addEventListener(ConstRecharge.EVENTTYPE_RECHARGE_APPSTORE_RESTORE_FAILED, _onAppStoreRestoreFailed);
		}
		
		/**
		 * 苹果充值失败或点击返回按钮
		 * @param e
		 * 
		 */		
		private function _onAppStoreRestoreFailed(e:Event):void
		{
			_rechargeClick = true;
		}
		
		/**
		 * RPC返回响应
		 * @param e
		 * 
		 */		
		private function _onRpcReturn(e:Event):void
		{
			var msg:SocketMessage = e.data as SocketMessage;
			if((msg.getCommand() == ConstNetCommand.CS_RECEIPT_VERIFYRECEIPT) 
				||(msg.getCommand() == ConstNetCommand.CS_RECEIPT_VERIFYRECEIPT20))
			{
				if ((msg.retcode == 0)||(msg.retcode == 6))
				{
					// 请求服务器更新货币信息
					//SocketCommand_role.get_role_info();
					
					var retData:Object = msg.retparams;
					var addGold:int = int(retData.addgold);
					if (addGold > 0)
					{
						var str:String = CJLang("MALL_BUY_GET");
						str = str.replace("{count}", retData.addgold);
						str = str.replace("{itemname}", CJLang("CURRENCY_NAME_GOLD"));
						this._showPiaozi(str);
					}
				}
				_rechargeClick = true;
				_clearSelect();
			}
			else if (msg.getCommand() == ConstNetCommand.CS_ROLE_GET_ROLE_INFO)
			{
				if (msg.retcode == 0)
				{
					this._labGoldNum.text = String(this._roleData.gold);
				}
			}
		}
		
		/**
		 * 飘字
		 * @param str 飘字内容
		 * 
		 */		
		private function _showPiaozi(str:String):void
		{
			var seccessLabel:Label = new Label();
			seccessLabel.text = str;
			seccessLabel.textRendererProperties.textFormat = new TextFormat( ConstTextFormat.FONT_FAMILY_HEITI, 13, 0xFFFFFF, null, null, null, null, null, TextFormatAlign.CENTER);
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
		
		private function _clearSelect():void
		{
			if (_arrayRecharge == null)
			{
				return;
			}
			for each (var item:CJRechargeItem in _arrayRecharge)
			{
				item.imgSelected.visible = false;
			}
			
		}
		
		/**
		 * 接收到平台充值数据
		 * 
		 */		
		private function _onReceiveData():void
		{
			var arrayData:Array = _dataPlatformProducts.getProductsData();
			_showProducts(arrayData);
			
			if (CJLoadingLayer.isShowHorse)
			{
				CJLoadingLayer.close();
			}
		}
		
		/**
		 * ANE物品获取处理
		 * @param e
		 * 
		 */		
//		private function _onEventProductsReceived(e:AppPurchaseEvent):void
//		{
//			var arrayData:Array = e.datas;
//			_showProducts(arrayData);
//		}
		
		/**
		 * 显示充值内容
		 * @param arrayData
		 * 
		 */		
		private function _showProducts(arrayData:Array):void
		{
			if (null == arrayData)
			{
				return;
			}
			var pdt:CJDataOfPlatformProduct;
			var item:CJRechargeItem;
			for (var i:int = 0; i < arrayData.length; i++)
			{
				if (i > 5)
				{
					return;
				}
				pdt = arrayData[i];
				item = _arrayRecharge[i];
				if (null == pdt)
				{
					item.visible = false;
					continue;
				}
				item.visible = true;
				item.gold = String(pdt.goldName);
				item.rmb = String(pdt.rmbName);
				item.productName = String(pdt.productId);
			}
		}
		
		/**
		 * 数据请求
		 * 
		 */		
		private function _dataRequest():void
		{
//			var strProduct:String = _getProductStrint();
//			HelloAne.o.getIosProduct(strProduct);
//			iPlatform.getproducts();
			if (_dataPlatformProducts.dataIsEmpty)
			{
				CJLoadingLayer.show();
				_dataPlatformProducts.loadFromRemote();
			}
			else
			{
				_onReceiveData();
			}
		}
		
//		/**
//		 * 获取套餐id内容字符串
//		 * 
//		 */		
//		private function _getProductStrint():String
//		{
//			var rtn:String = "";
//			for each(var product:String in ConstPlatformProduct.CURRENT_PLATFORM_PRODUCT)
//			{
//				rtn += product + ",";
//			}
//			rtn = rtn.substr(0, rtn.length - 1);
//			return rtn;
//		}
		
		private function _closeTriggered(e:Event):void
		{
			SSoundEffectUtil.playButtonNormalSound();
			SApplication.moduleManager.exitModule("CJRechargeModule");
		}
		private function _pileRechargeTriggered(e:Event):void
		{
			SSoundEffectUtil.playButtonNormalSound();
			SApplication.moduleManager.exitModule("CJRechargeModule");
			SApplication.moduleManager.enterModule("CJPileRechargeModule");
		}
		private function _firstRechargeTriggered(e:Event):void
		{
			SSoundEffectUtil.playButtonNormalSound();
			SApplication.moduleManager.exitModule("CJRechargeModule");
			SApplication.moduleManager.enterModule("CJFirstRechargeModule");
		}
		override public function dispose():void
		{
			super.dispose();
//			HelloAne.o.removeEventListener(AppPurchaseEvent.PRODUCTS_RECEIVED, _onEventProductsReceived);
			_dataPlatformProducts.removeEventListener(DataEvent.DataLoadedFromRemote, _onReceiveData);
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData, _onRpcReturn);
			SocketManager.o.removeEventListener(ConstRecharge.EVENTTYPE_RECHARGE_APPSTORE_RESTORE_FAILED, _onAppStoreRestoreFailed);
		}
	}
}