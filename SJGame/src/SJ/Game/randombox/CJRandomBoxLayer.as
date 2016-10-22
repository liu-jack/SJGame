package SJ.Game.randombox
{
	
	import flash.filters.ConvolutionFilter;
	import flash.filters.GlowFilter;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import SJ.Common.Constants.ConstBag;
	import SJ.Common.Constants.ConstItem;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Common.global.textRender;
	import SJ.Game.SocketServer.SocketCommand_item;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.controls.CJItemUtil;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.data.CJDataOfBag;
	import SJ.Game.data.CJDataOfItem;
	import SJ.Game.data.config.CJDataOfItemProperty;
	import SJ.Game.data.json.Json_item_setting;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJLayerManager;
	import SJ.Game.layer.CJMessageBox;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.Events.DataEvent;
	import engine_starling.display.SAnimate;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	import engine_starling.feathersextends.TextFieldTextRendererEx;
	import engine_starling.utils.AssetManagerUtil;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.core.ITextRenderer;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 * 背包层
	 * @author sangxu
	 * 
	 */	
	public class CJRandomBoxLayer extends SLayer
	{
		/** 数据 - 背包 */
		private var _dataBag:CJDataOfBag;
		/** 道具模板 */
		private var _itemTmplBox:Json_item_setting;
		private var _itemTmplKey:Json_item_setting;
		/** 道具模板id */
		private var _itemTmplIdBox:int;
		private var _itemTmplIdKey:int;
		/** 道具数量 */
		private var _itemBoxCount:int;
		private var _itemKeyCount:int;
		
		private var _itemId:String;
		private var _itemIdBox:CJDataOfItem;
		/** 随机道具数量 */
		private var _getRandomItemCount:int = 3;
		
		private var _boxItemArray:Array = new Array();
		
		/** 界面上闪烁的小星星 */
		private var _animStarOne:SAnimate;
		private var _animStarTwo:SAnimate;
		private var _animStarThree:SAnimate;
		
		public function CJRandomBoxLayer()
		{
			super();
		}
		
		public function setItemId(itemId:String):void
		{
			this._itemId = itemId;
		}
		
		
		override protected function initialize():void
		{
			super.initialize();
			// 初始化数据
			this._initData();
			
			// 初始化控件
			this._initControls();
			// 增加监听
			this._addListeners();
			
			// 请求服务器数据
			this._remoteDataRequest();
			
		}
		/**
		 * 初始化数据
		 * 
		 */
		private function _initData():void
		{
			this._dataBag = CJDataManager.o.DataOfBag;
			var dataItem:CJDataOfItem = _dataBag.getItemByItemId(this._itemId);
			var dataTmpl:Json_item_setting = CJDataOfItemProperty.o.getData(String(dataItem.templateid));
			if (dataTmpl.subtype == ConstItem.SCONST_ITEM_SUBTYPE_USE_BOX)
			{
				// 宝箱
				this._itemTmplBox = dataTmpl;
				this._itemTmplKey = CJDataOfItemProperty.o.getData(dataTmpl.useparam0);
				
				this._itemTmplIdBox = int(dataTmpl.id);
				this._itemTmplIdKey = int(dataTmpl.useparam0);
			}
			else if (dataTmpl.subtype == ConstItem.SCONST_ITEM_SUBTYPE_USE_BOXKEY)
			{
				// 钥匙
				this._itemTmplKey = dataTmpl;
				this._itemTmplBox = CJDataOfItemProperty.o.getData(dataTmpl.useparam0);
				
				this._itemTmplIdKey = int(dataTmpl.id);
				this._itemTmplIdBox = int(dataTmpl.useparam0);
			}
			_setBoxAndKeyCount();
		}
		
		/**
		 * 设置宝箱和钥匙数量
		 * 
		 */		
		private function _setBoxAndKeyCount():void
		{
			_itemBoxCount = _dataBag.getItemCountByTmplId(this._itemTmplIdBox);
			_itemKeyCount = _dataBag.getItemCountByTmplId(this._itemTmplIdKey);
		}
		
		/**
		 * 重新绘制宝箱和钥匙数量
		 * 
		 */		
		private function _redrawBoxAndKeyCount():void
		{
			if (_itemBox != null && _itemKey != null)
			{
				this._itemBox.setCount(_itemBoxCount);
				this._itemKey.setCount(_itemKeyCount);
			}
		}
		/**
		 * 初始化控件
		 * 
		 */		
		private function _initControls():void
		{
			this.width = SApplicationConfig.o.stageWidth;
			this.height = SApplicationConfig.o.stageHeight;
			
			this.boxLayer.width = 349;
			this.boxLayer.height = 289;
			
			this.boxLayer.x = (this.width - this.boxLayer.width) / 2;
			this.boxLayer.y = (this.height - this.boxLayer.height) / 2;
			
			// 宝箱描述
			var ffDesc:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 14, 0xFFEC6A, null, null, null, null, null, TextFormatAlign.CENTER);
			_labDesc = new Label();
			_labDesc.x = 45;
			_labDesc.y = 77;
			_labDesc.width = 239;
			_labDesc.height = 16;
			_labDesc.text = CJLang("RANDOMBOX_DESC");
			_labDesc.textRendererProperties.textFormat = ffDesc;
			_labDesc.textRendererFactory = function():ITextRenderer
			{
				var _htmltextRender:TextFieldTextRendererEx;
				_htmltextRender = new TextFieldTextRendererEx()
				_htmltextRender.isHTML = true;
				var matrix:Array = [0,1,0,
					1,1,1,
					0,1,0];
				_htmltextRender.nativeFilters = [new ConvolutionFilter(3,3,matrix,3) , new GlowFilter(0x000000,1.0,2.0,2.0,5,2)];
				return _htmltextRender;
			};
			this.boxLayer.addChild(_labDesc);
			
			// 宝箱内道具
			this._itemFst = new CJRandomBoxItem();
			this._itemFst.x = 40;
			this._itemFst.y = 114;
			this.boxLayer.addChild(this._itemFst);
			_itemFst.addEventListener(starling.events.TouchEvent.TOUCH, _onClickResultItem);
			
			this._itemScd = new CJRandomBoxItem();
			this._itemScd.x = 141;
			this._itemScd.y = 114;
			this.boxLayer.addChild(this._itemScd);
			_itemScd.addEventListener(starling.events.TouchEvent.TOUCH, _onClickResultItem);
			
			this._itemThd = new CJRandomBoxItem();
			this._itemThd.x = 242;
			this._itemThd.y = 114;
			this.boxLayer.addChild(this._itemThd);
			_itemThd.addEventListener(starling.events.TouchEvent.TOUCH, _onClickResultItem);
			
			_boxItemArray.push(_itemFst, _itemScd, _itemThd);
			
			// 宝箱道具
			this._itemBox = new CJRandomBoxBoxItem(this._itemTmplIdBox);
			this._itemBox.x = 53;
			this._itemBox.y = 212;
			this._itemBox.setCount(_itemBoxCount);
			this.boxLayer.addChild(this._itemBox);
			
			// 钥匙道具
			this._itemKey = new CJRandomBoxBoxItem(this._itemTmplIdKey);
			this._itemKey.x = 127;
			this._itemKey.y = 212;
			this._itemKey.setCount(_itemKeyCount);
			this.boxLayer.addChild(this._itemKey);
			
			// 开启按钮
			this.btnOpen.defaultSkin = new SImage(SApplication.assets.getTexture("kaibaoxiang_anniu01"));
			this.btnOpen.downSkin = new SImage(SApplication.assets.getTexture("kaibaoxiang_anniu02"));
			this.btnOpen.defaultLabelProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 13, 0xFFF84E,null,null,null,null,null, TextFormatAlign.CENTER);
			this.btnOpen.labelFactory = textRender.standardTextRender;
			this.btnOpen.label = CJLang("RANDOMBOX_BTN_OPEN");
			this.btnOpen.addEventListener(starling.events.Event.TRIGGERED, this._onBtnClickOpen);
			
			// 关闭按钮
			this.btnClose.defaultSkin  = new SImage(SApplication.assets.getTexture("common_quanpingguanbianniu01"));
			this.btnClose.downSkin = new SImage(SApplication.assets.getTexture("common_quanpingguanbianniu02"));
			// 为关闭按钮添加监听
			this.btnClose.addEventListener(starling.events.Event.TRIGGERED, this._onBtnClickClose);
			
			_addAnimStar();
		}
		
		/**
		 * 增加闪烁星星动画
		 * 
		 */		
		private function _addAnimStar():void
		{
			var animWidth:int = 80;
			
			var animObject:Object = AssetManagerUtil.o.getObject("anim_xiangqiankaikong");
			this._animStarOne = SAnimate.SAnimateFromAnimJsonObject(animObject);
			this._animStarOne.width = animWidth;
			this._animStarOne.height = animWidth;
			this._animStarOne.x = this.boxLayer.width / 3 - (_animStarOne.width / 2);
			this._animStarOne.y = 40;
			this._animStarOne.loop = true;
			this._animStarOne.touchable = false;
			this.boxLayer.addChild(this._animStarOne);
			Starling.juggler.add(_animStarOne);
			this._animStarOne.gotoAndPlay();
			this._animStarOne.currentFrame = _getRandomNum();
			
			this._animStarTwo = SAnimate.SAnimateFromAnimJsonObject(animObject);
			this._animStarTwo.width = animWidth;
			this._animStarTwo.height = animWidth;
			this._animStarTwo.x = this.boxLayer.width / 3 * 2 - (_animStarOne.width / 2);
			this._animStarTwo.y = 40;
			this._animStarTwo.loop = true;
			this._animStarTwo.touchable = false;
			this.boxLayer.addChild(this._animStarTwo);
			Starling.juggler.add(_animStarTwo);
			this._animStarTwo.gotoAndPlay();
			this._animStarTwo.currentFrame = _getRandomNum();
			
			this._animStarThree = SAnimate.SAnimateFromAnimJsonObject(animObject);
			this._animStarThree.width = animWidth;
			this._animStarThree.height = animWidth;
			this._animStarThree.x = btnOpen.x + ((btnOpen.width - _animStarThree.width) / 2);
			this._animStarThree.y = btnOpen.y + ((btnOpen.height - _animStarThree.height) / 2);
			this._animStarThree.loop = true;
			this._animStarThree.touchable = false;
			this.boxLayer.addChild(this._animStarThree);
			Starling.juggler.add(_animStarThree);
			this._animStarThree.gotoAndPlay();
			this._animStarThree.currentFrame = _getRandomNum();
		}
		/**
		 * 获取0-9的随机数
		 * @return 
		 * 
		 */		
		private function _getRandomNum():int
		{
			return int(Math.random() * 9);
		}
		
		/**
		 * 移除闪烁星星动画
		 * 
		 */		
		private function _removeAnimStar():void
		{
			if (_animStarOne != null)
			{
				Starling.juggler.remove(_animStarOne);
			}
			if (_animStarTwo != null)
			{
				Starling.juggler.remove(_animStarTwo);
			}
			if (_animStarThree != null)
			{
				Starling.juggler.remove(_animStarThree);
			}
		}
		
		private function _onClickResultItem(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this.boxLayer, TouchPhase.BEGAN);
			if (!touch)
			{
				return;
			}
			var item:CJRandomBoxItem = event.currentTarget as CJRandomBoxItem;
			if (item.status == ConstBag.FrameCreateStateUnlock)
			{
				CJItemUtil.showItemTooltipsWithTemplateId(item.templateId);
			}
		}
		/**
		 * 添加监听事件
		 * 
		 */		
		private function _addListeners():void
		{
			_dataBag.addEventListener(DataEvent.DataLoadedFromRemote, this._onReceiveBagData);
			
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _onRpcReturn);
		}
		
		override public function dispose():void
		{
			_dataBag.removeEventListener(DataEvent.DataLoadedFromRemote, this._onReceiveBagData);
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData, _onRpcReturn);
			_removeAnimStar();
			super.dispose();
		}
		
		
		/**
		 * RPC返回响应
		 * @param e
		 * 
		 */		
		private function _onRpcReturn(e:Event):void
		{
			var msg:SocketMessage = e.data as SocketMessage;
			if(msg.getCommand() == ConstNetCommand.CS_ITEM_USERANDOMBOX)
			{
				if (msg.retcode == 0)
				{
					var params:Object = msg.retparams;
					var data:Array = params.data;
					
					var itemTemp:CJRandomBoxItem;
					for (var index:int = 0; index < _boxItemArray.length; index++)
					{
						itemTemp = _boxItemArray[index] as CJRandomBoxItem;
						itemTemp.setItemByTmplId(int(data[index].tmplid), true);
						itemTemp.setCount(int(data[index].count));
					}
					
					this._btnOpen.label = CJLang("RANDOMBOX_BTN_AGAIN");
					
					// 刷新背包数据
					_dataBag.loadFromRemote();
				}
				else if (msg.retcode == 4)
				{
					// 宝箱数量不足
					CJMessageBox(CJLang(_itemTmplBox.itemname) + CJLang("RANDOMBOX_ALERT_BOXCOUNT"));
					_dataBag.loadFromRemote();
					return;
				}
				else if (msg.retcode == 5)
				{
					// 钥匙数量不足
					CJMessageBox(CJLang(_itemTmplKey.itemname) + CJLang("RANDOMBOX_ALERT_BOXCOUNT"));
					_dataBag.loadFromRemote();
					return;
				}
				else if (msg.retcode == 6)
				{
					// 背包空间不足
					CJMessageBox(CJLang("BAG_HAS_NOT_ENOUGH_GRID"));
					_dataBag.loadFromRemote();
					return;
				}
			}
		}
		
		/**
		 * 获取远程背包数据完成
		 */
		private function _onReceiveBagData(e:Event):void
		{
			_setBoxAndKeyCount();
			_redrawBoxAndKeyCount();
		}
		
		/**
		 * 请求服务器数据
		 */
		private function _remoteDataRequest():void
		{
			
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function _onBtnClickOpen(e:Event):void
		{
			if (_itemBoxCount <= 0)
			{
				// 宝箱数量不足
				CJMessageBox(CJLang(_itemTmplBox.itemname) + CJLang("RANDOMBOX_ALERT_BOXCOUNT"));
				return;
			}
			if (_itemKeyCount <= 0)
			{
				// 钥匙数量不足
				CJMessageBox(CJLang(_itemTmplKey.itemname) + CJLang("RANDOMBOX_ALERT_BOXCOUNT"));
				return;
			}
			if (_dataBag.getBagEmptyGridCount() < _getRandomItemCount)
			{
				// 背包空间不足
				CJMessageBox(CJLang("BAG_HAS_NOT_ENOUGH_GRID"));
				return;
			}
			SocketCommand_item.useRandomBox(_itemTmplBox.id);
		}
		
		/**
		 * 点击关闭按钮
		 * @param e
		 * 
		 */		
		private function _onBtnClickClose(e:Event):void{
			//退出背包模块
			SApplication.moduleManager.exitModule("CJRandomBoxModule");
		}
		
		
		/** Controls */
		/** 关闭按钮 */
		private var _btnClose:Button;
		/** 背包背景图 */
		private var _imgBagLayerBg:ImageLoader;
		/** 道具 */
		private var _itemFst:CJRandomBoxItem;
		private var _itemScd:CJRandomBoxItem;
		private var _itemThd:CJRandomBoxItem;
		/** 宝箱 */
		private var _itemBox:CJRandomBoxBoxItem;
		/** 钥匙 */
		private var _itemKey:CJRandomBoxBoxItem;
		/** 层 - 随机宝箱显示层 */
		private var _boxLayer:SLayer;
		/** 按钮 - 开启 */
		private var _btnOpen:Button;
		/** 文字 - 描述 */
		private var _labDesc:Label;
		
		/** Controlers getter */
		public function get btnClose():Button
		{
			return _btnClose;
		}
		public function get imgBagLayerBg():ImageLoader
		{
			return _imgBagLayerBg;
		}
		public function get boxLayer():SLayer
		{
			return _boxLayer;
		}
		public function get btnOpen():Button
		{
			return _btnOpen;
		}
		
		
		
		/** Controlers setter */
		public function set btnClose(value:Button):void
		{
			_btnClose = value;
		}
		public function set imgBagLayerBg(value:ImageLoader):void
		{
			_imgBagLayerBg = value;
		}
		public function set boxLayer(value:SLayer):void
		{
			_boxLayer = value;
		}
		public function set btnOpen(value:Button):void
		{
			_btnOpen = value;
		}
	}
}