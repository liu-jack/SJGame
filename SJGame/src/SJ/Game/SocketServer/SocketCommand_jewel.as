package SJ.Game.SocketServer
{
	import SJ.Common.Constants.ConstNetCommand;
	
	import engine_starling.utils.Logger;

	/**
	 * 道具
	 * @author sangxu
	 * 
	 */
	public class SocketCommand_jewel
	{
		public function SocketCommand_jewel()
		{
			
		}
		/**
		 * 获取宝石镶嵌数据
		 */
		public static function getInlayInfo():void
		{
			SocketManager.o.call(ConstNetCommand.CS_JEWEL_GETINLAYINFO);
		}
		
		/**
		 * 宝石镶嵌开启孔 - 向服务器端请求
		 * @param heroId 	武将id
		 * @param position 	装备位
		 * @param isaddrate 是否增加概率
		 * 
		 */		
		public static function openJewelInlay(heroId:String, position:int, index:int):void
		{
			SocketManager.o.call(ConstNetCommand.CS_JEWEL_OPENJEWELINLAY, heroId, position, index);
		}
		
		/**
		 * 宝石镶嵌
		 * @param heroId	武将id
		 * @param position	装备位
		 * @param index		宝石孔索引
		 * @param jewelId	宝石唯一id
		 * 
		 */		
		public static function inlayJewel(heroId:String, position:int, index:int, jewelId:String):void
		{
			SocketManager.o.call(ConstNetCommand.CS_JEWEL_INLAYJEWEL, heroId, position, index, jewelId);
		}
		
		/**
		 * 宝石摘取
		 * @param heroId	武将id
		 * @param position	装备位
		 * @param index		宝石孔索引
		 * 
		 */		
		public static function removejewel(heroId:String, position:int, index:int):void
		{
			SocketManager.o.call(ConstNetCommand.CS_JEWEL_REMOVEJEWEL, heroId, position, index);
		}
	}
}