package SJ.Common.Constants
{
	public class ConstMainUI
	{
		public function ConstMainUI()
		{
		}
		public static const MAPUNIT_WIDTH:Number = 480;
		public static const MAPUNIT_HEIGHT:Number = 320;
		/**
		 * 传送点每秒播放图片帧数 
		 */		
		public static const ConstTeleporterFPS:uint = 8;
		/**
		 * NPC每秒播放图片帧数 
		 */		
		public static const ConstNPC_FPS:uint = 10;
		/**
		 * 经验条X坐标 
		 */		
		public static const ConstExpBarX:int = 119;
		/**
		 * 经验条Y坐标 
		 */		
		public static const ConstExpBarY:int = 17;
		/**
		 * 主界面中经验条图片最大长度 
		 */	
		public static const ConstExpBarMaxLength:int = 81;
		/**
		 * 主界面中经验条图片高度 
		 */	
		public static const ConstExpBarHeight:int = 8;
		/**
		 * 体力条X坐标 
		 */		
		public static const ConstStrengthBarX:int = 56;
		/**
		 * 体力条X坐标
		 */		
		public static const ConstStrengthBarY:int = 27;
		/**
		 * 主界面中体力条图片最大长度 
		 */	
		public static const ConstStrengthBarMaxLength:int = 92;
		/**
		 * 主界面中体力条图片高度 
		 */	
		public static const ConstStrengthBarHeight:int = 4;
		/**
		 *主界面点击其他玩家事件
		 */		
		public static const MAIN_UI_CLICK_PLAYER:String = "MAIN_UI_CLICK_PLAYER";
		/**
		 *点击的玩家消失事件
		 */		
		public static const MAIN_UI_CLICK_PLAYER_DISAPPEAR:String = "MAIN_UI_CLICK_PLAYER_DISAPPEAR";
		/**
		 *上次点击玩家的uid
		 */
		public static var oldClickPlayerUid:String;
		
		/**
		 *新消息提醒个数
		 */
		public static var newsCount:int;
		/**
		 * 助战玩家获得体力丹个数
		 */		
		public static var addVitCount:int;
		
	}
}