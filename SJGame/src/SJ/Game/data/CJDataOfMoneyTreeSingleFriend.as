package SJ.Game.data
{
	import engine_starling.data.SDataBase;
	
	/**
	 * 单个好友的摇钱树数据
	 * @author sangxu
	 * 
	 */
	public class CJDataOfMoneyTreeSingleFriend extends SDataBase
	{
		public function CJDataOfMoneyTreeSingleFriend()
		{
			super("CJDataOfMoneyTreeSingleFriend");
		}
		
		/** setter */
		public function set canfeed(value:Boolean):void
		{
			this.setData("canfeed", value);
		}
		public function set isonline(value:Boolean):void
		{
			this.setData("isonline", value);
		}
		public function set name(value:String):void
		{
			this.setData("name", value);
		}
		public function set treelevel(value:int):void
		{
			this.setData("treelevel", value);
		}
		public function set uid(value:String):void
		{
			this.setData("uid", value);
		}
		public function set camp(value:int):void
		{
			this.setData("camp", value);
		}
		public function set exp(value:int):void
		{
			this.setData("exp", value);
		}
		
		/** getter */
		public function get canfeed():Boolean
		{
			return this.getData("canfeed");
		}
		public function get isonline():Boolean
		{
			return this.getData("isonline");
		}
		public function get name():String
		{
			return this.getData("name");
		}
		public function get treelevel():int
		{
			return this.getData("treelevel");
		}
		public function get uid():String
		{
			return this.getData("uid");
		}
		public function get camp():int
		{
			return this.getData("camp");
		}
		public function get exp():int
		{
			return this.getData("exp");
		}
		
		
	}
}