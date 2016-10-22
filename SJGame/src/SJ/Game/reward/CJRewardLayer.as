package SJ.Game.reward
{
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Common.global.textRender;
	import SJ.Game.SocketServer.SocketCommand_hero;
	import SJ.Game.SocketServer.SocketCommand_item;
	import SJ.Game.SocketServer.SocketCommand_role;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.controls.CJItemUtil;
	import SJ.Game.data.CJDataManager;
	import SJ.Game.event.CJEvent;
	import SJ.Game.lang.CJLang;
	import SJ.Game.task.CJTaskFlowString;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.controls.TabBar;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import starling.events.Event;

	
	/**
	 +------------------------------------------------------------------------------
	 * 发奖面板
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-11-19 下午4:38:39  
	 +------------------------------------------------------------------------------
	 */
	public class CJRewardLayer extends SLayer
	{
		private var _btnClose:Button;
		/*中间的选项卡*/
		private var _screenNavigator:ScreenNavigator;
		/*按钮切换*/
		private var _tabBar:TabBar;
		private var _buttonGet:Button;
		
		private var _rewardList:Array;
		
		public function CJRewardLayer()
		{
			super();
		}
		
		override protected function initialize():void
		{
			this._drawTitle();
			
			this._drawTabBar();
			this._drawScreenNatigator();
			this._drawBottom();
			
			this._addEventListeners()
		}
		
		private function _addEventListeners():void
		{
			this._buttonGet.addEventListener(Event.TRIGGERED , this._getReward);
			this._tabBar.addEventListener(Event.CHANGE, tabs_changeHandler);
			this._btnClose.addEventListener(Event.TRIGGERED , this._closeDialog);
			
			CJDataManager.o.DataOfReward.addEventListener(CJEvent.EVENT_REWARD_CHANGE , this.invalidate);
		}
		
		private function _drawTitle():void
		{
			var bg:Scale9Image = new Scale9Image(new Scale9Textures(SApplication.assets.getTexture('common_erjitanchuang') , new Rectangle(16, 16, 1, 1)));
			bg.width = 408;
			bg.height = 264;
			this.addChild(bg);
			
			var line:ImageLoader = new ImageLoader();
			line.source = SApplication.assets.getTexture('common_fengexian');
			line.x = 10;
			line.y = 30;
			this.addChild(line);
			
			var tf:TextFormat = new TextFormat('黑体' ,  16 , 0xFFEB9B);
			var title:Label = new Label();
			title.textRendererProperties.textFormat = tf;
			title.textRendererFactory = textRender.standardTextRender;
			this.addChild(title);
			title.x = 170;
			title.y = 10 ;
			title.text = CJLang('reward_lingjiang');
			
			_btnClose = new Button();
			_btnClose.defaultSkin = new SImage(SApplication.assets.getTexture("common_guanbianniu01new"));
			_btnClose.downSkin = new SImage(SApplication.assets.getTexture("common_guanbianniu02new"));
			_btnClose.x = 387;
			_btnClose.y = -20;
			_btnClose.name = 'close';
			this.addChild(_btnClose);
		}
		
		override protected function draw():void
		{
			super.draw();
			var rewardList:Array = CJDataManager.o.DataOfReward.validList;
			if(!rewardList || rewardList.length == 0)
			{
				this._tabBar.removeChildren();
				this._screenNavigator.removeAllScreens();
				_buttonGet.visible = false;
				return;
			}
			_buttonGet.visible = true;
			this._setTabBarData(rewardList);
			this._setScreenItem(rewardList);
		}
		
		private function _setScreenItem(rewardList:Array):void
		{
			this._screenNavigator.removeAllScreens();
			var length:int = rewardList.length;
			for(var i:int = 0 ; i < length ; i++)
			{
				var item:ScreenNavigatorItem = new ScreenNavigatorItem(CJRewardScreen , null , {data:rewardList[i], owner:_screenNavigator});
				this._screenNavigator.addScreen(String(i) ,item);
			}
			this._screenNavigator.showScreen(String(0));
		}
		
		private function _drawTabBar():void
		{
			this._tabBar = new TabBar();
			this._tabBar.name = "mainbar";
			this._tabBar.x = 10;
			this._tabBar.y = 40;
			this._tabBar.direction = TabBar.DIRECTION_HORIZONTAL;
			this._tabBar.gap = 3;
			this._setTabRender();
			this.addChild(this._tabBar);
		}
		
		private function _setTabRender():void
		{
			_tabBar.tabFactory = function():Button
			{
				var btn:Button = new Button();
				btn.defaultSkin = new SImage(SApplication.assets.getTexture("qiandao_chayexiang"));
				btn.defaultSelectedSkin = new SImage(SApplication.assets.getTexture("qiandao_chayexiangdianliang"));
				btn.width = 95;
				btn.height = 25;
				var format:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI , 14 , 0xffffff , null , null , null , null , null , TextFormatAlign.CENTER);
				btn.defaultLabelProperties.textFormat = format;
				btn.labelFactory = textRender.htmlTextRender;
				return btn;
			}
		}
		
		private function _setTabBarData(data:Array):void
		{
			if(!data)
			{
				return;
			}
			var length:int = data.length;
			var tempData:Array = new Array();
			for(var i:int = 0 ; i < length ; i++)
			{
				tempData.push({label:data[i]['title'] , name:data[i]['title']})
			}
			this._tabBar.dataProvider = new ListCollection(tempData);
			this._tabBar.selectedIndex = 0;
		}
		
		private function _drawScreenNatigator():void
		{
			this._screenNavigator = new ScreenNavigator();
			this._screenNavigator.x = 14;
			this._screenNavigator.y = 63;
			this.addChildAt( this._screenNavigator , 3);
		}
		
		private function _drawBottom():void
		{
			var format:TextFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI , 14 , 0xBDAB83 , null , null , null , null , null , TextFormatAlign.CENTER);
			_buttonGet = new Button();
			_buttonGet.labelFactory = textRender.htmlTextRender;
			_buttonGet.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniuda01new"));
			_buttonGet.downSkin = new SImage(SApplication.assets.getTexture("common_anniuda02new"));
			_buttonGet.x = 143;
			_buttonGet.y = 225;
			_buttonGet.name = 'getreward';
			_buttonGet.defaultLabelProperties.textFormat = format;
			_buttonGet.label = CJLang("reward_lingqu");
			this.addChild(_buttonGet);
		}
		
		private function _closeDialog(e:Event):void
		{
			if((e.target as Button).name != "close")
			{
				return;
			}
			this._buttonGet.removeEventListener(Event.TRIGGERED , this._getReward);
			this._tabBar.removeEventListener(Event.CHANGE, tabs_changeHandler);
			SApplication.moduleManager.exitModule(CJRewardModule.MOUDLE_NAME);
		}
		
		private function _getReward(e:Event):void
		{
			if(e.target is Button && (e.target as Button).name == "getreward")
			{
				var screen:CJRewardScreen = this._screenNavigator.activeScreen as CJRewardScreen;
				if(!CJItemUtil.canPutItemInBag(CJDataManager.o.DataOfBag , screen.data['awarditem'] , 1))
				{
					new CJTaskFlowString(CJLang('FUBEN_GUANKAPASS_AWARD')).addToLayer();
					return;
				}
				
				SocketManager.o.callwithRtn(ConstNetCommand.CS_REWARD_GETREWARD , function(e:SocketMessage):void
				{
					if(e.retcode == 1)
					{
						new CJTaskFlowString(CJLang('reward_gongxihuode')+screen.text).addToLayer();
						SocketCommand_item.getBag();
						//后续又要发钱。SHIT。
						SocketCommand_hero.get_heros();
						SocketCommand_role.get_role_info();
					}
					else
					{
						new CJTaskFlowString(CJLang('reward_lingqushibai')).addToLayer();
					}
				}
					, false ,screen.id
				);
			}
		}
		
		private function tabs_changeHandler(e:Event):void
		{
			if(e.target is TabBar && (e.target as TabBar).name == "mainbar")
			{
				var tabs:TabBar = e.currentTarget as TabBar;
				var selectedIndex:int = tabs.selectedIndex;
				if(!this._screenNavigator.hasScreen(String(selectedIndex)))
				{
					return;
				}
				this._screenNavigator.showScreen(String(selectedIndex));
			}
		}
		
		
		override public function dispose():void
		{
			super.dispose();
			this._btnClose.removeEventListener(Event.TRIGGERED , this._closeDialog);
		}
	}
}