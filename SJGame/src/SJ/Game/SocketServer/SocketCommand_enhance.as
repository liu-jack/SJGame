package SJ.Game.SocketServer
{
	import SJ.Common.Constants.ConstNetCommand;
	
	import engine_starling.utils.Logger;

	/**
	 * 道具
	 * @author sangxu
	 * 
	 */
	public class SocketCommand_enhance
	{
		public function SocketCommand_enhance()
		{
			
		}
		/**
		 * 获取装备强化信息
		 * 
		 */
		public static function getEquipEnhanceInfo():void
		{
			SocketManager.o.call(ConstNetCommand.CS_ENHANCE_GETEQUIPENHANCEINFO);
		}
		/**
		 * 装备强化 - 向服务器端请求
		 * @param heroId	武将id
		 * @param position 	装备位
		 * @param isaddrate 是否增加概率, 默认为未选中
		 * 
		 */		
		public static function enhanceEquip(heroId:String, position:int, isaddrate:Boolean = false):void
		{
			SocketManager.o.call(ConstNetCommand.CS_ENHANCE_ENHANCEEQUIP, heroId, position, isaddrate);
		}
		/**
		 * 装备强化10次 - 向服务器端请求
		 * @param heroId	武将id
		 * @param position 	装备位
		 * @param isaddrate 是否增加概率, 默认为未选中
		 * 
		 */		
		public static function enhanceEquipTen(heroId:String, position:int, isaddrate:Boolean = false):void
		{
			SocketManager.o.call(ConstNetCommand.CS_ENHANCE_ENHANCEEQUIPTEN, heroId, position, isaddrate);
		}
		
	}
}