package SJ.Game.bag
{
	import SJ.Common.Constants.ConstItem;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.SocketServer.SocketCommand_item;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.lang.CJLang;
	import SJ.Game.task.CJTaskEvent;
	import SJ.Game.task.CJTaskEventHandler;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.controls.TextInput;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import starling.events.Event;
	import starling.textures.Texture;
	
	/**
	 * 背包提示框层
	 * @author sangxu
	 * 
	 */	
	public class CJItemUseCountLayer extends SLayer
	{
		
		public function CJItemUseCountLayer()
		{
			super();
		}
		/** 页面宽高 */
		private var _widthVal:int = 176;
		private var _heightVal:int = 122;
		
		private var _contant:String = "";
		/** 确认按钮回调 */
		private var _sureCallback:Function;
		/** 取消按钮回调 */
		private var _cancelCallback:Function;
		
		private var _maxValue:int = 1;
		/** 使用逻辑id */
		private var _useLogicId:int = 0;
		/** 使用道具是否为最大值, true使用数量为可使用最大值, false显示使用数量为1 */
		private var _useMax:Boolean = true;
		
		override protected function initialize():void
		{
			super.initialize();
			
			this._initData();
			
			this._initControls();
			
			this._addListener();
			
		}
		

		
		/**
		 * 初始化数据
		 * 
		 */
		private function _initData():void
		{
			
		}
		/**
		 * 初始化控件
		 * 
		 */		
		private function _initControls():void
		{
			
			this.width = this._widthVal;
			this.height = this._heightVal;
			this.x = (stage.width - this.width) / 2;
			this.y = (stage.height - this.height) / 2;
			
			// 背景图
			if (null == this.imgBg)
			{
				var textureBg:Texture = SApplication.assets.getTexture("common_tishikuang");
				var bgScaleRange:Rectangle = new Rectangle(16, 15, 1, 1);
				var bgTexture:Scale9Textures = new Scale9Textures(textureBg, bgScaleRange);
				this.imgBg = new Scale9Image(bgTexture);
				this.imgBg.x = 0;
				this.imgBg.y = 0;
				this.imgBg.width = this.width;
				this.imgBg.height = this.height;
				this.addChildAt(this.imgBg, 0);
			}
			
			/** 字体 - 文字 */
			var fontCont:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 10, 0xFFFFFF, null, null, null, null, null, TextFormatAlign.CENTER);
			/** 字体 - 数字 */
			var fontInput:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 10, 0x000000, null, null, null, null, null, TextFormatAlign.CENTER);
			/** 字体 - 按钮 */
			var fontBtn:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 11, 0xD5CDA1);
			
			// 文字 - 使用
			if (null == this.labCont)
			{
				this.labCont = new Label();
				this.labCont.width = 24;
				this.labCont.height = 15;
				this.labCont.x = 17;
				this.labCont.y = 47;
//				this.labCont.textRendererProperties.wordWrap = true;
				this.addChild(this.labCont);
				this.labCont.textRendererProperties.textFormat = fontCont;
				this.labCont.text = CJLang("ITEM_TOOLTIP_BTN_USE");
			}
			
			// 按钮 - 减
			if (null == this.btnSub)
			{
				this.btnSub = new Button();
				this.btnSub.width = 18;
				this.btnSub.height = 18;
				this.btnSub.x = 48;
				this.btnSub.y = 45;
				this.addChild(this.btnSub);
				this.btnSub.defaultSkin = new SImage(SApplication.assets.getTexture("common_jiananniu"));
			}
			
			// 按钮 - 加
			if (null == this.btnAdd)
			{
				this.btnAdd = new Button();
				this.btnAdd.width = 18;
				this.btnAdd.height = 18;
				this.btnAdd.x = 138;
				this.btnAdd.y = 45;
				this.addChild(this.btnAdd);
				this.btnAdd.defaultSkin = new SImage(SApplication.assets.getTexture("common_jiaanniu"));
			}
			
			// 按钮 - MAX
			if (null == this.btnMax)
			{
				this.btnMax = new Button();
				this.btnMax.width = 32;
				this.btnMax.height = 12;
				this.btnMax.x = 86;
				this.btnMax.y = 29;
				this.addChild(this.btnMax);
				this.btnMax.defaultSkin = new SImage(SApplication.assets.getTexture("zq_zuidahua"));
			}
			
			// 图片 - 输入框
