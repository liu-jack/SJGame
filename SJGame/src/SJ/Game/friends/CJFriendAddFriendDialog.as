package SJ.Game.friends
{
	import SJ.Common.Constants.ConstCreateRole;
	import SJ.Common.Constants.ConstNPCDialog;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketCommand_friend;
	import SJ.Game.SocketServer.SocketCommand_role;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.controls.CJFlyWordsUtil;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.lang.CJLang;
	import SJ.Game.utils.SSoundEffectUtil;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	import engine_starling.utils.SStringUtils;
	
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.controls.TextInput;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	/**
	 * 添加好友对话框
	 * @author zhengzheng
	 * 
	 */	
	public class CJFriendAddFriendDialog extends SLayer
	{
		//输入框
		private var _tiPlayerName:TextInput;
//		//关闭按钮
//		private var _btnClose:Button;
		//确定按钮
		private var _btnConfirm:Button;
		//取消按钮
		private var _btnCancel:Button;
		/**可点击背景*/
		private var _quad:Quad;
		public function CJFriendAddFriendDialog()
		{
			super();
			this.setSize(188, 133);
		}
		
		override protected function initialize():void
		{
			super.initialize();
			_drawContent();
			_addListener();
		}
		
		/**
		 * 绘制界面内容
		 */	
		private function _drawContent():void
		{
			var texture:Texture;
			var texture9:Scale9Textures;
			var fontFormat:TextFormat;
			
			_quad = new Quad(SApplicationConfig.o.stageWidth, SApplicationConfig.o.stageHeight);
			_quad.alpha = 0;
			_quad.x = (this.width - SApplicationConfig.o.stageWidth) / 2;
			_quad.y = (this.height - SApplicationConfig.o.stageHeight) / 2;
			this.addChild(_quad);
			
			//	 整体外框
			var imgFrame:Scale9Image = ConstNPCDialog.genS9ImageWithTextureNameAndRect("common_tishikuang", 15.8, 15.5,1,1);
			imgFrame.width = 176;
			imgFrame.height = 123;
			this.addChild(imgFrame);
			
			var labDes:Label= new Label;
			fontFormat = new TextFormat( "Arial", 10, 0xFFFFFF,null,null,null,null,null,TextFormatAlign.CENTER);
			labDes.textRendererProperties.textFormat = fontFormat;
			labDes.x = 18;
			labDes.y = 34;
			labDes.width = 131;
			labDes.text = CJLang("FRIEND_INPUT_NAME_TO_ADD");
			this.addChild(labDes);
			
			//输入框
			_tiPlayerName = new TextInput();
			texture = SApplication.assets.getTexture("common_tiptankuang");
			texture9 = new Scale9Textures(texture,new Rectangle(4,4,4,4));
			var imgInput:Scale9Image = new Scale9Image(texture9);
			imgInput.width = 131;
			imgInput.height = 21;
			_tiPlayerName.backgroundSkin = imgInput;
			_tiPlayerName.x = 23;
			_tiPlayerName.y = 56;
			_tiPlayerName.width = 131;
			_tiPlayerName.height = 20;
			_tiPlayerName.textEditorProperties.maxChars = ConstCreateRole.ConstMaxRoleNameCount;
			_tiPlayerName.textEditorProperties.fontSize = 10;
			_tiPlayerName.textEditorProperties.fontFamily = "宋体";
			_tiPlayerName.textEditorProperties.color = 0xFFFFFFFF;
			_tiPlayerName.paddingLeft = 20;
			_tiPlayerName.paddingTop = 3.5;
			this.addChild(_tiPlayerName);
			
			//查找图片
			var imgSearch:ImageLoader = new ImageLoader();
			imgSearch.source = SApplication.assets.getTexture("haoyou_chazhao");
			imgSearch.x = 27;
			imgSearch.y = 58;
			imgSearch.width = 17;
			imgSearch.height = 17;
			this.addChild(imgSearch);
			
//			_btnClose = new Button();
//			_btnClose.defaultSkin = new SImage( SApplication.assets.getTexture("common_guanbianniu01new"));
//			_btnClose.downSkin = new SImage( SApplication.assets.getTexture("common_guanbianniu02new"));
//			_btnClose.x = 157;
//			_btnClose.y = -13;
//			_btnClose.width = 36;
//			_btnClose.height = 35;
//			this.addChild(_btnClose);
			
			fontFormat = new TextFormat( "黑体", 12, 0xB7A077);
			//确定按钮
			_btnConfirm = new Button();
			_btnConfirm.defaultSkin = new SImage( SApplication.assets.getTexture("common_anniu01new"));
			_btnConfirm.downSkin = new SImage( SApplication.assets.getTexture("common_anniu02new"));
			_btnConfirm.defaultLabelProperties.textFormat = fontFormat;
			_btnConfirm.label = CJLang("FRIEND_ADD");
			_btnConfirm.x = 23;
			_btnConfirm.y = 86;
			_btnConfirm.width = 53;
			_btnConfirm.height = 28;
			this.addChild(_btnConfirm);
			//取消按钮
			_btnCancel = new Button();
			_btnCancel.defaultSkin = new SImage( SApplication.assets.getTexture("common_anniu01new"));
			_btnCancel.downSkin = new SImage( SApplication.assets.getTexture("common_anniu02new"));
			_btnCancel.defaultLabelProperties.textFormat = fontFormat;
			_btnCancel.label = CJLang("COMMON_CANCEL");
			_btnCancel.defaultLabelProperties.textFormat = fontFormat;
			_btnCancel.x = 99;
			_btnCancel.y = _btnConfirm.y;
			_btnCancel.width = 53;
			_btnCancel.height = 28;
			this.addChild(_btnCancel);
			
		}
		/**
		 * 为控件添加监听 
		 * 
		 */	
		private function _addListener():void
		{
			_quad.addEventListener(TouchEvent.TOUCH, _onClickQuad);
//			_btnClose.addEventListener(Event.TRIGGERED , this._btnCloseTriggered);
			_btnConfirm.addEventListener(Event.TRIGGERED , this._btnConfirmTriggered);
			_btnCancel.addEventListener(Event.TRIGGERED , this._btnCancelTriggered);
			//添加数据到达监听 
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,_onloadInfo);
		}
		
		override public function dispose():void
		{
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_onloadInfo);
			CJFriendUtil.o.dipose();
			super.dispose();
		}
		
		
		/**
		 * 触发关闭事件
		 * @param e
		 * 
		 */		
		private function _onClickQuad(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this,TouchPhase.ENDED);
			if (!touch)
			{
				return;	
			}
			this.removeFromParent(true);
		}
