package SJ.Game.cdkey
{
	import SJ.Common.Constants.ConstMainUI;
	import SJ.Common.Constants.ConstTextFormat;
	import SJ.Game.SocketServer.SocketCommand_cdkey;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJMessageBox;
	
	import engine_starling.SApplication;
	import engine_starling.display.SLayer;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.TextInput;
	
	import starling.events.Event;
	
	public class CJCDKeyLayer extends SLayer
	{
		private var _prompt1:Label;
		/**  请输入激活码 **/
		public function get prompt1():Label
		{
			return _prompt1;
		}
		/** @private **/
		public function set prompt1(value:Label):void
		{
			_prompt1 = value;
		}
		private var _prompt2:Label;
		/**  兑换成功 **/
		public function get prompt2():Label
		{
			return _prompt2;
		}
		/** @private **/
		public function set prompt2(value:Label):void
		{
			_prompt2 = value;
		}
		private var _cdkeyputin:TextInput;
		/**  昵称输入框 **/
		public function get cdkeyputin():TextInput
		{
			return _cdkeyputin;
		}
		/** @private **/
		public function set cdkeyputin(value:TextInput):void
		{
			_cdkeyputin = value;
		}
		private var _btnExchange:Button;
		/**  兑换 **/
		public function get btnExchange():Button
		{
			return _btnExchange;
		}
		/** @private **/
		public function set btnExchange(value:Button):void
		{
			_btnExchange = value;
		}
		private var _btnClose:Button;
		/**  关闭按钮 **/
		public function get btnClose():Button
		{
			return _btnClose;
		}
		/** @private **/
		public function set btnClose(value:Button):void
		{
			_btnClose = value;
		}

		
		/** 最大cdkey长度 **/
		private const MAX_CDKEY_LEN:uint = 16;
		
		public function CJCDKeyLayer()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			width = ConstMainUI.MAPUNIT_WIDTH;
			height = ConstMainUI.MAPUNIT_HEIGHT;
			
			// 关闭按钮
			btnClose.addEventListener(Event.TRIGGERED, function(e:Event):void{
				SApplication.moduleManager.exitModule("CJCDKeyModule");
			});
			
			prompt1.text = CJLang("cdkey_prompt1");//"请输入激活码";
			prompt2.text = CJLang("cdkey_prompt2");//"（兑换成功后，请到动态中领取奖励）";
			
			// 设置名称输入框字体格式
			var fontFormat:Object = cdkeyputin.textEditorProperties;
//			fontFormat.fontFamily = "宋体";
//			fontFormat.color = 0xFFFFFFFF;
//			fontFormat.displayAsPassword = false;
			fontFormat.textAlign = "center"; 
//			fontFormat.color = 0x00000000;
			fontFormat.maxChars = MAX_CDKEY_LEN;
			fontFormat.restrict = "a-f0-9";// 输入判断
			cdkeyputin.textEditorProperties = fontFormat;
			
			// 兑换
			btnExchange.addEventListener(Event.TRIGGERED, function(e:Event):void{
				
				if (MAX_CDKEY_LEN == cdkeyputin.text.length)
					SocketCommand_cdkey.activate(__activate, cdkeyputin.text);
				else
					CJMessageBox(CJLang("cdkey_error_len"));
				
				// 激活返回函数
				function __activate(message:SocketMessage):void
				{
					switch(message.retcode)
					{
						case 0:
							cdkeyputin.text = "";
							CJMessageBox(CJLang("cdkey_error_ok"));
							break;
						case 1:
							CJMessageBox(CJLang("cdkey_error_count"));
							break;
						case 2:
							CJMessageBox(CJLang("cdkey_error_no"));
							break;
						case 3:
							CJMessageBox(CJLang("cdkey_error_date"));
							break;
						default:
							CJMessageBox(CJLang("ERROR_UNKNOWN")+ "CJCDKeyLayer.__activate retcode = " + message.retcode);
							break;
					}
				}
			});
			btnExchange.defaultLabelProperties.textFormat = ConstTextFormat.textformatkhakisize11;
			btnExchange.label = CJLang("cdkey_exchange");//"兑换";
		}
	}
}














