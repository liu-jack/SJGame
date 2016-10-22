package SJ.Game.layer
{
	import SJ.Game.controls.CJPanelFrame;
	import SJ.Game.controls.CJPanelTitle;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJLayerManagerWrapper;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.controls.ScrollText;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import starling.events.Event;
	
	/**
	 +------------------------------------------------------------------------------
	 * 弹出提示框
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-11-9 下午3:00:03  
	 +------------------------------------------------------------------------------
	 */
	public class CJTipLayer extends SLayer
	{
		private var _content:String = "";
		private var _scrollText:ScrollText;	
		private var _callBack:Function;
		
		public function CJTipLayer(callBack:Function = null)
		{
			super();
			this._callBack = callBack;
		}
		
		override protected function initialize():void
		{
			this._drawContent();
		}
		
		override protected function draw():void
		{
			if(_content == '')
			{
				return;
			}
			_scrollText.text = _content;
		}
		
		private function _drawContent():void
		{
			this._drawBg();
//			this._drawTitle();
		}
		
		private function _drawTitle():void
		{
			var title:CJPanelTitle = new CJPanelTitle(CJLang("FUNCTION_NAME_31"));
			title.width = 20;
			this.addChild(title);
			title.x = 10;
			title.y = -15;
		}
		
		private function _drawBg():void
		{
			this.width = 350;
			this.height = 150;
			//底框
			var bgWrap:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_waikuangnew") , new Rectangle(15 , 15 , 1, 1)));
			bgWrap.width = 350;
			bgWrap.height = 150;
			this.addChildAt(bgWrap , 0);
			
			//滚珠
//			var bgBall:CJPanelFrame = new CJPanelFrame(240 , 110);
//			bgBall.width = 240;
//			bgBall.height = 110;
//			bgBall.x = 5;
//			bgBall.y = 5;
//			this.addChildAt(bgBall , 0 );
			
			//底
			var bg:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_dinew") , new Rectangle(1 ,1 , 1, 1)));
			bg.width = 350;
			bg.height = 150;
			this.addChildAt(bg , 0);
			
			//关闭按钮
			var closeBtn:Button = new Button();
			closeBtn.defaultSkin = new SImage(SApplication.assets.getTexture("common_guanbianniu01new"));
			closeBtn.downSkin = new SImage(SApplication.assets.getTexture("common_guanbianniu02new"));
			closeBtn.x = 323;
			closeBtn.y = -19;
			closeBtn.addEventListener(Event.TRIGGERED , close);
			this.addChild(closeBtn);
			
			_scrollText = new ScrollText();
			_scrollText.isHTML = true;
			_scrollText.width = 335;
			_scrollText.height = 140;
			_scrollText.x = 15;
			_scrollText.y = 15;
			_scrollText.textFormat = new TextFormat("黑体" , 12 , 0xFFFFFF);
			this.addChild(_scrollText);
		}
		
		public function get text():String
		{
			return _content;
		}
		
		public function set text(value:String):void
		{
			if(value == '' || value == null || value == _content)
			{
				return;
			}
			_content = value;
			this.invalidate();
		}
		
		override public function dispose():void
		{
			super.dispose();
			this._callBack = null;
		}
		
		public function addToModal():void
		{
			CJLayerManagerWrapper.o.addToModalSequence(this);
		}
		
		public function close():void
		{
			if(this._callBack != null)
			{
				this._callBack();
			}
			this._callBack = null;
			this.removeFromParent(true);
		}
	}
}