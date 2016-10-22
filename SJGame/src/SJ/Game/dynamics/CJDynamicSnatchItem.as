package SJ.Game.dynamics
{
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import SJ.Common.Constants.ConstMail;
	import SJ.Common.Constants.ConstNPCDialog;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.global.textRender;
	import SJ.Game.SocketServer.SocketCommand_item;
	import SJ.Game.SocketServer.SocketCommand_mail;
	import SJ.Game.SocketServer.SocketCommand_role;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.controls.CJFlyWordsUtil;
	import SJ.Game.data.config.CJDataHeroProperty;
	import SJ.Game.data.config.CJDataOfHeroPropertyList;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.formation.CJItemTurnPageBase;
	import SJ.Game.lang.CJLang;
	import SJ.Game.utils.SSoundEffectUtil;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.display.Scale9Image;
	
	import starling.events.Event;

	/**
	 * 动态显示单元
	 * @author zhengzheng
	 * 
	 */	
	public class CJDynamicSnatchItem extends CJItemTurnPageBase
	{
		/**敲锣图标*/
		private var _imgLuo:SImage;
		/**时间显示*/
		private var _labTime:Label;
		/**动态描述*/
		private var _labDesc:Label;
		/**删除按钮*/
		private var _btnDel:Button;
		
		public function CJDynamicSnatchItem()
		{
			super("CJDynamicSnatchItem");
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
			_btnDel.addEventListener(Event.TRIGGERED , _btnDelTriggered);
		}
		/**
		 * 初始化数据
		 */		
		private function _initData():void
		{
			this.width = 393;
			this.height = 52;
			
			_imgLuo = new SImage(SApplication.assets.getTexture("dongtai_luo"));
			_imgLuo.x = 10;
			_imgLuo.y = 10;
			
			_labTime = new Label();
			_labTime.x = 56;
			_labTime.y = 4;
			_labTime.textRendererProperties.textFormat = new TextFormat( "Arial", 10, 0x37E1D6);
			
			_labDesc = new Label();
			_labDesc.textRendererProperties.textFormat = new TextFormat( "Arial", 10, 0x37E1D6, null, null, null, null, null, TextFormatAlign.LEFT);
			_labDesc.textRendererProperties.wordWrap = true; 
			_labDesc.textRendererFactory = textRender.htmlTextRender;
			_labDesc.x = 56;
			_labDesc.y = 19;
			_labDesc.width = 253;
			
			
			_btnDel = new Button();
			_btnDel.x = 326;
			_btnDel.y = 13;
			_btnDel.width = 57;
			_btnDel.height = 28;
			_btnDel.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniu01new"));
			_btnDel.downSkin = new SImage(SApplication.assets.getTexture("common_anniu02new"));
			_btnDel.defaultLabelProperties.textFormat = new TextFormat( "Arial", 10, 0xE3B542);
			_btnDel.label = CJLang("DYNAMIC_CONFIRM");

		}
		/**
		 * 
		 * 画出单个条目
		 * 
		 */
		private function _drawContent():void
		{
			//文字底框
			var imgBg:Scale9Image = ConstNPCDialog.genS9ImageWithTextureNameAndRect("common_liaotian_wenzidi", 5, 5, 2, 2);
			imgBg.width = 393;
			imgBg.height = 52;
			imgBg.alpha = 0.8;
			addChild(imgBg);
			
			addChild(_imgLuo);
			addChild(_labTime);
			addChild(_labDesc);
			addChild(_btnDel);
		}
		
		override protected function draw():void
		{
			super.draw();
			const isSelectInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			if(isSelectInvalid)
			{
				_labTime.text = CJDynamicUtil.o.changeSecondToDate(data.maildate);
				var descStr:String;
				var snatchInfo:Object;
				if (data.mailtype == ConstMail.MAIL_TYPE_SNATCH)
				{
					snatchInfo = JSON.parse(data.mailcontext);
					descStr = CJLang("DYNAMIC_SNATCH")  + "：" + 
						CJLang("DYNAMIC_SNATCH_DESCRIPTION", {"rolename":snatchInfo.rolename, "treasurepartname":snatchInfo.treasurepartname});
				}
				else if (data.mailtype == ConstMail.MAIL_TYPE_FRISNATCH)
				{
					snatchInfo = JSON.parse(data.mailcontext);
					descStr = CJLang("DYNAMIC_SNATCH")  + "：" + 
						CJLang("DYNAMIC_FRISNATCH_DESCRIPTION", {"rolename":snatchInfo.rolename, "money":snatchInfo.money});
				}
				_labDesc.text = descStr;
			}
		}
		
		/**
		 * 删除触发事件
		 * @param e Event
		 * 
		 */		
		private function _btnDelTriggered(e:Event):void
		{
			SSoundEffectUtil.playButtonNormalSound();
			//添加数据到达监听 
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,_onloadDelMailInfo);
			SocketCommand_mail.delMail(_data.mailid);
		}
		
		
		override public function dispose():void
		{
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_onloadDelMailInfo);
			super.dispose();
		}
		
		
		/**
		 * 加载删除邮件服务器返回数据 
		 * @param e Event
		 * 
		 */		
		private function _onloadDelMailInfo(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if (message.getCommand() == ConstNetCommand.CS_MAIL_DEL_MAIL)
			{
				SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_onloadDelMailInfo);
				if (message.retcode == 0)
				{
					var isSucess:Boolean = message.retparams;
					if (isSucess)
					{
						CJFlyWordsUtil(CJLang("DYNAMIC_DEL_SUCCES"));
						SocketCommand_mail.getMails();
					}
					else
					{
						CJFlyWordsUtil(CJLang("DYNAMIC_DEL_FAIL"));
					}
				}
			}
		}
	}
}