//			if (null == this.imgInput)
//			{
//				this.imgInput = new ImageLoader();
//				this.imgInput.width = 57;
//				this.imgInput.height = 16;
//				this.imgInput.x = 74;
//				this.imgInput.y = 46;
//			}
//			this.imgInput.source = new SImage(SApplication.assets.getTexture("zuoqi_shurukuang"));
//			this.addChild(this.imgInput);
			
			// 按钮 - 确认
			if (null == this.btnSure)
			{
				this.btnSure = new Button();
				this.btnSure.width = 53;
				this.btnSure.height = 28;
				this.btnSure.x = 26;
				this.btnSure.y = 82;
				this.addChild(this.btnSure);
				this.btnSure.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniu01new"));
				this.btnSure.downSkin = new SImage(SApplication.assets.getTexture("common_anniu02new"));
				if (this._useLogicId == ConstItem.SCONST_ITEM_USE_LOGIC_COMPOSEITEM
					|| this._useLogicId == ConstItem.SCONST_ITEM_USE_LOGIC_COMPOSEHERO
					|| this._useLogicId == ConstItem.SCONST_ITEM_USE_LOGIC_COMPOSEHORSE)
				{
					this.btnSure.label = CJLang("BAG_BTN_NAME_COMPOSE");
				}
				else
				{
					this.btnSure.label = CJLang("BAG_EXPAND_BTN_NAME_SURE");
				}
				this.btnSure.defaultLabelProperties.textFormat = fontBtn;
			}
			
			// 按钮 - 取消
			if (null == this.btnCancel)
			{
				this.btnCancel = new Button();
				this.btnCancel.width = 53;
				this.btnCancel.height = 28;
				this.btnCancel.x = 98;
				this.btnCancel.y = 82;
				this.addChild(this.btnCancel);
				this.btnCancel.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniu01new"));
				this.btnCancel.downSkin = new SImage(SApplication.assets.getTexture("common_anniu02new"));
				this.btnCancel.label = CJLang("BAG_EXPAND_BTN_NAME_CANCEL");
				this.btnCancel.defaultLabelProperties.textFormat = fontBtn;
			}
			
			// 输入框
			if (this.tiInput == null)
			{
				this.tiInput = new TextInput();
				this.tiInput.width = 57;
				this.tiInput.height = 16;
				this.tiInput.x = 74;
				this.tiInput.y = 46;
				this.tiInput.backgroundSkin = new SImage(SApplication.assets.getTexture("zuoqi_shurukuang"));
				this.tiInput.textEditorProperties = fontInput;
				if (_useMax)
				{
					this.tiInput.text = String(this._maxValue);
				}
				else
				{
					this.tiInput.text = "1";
				}
				this.addChild(this.tiInput);
			}
		}
		
		/**
		 * 设置提示框提示语
		 * @param contant
		 * 
		 */		
		public function setContant(contant:String):void
		{
			this._contant = contant;
			if (null != this.labCont)
			{
				this.labCont.text = contant;
			}
		}

		/**
		 * 设置提示框宽高
		 * @param widthValue	宽度
		 * @param heightValue	高度
		 * 
		 */		
		public function setLayerSize(widthValue:int, heightValue:int):void
		{
			this._widthVal = widthValue;
			this._heightVal = heightValue;
		}
		
		
		/**
		 * 设置事件监听
		 * 
		 */		
		private function _addListener() : void
		{
			// 监听数据事件
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, this._onRpcReturn);
			// 按钮 - 减
			this._btnSub.addEventListener(Event.TRIGGERED, this._onBtnSubClick);
			// 按钮 - 加
			this._btnAdd.addEventListener(Event.TRIGGERED, this._onBtnAddClick);
			// 按钮 - MAX
			this._btnMax.addEventListener(Event.TRIGGERED, this._onBtnMaxClick);
			// 按钮 - 确认
			this._btnSure.addEventListener(Event.TRIGGERED, this._onBtnSureClick);
			// 按钮 - 取消
			this._btnCancel.addEventListener(Event.TRIGGERED, this._onBtnCancelClick);
			
		}
		
		/**
		 * 移除所有事件监听
		 * 
		 */		
		private function _removeAllEventListener():void
		{
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData, this._onRpcReturn);
			// 按钮 - 减
			this._btnSub.removeEventListener(Event.TRIGGERED, this._onBtnSubClick);
			// 按钮 - 加
			this._btnAdd.removeEventListener(Event.TRIGGERED, this._onBtnAddClick);
			// 按钮 - MAX
			this._btnMax.removeEventListener(Event.TRIGGERED, this._onBtnMaxClick);
			// 按钮 - 确认
			this._btnSure.removeEventListener(Event.TRIGGERED, this._onBtnSureClick);
			// 按钮 - 取消
			this._btnCancel.removeEventListener(Event.TRIGGERED, this._onBtnCancelClick);
		}
		
		/**
		 * RPC返回响应
		 * @param e
		 * 
		 */		
		private function _onRpcReturn(e:Event):void
		{
			var msg:SocketMessage = e.data as SocketMessage;
			if(msg.getCommand() == ConstNetCommand.CS_ITEM_USE_ITEM)
			{
				// 使用道具
				if (msg.retcode == 0)
				{
					// 更新页面货币显示
					SocketCommand_item.getBag();
					this._closeLayer();
					//发出使用道具的事件
					CJTaskEventHandler.o.dispatchEventWith(CJEvent.EVENT_TASK_ACTION_EXECUTED , false , {"type":CJTaskEvent.TASK_EVENT_USE_TOOL});
				}
			}
			
		}
		
		/**
		 * 按钮点击处理 - 减
		 * @param event
		 * 
		 */
		private function _onBtnSubClick(event:Event):void
		{
			var count:int = 0;
			count = parseInt(this.tiInput.text);
			if (count > 1)
			{
				if (count > this._maxValue)
				{
					this.tiInput.text = String(this._maxValue);
					return;
				}
				count--;
				this.tiInput.text = String(count);
			}
			else
			{
				this.tiInput.text = "1";
			}
		}
		
		/**
		 * 按钮点击处理 - 加
		 * @param event
		 * 
		 */
		private function _onBtnAddClick(event:Event):void
		{
			var count:int = 0;
			count = parseInt(this.tiInput.text);
			if (count < this._maxValue)
			{
				if (count < 1)
				{
					this.tiInput.text = "1";
					return;
				}
				count++;
				this.tiInput.text = String(count);
			}
			else
			{
				this.tiInput.text = String(this._maxValue);
			}
		}
		
		/**
		 * 按钮点击处理 - MAX
		 * @param event
		 * 
		 */
		private function _onBtnMaxClick(event:Event):void
		{
			this.tiInput.text = String(this._maxValue);
		}
		
		/**
		 * 按钮点击处理 - 确认
		 * @param event
		 * 
		 */
		private function _onBtnSureClick(event:Event):void
		{
			var count:int = 0;
			count = parseInt(this.tiInput.text);
			if (count < 1)
			{
				this.tiInput.text = "1";
				return;
			}
			if (count > this._maxValue)
			{
				this.tiInput.text = String(this._maxValue);
				return;
			}
			
			if (null != this._sureCallback)
			{
				this._sureCallback(count);
			}
		}
		
		/**
		 * 按钮点击处理 - 取消
		 * @param event
		 * 
		 */
		private function _onBtnCancelClick(event:Event):void
		{
			if (null != this._cancelCallback)
			{
				this._cancelCallback();
			}
			this._closeLayer();
		}
		
		/**
		 * 确认按钮回调方法
		 * @param value
		 * 
		 */		
		public function set sureCallBack(value:Function):void
		{
			this._sureCallback = value;
		}
		
		/**
		 * 关闭层
		 * 
		 */		
		private function _closeLayer():void
		{
			this.removeFromParent();
			this._removeAllEventListener();
		}
		
		/**
		 * 取消按钮回调方法
		 * @param value
		 * 
		 */		
		public function set cancelCallback(value:Function):void
		{
			this._cancelCallback = value;
		}
		
		/**
		 * 设置最大值
		 * @param value
		 * 
		 */			
		public function set maxValue(value:int):void
		{
			if (value > 0)
			{
				this._maxValue = value;
			}
		}
		
		public function set useLogicId(value:int):void
		{
			this._useLogicId = value;
		}
		
		/**
		 * 设置是否显示为最大值
		 * @param value: true - 使用数量为可使用最大值
		 *               false - 显示使用数量为1
		 */
		public function set useMax(value:Boolean):void
		{
			this._useMax = value;
		}
		/** Controls */
		/** 背景图片 */
		private var _imgBg:Scale9Image;
		/** 显示语言内容 */
		private var _labCont:Label;
		/** 数字内容 */
		private var _labValue:Label;
		/** 减按钮 */
		private var _btnSub:Button;
		/** 加按钮 */
		private var _btnAdd:Button;
		/** 最大按钮 */
		private var _btnMax:Button;
		/** 图片 - 输入框背景图 */
		private var _imgInput:ImageLoader;
		/** 输入框 */
		private var _tiInput:TextInput;
		/** 确认按钮 */
		private var _btnSure:Button;
		/** 取消按钮 */
		private var _btnCancel:Button;
		
		/** Controls getter */
		public function get imgBg():Scale9Image
		{
			return this._imgBg;
		}
		public function get labCont():Label
		{
			return this._labCont;
		}
		public function get labValue():Label
		{
			return this._labValue;
		}
		public function get btnSub():Button
		{
			return this._btnSub;
		}
		public function get btnAdd():Button
		{
			return this._btnAdd;
		}
		public function get btnMax():Button
		{
			return this._btnMax;
		}
		public function get imgInput():ImageLoader
		{
			return this._imgInput;
		}
		public function get tiInput():TextInput
		{
			return this._tiInput;
		}
		public function get btnSure():Button
		{
			return this._btnSure;
		}
		public function get btnCancel():Button
		{
			return this._btnCancel;
		}
		
		/** Controls setter */
		public function set imgBg(value:Scale9Image):void
		{
			this._imgBg = value;
		}
		public function set labCont(value:Label):void
		{
			this._labCont = value;
		}
		public function set labValue(value:Label):void
		{
			this._labValue = value;
		}
		public function set btnSub(value:Button):void
		{
			this._btnSub = value;
		}
		public function set btnAdd(value:Button):void
		{
			this._btnAdd = value;
		}
		public function set btnMax(value:Button):void
		{
			this._btnMax = value;
		}
		public function set imgInput(value:ImageLoader):void
		{
			this._imgInput = value;
		}
		public function set tiInput(value:TextInput):void
		{
			this._tiInput = value;
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