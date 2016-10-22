package SJ.Game.data
{
	import flash.utils.Dictionary;
	
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketCommand_mall;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.event.CJSocketEvent;
	
	import engine_starling.data.SDataBaseRemoteData;
	
	import starling.events.Event;
	
	/**
	 * 商城数据
	 * @author sangxu
	 * 
	 */
	public class CJDataOfMall extends SDataBaseRemoteData
	{
		public function CJDataOfMall()
		{
			super("CJDataOfMall");
			_init();
		}
		
		private var _type:int;
//		private var _arrayItems:Array;
		private var _dicItems:Dictionary;
		
		/** 全部道具. key - type; value - array(CJDataOfMallItem) */
		private var _dicAllItem:Dictionary;
		
		private static var _o:CJDataOfMall;
		public static function get o():CJDataOfMall
		{
			if(_o == null)
			{
				_o = new CJDataOfMall();
			}
			return _o;
		}
		
		private function _init():void
		{
			this._type = -1;
//			this._arrayItems = new Array();
			this._dicItems = new Dictionary();
			
			this._dicAllItem = new Dictionary();
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _onloadMall);
		}
		
		/**
		 * 商城类型
		 * @return 
		 * 
		 */		
		public function get type():int
		{
			return this._type;
		}
		/**
		 * 商城道具
		 * @return 
		 * 
		 */		
//		public function get arrayItems():Array
//		{
//			return this._arrayItems;
//		}
		
		/**
		 * 根据商城类型获取对应商城道具
		 * @param pageType
		 * @return 
		 * 
		 */		
		public function getItemsByType(pageType:String):Array
		{
			return this._dicAllItem[pageType];
		}
		/**
		 * 加载商城数据
		 * @param e
		 * 
		 */
		protected function _onloadMall(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() == ConstNetCommand.CS_MALL_GETITEMS)
			{
//				if(message.retcode == 0)
//				{
//					var rtnObject:Object = message.retparams;
//					this._type = int(rtnObject.type);
//					var items:Array = rtnObject.items;
//					var itemTemp:CJDataOfMallItem;
//					this._arrayItems = new Array();
//					for each (var obj:Object in items)
//					{
//						itemTemp = new CJDataOfMallItem();
//						itemTemp.loadData(obj);
//						this._arrayItems.push(itemTemp);
//						this._dicItems[String(itemTemp.id)] = itemTemp;
//					}
//					
//					this._arrayItems.sort(this._sort);
//					
//					this._dataIsEmpty = true;
//					this._onloadFromRemoteComplete();
//				}
			}
			else if (message.getCommand() == ConstNetCommand.CS_MALL_GETALLITEMS)
			{
				//获取商城全部道具
				var retParams:Object = message.retparams;
				
				var arrItem:Array = retParams.items;
				
				_dicAllItem = new Dictionary();
				var arrItemTemp:Array;
				var mallItemTemp:CJDataOfMallItem;
				var itemType:String;
				for each (var objTemp:Object in arrItem)
				{
					mallItemTemp = new CJDataOfMallItem();
					mallItemTemp.loadData(objTemp);
					itemType = String(mallItemTemp.type);
					arrItemTemp = _dicAllItem[itemType];
					if (null == arrItemTemp)
					{
						arrItemTemp = new Array();
					}
					arrItemTemp.push(mallItemTemp);
					this._dicAllItem[itemType] = arrItemTemp;
					this._dicItems[String(mallItemTemp.id)] = mallItemTemp;
				}
				
				for each(var arrTemp:Array in this._dicAllItem)
				{
					arrTemp.sort(this._sort);
				}
				
				this._dataIsEmpty = true;
				this._onloadFromRemoteComplete();
			}
			
		}
		
		/**
		 * 道具排序, 道具类型正序排列, 同类型道具按品质倒序
		 * @param itemA
		 * @param itemB
		 * @return 
		 * 
		 */		
		private function _sort(itemA:CJDataOfMallItem, itemB:CJDataOfMallItem):int  
		{
			if (itemA.id > itemB.id)
			{
				return 1;
			}
			return -1;
		}
		
		/**
		 * 根据商城道具id获取商城道具数据
		 * @param itemId	商城出售道具id
		 * @return 
		 * 
		 */		
		public function getMallItemById(itemId:String):CJDataOfMallItem
		{
			return this._dicItems[itemId];
		}
		
		override protected function _onloadFromRemote(params:Object=null):void
		{
			SocketCommand_mall.getAllItems();
//			var itemType:int;
//			if (params == null)
//			{
//				itemType = ConstMall.MALL_ITEM_TYPE_HOT;
//			}
//			else
//			{
//				itemType = int(params);
//			}
//			SocketCommand_mall.getItems(itemType);
			super._onloadFromRemote(params);
		}
	}
}