package SJ.Common.Constants
{
//	import SJ.Game.friends.CJFriendPlayerTipsLayer;

	/**
	 * 好友常量信息
	 * @author zhengzheng
	 * 
	 */	
	public final class ConstFriend
	{
		public function ConstFriend()
		{
		}
		/**
		 *显示数据类型
		 */		
		public static var FRIEND_SHOW_TYPE:int = 0;
		/**
		 *显示数据类型-我的好友
		 */		
		public static const FRIEND_SHOW_TYPE_MY_FRIEND:int = 0;
		/**
		 *显示数据类型-最近联系
		 */		
		public static const FRIEND_SHOW_TYPE_RECENT_CONTACT:int = 1;
		/**
		 *显示数据类型-黑名单
		 */		
		public static const FRIEND_SHOW_TYPE_BLACKLIST:int = 2;
		/**
		 *显示数据类型-申请好友
		 */		
		public static const FRIEND_SHOW_TYPE_REQUEST:int = 3;
		/**
		 *好友申请界面每页显示条目个数
		 */		
		public static const FRIEND_REQUEST_PER_PAGE_ITEM_NUM:int = 6;
		/**
		 *好友列表界面每页显示条目个数
		 */		
		public static const FRIEND_PLAYER_PER_PAGE_ITEM_NUM:int = 3;
		
		/**
		 *服务器返回数据-未知错误
		 */		
		public static var FRIEND_RETCODE_UNKNOWN:int = -1;
		/**
		 *服务器返回数据-成功
		 */		
		public static const FRIEND_RETCODE_SUCC:int = 0;
		/**
		 *服务器返回数据-好友已满
		 */		
		public static const FRIEND_RETCODE_FRIEND_FULL:int = 1;
		/**
		 *服务器返回数据-黑名单已满
		 */		
		public static const FRIEND_RETCODE_BLACKLIST_FULL:int = 1;
		/**
		 *服务器返回数据-是自己
		 */		
		public static const FRIEND_RETCODE_IS_SELF:int = 2;
		/**
		 *服务器返回数据-不在线
		 */		
		public static const FRIEND_RETCODE_OFFLINE:int = 3;
		/**
		 *服务器返回数据-已经在请求列表
		 */		
		public static var FRIEND_RETCODE_ALREADY_IN_REQUEST_LIST:int = 4;
		/**
		 *服务器返回数据-已经是好友
		 */		
		public static const FRIEND_RETCODE_ALREADY_FRIEND:int = 5;
		/**
		 *服务器返回数据-请求不存在
		 */		
		public static const FRIEND_RETCODE_REQUEST_NOT_EXIST:int = 6;
		/**
		 *服务器返回数据-不是好友
		 */		
		public static const FRIEND_RETCODE_IS_NOT_FRIEND:int = 7;
		/**
		 *服务器返回数据-已经在黑名单中
		 */		
		public static const FRIEND_RETCODE_ALREADY_BLACKLIST:int = 8;
		/**
		 *服务器返回数据-对方好友达到上限
		 */		
		public static const FRIEND_OTHER_FULL:int = 9;
		/** 列表玩家的个数- 我的好友 */
		public static var myFriendPlayerNum:int;
		/** 列表玩家的个数- 最近联系人 */
		public static var recentContactPlayerNum:int;
		/** 列表玩家的个数- 好友申请 */
		public static var requestPlayerNum:int;
		/** 列表玩家的个数- 黑名单 */
		public static var blacklistPlayerNum:int;
		
		/**
		 *是否只显示在线玩家
		 */		
		public static var isShowOnlyOnline:Boolean = false;
//		/** 上一次的玩家提示框*/
//		public static var layerPlayerTipsOld:CJFriendPlayerTipsLayer;
		/**
		 *好友申请总条目个数
		 */		
		public static const FRIEND_REQUEST_ITEM_TOTAL_NUM:String = "FRIEND_REQUEST_ITEM_TOTAL_NUM";
		/**
		 *我的好友总条目个数
		 */		
		public static const FRIEND_MY_FRIEND_ITEM_TOTAL_NUM:String = "FRIEND_MY_FRIEND_ITEM_TOTAL_NUM";
		/**
		 *最近联系总条目个数
		 */		
		public static const FRIEND_RECENT_CONTACT_ITEM_TOTAL_NUM:String = "FRIEND_RECENT_CONTACT_ITEM_TOTAL_NUM";
		/**
		 *黑名单总条目个数
		 */		
		public static const FRIEND_BLACKLIST_ITEM_TOTAL_NUM:String = "FRIEND_BLACKLIST_ITEM_TOTAL_NUM";
//		/**
//		 *玩家提示信息改变
//		 */		
//		public static const FRIEND_TIPS_CHANGED:String = "FRIEND_TIPS_CHANGED";
		/**
		 *显示在线玩家改变
		 */		
		public static const FRIEND_ONLINE_SHOW_CHANGED:String = "FRIEND_ONLINE_SHOW_CHANGED";
		/**
		 *显示在线玩家好友申请改变
		 */		
		public static const FRIEND_ONLINE_REQUEST_SHOW_CHANGED:String = "FRIEND_ONLINE_REQUEST_SHOW_CHANGED";
	}
}