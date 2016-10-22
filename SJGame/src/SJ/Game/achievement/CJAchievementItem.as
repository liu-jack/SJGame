package SJ.Game.achievement
{
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Common.global.textRender;
	import SJ.Game.SocketServer.SocketCommand_item;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.controls.CJItemUtil;
	import SJ.Game.data.config.CJDataOfItemPackageProperty;
	import SJ.Game.data.config.CJDataOfItemProperty;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.formation.CJItemTurnPageBase;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJMessageBox;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	
	import starling.events.Event;
	
	/**
	 * 里程碑单元
	 * @author changmiao
	 * 
	 */	
	public class CJAchievementItem extends CJItemTurnPageBase
	{
		private var _title:Label;
		private var _state0Img: SImage;
		private var _state2Img: SImage;
		private var _getButton:Button;
		
		private var _icons:Array = new Array();
		private var _iconBgs:Array = new Array();
		public function CJAchievementItem()
		{
			super("CJAchievementItem");
		}
		override protected function initialize():void
		{
			this.width = 418;
			this.height = 67;
			
			for(var i:int = 0; i < 4; i++)
			{
				var iconBg: SImage = new SImage(SApplication.assets.getTexture("achi_bg"));
				iconBg.x = 122 + 51 * i;
				iconBg.y = 11;
				iconBg.scaleX = 0.75;
				iconBg.scaleY = 0.75;
				iconBg.visible = false;
				this.addChild(iconBg);
				_iconBgs.push(iconBg);
			}
			
			var line: SImage = new SImage(SApplication.assets.getTexture("zhuzhanhaoyou_fengexian"));
			line.x = 0;
			line.y = 67;
			line.scaleY = 8.9;
			line.rotation = Math.PI * 1.5;	
			this.addChild(line);
			
			_title = new Label();
			_title.text = "";
			_title.width = 115;
			_title.height = 30;
			_title.x = 5;
			_title.y = (67 - _title.height) / 2 - 2;
			_title.textRendererFactory = textRender.glowTextRender;
			_title.textRendererProperties.textFormat = new TextFormat(ConstTextFormat.FONT_FAMILY_HEITI, 11, 0xE5DB8E);
			_title.textRendererProperties.wordWrap = true;	
			this.addChild(_title);
			
			_state0Img = new SImage(SApplication.assets.getTexture("jinxingzhongtushi"));
			_state0Img.x = 327;
			_state0Img.y = 7;
			_state0Img.visible = false;
			this.addChild(_state0Img);
			
			_state2Img = new SImage(SApplication.assets.getTexture("yiwanchengtushi"));
			_state2Img.x = 327;
			_state2Img.y = 7;
			_state2Img.visible = false;
			this.addChild(_state2Img);
			
			_getButton = new Button();
			_getButton.x = 322;
			_getButton.y = 17;
			_getButton.width = 80;
			_getButton.height = 30;
			_getButton.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniu01new"));
			_getButton.downSkin = new SImage(SApplication.assets.getTexture("common_anniu02new"));
			_getButton.defaultLabelProperties.textFormat =  new TextFormat( ConstTextFormat.FONT_FAMILY_HEITI, 13, 0xE5DB8E,null,null,null,null,null, TextFormatAlign.CENTER);
			_getButton.label = CJLang("ACHI_BTN_GET");
			_getButton.visible = false;
			this.addChild(_getButton);
			_getButton.addEventListener(starling.events.Event.TRIGGERED, _onGetClick);
	
		}
		
		private function _onGetClick(e:Event):void
		{
			SocketManager.o.callwithRtn(ConstNetCommand.CS_ACHIEVEMENT_GETREWARD , _onGetReward, false, data.achiid);
		}
		
		private function _onGetReward(message:SocketMessage):void
		{
			switch (message.retcode)
			{
				case 0:
				{
					CJMessageBox(CJLang("ACHI_GETREWARD_TIP_0"));
					SocketCommand_item.getBag();
					CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_ACHIEVEMENT_STATE_CHANGE ,false , data.achiid);
					break;
				}
				case 1:
				{
					CJMessageBox(CJLang("ACHI_GETREWARD_TIP_1"));
					break;
				}
				case 2:
				{
					CJMessageBox(CJLang("ACHI_GETREWARD_TIP_2"));
					break;
				}
				case 3:
				{
					CJMessageBox(CJLang("ACHI_GETREWARD_TIP_3"));
					break;
				}
				case 4:
				{
					CJMessageBox(CJLang("ACHI_GETREWARD_TIP_4"));
					break;
				}				
			}
		}
		
		override protected function draw():void
		{
			super.draw();
			const isSelectInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			if(isSelectInvalid)
			{
				var itemArr:Array;
				var packageTemplateProperty:CJDataOfItemPackageProperty = CJDataOfItemPackageProperty.o;
				itemArr = packageTemplateProperty.getPackageConfig(data.giftId);
				
				var count:int = _icons.length;
				for(var i:int = 0; i < count; i++)
				{
					(_icons[i] as Button).removeFromParent(true);
				}
				_icons = [];
				for(i = 0; i < 4; i++)
				{
					SImage(_iconBgs[i]).visible = true;
					if(i >= itemArr.length)
					{
						SImage(_iconBgs[i]).visible = false;
						continue;
					}
					var imgName:String = CJDataOfItemProperty.o.getTemplate(itemArr[i].itemid).picture;	
					var icon: Button = new Button();
					icon.defaultSkin = new SImage(SApplication.assets.getTexture(imgName));
					icon.x = 126 + 51 * i;
					icon.y = 15;
					icon.name = itemArr[i].itemid;
					icon.scaleX = 0.75;
					icon.scaleY = 0.75;
					icon.addEventListener(Event.TRIGGERED, _showGiftItem);
					this.addChild(icon);
					_icons.push(icon);
				}
				_title.text = data.title;
				if(data.type == 1)
				{
					_title.height = 14;
					_title.y = (67 - _title.height) / 2 - 2;
				}
				else if(data.type == 2)
				{
					_title.height = 30;
					_title.y = (67 - _title.height) / 2 - 2;
				}
				
				switch(data.state)
				{
					case 0:
					{
						_state0Img.visible = true;
						_state2Img.visible = false;
						_getButton.visible = false;
						break;
					}
					case 1:
					{
						_state0Img.visible = false;
						_state2Img.visible = false;
						_getButton.visible = true;
						break;
					}
					case 2:
					{
						_state0Img.visible = false;
						_state2Img.visible = true;
						_getButton.visible = false;
						break;
					}
				}
			}
		}
		
		private function _showGiftItem(e:Event):void
		{
			var item:Button = e.currentTarget as Button;
			if(item.name != "")CJItemUtil.showItemTooltipsWithTemplateId(parseInt(item.name));
		}
		
		override public function dispose():void
		{

			super.dispose();
		}
	}
}
