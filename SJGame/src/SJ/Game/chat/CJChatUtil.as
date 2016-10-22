package SJ.Game.chat
{
	import SJ.Game.data.CJDataManager;
	import SJ.Game.lang.CJLang;
	import SJ.Game.layer.CJMessageBox;
	import SJ.Game.richtext.CJRTElementBr;
	import SJ.Game.richtext.CJRTElementLabel;
	import SJ.Game.task.CJTaskFlowString;

	/**
	 +------------------------------------------------------------------------------
	 * 聊天工具类
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-6-9 下午3:59:43  
	 +------------------------------------------------------------------------------
	 */
	public class CJChatUtil
	{
		/**
		 * 检测当前频道是否可以发言
		 * @param screenName : 频道的标记
		 */		
		public static function checkCanSend(screenName:String):Boolean
		{
			//检测发言时间
			var currentTime:Number = new Date().time;
			if(currentTime - CJDataManager.o.DataOfChat.lastChatTime <= 5 * 1000)
			{
				new CJTaskFlowString(CJLang("CHAT_TO_FAST")).addToLayer();
				return false;
			}
			
			if(screenName == "WORLD")
			{
				return true;
			}
			else if(screenName == "ARMY")
			{
				CJMessageBox(CJLang("CHAT_JUNTUANTISHI"));
				return false;
			}
			else if(screenName == "PRIVATE")
			{
				return true;
			}
			return false;
		}
		
		public static function pushPrivateChatLabels(content:String, fromuid:String , fromrolename:String ,touid:String , torolename:String, fontsize:int = 12 , height:Number = 16):Array
		{
			content = CJLang('CHAT_SAY') + content;
			var array:Array = new Array();
			
			var labelChannel:CJRTElementLabel = new CJRTElementLabel("["+CJLang("CHAT_PRIVATE")+"]");
			labelChannel.font = "黑体";
			labelChannel.size = fontsize;
			labelChannel.height = height;
			labelChannel.color = 0xC042EA;
			array.push(labelChannel);
			
			var myuid:String = CJDataManager.o.DataOfHeroList.getRoleId();
//			你对****
			if(myuid == fromuid)
			{
				var prefix:CJRTElementLabel = new CJRTElementLabel(CJLang('CHAT_YOU_TO'));
				prefix.font = "黑体";
				prefix.size = fontsize;
				prefix.height = height;
				prefix.color = 0xFFFFFF;
				array.push(prefix);
				
				var labelName:CJRTElementLabel = new CJRTElementLabel(torolename+ " ");
				labelName.font = "黑体";
				labelName.size = fontsize;
				labelName.height = height;
				labelName.data.fromuid = touid;
				labelName.data.rolename = torolename;
				labelName.color = 0x338595;
				labelName.underline = 1;
				labelName.clickable = true;
				array.push(labelName);
			}
//			****对你
			else
			{
				var labelName1:CJRTElementLabel = new CJRTElementLabel(fromrolename+ " ");
				labelName1.font = "黑体";
				labelName1.size = fontsize;
				labelName1.height = height;
				labelName1.data.fromuid = fromuid;
				labelName1.data.rolename = fromrolename;
				labelName1.color = 0x338595;
				labelName1.underline = 1;
				labelName1.clickable = true;
				array.push(labelName1);
				
				var suffix:CJRTElementLabel = new CJRTElementLabel(CJLang('CHAT_TO_YOU'));
				suffix.font = "黑体";
				suffix.size = fontsize;
				suffix.height = height;
				suffix.color = 0xFFFFFF;
				array.push(suffix);
			}
			
			var labelContent:CJRTElementLabel = new CJRTElementLabel(content);
			labelContent.font = "黑体";
			labelContent.size = fontsize;
			labelContent.height = height;
			labelContent.color = 0xC042EA;
			array.push(labelContent);
			
			array.push(new CJRTElementBr());
			return array;
		}
		
		public static function pushNoticeChatLabels(content:String , fontsize:int = 12 , height:Number = 16):Array
		{
			var array:Array = new Array();
			
			var labelChannel:CJRTElementLabel = new CJRTElementLabel("["+CJLang("CHAT_NOTICE")+"]");
			labelChannel.font = "黑体";
			labelChannel.color = 0xFF0000;
			labelChannel.size = fontsize;
			labelChannel.height = height;
			array.push(labelChannel);
			
			var labelContent:CJRTElementLabel = new CJRTElementLabel(content);
			labelContent.font = "黑体";
			labelContent.color = 0xFF0000;
			labelContent.size = fontsize;
			labelContent.height = height;
			array.push(labelContent);
			
			array.push(new CJRTElementBr());
			return array;
		}
		
		/**
		 * 世界聊天返回的Element列表
		 */	
		public static function pushWorldChatLabels(content:String , fromuid:String , rolename:String , fontsize:int = 12 , height:Number = 16):Array
		{
			content = CJLang('CHAT_SAY') + content;
			var array:Array = new Array();
			
			var labelChannel:CJRTElementLabel = new CJRTElementLabel("["+CJLang("CHAT_WORLD")+"]");
			labelChannel.font = "黑体";
			labelChannel.color = 0xFFF55D;
			labelChannel.size = fontsize;
			labelChannel.height = height;
			array.push(labelChannel);
			
			var labelName:CJRTElementLabel = new CJRTElementLabel(rolename+ " ");
			labelName.font = "黑体";
			labelName.data.fromuid = fromuid;
			labelName.data.rolename = rolename
			labelName.color = 0x338595;
			labelName.underline = 1;
			labelName.clickable = true;
			labelName.size = fontsize;
			labelName.height = height;
			array.push(labelName);
			
			var labelContent:CJRTElementLabel = new CJRTElementLabel(content);
			labelContent.font = "黑体";
			labelContent.color = 0xFFF55D;
			labelContent.size = fontsize;
			labelContent.height = height;
			
			array.push(labelContent);
			array.push(new CJRTElementBr());
			return array;
		}
		
		/**
		 * 军团聊天返回的Element列表
		 */		
		public static function pushArmyChatLabels(content:String, fromuid:String , rolename:String , fontsize:int = 12, height:Number = 16):Array
		{
			content = CJLang('CHAT_SAY')+content;
			var array:Array = new Array();
			
			var labelChannel:CJRTElementLabel = new CJRTElementLabel("["+CJLang("CHAT_ARMY")+"]");
			labelChannel.font = "黑体";
			labelChannel.color = 0x4EE431;
			labelChannel.size = fontsize;
			labelChannel.height = height;
			
			array.push(labelChannel);
			
			var labelName:CJRTElementLabel = new CJRTElementLabel(rolename+ " ");
			labelName.font = "黑体";
			labelName.data.fromuid = fromuid;
			labelName.data.rolename = rolename
			labelName.color = 0x338595;
			labelName.underline = 1;
			labelName.clickable = true;
			labelName.size = fontsize;
			labelName.height = height;
			array.push(labelName);
			
			var labelContent:CJRTElementLabel = new CJRTElementLabel(content);
			labelContent.font = "黑体";
			labelContent.color = 0x4EE431;
			labelContent.size = fontsize;
			labelContent.height = height;
			array.push(labelContent);
			
			array.push(new CJRTElementBr());
			return array;
		}
	}
}