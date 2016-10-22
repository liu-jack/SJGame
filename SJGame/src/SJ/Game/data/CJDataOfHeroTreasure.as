package SJ.Game.data
{
	import engine_starling.data.SDataBase;
	
	/**
	 +------------------------------------------------------------------------------
	 * 聚灵 - 武将身上装备灵丸数据
	 +------------------------------------------------------------------------------
	 * @author    caihua   
	 * @email    caihua.bj@gmail.com
	 * @date 2013-5-31 下午2:23:39  
	 +------------------------------------------------------------------------------
	 */
	public class CJDataOfHeroTreasure extends SDataBase
	{
		/*武将的id*/
		private var _heroid:String;
		/*武将身上的1号位置的灵丸id*/
		private var _treasureid1:String;
		private var _treasureid2:String;
		private var _treasureid3:String;
		private var _treasureid4:String;
		private var _treasureid5:String;
		private var _treasureid6:String;
		private var _treasureid7:String;
		private var _treasureid8:String;
		
		public static const DATA_KEY:String = "CJDataOfTreasure";
		
		public function CJDataOfHeroTreasure()
		{
			super(DATA_KEY);
		}
		
		public function init(data:Object):void
		{
			if(data == null)
			{
				return;
			}
			this._heroid = data.heroid;
			this._treasureid1 = data.treasureid1;
			this._treasureid2 = data.treasureid2;
			this._treasureid3 = data.treasureid3;
			this._treasureid4 = data.treasureid4;
			this._treasureid5 = data.treasureid5;
			this._treasureid6 = data.treasureid6;
			this._treasureid7 = data.treasureid7;
			this._treasureid8 = data.treasureid8;
		}

		public function get heroid():String
		{
			return _heroid;
		}

		public function set heroid(value:String):void
		{
			_heroid = value;
		}

		/**
		 * 武将身上1号位置的灵丸id
		 */		
		public function get treasureid1():String
		{
			return _treasureid1;
		}

		/**
		 * 武将身上1号位置的灵丸id
		 */	
		public function set treasureid1(value:String):void
		{
			_treasureid1 = value;
		}

		/**
		 * 武将身上2号位置的灵丸id
		 */	
		public function get treasureid2():String
		{
			return _treasureid2;
		}

		/**
		 * 武将身上2号位置的灵丸id
		 */	
		public function set treasureid2(value:String):void
		{
			_treasureid2 = value;
		}

		/**
		 * 武将身上3号位置的灵丸id
		 */	
		public function get treasureid3():String
		{
			return _treasureid3;
		}

		/**
		 * 武将身上3号位置的灵丸id
		 */	
		public function set treasureid3(value:String):void
		{
			_treasureid3 = value;
		}

		/**
		 * 武将身上4号位置的灵丸id
		 */	
		public function get treasureid4():String
		{
			return _treasureid4;
		}

		/**
		 * 武将身上4号位置的灵丸id
		 */	
		public function set treasureid4(value:String):void
		{
			_treasureid4 = value;
		}

		/**
		 * 武将身上5号位置的灵丸id
		 */	
		public function get treasureid5():String
		{
			return _treasureid5;
		}

		/**
		 * 武将身上5号位置的灵丸id
		 */	
		public function set treasureid5(value:String):void
		{
			_treasureid5 = value;
		}

		/**
		 * 武将身上6号位置的灵丸id
		 */	
		public function get treasureid6():String
		{
			return _treasureid6;
		}

		/**
		 * 武将身上6号位置的灵丸id
		 */	
		public function set treasureid6(value:String):void
		{
			_treasureid6 = value;
		}

		/**
		 * 武将身上7号位置的灵丸id
		 */	
		public function get treasureid7():String
		{
			return _treasureid7;
		}

		/**
		 * 武将身上7号位置的灵丸id
		 */	
		public function set treasureid7(value:String):void
		{
			_treasureid7 = value;
		}

		/**
		 * 武将身上8号位置的灵丸id
		 */	
		public function get treasureid8():String
		{
			return _treasureid8;
		}

		/**
		 * 武将身上8号位置的灵丸id
		 */	
		public function set treasureid8(value:String):void
		{
			_treasureid8 = value;
		}
	}
}