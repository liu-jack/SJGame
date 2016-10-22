package SJ.Game.dynamics
{
	
	import SJ.Common.Constants.ConstDynamic;
	import SJ.Common.Constants.ConstNPCDialog;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstNetLockID;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.SocketServer.SocketCommand_fuben;
	import SJ.Game.SocketServer.SocketCommand_role;
	import SJ.Game.SocketServer.SocketLockManager;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.data.config.CJDataOfGlobalConfigProperty;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.lang.CJLang;
	import SJ.Game.utils.SSoundEffectUtil;
	
	import engine_starling.SApplication;
	import engine_starling.SApplicationConfig;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.display.Scale9Image;
	
	import flash.text.TextFormat;
	
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * 刷新助战好友确认框
	 * @author zhengzheng
	 * 
	 */	
	public class CJRefreshAssistantDialog extends SLayer
	{
		/**描述内容 */
		private var _labDesc:Label;
		/**元宝数量 */
		private var _labGoldNum:Label;
		/**元宝图标*/
		private var _imgGold:SImage;
//		/**关闭按钮*/
//		private var _btnClose:Button;
		/**确定按钮*/
		private var _btnConfirm:Button;
		/**取消按钮*/
		private var _btnCancel:Button;
		/**可点击背景*/
		private var _quad:Quad;
		public function CJRefreshAssistantDialog()
		{
			super();
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
			this.width = 188;
			this.height = 133;
			//	 整体外框
			var imgFrame:Scale9Image = ConstNPCDialog.genS9ImageWithTextureNameAndRect("common_tishikuang", 15.8, 15.5,1,1);
			imgFrame.width = this.width - 14;
			imgFrame.height = this.height - 12;
			imgFrame.y = 11;
//			imgFrame.alpha = 0.8;
			this.addChild(imgFrame);
			
			
			_labDesc = new Label();
			_labDesc.x = 28;
			_labDesc.y = 50;
			_labDesc.text = CJLang("DYNAMIC_USE_OR_NOT") + "             " + CJLang("DYNAMIC_REFRESH") + "?";
			this.addChild(_labDesc);
			
			_labGoldNum = new Label();
			_labGoldNum.x = 91;
			_labGoldNum.y = 50;
			_labGoldNum.text = CJDataOfGlobalConfigProperty.o.getData("DYNAMIC_REFRESH_COST_GOLD");
			this.addChild(_labGoldNum);
			
			_imgGold = new SImage(SApplication.assets.getTexture("common_yuanbao"));
			_imgGold.x = 103;
			_imgGold.y = 53;
			this.addChild(_imgGold);
			
//			this._btnClose = new Button();
//			this._btnClose.defaultSkin = new SImage(SApplication.assets.getTexture("common_guanbianniu01new"));
//			this._btnClose.downSkin = new SImage(SApplication.assets.getTexture("common_guanbianniu02new"));
//			this._btnClose.width = 30;
//			this._btnClose.height = 30;
//			this._btnClose.x = 159;
//			this._btnClose.y = -1;
//			this.addChild(_btnClose);
			
			//确定按钮
			_btnConfirm = new Button();
			_btnConfirm.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniu01new"));
			_btnConfirm.downSkin = new SImage(SApplication.assets.getTexture("common_anniu02new"));
			_btnConfirm.x = 26;
			_btnConfirm.y = 88;
			_btnConfirm.width = 53;
			_btnConfirm.height = 28;
			_btnConfirm.labelOffsetY = -1;
			this.addChild(_btnConfirm);
			//取消按钮
			_btnCancel = new Button();
			_btnCancel.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniu01new"));
			_btnCancel.downSkin = new SImage(SApplication.assets.getTexture("common_anniu02new"));
			_btnCancel.x = 98;
			_btnCancel.y = 88;
			_btnCancel.width = 53;
			_btnCancel.height = 28;
			_btnCancel.labelOffsetY = -1;
			this.addChild(_btnCancel);
			
			_quad = new Quad(SApplicationConfig.o.stageWidth, SApplicationConfig.o.stageHeight);
			_quad.alpha = 0;
			_quad.x = (this.width - SApplicationConfig.o.stageWidth) / 2;
			_quad.y = (this.height - SApplicationConfig.o.stageHeight) / 2;
			this.addChildAt(_quad, 0);
			_setTextFormat();
		}
		/**
		 * 
		 * 设置文本格式
		 */		
		private function _setTextFormat():void
		{
			var fontFormat:TextFormat = new TextFormat( "黑体", 12, 0xC7B88F);
			_btnConfirm.defaultLabelProperties.textFormat = fontFormat;
			_btnConfirm.label = CJLang("DYNAMIC_CONFIRM");
			
			_btnCancel.defaultLabelProperties.textFormat = fontFormat;
			_btnCancel.label = CJLang("DYNAMIC_CANCEL");
			
			_labDesc.textRendererProperties.textFormat = ConstTextFormat.textformatwhitecenter;
			
			fontFormat = new TextFormat( "黑体", 10, 0xFEFE02);
			_labGoldNum.textRendererProperties.textFormat = fontFormat;
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
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,_onloadRefreshInfo);
		}
		
		private function _onloadRefreshInfo(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage
			if(message.getCommand() == ConstNetCommand.CS_FUBEN_FLUSH_INVITE_HEROS)
			{
				if (message.retcode == 0)
				{
					SocketCommand_role.get_role_info();
					this.removeFromParent(true);
				}
			}
		}
		
		override public function dispose():void
		{
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_onloadRefreshInfo);
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
		/**
		 * 触发确定事件
		 * 
		 */
		private function _btnConfirmTriggered():void
		{
			SSoundEffectUtil.playButtonNormalSound();
			SocketCommand_fuben.flushInviteHeros();
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
		
	}
}