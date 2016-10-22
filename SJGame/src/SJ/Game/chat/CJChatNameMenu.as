package SJ.Game.chat
{
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.lang.CJLang;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	
	import feathers.controls.Button;
	import feathers.controls.TabBar;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import starling.events.Event;
	
	/**
	 +------------------------------------------------------------------------------
	 * 点击名字链接弹出的菜单
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-6-8 下午6:02:08  
	 +------------------------------------------------------------------------------
	 */
	public class CJChatNameMenu extends TabBar
	{
		/*弹出menu上的名字*/
		public const NAME_BUTTON_LIST:Array = ["VIEW" ,  "PRIVATE" , "FRIEND" , "REMOVE"]; 
		/*弹出menu*/
		private var _nameBar:TabBar;
		/*关闭按钮*/
		private var _btnClose:Button;
		
		public function CJChatNameMenu()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			this._drawContent();
			this._addEventListeners();
		}
		
		private function _addEventListeners():void
		{
			this._btnClose.addEventListener(Event.TRIGGERED , this._closeDialog);
			this._nameBar.addEventListener(Event.CHANGE, _channelChangeHandler);
		}
		
		private function _channelChangeHandler(e:Event):void
		{
			if(e.target is TabBar && (e.target as TabBar).name == "namebar")
			{
				var tabs:TabBar = e.currentTarget as TabBar;
				var selectedIndex:int = tabs.selectedIndex;
				if(selectedIndex == -1)
				{
					return;
				}
				CJEventDispatcher.o.dispatchEventWith("namemenuclicked" , false , {"menu":tabs.selectedItem.name});
			}
		}
		
		private function _drawContent():void
		{
			var bg:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_liaotian_wenzidi") , new Rectangle(4 , 4 , 1, 1)));
			bg.width = 68;
			bg.height = 135;
			this.addChild(bg);
			
			this._nameBar = new TabBar();
			this._nameBar.name = "namebar";
			this._nameBar.direction = TabBar.DIRECTION_VERTICAL;
			this._nameBar.gap = 6;
			this._nameBar.selectedIndex = -1;
			this._setTabRender();
			this._setTabBarData();
			this._nameBar.x = 3 ;
			this._nameBar.y = 3 ;
			this.addChild(_nameBar);
			
			_btnClose = new Button();
			_btnClose.defaultSkin = new SImage(SApplication.assets.getTexture("common_tipguanbianniu01"));
			_btnClose.downSkin = new SImage(SApplication.assets.getTexture("common_tipguanbianniu02"));
			_btnClose.x = 65;
			_btnClose.y = -9;
			_btnClose.name = "close";
			this.addChild(_btnClose);
		}
		
		private function _setTabRender():void
		{
			this._nameBar.tabFactory = function():Button
			{
				var btn:Button = new Button();
				btn.defaultSkin = new SImage(SApplication.assets.getTexture("common_tipanniu01"));
				btn.defaultSelectedSkin = new SImage(SApplication.assets.getTexture("common_tipanniu02"));
				btn.width = 60;
				btn.height = 27;
				var format:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI , 13 , 0x000000 );
				format.align = TextFormatAlign.CENTER;
				btn.defaultLabelProperties.textFormat = format;
				return btn;
			}
		}
		
		private function _setTabBarData():void
		{
			var data:Array = new Array();
			for(var i:String in NAME_BUTTON_LIST)
			{
				data.push({label : CJLang("CHAT_"+NAME_BUTTON_LIST[i]) , name:NAME_BUTTON_LIST[i]});
			}
			this._nameBar.dataProvider = new ListCollection(data);
		}
		
		private function _closeDialog(e:Event):void
		{
			if((e.target as Button).name != "close")
			{
				return;
			}
			this.closeMenu();
		}
		
		public function closeMenu():void
		{
			if(this.parent && this != null)
			{
				if(this._nameBar)
				{
					this._nameBar.removeEventListener(Event.CHANGE, _channelChangeHandler);
				}
				this.removeFromParent();
			}
		}
	}
}