package SJ.Game.SocketServer
{
	import SJ.Common.Constants.ConstNetCommand;

	/**
	 * 武将网络操作
	 * @author longtao
	 * 
	 */
	public class SocketCommand_hero
	{
		public function SocketCommand_hero()
		{
		}
		
		/**
		 * 获取武将列表
		 */
		public static function get_heros():void
		{
			SocketManager.o.callunlock(ConstNetCommand.CS_HERO_GET_HEROS);
		}
		
		/**
		 * 获取武将列表
		 */
		public static function get_heros_and_callback(fun:Function=null):void
		{
			SocketManager.o.callwithRtn(ConstNetCommand.CS_HERO_GET_HEROS, fun);
		}
		
		/**
		 * 雇佣武将
		 * @param templateid
		 * 
		 */
		public static function employ_hero(templateid:uint):void
		{
			SocketManager.o.call(ConstNetCommand.CS_HERO_EMPLOY_HERO, templateid);
		}
		
		/**
		 * 解雇武将
		 * @param heroid 武将id
		 * 
		 */
		public static function fire_hero(heroid:String):void
		{
			SocketManager.o.call(ConstNetCommand.CS_HERO_FIRE_HERO, heroid);
		}
		
		/**
		 * 获取所有武将穿着中的装备信息
		 */
		public static function get_puton_equip():void
		{
			SocketManager.o.call(ConstNetCommand.CS_HERO_GET_PUTON_EQUIP);
		}
		
		/**
		 * 武将穿戴装备
		 * @param heroid 武将id
		 * @param itemid 装备id
		 */
		public static function puton_equip(heroid:String, itemid:String):void
		{
			SocketManager.o.call(ConstNetCommand.CS_HERO_PUTON_EQUIP, heroid, itemid);
		}
		
		/**
		 * 武将脱下装备
		 * @param heroid 武将id
		 * @param itemid 装备id
		 */
		public static function takeoff_equip(heroid:String, itemid:String):void
		{
			SocketManager.o.call(ConstNetCommand.CS_HERO_TAKEOFF_EQUIP, heroid, itemid);
		}
		
		/**
		 * 获取武将展示信息
		 * 可查看其他玩家信息
		 * @param userid	请求的角色id
		 */
		public static function getShowInfo(userid:String):void
		{
			SocketManager.o.call(ConstNetCommand.CS_HERO_GET_SHOW_INFO, userid);
		}
		
		/**
		 * 获取单个武将展示所有信息
		 * @param userid
		 * 
		 */
		public static function getHeroProp(heroid:String,callback:Function = null):void
		{
			SocketManager.o.callwithRtn(ConstNetCommand.CS_HERO_GET_HERO_PROP,callback,false, heroid);
		}
		
		/**
		 * 获取所有武将展示所有信息
		 */
		public static function getHeroListProp():void
		{
			SocketManager.o.call(ConstNetCommand.CS_HERO_GET_HERO_LIST_PROP);
		}
	}
}