package SJ.Game.bag
{
	import SJ.Common.Constants.ConstBag;
	import SJ.Common.Constants.ConstCurrency;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.SocketServer.SocketCommand_item;
	import SJ.Game.SocketServer.SocketCommand_role;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfBag;
	import SJ.Game.data.CJDataOfRole;
	import SJ.Game.data.config.CJDataOfBagExpandProperty;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJMessageBox;
	import SJ.Game.layer.CJMsgBoxSilverNotEnough;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Dictionary;
	
	import starling.events.Event;
	import starling.textures.Texture;
	
//	import flash.filters.ConvolutionFilter;
//	import flash.filters.GlowFilter;
	/**
	 * 背包扩容层
	 * @author sangxu
	 * 
	 */	
	public class CJBagExpandLayer extends SLayer
	{
		
		public function CJBagExpandLayer()
		{
			super();
		}

		/** 角色数据 */
		private var _roleData:CJDataOfRole;
		/** 背包扩充配置数据 */
		private var _expandSetting:CJDataOfBagExpandProperty;
		
		/** 当前未解锁背包格索引数, 此次解锁格子数量 */
		private var _expandIndex:int = 0;
		/** 已经过解锁的背包格数量 */
		private var _expandCount:int = 0;
		/** 容器类型 */
		private var _containerType:int = ConstBag.CONTAINER_TYPE_BAG;
		
		/** 扩包使用货币类型 */
		private var _priceType:int = 0;
		/** 扩包使用货币总量 */
		private var _priceSum:int = 0;
		
//		private var _alertLayer:CJBagAlertLayer;
		
//		private var _isInit:Boolean = false;
		
		
		override protected function initialize():void
		{
			super.initialize();
			
			this._initData();
			
			this._initControls();
			
			this._addListener();
			
//			this._isInit = true;
		}
		
		/**
		 * 设置初始数据
		 * @param expandIndex 当前点击的未解锁格子索引
		 * @param expandCount 已经过解锁格子数量
		 * 
		 */		
		public function _setInitData(expandIndex:int, expandCount:int):void
		{
			// 当前点击未解锁背包格索引数
			this._expandIndex = expandIndex;
			// 已经过解锁的背包格数量
			this._expandCount = expandCount;
		}
		
		/**
		 * 设置容器类型
		 * @param containerType 容器类型
		 * 
		 */		
		public function setContainerType(containerType:int):void
		{
			this._containerType = containerType;
		}
		
		
		/**
		 * 初始化数据
		 * 
		 */
		private function _initData():void
		{
			// 角色数据
			this._roleData = CJDataOfRole(CJDataManager.o.getData("CJDataOfRole"));
			// 背包扩充配置数据
			this._expandSetting = CJDataOfBagExpandProperty.o;
		}
		/**
		 * 初始化控件
		 * 
		 */		
		private function _initControls():void
		{
			this.width = 242;
			this.height = 100;
			this.x = (stage.width - this.width) / 2;
			this.y = (stage.height - this.height) / 2;
			
			// 背包层背景
			if (null == this.imgBg)
			{
				var textureBg:Texture = SApplication.assets.getTexture("common_tishikuang");
				var bgScaleRange:Rectangle = new Rectangle(16, 15, 1, 1);
				var bgTexture:Scale9Textures = new Scale9Textures(textureBg, bgScaleRange);
				this.imgBg = new Scale9Image(bgTexture);
				this.imgBg.x = 0;
				this.imgBg.y = 0;
				this.imgBg.width = 242;
				this.imgBg.height = 100;
				this.addChildAt(this.imgBg, 0);
			}
			
			/** 字体 - 文字 */
			var fontCont:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 13, 0xE9B54B, null, null, null, null, null, TextFormatAlign.CENTER);
			/** 字体 - 按钮 */
			var fontBtn:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 11, 0xFFFEFD);
			
			// 文字
			this.labCont.width = this.imgBg.width - 20;
			this.labCont.x = (this.imgBg.width - this.labCont.width) / 2;
			this.labCont.textRendererProperties.textFormat = fontCont;
			this.labCont.textRendererProperties.wordWrap = true;
			this.labCont.text = "";
			
			// 按钮 - 确认
			this.btnSure.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniu01new"));
			this.btnSure.downSkin = new SImage(SApplication.assets.getTexture("common_anniu02new"));
			this.btnSure.disabledSkin = new SImage(SApplication.assets.getTexture("common_anniu03new"));
			this.btnSure.defaultLabelProperties.textFormat = fontBtn;
			this.btnSure.label = CJLang("BAG_EXPAND_BTN_NAME_SURE");
			
			// 按钮 - 取消
			this.btnCancel.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniu01new"));
			this.btnCancel.downSkin = new SImage(SApplication.assets.getTexture("common_anniu02new"));
			this.btnCancel.disabledSkin = new SImage(SApplication.assets.getTexture("common_anniu03new"));
			this.btnCancel.defaultLabelProperties.textFormat = fontBtn;
			this.btnCancel.label = CJLang("BAG_EXPAND_BTN_NAME_CANCEL");
			
//			var tooltipXml:XML = AssetManagerUtil.o.getObject(ConstResource.sResSxmlBagTooltip) as XML;
//			this._alertLayer = new CJBagAlertLayer();
			
//			this._drawPageInfo();
		}
		
		/**
		 * 根据数据绘制页面
		 * @param expandIndex 当前点击的未解锁格子索引
		 * @param expandCount 已经过解锁格子数量
		 * 
		 */
		public function drawInfoWithData(expandIndex:int, expandCount:int):void
		{
			this._setInitData(expandIndex, expandCount);
//			if (false == _isInit)
//			{
//				this.initialize();
//			}
//			else
//			{
//				this._drawPageInfo();
//			}
			this._drawPageInfo();
		}
		
		/**
		 * 绘制弹出框信息
		 * 
		 */		
		private function _drawPageInfo():void
		{
			// 显示文字及按钮可用
			// 配置数据起始索引
			var startIdx:int = this._expandCount + 1;
			// 配置数据结束索引
			var endIdx:int = this._expandCount + this._expandIndex;
			// 开启格子数量
			var openCount:int = this._expandIndex;
			// 需要货币数量总和
			this._priceSum = 0;
			// 需要货币类型
//			var priceType:int = 0;
			// 获取数据临时变量
			var countTemp:int = 0;
			var allExpandData:Dictionary = this._expandSetting.getAllTemplates();
			
			for each(var data:Object in allExpandData)
			{
				//				var data:CJDataOfBagExpand = this._expandSetting.getTemplate(parseInt(key));
				if (data.containerType != this._containerType)
				{
					continue;
				}
				if (data.number < startIdx || data.number > endIdx)
				{
					continue;
				}
				this._priceSum += data.costPrice;
				countTemp += 1;
				if (countTemp >= openCount)
				{
					this._priceType = data.costType;
					break;
				}
			}
			var contant:String = CJLang("BAG_EXPAND_CONTENT");
			contant = contant.replace("{price}", String(this._priceSum));
			contant = contant.replace("{count}", openCount);
			
			if (ConstCurrency.CURRENCY_TYPE_SILVER == this._priceType)
			{
				contant = contant.replace("{currency}", CJLang("CURRENCY_NAME_SILVER"));
//				if (prictSum > this._roleData.silver)
//				{
//					this.btnSure.isEnabled = false;
//				}
//				else
//				{
//					this.btnSure.isEnabled = true;
//				}
			}
			else if(ConstCurrency.CURRENCY_TYPE_GOLD == this._priceType)
			{
				contant = contant.replace("{currency}", CJLang("CURRENCY_NAME_GOLD"));
//				if (prictSum > this._roleData.gold)
//				{
//					this.btnSure.isEnabled = false;
//				}
//				else
//				{
//					this.btnSure.isEnabled = true;
//				}
			}
			this.labCont.text = contant;
		}
		
		
		
		/**
		 * 设置事件监听
		 * 
		 */		
		private function _addListener() : void
		{
			// 确认按钮
			this.btnSure.addEventListener(Event.TRIGGERED, this._onBtnSureClick);
			// 取消按钮
			this.btnCancel.addEventListener(Event.TRIGGERED, this._onBtnCancelClick);
			// 监听RPC
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _onRpcReturn);
		}
		
		/**
		 * RPC返回响应
		 * @param e
		 * 
		 */		
		private function _onRpcReturn(e:Event):void
		{
			var msg:SocketMessage = e.data as SocketMessage;
			if(msg.getCommand() == ConstNetCommand.CS_OPEN_BAG_GRID)
			{
				this.btnSure.isEnabled = true;
				if (msg.retcode == 0)
				{
					if (msg.retparams.result == true)
					{
						var bagData:CJDataOfBag = CJDataManager.o.getData("CJDataOfBag");
						var bagCount:int = int(msg.retparams.count);
						bagData.bagCount = bagCount;
						this._expandIndex = 0;
						// 派发扩包成功消息
						dispatchEvent(new Event(ConstBag.EVENT_TYPE_BAG_EXPAND_COMPLETE));
						SocketCommand_role.get_role_info();
						// 关闭当前框
						this._closeLayer();
					}
				}
			}
		}
		
		
		
		/**
		 * 按钮点击处理 - 取消按钮
		 * @param event
		 * 
		 */
		private function _onBtnCancelClick(event:Event):void
		{
//			dispatchEvent(new Event(ConstBag.EVENT_TYPE_BAG_EXPAND_COMPLETE));
			this._closeLayer();
		}
		
		/**
		 * 按钮点击处理 - 确认按钮
		 * @param event
		 * 
		 */
		private function _onBtnSureClick(event:Event):void
		{
			var contant:String = "";
			if (ConstCurrency.CURRENCY_TYPE_SILVER == this._priceType)
			{
				if (this._priceSum > this._roleData.silver)
				{
					contant = this._getAlertContant(CJLang("CURRENCY_NAME_SILVER"), 
													String(this._priceSum), 
													CJLang("BAG_ADDMONEY_SILVER"));
					
//					this._popAlertLayer(contant);
					// 银两不足提示框 modify by sangxu 2013-09-04
					CJMsgBoxSilverNotEnough(contant, 
						"", 
						function():void{
							_closeLayer();
							SApplication.moduleManager.exitModule("CJBagModule");
						});
					return;
				}
			}
			else if(ConstCurrency.CURRENCY_TYPE_GOLD == this._priceType)
			{
				if (this._priceSum > this._roleData.gold)
				{
					contant = this._getAlertContant(CJLang("CURRENCY_NAME_GOLD"), 
													String(this._priceSum), 
													CJLang("BAG_ADDMONEY_GOLD"));
					this._popAlertLayer(contant);
					return;
				}
			}
			this.btnSure.isEnabled = false;
			
			// 添加网络锁
//			SocketLockManager.KeyLock(ConstNetCommand.CS_OPEN_BAG_GRID);
			
			SocketCommand_item.openBagGrid(ConstBag.CONTAINER_TYPE_BAG, this._expandIndex);
		}
		
		/**
		 * 
		 * @param currency	替换的货币名称
		 * @param count		替换的货币数量
		 * @param type		替换的获取货币方式
		 * 
		 */		
		private function _getAlertContant(currency:String, count:String, type:String):String
		{
			var contant:String = CJLang("BAG_MONEY_NOT_ENOUGH");
			contant = contant.split("{currency}").join(currency);
			contant = contant.replace("{count}", count);
			contant = contant.replace("{type}", type);
			return contant;
		}
		
		/**
		 * 弹出提示信息
		 * @return 
		 * 
		 */
		private function _popAlertLayer(contant:String):void
		{
//			this._alertLayer.setContant(contant);
//			CJLayerManager.o.addToModal(this._alertLayer);
			CJMessageBox(contant);
		}
		
		/**
		 * 关闭层
		 * 包含移除全部监听
		 */		
		private function _closeLayer():void
		{
			this._removeAllEventListener();
			this.removeFromParent(true);
		}
		
		/**
		 * 移除所有事件监听
		 * 
		 */		
		private function _removeAllEventListener():void
		{
			if (this.btnSure != null)
			{
				this.btnSure.addEventListener(Event.TRIGGERED, this._onBtnSureClick);
			}
			if (this.btnCancel != null)
			{
				this.btnCancel.addEventListener(Event.TRIGGERED, this._onBtnCancelClick);
			}
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _onRpcReturn);
		}
		
		/** Controls */
		/** 背景图片 */
		private var _imgBg:Scale9Image;
		/** 显示语言内容 */
		private var _labCont:Label;
		/** 确认按钮 */
		private var _btnSure:Button;
		/** 取消按钮 */
		private var _btnCancel:Button;
		
		/** getter */
		public function get imgBg():Scale9Image
		{
			return this._imgBg;
		}
		public function get labCont():Label
		{
			return this._labCont;
		}
		public function get btnSure():Button
		{
			return this._btnSure;
		}
		public function get btnCancel():Button
		{
			return this._btnCancel;
		}
		
		/** setter */
		public function set imgBg(value:Scale9Image):void
		{
			this._imgBg = value;
		}
		public function set labCont(value:Label):void
		{
			this._labCont = value;
		}
		public function set btnSure(value:Button):void
		{
			this._btnSure = value;
		}
		public function set btnCancel(value:Button):void
		{
			this._btnCancel = value;
		}
		
		
	}
}