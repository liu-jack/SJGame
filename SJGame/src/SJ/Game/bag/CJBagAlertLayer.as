package SJ.Game.bag
{
	
	
//	import SJ.Common.Constants.ConstNetCommand;
//	import SJ.Game.SocketServer.SocketCommand_item;
//	import SJ.Game.SocketServer.SocketManager;
//	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.lang.CJLang;
	
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
	
	import starling.events.Event;
	import starling.textures.Texture;
	
//	import flash.filters.ConvolutionFilter;
//	import flash.filters.GlowFilter;
	/**
	 * 背包提示框层
	 * @author sangxu
	 * 
	 */	
	public class CJBagAlertLayer extends SLayer
	{
		
		public function CJBagAlertLayer()
		{
			super();
		}
		/** 页面宽高 */
		private var _widthVal:int = 200;
		private var _heightVal:int = 100;
		
		private var _contant:String = "";
		
		
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
				var textureBg:Texture = SApplication.assets.getTexture("common_tankuangdi");
				var bgScaleRange:Rectangle = new Rectangle(19,19,1,1);
				var bgTexture:Scale9Textures = new Scale9Textures(textureBg, bgScaleRange);
				this.imgBg = new Scale9Image(bgTexture);
			}
			this.imgBg.x = 0;
			this.imgBg.y = 0;
			this.imgBg.width = this.width;
			this.imgBg.height = this.height;
			this.addChildAt(this.imgBg, 0);
			
			/** 字体 - 文字 */
			var fontCont:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 13, 0xE9B54B, null, null, null, null, null, TextFormatAlign.CENTER);
			/** 字体 - 按钮 */
			var fontBtn:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 11, 0xFFFEFD);
			
			// 文字
			if (null == this.labCont)
			{
				this.labCont = new Label();
				this.labCont.width = this.width;
				this.labCont.height = 22;
				this.labCont.x = 0;
				this.labCont.y = 16;
//				this.labCont.textRendererProperties.fontFormat.multiline = true;
				this.labCont.textRendererProperties.wordWrap = true;
			}
			this.labCont.textRendererProperties.textFormat = fontCont;
			if ("" != this._contant)
			{
				this.labCont.text = this._contant;
			}
			else
			{
				this.labCont.text = "";
			}
			this.addChild(this.labCont);
				
			
			
			// 按钮 - 确认
			if (null == this.btnSure)
			{
				this.btnSure = new Button();
				this.btnSure.width = 60;
				this.btnSure.height = 22;
				this.btnSure.x = (this.width - this.btnSure.width) / 2;
				this.btnSure.y = this.height - this.btnSure.height - 15;
			}
			this.btnSure.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniu01new"));
			this.btnSure.downSkin = new SImage(SApplication.assets.getTexture("common_anniu02new"));
			this.btnSure.disabledSkin = new SImage(SApplication.assets.getTexture("common_anniu03new"));
			this.btnSure.defaultLabelProperties.textFormat = fontBtn;
			this.btnSure.label = CJLang("BAG_EXPAND_BTN_NAME_SURE");
			this.addChild(this.btnSure);
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
			// 确认按钮
			this.btnSure.addEventListener(Event.TRIGGERED, this._onBtnSureClick);
		}
		
		/**
		 * 按钮点击处理 - 确认按钮
		 * @param event
		 * 
		 */
		private function _onBtnSureClick(event:Event):void
		{
			this._removeAllEventListener();
			this.removeFromParent();
		}
		
		/**
		 * 移除所有事件监听
		 * 
		 */		
		private function _removeAllEventListener():void
		{
			this.btnSure.removeEventListener(Event.TRIGGERED, this._onBtnSureClick);
		}
		
		/** Controls */
		/** 背景图片 */
		private var _imgBg:Scale9Image;
		/** 显示语言内容 */
		private var _labCont:Label;
		/** 确认按钮 */
		private var _btnSure:Button;
		
		/** Controls getter */
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
		
		/** Controls setter */
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
	}
}