package SJ.Game.friends
{
	import SJ.Common.Constants.ConstMainUI;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketCommand_role;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.data.config.CJDataHeroProperty;
	import SJ.Game.data.config.CJDataOfHeroPropertyList;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.lang.CJLang;
	import SJ.Game.utils.SSoundEffectUtil;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import starling.events.Event;
	import starling.textures.Texture;

	/**
	 * 点击玩家弹出框
	 * @author zhengzheng
	 * 
	 */	
	public class CJFriendClickPlayerDialog extends SLayer
	{
		/**玩家名字*/
		private var _labname:Label;
//		/**玩家等级*/
//		private var _lablevel:Label;
		/**玩家等级*/
		private var _labVipLevel:Label;
		/**玩家战斗力*/
		private var _labBattlePower:Label;
		/**头像按钮*/
		private var _btnHead:Button;
		/**玩家的用户id*/
		private var _playerUid:String;
		/**玩家信息*/
		private var _playerInfo:Object;
		
		
		public function CJFriendClickPlayerDialog(playerUid:String)
		{
			super();
			_playerUid = playerUid;
			this.setSize(152, 63);
			//添加数据到达监听 
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,_onloadRoleInfo);
			// 添加网络锁
			//			SocketLockManager.KeyLock(ConstNetCommand.CS_ROLE_GET_OTHER_ROLE_INFO);
			SocketCommand_role.get_other_role_info(_playerUid);
		}
		
		override public function dispose():void
		{
			super.dispose();
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_onloadRoleInfo);
			CJEventDispatcher.o.removeEventListener(ConstMainUI.MAIN_UI_CLICK_PLAYER_DISAPPEAR, _closePlayerDialog);
			
		}
		
		
		
		/**
		 * 加载服务器返回数据 
		 * @param e Event
		 * 
		 */		
		private function _onloadRoleInfo(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if (message.getCommand() != ConstNetCommand.CS_ROLE_GET_OTHER_ROLE_INFO)
				return;
			// 去除网络锁
			//			SocketLockManager.KeyUnLock(ConstNetCommand.CS_ROLE_GET_OTHER_ROLE_INFO);
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_onloadRoleInfo);
			if (message.retcode == 0)
			{
				_playerInfo = message.retparams;
				if (_playerInfo)
				{
					_initialize();
				}
			}
		}
		private function _initialize():void
		{
			_drawContent();
			_addListener();
		}
		
		/**
		 * 初始化基本数据
		 */		
		private function _drawContent():void
		{
			//背景
			var imgBg:ImageLoader = new ImageLoader();
			imgBg.source = SApplication.assets.getTexture("zhujiemian_mubiaowanjiadi");
			imgBg.width = 152;
			imgBg.height = 63;
			this.addChild(imgBg);
			
			var textFormat:TextFormat;
			textFormat = new TextFormat( "Arial", 10, 0xE1C97F,null,null,null,null,null, TextFormatAlign.CENTER);
			_labname = new Label();
			_labname.x = 57;
			_labname.y = 2;
			_labname.width = 60;
			_labname.textRendererProperties.textFormat = textFormat;
			if (_playerInfo.rolename.length > 5)
			{
				_labname.text = _playerInfo.rolename.substr(0, 5) + "...";
			}
			else
			{
				_labname.text = _playerInfo.rolename;
			}
			this.addChild(_labname);
//			_lablevel = new Label();
//			_lablevel.x = 100;
//			_lablevel.y = 2;
//			_lablevel.textRendererProperties.textFormat = textFormat;
			
			_labVipLevel = new Label();
			_labVipLevel.x = 16;
			_labVipLevel.y = 51;
			_labVipLevel.width = 30;
			textFormat = new TextFormat( "Arial", 7, 0xFFEA00,null,null,null,null,null, TextFormatAlign.CENTER);
			_labVipLevel.textRendererProperties.textFormat = textFormat;
			_labVipLevel.text = "VIP " + _playerInfo.viplevel
			this.addChild(_labVipLevel);
			
			_labBattlePower = new Label();
			_labBattlePower.x = 58;
			_labBattlePower.y = 19;
			_labBattlePower.width = 66;
			textFormat = new TextFormat( "Arial", 10, 0xFDFFCA,null,null,null,null,null, TextFormatAlign.CENTER);
			_labBattlePower.textRendererProperties.textFormat = textFormat;
			_labBattlePower.text = CJLang("FRIEND_BATTLE_POWER").replace("{battleeffect}", _playerInfo.battleeffectsum);
			this.addChild(_labBattlePower);
			
			_btnHead = new Button();
			_btnHead.x = -15;
			_btnHead.y = -26;
			_btnHead.width = 90;
			_btnHead.height = 90;
			var heroTmpl:CJDataHeroProperty = CJDataOfHeroPropertyList.o.getProperty(_playerInfo.templateid);
			var texture:Texture = SApplication.assets.getTexture(heroTmpl.headicon);
			if (texture)
			{
				_btnHead.defaultSkin = new SImage(texture);
			}
			this.addChild(_btnHead);
			
		}
		
		
		/**
		 * 为控件添加监听 
		 * 
		 */	
		private function _addListener():void
		{
			_btnHead.addEventListener(Event.TRIGGERED , this._btnCheckTriggered);
			//添加点击其他玩家弹出框
			CJEventDispatcher.o.addEventListener(ConstMainUI.MAIN_UI_CLICK_PLAYER_DISAPPEAR, _closePlayerDialog);
		}
		/**
		 * 关闭点击玩家的弹窗
		 * @param e
		 * 
		 */		
		private function _closePlayerDialog(e:Event):void
		{
			if(e.type != ConstMainUI.MAIN_UI_CLICK_PLAYER_DISAPPEAR)
			{
				return;
			}
			if (e.data)
			{
				var clickedPlayerUid:String = String(e.data.clickedPlayerUid);
				if (this && _playerInfo && clickedPlayerUid == _playerInfo.userid)
				{
					btnCloseTriggered(e);
				}
			}
		}
		/**
		 * 触发查看事件
		 * @param e Event
		 * 
		 */		
		private function _btnCheckTriggered(e:Event):void
		{
			SSoundEffectUtil.playTipSound();
			SApplication.moduleManager.enterModule("CJHeroPropertyUIModule", {"uid":_playerUid});
		}
		/**
		 * 触发关闭事件
		 * @param e Event
		 * 
		 */		
		public function btnCloseTriggered(e:Event):void
		{
			this.removeFromParent(true);
			ConstMainUI.oldClickPlayerUid = null;
		}
	}
}