package SJ.Game.data
{
	import SJ.Common.Constants.ConstBag;
	import SJ.Common.Constants.ConstNetCommand;
	import SJ.Game.SocketServer.SocketCommand_item;
	import SJ.Game.SocketServer.SocketManager;
	import SJ.Game.SocketServer.SocketMessage;
	import SJ.Game.data.config.CJDataOfItemProperty;
	import SJ.Game.data.json.Json_item_setting;
	import SJ.Game.event.CJEvent;
	import SJ.Game.event.CJEventDispatcher;
	import SJ.Game.event.CJSocketEvent;
	import SJ.Game.task.CJTaskEvent;
	import SJ.Game.task.CJTaskEventHandler;
	
	import engine_starling.data.SDataBaseRemoteData;
	import engine_starling.utils.SStringUtils;
	
	import starling.events.Event;
	
	/**
	 * 背包数据
	 * @author longtao
	 * 
	 */
	public class CJDataOfBag extends SDataBaseRemoteData
	{
		public function CJDataOfBag()
		{
			super("CJDataOfBag");
			_init()
		}
		/** 需要排序 */
		private var _needSort:Boolean = true;
		
		/**
		 * 背包中道具容量
		 */
		private var _count:uint;
		
		
		
		private function _init():void
		{
			_count = 0;
			this.bagCount = 0;
			this.bagMaxCount = 0;
			SocketManager.o.addEventListener(CJSocketEvent.SocketEventData, _onloadBag);
		}
		
		/**
		 * 加载背包数据
		 * @param e
		 * 
		 */
		protected function _onloadBag(e:Event):void
		{
			var message:SocketMessage = e.data as SocketMessage;
			if(message.getCommand() != ConstNetCommand.CS_ITEM_GET_BAG)
			{
				return;
			}
			if(message.retcode == 0)
			{
				var rtnObject:Object = message.retparams;
				_initBagData(rtnObject);
				this._needSort = true;
				this._dataIsEmpty = true;
				this._onloadFromRemoteComplete();
				
				// 派发事件穿脱装备使用	add by longtao
				CJEventDispatcher.o.dispatchEventWith(CJEvent.EVENT_CHANGE_EQUIP_COMPLETE, false, {command:ConstNetCommand.CS_ITEM_GET_BAG});
				// add by longtao end
				
				CJTaskEventHandler.o.dispatchEventWith(CJEvent.EVENT_TASK_ACTION_EXECUTED , false , {"type":CJTaskEvent.TASK_EVENT_COLLECTNORMAL});
			}
			
		}
		
		private function _initBagData(obj:Object):void
		{
			this.bagCount = parseInt(obj.bagcount);
			var retItems:Array = obj.items as Array;
			var tempArray:Array = new Array();
			
			var itemData:CJDataOfItem;
			for each(var retItem:Object in retItems)
			{
				itemData = new CJDataOfItem();
				for ( var key:String in retItem)
				{
					itemData.setData(key, retItem[key]);
				}
				tempArray.push(itemData);
			}
			this.itemsArray = tempArray;
		}
		
		/**
		 * 背包排序
		 * @return 
		 * 
		 */		
		public function _bagDataWithSort():void
		{
			if (true == _needSort)
			{
				this.itemsArray.sort(this.sort);
				this._needSort = false;
			}
			
//			return this.itemsArray;
		}
		
		/**
		 * 道具排序, 道具类型正序排列, 同类型道具按品质倒序
		 * @param itemA
		 * @param itemB
		 * @return 
		 * 
		 */		
		public function sort(itemA:CJDataOfItem, itemB:CJDataOfItem):int  
		{
			var tmplA:Json_item_setting = CJDataOfItemProperty.o.getTemplate(itemA.templateid);
			var tmplB:Json_item_setting = CJDataOfItemProperty.o.getTemplate(itemB.templateid);
			// 类型, 正序
			var typeRst:int = this._compare(parseInt(tmplA.type), parseInt(tmplB.type));
			if (0 != typeRst)
			{
				return typeRst;
			}
			// 子类型, 正序
			var subTypeRst:int = this._compare(parseInt(tmplA.subtype), parseInt(tmplB.subtype));
			if (0 != subTypeRst)
			{
				return subTypeRst;
			}
			// 比较品质, 倒序
			var qualityRst:int = this._compare(parseInt(tmplA.quality), parseInt(tmplB.quality), true);
			if (0 != qualityRst)
			{
				return qualityRst;
			}
			// 等级, 倒序
			var levelRst:int = this._compare(parseInt(tmplA.level), parseInt(tmplB.level), true);
			if (0 != levelRst)
			{
				return levelRst;
			}
			// 模板id, 正序
			var tmplIdRst:int = this._compare(parseInt(tmplA.id), parseInt(tmplB.id));
			if (0 != tmplIdRst)
			{
				return tmplIdRst;
			}
			// 数量, 倒序
			var countRst:int = this._compare(itemA.count, itemB.count, true);
			return countRst;
		}
		
		/**
		 * 比较两个数字, 返回1、-1、0
		 * @param valueA
		 * @param valueB
		 * @param reverse	反转与否, 默认为false
		 * @return reverse为false(默认)时A>B返回1, A<B返回-1, A==B返回0
		 *         reverse为true时A<B返回1, A>B返回-1, A==B返回0
		 * 
		 */		
		private function _compare(valueA:int, valueB:int, reverse:Boolean = false):int
		{
			var rvsValue:int = !reverse ? 1 : -1;
			if (valueA > valueB)
			{
				return 1 * rvsValue;
			}
			else if(valueA < valueB)
			{
				return -1 * rvsValue;
			}
			else
			{
				return 0;
			}
		}
		
		/**
		 * 根据道具唯一id获取背包内道具
		 * @param itemId	道具唯一id
		 * @return 
		 * 
		 */		
		public function getItemByItemId(itemId:String):CJDataOfItem
		{
			for each(var itemData:CJDataOfItem in this.itemsArray)
			{
				if (itemData.itemid == itemId)
				{
					return itemData;
				}
			}
			return null;
		}
		
		/**
		 * 获取背包内指定道具模板id的道具数量总和
		 * @param itemTemplateId	道具模板id
		 * @return 
		 * 
		 */		
		public function getItemCountByTmplId(itemTemplateId:int):int
		{
			var count:int = 0;
			for each(var itemData:CJDataOfItem in this.itemsArray)
			{
				if (itemData.templateid == itemTemplateId)
				{
					count += itemData.count;				
				}
			}
			return count;
		}
		
		

		/**
		 * 当前背包道具数量
		 */
//		public function get count():uint
//		{
//			return _count;
//		}
		
		/**
		 * 背包已解锁容量
		 * @param bagCount
		 * 
		 */
		public function set bagCount(bagCount:int):void
		{
			super.setData("bagcount", bagCount);
		}
		
		/**
		 * 背包已解锁容量
		 * @return 
		 * 
		 */		
		public function get bagCount():int
		{
			return super.getData("bagcount");
		}
		
		/**
		 * 背包最大容量
		 * @param bagMaxCount
		 * 
		 */		
		public function set bagMaxCount(bagMaxCount:int):void
		{
			super.setData("bagMaxCount", bagMaxCount);
		}
		
		/**
		 * 背包最大容量
		 * @param bagMaxCount
		 * 
		 */		
		public function get bagMaxCount():int
		{
			return super.getData("bagMaxCount");
		}

		/**
		 * 背包中道具
		 * @param items
		 * 
		 */
		public function set itemsArray(items : Array):void
		{
			this.setData("items", items);
		}

		/**
		 * 背包中道具
		 * 
		 */
		public function get itemsArray() : Array
		{
			return this.getData("items");
		}

		
		
//		public function addItem( item:CJDataOfItem ):void
//		{
//			if ( null == item )
//				return;
//			
//			if (this.getData(item.guid) == null)
//			{
//				_count++;
//			}
//			super.setData(item.guid, item);
//		}
		
		public function deleteItem(itemId:String):void
		{
			if (null==itemId || SStringUtils.isEmpty(itemId))
			{
				return;
			}
			super.delData(itemId);
			_count--;
		}
		
		
		
//		public function getItem( guid:String ):CJDataOfItem
//		{
//			return getData( guid );
//		}

		
//		/**
//		 * 覆写设置数据
//		 * @param key	道具唯一id
//		 * @param value
//		 */
//		override public function setData(key:String, value:*):void
//		{
//			addItem( value );
//		}
		
//		
//		/**
//		 * 覆写删除数据
//		 * @param key	道具唯一ID
//		 * 
//		 */
//		override public function delData(key:String):void
//		{
//			deleteItem(key);
//		}
		
		
		override protected function _onloadFromRemote(params:Object=null):void
		{
			SocketCommand_item.getBag();
			super._onloadFromRemote(params);
		}

		/**
		 * 根据容器类型获取对应类型的道具
		 */
		public function getItemsByContainerType(type : int) : Array
		{
			this._bagDataWithSort();
			var allItems : Array = this.itemsArray;
			if (ConstBag.BAG_TYPE_ALL == type)
			{
				return allItems;
			}
			
			var typeTemp : int = 0;
			var retArray : Array = new Array();
			var templateSetting : CJDataOfItemProperty = CJDataOfItemProperty.o;
			for each (var item : CJDataOfItem in allItems)
			{
				var itemTemplate : Json_item_setting = templateSetting.getTemplate(item.templateid);
				typeTemp = itemTemplate.type;
				if (typeTemp == type)
				{
					retArray.push(item);
				}
			}
			return retArray;
		}
		/**
		 * 根据道具模板id返回背包中第一个此模板的道具
		 * @param itemTemplateId	道具模板id
		 * @return 背包中不存在此道具则返回null
		 * 
		 */		
		public function getFirstItemByTemplateId(itemTemplateId:int):CJDataOfItem
		{
			var allItems : Array = this.itemsArray;
			var templateSetting : CJDataOfItemProperty = CJDataOfItemProperty.o;
			for each (var item:CJDataOfItem in allItems)
			{
				var itemTemplate : Json_item_setting = templateSetting.getTemplate(item.templateid);
				if (itemTemplateId == int(itemTemplate.id))
				{
					return item;
				}
			}
			return null;
		}
		
		/**
		 * 背包是否已满
		 * @return 
		 * 
		 */		
		public function isBagFull():Boolean
		{
			return (bagCount - itemsArray.length) > 0 ? false : true;
		}
		
		/**
		 * 获取背包空格数量
		 * @return 
		 * 
		 */		
		public function getBagEmptyGridCount():int
		{
			return (bagCount - itemsArray.length);
		}
		
		/**
		 * 
		 * @param type
		 * @return 
		 * 
		 */		
		public function getItemsByItemType(type:int):Array
		{
			this._bagDataWithSort();
			var allItems : Array = this.itemsArray;
//			if (ConstBag.BAG_TYPE_ALL == type)
//			{
//				return allItems;
//			}
			
			var typeTemp : int = 0;
			var tempArray : Array = new Array();
			var retArray : Array = new Array();
			var templateSetting : CJDataOfItemProperty = CJDataOfItemProperty.o;
			var hasItem:Boolean = false;
			var itemTemplate : Json_item_setting;
			var arrayTmpl:Json_item_setting;
			
			for each (var item : CJDataOfItem in allItems)
			{
				itemTemplate = templateSetting.getTemplate(item.templateid);
				typeTemp = itemTemplate.type;
				if (typeTemp == type)
				{
					hasItem = false;
					for each (var arrayItem:CJDataOfItem in tempArray)
					{
						arrayTmpl = templateSetting.getTemplate(arrayItem.templateid);
						if (arrayTmpl.id == itemTemplate.id)
						{
							arrayItem.count += item.count;
							hasItem = true;
							break;
						}
					}
					if (!hasItem)
					{
						var itemNew:CJDataOfItem = new CJDataOfItem();
						itemNew.templateid = item.templateid;
						itemNew.count = item.count;
						itemNew.containertype = item.containertype;
						tempArray.push(itemNew);
					}
				}
			}
			for each (var tempItem:CJDataOfItem in tempArray)
			{
				if (tempItem.count > 1)
				{
					retArray.push(tempItem);
				}
			}
			
			return retArray;
		}
	}
}