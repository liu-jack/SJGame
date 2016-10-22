package SJ.Game.data
{
	import engine_starling.data.SDataBase;
	
	/**
	 * 玩家角色信息
	 * @author longtao
	 * 
	 */
	public class CJDataOfUser extends SDataBase
	{
		public function CJDataOfUser()
		{
			super("CJDataOfUser");
		}
		
		/**
		 * 平台ID
		 */
		public function get platformID():uint
		{
			return getData("platformID");
		}

		/**
		 * @private
		 */
		public function set platformID(value:uint):void
		{
			setData("platformID",value);
		}
		
		/**
		 * 服务器ID
		 */
		public function get serverID():uint
		{
			return getData("serverID");
		}
		
		/**
		 * @private
		 */
		public function set serverID(value:uint):void
		{
			setData("serverID",value);
		}
		
		/**
		 * 武将ID
		 */
		public function get heroID():uint
		{
			return getData("heroID");
		}

		/**
		 * @private
		 */
		public function set heroID(value:uint):void
		{
			setData("heroID",value);
		}
		
		/**
		 * 角色名称
		 */
		public function get name():String
		{
			return getData("name");
		}
		
		/**
		 * @private
		 */
		public function set name(value:String):void
		{
			setData("name",value);
		}
		
		/**
		 * 银两数量
		 */
		public function get silver():Number
		{
			return getData("silver");
		}

		/**
		 * @private
		 */
		public function set silver(value:Number):void
		{
			setData("silver",value);
		}
		
		/**
		 * 金币数量
		 */
		public function get gold():Number
		{
			return getData("gold");
		}
		
		/**
		 * @private
		 */
		public function set gold(value:Number):void
		{
			setData("gold",value);
		}
		
		/**
		 * 礼券数量
		 */
		public function get giftTicket():Number
		{
			return getData("giftTicket");
		}
		
		/**
		 * @private
		 */
		public function set giftTicket(value:Number):void
		{
			setData("giftTicket",value);
		}
		
		/**
		 * vip等级
		 */
		public function get vipLevel():Number
		{
			return getData("vipLevel");
		}
		
		/**
		 * @private
		 */
		public function set vipLevel(value:Number):void
		{
			setData("vipLevel",value);
		}
		
		/**
		 * 主角技能
		 */
		public function get skill():Number
		{
			return getData("skill");
		}
		
		/**
		 * @private
		 */
		public function set skill(value:Number):void
		{
			setData("skill",value);
		}

	}
}