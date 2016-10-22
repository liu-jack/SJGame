package SJ.Game.data
{
	import SJ.Common.Constants.ConstPlayer;
	import SJ.Game.data.config.CJDataHeroProperty;
	
	/**
	 * 武将信息
	 * @author longtao
	 * 
	 */
	public class CJDataOfHero
	{
		public function CJDataOfHero()
		{
		}
		
		private var _heroid:String;
		/**
		 * 武将ID
		 */
		public function get heroid():String
		{
			return _heroid
		}
		
		/**
		 * @private
		 */
		public function set heroid(value:String):void
		{
			_heroid = value
		}
		
		private var _templateid:int;
		/**
		 * 模板ID
		 */
		public function get templateid():int
		{
			return _templateid
		}
		
		/**
		 * @private
		 */
		public function set templateid(value:int):void
		{
			_templateid = value;
		}
		
		
		private var _level:String;
		/**
		 * 武将等级
		 */
		public function get level():String
		{
			return _level
		}
		
		/**
		 * @private
		 */
		public function set level(value:String):void
		{
			_level = value;
		}
		
		private var _stagelevel:String;
		/**
		 * 进阶等级
		 */
		public function get stagelevel():String
		{
			return _stagelevel
		}
		
		/**
		 * @private
		 */
		public function set stagelevel(value:String):void
		{
			_stagelevel = value;
		}
		
		
		private var _currentexp:String;
		/**
		 * 当前经验
		 */
		public function get currentexp():String
		{
			return _currentexp
		}
		
		/**
		 * @private
		 */
		public function set currentexp(value:String):void
		{
			_currentexp = value;
		}
		
		private var _userid:String;
		/**
		 * 玩家id
		 */
		public function get userid():String
		{
			return _userid
		}
		
		/**
		 * @private
		 */
		public function set userid(value:String):void
		{
			_userid = value;
		}
		
		private var _heroProperty:CJDataHeroProperty;

		/**
		 * 武将模板数据
		 */
		public function get heroProperty():CJDataHeroProperty
		{
			return _heroProperty;
		}

		/**
		 * @private
		 */
		public function set heroProperty(value:CJDataHeroProperty):void
		{
			_heroProperty = value;
		}
		
		/**
		 * 是否为主角
		 * @return 
		 * 
		 */
		public function get isRole():Boolean
		{
			if (null == _heroProperty)
				return false;
			if (_heroProperty.type == ConstPlayer.SConstPlayerTypePlayer && heroid == userid)
				return true;
			return false;
		}
		
		
		private var _currentskill:String;

		/**
		 * 当前技能ID
		 */
		public function get currentskill():String
		{
			return _currentskill;
		}

		/**
		 * @private
		 */
		public function set currentskill(value:String):void
		{
			_currentskill = value;
		}
		
		private var _formationindex:String;
		
		/**
		 * 阵型索引(该数据目前无用)
		 */
		public function get formationindex():String
		{
			return _formationindex;
		}
		
		/**
		 * @private
		 */
		public function set formationindex(value:String):void
		{
			_formationindex = value;
		}
		
		private var _currenttalent:String

		/**
		 * 当前天赋
		 */
		public function get currenttalent():String
		{
			return _currenttalent;
		}

		/**
		 * @private
		 */
		public function set currenttalent(value:String):void
		{
			_currenttalent = value;
		}
		
		private var _starlevel:String

		/**
		 * 武将星级
		 */
		public function get starlevel():String
		{
			return _starlevel;
		}

		/**
		 * @private
		 */
		public function set starlevel(value:String):void
		{
			_starlevel = value;
		}

		private var _battleeffectsum:String
		/**
		 * 武将总战斗力
		 */
		public function get battleeffectsum():String
		{
			return _battleeffectsum;
		}
		
		/**
		 * @private
		 */
		public function set battleeffectsum(value:String):void
		{
			_battleeffectsum = value;
		}
	}
}