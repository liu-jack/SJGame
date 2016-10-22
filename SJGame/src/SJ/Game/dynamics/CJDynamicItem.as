package SJ.Game.dynamics
{
	import SJ.Common.Constants.ConstMail;
	import SJ.Common.Constants.ConstNPCDialog;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Common.global.textRender;
	import SJ.Game.SocketServer.SocketCommand_item;
	import SJ.Game.SocketServer.SocketCommand_mail;
	import SJ.Game.SocketServer.SocketCommand_role;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.controls.CJFlyWordsUtil;
	import SJ.Game.data.config.CJDataOfItemProperty;
	import SJ.Game.data.json.Json_item_setting;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.formation.CJItemTurnPageBase;
	import SJ.Game.lang.CJLang;
	import SJ.Game.utils.SSoundEffectUtil;
	
	import engine_starling.SApplication;
	import engine_starling.display.SImage;
	import engine_starling.display.SLayer;
	import engine_starling.utils.Logger;
	import engine_starling.utils.SManufacturerUtils;
	import engine_starling.utils.SStringUtils;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.ITextRenderer;
	import feathers.display.Scale9Image;
	
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Dictionary;
	
	import starling.events.Event;

	/**
	 * 动态显示单元
	 * @author zhengzheng
	 * 
	 */	
	public class CJDynamicItem extends CJItemTurnPageBase
	{
		/**敲锣图标*/
		private var _imgLuo:SImage;
		/**时间显示*/
		private var _labTime:Label;
		/**动态描述*/
		private var _labDesc:Label;
		/**领取奖励按钮*/
		private var _btnGetReward:Button;
		/**删除按钮*/
		private var _btnDel:Button;
		/**已领取标签*/
		private var _labGetAlready:Label;
		
		public function CJDynamicItem()
		{
			super("CJDynamicItem");
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
			_btnGetReward.addEventListener(Event.TRIGGERED , _btnGetRewardTriggered);
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
			if(SManufacturerUtils.getManufacturerType() == SManufacturerUtils.TYPE_IOS)
			{
				_labDesc.textRendererProperties.textFormat = new TextFormat( "Arial", 10, 0x37E1D6, null, null, null, null, null, TextFormatAlign.LEFT);
				_labDesc.textRendererProperties.wordWrap = true; 
				_labDesc.textRendererFactory = textRender.htmlTextRender;
			}
			else
			{
				_labDesc.textRendererFactory = function():ITextRenderer
				{
					var tr:TextFieldTextRenderer = new TextFieldTextRenderer();
					tr.width = 253;
					tr.wordWrap = true;
					tr.maxWidth = tr.width;
					tr.isHTML = true;
					var tf:TextFormat = new TextFormat(); 
					tf.align = TextFormatAlign.LEFT;
					tf.color = 0x37E1D6;
					tf.size = 10;
					tr.textFormat = tf;
					return tr;
				};
			}
			_labDesc.x = 56;
			_labDesc.y = 19;
			_labDesc.width = 253;
			
			_btnGetReward = new Button();
			_btnGetReward.x = 321;
			_btnGetReward.y = 13;
			_btnGetReward.width = 67;
			_btnGetReward.height = 28;
			_btnGetReward.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniu01new"));
			_btnGetReward.downSkin = new SImage(SApplication.assets.getTexture("common_anniu02new"));
			_btnGetReward.defaultLabelProperties.textFormat = ConstTextFormat.textformatwhitecenter;
			_btnGetReward.label = CJLang("DYNAMIC_GET_REWARD");
			
			_btnDel = new Button();
			_btnDel.x = 326;
			_btnDel.y = 13;
			_btnDel.width = 57;
			_btnDel.height = 28;
			_btnDel.defaultSkin = new SImage(SApplication.assets.getTexture("common_anniu01new"));
			_btnDel.downSkin = new SImage(SApplication.assets.getTexture("common_anniu02new"));
			_btnDel.defaultLabelProperties.textFormat = new TextFormat( "Arial", 10, 0xE3B542);
			_btnDel.label = CJLang("DYNAMIC_DEL");
			_btnDel.visible = false;
			
			
			_labGetAlready = new Label();
			_labGetAlready.x = 150;
			_labGetAlready.y = 3;
			_labGetAlready.textRendererProperties.textFormat = new TextFormat( "Arial", 10, 0x4EE730);
			_labGetAlready.text = "（" + CJLang("DYNAMIC_ALREADY_GET") + "）";
			_labGetAlready.visible = false;
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
			addChild(_btnGetReward);
			addChild(_btnDel);
			addChild(_labGetAlready);
			
//			updateMailData(_data);
		}
		
		override protected function draw():void
		{
			super.draw();
			const isSelectInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			if(isSelectInvalid)
			{
				_labTime.text = CJDynamicUtil.o.changeSecondToDate(data.maildate);
				var descStr:String;
				if (data.mailtype == ConstMail.MAIL_TYPE_FRIEND)
				{
					var assistInfo:Object = JSON.parse(data.mailcontext);
					descStr = CJLang("DYNAMIC_FRIEND")  + "：" + 
						CJLang("DYNAMIC_FRIEND_DESCRIPTION", {"rolename":assistInfo.rolename, "vit":assistInfo.addVitCount});
//					data.mailhasattachitems == 0;
				}
				else if (data.mailtype == ConstMail.MAIL_TYPE_SYSTEM)
				{
					descStr = CJLang("DYNAMIC_SYSTEM")  + "：" + data.mailcontext;
				}
				if (data.mailattachgold > 0)
				{
					descStr += "，" + CJLang("DYNAMIC_GOLD")  + " * " + data.mailattachgold;
				}
				if (data.mailattachsliver > 0)
				{
					descStr += "，" + CJLang("DYNAMIC_SILVER")  + " * " + data.mailattachsliver;
				}
				if (!SStringUtils.isEmpty(data.mailattachitems) && data.mailtype != 2)
				{
					var dictItem:Object = JSON.parse(data.mailattachitems);
					for (var itemTmplId:String in dictItem) 
					{
						//						Logger.log("mailattachitem","key:" + itemTmplId + ", value:" + dictItem[itemTmplId]);
						var templateItemSetting:Json_item_setting = CJDataOfItemProperty.o.getTemplate(int(itemTmplId));
						if (templateItemSetting)
						{
							descStr += "，" + CJLang(templateItemSetting.itemname) +
								" * " + dictItem[itemTmplId];
						}
					}
				}
				_labDesc.text = descStr;
				//未领取时
				if (data.mailhasattachitems == 1 || data.mailattachgold > 0 || data.mailattachsliver > 0)
				{
					_labGetAlready.visible = false;
					_btnGetReward.visible = true;
					_btnDel.visible = false;
				}
				else
				{
					_btnGetReward.visible = false;
					_labGetAlready.visible = true;
					_btnDel.visible = true;
				}
			}
		}
		
		/**
		 * 领取奖励触发事件
		 * @param e Event
		 * 
		 */		
		private function _btnGetRewardTriggered(e:Event):void
		{
			SSoundEffectUtil.playButtonNormalSound();
			//添加数据到达监听 
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,_onloadRecvMailAttachInfo);
			SocketCommand_mail.recvMailAttach(_data.mailid);
		}
		
		override public function dispose():void
		{
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_onloadDelMailInfo);
			SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_onloadRecvMailAttachInfo);
			super.dispose();
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
		/**
		 * 加载接受邮件附件服务器返回数据 
		 * @param e Event
		 * 
		 */		
		private function _onloadRecvMailAttachInfo(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if (message.getCommand() == ConstNetCommand.CS_MAIL_RECV_MAIL_ATTACH)
			{
				SocketManager.o.removeEventListener(CJSocketEvent.SocketEventData,_onloadRecvMailAttachInfo);
				var retCode:int = message.retcode;
				switch(retCode)
				{
					case 0:
						CJFlyWordsUtil(CJLang("DYNAMIC_GET_SUCCESS"));
						SocketCommand_mail.getMails();
						SocketCommand_item.getBag();
						SocketCommand_role.get_role_info();
						_btnGetReward.visible = false;
						_labGetAlready.visible = true;
						_btnDel.visible = true;
						//添加数据到达监听 
						SocketManager.o.addEventListener(CJSocketEvent.SocketEventData,_onloadDelMailInfo);
						SocketCommand_mail.delMail(_data.mailid);
						break;
					case 1:
						CJFlyWordsUtil(CJLang("DYNAMIC_DEL_GOLD_TOPPEST"));
						break;
					case 2:
						CJFlyWordsUtil(CJLang("DYNAMIC_DEL_SILVER_TOPPEST"));
						break;
					case 3:
						CJFlyWordsUtil(CJLang("DYNAMIC_BAG_FULL"));
						break;
					default:
						break;
				}
			}
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
//						CJFlyWordsUtil(CJLang("DYNAMIC_DEL_SUCCESS"));
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