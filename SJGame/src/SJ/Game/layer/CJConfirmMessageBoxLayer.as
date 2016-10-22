package SJ.Game.layer
{
	import flash.geom.Rectangle;
	
	import SJ.Game.controls.CJButtonUtil;
	import SJ.Game.lang.CJLang;
	import SJ.Game.utils.SSoundEffectUtil;
	
	import engine_starling.SApplication;
	
	import feathers.controls.Button;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import starling.events.Event;
	import starling.textures.Texture;

	public class CJConfirmMessageBoxLayer extends CJMessageBoxLayer
	{
		private var _cancel:Function;
		private var _quedingButton:Button;
		private var _quxiaoButton:Button;
		private var _space:Number = 39;
		private var _frame:Scale9Image
		private static var _ins:CJConfirmMessageBoxLayer = null;
		
		private var _oktext:String = CJLang("MESSAGE_BOX_CONFIRM");
		private var _canceltext:String = CJLang("MESSAGE_BOX_CANCEL");
		
		public static function get o():CJConfirmMessageBoxLayer
		{
			if(_ins == null)
				_ins = new CJConfirmMessageBoxLayer();
			return _ins;
		}
		
		public function CJConfirmMessageBoxLayer()
		{
			super();
			oktext = CJLang("COMMON_TRUE");
			canceltext = CJLang("COMMON_CANCEL");
		}
		override protected function _initButton():void
		{
			_quedingButton = CJButtonUtil.createCommonButton(CJLang("COMMON_TRUE"));
			_quedingButton.addEventListener(Event.TRIGGERED,_touchHandler);
			_quedingButton.labelOffsetY = -1;
			_quedingButton.x = 20;
			_quedingButton.y = this.height- _space;
			this.addChild(_quedingButton);
			
			
			_quxiaoButton = CJButtonUtil.createCommonButton(CJLang("COMMON_CANCEL"));
			 _quxiaoButton.addEventListener(Event.TRIGGERED,_cancelHandler);
			 _quxiaoButton.labelOffsetY = -1;
			 _quxiaoButton.x = 130;
			 _quxiaoButton.y = _quedingButton.y;
			this.addChild(_quxiaoButton);
			
		}
		
		public function set cancelBack(func:Function):void
		{
			_cancel = func;
		}
		
		public function reSize(w:Number,h:Number):void
		{
			this.setSize(w,h);
			var texture:Texture = SApplication.assets.getTexture("common_tankuangdi");
			var texture9:Scale9Textures = new Scale9Textures(texture,new Rectangle(19,19,1,1));
			this._image.textures = texture9
			this._image.width = w;
			this._image.height = h;
			_quedingButton.y = this.height - _space
			_quxiaoButton.y = _quedingButton.y
		}
		
		protected function _cancelHandler(e:Event):void
		{
			SSoundEffectUtil.playButtonNormalSound();
			this.removeFromParent(false);
			this._label.text = "";
			if(this._cancel!=null)
			{
				_cancel();
			}
		}
		
		override protected function draw():void
		{
			// TODO Auto Generated method stub
			super.draw();
			_quedingButton.label = _oktext;
			_quxiaoButton.label = canceltext;
		}
		
		
		/**
		 * ok 文字 
		 */
		public function get oktext():String
		{
			return _oktext;
		}

		/**
		 * @private
		 */
		public function set oktext(value:String):void
		{
			_oktext = value;
			
			this.invalidate();
		}

		/**
		 * 取消文字 
		 */
		public function get canceltext():String
		{
			return _canceltext;
		}

		/**
		 * @private
		 */
		public function set canceltext(value:String):void
		{
			_canceltext = value;
			
			this.invalidate();
		}


	}
}