//		/**
//		 * 触发关闭事件
//		 * 
//		 */		
//		private function _btnCloseTriggered():void
//		{
//			this.removeFromParent(true);
//		}
		/**
		 * 触发确定事件
		 * 
		 */
		private function _btnConfirmTriggered():void
		{
			SSoundEffectUtil.playButtonNormalSound();
			var name:String = _tiPlayerName.text;
			if (SStringUtils.isEmpty(name))
			{
				CJFlyWordsUtil(CJLang("FRIEND_INPUT_NAME_TO_ADD"));
			}
			else
			{
				SocketCommand_role.get_other_role_info_by_name(_tiPlayerName.text);
			}
		}
		/**
		 * 触发取消事件
		 * 
		 */
		private function _btnCancelTriggered():void
		{
			SSoundEffectUtil.playButtonNormalSound();
			this.removeFromParent(true);
		}
		/**
		 * 加载服务器返回数据 
		 * @param e Event
		 * 
		 */		
		private function _onloadInfo(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if (message.getCommand() == ConstNetCommand.CS_ROLE_GET_OTHER_ROLE_INFO_BY_NAME)
			{
				if (message.retcode == 0)
				{
					var retParams:Object = message.retparams;
					CJFriendUtil.o.requestRetTips();
//					SocketCommand_friend.requestAddFriend(retParams.userid);
					SocketManager.o.callwithRtn(ConstNetCommand.CS_FRIEND_REQUEST_ADD_FRIEND, _onGetInfo,false, retParams.userid);
				}
				else if (message.retcode == 1)
				{
					CJFlyWordsUtil(CJLang("FRIEND_NOT_FIND_PLAYER"));
				}
			}
		}
		
		private function _onGetInfo(message:SocketMessage):void
		{
			this.removeFromParent(true);
		}
	}
}