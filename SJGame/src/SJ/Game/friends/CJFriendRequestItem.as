package SJ.Game.friends
{
	import SJ.Common.Constants.ConstNPCDialog;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketCommand_friend;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.formation.CJItemTurnPageBase;
	import SJ.Game.lang.CJLang;
	import SJ.Game.utils.SSoundEffectUtil;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.display.Scale3Image;
	
	import flash.text.TextFormat;
	
	import starling.events.Event;

	/**
	 * 申请好友显示单元
	 * @author zhengzheng
	 * 
	 */	
	public class CJFriendRequestItem extends CJItemTurnPageBase
	{
		/**申请加好友描述*/
		private var _description:Label;
		/**查看按钮*/
		private var _btnCheck:Button;
		/**同意按钮*/
		private var _btnAgree:Button;
		/**拒绝按钮*/
		private var _btnReject:Button;
		
		public function CJFriendRequestItem()
		{
			super("CJFriendRequestItem");
		}
		override protected function initialize():void
		{
			_initData();
			_drawContent();
			_addListener();
		}
		/**
		 * 添加按钮监听
		 * 
		 */		
		private function _addListener():void
		{
			this._btnCheck.addEventListener(Event.TRIGGERED , this._btnCheckTriggered);
			this._btnAgree.addEventListener(Event.TRIGGERED , this._btnAgreeTriggered);
			this._btnReject.addEventListener(Event.TRIGGERED , this._btnRejectTriggered);
		}
		
		override public function dispose():void
		{
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_onloadInfo);
			CJFriendUtil.o.dipose();
			super.dispose();
		}
		
		
		/**
		 * 初始化数据
		 */		
		private function _initData():void
		{
			this.width = 295;
			this.height = 34;
			
			_description = new Label();
			_description.x = 12;
			_description.y = 9;
			_description.textRendererProperties.textFormat = new TextFormat( "Arial", 10, 0x53E0D4);
			
			_btnCheck = new Button();
			_btnCheck.x = 140;
			_btnCheck.y = 5;
			_btnCheck.width = 45;
			_btnCheck.defaultLabelProperties.textFormat = new TextFormat( "黑体", 12, 0x000000);
			
			_btnAgree = new Button();
			_btnAgree.x = 195;
			_btnAgree.y = 5;
			_btnAgree.width = 45;
			_btnAgree.defaultLabelProperties.textFormat = new TextFormat( "黑体", 12, 0x000000);
			
			_btnReject = new Button();
			_btnReject.x = 250;
			_btnReject.y = 5;
			_btnReject.width = 45;
			_btnReject.defaultLabelProperties.textFormat = new TextFormat( "黑体", 12, 0x000000);
			
			_btnCheck.label = CJLang("FRIEND_CHECK");
			_btnAgree.label = CJLang("FRIEND_AGREE");
			_btnReject.label = CJLang("FRIEND_REJECT");
			
		}
		/**
		 * 画出单个条目
		 * 
		 */
		private function _drawContent():void
		{
			addChild(_description);
			_btnCheck.defaultSkin = new SImage(SApplication.assets.getTexture("common_tipanniu01"));
			_btnCheck.downSkin = new SImage(SApplication.assets.getTexture("common_tipanniu02"));
			addChild(_btnCheck);
			_btnAgree.defaultSkin = new SImage(SApplication.assets.getTexture("common_tipanniu01"));
			_btnAgree.downSkin = new SImage(SApplication.assets.getTexture("common_tipanniu02"));
			addChild(_btnAgree);
			_btnReject.defaultSkin = new SImage(SApplication.assets.getTexture("common_tipanniu01"));
			_btnReject.downSkin = new SImage(SApplication.assets.getTexture("common_tipanniu02"));
			addChild(_btnReject);
			
			//分割线
			var imgLine:Scale3Image = ConstNPCDialog.genS3ImageWithTextureNameAndRegion("haoyouxitong_xian", 0.5, 1);
			imgLine.x = 10;
			imgLine.y = 33;
			imgLine.width = 290;
			imgLine.height = 1;
			addChild(imgLine);
		}
		override protected function draw():void
		{
			super.draw();
			const isSelectInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			if(isSelectInvalid)
			{
				var roleName:String = data.rolename;
				if (roleName.length > 4)
				{
					roleName = roleName.substring(0, 4) + "...";
				}
				_description.text = roleName + CJLang("FRIEND_REQUEST_ADD_FRIEND");
			}
		}
		
		private function _btnCheckTriggered(e:Event):void
		{
			SSoundEffectUtil.playButtonNormalSound();
			SApplication.moduleManager.exitModule("CJFriendModule");
			SApplication.moduleManager.enterModule("CJHeroPropertyUIModule", {"uid":_data.senduid, "requestid":_data.requestid});
		} 
		/**
		 * 触发同意事件
		 * @param e Event
		 * 
		 */		
		private function _btnAgreeTriggered(e:Event):void
		{
			SSoundEffectUtil.playButtonNormalSound();
			// 添加网络锁
//			SocketLockManager.Lock(ConstNetLockID.CJFriendModule);
			CJFriendUtil.o.responseRetTips();
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,_onloadInfo);
			SocketCommand_friend.responseAddFriend(_data.requestid);
		}
		/**
		 * 触发拒绝事件
		 * @param e Event
		 * 
		 */		
		private function _btnRejectTriggered(e:Event):void
		{
			SSoundEffectUtil.playButtonNormalSound();
			// 添加网络锁
//			SocketLockManager.Lock(ConstNetLockID.CJFriendModule);
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,_onloadInfo);
			SocketCommand_friend.responseDelAddFriend(_data.requestid);
		}
		/**
		 * 加载服务器返回数据 
		 * @param e Event
		 * 
		 */		
		private function _onloadInfo(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if (message.getCommand() == ConstNetCommand.CS_FRIEND_RESPONSE_ADD_FRIEND
				|| message.getCommand() == ConstNetCommand.CS_FRIEND_RESPONSE_DEL_ADD_FRIEND)
			{
				SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_onloadInfo);
				if (message.retcode == 0)
				{
					SocketCommand_friend.getAllRequestsInfo();
				}
			}
		}
	}
}