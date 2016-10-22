package SJ.Game.rank
{
	import SJ.Common.Constants.ConstRank;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Common.global.textRender;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.lang.CJLang;
	import SJ.Game.utils.SSoundEffectUtil;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.utils.Logger;
	
	import feathers.controls.Button;
	import feathers.controls.TabBar;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import starling.events.Event;
	
	/**
	 * 点击排行榜单元弹出的菜单
	 * @author zhengzheng
	 * 
	 */	
	public class CJRankItemClickMenu extends TabBar
	{
		/*弹出menu上的名字*/
		public const NAME_BUTTON_LIST:Array = ["CHECK" ,  "PRIVATE_CHAT" , "FRIEND"]; 
		/*弹出menu*/
		private var _nameBar:TabBar;
		/*关闭按钮*/
		private var _btnClose:Button;
		
		public function CJRankItemClickMenu()
		{
//			ConstRank.RANK_TYPE = typeRankList;
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
			SSoundEffectUtil.playButtonNormalSound();
			if(e.target is TabBar && (e.target as TabBar).name == "namebar")
			{
				var tabs:TabBar = e.currentTarget as TabBar;
				var selectedIndex:int = tabs.selectedIndex;
				if(selectedIndex == -1)
				{
					return;
				}
				CJEventDispatcher.o.dispatchEventWith(("rankItemMenuClicked" + ConstRank.RANK_TYPE) , false , {"menu":tabs.selectedItem.name});
			}
		}
		
		private function _drawContent():void
		{
			var bg:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture("common_tankuangdi2") , new Rectangle(4 , 4 , 1, 1)));
			bg.width = 81;
			bg.height = 106;
			this.addChild(bg);
			
			this._nameBar = new TabBar();
			this._nameBar.name = "namebar";
			this._nameBar.direction = TabBar.DIRECTION_VERTICAL;
			this._nameBar.gap = 8;
			this._nameBar.selectedIndex = -1;
			this._setTabRender();
			this._setTabBarData();
			this._nameBar.x = 15 ;
			this._nameBar.y = 11 ;
			this.addChild(_nameBar);
			
			_btnClose = new Button();
			_btnClose.defaultSkin = new SImage(SApplication.assets.getTexture("common_tipguanbianniu01"));
			_btnClose.downSkin = new SImage(SApplication.assets.getTexture("common_tipguanbianniu02"));
			_btnClose.x = 71;
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
				btn.downSkin = new SImage(SApplication.assets.getTexture("common_tipanniu02"));
				btn.width = 52;
				btn.height = 23;
				var format:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI , 12 , 0x000000 , null , null , null , null , null , TextFormatAlign.CENTER);
				btn.defaultLabelProperties.textFormat = format;
				btn.labelFactory = textRender.convolutionTextRender;
				return btn;
			}
		}
		
		private function _setTabBarData():void
		{
			var data:Array = new Array();
			for(var i:String in NAME_BUTTON_LIST)
			{
				data.push({label : CJLang("RANK_"+NAME_BUTTON_LIST[i]) , name:NAME_BUTTON_LIST[i]});
			}
			this._nameBar.dataProvider = new ListCollection(data);
		}
		
		private function _closeDialog(e:Event):void
		{
			SSoundEffectUtil.playButtonNormalSound();
			if((e.target as Button).name != "close")
			{
				return;
			}
			this.closeMenu();
		}
		/**
		 * 关闭菜单
		 * 
		 */		
		public function closeMenu():void
		{
			if(this.parent && this != null)
			{
				if(this._nameBar)
				{
					this._nameBar.removeEventListener(Event.CHANGE, _channelChangeHandler);
				}
				this.removeFromParent(true);
			}
		}
	}
}