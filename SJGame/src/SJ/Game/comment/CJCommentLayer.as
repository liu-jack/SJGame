package SJ.Game.comment
{
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import SJ.Common.Constants.ConstComment;
	import SJ.Common.Constants.ConstGlobal;
	import SJ.Common.Constants.ConstNPCDialog;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstResource;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Common.global.textRender;
	import SJ.Game.SocketServer.SocketCommand_comment;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.controls.CJFlyWordsUtil;
	import SJ.Game.data.config.CJDataOfGlobalConfigProperty;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.lang.CJLang;
	import SJ.Game.utils.SSoundEffectUtil;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	import engine_starling.utils.AssetManagerUtil;
	import engine_starling.utils.SManufacturerUtils;
	import engine_starling.utils.SStringUtils;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.display.Scale9Image;
	
	import starling.events.Event;

	/**
	 * 评论活动层
	 * @author zhengzheng
	 * 
	 */	
	public class CJCommentLayer extends SLayer
	{
		/**背景图*/
		private var _imgBg:Scale9Image;
		/**标题*/
		private var _labTitle:Label;
		/**描述*/
		private var _labDesc:Label;
		/**评论按钮 */
		private var _btnComment:Button;
		/**关闭按钮 */
		private var _btnClose:Button;
		/**赠送元宝个数*/
		private var _awardGold:int;
		/**评论链接地址*/
		private var _commentUrl:String;
		/**评论返回值-成功*/
		private static const COMMENT_RET_SUCCESS:int  = 0;
		/**评论返回值-失败*/
		private static const COMMENT_RET_FAIL:int  = 1;
		

		public function CJCommentLayer()
		{
			super();
		}
		
		override protected function initialize():void
		{
			_initData();
			_drawContent();
			_addListener();
		}
		/**
		 * 初始化数据
		 */		
		private function _initData():void
		{
			this.width = 203;
			this.height = 141;
			
			_awardGold = int(CJDataOfGlobalConfigProperty.o.getData("COMMENT_AWARD_GOLD_COUNT"));
			var commentConfigList:Array = AssetManagerUtil.o.getObject(ConstResource.sResJsonCommentUrl) as Array;
			var currentChannel:String = String(ConstGlobal.CHANNEL);
			//评论配置为空，或者评论配置不包含当前渠道
			if(commentConfigList == null || !commentConfigList.hasOwnProperty(currentChannel))
			{
				return;
			}
//			当前设备型号
			var manufactory:String = SManufacturerUtils.getManufacturerType();
			if(manufactory == SManufacturerUtils.TYPE_ANDROID)
			{
				_commentUrl = commentConfigList[currentChannel].commenturlandroid;
			}
			else if(manufactory == SManufacturerUtils.TYPE_IOS)
			{
				_commentUrl = commentConfigList[currentChannel].commenturlios;
			}
			else
			{
				_commentUrl = null;
			}
		}
		
		
		/**
		 * 绘制内容
		 */		
		private function _drawContent():void
		{
			_imgBg = ConstNPCDialog.genS9ImageWithTextureNameAndRect("common_tishikuang", 15.8, 15.5,1,1);
			_imgBg.width = this.width - 14;
			_imgBg.height = this.height - 12;
			_imgBg.y = 11;
			this.addChild(_imgBg);
			
			var fontFormat:TextFormat = new TextFormat( "Arial", 12, 0xFF0000, null,null,null,null,null, TextFormatAlign.CENTER);
			
			_labTitle = new Label();
			_labTitle.x = 13;
			_labTitle.y = 25;
			_labTitle.width = this.width - 38;
			_labTitle.textRendererProperties.textFormat = fontFormat;
			_labTitle.text = CJLang("COMMENT_TITLE");
			this.addChild(_labTitle);
			
			_labDesc = new Label();
			_labDesc.x = 13;
			_labDesc.y = 47;
			_labDesc.width = this.width - 38;
			_labDesc.textRendererProperties.textFormat = ConstTextFormat.textformatheitiwhite;
			_labDesc.textRendererProperties.wordWrap = true;
			_labDesc.textRendererFactory = textRender.htmlTextRender;
			_labDesc.text = CJLang("COMMENT_DESC", {"gold":_awardGold});
			this.addChild(_labDesc);
			
			_btnComment = new Button();
			_btnComment.x = 55;
			_btnComment.y = 90;
			_btnComment.width = 67;
			_btnComment.height = 28;
			_btnComment.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniu01new"));
			_btnComment.downSkin = new SImage(SApplication.assets.getTexture("common_anniu02new"));
			_btnComment.defaultLabelProperties.textFormat = ConstTextFormat.textformatkhakisize11;
			_btnComment.label = CJLang("COMMENT_GOTO_COMMENT");
			this.addChild(_btnComment);
			
			_btnClose = new Button();
			_btnClose.x = 166;
			_btnClose.y = -6;
			_btnClose.width = 46;
			_btnClose.height = 45;
			_btnClose.defaultSkin = new SImage(SApplication.assets.getTexture("common_guanbianniu01new"));
			_btnClose.downSkin = new SImage(SApplication.assets.getTexture("common_guanbianniu02new"));
			this.addChild(_btnClose);
		}
		
		/**
		 * 添加监听
		 */		
		private function _addListener():void
		{
			_btnComment.addEventListener(Event.TRIGGERED , this._btnCommentTriggered);
			_btnClose.addEventListener(Event.TRIGGERED , this._btnCloseTriggered);
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _onGoToCommentReturn);
		}
		
		override public function dispose():void
		{
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData, _onGoToCommentReturn);
			super.dispose();
		}
		
		
		/**
		 * 去评论返回响应
		 * @param e
		 * 
		 */		
		private function _onGoToCommentReturn(e:Event):void
		{
			var msg:SocketMessage = e.data as SocketMessage;
			if(msg.getCommand() == ConstNetCommand.CS_COMMENT_GOTOCOMMENT)
			{
				switch(msg.retcode)
				{
					case COMMENT_RET_SUCCESS:
						_btnCloseTriggered(e);
						break;
					case COMMENT_RET_FAIL:
						CJFlyWordsUtil(CJLang("COMMENT_GOTO_DYNAMIC"));
						break;
					default:
						break;
				}
			}
		}
		/**
		 * 触发评论事件
		 * @param e Event
		 * 
		 */		
		private function _btnCommentTriggered(e:Event):void
		{
			_btnCloseTriggered(e);
			if (!SStringUtils.isEmpty(_commentUrl))
			{
				if (!ConstComment.isComment)
				{
					ConstComment.isComment = true;
					navigateToURL(new URLRequest(_commentUrl));
				}
				SocketCommand_comment.goToComment();
			}
		}
		
		/**
		 * 触发关闭事件
		 * @param e Event
		 * 
		 */		
		private function _btnCloseTriggered(e:Event):void
		{
			SSoundEffectUtil.playButtonNormalSound();
			SApplication.moduleManager.exitModule("CJCommentModule");
		}
	}
}














