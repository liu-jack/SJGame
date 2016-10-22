package SJ.Game.data
{
	import SJ.Common.Constants.ConstBag;
	import SJ.Common.Constants.ConstItem;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketCommand_item;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.event.CJSocketEvent;
	
	import engine_starling.data.SDataBaseRemoteData;
	
	import flash.utils.Dictionary;
	
	import lib.engine.utils.functions.Assert;
	
	import starling.events.Event;
	
	/**
	 * 获取武将穿戴中的装备完整信息
	 * @author longtao
	 * 
	 */
	public class CJDataOfEquipmentbar extends SDataBaseRemoteData
	{
		/** 装备栏{itemid:CJDataOfItem} **/
		private var _dataObj:Object = new Object;
		/** 装备孔{itemid:CJDataOfItem} */
		private var _dataHole:Dictionary = new Dictionary();
		private static var _o:CJDataOfEquipmentbar;
		
		public function CJDataOfEquipmentbar()
		{
			super("CJDataOfEquipmentbar");
			
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _onloadcomplete);
		}
		
		public static function get o():CJDataOfEquipmentbar
		{
			if(_o == null)
			{
				_o = new CJDataOfEquipmentbar();
			}
			return _o;
		}
		
		override protected function _onloadFromRemote(params:Object=null):void
		{
			// TODO Auto Generated method stub
			SocketCommand_item.get_equipmentbar();
			super._onloadFromRemote(params);
		}
		
		/**
		 * 获取装备栏道具
		 * @param itemid
		 * @return 
		 * 
		 */
		public function getEquipbarItem(itemid:String):CJDataOfItem
		{
			return _dataObj[itemid] as CJDataOfItem;
		}
		
		/**
		 * 获取孔中道具
		 * @param itemid 道具id
		 * @return 
		 * 
		 */		
		public function getHoleItem(itemId:String):CJDataOfItem
		{
			var itemData:CJDataOfItem = _dataHole[itemId];
			Assert(itemData != null, "Equipment hole data is null, itemId is:" + itemId);
			return itemData;
		}
		
		/**
		 * 获取所有孔中道具
		 * @return 
		 * 
		 */		
		public function getHoleItemDic():Dictionary
		{
			return this._dataHole;
		}
		
		/**
		 * 重新设置数据
		 * @param rtnData
		 */
		public function resetData(rtnData:Object):void
		{
			_resetData(rtnData);
		}
		
		private function _resetData(rtnData:Object):void
		{
			Assert( rtnData!=null, "CJDataOfEquipmentbar._resetData rtnData==null" );
			var retItems:Object = rtnData;
			for each(var retItem:Object in retItems)
			{
				var itemData : CJDataOfItem = new CJDataOfItem();
				for ( var key:String in  retItem)
				{
					itemData.setData(key, retItem[key]);
				}
				if (itemData.containertype == ConstBag.CONTAINER_TYPE_EQUIP)
				{
					// 装备栏
					_dataObj[ String(itemData.itemid) ] = itemData;
				}
				else if(itemData.containertype == ConstBag.CONTAINER_TYPE_HOLE)
				{
					// 装备孔中的宝石
					_dataHole[String(itemData.itemid)] = itemData;
				}
			}
			
			// 派发事件，重新获取数据完成
			_notifyDataChange("",null,null);
		}
		
		/**
		 * 加载武将数据
		 * @param e
		 * 
		 */
		protected function _onloadcomplete(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() != ConstNetCommand.CS_ITEM_EQUIPMENTBAR)
				return;
			if(message.retcode == 0)
			{
				var rtnObject:Object = message.retparams[0];
				_resetData(rtnObject);
				this._dataIsEmpty = true;
				this._onloadFromRemoteComplete();
				
				// 派发事件穿脱装备使用	add by longtao
				CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_CHANGE_EQUIP_COMPLETE, false, {command:ConstNetCommand.CS_ITEM_EQUIPMENTBAR});
				// add by longtao end
			}
		}
	}
}