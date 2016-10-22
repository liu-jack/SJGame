package SJ.Game.Notice
{
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import SJ.Game.controls.CJPanelFrame;
	import SJ.Game.controls.CJPanelTitle;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.lang.CJLang;
	import SJ.Game.utils.SCompileUtils;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.controls.ScrollText;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import starling.events.Event;
	
	/**
	 +------------------------------------------------------------------------------
	 * 公告页面
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-10-9 下午3:57:03  
	 +------------------------------------------------------------------------------
	 */
	public class CJNoticeLayer extends SLayer
	{
		private var _content:String = "";
		private var _scrollText:ScrollText;		
		
		public function CJNoticeLayer()
		{
			super();
		}
		
		override protected function initialize():void
		{
			this._drawContent();
		}
		
		private function _initNewestNotice():void
		{
			var newestNotice:Object = CJDataManager.o.DataOfNotice.getNewestNotice();
			if(newestNotice && newestNotice.hasOwnProperty('content'))
			{
				this.text = newestNotice['content'];
			}
		}
		
		override protected function draw():void
		{
			if(_content == '')
			{
				_content = ".";
			}
			
			_scrollText.text = _content;
			
			super.draw();
		}
		
		private function _drawContent():void
		{
			this._drawBg();
			this._drawTitle();
		}
		
		private function _drawTitle():void
		{
			var title:CJPanelTitle = new CJPanelTitle(CJLang("FUNCTION_NAME_31"));
			this.addChild(title);
			title.x = 10;
			title.y = -15;
		}
		
		private function _drawBg():void
		{
			//底框
			var bgWrap:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_waikuangnew") , new Rectangle(15 , 15 , 1, 1)));
			bgWrap.width = 330;
			bgWrap.height = 190;
			this.addChildAt(bgWrap , 0);
			
			//滚珠
			var bgBall:CJPanelFrame = new CJPanelFrame(320 , 180);
			bgBall.width = 320;
			bgBall.height = 180;
			bgBall.x = 5;
			bgBall.y = 5;
			this.addChildAt(bgBall , 0 );
			
			//底
			var bg:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_dinew") , new Rectangle(1 ,1 , 1, 1)));
			bg.width = 330;
			bg.height = 190;
			this.addChildAt(bg , 0);
			
			//关闭按钮
			var closeBtn:Button = new Button();
			closeBtn.defaultSkin = new SImage(SApplication.assets.getTexture("common_guanbianniu01new"));
			closeBtn.downSkin = new SImage(SApplication.assets.getTexture("common_guanbianniu02new"));
			closeBtn.x = 307;
			closeBtn.y = -17;
			closeBtn.addEventListener(Event.TRIGGERED , function():void
			{
				SApplication.moduleManager.exitModule('CJNoticeModule');
			});
			this.addChild(closeBtn);
			
			_scrollText = new ScrollText();
			_scrollText.isHTML = true;
			_scrollText.width = 305;
			_scrollText.height = 162;
			_scrollText.x = 15;
			_scrollText.y = 15;
			_scrollText.textFormat = new TextFormat("黑体" , 12 , 0xFFFFFF);
			this.addChild(_scrollText);
				
			_initNewestNotice();
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
			
			//正在审核的话，屏蔽公告
			if(SCompileUtils.o.isOnVerify())
			{
				_content = "";
			}
			
			this.invalidate();
		}
	}
}