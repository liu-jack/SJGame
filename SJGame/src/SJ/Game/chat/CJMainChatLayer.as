package SJ.Game.chat
{
	import SJ.Game.data.CJDataManager;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.richtext.CJRichText;
	
	import engine_starling.SApplication;
	import engine_starling.display.SLayer;
	
	import feathers.controls.ImageLoader;
	import feathers.display.Scale3Image;
	import feathers.textures.Scale3Textures;
	
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 +------------------------------------------------------------------------------
	 * 主界面的显示聊天层
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-7-27 上午8:59:42  
	 +------------------------------------------------------------------------------
	 */
	public class CJMainChatLayer extends SLayer
	{
		/*大的菜单*/
		private static const BIGMENU:Number = 345;
		/*小的菜单*/
		private static const SMALLMENU:Number = 240;
		
		/*聊天显示黑色背景*/
		private var _bg:Scale3Image;
		/*左下角的小信息图标*/
		private var _infoIcon:ImageLoader;
		/*显示信息*/
		private var _richText:CJRichText;
		
		/*信息可显示区域 - 大*/
		private static const INFO_LENGTH_BIG:Number = 202;
		/*信息可显示区域 - 小*/
		private static const INFO_LENGTH_SMALL:Number = 96;
		
		/*单行 - text的位置*/
		private static const POS_SINGAL:Number = 8;
		/*多行 - text的位置*/
		private static const POS_MULTI:Number = 3;
		
		public function CJMainChatLayer()
		{
			super();
		}
		
		override protected function initialize():void
		{
			this._drawContent();
			this._addEventListeners();
			super.initialize();
			this._showNewestMessage();
		}
		
		private function _showNewestMessage():void
		{
			var newElements:Array = CJDataManager.o.DataOfChat.newestElments;
			_richText.draWithElementArray(newElements);
			if(_richText.realtextWidth > _richText.width)
			{
				_richText.y = POS_MULTI;
			}
			else
			{
				_richText.y = POS_SINGAL;
			}
		}
		
		private function _addEventListeners():void
		{
			this.addEventListener(TouchEvent.TOUCH, this._onTouch);
			CJEventDispatcher.o.addEventListener(CJEvent.EVENT_CHAT_NEW_MESSAGE  , this._changeInfo);
		}
		
		override public function dispose():void
		{
			CJEventDispatcher.o.removeEventListener(CJEvent.EVENT_CHAT_NEW_MESSAGE  , this._changeInfo);
			super.dispose();
		}
		
		
		
		private function _changeInfo(e:Event):void
		{
			if(e.type != CJEvent.EVENT_CHAT_NEW_MESSAGE)
			{
				return;
			}
			_showNewestMessage();
		}
		
		private function _onTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this);
			if(touch)
			{
				if(touch.phase == TouchPhase.ENDED)
				{
					SApplication.moduleManager.enterModule("CJChatModule");
				}
			}
		}
		
		public function resize(isHide:Boolean):void
		{
			var newestElements:Array = CJDataManager.o.DataOfChat.newestElments;
			
			if(isHide)
			{
				_bg.width = BIGMENU;
				_richText.width = INFO_LENGTH_BIG;
			}
			else
			{
				_bg.width = SMALLMENU;
				_richText.width = INFO_LENGTH_SMALL;
			}
			
			if(newestElements)
			{
				_richText.draWithElementArray(newestElements);
			}
			
			if(_richText.realtextWidth > _richText.width)
			{
				_richText.y = POS_MULTI;
			}
			else
			{
				_richText.y = POS_SINGAL;
			}
		}
		
		private function _drawContent():void
		{
			_bg = new Scale3Image(new Scale3Textures(SApplication.assets.getTexture("zhujiemian_duihua") , 50 , 15));
			_bg.width = BIGMENU;
			_bg.x = -43;
			this.addChild(_bg);
			
			_infoIcon = new ImageLoader();
			_infoIcon.source = SApplication.assets.getTexture("zhujiemian_duihuabiao");
			_infoIcon.x = 7;
			_infoIcon.y = 8;
			this.addChild(_infoIcon);
			
			_richText = new CJRichText(INFO_LENGTH_BIG);
			_richText.x = 30;
			_richText.y = POS_MULTI;
			this.addChild(_richText);
		}
	}
}