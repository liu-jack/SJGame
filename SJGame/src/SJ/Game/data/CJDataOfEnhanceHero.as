package SJ.Game.data
{
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketCommand_enhance;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.event.CJSocketEvent;
	
	import engine_starling.data.SDataBase;
	import engine_starling.data.SDataBaseRemoteData;
	
	import starling.events.Event;
	
	/**
	 * 装备强化数据
	 * @author sangxu
	 * 
	 */
	public class CJDataOfEnhanceHero extends SDataBase
	{
		public function CJDataOfEnhanceHero()
		{
			super("CJDataOfEnhanceHero");
		}
		
		/** 武将id */
		public function set heroid(value:String):void
		{
			setData("heroid", value);
		}
		public function get heroid():String
		{
			return getData( "heroid" );
		}
		
		/** 用户id */
		public function set userid(value:String):void
		{
			setData("userid", value);
		}
		public function get userid():String
		{
			return getData( "userid" );
		}
		
		/** 武器 */
		public function set weapon(value:uint):void
		{
			setData("weapon", value);
		}
		public function get weapon():uint
		{
			return getData( "weapon" );
		}
		
		/** 头盔 */
		public function set head(value:uint):void
		{
			setData("head", value);
		}
		public function get head():uint
		{
			return getData( "head" );
		}
		
		/** 披风 */
		public function set cloak(value:uint):void
		{
			setData("cloak", value);
		}
		public function get cloak():uint
		{
			return getData( "cloak" );
		}
		
		/** 铠甲 */
		public function set armour(value:uint):void
		{
			setData("armour", value);
		}
		public function get armour():uint
		{
			return getData( "armour" );
		}
		/** 鞋子 */
		public function set shoe(value:uint):void
		{
			setData("shoe", value);
		}
		public function get shoe():uint
		{
			return getData( "shoe" );
		}
		
		/** 腰带 */
		public function set belt(value:uint):void
		{
			setData("belt", value);
		}
		public function get belt():uint
		{
			return getData( "belt" );
		}
	}
}