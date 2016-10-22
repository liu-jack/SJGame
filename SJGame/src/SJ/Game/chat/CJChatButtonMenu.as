package SJ.Game.chat
{
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import SJ.Common.Constants.ConstTextFormat;
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
	 * 点击频道按钮弹出的菜单
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-6-8 下午6:02:08  
	 +------------------------------------------------------------------------------
	 */
	public class CJChatButtonMenu extends TabBar
	{
		/*弹出menu上的名字*/
		public const NAME_BUTTON_LIST:Array = ["WORLD" , "ARMY" , "PRIVATE"]; 
		/*弹出menu*/
		private var _channelBar:TabBar;
		
		public function CJChatButtonMenu()
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
			this._channelBar.addEventListener(Event.CHANGE, _channelChangeHandler);
		}
		
		private function _channelChangeHandler(e:Event):void
		{
			if(e.target is TabBar && (e.target as TabBar).name == "channelbar")
			{
				var tabs:TabBar = e.currentTarget as TabBar;
				var selectedIndex:int = tabs.selectedIndex;
				if(selectedIndex == -1)
				{
					return;
				}
				this.dispatchEventWith("channelmenuclicked" , false , {"menu":tabs.selectedItem.name});
			}
		}
		
		private function _drawContent():void
		{
			var bg:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_liaotian_wenzidi") , new Rectangle(4 , 4 , 1, 1)));
			bg.width = 68;
			bg.height = 102;
			this.addChild(bg);
			
			this._channelBar = new TabBar();
			this._channelBar.name = "channelbar";
			this._channelBar.direction = TabBar.DIRECTION_VERTICAL;
			this._channelBar.gap = 6;
			this._channelBar.selectedIndex = -1;
			this._setTabRender();
			this._setTabBarData();
			this._channelBar.x = 3 ;
			this._channelBar.y = 3 ;
			this.addChild(_channelBar);
		}
		
		private function _setTabRender():void
		{
			this._channelBar.tabFactory = function():Button
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
			this._channelBar.dataProvider = new ListCollection(data);
		}
		
		public function closeMenu():void
		{
			if(this.parent && this != null)
			{
				this._channelBar.removeEventListener(Event.CHANGE, _channelChangeHandler);
				this.removeFromParent(true);
			}
		}
	}
}