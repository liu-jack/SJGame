package SJ.Game.data
{
	import engine_starling.data.SDataBase;
	
	/**
	 * 游戏中的共用帐号数据
	 * @author longtao
	 * 
	 */
	public class CJDataOfAccounts extends SDataBase
	{
		public function CJDataOfAccounts()
		{
			super("CJDataOfAccounts");
			loadFromCache();
		}
		
		override public function clearAll():void
		{
			userID = "";
			accounts = "";
			password = "";
		}

		/**
		 * 玩家帐号ID
		 */
		public function get userID():String
		{
			return getData("userID");
		}

		/**
		 * @private
		 */
		public function set userID(value:String):void
		{
			setData("userID",value);
		}

		/**
		 * 帐号字串
		 */
		public function get accounts():String
		{
			return getData("accounts");
		}

		/**
		 * @private
		 */
		public function set accounts(value:String):void
		{
			setData("accounts",value);
		}
		
		/**
		 * 密码字串
		 */
		public function get password():String
		{
			return getData("password");
		}
		
		/**
		 * @private
		 */
		public function set password(value:String):void
		{
			setData("password",value);
		}

		/**
		 * 是否播放了首场战斗 
		 */
		public function get fristbattleplayed():Boolean
		{
			return getData("fristbattleplayed",true);
		}

		/**
		 * @private
		 */
		public function set fristbattleplayed(value:Boolean):void
		{
			return setData("fristbattleplayed",value);
		}

		

	}
}