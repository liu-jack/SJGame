package SJ.Game.SocketServer
{
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.event.CJEvent;
	import SJ.Game.task.CJTaskEvent;
	import SJ.Game.task.CJTaskEventHandler;
	
	import engine_starling.utils.Logger;

	/**
	 * 道具
	 * @author sangxu
	 * 
	 */
	public class SocketCommand_item
	{
		public function SocketCommand_item()
		{
			
		}
		/**
		 * 登录操作 
		 * @param username 用户名
		 * @param password 密码 需要外部MD5加密
		 * 
		 */
		public static function getBag():void
		{
			SocketManager.o.call(ConstNetCommand.CS_ITEM_GET_BAG, '1');
		}
		/**
		 * 装备铸造-向服务器端请求
		 * @param itemtemplateid 要铸造装备的id
		 * @param moneytype 铸造装备需要花费的钱币类型
		 * 
		 */		
		public static function itemMake(itemtemplateid:int, moneytype:int):void
		{
			SocketManager.o.call(ConstNetCommand.CS_ITEM_MAKE, itemtemplateid, moneytype);
		}
		
		/**
		 * 扩充道具容器容量
		 * @param containerType	容器类型
		 * @param openCount		扩容格子数量
		 * 
		 */		
		public static function openBagGrid(containerType:int, openCount:int):void
		{
			SocketManager.o.call(ConstNetCommand.CS_OPEN_BAG_GRID, containerType, openCount);
		}
		
		/**
		 * 使用道具
		 * @param containerType	道具所在容器类型
		 * @param itemId		道具id
		 * @return 
		 * 
		 */		
		public static function useItem(containerType:int, itemId:String, count:int):void
		{
			SocketManager.o.call(ConstNetCommand.CS_ITEM_USE_ITEM, containerType, itemId, count);
		}
		
		/**
		 * 出售道具
		 * @param containerType	道具所在容器类型
		 * @param itemId		道具id
		 * @return 
		 * 
		 */		
		public static function sellItem(containerType:int, itemId:String):void
		{
			SocketManager.o.call(ConstNetCommand.CS_ITEM_SELL_ITEM, containerType, itemId);
		}
		
		/**
		 * 获取武将装备格子中的道具信息
		 * add by longtao
		 */
		public static function get_equipmentbar():void
		{
			SocketManager.o.call(ConstNetCommand.CS_ITEM_EQUIPMENTBAR);
		}
		/**
		 * 宝石合成-向服务器端请求
		 * @param srcItemId：被合成宝石的唯一id
		 * @param srcJewelId：被合成宝石的模板id
		 * @param jewelnum：合成后宝石的数量
		 */		
		public static function jewelCombine(srcJewelId:int, desJewelNum:int):void
		{
			SocketManager.o.call(ConstNetCommand.CS_JEWEL_COMBINE_COMBINE, srcJewelId, desJewelNum);
		}

		
		/**
		 * 宝石一键合成-向服务器端请求
		 * @param jewellevel：选择合成宝石的级别
		 */		
		public static function jewelCombineOneKey(jewellevel:int):void
		{
			SocketManager.o.call(ConstNetCommand.CS_JEWEL_COMBINE_COMBINE_ONE_KEY, jewellevel);
		}
		
		/**
		 * 使用随机宝箱
		 * @param itemTmplId: 宝箱道具模板id
		 * 
		 */		
		public static function useRandomBox(itemTmplId:int):void
		{
			SocketManager.o.call(ConstNetCommand.CS_ITEM_USERANDOMBOX, itemTmplId);
		}
	}
}