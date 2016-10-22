package SJ.Game.data
{
	import engine_starling.data.SDataBase;
	
	/**
	 * 好友信息数据
	 * @author zhengzheng
	 * 
	 */
	public class CJDataOfFriendItem extends SDataBase
	{
		//自己的uid
		private var _uid:String;
		//好友的uid
		private var _frienduid:String;
		//好友关系确立的时间 1970至今的毫秒数
		private var _createdate:String;
		//扩展字段
		private var _extcode:int;
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
		//好友的战斗力
		private var _battleeffect:String;
		//好友的总战斗力
		private var _battleeffectsum:String;
		public function CJDataOfFriendItem()
		{
			super("CJDataOfFriendItem");
		}
		
		public function get uid():String
		{
			return _uid;
		}

		public function set uid(value:String):void
		{
			_uid = value;
		}

		public function get frienduid():String
		{
			return _frienduid;
		}

		public function set frienduid(value:String):void
		{
			_frienduid = value;
		}

		public function get createdate():String
		{
			return _createdate;
		}

		public function set createdate(value:String):void
		{
			_createdate = value;
		}

		public function get extcode():int
		{
			return _extcode;
		}

		public function set extcode(value:int):void
		{
			_extcode = value;
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

		public function get battleeffect():String
		{
			return _battleeffect;
		}

		public function set battleeffect(value:String):void
		{
			_battleeffect = value;
		}

		public function get battleeffectsum():String
		{
			return _battleeffectsum;
		}

		public function set battleeffectsum(value:String):void
		{
			_battleeffectsum = value;
		}


	}
}