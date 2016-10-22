package SJ.Game.data
{
	import engine_starling.data.SDataBase;
	
	/**
	 * 好友申请信息数据
	 * @author zhengzheng
	 * 
	 */
	public class CJDataOfFriendRequestItem extends SDataBase
	{
		//好友申请Id
		private var _requestid:String;
		//接受申请的UID
		private var _recvuid:String;
		//发送申请的uid
		private var _senduid:String;
		//申请发起的时间
		private var _createdate:String;
		//好友的阵营 (0无阵营，1魏，2蜀，4吴)
		private var _camp:int;
		//好友的职业（1战士2法师 8 火枪手）
		private var _job:int;
		//好友最近登录时间
		private var _lately_login:String;
		//好友等级
		private var _level:int;
		//好友在线状态（0：离线，1：在线）
		private var _online:int;
		//好友的角色名
		private var _rolename:String;
		//好友的模板id
		private var _templateid:int;
		//好友的vip等级
		private var _viplevel:int;
		
		public function CJDataOfFriendRequestItem()
		{
			super("CJDataOfFriendRequestItem");
		}
		
		public function get requestid():String
		{
			return _requestid;
		}

		public function set requestid(value:String):void
		{
			_requestid = value;
		}

		public function get recvuid():String
		{
			return _recvuid;
		}

		public function set recvuid(value:String):void
		{
			_recvuid = value;
		}

		public function get senduid():String
		{
			return _senduid;
		}

		public function set senduid(value:String):void
		{
			_senduid = value;
		}

		public function get createdate():String
		{
			return _createdate;
		}

		public function set createdate(value:String):void
		{
			_createdate = value;
		}
		public function get camp():int
		{
			return _camp;
		}
		
		public function set camp(value:int):void
		{
			_camp = value;
		}
		
		public function get job():int
		{
			return _job;
		}
		
		public function set job(value:int):void
		{
			_job = value;
		}
		
		public function get lately_login():String
		{
			return _lately_login;
		}
		
		public function set lately_login(value:String):void
		{
			_lately_login = value;
		}
		
		public function get level():int
		{
			return _level;
		}
		
		public function set level(value:int):void
		{
			_level = value;
		}
		
		public function get online():int
		{
			return _online;
		}
		
		public function set online(value:int):void
		{
			_online = value;
		}
		
		public function get rolename():String
		{
			return _rolename;
		}
		
		public function set rolename(value:String):void
		{
			_rolename = value;
		}
		
		public function get templateid():int
		{
			return _templateid;
		}
		
		public function set templateid(value:int):void
		{
			_templateid = value;
		}
		
		public function get viplevel():int
		{
			return _viplevel;
		}
		
		public function set viplevel(value:int):void
		{
			_viplevel = value;
		}

	}
}