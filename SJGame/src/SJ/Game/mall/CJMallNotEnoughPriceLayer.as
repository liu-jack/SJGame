package SJ.Game.mall
{
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.SApplication;
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

	/**
	 * 商城货币不足提示框
	 * @author sangxu
	 * 
	 */	
	public class CJMallNotEnoughPriceLayer extends SLayer
	{
		private var _cancel:Function;
		
		private static var _ins:CJMallNotEnoughPriceLayer = null;
		/** 文字 - 标题 */
		protected var _labTitle:Label;
		/** 文字 - 提示内容 */
		protected var _labCont:Label;
		private var _callBack:Function;
		/** 按钮数组 */
		private var _btnVec:Vector.<Button>= new Vector.<Button>;
		public function CJMallNotEnoughPriceLayer()
		{
			super();
			_init();
		}
		
		public static function get o():CJMallNotEnoughPriceLayer
		{
			if(_ins == null)
				_ins = new CJMallNotEnoughPriceLayer();
			return _ins;
		}
		private function _init():void
		{
			_initBg();
			_initLable();
			_initButton();
		}
		
		/**
		 * 设置标题
		 * @param str
		 * 
		 */		
		public function set title(str:String):void
		{
			this._labTitle.text = str;
		}
		
		/**
		 * 设置文字 
		 * @param str
		 * 
		 */
		public function set text(str:String):void
		{
			_labCont.text = str;
		}
		
		/**
		 * 在弹出框中增加按钮
		 * @param button
		 * 
		 */		
		public function addButton(button:Button):void
		{
			this._btnVec.push(button);
			this.addChild(button);
			
		}
		
		/**
		 * 设置回调函数
		 * @param func
		 * 
		 */
		public function set callBack(func:Function):void
		{
			_callBack = func;
		}
		
		/**
		 * 关闭层
		 * 
		 */		
		private function _closeLayer():void
		{
			for each (var button:Button in this._btnVec)
			{
				if (button != null)
				{
					if (this.contains(button))
					{
						button.removeEventListeners(Event.TRIGGERED);
					}
				}
			}
//			this._btnVec = null;
		}
		
		override public function removeFromParent(dispose:Boolean=false):void 
		{
			super.removeFromParent(dispose);
			this._closeLayer();
		}
		
		/**
		 * 初始化背景图
		 * 
		 */		
		protected function _initBg():void
		{
			// 背景
			var texture:Texture = SApplication.assets.getTexture("common_tishikuang");
			var texture9:Scale9Textures = new Scale9Textures(texture,new Rectangle(16, 15, 1, 1));
			var image:Scale9Image = new Scale9Image(texture9);
			image.width = 220;
			image.height = 118;
			this.setSize(image.width,image.height);
			this.addChild(image);
			
			// 花框
//			var ttKuang:Texture = SApplication.assets.getTexture("common_bianzhuangshi");
//			var stKuang:Scale9Textures = new Scale9Textures(ttKuang, new Rectangle(13, 14, 1, 1));
//			var imageKuang:Scale9Image = new Scale9Image(stKuang);
//			imageKuang.x = 4;
//			imageKuang.y = 4;
//			imageKuang.width = 212;
//			imageKuang.height = 110;
//			this.addChild(imageKuang);
		}
		
		/**
		 * 初始化文字
		 * 
		 */		
		protected function _initLable():void
		{
			this._labTitle = new Label();
			this._labTitle.text = CJLang("MALL_ALERT_TITLE");
			this._labTitle.width = 50;
			this._labTitle.height = 15;
			this._labTitle.textRendererProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 18, 0xFF0000, null, null, null, null, null, TextFormatAlign.CENTER);
			this._labTitle.y = 10;
			this._labTitle.x = (this.width - this._labTitle.width) / 2;
			this.addChild(this._labTitle);
			
			this._labCont= new Label;
			var fontFormat:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 13, 0xFF0000,null,null,null,null,null,TextFormatAlign.CENTER);
			this._labCont.textRendererProperties.textFormat = fontFormat;
			this._labCont.textRendererProperties.wordWrap = true;
			this._labCont.x = 10;
			this._labCont.y = 44;
			this._labCont.width = this.width-20;
			this.addChild(this._labCont);
		}
		
		/**
		 * 初始化按钮
		 * 
		 */		
		protected function _initButton():void
		{
			
		}
	}
}