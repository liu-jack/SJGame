package SJ.Game.mall
{
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.SocketServer.SocketCommand_item;
	import SJ.Game.SocketServer.SocketCommand_role;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.controls.CJButtonUtil;
	import SJ.Game.controls.CJFlyWordsUtil;
	import SJ.Game.controls.CJItemUtil;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfBag;
	import SJ.Game.data.CJDataOfMall;
	import SJ.Game.data.CJDataOfMallItem;
	import SJ.Game.data.CJDataOfRole;
	import SJ.Game.data.config.CJDataOfItemProperty;
	import SJ.Game.data.config.CJDataOfVipFuncSetting;
	import SJ.Game.data.json.Json_item_setting;
	import SJ.Game.data.json.Json_vip_function_setting;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJMessageBox;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.Events.DataEvent;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	import engine_starling.utils.STween;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.display.Scale3Image;
	import feathers.textures.Scale3Textures;
	
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.events.Event;
	import starling.textures.Texture;

	/**
	 * 商城操作layer
	 * @author sangxu
	 * @date:2013-06-28
	 */	
	public class CJMallOperateLayer extends SLayer
	{
		public function CJMallOperateLayer()
		{
			super();
		}
		
		/** datas */
		/** 数据 - 商城数据 */
		private var _dataMall:CJDataOfMall;
		/** 数据 - 角色数据 */
		private var _dataRole:CJDataOfRole;
		/** 数据 - 背包 */
		private var _dataBag:CJDataOfBag;
		
		/** 商城显示 - 初始坐标*/
		private const MALL_DISPLAY_INIT_X:uint = 14;
		private const MALL_DISPLAY_INIT_Y:uint = 15;
		/** 商城显示 - 行列间隔 */
		private const MALL_DISPLAY_SPACE_X:uint = 131;
		private const MALL_DISPLAY_SPACE_Y:uint = 69;
		/** 商城显示 - 物品框宽高 */
		private const MALL_DISPLAY_ITEM_WIDTH:uint = 126;
		private const MALL_DISPLAY_ITEM_HEIGHT:uint = 62;
		/** 商城显示 - 行数 */
		private const MALL_DISPLAY_ROW_COUNT:uint = 3;
		/** 商城显示 - 列数 */
		private const MALL_DISPLAY_COL_COUNT:uint = 3;
		
		/** 单页显示商城道具数量 */
		private var _onePageNum:uint = MALL_DISPLAY_ROW_COUNT * MALL_DISPLAY_COL_COUNT;
		/** 当前页数 */
		private var _currentPage:uint = 1;
		/** 总页数 */
		private var _pageNum:uint;
		/** 商城物品数组 */
		private var _arrayItems:Array = new Array();
		
		/** 道具tooltip layer */		
//		private var _tooltipLayer:CJItemTooltip;
		
		/** 道具模板管理器 */
		private var _itemTemplateProperty:CJDataOfItemProperty;
		
		/** VIP宝石折扣 */
		private var _vipJewelDiscount:int;
		/** 页面类型 */
		private var _pageType:String;
		
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
			
			this._dataMall.addEventListener(DataEvent.DataLoadedFromRemote , this._onDataLoadedMall);
		}
		
		/**
		 * 初始化绘制
		 * 
		 */		
		private function _initDraw():void
		{
			
		}
		
		/**
		 * 初始化控件
		 * 
		 */		
		private function _initControls():void
		{
			// 字体 - 页码
			var fontFormatPage:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 10, 0xB7B5A4, null, null, null, null, null, TextFormatAlign.CENTER);

			
			// 页码显示框
			var texture:Texture = SApplication.assets.getTexture("common_tiptankuang");
			var scale3texture:Scale3Textures = new Scale3Textures(texture, texture.width/2-1,1);
			this.btnYemaditiao = new Button();
			this.btnYemaditiao.defaultSkin= new Scale3Image(scale3texture);
			this.btnYemaditiao.defaultLabelProperties.textFormat = fontFormatPage;
			this.btnYemaditiao.x = 169;
			this.btnYemaditiao.y = 228;
			this.btnYemaditiao.width = 84;
			this.btnYemaditiao.height = 24;
			this.addChild(this.btnYemaditiao);
			
			// 按钮 - 左
			this.btnPageLeft = new Button();
			this.btnPageLeft.defaultSkin = new SImage(SApplication.assets.getTexture("common_fanyeright01"));
			this.btnPageLeft.disabledSkin = new SImage(SApplication.assets.getTexture("common_fanyeright02"));
			this.btnPageLeft.x = 130 + 50;
			this.btnPageLeft.y = 226;
			this.btnPageLeft.width = 25;
			this.btnPageLeft.height = 28;
			this.btnPageLeft.scaleX = -1;
//			this.btnPageLeft.x += this.btnPageLeft.width;
			this.btnPageLeft.x -= 25;
			this.addChild(this.btnPageLeft);
			this.btnPageLeft.addEventListener(Event.TRIGGERED, _onClickBtnPageLeft);
			
			// 按钮 - 右
			this.btnPageRight = new Button();
			this.btnPageRight.defaultSkin = new SImage(SApplication.assets.getTexture("common_fanyeright01"));
			this.btnPageRight.disabledSkin = new SImage(SApplication.assets.getTexture("common_fanyeright02"));
			this.btnPageRight.x = 266;
			this.btnPageRight.y = 226;
			this.btnPageRight.width = 25;
			this.btnPageRight.height = 28;
			this.addChild(this.btnPageRight);
			this.btnPageRight.addEventListener(Event.TRIGGERED, _onClickBtnPageRight);
			
			/** 物品框*/
			var goodsItem:CJMallGoodsLayer;
			
//			this._arrayItems = new Array();
			
			//循环行数
			for(var row:uint = 0; row < MALL_DISPLAY_ROW_COUNT; row++)
			{
				//循环列数
				for (var col:uint = 0; col < this.MALL_DISPLAY_COL_COUNT; col++)
				{
					goodsItem = new CJMallGoodsLayer();
					goodsItem.x += MALL_DISPLAY_INIT_X + MALL_DISPLAY_SPACE_X * col;
					goodsItem.y += MALL_DISPLAY_INIT_Y + MALL_DISPLAY_SPACE_Y * row;
					goodsItem.width = MALL_DISPLAY_ITEM_WIDTH;
					goodsItem.height = MALL_DISPLAY_ITEM_HEIGHT;
//					goodsItem.index = j * _bagColNum + k;
					goodsItem.visible = false;
					this._arrayItems.push(goodsItem);
					this.addChild(goodsItem);
				}
			}
			
			// 分割线
			var textureTemp:Texture = SApplication.assets.getTexture("common_fengexian");
			var stTemp:Scale3Textures = new Scale3Textures(textureTemp, textureTemp.width/2-1,1);
			var imgFenge:Scale3Image = new Scale3Image(stTemp);
			imgFenge.x = 13;
			imgFenge.y = 219;
			imgFenge.height = 2;
			imgFenge.width = 392;
			this.addChild(imgFenge);
			
			this._onRefreshPageBtn();
		}
		
		/**
		 * 按钮点击 - 左
		 * @param event
		 * 
		 */		
		private function _onClickBtnPageLeft(event:Event):void
		{
			
			if(this._currentPage <= 1) 
			{
				return;
			}
			
			// 添加网络锁
//			SocketLockManager.Lock(ConstNetLockID.MallModule);
			
			this._currentPage --;
			this._onRefreshPageBtn();
			this._redrawItems();
			this._setPageIndexLabel();
			
			// 解除网络锁
//			SocketLockManager.UnLock(ConstNetLockID.MallModule);
		}
		
		/**
		 * 按钮点击 - 右
		 * @param event
		 * 
		 */		
		private function _onClickBtnPageRight(event:Event):void
		{
			if(this._currentPage >= this._pageNum)
			{
				return;
			}
			
			// 添加网络锁
//			SocketLockManager.Lock(ConstNetLockID.MallModule);
			
			this._currentPage ++;
			this._onRefreshPageBtn();
			this._redrawItems();
			this._setPageIndexLabel();
			
			// 解除网络锁
//			SocketLockManager.UnLock(ConstNetLockID.MallModule);
		}
		
		private function _onRefreshPageBtn():void
		{
			if(this._currentPage <= 1) 
			{
				this.btnPageLeft.isEnabled = false;
			}
			else
			{
				this.btnPageLeft.isEnabled = true;
			}
			
			if(this._currentPage >= this._pageNum)
			{
				this.btnPageRight.isEnabled = false;
			}
			else
			{
				this.btnPageRight.isEnabled = true;
			}
		}
		
		/**
		 * 重新绘制当页商城道具
		 * 
		 */		
		private function _redrawItems():void
		{
			// 本页数据起始位置
			var indexBegin:uint = _onePageNum * (_currentPage - 1);
			var mallItem:CJMallGoodsLayer;
			var dataItem:CJDataOfMallItem;
			
			var dataItems:Array = this._dataMall.getItemsByType(_pageType);
			for (var i:uint=0; i < this._arrayItems.length; i++)
			{
				mallItem = this._arrayItems[i];
				if ((i + indexBegin) < dataItems.length)
				{
					// 有数据
					dataItem = dataItems[i + indexBegin];
					mallItem.redrawWithData(dataItem, _vipJewelDiscount);
				}
				else
				{
					mallItem.redrawWithData(null);
				}
			}
		}
		
		public function redrawItemSelect(mallItemId:int):void
		{
			var mallItem:CJMallGoodsLayer;
			for (var i:uint=0; i < this._arrayItems.length; i++)
			{
				mallItem = this._arrayItems[i];
				mallItem.select = false;
				if (mallItem.dataMallItem != null)
				{
					if (mallItemId == mallItem.dataMallItem.id)
					{
						mallItem.select = true;
					}
				}
			}
		}
		
		/**
		 * 清空选中状态
		 * 
		 */		
		private function _clearSelect():void
		{
			for each(var mallItem:CJMallGoodsLayer in this._arrayItems)
			{
				mallItem.select = false;
			}
//			_tooltipLayer = null;
		}
		
		/**
		 * 设置页码索引
		 * @param scrollPage 
		 * @param imgYemaditiao
		 * 
		 */		
		private function _setPageIndexLabel():void
		{
			this.btnYemaditiao.label = this._currentPage + " / " + this._pageNum;
		}
		
		/**
		 * 初始化数据
		 * 
		 */		
		private function _initData():void
		{
			// 商城数据
			this._dataMall = CJDataManager.o.getData("CJDataOfMall") as CJDataOfMall;
			
			// 角色数据
			this._dataRole = CJDataManager.o.getData("CJDataOfRole") as CJDataOfRole;
			
			// 背包数据
			this._dataBag = CJDataManager.o.getData("CJDataOfBag") as CJDataOfBag;
			
			// 道具模板管理器
			this._itemTemplateProperty = CJDataOfItemProperty.o;
			
			var vipLv:int = CJDataManager.o.DataOfRole.vipLevel;
			var vipCfg:Json_vip_function_setting = 	CJDataOfVipFuncSetting.o.getData(String(vipLv));
			_vipJewelDiscount = int(vipCfg.jewel_discount);
		}
		
		/**
		 * 接收到商城数据
		 * 
		 */		
		private function _onDataLoadedMall():void
		{
			_onChangeType();
		}
		
		private function _onChangeType():void
		{
			if (this._dataMall.dataIsEmpty)
			{
				return;
			}
				
			var arrayItems:Array = this._dataMall.getItemsByType(_pageType);
			//物品框总页数
			this._pageNum = arrayItems.length % this._onePageNum > 0 ? 
				(arrayItems.length / this._onePageNum + 1) :
				arrayItems.length / this._onePageNum;
			this._currentPage = 1;
			
			this._redrawItems();
			this._setPageIndexLabel();
			this._onRefreshPageBtn();
		}
		
		
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
			if(msg.getCommand() == ConstNetCommand.CS_MALL_BUYITEM)
			{
				// 购买商城道具
				this._rpcReturnHandleBuyItem(msg);
				
				// 解除网络锁
//				SocketLockManager.UnLock(ConstNetLockID.MallModule);
			}
		}
		
		/**
		 * RPC返回结果处理 - 购买商城道具
		 * @param msg
		 * @return 
		 * 
		 */		
		private function _rpcReturnHandleBuyItem(msg:SocketMessage):void
		{
			if (msg.retcode == 0)
			{
				// 成功
				var retData:Object = msg.retparams;
				// 商城道具id
				var mallItemId:String = String(retData[1]);
				var count:String = String(retData[2]);
				
				var mallItem:CJDataOfMallItem = _dataMall.getMallItemById(mallItemId);
				// 道具模板id
				var itemTmplId:String = String(mallItem.itemid);
				var message:String = CJLang("MALL_BUY_GET");
				message = message.replace("{count}", count);
				var itemTmpl:Json_item_setting = _itemTemplateProperty.getTemplate(int(itemTmplId));
				message = message.replace("{itemname}", CJLang(itemTmpl.itemname));
				CJFlyWordsUtil(message);
				
				// 更新背包数据
				SocketCommand_item.getBag();
				// 更新角色数据（货币）
				SocketCommand_role.get_role_info();
				return;
			}
			else if (msg.retcode == 1)
			{
				// 未到时限
				CJMessageBox(CJLang("MALL_ALERT_NOTREACHTIME"));
				return;
			}
			else if (msg.retcode == 2)
			{
				// 时限已过
				CJMessageBox(CJLang("MALL_ALERT_PASSTIME"));
				return;
			}
			else if (msg.retcode == 3)
			{
				// 剩余数量不足
				CJMessageBox(CJLang("MALL_ALERT_PASSTIME"));
				return;
			}
			else if (msg.retcode == 4)
			{
				// 背包不足
				CJMessageBox(CJLang("MALL_ALERT_BAGNOTGRID"));
				return;
			}
			else if (msg.retcode == 5)
			{
				// 声望不足
				this._showCreditNotEnough();
				return;
			}
			else if (msg.retcode == 6)
			{
				// 元宝不足
				this._showGoldNotEnough();
				return;
			}
			else if (msg.retcode == 7)
			{
				// 不存在该道具
				return;
			}
		}
		
		/**
		 * 显示道具tooltip
		 * @param itemTemplateId	道具模板id
		 * 
		 */		
		public function showTooltip(itemTemplateId:int):void
		{
//			if (this._tooltipLayer == null)
//			{
//				this._tooltipLayer = new CJItemTooltip();
//			}
//			this._tooltipLayer = new CJItemTooltip();
//			this._tooltipLayer.setItemTemplateIdAndRefresh(itemTemplateId);
//			this._tooltipLayer.setCloseFunction(_clearSelect);
//			CJLayerManager.o.addModuleLayer(_tooltipLayer);
			
			CJItemUtil.showItemTooltipsWithTemplateId(itemTemplateId).setCloseFunction(_clearSelect);
//			this._tooltipLayer.setCloseFunction(_clearSelect);
		}
		
		/**
		 * 购买商城道具
		 * @param mallItem	商城道具数据CJDataOfMallItem
		 * @param count	购买数量
		 * 
		 */		
		public function buyMallItem(mallItem:CJDataOfMallItem):void
		{
			var layerBuy:CJMallBuyLayer = new CJMallBuyLayer(mallItem);
			layerBuy.setCloseFunction(_clearSelect);
			CJLayerManager.o.addModuleLayer(layerBuy);
		}
		
		/**
		 * 提示元宝不足
		 * 
		 */		
		private function _showGoldNotEnough():void
		{
			// 元宝不足
			// 字体 - 按钮
//			var tfBtn:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 13, 0xFFEFBD, null, null, null, null, null, TextFormatAlign.CENTER);
			
			this.alertLayer = new CJMallNotEnoughPriceLayer();
			this.alertLayer.text = CJLang("MALL_ALERT_YUANBAO");
			CJLayerManager.o.addModuleLayer(this.alertLayer);
			
			// 充值
			this.btnSure = CJButtonUtil.createCommonButton(CJLang("MALL_ALERT_BTN_RECHARGE"));
			this.btnSure.addEventListener(Event.TRIGGERED, _onBtnClickAlertSure);
			this.btnSure.x = 20;
			this.btnSure.y = 80;
			this.btnSure.labelOffsetY = -2;
//			btnSure.defaultLabelProperties.textForma = tfBtn;
			alertLayer.addButton(this.btnSure);
			
			// 取消
			this.btnCancel = CJButtonUtil.createCommonButton(CJLang("COMMON_CANCEL"));
			this.btnCancel.addEventListener(Event.TRIGGERED, _onBtnClickAlertCancel);
			this.btnCancel.x = 120;
			this.btnCancel.y = this.btnSure.y;
			this.btnCancel.labelOffsetY = -2;
//			btnCancel.defaultLabelProperties.textForma = tfBtn;
			alertLayer.addButton(this.btnCancel);
			
		}
		
		/**
		 * 按钮点击事件响应 - 货币不足提示框充值按钮
		 * 
		 */		
		private function _onBtnClickAlertSure(event:Event):void
		{
			this.alertLayer.removeFromParent();
			// 退出商城模块
			SApplication.moduleManager.exitModule("CJMallModule");
			// 进入充值模块
			SApplication.moduleManager.enterModule("CJRechargeModule");
		}
		
		/**
		 * 按钮点击事件响应 - 货币不足提示框取消按钮
		 * 
		 */		
		private function _onBtnClickAlertCancel(event:Event):void
		{
			alertLayer.removeFromParent();
		}
		
		/**
		 * 提示声望不足 
		 * 
		 */		
		private function _showCreditNotEnough():void
		{
			// 声望不足
			this.alertLayer = new CJMallNotEnoughPriceLayer();
			this.alertLayer.text = CJLang("MALL_ALERT_SHENGWANG");
			
			CJLayerManager.o.addModuleLayer(this.alertLayer);
			
			this.btnSure = CJButtonUtil.createCommonButton(CJLang("COMMON_TRUE"));
			this.btnSure.addEventListener(Event.TRIGGERED, _onBtnClickAlertCancel);
			this.btnSure.x = 76;
			this.btnSure.y = 80;
			this.btnSure.labelOffsetY = -2;
			this.alertLayer.addButton(this.btnSure);
			
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
		
		/**
		 * 移除所有事件监听
		 * 
		 */		
		public function removeAllEventListener():void
		{
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData, _onRpcReturn);
			this._dataMall.removeEventListener(DataEvent.DataLoadedFromRemote , this._onDataLoadedMall);
			this.btnPageLeft.removeEventListener(Event.TRIGGERED, _onClickBtnPageLeft);
			this.btnPageRight.removeEventListener(Event.TRIGGERED, _onClickBtnPageRight);
			if (this.btnSure != null)
			{
				this.btnSure.removeEventListener(Event.TRIGGERED, _onBtnClickAlertSure);
				this.btnSure.removeEventListener(Event.TRIGGERED, _onBtnClickAlertCancel);
			}
			if (this.btnCancel != null)
			{
				this.btnCancel.removeEventListener(Event.TRIGGERED, _onBtnClickAlertCancel);
			}
			for each(var goodsItem:CJMallGoodsLayer in this._arrayItems)
			{
				if (goodsItem != null)
				{
					goodsItem.removeAllEventListener();
				}
			}
		}
		
		override public function dispose():void
		{
//			_tooltipLayer = null;
			removeAllEventListener();
			
			super.dispose();
		}
		
		public function setPageType(pageType:String):void
		{
			if (_pageType == pageType)
			{
				return;
			}
			_pageType = pageType;
			
			_onChangeType();
		}
		
		/** controls */
		/** 页码 */
		private var _btnYemaditiao:Button;
		/** 按钮 - 左 */
		private var _btnPageLeft:Button;
		/** 按钮 - 右 */
		private var _btnPageRight:Button;
		/** 提示层 - 商城货币不足 */
		private var _alertLayer:CJMallNotEnoughPriceLayer;
		/** 提示层按钮 - 充值 */
		private var _btnSure:Button;
		/** 提示层按钮 - 取消 */
		private var _btnCancel:Button
		
		/** setter */
		public function set btnPageLeft(value:Button):void
		{
			this._btnPageLeft = value;
		}
		public function set btnPageRight(value:Button):void
		{
			this._btnPageRight = value;
		}
		public function set btnYemaditiao(value:Button):void
		{
			this._btnYemaditiao = value;
		}
		public function set alertLayer(value:CJMallNotEnoughPriceLayer):void
		{
			this._alertLayer = value;
		}
		public function set btnSure(value:Button):void
		{
			this._btnSure = value;
		}
		public function set btnCancel(value:Button):void
		{
			this._btnCancel = value;
		}
		
		/** getter */
		public function get btnPageLeft():Button
		{
			return this._btnPageLeft;
		}
		public function get btnPageRight():Button
		{
			return this._btnPageRight;
		}
		public function get btnYemaditiao():Button
		{
			return this._btnYemaditiao;
		}
		public function get alertLayer():CJMallNotEnoughPriceLayer
		{
			return this._alertLayer;
		}
		public function get btnSure():Button
		{
			return this._btnSure;
		}
		public function get btnCancel():Button
		{
			return this._btnCancel;
		}
	}
}